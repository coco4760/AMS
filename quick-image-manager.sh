#!/bin/bash

# ========================================
# 快速镜像管理脚本
# 基于配置文件进行镜像下载、保存和加载
# ========================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 配置文件路径
CONFIG_FILE="images-config.yaml"

# 检查配置文件
check_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        print_error "配置文件 $CONFIG_FILE 不存在"
        exit 1
    fi
}

# 检查Python环境
check_python() {
    # 检查虚拟环境
    if [ -d "venv" ]; then
        print_info "发现虚拟环境，自动激活..."
        if [ -f "venv/bin/activate" ]; then
            source venv/bin/activate
        elif [ -f "venv/Scripts/activate" ]; then
            source venv/Scripts/activate
        else
            print_warning "虚拟环境激活脚本不存在，尝试直接使用..."
            if [ -f "venv/bin/python" ]; then
                PYTHON_CMD="venv/bin/python"
            elif [ -f "venv/bin/python3" ]; then
                PYTHON_CMD="venv/bin/python3"
            else
                print_error "虚拟环境中的Python不可用"
                exit 1
            fi
        fi
        return 0
    fi
    
    if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
        print_error "Python未安装"
        exit 1
    fi
    
    # 检查PyYAML
    if ! python3 -c "import yaml" 2>/dev/null && ! python -c "import yaml" 2>/dev/null; then
        print_warning "PyYAML未安装，建议创建虚拟环境..."
        print_info "运行以下命令创建虚拟环境："
        print_info "  python3 -m venv venv"
        print_info "  source venv/bin/activate"
        print_info "  pip install pyyaml"
        exit 1
    fi
}

# 显示帮助
show_help() {
    cat << EOF
快速镜像管理脚本

使用方法:
  $0 <环境> [操作] [选项]

环境:
  dev     开发环境
  test    测试环境
  prod    生产环境

操作:
  download    下载镜像（默认）
  save        保存镜像
  load <文件> 加载镜像
  stats       显示统计

选项:
  -p, --parallel    启用并行处理
  -o, --output <目录> 指定输出目录
  -f, --force       强制重新下载
  -h, --help        显示此帮助

示例:
  # 下载生产环境镜像
  $0 prod

  # 保存生产环境镜像
  $0 prod save

  # 加载镜像包
  $0 prod load docker-images-prod.tar.gz

  # 显示统计信息
  $0 prod stats

  # 并行下载
  $0 prod download -p

  # 指定输出目录
  $0 prod save -o my-images
EOF
}

# 下载镜像
download_images() {
    local environment="$1"
    local parallel="$2"
    local force="$3"
    
    print_info "开始下载环境 $environment 的镜像..."
    
    local cmd="python3 smart-image-manager.py -c $CONFIG_FILE -a download -e $environment"
    
    if [ "$parallel" = "true" ]; then
        cmd="$cmd -p"
    fi
    
    if [ "$force" = "true" ]; then
        cmd="$cmd --no-skip-existing"
    fi
    
    print_info "执行命令: $cmd"
    eval $cmd
}

# 保存镜像
save_images() {
    local environment="$1"
    local parallel="$2"
    local output_dir="$3"
    
    print_info "开始保存环境 $environment 的镜像..."
    
    local cmd="python3 smart-image-manager.py -c $CONFIG_FILE -a save -e $environment"
    
    if [ "$parallel" = "true" ]; then
        cmd="$cmd -p"
    fi
    
    if [ -n "$output_dir" ]; then
        cmd="$cmd -o $output_dir"
    fi
    
    print_info "执行命令: $cmd"
    eval $cmd
}

# 加载镜像
load_images() {
    local tar_file="$1"
    local parallel="$2"
    
    if [ ! -f "$tar_file" ] && [ ! -d "$tar_file" ]; then
        print_error "文件不存在: $tar_file"
        exit 1
    fi
    
    print_info "开始加载镜像: $tar_file"
    
    local cmd="python3 smart-image-manager.py -c $CONFIG_FILE -a load --tar-file $tar_file"
    
    if [ "$parallel" = "true" ]; then
        cmd="$cmd -p"
    fi
    
    print_info "执行命令: $cmd"
    eval $cmd
}

# 显示统计
show_stats() {
    local environment="$1"
    
    print_info "显示环境 $environment 的镜像统计..."
    
    local cmd="python3 smart-image-manager.py -c $CONFIG_FILE -a stats -e $environment"
    print_info "执行命令: $cmd"
    eval $cmd
}

# 主函数
main() {
    # 检查依赖
    check_config
    check_python
    
    # 解析参数
    local environment=""
    local action="download"
    local parallel=false
    local output_dir=""
    local force=false
    local tar_file=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--parallel)
                parallel=true
                shift
                ;;
            -o|--output)
                output_dir="$2"
                shift 2
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            dev|test|prod)
                environment="$1"
                shift
                ;;
            download|save|load|stats)
                action="$1"
                shift
                ;;
            *)
                if [ "$action" = "load" ] && [ -z "$tar_file" ]; then
                    tar_file="$1"
                else
                    print_error "未知参数: $1"
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # 检查必需参数
    if [ -z "$environment" ]; then
        print_error "请指定环境 (dev|test|prod)"
        show_help
        exit 1
    fi
    
    # 执行操作
    case $action in
        download)
            download_images "$environment" "$parallel" "$force"
            ;;
        save)
            save_images "$environment" "$parallel" "$output_dir"
            ;;
        load)
            if [ -z "$tar_file" ]; then
                print_error "请指定要加载的tar文件"
                exit 1
            fi
            load_images "$tar_file" "$parallel"
            ;;
        stats)
            show_stats "$environment"
            ;;
        *)
            print_error "未知操作: $action"
            show_help
            exit 1
            ;;
    esac
    
    print_success "操作完成！"
}

# 运行主函数
main "$@"
