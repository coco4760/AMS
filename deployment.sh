#!/bin/bash

# ========================================
# 统一部署脚本
# 支持一键启动所有服务或分别启动不同服务组
# ========================================

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
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# 日志文件
LOG_FILE="$SCRIPT_DIR/deployment.log"
ERROR_LOG_FILE="$SCRIPT_DIR/deployment-error.log"

# 全局变量
VERBOSE=false
DRY_RUN=false
SKIP_CHECKS=false

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

print_step() {
    echo -e "${CYAN}📋 $1${NC}"
}

# 检查环境
check_environment() {
    print_step "检查部署环境..."
    
    # 检查Docker
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker未运行，请先启动Docker服务"
        return 1
    fi
    print_success "Docker服务检查通过"
    
    # 检查Docker Compose
    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        print_error "Docker Compose未安装或不可用"
        return 1
    fi
    print_success "Docker Compose检查通过"
    
    # 检查脚本目录
    if [ ! -d "$SCRIPTS_DIR" ]; then
        print_error "脚本目录不存在: $SCRIPTS_DIR"
        return 1
    fi
    print_success "脚本目录检查通过"
    
    # 检查必要的脚本文件
    local required_scripts=(
        "start-support-services.sh"
        "start-ai-brain.sh"
        "start-services.sh"
    )
    
    for script in "${required_scripts[@]}"; do
        if [ ! -f "$SCRIPTS_DIR/$script" ]; then
            print_warning "脚本文件不存在: $script"
        else
            print_success "脚本文件检查通过: $script"
        fi
    done
    
    return 0
}

# 启动基础服务
start_support_services() {
    print_step "启动基础服务 (Support Services)..."
    
    if [ "$DRY_RUN" = "true" ]; then
        print_info "模拟执行: ./scripts/quick-support.sh start"
        return 0
    fi
    
    if ./scripts/quick-support.sh start; then
        print_success "基础服务启动成功"
        return 0
    else
        print_error "基础服务启动失败"
        return 1
    fi
}

# 启动AI Brain服务
start_ai_brain() {
    print_step "启动AI Brain服务..."
    
    if [ "$DRY_RUN" = "true" ]; then
        print_info "模拟执行: ./scripts/quick-ai-brain.sh start"
        return 0
    fi
    
    if ./scripts/quick-ai-brain.sh start; then
        print_success "AI Brain服务启动成功"
        return 0
    else
        print_error "AI Brain服务启动失败"
        return 1
    fi
}

# 启动业务服务
start_business_services() {
    print_step "启动业务服务 (Services)..."
    
    if [ "$DRY_RUN" = "true" ]; then
        print_info "模拟执行: ./scripts/quick-services.sh start"
        return 0
    fi
    
    if ./scripts/quick-services.sh start; then
        print_success "业务服务启动成功"
        return 0
    else
        print_error "业务服务启动失败"
        return 1
    fi
}

# 启动插件服务
start_plugin_services() {
    print_step "启动插件服务 (Plugins)..."
    
    if [ "$DRY_RUN" = "true" ]; then
        print_info "模拟执行: ./scripts/quick-plugins.sh start"
        return 0
    fi
    
    if ./scripts/quick-plugins.sh start; then
        print_success "插件服务启动成功"
        return 0
    else
        print_error "插件服务启动失败"
        return 1
    fi
}

# 启动存储服务
start_storage_services() {
    print_step "启动存储服务 (Storage)..."
    
    if [ "$DRY_RUN" = "true" ]; then
        print_info "模拟执行: ./scripts/quick-storage.sh start"
        return 0
    fi
    
    if ./scripts/quick-storage.sh start; then
        print_success "存储服务启动成功"
        return 0
    else
        print_error "存储服务启动失败"
        return 1
    fi
}

