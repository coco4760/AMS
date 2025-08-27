#!/bin/bash

# 智能Storage服务管理脚本
# 自动检索docker-compose文件并提供启动、停止、重启、状态查看等功能的快捷方式

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# 全局变量
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
STORAGE_DIR="$PROJECT_ROOT/storage"
VERBOSE=false
FORCE=false
REMOVE=false

# 显示使用方法
show_usage() {
    echo -e "${BLUE}智能Storage服务管理脚本${NC}"
    echo ""
    echo "使用方法: $0 <命令> [选项]"
    echo ""
    echo "命令:"
    echo "  start    启动所有storage服务"
    echo "  stop     停止所有storage服务"
    echo "  restart  重启所有storage服务"
    echo "  status   查看所有服务状态"
    echo "  logs     查看服务日志"
    echo "  clean    清理有问题的数据目录"
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
    
    if [[ ! -d "$STORAGE_DIR" ]]; then
        log_error "Storage目录不存在: $STORAGE_DIR"
        return 1
    fi
    
    # 遍历storage目录下的所有子目录
    for service_dir in "$STORAGE_DIR"/*/; do
        if [[ -d "$service_dir" ]]; then
            local service_name=$(basename "$service_dir")
            local compose_file="$service_dir/docker-compose.yaml"
            
            if [[ -f "$compose_file" ]]; then
                services+=("$service_name")
            fi
        fi
    done
    
    echo "${services[@]}"
}

# 列出所有可用的服务
list_services() {
    log_info "正在扫描Storage目录..."
    
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
        local service_dir="$STORAGE_DIR/$service"
        local compose_file="$service_dir/docker-compose.yaml"
        
        echo -e "${CYAN}服务: $service${NC}"
        echo "  目录: $service_dir"
        echo "  配置文件: $compose_file"
        
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

# 准备数据目录
prepare_data_directories() {
    local data_root="/var/lib/clouditera/data"
    
    log "准备数据目录: $data_root"
    
    # 创建根目录
    if [[ ! -d "$data_root" ]]; then
        log "创建数据根目录: $data_root"
        sudo mkdir -p "$data_root"
    fi
    
    # 创建各个服务的子目录
    local services=(es rag_data rag_data/es/data rag_data/es/plugins)
    
    for service in "${services[@]}"; do
        local service_dir="$data_root/$service"
        if [[ ! -d "$service_dir" ]]; then
            log "创建服务目录: $service_dir"
            sudo mkdir -p "$service_dir"
        fi
        
        # 为特定服务创建必要的子目录
        case $service in
            "es")
                if [[ ! -d "$service_dir/data" ]]; then
                    sudo mkdir -p "$service_dir/data"
                fi
                if [[ ! -d "$service_dir/plugins" ]]; then
                    sudo mkdir -p "$service_dir/plugins"
                fi
                ;;
            "rag_data")
                if [[ ! -d "$service_dir/data" ]]; then
                    sudo mkdir -p "$service_dir/data"
                fi
                if [[ ! -d "$service_dir/logs" ]]; then
                    sudo mkdir -p "$service_dir/logs"
                fi
                ;;
        esac
    done
    
    # 设置目录权限
    log "设置目录权限..."
    sudo chown -R 1000:1000 "$data_root/es" || true
    sudo chown -R 1000:1000 "$data_root/rag_data/es" 2>/dev/null || true
    sudo chmod -R 755 "$data_root"
    
    log_success "数据目录准备完成"
}

# 启动单个服务
start_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local compose_file="$service_dir/docker-compose.yaml"
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    if [[ ! -f "$compose_file" ]]; then
        log_warning "跳过 $service_name: 未找到 docker-compose.yaml 文件"
        return 1
    fi
    
    log "正在启动服务: $service_name"
    
    # 检查服务是否已经在运行
    if [[ "$FORCE" != "true" ]]; then
        if $docker_compose_cmd -f "$compose_file" ps | grep -q "Up"; then
            log_warning "服务 $service_name 已经在运行，跳过启动"
            return 0
        fi
    fi
    
    # 启动服务
    if $docker_compose_cmd -f "$compose_file" up -d; then
        log_success "服务 $service_name 启动成功"
        return 0
    else
        log_error "服务 $service_name 启动失败"
        return 1
    fi
}

# 停止单个服务
stop_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local compose_file="$service_dir/docker-compose.yaml"
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    if [[ ! -f "$compose_file" ]]; then
        log_warning "跳过 $service_name: 未找到 docker-compose.yaml 文件"
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
    
    # 停止服务
    if [[ "$REMOVE" == "true" ]]; then
        if $docker_compose_cmd -f "$compose_file" down; then
            log_success "服务 $service_name 停止并移除成功"
            return 0
        else
            log_error "服务 $service_name 停止并移除失败"
            return 1
        fi
    else
        if $docker_compose_cmd -f "$compose_file" stop; then
            log_success "服务 $service_name 停止成功"
            return 0
        else
            log_error "服务 $service_name 停止失败"
            return 1
        fi
    fi
}

# 启动所有服务
start_all_services() {
    log_info "开始启动所有Storage服务..."
    
    # 检查前置条件
    check_docker
    check_docker_compose
    
    # 准备数据目录
    prepare_data_directories
    
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
        local service_dir="$STORAGE_DIR/$service"
        
        if start_service "$service_dir"; then
            started_services=$((started_services + 1))
        else
            failed_services=$((failed_services + 1))
        fi
        
        # 在服务之间添加短暂延迟
        sleep 1
    done
    
    # 显示启动结果摘要
    log_info "启动完成摘要:"
    log_info "总服务数: $total_services"
    log_info "成功启动: $started_services"
    log_info "启动失败: $failed_services"
    
    if [[ $failed_services -eq 0 ]]; then
        log_success "所有Storage服务启动完成"
        return 0
    else
        log_error "部分服务启动失败，请检查日志"
        return 1
    fi
}

# 停止所有服务
stop_all_services() {
    log_info "开始停止所有Storage服务..."
    
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
        local service_dir="$STORAGE_DIR/$service"
        
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
        log_success "所有Storage服务停止完成"
        return 0
    else
        log_error "部分服务停止失败，请检查日志"
        return 1
    fi
}

# 查看服务状态
show_status() {
    log_info "查看Storage服务状态..."
    
    local services=($(discover_services))
    local total_services=${#services[@]}
    local docker_compose_cmd=$(get_docker_compose_cmd)
    
    if [[ $total_services -eq 0 ]]; then
        log_warning "未找到任何可用的服务"
        return 1
    fi
    
    echo ""
    echo -e "${BLUE}=== Storage服务状态 ===${NC}"
    echo ""
    
    for service in "${services[@]}"; do
        local service_dir="$STORAGE_DIR/$service"
        local compose_file="$service_dir/docker-compose.yaml"
        
        if [[ -f "$compose_file" ]]; then
            echo -e "${CYAN}服务: $service${NC}"
            $docker_compose_cmd -f "$compose_file" ps
            echo ""
        fi
    done
}

# 查看服务日志
show_logs() {
    log_info "查看Storage服务日志..."
    
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
        local compose_file="$STORAGE_DIR/$selected_service/docker-compose.yaml"
        
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
            local compose_file="$STORAGE_DIR/$service/docker-compose.yaml"
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

# 清理有问题的数据目录
clean_data_directories() {
    log_info "清理有问题的数据目录..."
    
    echo ""
    echo "请选择清理模式:"
    echo "1) 安全清理 - 只清理损坏的文件，保留数据"
    echo "2) 完全清理 - 删除所有数据（危险！）"
    echo "3) 取消操作"
    echo ""
    read -p "请输入选择 (1-3): " choice
    
    case $choice in
        1)
            log_info "执行安全清理..."
            
            # 停止所有服务
            stop_all_services
            
            echo "备份现有数据..."
            local backup_dir="/var/lib/clouditera/data/backups/$(date +%Y%m%d_%H%M%S)"
            sudo mkdir -p "$backup_dir"
            
            # 备份重要数据
            if [[ -d "/var/lib/clouditera/data/mysql/data" ]]; then
                sudo cp -r /var/lib/clouditera/data/mysql/data "$backup_dir/mysql_data"
                log_info "MySQL数据已备份到: $backup_dir/mysql_data"
            fi
            
            if [[ -d "/var/lib/clouditera/data/es/data" ]]; then
                sudo cp -r /var/lib/clouditera/data/es/data "$backup_dir/es_data"
                log_info "Elasticsearch数据已备份到: $backup_dir/es_data"
            fi
            
            echo "清理损坏的文件..."
            sudo find /var/lib/clouditera/data -name "*.lock" -delete 2>/dev/null || true
            sudo find /var/lib/clouditera/data -name "*.tmp" -delete 2>/dev/null || true
            sudo find /var/lib/clouditera/data -name "*.pid" -delete 2>/dev/null || true
            
            echo "重新创建目录结构..."
            sudo mkdir -p /var/lib/clouditera/data/{es,rag_data/es/data,rag_data/es/plugins}
            
            echo "设置目录权限..."
            sudo chown -R 1000:1000 /var/lib/clouditera/data/es
            sudo chown -R 1000:1000 /var/lib/clouditera/data/rag_data/es
            sudo chmod -R 755 /var/lib/clouditera/data
            
            log_success "安全清理完成！"
            log_info "数据已备份到: $backup_dir"
            log_info "现在可以使用 '$0 start' 重新启动服务"
            ;;
        2)
            log_warning "执行完全清理..."
            echo "警告: 这将删除所有数据，无法恢复！"
            read -p "确认删除所有数据? (输入 'DELETE ALL' 确认): " confirm
            if [[ "$confirm" == "DELETE ALL" ]]; then
                # 停止所有服务
                stop_all_services
                
                echo "删除所有数据..."
                sudo rm -rf /var/lib/clouditera/data/*
                
                echo "重新创建目录结构..."
                sudo mkdir -p /var/lib/clouditera/data/{es,rag_data/es/data,rag_data/es/plugins}
                
                echo "设置目录权限..."
                sudo chown -R 1000:1000 /var/lib/clouditera/data/es
                sudo chown -R 1000:1000 /var/lib/clouditera/data/rag_data/es
                sudo chmod -R 755 /var/lib/clouditera/data
                
                log_success "完全清理完成！"
                log_info "现在可以使用 '$0 start' 重新启动服务"
            else
                log_info "操作已取消"
            fi
            ;;
        3)
            log_info "操作已取消"
            ;;
        *)
            log_error "无效选择，操作已取消"
            ;;
    esac
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
            log_info "重启所有Storage服务..."
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
        clean)
            clean_data_directories
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
