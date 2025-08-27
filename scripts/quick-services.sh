#!/bin/bash

# 智能Services服务管理脚本
# 自动检索docker-compose文件并提供启动、停止、重启、状态查看等功能的快捷方式

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 全局变量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SERVICES_DIR="$PROJECT_ROOT/services"
VERBOSE=false
FORCE=false
REMOVE=false

# 显示使用方法
show_usage() {
    echo -e "${BLUE}智能Services服务管理脚本${NC}"
    echo ""
    echo "使用方法: $0 <命令> [选项]"
    echo ""
    echo "命令:"
    echo "  start    启动所有services服务"
    echo "  stop     停止所有services服务"
    echo "  restart  重启所有services服务"
    echo "  status   查看所有服务状态"
    echo "  logs     查看服务日志"
    echo "  list     列出所有可用的服务"
    echo "  help     显示此帮助信息"
    echo ""
    echo "选项:"
    echo "  -v       详细模式"
    echo "  -f       强制模式"
    echo "  -r       停止时移除容器"
    echo ""
    echo "示例:"
    echo "  $0 start        # 启动所有服务"
    echo "  $0 stop -r      # 停止并移除容器"
    echo "  $0 restart -v   # 详细模式重启"
    echo "  $0 status       # 查看服务状态"
    echo "  $0 list         # 列出所有服务"
}

# 日志函数
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} $1"
}

log_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

log_info() {
    echo -e "${CYAN}[$(date '+%Y-%m-%d %H:%M:%S')] INFO:${NC} $1"
}

# 检查Docker是否运行
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker未运行或无法访问。请确保Docker服务已启动。"
        exit 1
    fi
    log "Docker服务检查通过"
}

# 检查Docker Compose是否可用
check_docker_compose() {
    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        log_error "Docker Compose未安装或不可用。"
        exit 1
    fi
    log "Docker Compose检查通过"
}

# 获取Docker Compose命令
get_docker_compose_cmd() {
    if command -v docker-compose >/dev/null 2>&1; then
        echo "docker-compose"
    else
        echo "docker compose"
    fi
}

