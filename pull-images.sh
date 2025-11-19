#!/bin/bash
# pull-images.sh - 拉取/保存项目所有 docker-compose 镜像（覆盖全部 profiles）
# 功能：
# - 递归扫描 docker-compose.yml|yaml
# - 自动枚举 profiles，并合并所有 profile 下的镜像清单
# - 去重、并行拉取、失败重试（内建并发控制，无 xargs 依赖）
# - 可选保存镜像为 tar.gz 到指定目录
# - 可选指定平台（arm64/amd64 等）

set -euo pipefail

show_help() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -h, --help              显示帮助
  -d, --dir DIR           指定扫描目录（默认当前目录）
  -s, --save              保存镜像为 tar.gz（默认不保存）
  --save-dir DIR          保存目录（默认使用各 compose 目录）
  -p, --parallel N        并行拉取并发数（默认 4）
  -r, --retries N         拉取失败重试次数（默认 2）
  --platform PLAT         指定平台传给 docker pull（如 linux/amd64）
  --service PATTERN       只处理包含指定关键字的服务（支持多个，用逗号分隔）
  --exclude PATTERN       排除包含指定关键字的服务（支持多个，用逗号分隔）
  --folder PATTERN        只处理指定文件夹名称下的 docker-compose（支持多个，用逗号分隔）
  --exclude-folder PATTERN 排除指定文件夹名称下的 docker-compose（支持多个，用逗号分隔）
  --list-services         列出所有可用的服务名称后退出
  --list-folders          列出所有包含 docker-compose 的文件夹后退出
  --dry-run               只显示将要拉取的镜像，不实际拉取
EOF
}

SAVE_IMAGES=false
SCAN_DIR="$(pwd)"
SAVE_DIR=""
PARALLEL=4
RETRIES=2
PLATFORM=""
SERVICE_PATTERNS=""
EXCLUDE_PATTERNS=""
FOLDER_PATTERNS=""
EXCLUDE_FOLDER_PATTERNS=""
LIST_SERVICES=false
LIST_FOLDERS=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    -d|--dir) SCAN_DIR="$2"; shift 2 ;;
    -s|--save) SAVE_IMAGES=true; shift ;;
    --save-dir) SAVE_DIR="$2"; shift 2 ;;
    -p|--parallel) PARALLEL="$2"; shift 2 ;;
    -r|--retries) RETRIES="$2"; shift 2 ;;
    --platform) PLATFORM="$2"; shift 2 ;;
    --service) SERVICE_PATTERNS="$2"; shift 2 ;;
    --exclude) EXCLUDE_PATTERNS="$2"; shift 2 ;;
    --folder) FOLDER_PATTERNS="$2"; shift 2 ;;
    --exclude-folder) EXCLUDE_FOLDER_PATTERNS="$2"; shift 2 ;;
    --list-services) LIST_SERVICES=true; shift ;;
    --list-folders) LIST_FOLDERS=true; shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
done

