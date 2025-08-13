#!/bin/bash

# ========================================
# Plugins服务启动脚本
# 自动启动plugins目录下的所有Docker服务
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

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$PROJECT_ROOT/plugins"
LOG_FILE="$PROJECT_ROOT/plugins-start.log"
ERROR_LOG_FILE="$PROJECT_ROOT/plugins-error.log"

# 打印函数
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$ERROR_LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$ERROR_LOG_FILE"
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
}

# 检查Docker Compose
check_docker_compose() {
    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        print_error "Docker Compose未安装或不可用"
        exit 1
    fi
}

# 获取Docker Compose命令
get_docker_compose_cmd() {
    if command -v docker-compose >/dev/null 2>&1; then
        echo "docker-compose"
    else
        echo "docker compose"
    fi
}

# 检查环境变量文件
check_env_files() {
    print_info "检查环境变量文件..."
    
    if [ ! -d "$PLUGINS_DIR" ]; then
        print_warning "Plugins目录不存在: $PLUGINS_DIR"
        return 1
    fi
    
    local env_files=()
    local missing_env=()
    
    # 查找所有子目录中的.env文件
    while IFS= read -r -d '' file; do
        local dir=$(dirname "$file")
        local service_name=$(basename "$dir")
        env_files+=("$service_name:$file")
    done < <(find "$PLUGINS_DIR" -maxdepth 2 -name ".env" -print0 2>/dev/null)
    
    if [ ${#env_files[@]} -eq 0 ]; then
        print_warning "未找到任何.env文件"
        return 1
    fi
    
    print_info "找到以下环境变量文件:"
    for env_info in "${env_files[@]}"; do
        local service_name="${env_info%%:*}"
        local env_file="${env_info##*:}"
        print_info "  $service_name: $env_file"
    done
    
    return 0
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
        print_success "服务启动成功: $service_name"
        cd "$PROJECT_ROOT"
        return 0
    else
        print_error "服务启动失败: $service_name"
        cd "$PROJECT_ROOT"
        return 1
    fi
}

# 停止单个服务
stop_service() {
    local service_path="$1"
    local service_name="$2"
    
    if [ ! -d "$service_path" ]; then
        print_warning "服务目录不存在: $service_path"
        return 2
    fi
    
    local compose_file=""
    if [ -f "$service_path/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    elif [ -f "$service_path/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    else
        print_warning "未找到docker-compose文件: $service_path"
        return 2
    fi
    
    print_info "停止服务: $service_name"
    
    cd "$service_path"
    
    local docker_compose_cmd=$(get_docker_compose_cmd)
    if $docker_compose_cmd down; then
        print_success "服务停止成功: $service_name"
        cd "$PROJECT_ROOT"
        return 0
    else
        print_error "服务停止失败: $service_name"
        cd "$PROJECT_ROOT"
        return 1
    fi
}

# 显示单个服务状态
show_service_status() {
    local service_path="$1"
    local service_name="$2"
    
    if [ ! -d "$service_path" ]; then
        print_warning "服务目录不存在: $service_path"
        return 2
    fi
    
    local compose_file=""
    if [ -f "$service_path/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    elif [ -f "$service_path/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    else
        print_warning "未找到docker-compose文件: $service_path"
        return 2
    fi
    
    print_info "服务状态: $service_name"
    
    cd "$service_path"
    
    local docker_compose_cmd=$(get_docker_compose_cmd)
    if $docker_compose_cmd ps; then
        cd "$PROJECT_ROOT"
        return 0
    else
        print_error "获取服务状态失败: $service_name"
        cd "$PROJECT_ROOT"
        return 1
    fi
}

# 启动所有服务
start_all_services() {
    print_header "开始启动Plugins服务"
    
    local failed_services=()
    local success_services=()
    local skipped_services=()
    
    # 扫描plugins目录下的所有服务
    print_info "扫描plugins目录..."
    local found_services=()
    
    if [ -d "$PLUGINS_DIR" ]; then
        while IFS= read -r -d '' dir; do
            local service_name=$(basename "$dir")
            if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
                found_services+=("$service_name")
            fi
        done < <(find "$PLUGINS_DIR" -maxdepth 1 -type d -print0 2>/dev/null)
    fi
    
    if [ ${#found_services[@]} -eq 0 ]; then
        print_warning "未找到任何可启动的插件服务"
        return 0
    fi
    
    print_info "找到以下插件服务: ${found_services[*]}"
    
    # 启动每个服务
    for service_name in "${found_services[@]}"; do
        local service_path="$PLUGINS_DIR/$service_name"
        
        print_info "处理服务: $service_name"
        
        start_service "$service_path" "$service_name"
        exit_code=$?
        
        case $exit_code in
            0)
                success_services+=("$service_name")
                print_success "✅ $service_name 启动成功"
                ;;
            1)
                failed_services+=("$service_name")
                print_error "❌ $service_name 启动失败"
                ;;
            2)
                skipped_services+=("$service_name")
                print_warning "⚠️  $service_name 跳过（配置不完整）"
                ;;
        esac
        
        # 等待服务稳定
        sleep 5
    done
    
    # 显示启动结果摘要
    print_header "启动结果摘要"
    print_info "成功启动: ${#success_services[@]} 个服务"
    if [ ${#success_services[@]} -gt 0 ]; then
        print_success "✅ ${success_services[*]}"
    fi
    
    print_info "启动失败: ${#failed_services[@]} 个服务"
    if [ ${#failed_services[@]} -gt 0 ]; then
        print_error "❌ ${failed_services[*]}"
    fi
    
    print_info "跳过服务: ${#skipped_services[@]} 个服务"
    if [ ${#skipped_services[@]} -gt 0 ]; then
        print_warning "⚠️  ${skipped_services[*]}"
    fi
    
    # 如果有失败的服务，返回错误
    if [ ${#failed_services[@]} -gt 0 ]; then
        print_error "部分服务启动失败，请检查日志"
        return 1
    fi
    
    return 0
}

# 停止所有服务
stop_all_services() {
    print_header "停止所有Plugins服务"
    
    if [ ! -d "$PLUGINS_DIR" ]; then
        print_warning "Plugins目录不存在"
        return 0
    fi
    
    local found_services=()
    
    while IFS= read -r -d '' dir; do
        local service_name=$(basename "$dir")
        if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
            found_services+=("$service_name")
        fi
    done < <(find "$PLUGINS_DIR" -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [ ${#found_services[@]} -eq 0 ]; then
        print_warning "未找到任何可停止的插件服务"
        return 0
    fi
    
    print_info "找到以下插件服务: ${found_services[*]}"
    
    for service_name in "${found_services[@]}"; do
        local service_path="$PLUGINS_DIR/$service_name"
        stop_service "$service_path" "$service_name"
    done
    
    print_success "所有Plugins服务已停止"
}

# 重启所有服务
restart_all_services() {
    print_header "重启所有Plugins服务"
    
    stop_all_services
    sleep 5
    start_all_services
}

# 显示所有服务状态
show_all_services_status() {
    print_header "Plugins服务状态"
    
    if [ ! -d "$PLUGINS_DIR" ]; then
        print_warning "Plugins目录不存在"
        return 0
    fi
    
    local found_services=()
    
    while IFS= read -r -d '' dir; do
        local service_name=$(basename "$dir")
        if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
            found_services+=("$service_name")
        fi
    done < <(find "$PLUGINS_DIR" -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [ ${#found_services[@]} -eq 0 ]; then
        print_warning "未找到任何插件服务"
        return 0
    fi
    
    print_info "找到以下插件服务: ${found_services[*]}"
    
    for service_name in "${found_services[@]}"; do
        local service_path="$PLUGINS_DIR/$service_name"
        show_service_status "$service_path" "$service_name"
        echo ""
    done
}

# 显示成功启动的服务状态
show_successful_services_status() {
    print_header "成功启动的Plugins服务状态"
    
    if [ ! -d "$PLUGINS_DIR" ]; then
        print_warning "Plugins目录不存在"
        return 0
    fi
    
    local found_services=()
    
    while IFS= read -r -d '' dir; do
        local service_name=$(basename "$dir")
        if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
            found_services+=("$service_name")
        fi
    done < <(find "$PLUGINS_DIR" -maxdepth 1 -type d -print0 2>/dev/null)
    
    if [ ${#found_services[@]} -eq 0 ]; then
        print_warning "未找到任何插件服务"
        return 0
    fi
    
    for service_name in "${found_services[@]}"; do
        local service_path="$PLUGINS_DIR/$service_name"
        
        # 检查服务是否正在运行
        if [ -f "$service_path/docker-compose.yml" ] || [ -f "$service_path/docker-compose.yaml" ]; then
            cd "$service_path"
            local docker_compose_cmd=$(get_docker_compose_cmd)
            if $docker_compose_cmd ps | grep -q "Up"; then
                print_success "✅ $service_name 正在运行"
                $docker_compose_cmd ps
            else
                print_warning "⚠️  $service_name 未运行"
            fi
            cd "$PROJECT_ROOT"
        fi
        echo ""
    done
}

# 清理日志
clean_logs() {
    print_info "清理日志文件..."
    
    if [ -f "$LOG_FILE" ]; then
        rm "$LOG_FILE"
        print_success "已删除日志文件: $LOG_FILE"
    fi
    
    if [ -f "$ERROR_LOG_FILE" ]; then
        rm "$ERROR_LOG_FILE"
        print_success "已删除错误日志文件: $ERROR_LOG_FILE"
    fi
}

# 显示帮助
show_help() {
    cat << EOF
Plugins服务管理脚本

使用方法:
  $0 <命令> [选项]

命令:
  start                启动所有Plugins服务
  stop                 停止所有Plugins服务
  restart              重启所有Plugins服务
  status               显示所有Plugins服务状态
  status-successful    显示成功启动的服务状态
  clean-logs           清理日志文件
  help                 显示此帮助信息

选项:
  --continue-on-failure    启动失败时继续执行其他服务
  --verbose                详细输出模式

示例:
  $0 start                    # 启动所有服务
  $0 stop                     # 停止所有服务
  $0 restart                  # 重启所有服务
  $0 status                   # 查看服务状态
  $0 status-successful        # 查看成功启动的服务状态
  $0 clean-logs               # 清理日志文件

注意事项:
  - 确保Docker和Docker Compose已安装并运行
  - 每个插件服务目录需要包含docker-compose.yml和.env文件
  - 服务启动顺序按照目录扫描顺序进行
  - 建议在启动前检查环境变量配置

EOF
}

# 主函数
main() {
    # 创建日志目录
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # 记录开始时间
    echo "=========================================" >> "$LOG_FILE"
    echo "Plugins服务管理开始时间: $(date)" >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
    
    # 解析命令行参数
    local command=""
    local continue_on_failure=false
    local verbose=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            start|stop|restart|status|status-successful|clean-logs|help)
                command="$1"
                shift
                ;;
            --continue-on-failure)
                continue_on_failure=true
                shift
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            *)
                print_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 如果没有指定命令，显示帮助
    if [ -z "$command" ]; then
        show_help
        exit 0
    fi
    
    # 处理help命令
    if [ "$command" = "help" ]; then
        show_help
        exit 0
    fi
    
    # 设置日志级别
    if [ "$verbose" = "true" ]; then
        set -x
    fi
    
    # 环境检查
    check_docker
    check_docker_compose
    
    # 检查环境变量文件
    check_env_files
    
    # 执行命令
    case $command in
        start)
            start_all_services
            ;;
        stop)
            stop_all_services
            ;;
        restart)
            restart_all_services
            ;;
        status)
            show_all_services_status
            ;;
        status-successful)
            show_successful_services_status
            ;;
        clean-logs)
            clean_logs
            ;;
        *)
            print_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
    
    # 记录结束时间
    echo "=========================================" >> "$LOG_FILE"
    echo "Plugins服务管理结束时间: $(date)" >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