# 自动发现所有可用的服务
discover_services() {
    local services=()
    
    if [[ ! -d "$SERVICES_DIR" ]]; then
        log_error "Services目录不存在: $SERVICES_DIR"
        return 1
    fi
    
    # 遍历services目录下的所有子目录
    for service_dir in "$SERVICES_DIR"/*/; do
        if [[ -d "$service_dir" ]]; then
            local service_name=$(basename "$service_dir")
            local compose_file=""
            
            # 检查docker-compose文件
            if [[ -f "$service_dir/docker-compose.yaml" ]]; then
                compose_file="$service_dir/docker-compose.yaml"
            elif [[ -f "$service_dir/docker-compose.yml" ]]; then
                compose_file="$service_dir/docker-compose.yml"
            fi
            
            if [[ -n "$compose_file" ]]; then
                services+=("$service_name")
            fi
        fi
    done
    
    echo "${services[@]}"
}

# 列出所有可用的服务
list_services() {
    log_info "正在扫描Services目录..."
    
    local services=($(discover_services))
    local total_services=${#services[@]}
    
    if [[ $total_services -eq 0 ]]; then
        log_warning "未找到任何可用的服务"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}发现 $total_services 个可用服务:${NC}"
    echo ""
    
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    for service in "${services[@]}"; do
        local service_dir="$SERVICES_DIR/$service"
        local compose_file=""
        
        # 确定compose文件路径
        if [[ -f "$service_dir/docker-compose.yaml" ]]; then
            compose_file="$service_dir/docker-compose.yaml"
        elif [[ -f "$service_dir/docker-compose.yml" ]]; then
            compose_file="$service_dir/docker-compose.yml"
        fi
        
        echo -e "${CYAN}服务: $service${NC}"
        echo "  目录: $service_dir"
        echo "  配置文件: $compose_file"
        
        # 检查.env文件
        if [[ -f "$service_dir/.env" ]]; then
            echo -e "  环境配置: ${GREEN}已配置${NC}"
        else
            echo -e "  环境配置: ${YELLOW}未配置${NC}"
        fi
        
        # 检查服务状态
        if [[ -f "$compose_file" ]]; then
            local status=$($docker_compose_cmd -f "$compose_file" ps --format json 2>/dev/null | jq -r '.State' 2>/dev/null || echo "unknown")
            if [[ "$status" == "running" ]]; then
                echo -e "  状态: ${GREEN}运行中${NC}"
            elif [[ "$status" == "exited" ]]; then
                echo -e "  状态: ${YELLOW}已停止${NC}"
            else
                echo -e "  状态: ${RED}未知${NC}"
            fi
        fi
        echo ""
    done
}

# 启动单个服务
start_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local compose_file=""
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    # 确定compose文件路径
    if [[ -f "$service_dir/docker-compose.yaml" ]]; then
        compose_file="$service_dir/docker-compose.yaml"
    elif [[ -f "$service_dir/docker-compose.yml" ]]; then
        compose_file="$service_dir/docker-compose.yml"
    fi
    
    if [[ -z "$compose_file" ]]; then
        log_warning "跳过 $service_name: 未找到 docker-compose 文件"
        return 1
    fi
    
    log "正在启动服务: $service_name"
    
    # 检查.env文件
    if [[ -f "$service_dir/.env" ]]; then
        log_info "发现环境配置文件: $service_dir/.env"
    else
        log_warning "未发现环境配置文件: $service_dir/.env"
    fi
    
    # 检查服务是否已经在运行
    if [[ "$FORCE" != "true" ]]; then
        if $docker_compose_cmd -f "$compose_file" ps | grep -q "Up"; then
            log_warning "服务 $service_name 已经在运行，跳过启动"
            return 0
        fi
    fi
    
    # 切换到服务目录并启动
    cd "$service_dir"
    
    # 启动服务
    if $docker_compose_cmd -f "$compose_file" up -d; then
        log_success "服务 $service_name 启动成功"
        cd - >/dev/null
        return 0
    else
        log_error "服务 $service_name 启动失败"
        cd - >/dev/null
        return 1
    fi
}

# 停止单个服务
stop_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local compose_file=""
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    # 确定compose文件路径
    if [[ -f "$service_dir/docker-compose.yaml" ]]; then
        compose_file="$service_dir/docker-compose.yaml"
    elif [[ -f "$service_dir/docker-compose.yml" ]]; then
        compose_file="$service_dir/docker-compose.yml"
    fi
    
    if [[ -z "$compose_file" ]]; then
        log_warning "跳过 $service_name: 未找到 docker-compose 文件"
        return 1
    fi
    
    log "正在停止服务: $service_name"
    
    # 检查服务是否在运行
    if ! $docker_compose_cmd -f "$compose_file" ps | grep -q "Up"; then
        if [[ "$FORCE" != "true" ]]; then
            log_warning "服务 $service_name 已经停止，跳过"
            return 0
        fi
    fi
    
    # 切换到服务目录并停止
    cd "$service_dir"
    
    # 停止服务
    if [[ "$REMOVE" == "true" ]]; then
        if $docker_compose_cmd -f "$compose_file" down; then
            log_success "服务 $service_name 停止并移除成功"
            cd - >/dev/null
            return 0
        else
            log_error "服务 $service_name 停止并移除失败"
            cd - >/dev/null
            return 1
        fi
    else
        if $docker_compose_cmd -f "$compose_file" stop; then
            log_success "服务 $service_name 停止成功"
            cd - >/dev/null
            return 0
        else
            log_error "服务 $service_name 停止失败"
            cd - >/dev/null
            return 1
        fi
    fi
}

# 启动所有服务
start_all_services() {
    log_info "开始启动所有Services服务..."
    
    # 检查前置条件
    check_docker
    check_docker_compose
    
    # 获取所有服务
    local services=($(discover_services))
    local total_services=${#services[@]}
    
    if [[ $total_services -eq 0 ]]; then
        log_error "未找到任何可用的服务"
        return 1
    fi
    
    log_info "发现 $total_services 个服务: ${services[*]}"
    
    # 统计变量
    local started_services=0
    local failed_services=0
    
    # 启动每个服务
    for service in "${services[@]}"; do
        local service_dir="$SERVICES_DIR/$service"
        
        if start_service "$service_dir"; then
            started_services=$((started_services + 1))
        else
            failed_services=$((failed_services + 1))
        fi
        
        # 在服务之间添加短暂延迟
        sleep 2
    done
    
    # 显示启动结果摘要
    log_info "启动完成摘要:"
    log_info "总服务数: $total_services"
    log_info "成功启动: $started_services"
    log_info "启动失败: $failed_services"
    
    if [[ $failed_services -eq 0 ]]; then
        log_success "所有Services服务启动完成"
        return 0
    else
        log_error "部分服务启动失败，请检查日志"
        return 1
    fi
}

# 停止所有服务
stop_all_services() {
    log_info "开始停止所有Services服务..."
    
    # 检查前置条件
    check_docker
    check_docker_compose
    
    # 获取所有服务
    local services=($(discover_services))
    local total_services=${#services[@]}
    
    if [[ $total_services -eq 0 ]]; then
        log_error "未找到任何可用的服务"
        return 1
    fi
    
    log_info "发现 $total_services 个服务: ${services[*]}"
    
    # 统计变量
    local stopped_services=0
    local failed_services=0
    
    # 停止每个服务
    for service in "${services[@]}"; do
        local service_dir="$SERVICES_DIR/$service"
        
        if stop_service "$service_dir"; then
            stopped_services=$((stopped_services + 1))
        else
            failed_services=$((failed_services + 1))
        fi
        
        # 在服务之间添加短暂延迟
        sleep 1
    done
    
    # 显示停止结果摘要
    log_info "停止完成摘要:"
    log_info "总服务数: $total_services"
    log_info "成功停止: $stopped_services"
    log_info "停止失败: $failed_services"
    
    if [[ $failed_services -eq 0 ]]; then
        log_success "所有Services服务停止完成"
        return 0
    else
        log_error "部分服务停止失败，请检查日志"
        return 1
    fi
}

# 查看服务状态
show_status() {
    log_info "查看Services服务状态..."
    
    local services=($(discover_services))
    local total_services=${#services[@]}
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    if [[ $total_services -eq 0 ]]; then
        log_warning "未找到任何可用的服务"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}=== Services服务状态 ===${NC}"
    echo ""
    
    for service in "${services[@]}"; do
        local service_dir="$SERVICES_DIR/$service"
        local compose_file=""
        
        # 确定compose文件路径
        if [[ -f "$service_dir/docker-compose.yaml" ]]; then
            compose_file="$service_dir/docker-compose.yaml"
        elif [[ -f "$service_dir/docker-compose.yml" ]]; then
            compose_file="$service_dir/docker-compose.yml"
        fi
        
        if [[ -f "$compose_file" ]]; then
            echo -e "${CYAN}服务: $service${NC}"
            $docker_compose_cmd -f "$compose_file" ps
            echo ""
        fi
    done
}

# 查看服务日志
show_logs() {
    log_info "查看Services服务日志..."
    
    local services=($(discover_services))
    local total_services=${#services[@]}
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    if [[ $total_services -eq 0 ]]; then
        log_error "未找到任何可用的服务"
        return 1
    fi
    
    echo ""
    echo "请选择要查看日志的服务:"
    
    # 显示服务列表
    for i in "${!services[@]}"; do
        echo "$((i+1))) ${services[$i]}"
    done
    echo "$((total_services+1))) 所有服务"
    echo ""
    
    read -p "请输入选择 (1-$((total_services+1))): " choice
    
    if [[ "$choice" -ge 1 && "$choice" -le "$total_services" ]]; then
        local selected_service="${services[$((choice-1))]}"
        local service_dir="$SERVICES_DIR/$selected_service"
        local compose_file=""
        
        # 确定compose文件路径
        if [[ -f "$service_dir/docker-compose.yaml" ]]; then
            compose_file="$service_dir/docker-compose.yaml"
        elif [[ -f "$service_dir/docker-compose.yml" ]]; then
            compose_file="$service_dir/docker-compose.yml"
        fi
        
        if [[ -f "$compose_file" ]]; then
            echo ""
            echo -e "${BLUE}=== $selected_service 日志 ===${NC}"
            $docker_compose_cmd -f "$compose_file" logs -f
        else
            log_error "服务 $selected_service 的配置文件不存在"
            return 1
        fi
    elif [[ "$choice" -eq $((total_services+1)) ]]; then
        echo ""
        echo -e "${BLUE}=== 所有服务日志 ===${NC}"
        for service in "${services[@]}"; do
            local service_dir="$SERVICES_DIR/$service"
            local compose_file=""
            
            # 确定compose文件路径
            if [[ -f "$service_dir/docker-compose.yaml" ]]; then
                compose_file="$service_dir/docker-compose.yaml"
            elif [[ -f "$service_dir/docker-compose.yml" ]]; then
                compose_file="$service_dir/docker-compose.yml"
            fi
            
            if [[ -f "$compose_file" ]]; then
                echo ""
                echo -e "${CYAN}=== $service 日志 ===${NC}"
                $docker_compose_cmd -f "$compose_file" logs --tail=20
            fi
        done
    else
        log_error "无效选择"
        return 1
    fi
}

# 主函数
main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    local command="$1"
    shift
    
    # 解析选项
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -r|--remove)
                REMOVE=true
                shift
                ;;
            *)
                log_error "未知选项: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    case "$command" in
        start)
            start_all_services
            ;;
        stop)
            stop_all_services
            ;;
        restart)
            log_info "重启所有Services服务..."
            echo "1. 停止服务..."
            stop_all_services
            echo "2. 等待5秒..."
            sleep 5
            echo "3. 启动服务..."
            start_all_services
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        list)
            list_services
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            log_error "未知命令 '$command'"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# 捕获中断信号
trap 'log_warning "脚本被用户中断"; exit 130' INT TERM

# 执行主函数
main "$@"
