#!/bin/bash

# ========================================
# Support服务启动脚本
# 自动启动support目录下的所有Docker服务
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
SUPPORT_DIR="$PROJECT_ROOT/support"

# 日志文件
LOG_FILE="$PROJECT_ROOT/support-services-start.log"
ERROR_LOG_FILE="$PROJECT_ROOT/support-services-error.log"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$ERROR_LOG_FILE"
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

# 检查Docker Compose是否可用
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
    local service_dir="$1"
    local service_name="$2"
    local compose_file="$3"
    
    # 使用全局等待时间变量，如果没有设置则使用默认值
    local default_wait_time=${SERVICE_WAIT_TIME:-8}
    
    print_info "正在启动服务: $service_name"
    
    cd "$service_dir"
    
    # 检查是否有.env文件
    if [ -f ".env" ]; then
        print_info "发现环境配置文件 .env"
    else
        print_warning "未发现环境配置文件 .env"
    fi
    
    # 启动服务
    local compose_cmd=$(get_docker_compose_cmd)
    if $compose_cmd -f "$compose_file" up -d; then
        print_success "服务 $service_name 启动成功"
        
        # 根据服务类型调整等待时间
        local wait_time=$default_wait_time
        case $service_name in
            "kong"|"nacos"|"rabbitmq")
                wait_time=$((default_wait_time + 7))  # 关键基础服务需要更长时间
                print_info "等待 $wait_time 秒让 $service_name 完全启动..."
                ;;
            *)
                print_info "等待 $wait_time 秒让 $service_name 启动..."
                ;;
        esac
        
        sleep $wait_time
        
        # 检查服务状态
        if $compose_cmd -f "$compose_file" ps | grep -q "Up"; then
            print_success "服务 $service_name 运行正常"
            
            # 对于有健康检查的服务，等待健康检查通过
            if [ "$service_name" = "kong" ]; then
                print_info "等待 Kong 迁移服务完成..."
                
                # 等待迁移服务完成
                local migration_wait_attempts=0
                local max_migration_attempts=20
                
                while [ $migration_wait_attempts -lt $max_migration_attempts ]; do
                    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "kong-migrations.*Exited.*0"; then
                        print_success "Kong 迁移服务已完成"
                        break
                    fi
                    print_info "等待 Kong 迁移服务... (尝试 $((migration_wait_attempts + 1))/$max_migration_attempts)"
                    sleep 5
                    migration_wait_attempts=$((migration_wait_attempts + 1))
                done
                
                if [ $migration_wait_attempts -eq $max_migration_attempts ]; then
                    print_warning "Kong 迁移服务等待超时，继续检查主服务"
                fi
                
                print_info "等待 Kong 健康检查通过..."
                local health_check_attempts=0
                local max_attempts=20
                
                while [ $health_check_attempts -lt $max_attempts ]; do
                    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "kong.*healthy"; then
                        print_success "Kong 健康检查通过"
                        break
                    fi
                    print_info "等待 Kong 健康检查... (尝试 $((health_check_attempts + 1))/$max_attempts)"
                    sleep 5
                    health_check_attempts=$((health_check_attempts + 1))
                done
                
                if [ $health_check_attempts -eq $max_attempts ]; then
                    print_warning "Kong 健康检查超时，但服务已启动"
                fi
            fi
        else
            print_warning "服务 $service_name 可能未完全启动"
        fi
    else
        print_error "服务 $service_name 启动失败"
        return 1
    fi
    
    cd - >/dev/null
}

# 停止单个服务
stop_service() {
    local service_dir="$1"
    local service_name="$2"
    local compose_file="$3"
    
    print_info "正在停止服务: $service_name"
    
    cd "$service_dir"
    
    local compose_cmd=$(get_docker_compose_cmd)
    if $compose_cmd -f "$compose_file" down; then
        print_success "服务 $service_name 停止成功"
    else
        print_warning "服务 $service_name 停止时出现问题"
    fi
    
    cd - >/dev/null
}

# 显示服务状态
show_service_status() {
    local service_dir="$1"
    local service_name="$2"
    local compose_file="$3"
    
    cd "$service_dir"
    
    local compose_cmd=$(get_docker_compose_cmd)
    print_info "服务 $service_name 状态:"
    $compose_cmd -f "$compose_file" ps
    
    cd - >/dev/null
}

# 显示启动配置
show_startup_config() {
    print_info "启动配置信息:"
    print_info "  服务等待时间: ${SERVICE_WAIT_TIME:-8} 秒"
    print_info "  失败时继续执行: $CONTINUE_ON_FAILURE"
    print_info "  详细输出: $verbose"
    echo ""
}

