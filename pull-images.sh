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

declare -A PULLED_IMAGES   # set
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

  until "${pull_cmd[@]}"; do
    tries=$((tries+1))
    if (( tries > max )); then
      echo "❌ 拉取失败: $img"
      return 1
    fi
    echo "⏳ 重试($tries/$max): $img"
    sleep 2
  done
  echo "✅ 拉取成功: $img"
}

# 并发控制：最多 PARALLEL 个后台任务
run_with_limit() {
  local -a items=("$@")
  local running=0
  for it in "${items[@]}"; do
    _pull_one "$it" &
    running=$((running+1))
    if (( running >= PARALLEL )); then
      wait -n || true
      running=$((running-1))
    fi
  done
  wait || true
}

# 执行拉取
echo "⬇️ 正在并行拉取镜像（并发=$PARALLEL）..."
run_with_limit "${IMAGES[@]}"

# 保存镜像
if [[ "$SAVE_IMAGES" == true ]]; then
  echo "💾 保存镜像为单个压缩包..."
  
  # 生成压缩包名称（基于当前时间和目录名）
  timestamp=$(date +"%Y%m%d_%H%M%S")
  dir_name=$(basename "$SCAN_DIR")
  archive_name="images_${dir_name}_${timestamp}.tar.gz"
  out_dir="${SAVE_DIR:-$SCAN_DIR}"
  mkdir -p "$out_dir"
  archive_path="$out_dir/$archive_name"
  
  echo "📦 创建镜像压缩包: $archive_path"
  
  # 创建临时目录来存放所有镜像的 tar 文件
  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' EXIT
  
  # 保存所有镜像到临时目录
  for img in "${IMAGES[@]}"; do
    # 生成安全文件名
    tar_name="$(echo "$img" | tr '/:' '__').tar"
    temp_tar="$temp_dir/$tar_name"
    echo "   - 保存: $img -> $temp_tar"
    docker save "$img" > "$temp_tar"
  done
  
  # 将所有 tar 文件打包成一个压缩包
  echo "📦 打包所有镜像到: $archive_path"
  cd "$temp_dir"
  tar -czf "$archive_path" *.tar
  
  # 显示压缩包信息
  archive_size=$(du -h "$archive_path" | cut -f1)
  echo "✅ 镜像压缩包创建完成: $archive_path (大小: $archive_size)"
  echo "📋 包含镜像数量: ${#IMAGES[@]}"
fi

# 汇总
echo
echo "📋 镜像清单汇总 (${#IMAGES[@]}):"
for img in "${IMAGES[@]}"; do
  echo "$img"
done

echo "✅ 完成！"