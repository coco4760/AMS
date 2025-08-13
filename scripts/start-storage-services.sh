#!/bin/bash

# 启动Storage目录下所有Docker Compose服务的脚本
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
LOG_FILE="storage-services.log"
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
    echo "  -f, --force    强制启动，即使服务已经在运行"
    echo ""
    echo "示例:"
    echo "  $0              # 正常启动所有storage服务"
    echo "  $0 -v           # 详细模式启动"
    echo "  $0 -f           # 强制启动所有服务"
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
    
    # 设置目录权限
    sudo chmod -R 755 "$data_root"
    
    log_success "数据目录准备完成"
}

# 清理有问题的数据目录
clean_problematic_directories() {
    local data_root="/var/lib/clouditera/data"
    
    log "检查并清理有问题的数据目录..."
    
    # 检查MySQL数据目录
    local mysql_data_dir="$data_root/mysql/data"
    if [[ -d "$mysql_data_dir" ]] && [[ "$(ls -A "$mysql_data_dir" 2>/dev/null)" ]]; then
        log_warning "MySQL数据目录不为空，需要清理..."
        
        # 检查是否包含真实的数据库数据
        if [[ -d "$mysql_data_dir/mysql" ]] || [[ -d "$mysql_data_dir/sys" ]] || [[ -d "$mysql_data_dir/performance_schema" ]]; then
            local backup_dir="$data_root/backups/mysql_$(date +%Y%m%d_%H%M%S)"
            log "检测到MySQL数据库数据，备份到: $backup_dir"
            sudo mkdir -p "$(dirname "$backup_dir")"
            sudo mv "$mysql_data_dir" "$backup_dir"
            log_success "MySQL数据已备份到: $backup_dir"
        else
            log "MySQL数据目录为空或只包含临时文件，直接清理..."
            sudo rm -rf "$mysql_data_dir"/*
        fi
        
        # 重新创建目录
        sudo mkdir -p "$mysql_data_dir"
        sudo chown 999:999 "$mysql_data_dir"
        sudo chmod 755 "$mysql_data_dir"
        log_success "MySQL数据目录清理完成"
    fi
    
    # 检查其他可能有问题的服务
    local services=("es" "redis" "mongo" "postgres" "minio" "qdrant")
    for service in "${services[@]}"; do
        local service_data_dir="$data_root/$service/data"
        if [[ -d "$service_data_dir" ]] && [[ "$(ls -A "$service_data_dir" 2>/dev/null)" ]]; then
            # 检查是否有锁文件或损坏的索引
            if [[ "$service" == "es" ]]; then
                # 检查Elasticsearch锁文件
                if sudo find "$service_data_dir" -name "node.lock" 2>/dev/null | grep -q .; then
                    log_warning "发现Elasticsearch锁文件，清理中..."
                    sudo find "$service_data_dir" -name "node.lock" -delete 2>/dev/null || true
                fi
                
                # 检查是否有真实的索引数据
                if sudo find "$service_data_dir" -name "*.cfe" -o -name "*.cfs" 2>/dev/null | grep -q .; then
                    log "检测到Elasticsearch索引数据，保留数据..."
                fi
            fi
            
            # 检查Redis数据文件
            if [[ "$service" == "redis" ]] && [[ -f "$service_data_dir/dump.rdb" ]]; then
                log "检测到Redis数据文件，保留数据..."
            fi
            
            # 检查MongoDB数据
            if [[ "$service" == "mongo" ]] && [[ -d "$service_data_dir/admin" ]] || [[ -d "$service_data_dir/local" ]]; then
                log "检测到MongoDB数据，保留数据..."
            fi
        fi
    done
    
    log_success "问题数据目录清理完成"
}

# 启动单个服务
start_service() {
    local service_dir="$1"
    local service_name=$(basename "$service_dir")
    local compose_file="$service_dir/docker-compose.yaml"
    
    if [[ ! -f "$compose_file" ]]; then
        log_warning "跳过 $service_name: 未找到 docker-compose.yaml 文件"
        return 1
    fi
    
    log "正在启动服务: $service_name"
    
    # 检查服务是否已经在运行
    if [[ "$FORCE" != "true" ]]; then
        if docker-compose -f "$compose_file" ps | grep -q "Up"; then
            log_warning "服务 $service_name 已经在运行，跳过启动"
            return 0
        fi
    fi
    
    # 启动服务
    if docker-compose -f "$compose_file" up -d; then
        log_success "服务 $service_name 启动成功"
        return 0
    else
        log_error "服务 $service_name 启动失败"
        return 1
    fi
}

# 主函数
main() {
    # 解析命令行参数
    VERBOSE=false
    FORCE=false
    
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
            *)
                log_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 记录脚本开始执行
    log "=========================================="
    log "开始启动Storage服务"
    log "工作目录: $(pwd)"
    log "详细模式: $VERBOSE"
    log "强制模式: $FORCE"
    log "=========================================="
    
    # 检查前置条件
    check_docker
    check_docker_compose
    
    # 准备数据目录
    prepare_data_directories
    
    # 清理有问题的数据目录
    clean_problematic_directories
    
    # 获取storage目录的绝对路径
    STORAGE_DIR="$(pwd)/storage"
    if [[ ! -d "$STORAGE_DIR" ]]; then
        log_error "Storage目录不存在: $STORAGE_DIR"
        exit 1
    fi
    
    log "Storage目录: $STORAGE_DIR"
    
    # 统计变量
    total_services=0
    started_services=0
    failed_services=0
    skipped_services=0
    
    # 遍历storage目录下的所有子目录
    for service_dir in "$STORAGE_DIR"/*/; do
        if [[ -d "$service_dir" ]]; then
            total_services=$((total_services + 1))
            
            if start_service "$service_dir"; then
                started_services=$((started_services + 1))
            else
                failed_services=$((failed_services + 1))
            fi
            
            # 在服务之间添加短暂延迟
            sleep 1
        fi
    done
    
    # 显示启动结果摘要
    log "=========================================="
    log "启动完成摘要:"
    log "总服务数: $total_services"
    log "成功启动: $started_services"
    log "启动失败: $failed_services"
    log "跳过服务: $skipped_services"
    log "=========================================="
    
    # 显示所有运行中的服务状态
    log "当前运行中的服务状态:"
    for service_dir in "$STORAGE_DIR"/*/; do
        if [[ -d "$service_dir" ]]; then
            local service_name=$(basename "$service_dir")
            local compose_file="$service_dir/docker-compose.yaml"
            
            if [[ -f "$compose_file" ]]; then
                echo ""
                log "服务: $service_name"
                docker-compose -f "$compose_file" ps
            fi
        fi
    done
    
    # 根据结果设置退出码
    if [[ $failed_services -eq 0 ]]; then
        log_success "所有Storage服务启动完成"
        exit 0
    else
        log_error "部分服务启动失败，请检查日志"
        exit 1
    fi
}

# 捕获中断信号
trap 'log_warning "脚本被用户中断"; exit 130' INT TERM

# 执行主函数
main "$@"