# 主启动函数
start_all_services() {
    print_header "开始启动Support服务"
    
    # 显示启动配置
    show_startup_config
    
    # 定义服务启动顺序（基础服务优先）
    local services=(
        "nacos:nacos:docker-compose.yaml"
        "rabbitmq:rabbitmq:docker-compose.yml"
        "kong:kong:docker-compose.yaml"
        "iam:iam:docker-compose.yml"
        "filems:filems:docker-compose.yml"
        "collabnet:collabnet:docker-compose.yml"
        "mineru:mineru:docker-compose.yml"
        "node_manager:node_manager:docker-compose.yml"
        "mineru_cpu:mineru_cpu:docker-compose.yml"
        "rag_service:rag_service:docker-compose.yml"
        "ragflow:ragflow:docker-compose.yml"
    )
    
    local failed_services=()
    local success_services=()
    local skipped_services=()
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name service_dir compose_file <<< "$service_info"
        local full_path="$SUPPORT_DIR/$service_dir"
        
        if [ -d "$full_path" ]; then
            if [ -f "$full_path/$compose_file" ]; then
                print_info "正在启动服务: $service_name"
                if start_service "$full_path" "$service_name" "$compose_file"; then
                    print_success "✓ $service_name 启动完成"
                    success_services+=("$service_name")
                else
                    print_error "✗ $service_name 启动失败"
                    failed_services+=("$service_name")
                    
                    # 如果启用了继续执行选项，则继续下一个服务
                    if [ "$CONTINUE_ON_FAILURE" = "true" ]; then
                        print_warning "继续执行下一个服务..."
                    else
                        print_error "服务启动失败，停止执行"
                        print_info "使用 --continue-on-failure 选项可以在失败时继续执行"
                        return 1
                    fi
                fi
            else
                print_warning "服务 $service_name 的配置文件 $compose_file 不存在"
                skipped_services+=("$service_name")
            fi
        else
            print_warning "服务目录 $service_dir 不存在"
            skipped_services+=("$service_name")
        fi
        
        # 在服务之间添加短暂延迟，确保前一个服务完全启动
        if [ "$service_name" != "ragflow" ]; then  # 最后一个服务不需要等待
            print_info "等待 3 秒后启动下一个服务..."
            sleep 3
        fi
        
        echo ""
    done
    
    # 显示启动结果摘要
    print_header "启动结果摘要"
    
    if [ ${#success_services[@]} -gt 0 ]; then
        print_success "成功启动的服务 (${#success_services[@]}): ${success_services[*]}"
    fi
    
    if [ ${#failed_services[@]} -gt 0 ]; then
        print_error "启动失败的服务 (${#failed_services[@]}): ${failed_services[*]}"
        print_info "请检查错误日志: $ERROR_LOG_FILE"
        
        # 如果启用了继续执行选项，显示成功状态
        if [ "$CONTINUE_ON_FAILURE" = "true" ]; then
            print_warning "部分服务启动失败，但已继续执行完成"
            if [ ${#success_services[@]} -gt 0 ]; then
                print_header "成功启动的服务状态概览"
                show_successful_services_status "${success_services[@]}"
            fi
        else
            print_error "启动失败，脚本已停止"
            return 1
        fi
    fi
    
    if [ ${#skipped_services[@]} -gt 0 ]; then
        print_warning "跳过的服务 (${#skipped_services[@]}): ${skipped_services[*]}"
    fi
    
    # 如果所有服务都成功启动，显示完整状态
    if [ ${#failed_services[@]} -eq 0 ] && [ ${#skipped_services[@]} -eq 0 ]; then
        print_success "所有服务启动完成！"
        print_header "服务状态概览"
        show_all_services_status
    fi
}

# 停止所有服务
stop_all_services() {
    print_header "停止所有Support服务"
    
    local services=(
        "mineru_cpu:mineru_cpu:docker-compose.yml"
        "rag_service:rag_service:docker-compose.yml"
        "ragflow:ragflow:docker-compose.yml"
        "node_manager:node_manager:docker-compose.yml"
        "mineru:mineru:docker-compose.yml"
        "collabnet:collabnet:docker-compose.yml"
        "filems:filems:docker-compose.yml"
        "iam:iam:docker-compose.yml"
        "kong:kong:docker-compose.yaml"
        "rabbitmq:rabbitmq:docker-compose.yml"
        "nacos:nacos:docker-compose.yaml"
    )
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name service_dir compose_file <<< "$service_info"
        local full_path="$SUPPORT_DIR/$service_dir"
        
        if [ -d "$full_path" ] && [ -f "$full_path/$compose_file" ]; then
            stop_service "$full_path" "$service_name" "$compose_file"
        fi
    done
    
    print_success "所有服务已停止"
}

# 重启所有服务
restart_all_services() {
    print_header "重启所有Support服务"
    stop_all_services
    sleep 8  # 增加等待时间，确保服务完全停止
    start_all_services
}

# 显示所有服务状态
show_all_services_status() {
    print_header "所有服务状态"
    
    local services=(
        "nacos:nacos:docker-compose.yaml"
        "rabbitmq:rabbitmq:docker-compose.yml"
        "kong:kong:docker-compose.yaml"
        "iam:iam:docker-compose.yml"
        "filems:filems:docker-compose.yml"
        "collabnet:collabnet:docker-compose.yml"
        "mineru:mineru:docker-compose.yml"
        "node_manager:node_manager:docker-compose.yml"
        "mineru_cpu:mineru_cpu:docker-compose.yml"
        "rag_service:rag_service:docker-compose.yml"
        "ragflow:ragflow:docker-compose.yml"
    )
    
    for service_info in "${services[@]}"; do
        IFS=':' read -r service_name service_dir compose_file <<< "$service_info"
        local full_path="$SUPPORT_DIR/$service_dir"
        
        if [ -d "$full_path" ] && [ -f "$full_path/$compose_file" ]; then
            show_service_status "$full_path" "$service_name" "$compose_file"
            echo ""
        fi
    done
}

# 显示成功启动的服务状态
show_successful_services_status() {
    local success_services=("$@")
    
    for service_name in "${success_services[@]}"; do
        # 根据服务名找到对应的配置
        case $service_name in
            "nacos")
                show_service_status "$SUPPORT_DIR/nacos" "$service_name" "docker-compose.yaml"
                ;;
            "rabbitmq")
                show_service_status "$SUPPORT_DIR/rabbitmq" "$service_name" "docker-compose.yml"
                ;;
            "kong")
                show_service_status "$SUPPORT_DIR/kong" "$service_name" "docker-compose.yaml"
                ;;
            "iam")
                show_service_status "$SUPPORT_DIR/iam" "$service_name" "docker-compose.yml"
                ;;
            "filems")
                show_service_status "$SUPPORT_DIR/filems" "$service_name" "docker-compose.yml"
                ;;
            "collabnet")
                show_service_status "$SUPPORT_DIR/collabnet" "$service_name" "docker-compose.yml"
                ;;
            "node_manager")
                show_service_status "$SUPPORT_DIR/node_manager" "$service_name" "docker-compose.yml"
                ;;
            "mineru_cpu")
                show_service_status "$SUPPORT_DIR/mineru_cpu" "$service_name" "docker-compose.yml"
                ;;
            "rag_service")
                show_service_status "$SUPPORT_DIR/rag_server" "$service_name" "docker-compose.yml"
                ;;
            "ragflow")
                show_service_status "$SUPPORT_DIR/ragflow" "$service_name" "docker-compose.yml"
                ;;
        esac
        echo ""
    done
}

