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
EOF
}

SAVE_IMAGES=false
SCAN_DIR="$(pwd)"
SAVE_DIR=""
PARALLEL=4
RETRIES=2
PLATFORM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    -d|--dir) SCAN_DIR="$2"; shift 2 ;;
    -s|--save) SAVE_IMAGES=true; shift ;;
    --save-dir) SAVE_DIR="$2"; shift 2 ;;
    -p|--parallel) PARALLEL="$2"; shift 2 ;;
    -r|--retries) RETRIES="$2"; shift 2 ;;
    --platform) PLATFORM="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; show_help; exit 1 ;;
  esac
done

# 找 compose 文件
mapfile -d '' COMPOSE_FILES < <(find "$SCAN_DIR" -type f \( -name 'docker-compose.yml' -o -name 'docker-compose.yaml' \) -print0)
if [[ ${#COMPOSE_FILES[@]} -eq 0 ]]; then
  echo "❌ 未找到 docker-compose 文件！"
  exit 1
fi

declare -A PULLED_IMAGES   # set
declare -A ALL_IMAGES_SET  # set of all images

echo "🔍 正在解析镜像清单（包含全部 profiles）..."

get_images_for_file() {
  local file="$1"
  local dir
  dir=$(dirname "$file")
  pushd "$dir" > /dev/null

  # 基础（无 profile）镜像
  if imgs=$(docker compose -f "$(basename "$file")" config --images 2>/dev/null | sort -u); then
    printf '%s\n' $imgs
  fi

  # 枚举 profiles 并合并
  if profiles=$(docker compose -f "$(basename "$file")" config --profiles 2>/dev/null | awk 'NF'); then
    while read -r prof; do
      [[ -z "$prof" ]] && continue
      if imgs_p=$(docker compose -f "$(basename "$file")" --profile "$prof" config --images 2>/dev/null | sort -u); then
        printf '%s\n' $imgs_p
      fi
    done <<< "$profiles"
  fi

  popd > /dev/null
}

# 收集所有镜像
for file in "${COMPOSE_FILES[@]}"; do
  while IFS= read -r img; do
    [[ -z "$img" ]] && continue
    ALL_IMAGES_SET["$img"]=1
  done < <(get_images_for_file "$file")

  echo "📄 合并清单: $(realpath "$file")"
done

# 去重列表并过滤非法项
IMAGES=( )
for k in "${!ALL_IMAGES_SET[@]}"; do IMAGES+=("$k"); done
# 过滤规则：
# - 不包含空格或等号
# - 不含未解析变量 $ { }
# - 只允许 [a-z0-9./:_-] 字符（仓库名需小写）
# - 形如 repo/name 或 repo/name:tag
mapfile -t IMAGES < <(printf '%s\n' "${IMAGES[@]}" \
  | grep -Ev '(^$|\s|=|\$|\{|\})' \
  | grep -E '^[a-z0-9._-]+(/[a-z0-9._-]+)+(:[a-zA-Z0-9._-]+)?$' \
  | sort -u)

if [[ ${#IMAGES[@]} -eq 0 ]]; then
  echo "ℹ️ 未解析到任何有效镜像（可能存在未解析变量或非法格式）"
  exit 0
fi

echo "📦 共计镜像: ${#IMAGES[@]}"

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
  echo "💾 保存镜像为 tar.gz..."
  for img in "${IMAGES[@]}"; do
    # 生成安全文件名
    tar_name="$(echo "$img" | tr '/:' '__').tar.gz"
    out_dir="${SAVE_DIR:-$SCAN_DIR}"
    mkdir -p "$out_dir"
    echo "   - 保存: $img -> $out_dir/$tar_name"
    docker save "$img" | gzip > "$out_dir/$tar_name"
  done
fi

# 汇总
echo
echo "📋 镜像清单汇总 (${#IMAGES[@]}):"
for img in "${IMAGES[@]}"; do
  echo "$img"
done

echo "✅ 完成！"