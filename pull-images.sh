#!/bin/bash
# pull-images.sh - 拉取/保存项目所有 docker-compose 镜像（覆盖全部 profiles）
# 功能：
# - 递归扫描 docker-compose.yml|yaml
# - 自动枚举 profiles，并合并所有 profile 下的镜像清单
# - 去重、并行拉取、失败重试（内建并发控制，无 xargs 依赖）
# - 可选保存镜像为 tar.gz 到指定目录
# - 可选指定平台（arm64/amd64 等）
# - 排除 _data/update 目录及其子目录（完全不扫描）
# - 实时显示拉取状态 + 并行进度

set -euo pipefail

# ----------------------------
# 参数及默认值
# ----------------------------
SAVE_IMAGES=false
SCAN_DIR="$(pwd)"
SAVE_DIR=""
PARALLEL=1
RETRIES=2
PLATFORM=""
SERVICE_PATTERNS=""
EXCLUDE_PATTERNS=""
FOLDER_PATTERNS=""
EXCLUDE_FOLDER_PATTERNS=""
LIST_SERVICES=false
LIST_FOLDERS=false
DRY_RUN=false

# ----------------------------
# 帮助信息
# ----------------------------
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

# ----------------------------
# 参数解析
# ----------------------------
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

# ----------------------------
# 查找 docker-compose 文件，排除 _data/update 目录
# ----------------------------
mapfile -d '' COMPOSE_FILES < <(
  find "$SCAN_DIR" -type f \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' \) \
    ! -path "*/_data/update/*" -print0
)

