#!/bin/bash

# ========================================
# AI Brain服务启动脚本
# 启动ai_brain目录下的所有Docker服务
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
AI_BRAIN_DIR="$PROJECT_ROOT/ai_brain"

# 日志文件
LOG_FILE="$PROJECT_ROOT/ai-brain-start.log"
ERROR_LOG_FILE="$PROJECT_ROOT/ai-brain-error.log"

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
    print_info "Docker Compose检查通过"
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
    
    if [ -f "$AI_BRAIN_DIR/base.env" ]; then
        print_success "发现环境配置文件 base.env"
    else
        print_error "未发现环境配置文件 base.env"
        return 1
    fi
    
    # 检查必要的环境变量
    if [ -z "$INSTALL_LOCAL" ]; then
        print_warning "INSTALL_LOCAL 环境变量未设置，使用默认值"
        export INSTALL_LOCAL="$PROJECT_ROOT"
    fi
    
    print_info "INSTALL_LOCAL: $INSTALL_LOCAL"
}

# 检查数据目录
check_data_directories() {
    print_info "检查数据目录..."
    
    local required_dirs=(
        "$INSTALL_LOCAL/ai_brain/app/storage"
        "$INSTALL_LOCAL/ai_brain/sandbox/dependencies"
        "$INSTALL_LOCAL/ai_brain/plugin_daemon"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            print_info "创建目录: $dir"
            mkdir -p "$dir"
        else
            print_success "目录存在: $dir"
        fi
    done
}

# 启动AI Brain服务
start_ai_brain() {
    print_info "正在启动AI Brain服务..."
    
    cd "$AI_BRAIN_DIR"
    
    # 检查配置文件
    if [ ! -f "docker-compose.yaml" ]; then
        print_error "docker-compose.yaml 文件不存在"
        return 1
    fi
    
    # 启动服务
    local compose_cmd=$(get_docker_compose_cmd)
    if $compose_cmd up -d; then
        print_success "AI Brain服务启动成功"
        
        # 等待服务启动
        local wait_time=${SERVICE_WAIT_TIME:-15}
        print_info "等待 $wait_time 秒让AI Brain服务完全启动..."
        sleep $wait_time
        
        # 检查服务状态
        if $compose_cmd ps | grep -q "Up"; then
            print_success "AI Brain服务运行正常"
            
            # 等待关键服务健康检查
            print_info "等待关键服务健康检查..."
            local health_check_attempts=0
            local max_attempts=15
            
            while [ $health_check_attempts -lt $max_attempts ]; do
                # 检查API服务
                if curl -s http://localhost:15001/health >/dev/null 2>&1; then
                    print_success "API服务健康检查通过"
                    break
                fi
                
                print_info "等待API服务健康检查... (尝试 $((health_check_attempts + 1))/$max_attempts)"
                sleep 3
                health_check_attempts=$((health_check_attempts + 1))
            done
            
            if [ $health_check_attempts -eq $max_attempts ]; then
                print_warning "API服务健康检查超时，但服务已启动"
            fi
        else
            print_warning "AI Brain服务可能未完全启动"
        fi
    else
        print_error "AI Brain服务启动失败"
        return 1
    fi
    
    cd - >/dev/null
}

# 停止AI Brain服务
stop_ai_brain() {
    print_info "正在停止AI Brain服务..."
    
    cd "$AI_BRAIN_DIR"
    
    local compose_cmd=$(get_docker_compose_cmd)
    if $compose_cmd down; then
        print_success "AI Brain服务停止成功"
    else
        print_warning "AI Brain服务停止时出现问题"
    fi
    
    cd - >/dev/null
}

# 显示服务状态
show_status() {
    print_info "AI Brain服务状态:"
    
    cd "$AI_BRAIN_DIR"
    
    local compose_cmd=$(get_docker_compose_cmd)
    $compose_cmd ps
    
    cd - >/dev/null
}

# 重启服务
restart_ai_brain() {
    print_header "重启AI Brain服务"
    stop_ai_brain
    sleep 8
    start_ai_brain
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
AI Brain服务管理脚本

使用方法:
  $0 <命令> [选项]

命令:
  start       启动AI Brain服务（默认）
  stop        停止AI Brain服务
  restart     重启AI Brain服务
  status      显示服务状态
  clean-logs  清理日志文件
  help        显示此帮助信息

选项:
  --no-log    不记录日志到文件
  --verbose   详细输出
  --wait-time <秒数>  设置服务启动等待时间（默认15秒）

示例:
  $0 start                    # 启动AI Brain服务
  $0 start --wait-time 20    # 设置等待时间为20秒
  $0 stop                     # 停止AI Brain服务
  $0 status                   # 查看服务状态
  $0 restart                  # 重启AI Brain服务

EOF
}

# 主函数
main() {
    # 解析命令行参数
    local command="start"
    local verbose=false
    SERVICE_WAIT_TIME="15"
    
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
    
    # 检查AI Brain目录
    if [ ! -d "$AI_BRAIN_DIR" ]; then
        print_error "AI Brain目录不存在: $AI_BRAIN_DIR"
        exit 1
    fi
    
    # 检查环境变量文件
    if ! check_env_files; then
        print_error "环境变量文件检查失败"
        exit 1
    fi
    
    # 检查数据目录
    check_data_directories
    
    # 执行命令
    case $command in
        start)
            print_header "开始启动AI Brain服务"
            if start_ai_brain; then
                print_success "AI Brain服务启动完成！"
                print_header "服务状态概览"
                show_status
            else
                print_error "AI Brain服务启动失败"
                exit 1
            fi
            ;;
        stop)
            print_header "停止AI Brain服务"
            stop_ai_brain
            ;;
        restart)
            restart_ai_brain
            ;;
        status)
            show_status
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
