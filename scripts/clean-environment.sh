#!/bin/bash

# ========================================
# 环境清理脚本
# 停止所有容器、删除镜像和数据目录
# ========================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 数据目录
DATA_DIR="/var/lib/clouditera"

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

print_header() {
    echo -e "${PURPLE}========================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}========================================${NC}"
}

# 检查Docker是否运行
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker未运行，请先启动Docker服务"
        exit 1
    fi
    print_success "Docker服务检查通过"
}

# 检查是否为root用户
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_warning "检测到root用户权限，请谨慎操作！"
    else
        print_warning "建议使用sudo运行此脚本以确保完全清理"
    fi
}

# 显示清理预览
show_cleanup_preview() {
    print_header "清理预览"
    
    # 统计容器数量
    local running_containers=$(docker ps -q 2>/dev/null | wc -l)
    local stopped_containers=$(docker ps -aq 2>/dev/null | wc -l)
    local total_containers=$((running_containers + stopped_containers))
    
    # 统计镜像数量
    local images=$(docker images -q 2>/dev/null | wc -l)
    
    # 统计数据目录大小
    local data_dir_size="0"
    if [ -d "$DATA_DIR" ]; then
        data_dir_size=$(du -sh "$DATA_DIR" 2>/dev/null | cut -f1 || echo "未知")
    fi
    
    echo -e "${BLUE}📊 当前环境状态:${NC}"
    echo -e "   🐳 运行中的容器: ${YELLOW}$running_containers${NC}"
    echo -e "   🐳 已停止的容器: ${YELLOW}$stopped_containers${NC}"
    echo -e "   🐳 总容器数: ${YELLOW}$total_containers${NC}"
    echo -e "   🖼️  Docker镜像: ${YELLOW}$images${NC}"
    echo -e "   📁 数据目录: ${YELLOW}$DATA_DIR${NC}"
    echo -e "   💾 数据目录大小: ${YELLOW}$data_dir_size${NC}"
    echo ""
    
    echo -e "${BLUE}🗑️  清理操作将执行:${NC}"
    echo -e "   1. 停止所有运行中的容器"
    echo -e "   2. 删除所有容器（包括已停止的）"
    echo -e "   3. 删除所有Docker镜像"
    echo -e "   4. 删除数据目录: $DATA_DIR"
    echo -e "   5. 清理Docker系统（可选）"
    echo ""
    
    echo -e "${RED}⚠️  警告: 此操作不可逆，所有数据将被永久删除！${NC}"
}

# 停止所有容器
stop_all_containers() {
    print_info "停止所有运行中的容器..."
    
    local running_containers=$(docker ps -q 2>/dev/null)
    if [ -n "$running_containers" ]; then
        if docker stop $running_containers 2>/dev/null; then
            print_success "所有容器已停止"
        else
            print_warning "部分容器停止失败，将尝试强制停止"
            docker kill $running_containers 2>/dev/null || true
        fi
    else
        print_info "没有运行中的容器"
    fi
}

# 删除所有容器
remove_all_containers() {
    print_info "删除所有容器..."
    
    local all_containers=$(docker ps -aq 2>/dev/null)
    if [ -n "$all_containers" ]; then
        if docker rm -f $all_containers 2>/dev/null; then
            print_success "所有容器已删除"
        else
            print_warning "部分容器删除失败"
        fi
    else
        print_info "没有容器需要删除"
    fi
}

# 删除所有镜像
remove_all_images() {
    print_info "删除所有Docker镜像..."
    
    local all_images=$(docker images -q 2>/dev/null)
    if [ -n "$all_images" ]; then
        if docker rmi -f $all_images 2>/dev/null; then
            print_success "所有镜像已删除"
        else
            print_warning "部分镜像删除失败"
        fi
    else
        print_info "没有镜像需要删除"
    fi
}

# 删除数据目录
remove_data_directory() {
    print_info "删除数据目录: $DATA_DIR"
    
    if [ -d "$DATA_DIR" ]; then
        # 检查目录权限
        if [ ! -r "$DATA_DIR" ] || [ ! -w "$DATA_DIR" ]; then
            print_warning "数据目录权限不足，尝试使用sudo删除"
            if sudo rm -rf "$DATA_DIR" 2>/dev/null; then
                print_success "数据目录已删除"
            else
                print_error "数据目录删除失败，请手动删除: $DATA_DIR"
                return 1
            fi
        else
            if rm -rf "$DATA_DIR" 2>/dev/null; then
                print_success "数据目录已删除"
            else
                print_error "数据目录删除失败"
                return 1
            fi
        fi
    else
        print_info "数据目录不存在: $DATA_DIR"
    fi
}

