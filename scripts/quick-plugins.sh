#!/bin/bash

# ========================================
# Plugins服务快速启动脚本
# 一键启动所有plugins服务
# ========================================

# 移除set -e，允许脚本在失败时继续执行
# set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$PROJECT_ROOT/plugins"

# 打印函数
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

# 检查Docker环境
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker未运行，请先启动Docker服务"
        exit 1
    fi
    print_success "Docker服务检查通过"
}

# 检查Docker Compose
check_docker_compose() {
    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        print_error "Docker Compose未安装或不可用"
        exit 1
    fi
    print_success "Docker Compose检查通过"
}

# 获取Docker Compose命令
get_docker_compose_cmd() {
    if command -v docker-compose >/dev/null 2>&1; then
        echo "docker-compose"
    else
        echo "docker compose"
    fi
}

# 启动单个服务
start_service() {
    local service_path="$1"
    local service_name="$2"
    
    if [ ! -d "$service_path" ]; then
        print_warning "服务目录不存在: $service_path"
        return 2
    fi
    
    # 检查是否有docker-compose文件
    local compose_file=""
    if [ -f "$service_path/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    elif [ -f "$service_path/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    else
        print_warning "未找到docker-compose文件: $service_path"
        return 2
    fi
    
    # 检查.env文件
    if [ ! -f "$service_path/.env" ]; then
        print_warning "未找到.env文件: $service_path/.env"
        return 2
    fi
    
    print_info "启动服务: $service_name"
    print_info "  路径: $service_path"
    print_info "  配置文件: $compose_file"
    
    cd "$service_path"
    
    # 验证配置
    local docker_compose_cmd=$(get_docker_compose_cmd)
    if ! $docker_compose_cmd config >/dev/null 2>&1; then
        print_error "Docker Compose配置验证失败: $service_name"
        cd "$PROJECT_ROOT"
        return 1
    fi
    
    # 启动服务
    if $docker_compose_cmd up -d; then
        print_success "✅ $service_name 启动成功"
        cd "$PROJECT_ROOT"
        return 0
    else
        print_error "❌ $service_name 启动失败"
        cd "$PROJECT_ROOT"
        return 1
    fi
}

# 主函数
main() {
    print_header "Plugins服务快速启动"
    
    # 环境检查
    check_docker
    check_docker_compose
    
    # 检查plugins目录
    if [ ! -d "$PLUGINS_DIR" ]; then
        print_warning "Plugins目录不存在: $PLUGINS_DIR"
        print_info "请确保plugins目录存在并包含相应的服务配置"
        exit 0
    fi
    
    print_info "🔍 扫描plugins目录..."
    
    # 服务启动顺序将根据实际发现的目录动态确定
    
    success_count=0
    failed_count=0
    skipped_count=0
    
    # 扫描plugins目录下的所有服务
    local found_services=()
    
    while IFS= read -r -d '' dir; do
        local service_name=$(basename "$dir")
        if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
            found_services+=("$service_name")
        fi
    done < <(find "$PLUGINS_DIR" -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [ ${#found_services[@]} -eq 0 ]; then
        print_warning "未找到任何可启动的插件服务"
        print_info "请确保plugins目录下的子目录包含docker-compose.yml和.env文件"
        exit 0
    fi
    
    print_info "找到以下插件服务: ${found_services[*]}"
    echo ""
    
    # 启动每个服务
    for service in "${found_services[@]}"; do
        service_path="$PLUGINS_DIR/$service"
        start_service "$service_path" "$service"
        exit_code=$?
        
        case $exit_code in
            0)
                success_count=$((success_count + 1))
                ;;
            1)
                failed_count=$((failed_count + 1))
                ;;
            2)
                skipped_count=$((skipped_count + 1))
                ;;
        esac
        
        # 等待服务稳定
        sleep 3
    done
    
    echo ""
    print_header "启动结果摘要"
    print_info "成功启动: $success_count 个服务"
    print_info "启动失败: $failed_count 个服务"
    print_info "跳过服务: $skipped_count 个服务"
    
    if [ $success_count -gt 0 ]; then
        print_success "🎉 部分或全部插件服务启动成功！"
    fi
    
    if [ $failed_count -gt 0 ]; then
        print_warning "⚠️  部分服务启动失败，请检查日志"
    fi
    
    echo ""
    print_info "📋 使用说明:"
    echo "  查看服务状态: ./scripts/start-plugins-services.sh status"
    echo "  停止所有服务: ./scripts/start-plugins-services.sh stop"
    echo "  重启所有服务: ./scripts/start-plugins-services.sh restart"
    echo "  查看详细帮助: ./scripts/start-plugins-services.sh help"
    echo ""
    print_info "💡 提示: 使用完整功能脚本可以获得更好的控制和日志记录"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