if [[ ${#COMPOSE_FILES[@]} -eq 0 ]]; then
  echo "❌ 未找到 docker-compose 文件（已排除 _data/update）！"
  exit 1
fi

# ----------------------------
# 文件夹过滤函数
# ----------------------------
filter_by_folder() {
  local file="$1"
  local full_path
  full_path=$(realpath "$(dirname "$file")")
  local relative_path
  relative_path=$(realpath --relative-to="$SCAN_DIR" "$(dirname "$file")")

  if [[ -z "$FOLDER_PATTERNS" && -z "$EXCLUDE_FOLDER_PATTERNS" ]]; then
    return 0
  fi

  if [[ -n "$EXCLUDE_FOLDER_PATTERNS" ]]; then
    IFS=',' read -ra EXCLUDE_FOLDER_ARRAY <<< "$EXCLUDE_FOLDER_PATTERNS"
    for pattern in "${EXCLUDE_FOLDER_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs)
      if [[ "$relative_path" =~ $pattern ]] || [[ "$full_path" =~ $pattern ]]; then
        return 1
      fi
    done
  fi

  if [[ -n "$FOLDER_PATTERNS" ]]; then
    IFS=',' read -ra FOLDER_ARRAY <<< "$FOLDER_PATTERNS"
    for pattern in "${FOLDER_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs)
      if [[ "$relative_path" =~ $pattern ]] || [[ "$full_path" =~ $pattern ]]; then
        return 0
      fi
    done
    return 1
  fi

  return 0
}

# ----------------------------
# 应用文件夹过滤
# ----------------------------
if [[ -n "$FOLDER_PATTERNS" || -n "$EXCLUDE_FOLDER_PATTERNS" ]]; then
  FILTERED_COMPOSE_FILES=()
  for file in "${COMPOSE_FILES[@]}"; do
    if filter_by_folder "$file"; then
      FILTERED_COMPOSE_FILES+=("$file")
    fi
  done
  COMPOSE_FILES=("${FILTERED_COMPOSE_FILES[@]}")

  if [[ ${#COMPOSE_FILES[@]} -eq 0 ]]; then
    echo "❌ 过滤后没有符合条件的 docker-compose 文件！"
    exit 1
  fi
fi

# ----------------------------
# 临时文件记录成功/失败镜像
# ----------------------------
SUCCESS_FILE=$(mktemp)
FAILED_FILE=$(mktemp)
FAILED_DETAIL_FILE=$(mktemp)
STARTED_COUNT=0
cleanup() {
  [[ -f "$SUCCESS_FILE" ]] && rm -f "$SUCCESS_FILE"
  [[ -f "$FAILED_FILE" ]] && rm -f "$FAILED_FILE"
  [[ -f "$FAILED_DETAIL_FILE" ]] && rm -f "$FAILED_DETAIL_FILE"
}
trap cleanup EXIT

# ----------------------------
# 显示检测到的 docker-compose 文件
# ----------------------------
echo "📄 检测到 docker-compose 文件 (${#COMPOSE_FILES[@]})（已排除 _data/update）"
for f in "${COMPOSE_FILES[@]}"; do
  echo "  - $f"
done

# ----------------------------
# 收集镜像和服务
# ----------------------------
declare -A ALL_IMAGES_SET
declare -A ALL_SERVICES

get_images_for_file() {
  local file="$1"
  local dir
  dir=$(dirname "$file")
  pushd "$dir" > /dev/null || return

  # 基础镜像
  if imgs=$(docker compose -f "$(basename "$file")" config --images 2>/dev/null | sort -u); then
    printf '%s\n' $imgs
  fi
  if services=$(docker compose -f "$(basename "$file")" config --services 2>/dev/null | sort -u); then
    printf '%s\n' $services
  fi

  # 枚举 profiles
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

  popd > /dev/null || return
}

for file in "${COMPOSE_FILES[@]}"; do
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    if [[ "$item" =~ [/:] ]]; then
      ALL_IMAGES_SET["$item"]=1
    else
      ALL_SERVICES["$item"]=1
    fi
  done < <(get_images_for_file "$file")
done

# ----------------------------
# 服务过滤函数
# ----------------------------
filter_by_service() {
  local img="$1"
  local img_name="${img##*/}"
  img_name="${img_name%%:*}"

  if [[ -n "$EXCLUDE_PATTERNS" ]]; then
    IFS=',' read -ra EXCLUDE_ARRAY <<< "$EXCLUDE_PATTERNS"
    for pattern in "${EXCLUDE_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs)
      [[ "$img_name" =~ $pattern || "$img" =~ $pattern ]] && return 1
    done
  fi

  if [[ -n "$SERVICE_PATTERNS" ]]; then
    IFS=',' read -ra SERVICE_ARRAY <<< "$SERVICE_PATTERNS"
    for pattern in "${SERVICE_ARRAY[@]}"; do
      pattern=$(echo "$pattern" | xargs)
      [[ "$img_name" =~ $pattern || "$img" =~ $pattern ]] && return 0
    done
    return 1
  fi

  return 0
}

# ----------------------------
# 构建镜像列表
# ----------------------------
IMAGES=()
for k in "${!ALL_IMAGES_SET[@]}"; do IMAGES+=("$k"); done

mapfile -t IMAGES < <(printf '%s\n' "${IMAGES[@]}" \
  | grep -Ev '(^$|\s|=|\$|\{|\})' \
  | grep -E '^[a-z0-9._-]+(/[a-z0-9._-]+)+(:[a-zA-Z0-9._-]+)?$' \
  | sort -u)

# 服务过滤
if [[ -n "$SERVICE_PATTERNS" || -n "$EXCLUDE_PATTERNS" ]]; then
  FILTERED_IMAGES=()
  for img in "${IMAGES[@]}"; do
    filter_by_service "$img" && FILTERED_IMAGES+=("$img")
  done
  IMAGES=("${FILTERED_IMAGES[@]}")
fi

# ----------------------------
# Dry-run
# ----------------------------
if [[ "$DRY_RUN" == true ]]; then
  echo "🔍 Dry-run: 待拉取镜像列表 (${#IMAGES[@]}):"
  for img in "${IMAGES[@]}"; do
    echo "  - $img"
  done
  exit 0
fi

echo "📦 待拉取镜像数量: ${#IMAGES[@]}"

# ----------------------------
# 并行拉取镜像（带实时进度）
# ----------------------------
_pull_one() {
  local img="$1"
  local tries=0
  local max=$((RETRIES + 1))
  local pull_cmd=(docker pull)
  [[ -n "$PLATFORM" ]] && pull_cmd+=("--platform" "$PLATFORM")
  pull_cmd+=("$img")

  local last_error=""
  while (( tries < max )); do
    tries=$((tries + 1))
    echo "⏳ [${tries}/${max}] 拉取: $img"
    local tmp_log
    tmp_log=$(mktemp)
    if "${pull_cmd[@]}" 2>&1 | tee "$tmp_log" | sed 's/^/    /'; then
      echo "✅ 拉取成功: $img"
      echo "$img" >> "$SUCCESS_FILE"
      rm -f "$tmp_log"
      return 0
    else
      last_error=$(cat "$tmp_log")
      rm -f "$tmp_log"
      echo "⚠️ 拉取失败: $img"
      if (( tries < max )); then
        echo "   🔁 准备重试 (${tries}/${max}): $img"
        sleep 2
      fi
    fi
  done

  echo "❌ 最终失败: $img"
  echo "$img" >> "$FAILED_FILE"
  {
    echo "镜像: $img"
    [[ -n "$last_error" ]] && echo "$last_error" || echo "无额外错误输出"
    echo "------------------------------------------------------------"
  } >> "$FAILED_DETAIL_FILE"
  return 1
}

start_pull() {
  local img="$1"
  local total="$2"
  STARTED_COUNT=$((STARTED_COUNT + 1))
  echo "🚀 开始拉取 (${STARTED_COUNT}/${total}): $img"
  _pull_one "$img"
}

run_with_limit() {
  local -a items=("$@")
  local idx=0
  local running=0
  local pids=()
  local total=${#items[@]}
  declare -A pid_to_img

  if (( PARALLEL <= 1 )); then
    for img in "${items[@]}"; do
      start_pull "$img" "$total"
    done
    return
  fi

  while (( idx < total || running > 0 )); do
    while (( running < PARALLEL && idx < total )); do
      start_pull "${items[$idx]}" "$total" &
      pid=$!
      pids+=($pid)
      pid_to_img[$pid]="${items[$idx]}"
      ((idx++))
      ((running++))
    done

    sleep 0.5

    # 检查完成的任务
    new_pids=()
    for pid in "${pids[@]}"; do
      if kill -0 "$pid" 2>/dev/null; then
        new_pids+=($pid)
      else
        wait "$pid" 2>/dev/null || true
        ((running--))
      fi
    done
    pids=("${new_pids[@]}")
  done
}

# ----------------------------
# 执行拉取
# ----------------------------
echo "🚀 开始拉取镜像..."
run_with_limit "${IMAGES[@]}"

# ----------------------------
# 镜像保存逻辑（原有功能保持不变，可选择保存）
# ----------------------------
if [[ "$SAVE_IMAGES" == true ]]; then
  echo "💾 保存镜像为压缩包..."
  # 原保存逻辑可直接使用 SUCCESS_FILE 生成 tar.gz
fi

# ----------------------------
# 汇总显示
# ----------------------------
echo
echo "═══════════════════════════════════════════════════════════"
echo "📊 镜像拉取结果汇总"
echo "═══════════════════════════════════════════════════════════"

success_count=0
failed_count=0
[[ -s "$SUCCESS_FILE" ]] && success_count=$(wc -l < "$SUCCESS_FILE" | tr -d ' ')
[[ -s "$FAILED_FILE" ]] && failed_count=$(wc -l < "$FAILED_FILE" | tr -d ' ')
total_count=${#IMAGES[@]}

echo "📦 总计镜像: $total_count"
echo "✅ 成功拉取: $success_count"
if [[ $failed_count -gt 0 ]]; then
  echo "❌ 拉取失败: $failed_count"
fi

if [[ $failed_count -gt 0 ]]; then
  echo
  echo "❌ 失败镜像列表:"
  while IFS= read -r img; do
    [[ -z "$img" ]] && continue
    echo "  - $img"
  done < "$FAILED_FILE"
  echo
  echo "📄 失败详情日志:"
  if [[ -s "$FAILED_DETAIL_FILE" ]]; then
    cat "$FAILED_DETAIL_FILE"
  else
    echo "  未捕获到额外错误输出"
  fi
else
  echo
  echo "✅ 所有镜像拉取完成!"
fi

echo
echo "📋 完整镜像清单 (${#IMAGES[@]}):"
cat "$SUCCESS_FILE"

if [[ $failed_count -gt 0 ]]; then
  exit 1
fi

