#!/bin/bash

# 停止Storage目录下所有Docker Compose服务的脚本
# 作者: AI Assistant
# 版本: 1.0
# 日期: $(date +%Y-%m-%d)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志文件
LOG_FILE="storage-services-stop.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 日志函数
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS:${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

# 显示帮助信息
show_help() {
    echo "使用方法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -v, --verbose  详细输出模式"
    echo "  -f, --force    强制停止，即使服务已经停止"
    echo "  -r, --remove   停止后移除容器和网络"
    echo ""
    echo "示例:"
    echo "  $0              # 正常停止所有storage服务"
    echo "  $0 -v           # 详细模式停止"
    echo "  $0 -f           # 强制停止所有服务"
    echo "  $0 -r           # 停止并移除容器"
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

# 停止单个服务
stop_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local compose_file="$service_dir/docker-compose.yaml"
    
    if [[ ! -f "$compose_file" ]]; then
        log_warning "跳过 $service_name: 未找到 docker-compose.yaml 文件"
        return 1
    fi
    
    log "正在停止服务: $service_name"
    
    # 检查服务是否在运行
    if ! docker-compose -f "$compose_file" ps | grep -q "Up"; then
        if [[ "$FORCE" != "true" ]]; then
            log_warning "服务 $service_name 已经停止，跳过"
            return 0
        fi
    fi
    
    # 停止服务
    if [[ "$REMOVE" == "true" ]]; then
        if docker-compose -f "$compose_file" down; then
            log_success "服务 $service_name 停止并移除成功"
            return 0
        else
            log_error "服务 $service_name 停止并移除失败"
            return 1
        fi
    else
        if docker-compose -f "$compose_file" stop; then
            log_success "服务 $service_name 停止成功"
            return 0
        else
            log_error "服务 $service_name 停止失败"
            return 1
        fi
    fi
}

# 主函数
main() {
    # 解析命令行参数
    VERBOSE=false
    FORCE=false
    REMOVE=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
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
                log_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 记录脚本开始执行
    log "=========================================="
    log "开始停止Storage服务"
    log "工作目录: $(pwd)"
    log "详细模式: $VERBOSE"
    log "强制模式: $FORCE"
    log "移除模式: $REMOVE"
    log "=========================================="
    
    # 检查前置条件
    check_docker
    check_docker_compose
    
    # 获取storage目录的绝对路径
    STORAGE_DIR="$(pwd)/storage"
    if [[ ! -d "$STORAGE_DIR" ]]; then
        log_error "Storage目录不存在: $STORAGE_DIR"
        exit 1
    fi
    
    log "Storage目录: $STORAGE_DIR"
    
    # 统计变量
    total_services=0
    stopped_services=0
    failed_services=0
    skipped_services=0
    
    # 遍历storage目录下的所有子目录
    for service_dir in "$STORAGE_DIR"/*/; do
        if [[ -d "$service_dir" ]]; then
            total_services=$((total_services + 1))
            
            if stop_service "$service_dir"; then
                stopped_services=$((stopped_services + 1))
            else
                failed_services=$((failed_services + 1))
            fi
            
            # 在服务之间添加短暂延迟
            sleep 1
        fi
    done
    
    # 显示停止结果摘要
    log "=========================================="
    log "停止完成摘要:"
    log "总服务数: $total_services"
    log "成功停止: $stopped_services"
    log "停止失败: $failed_services"
    log "跳过服务: $skipped_services"
    log "=========================================="
    
    # 根据结果设置退出码
    if [[ $failed_services -eq 0 ]]; then
        log_success "所有Storage服务停止完成"
        exit 0
    else
        log_error "部分服务停止失败，请检查日志"
        exit 1
    fi
}

# 捕获中断信号
trap 'log_warning "脚本被用户中断"; exit 130' INT TERM

# 执行主函数
main "$@"