# 找 compose 文件
mapfile -d '' COMPOSE_FILES < <(find "$SCAN_DIR" -type f \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' \) -print0)
if [[ ${#COMPOSE_FILES[@]} -eq 0 ]]; then
  echo "❌ 未找到 docker-compose 文件！"
  exit 1
fi

# 文件夹过滤函数
filter_by_folder() {
  local file="$1"
  local full_path
  full_path=$(realpath "$(dirname "$file")")
  local relative_path
  relative_path=$(realpath --relative-to="$SCAN_DIR" "$(dirname "$file")")
  
  # 如果没有指定文件夹过滤，则包含所有文件
  if [[ -z "$FOLDER_PATTERNS" && -z "$EXCLUDE_FOLDER_PATTERNS" ]]; then
    return 0
  fi
  
  # 检查排除模式
  if [[ -n "$EXCLUDE_FOLDER_PATTERNS" ]]; then
    IFS=',' read -ra EXCLUDE_FOLDER_ARRAY <<< "$EXCLUDE_FOLDER_PATTERNS"
    for pattern in "${EXCLUDE_FOLDER_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs) # 去除空格
      if [[ "$relative_path" =~ $pattern ]] || [[ "$full_path" =~ $pattern ]]; then
        return 1  # 排除
      fi
    done
  fi
  
  # 检查包含模式
  if [[ -n "$FOLDER_PATTERNS" ]]; then
    IFS=',' read -ra FOLDER_ARRAY <<< "$FOLDER_PATTERNS"
    for pattern in "${FOLDER_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs) # 去除空格
      if [[ "$relative_path" =~ $pattern ]] || [[ "$full_path" =~ $pattern ]]; then
        return 0  # 包含
      fi
    done
    return 1  # 不匹配任何包含模式
  fi
  
  return 0
}

# 应用文件夹过滤
if [[ -n "$FOLDER_PATTERNS" || -n "$EXCLUDE_FOLDER_PATTERNS" ]]; then
  echo "🔍 根据文件夹名称过滤 docker-compose 文件..."
  FILTERED_COMPOSE_FILES=( )
  for file in "${COMPOSE_FILES[@]}"; do
    if filter_by_folder "$file"; then
      FILTERED_COMPOSE_FILES+=("$file")
    fi
  done
  COMPOSE_FILES=("${FILTERED_COMPOSE_FILES[@]}")
  
  if [[ ${#COMPOSE_FILES[@]} -eq 0 ]]; then
    echo "❌ 过滤后没有找到符合条件的 docker-compose 文件！"
    exit 1
  fi
  
  echo "📁 过滤后剩余文件: ${#COMPOSE_FILES[@]} 个"
fi

declare -A PULLED_IMAGES   # set of successfully pulled images
declare -A ALL_IMAGES_SET  # set of all images
declare -A ALL_SERVICES    # set of all service names

echo "🔍 正在解析镜像清单（包含全部 profiles）..."

get_images_for_file() {
  local file="$1"
  local dir
  dir=$(dirname "$file")
  pushd "$dir" > /dev/null

  # 基础（无 profile）镜像和服务
  if imgs=$(docker compose -f "$(basename "$file")" config --images 2>/dev/null | sort -u); then
    printf '%s\n' $imgs
  fi
  if services=$(docker compose -f "$(basename "$file")" config --services 2>/dev/null | sort -u); then
    printf '%s\n' $services
  fi

  # 枚举 profiles 并合并
  if profiles=$(docker compose -f "$(basename "$file")" config --profiles 2>/dev/null | awk 'NF'); then
    while read -r prof; do
      [[ -z "$prof" ]] && continue
      if imgs_p=$(docker compose -f "$(basename "$file")" --profile "$prof" config --images 2>/dev/null | sort -u); then
        printf '%s\n' $imgs_p
      fi
      if services_p=$(docker compose -f "$(basename "$file")" --profile "$prof" config --services 2>/dev/null | sort -u); then
        printf '%s\n' $services_p
      fi
    done <<< "$profiles"
  fi

  popd > /dev/null
}

# 收集所有镜像和服务
for file in "${COMPOSE_FILES[@]}"; do
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    # 判断是镜像还是服务名（镜像通常包含 / 或 :）
    if [[ "$item" =~ [/:] ]]; then
      ALL_IMAGES_SET["$item"]=1
    else
      ALL_SERVICES["$item"]=1
    fi
  done < <(get_images_for_file "$file")

  echo "📄 合并清单: $(realpath "$file")"
done

# 如果只是列出服务，则输出后退出
if [[ "$LIST_SERVICES" == true ]]; then
  echo "📋 可用服务列表:"
  for service in "${!ALL_SERVICES[@]}"; do
    echo "  - $service"
  done | sort
  exit 0
fi

# 如果只是列出文件夹，则输出后退出
if [[ "$LIST_FOLDERS" == true ]]; then
  echo "📁 包含 docker-compose 的文件夹列表:"
  declare -A FOLDER_SET
  for file in "${COMPOSE_FILES[@]}"; do
    FOLDER_SET["$(dirname "$file")"]=1
  done
  for folder in "${!FOLDER_SET[@]}"; do
    echo "  - $(realpath "$folder")"
  done | sort
  exit 0
fi

# 服务过滤函数 - 通过镜像名匹配服务
filter_by_service() {
  local img="$1"
  
  # 如果没有指定服务过滤，则包含所有镜像
  if [[ -z "$SERVICE_PATTERNS" && -z "$EXCLUDE_PATTERNS" ]]; then
    return 0
  fi
  
  # 从镜像名中提取可能的服务名（去掉域名和标签）
  local img_name="${img##*/}"  # 去掉域名部分
  img_name="${img_name%%:*}"   # 去掉标签部分
  
  # 检查排除模式
  if [[ -n "$EXCLUDE_PATTERNS" ]]; then
    IFS=',' read -ra EXCLUDE_ARRAY <<< "$EXCLUDE_PATTERNS"
    for pattern in "${EXCLUDE_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs) # 去除空格
      if [[ "$img_name" =~ $pattern ]] || [[ "$img" =~ $pattern ]]; then
        return 1  # 排除
      fi
    done
  fi
  
  # 检查包含模式
  if [[ -n "$SERVICE_PATTERNS" ]]; then
    IFS=',' read -ra SERVICE_ARRAY <<< "$SERVICE_PATTERNS"
    for pattern in "${SERVICE_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs) # 去除空格
      if [[ "$img_name" =~ $pattern ]] || [[ "$img" =~ $pattern ]]; then
        return 0  # 包含
      fi
    done
    return 1  # 不匹配任何包含模式
  fi
  
  return 0
}

# 去重列表并过滤非法项
IMAGES=( )
for k in "${!ALL_IMAGES_SET[@]}"; do IMAGES+=("$k"); done

# 基础过滤规则：
# - 不包含空格或等号
# - 不含未解析变量 $ { }
# - 只允许 [a-z0-9./:_-] 字符（仓库名需小写）
# - 形如 repo/name 或 repo/name:tag
mapfile -t IMAGES < <(printf '%s\n' "${IMAGES[@]}" \
  | grep -Ev '(^$|\s|=|\$|\{|\})' \
  | grep -E '^[a-z0-9._-]+(/[a-z0-9._-]+)+(:[a-zA-Z0-9._-]+)?$' \
  | sort -u)

# 服务过滤
if [[ -n "$SERVICE_PATTERNS" || -n "$EXCLUDE_PATTERNS" ]]; then
  echo "🔍 根据服务关键字过滤镜像..."
  FILTERED_IMAGES=( )
  for img in "${IMAGES[@]}"; do
    if filter_by_service "$img"; then
      FILTERED_IMAGES+=("$img")
    fi
  done
  IMAGES=("${FILTERED_IMAGES[@]}")
fi

if [[ ${#IMAGES[@]} -eq 0 ]]; then
  echo "ℹ️ 未解析到任何有效镜像（可能存在未解析变量或非法格式）"
  exit 0
fi

echo "📦 共计镜像: ${#IMAGES[@]}"

# 如果是 dry-run，只显示镜像列表后退出
if [[ "$DRY_RUN" == true ]]; then
  echo "🔍 将要拉取的镜像列表:"
  for img in "${IMAGES[@]}"; do
    echo "  - $img"
  done
  echo "✅ Dry-run 完成！"
  exit 0
fi

# 拉取函数（带重试与平台）
_pull_one() {
  local img="$1"
  local tries=0
  local max="$RETRIES"
  local pull_cmd=(docker pull)
  if [[ -n "$PLATFORM" ]]; then
    pull_cmd+=("--platform" "$PLATFORM")
  fi
  pull_cmd+=("$img")

  # 捕获错误输出
  local error_output
  error_output=$("${pull_cmd[@]}" 2>&1)
  local pull_status=$?

  until [[ $pull_status -eq 0 ]]; do
    tries=$((tries+1))
    if (( tries > max )); then
      echo "❌ 拉取失败: $img"
      # 检查是否是认证问题
      if echo "$error_output" | grep -qi "unauthorized\|authentication required\|login"; then
        # 提取仓库地址
        local registry
        if [[ "$img" =~ ^([^/]+)/ ]]; then
          registry="${BASH_REMATCH[1]}"
          if [[ "$registry" != "docker.io" ]] && [[ "$registry" != "registry-1.docker.io" ]]; then
            echo "   💡 提示: 请先登录私有仓库: docker login $registry"
          else
            echo "   💡 提示: 该镜像可能需要登录 Docker Hub 或私有仓库"
          fi
        fi
      elif echo "$error_output" | grep -qi "not found\|manifest unknown"; then
        echo "   💡 提示: 镜像不存在或标签错误，请检查镜像名称和版本"
      fi
      return 1
    fi
    echo "⏳ 重试($tries/$max): $img"
    sleep 2
    error_output=$("${pull_cmd[@]}" 2>&1)
    pull_status=$?
  done
  echo "✅ 拉取成功: $img"
  # 记录成功拉取的镜像（追加操作通常是原子的）
  echo "$img" >> "$SUCCESS_FILE"
}

# 并发控制：最多 PARALLEL 个后台任务
run_with_limit() {
  local -a items=("$@")
  local -a pids=()
  local -A pid_to_img  # 映射 PID 到镜像名称
  local total=${#items[@]}
  local idx=0
  local running=0
  
  # 启动初始批次
  while (( idx < total && running < PARALLEL )); do
    _pull_one "${items[$idx]}" &
    local pid=$!
    pids+=($pid)
    pid_to_img[$pid]="${items[$idx]}"
    running=$((running + 1))
    idx=$((idx + 1))
  done
  
  # 处理剩余任务
  local iteration=0
  while (( idx < total || running > 0 )); do
    iteration=$((iteration + 1))
    
    # 检查哪些进程已完成
    local new_pids=()
    local completed_this_round=0
    for pid in "${pids[@]}"; do
      if kill -0 "$pid" 2>/dev/null; then
        # 进程仍在运行
        new_pids+=($pid)
      else
        # 进程已结束，等待它（清理僵尸进程）
        wait "$pid" 2>/dev/null || true
        unset 'pid_to_img[$pid]'  # 清理映射
        running=$((running - 1))
        completed_this_round=$((completed_this_round + 1))
      fi
    done
    pids=("${new_pids[@]}")
    
    # 启动新任务
    while (( running < PARALLEL && idx < total )); do
      _pull_one "${items[$idx]}" &
      local pid=$!
      pids+=($pid)
      pid_to_img[$pid]="${items[$idx]}"
      running=$((running + 1))
      idx=$((idx + 1))
    done
    
    # 如果还有任务在运行，稍等一下再检查
    if (( running > 0 )); then
      # 每10次迭代显示一次进度（避免输出过多）
      if (( iteration % 10 == 0 )); then
        local remaining=$((total - idx))
        local completed=$((total - remaining - running))
        echo "⏳ 等待中... (运行中: $running, 已完成: $completed, 待启动: $remaining)"
        # 显示仍在运行的进程信息（用于调试）
        if (( iteration % 30 == 0 && ${#pids[@]} > 0 )); then
          echo "   🔍 正在拉取的镜像:"
          for pid in "${pids[@]}"; do
            if [[ -v pid_to_img[$pid] ]]; then
              echo "      - ${pid_to_img[$pid]} (PID: $pid)"
            else
              echo "      - 未知镜像 (PID: $pid)"
            fi
          done
        fi
      fi
      sleep 0.5
    elif (( idx >= total && running == 0 )); then
      # 所有任务都完成了
      break
    fi
    
    # 防止无限循环（安全措施）
    if (( iteration > 10000 )); then
      echo "⚠️  警告: 检测到可能的死循环，强制退出"
      break
    fi
  done
  
  echo "✅ 所有拉取任务完成"
}

# 检查私有仓库登录状态
check_registry_auth() {
  local img="$1"
  # 提取仓库地址（格式：registry/namespace/image:tag）
  local registry
  if [[ "$img" =~ ^([^/]+)/ ]]; then
    registry="${BASH_REMATCH[1]}"
    # 跳过 Docker Hub 和本地镜像
    if [[ "$registry" == "docker.io" ]] || [[ "$registry" == "registry-1.docker.io" ]] || [[ "$registry" == "localhost" ]]; then
      return 0
    fi
    # 检查是否已登录该仓库
    if ! docker info 2>/dev/null | grep -q "$registry" && ! grep -q "\"$registry\"" ~/.docker/config.json 2>/dev/null; then
      echo "⚠️  警告: 未检测到 $registry 的登录信息，拉取可能失败"
      echo "   💡 建议先执行: docker login $registry"
      return 1
    fi
  fi
  return 0
}

# 创建临时文件记录成功拉取的镜像
SUCCESS_FILE=$(mktemp)
TEMP_DIR=""
cleanup() {
  [[ -n "$SUCCESS_FILE" ]] && rm -f "$SUCCESS_FILE"
  [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# 检查所有镜像的仓库登录状态
echo "🔐 检查私有仓库登录状态..."
declare -A CHECKED_REGISTRIES
for img in "${IMAGES[@]}"; do
  if [[ "$img" =~ ^([^/]+)/ ]]; then
    registry="${BASH_REMATCH[1]}"
    # 使用 -v 检查键是否存在，避免 unbound variable 错误
    if [[ ! -v CHECKED_REGISTRIES[$registry] ]]; then
      check_registry_auth "$img" || true
      CHECKED_REGISTRIES[$registry]=1
    fi
  fi
done

# 执行拉取
echo "⬇️ 正在并行拉取镜像（并发=$PARALLEL）..."
run_with_limit "${IMAGES[@]}"

# 保存镜像
if [[ "$SAVE_IMAGES" == true ]]; then
  echo "💾 保存镜像为单个压缩包..."
  
  # 等待一下确保所有写入完成
  sleep 1
  
  # 读取成功拉取的镜像列表
  if [[ ! -s "$SUCCESS_FILE" ]]; then
    echo "⚠️  没有成功拉取的镜像，跳过保存"
    echo "   (SUCCESS_FILE: $SUCCESS_FILE, 大小: $(stat -c%s "$SUCCESS_FILE" 2>/dev/null || echo 0) 字节)"
  else
    echo "📋 成功拉取的镜像数量: $(wc -l < "$SUCCESS_FILE" | tr -d ' ')"
    # 生成压缩包名称（基于当前时间和目录名）
    timestamp=$(date +"%Y%m%d_%H%M%S")
    dir_name=$(basename "$SCAN_DIR")
    archive_name="images_${dir_name}_${timestamp}.tar.gz"
    out_dir="${SAVE_DIR:-$SCAN_DIR}"
    mkdir -p "$out_dir"
    archive_path="$out_dir/$archive_name"
    
    echo "📦 创建镜像压缩包: $archive_path"
    
    # 创建临时目录来存放所有镜像的 tar 文件
    TEMP_DIR=$(mktemp -d)
    
    # 保存成功拉取的镜像到临时目录
    saved_count=0
    total_to_save=$(wc -l < "$SUCCESS_FILE" | tr -d ' ')
    current=0
    while IFS= read -r img; do
      [[ -z "$img" ]] && continue
      current=$((current + 1))
      
      # 再次检查镜像是否存在（双重保险）
      if ! docker image inspect "$img" >/dev/null 2>&1; then
        echo "⚠️  [$current/$total_to_save] 跳过不存在的镜像: $img"
        continue
      fi
      
      # 生成安全文件名
      tar_name="$(echo "$img" | tr '/:' '__').tar"
      temp_tar="$TEMP_DIR/$tar_name"
      echo "💾 [$current/$total_to_save] 正在保存: $img"
      if docker save "$img" > "$temp_tar" 2>&1; then
        saved_count=$((saved_count + 1))
        file_size=$(du -h "$temp_tar" 2>/dev/null | cut -f1 || echo "未知")
        echo "   ✅ 保存成功 ($file_size)"
      else
        echo "   ❌ 保存失败: $img"
        rm -f "$temp_tar"
      fi
    done < "$SUCCESS_FILE"
    
    if [[ $saved_count -eq 0 ]]; then
      echo "⚠️  没有成功保存任何镜像"
      rm -rf "$TEMP_DIR"
      TEMP_DIR=""
    else
      # 将所有 tar 文件打包成一个压缩包
      echo "📦 打包所有镜像到: $archive_path"
      cd "$TEMP_DIR"
      tar -czf "$archive_path" *.tar 2>/dev/null || {
        echo "❌ 打包失败"
        exit 1
      }
      
      # 显示压缩包信息
      archive_size=$(du -h "$archive_path" | cut -f1)
      echo "✅ 镜像压缩包创建完成: $archive_path (大小: $archive_size)"
      echo "📋 包含镜像数量: $saved_count"
    fi
  fi
fi

# 汇总
echo
echo "📋 镜像清单汇总 (${#IMAGES[@]}):"
for img in "${IMAGES[@]}"; do
  echo "$img"
done

echo "✅ 完成！"