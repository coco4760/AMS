#!/bin/bash
# load-images.sh - 从镜像压缩包导入 Docker 镜像
# 功能：
# - 解压镜像压缩包
# - 批量导入 Docker 镜像
# - 支持并行导入
# - 显示导入进度和结果

set -euo pipefail

show_help() {
  cat <<EOF
Usage: $0 [OPTIONS] ARCHIVE_PATH

Options:
  -h, --help              显示帮助
  -p, --parallel N        并行导入并发数（默认 2）
  -r, --retries N         导入失败重试次数（默认 1）
  -d, --dry-run           只显示将要导入的镜像，不实际导入
  -v, --verbose           显示详细输出
  --extract-dir DIR       指定解压目录（默认使用临时目录）

Arguments:
  ARCHIVE_PATH            镜像压缩包路径（.tar.gz 文件）

Examples:
  $0 images_storage_20241201_143022.tar.gz
  $0 -p 4 -r 2 images_services_20241201_143022.tar.gz
  $0 --dry-run images_storage_20241201_143022.tar.gz
EOF
}

PARALLEL=2
RETRIES=1
DRY_RUN=false
VERBOSE=false
EXTRACT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    -p|--parallel) PARALLEL="$2"; shift 2 ;;
    -r|--retries) RETRIES="$2"; shift 2 ;;
    -d|--dry-run) DRY_RUN=true; shift ;;
    -v|--verbose) VERBOSE=true; shift ;;
    --extract-dir) EXTRACT_DIR="$2"; shift 2 ;;
    -*|--*) echo "Unknown option: $1"; show_help; exit 1 ;;
    *) break ;;
  esac
done

# 检查参数
if [[ $# -eq 0 ]]; then
  echo "❌ 错误：请指定镜像压缩包路径"
  show_help
  exit 1
fi

ARCHIVE_PATH="$1"

# 检查文件是否存在
if [[ ! -f "$ARCHIVE_PATH" ]]; then
  echo "❌ 错误：镜像压缩包不存在: $ARCHIVE_PATH"
  exit 1
fi

# 检查文件扩展名
if [[ ! "$ARCHIVE_PATH" =~ \.tar\.gz$ ]]; then
  echo "❌ 错误：文件必须是 .tar.gz 格式: $ARCHIVE_PATH"
  exit 1
fi

# 获取文件信息
archive_size=$(du -h "$ARCHIVE_PATH" | cut -f1)
echo "📦 镜像压缩包: $ARCHIVE_PATH (大小: $archive_size)"

# 如果是 dry-run，只显示压缩包内容
if [[ "$DRY_RUN" == true ]]; then
  echo "🔍 Dry-run 模式：显示压缩包内容..."
  echo "📋 压缩包中的镜像文件:"
  tar -tzf "$ARCHIVE_PATH" | grep '\.tar$' | while read -r file; do
    # 从文件名还原镜像名
    img_name=$(echo "$file" | sed 's/\.tar$//' | tr '__' '/:' | sed 's/__/:/')
    echo "  - $img_name"
  done
  echo "✅ Dry-run 完成！"
  exit 0
fi

# 创建解压目录
if [[ -z "$EXTRACT_DIR" ]]; then
  EXTRACT_DIR=$(mktemp -d)
  trap 'rm -rf "$EXTRACT_DIR"' EXIT
  echo "📁 使用临时解压目录: $EXTRACT_DIR"
else
  mkdir -p "$EXTRACT_DIR"
  echo "📁 使用指定解压目录: $EXTRACT_DIR"
fi

# 解压镜像压缩包
echo "🔓 正在解压镜像压缩包..."
tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR"

# 获取所有镜像 tar 文件
mapfile -t IMAGE_TARS < <(find "$EXTRACT_DIR" -name "*.tar" -type f)

if [[ ${#IMAGE_TARS[@]} -eq 0 ]]; then
  echo "❌ 错误：压缩包中没有找到镜像文件"
  exit 1
fi

echo "📋 找到 ${#IMAGE_TARS[@]} 个镜像文件"

# 导入函数（带重试）
_load_one() {
  local tar_file="$1"
  local tries=0
  local max="$RETRIES"
  
  # 从文件名还原镜像名（用于显示）
  local img_name
  img_name=$(basename "$tar_file" .tar | tr '__' '/:' | sed 's/__/:/')
  
  if [[ "$VERBOSE" == true ]]; then
    echo "📥 开始导入: $img_name"
  fi
  
  until docker load < "$tar_file"; do
    tries=$((tries+1))
    if (( tries > max )); then
      echo "❌ 导入失败: $img_name"
      return 1
    fi
    echo "⏳ 重试($tries/$max): $img_name"
    sleep 2
  done
  
  echo "✅ 导入成功: $img_name"
}

# 并发控制：最多 PARALLEL 个后台任务
run_with_limit() {
  local -a items=("$@")
  local running=0
  local failed=0
  
  for item in "${items[@]}"; do
    if _load_one "$item"; then
      : # 成功
    else
      failed=$((failed+1))
    fi &
    
    running=$((running+1))
    if (( running >= PARALLEL )); then
      wait -n || true
      running=$((running-1))
    fi
  done
  
  wait || true
  
  if [[ $failed -gt 0 ]]; then
    echo "⚠️  有 $failed 个镜像导入失败"
    return 1
  fi
}

# 执行导入
echo "⬆️ 正在并行导入镜像（并发=$PARALLEL）..."
start_time=$(date +%s)

if run_with_limit "${IMAGE_TARS[@]}"; then
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  
  echo
  echo "📋 导入完成汇总:"
  echo "  - 总镜像数: ${#IMAGE_TARS[@]}"
  echo "  - 耗时: ${duration}秒"
  echo "  - 并发数: $PARALLEL"
  
  # 显示导入的镜像列表
  echo "  - 导入的镜像:"
  for tar_file in "${IMAGE_TARS[@]}"; do
    img_name=$(basename "$tar_file" .tar | tr '__' '/:' | sed 's/__/:/')
    echo "    * $img_name"
  done
  
  echo "✅ 所有镜像导入完成！"
else
  echo "❌ 部分镜像导入失败，请检查错误信息"
  exit 1
fi