# 清理Docker系统
cleanup_docker_system() {
    print_info "清理Docker系统..."
    
    # 清理未使用的数据
    if docker system prune -af --volumes 2>/dev/null; then
        print_success "Docker系统清理完成"
    else
        print_warning "Docker系统清理失败"
    fi
}

# 清理网络
cleanup_networks() {
    print_info "清理Docker网络..."
    
    local networks=$(docker network ls -q 2>/dev/null | grep -v "bridge\|host\|none")
    if [ -n "$networks" ]; then
        for network in $networks; do
            docker network rm "$network" 2>/dev/null || true
        done
        print_success "Docker网络清理完成"
    else
        print_info "没有自定义网络需要清理"
    fi
}

# 清理卷
cleanup_volumes() {
    print_info "清理Docker卷..."
    
    local volumes=$(docker volume ls -q 2>/dev/null)
    if [ -n "$volumes" ]; then
        if docker volume rm $volumes 2>/dev/null; then
            print_success "Docker卷清理完成"
        else
            print_warning "部分Docker卷清理失败"
        fi
    else
        print_info "没有Docker卷需要清理"
    fi
}

# 显示清理结果
show_cleanup_result() {
    print_header "清理结果"
    
    # 检查剩余容器
    local remaining_containers=$(docker ps -aq 2>/dev/null | wc -l)
    local remaining_images=$(docker images -q 2>/dev/null | wc -l)
    local data_dir_exists="否"
    
    if [ -d "$DATA_DIR" ]; then
        data_dir_exists="是"
    fi
    
    echo -e "${BLUE}📊 清理后状态:${NC}"
    echo -e "   🐳 剩余容器: ${YELLOW}$remaining_containers${NC}"
    echo -e "   🖼️  剩余镜像: ${YELLOW}$remaining_images${NC}"
    echo -e "   📁 数据目录存在: ${YELLOW}$data_dir_exists${NC}"
    echo ""
    
    if [ "$remaining_containers" -eq 0 ] && [ "$remaining_images" -eq 0 ] && [ "$data_dir_exists" = "否" ]; then
        echo -e "${GREEN}🎉 环境清理完成！${NC}"
    else
        echo -e "${YELLOW}⚠️  部分清理未完成，请检查上述项目${NC}"
    fi
}

# 显示帮助
show_help() {
    cat << EOF
环境清理脚本

使用方法:
  $0 [选项]

选项:
  --preview-only    仅显示清理预览，不执行清理
  --no-data-dir     不删除数据目录
  --no-docker-clean 不清理Docker系统
  --force           跳过确认提示
  --help            显示此帮助信息

功能:
  • 停止所有运行中的容器
  • 删除所有容器和镜像
  • 删除数据目录: $DATA_DIR
  • 清理Docker系统（可选）
  • 清理Docker网络和卷

警告:
  此脚本将永久删除所有Docker数据和配置！
  请确保已备份重要数据！

示例:
  $0                    # 完整清理（需要确认）
  $0 --force           # 强制清理（跳过确认）
  $0 --preview-only    # 仅显示清理预览
  $0 --no-data-dir     # 不删除数据目录

EOF
}

# 主函数
main() {
    local preview_only=false
    local no_data_dir=false
    local no_docker_clean=false
    local force=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --preview-only)
                preview_only=true
                shift
                ;;
            --no-data-dir)
                no_data_dir=true
                shift
                ;;
            --no-docker-clean)
                no_docker_clean=true
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    print_header "环境清理脚本"
    
    # 检查环境
    check_docker
    check_root
    echo ""
    
    # 显示清理预览
    show_cleanup_preview
    
    # 如果只是预览，则退出
    if [ "$preview_only" = "true" ]; then
        print_info "预览模式，未执行清理操作"
        exit 0
    fi
    
    # 确认操作
    if [ "$force" != "true" ]; then
        echo ""
        echo -e "${RED}⚠️  确认执行清理操作？${NC}"
        read -p "输入 'YES' 确认执行: " confirm
        if [ "$confirm" != "YES" ]; then
            print_info "操作已取消"
            exit 0
        fi
    fi
    
    echo ""
    print_header "开始执行清理操作"
    
    # 执行清理步骤
    stop_all_containers
    remove_all_containers
    remove_all_images
    
    if [ "$no_data_dir" != "true" ]; then
        remove_data_directory
    fi
    
    if [ "$no_docker_clean" != "true" ]; then
        cleanup_docker_system
        cleanup_networks
        cleanup_volumes
    fi
    
    echo ""
    show_cleanup_result
    
    print_header "清理操作完成"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