# 清理日志
clean_logs() {
    print_info "清理日志文件..."
    rm -f "$LOG_FILE" "$ERROR_LOG_FILE"
    print_success "日志文件已清理"
}

# 显示帮助
show_help() {
    cat << EOF
Support服务管理脚本

使用方法:
  $0 <命令> [选项]

命令:
  start       启动所有服务（默认）
  stop        停止所有服务
  restart     重启所有服务
  status      显示所有服务状态
  clean-logs  清理日志文件
  help        显示此帮助信息

选项:
  --no-log    不记录日志到文件
  --verbose   详细输出
  --continue-on-failure  启动失败时继续执行，不退出
  --wait-time <秒数>  设置服务启动等待时间（默认8秒）

示例:
  $0 start                    # 启动所有服务
  $0 start --continue-on-failure  # 启动失败时继续执行
  $0 start --wait-time 10    # 设置等待时间为10秒
  $0 stop                     # 停止所有服务
  $0 status                   # 查看服务状态
  $0 restart                  # 重启所有服务

EOF
}

# 主函数
main() {
    # 解析命令行参数
    local command="start"
    local verbose=false
    CONTINUE_ON_FAILURE="false"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            start|stop|restart|status|clean-logs|help)
                command="$1"
                shift
                ;;
            --verbose)
                verbose=true
                shift
                ;;
            --no-log)
                LOG_FILE="/dev/null"
                ERROR_LOG_FILE="/dev/null"
                shift
                ;;
            --continue-on-failure)
                CONTINUE_ON_FAILURE="true"
                print_info "启用失败时继续执行模式"
                shift
                ;;
            --wait-time)
                if [[ $# -gt 1 && $2 =~ ^[0-9]+$ ]]; then
                    SERVICE_WAIT_TIME="$2"
                    print_info "设置服务启动等待时间为 $SERVICE_WAIT_TIME 秒"
                    shift 2
                else
                    print_error "--wait-time 需要指定一个数字"
                    exit 1
                fi
                ;;
            -h|--help)
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
    
    # 如果是help命令，直接显示帮助信息
    if [ "$command" = "help" ]; then
        show_help
        exit 0
    fi
    
    # 创建日志目录
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # 记录启动时间
    echo "=========================================" >> "$LOG_FILE"
    echo "脚本启动时间: $(date)" >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
    
    # 检查环境
    check_docker
    check_docker_compose
    
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
        clean-logs)
            clean_logs
            ;;
        *)
            print_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