# 一键启动所有服务
start_all_services() {
    print_header "开始一键启动所有服务"
    
    local failed_services=()
    local success_services=()
    
    # 1. 启动存储服务
    if start_storage_services; then
        success_services+=("存储服务")
        print_info "等待存储服务稳定运行..."
        sleep 15
    else
        failed_services+=("存储服务")
        print_warning "存储服务启动失败，继续部署其他服务"
    fi
    
    # 2. 启动基础服务
    if start_support_services; then
        success_services+=("基础服务")
        print_info "等待基础服务稳定运行..."
        sleep 30
    else
        failed_services+=("基础服务")
        print_error "基础服务启动失败，停止部署"
        return 1
    fi
    
    # 3. 启动插件服务
    if start_plugin_services; then
        success_services+=("插件服务")
        print_info "等待插件服务稳定运行..."
        sleep 15
    else
        failed_services+=("插件服务")
        print_warning "插件服务启动失败，继续部署其他服务"
    fi
    
    # 4. 启动AI Brain服务
    if start_ai_brain; then
        success_services+=("AI Brain服务")
        print_info "等待AI Brain服务稳定运行..."
        sleep 20
    else
        failed_services+=("AI Brain服务")
        print_warning "AI Brain服务启动失败，继续部署其他服务"
    fi
    
    # 5. 启动业务服务
    if start_business_services; then
        success_services+=("业务服务")
    else
        failed_services+=("业务服务")
        print_warning "业务服务启动失败，继续部署其他服务"
    fi
    
    # 显示部署结果
    print_header "部署结果摘要"
    
    if [ ${#success_services[@]} -gt 0 ]; then
        print_success "成功启动的服务 (${#success_services[@]}): ${success_services[*]}"
    fi
    
    if [ ${#failed_services[@]} -gt 0 ]; then
        print_error "启动失败的服务 (${#failed_services[@]}): ${failed_services[*]}"
        print_info "请检查错误日志: $ERROR_LOG_FILE"
    fi
    
    if [ ${#failed_services[@]} -eq 0 ]; then
        print_success "🎉 所有服务启动完成！"
    else
        print_warning "⚠️  部分服务启动失败，但部署已继续完成"
    fi
    
    return 0
}

# 停止所有服务
stop_all_services() {
    print_header "停止所有服务"
    
    print_step "停止业务服务..."
    ./scripts/start-services.sh stop 2>/dev/null || true
    
    print_step "停止AI Brain服务..."
    ./scripts/start-ai-brain.sh stop 2>/dev/null || true
    
    print_step "停止插件服务..."
    ./scripts/start-plugins-services.sh stop 2>/dev/null || true
    
    print_step "停止基础服务..."
    ./scripts/start-support-services.sh stop 2>/dev/null || true
    
    print_step "停止存储服务..."
    # 存储服务脚本没有stop命令，使用docker-compose直接停止
    cd storage/mysql && docker-compose down 2>/dev/null || true
    cd ../redis && docker-compose down 2>/dev/null || true
    cd ../es && docker-compose down 2>/dev/null || true
    cd ../mongo && docker-compose down 2>/dev/null || true
    cd ../postgres && docker-compose down 2>/dev/null || true
    cd ../minio && docker-compose down 2>/dev/null || true
    cd ../qdrant && docker-compose down 2>/dev/null || true
    cd ../../
    
    print_success "所有服务已停止"
}

# 重启所有服务
restart_all_services() {
    print_header "重启所有服务"
    stop_all_services
    sleep 10
    start_all_services
}

# 显示服务状态
show_all_status() {
    print_header "所有服务状态"
    
    print_step "存储服务状态:"
    ./scripts/start-storage-services.sh status 2>/dev/null || print_warning "无法获取存储服务状态"
    
    echo ""
    print_step "基础服务状态:"
    ./scripts/start-support-services.sh status 2>/dev/null || print_warning "无法获取基础服务状态"
    
    echo ""
    print_step "插件服务状态:"
    ./scripts/start-plugins-services.sh status 2>/dev/null || print_warning "无法获取插件服务状态"
    
    echo ""
    print_step "AI Brain服务状态:"
    ./scripts/start-ai-brain.sh status 2>/dev/null || print_warning "无法获取AI Brain服务状态"
    
    echo ""
    print_step "业务服务状态:"
    ./scripts/start-services.sh status 2>/dev/null || print_warning "无法获取业务服务状态"
}

# 快速启动选项
quick_start() {
    local service_type="$1"
    
    case $service_type in
        "support"|"base")
            print_header "快速启动基础服务"
            start_support_services
            ;;
        "ai"|"ai_brain"|"brain")
            print_header "快速启动AI Brain服务"
            start_ai_brain
            ;;
        "business"|"services")
            print_header "快速启动业务服务"
            start_business_services
            ;;
        "plugins")
            print_header "快速启动插件服务"
            start_plugin_services
            ;;
        "storage")
            print_header "快速启动存储服务"
            start_storage_services
            ;;
        *)
            print_error "未知的服务类型: $service_type"
            print_info "支持的类型: support, ai_brain, business, plugins, storage"
            return 1
            ;;
    esac
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
统一部署脚本

使用方法:
  $0 <命令> [选项]

命令:
  start       一键启动所有服务（默认）
  stop        停止所有服务
  restart     重启所有服务
  status      显示所有服务状态
  quick <类型> 快速启动指定类型的服务
  clean-logs  清理日志文件
  help        显示此帮助信息

快速启动类型:
  storage     存储服务 (Storage)
  support     基础服务 (Support Services)
  plugins     插件服务 (Plugins)
  ai_brain    AI Brain服务
  business    业务服务 (Services)

选项:
  --verbose   详细输出
  --dry-run   模拟执行，不实际启动服务
  --skip-checks  跳过环境检查
  --no-log    不记录日志到文件

示例:
  $0 start                    # 一键启动所有服务
  $0 quick storage           # 快速启动存储服务
  $0 quick support           # 快速启动基础服务
  $0 quick plugins           # 快速启动插件服务
  $0 quick ai_brain          # 快速启动AI Brain服务
  $0 quick business          # 快速启动业务服务
  $0 stop                    # 停止所有服务
  $0 status                  # 查看所有服务状态
  $0 restart                 # 重启所有服务
  $0 --dry-run start         # 模拟启动所有服务

EOF
}

# 主函数
main() {
    # 解析命令行参数
    local command="start"
    local quick_type=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            start|stop|restart|status|clean-logs|help)
                command="$1"
                shift
                ;;
            quick)
                if [[ $# -gt 1 ]]; then
                    quick_type="$2"
                    command="quick"
                    shift 2
                else
                    print_error "--quick 需要指定服务类型"
                    exit 1
                fi
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                print_info "启用模拟执行模式"
                shift
                ;;
            --skip-checks)
                SKIP_CHECKS=true
                print_info "跳过环境检查"
                shift
                ;;
            --no-log)
                LOG_FILE="/dev/null"
                ERROR_LOG_FILE="/dev/null"
                shift
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
    echo "部署脚本启动时间: $(date)" >> "$LOG_FILE"
    echo "=========================================" >> "$LOG_FILE"
    
    # 检查环境（除非跳过）
    if [ "$SKIP_CHECKS" != "true" ]; then
        if ! check_environment; then
            print_error "环境检查失败，退出部署"
            exit 1
        fi
    fi
    
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
            show_all_status
            ;;
        quick)
            if [ -n "$quick_type" ]; then
                quick_start "$quick_type"
            else
                print_error "快速启动需要指定服务类型"
                show_help
                exit 1
            fi
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
