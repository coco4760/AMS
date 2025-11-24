#!/bin/bash
# common.sh - 部署脚本通用函数库

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 脚本目录（获取脚本所在目录的绝对路径）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 默认配置
DEFAULT_OLD_IP="192.168.34.7"
DATA_ROOT="/var/lib/clouditera/data"

# ========================================
# 日志输出函数
# ========================================
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📌 $1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# ========================================
# 依赖检查函数
# ========================================
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker 未安装，请先安装 Docker"
        return 1
    fi
    log_success "Docker 已安装: $(docker --version)"
    return 0
}

check_docker_compose() {
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose 未安装，请先安装 Docker Compose"
        return 1
    fi
    if docker compose version &> /dev/null; then
        log_success "Docker Compose 已安装: $(docker compose version)"
    else
        log_success "Docker Compose 已安装: $(docker-compose --version)"
    fi
    return 0
}

check_cpu_avx() {
    # 检查 CPU 是否支持 AVX 指令集
    if grep -q avx /proc/cpuinfo 2>/dev/null; then
        return 0  # 支持 AVX
    else
        return 1  # 不支持 AVX
    fi
}

fix_elasticsearch_permissions() {
    # 修复 Elasticsearch 数据目录权限
    # Elasticsearch 需要以 uid:gid 1000:1000 运行
    local data_root="${1:-$DATA_ROOT}"
    local es_data_dir="$data_root/es/data"
    local es_plugins_dir="$data_root/es/plugins"
    
    if [ ! -d "$es_data_dir" ]; then
        mkdir -p "$es_data_dir"
    fi
    
    if [ ! -d "$es_plugins_dir" ]; then
        mkdir -p "$es_plugins_dir"
    fi
    
    log_info "修复 Elasticsearch 数据目录权限..."
    
    # 尝试使用 chown 设置权限（需要 root 权限）
    if chown -R 1000:1000 "$es_data_dir" "$es_plugins_dir" 2>/dev/null; then
        log_success "Elasticsearch 目录权限已修复"
        return 0
    else
        # 如果 chown 失败，提示用户手动执行
        log_warning "无法自动修复 Elasticsearch 目录权限（需要 root 权限）"
        log_warning "请手动执行以下命令："
        log_warning "  sudo chown -R 1000:1000 $es_data_dir $es_plugins_dir"
        log_warning "  sudo chmod -R 755 $es_data_dir $es_plugins_dir"
        return 1
    fi
}

fix_postgres_permissions() {
    # 修复 PostgreSQL 数据目录权限
    # PostgreSQL 需要以 uid:gid 999:999 运行
    local data_root="${1:-$DATA_ROOT}"
    local pg_data_dir="$data_root/pgdata"
    
    if [ ! -d "$pg_data_dir" ]; then
        mkdir -p "$pg_data_dir"
    fi
    
    log_info "修复 PostgreSQL 数据目录权限..."
    
    # 尝试使用 chown 设置权限（需要 root 权限）
    # 递归修复所有文件和目录
    if chown -R 999:999 "$pg_data_dir" 2>/dev/null && \
       find "$pg_data_dir" -type f -exec chmod 600 {} \; 2>/dev/null && \
       find "$pg_data_dir" -type d -exec chmod 700 {} \; 2>/dev/null; then
        log_success "PostgreSQL 目录权限已修复"
        return 0
    else
        # 如果 chown 失败，提示用户手动执行
        log_warning "无法自动修复 PostgreSQL 目录权限（需要 root 权限）"
        log_warning "请手动执行以下命令："
        log_warning "  sudo chown -R 999:999 $pg_data_dir"
        log_warning "  sudo find $pg_data_dir -type f -exec chmod 600 {} \\;"
        log_warning "  sudo find $pg_data_dir -type d -exec chmod 700 {} \\;"
        return 1
    fi
}

check_dependencies() {
    log_step "检查系统依赖"
    local failed=0
    
    if ! check_docker; then
        failed=1
    fi
    
    if ! check_docker_compose; then
        failed=1
    fi
    
    # 检查 CPU AVX 支持（用于 MongoDB 5.0+）
    if ! check_cpu_avx; then
        log_warning "当前 CPU 不支持 AVX 指令集"
        log_warning "MongoDB 5.0+ 需要 AVX 支持，建议使用 MongoDB 4.4 或更低版本"
    fi
    
    if [ $failed -eq 1 ]; then
        log_error "依赖检查失败，请先安装必要的依赖"
        return 1
    fi
    
    return 0
}

# ========================================
# IP 地址相关函数
# ========================================
get_local_ips() {
    # 获取所有非回环的 IPv4 地址
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | sort -u
}

select_ip() {
    log_step "配置服务器 IP 地址"
    
    local old_ip="${1:-$DEFAULT_OLD_IP}"
    local local_ips=($(get_local_ips))
    
    echo -e "${BLUE}当前配置中的 IP 地址: ${YELLOW}$old_ip${NC}"
    echo ""
    
    if [ ${#local_ips[@]} -eq 0 ]; then
        log_warning "未检测到本机 IP 地址"
        read -p "请输入本机 IP 地址: " new_ip
    else
        echo -e "${BLUE}检测到的本机 IP 地址:${NC}"
        local idx=1
        for ip in "${local_ips[@]}"; do
            echo -e "  ${CYAN}[$idx]${NC} $ip"
            idx=$((idx + 1))
        done
        echo -e "  ${CYAN}[$idx]${NC} 手动输入"
        echo ""
        
        read -p "请选择 IP 地址 (1-${#local_ips[@]}, $idx 为手动输入): " choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#local_ips[@]}" ]; then
            new_ip="${local_ips[$((choice - 1))]}"
        elif [ "$choice" -eq $idx ]; then
            read -p "请输入本机 IP 地址: " new_ip
        else
            log_error "无效的选择"
            return 1
        fi
    fi
    
    # 验证 IP 地址格式
    if ! [[ "$new_ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_error "IP 地址格式不正确: $new_ip"
        return 1
    fi
    
    if [ "$old_ip" = "$new_ip" ]; then
        log_info "IP 地址未变化，跳过替换"
        return 0
    fi
    
    echo ""
    log_info "准备将配置中的 IP 地址从 $old_ip 替换为 $new_ip"
    read -p "确认继续？(y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        log_warning "操作已取消"
        return 1
    fi
    
    # 调用 replace-ip.sh 脚本
    log_info "执行 IP 地址替换..."
    if bash "$SCRIPT_DIR/replace-ip.sh" "$old_ip" "$new_ip"; then
        log_success "IP 地址替换完成"
        return 0
    else
        log_error "IP 地址替换失败"
        return 1
    fi
}

# ========================================
# 数据目录创建函数
# ========================================
create_data_directories() {
    log_step "创建数据目录"
    
    local data_root="${1:-$DATA_ROOT}"
    
    log_info "数据根目录: $data_root"
    
    # 定义需要创建的目录结构
    local dirs=(
        # AI Brain 相关
        "$data_root/ai_brain/app/storage"
        "$data_root/ai_brain/sandbox/dependencies"
        
        # 数据库相关
        "$data_root/mysql"
        "$data_root/pgdata"
        "$data_root/mongod"
        
        # 存储相关
        "$data_root/redis"
        "$data_root/minioData"
        "$data_root/qdrant"
        "$data_root/es/data"
        "$data_root/es/plugins"
        "$data_root/rabbitmq"
        
        # RAG 相关
        "$data_root/rag_service/postgres-data"
        "$data_root/rag_service/redis-data"
        "$data_root/rag_service/qdrant-data"
        "$data_root/rag_service/data"
        
        # 其他
        "$data_root/wuji/volumes/webide/code"
    )
    
    local created=0
    local skipped=0
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_info "目录已存在: $dir"
            skipped=$((skipped + 1))
        else
            if mkdir -p "$dir"; then
                log_success "创建目录: $dir"
                created=$((created + 1))
            else
                log_error "创建目录失败: $dir"
            fi
        fi
    done
    
    # 设置权限（尝试，如果失败则提示用户）
    if chown -R "$(whoami):$(whoami)" "$data_root" 2>/dev/null; then
        log_success "设置目录权限完成"
    else
        log_warning "无法自动设置目录权限，请手动执行: sudo chown -R \$(whoami):\$(whoami) $data_root"
    fi
    
    echo ""
    log_info "目录创建统计: 新建 $created 个，已存在 $skipped 个"
    
    return 0
}

# ========================================
# 确认函数
# ========================================
confirm_action() {
    local message="$1"
    read -p "$message (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]]
}

# ========================================
# 组件部署函数（由子脚本调用）
# ========================================
deploy_component() {
    local component_name="$1"
    local component_dir="$2"
    local compose_file="${3:-docker-compose.yaml}"
    
    log_step "部署组件: $component_name"
    
    if [ ! -d "$component_dir" ]; then
        log_error "组件目录不存在: $component_dir"
        return 1
    fi
    
    cd "$component_dir" || return 1
    
    # 检查 compose 文件
    if [ ! -f "$compose_file" ] && [ ! -f "docker-compose.yml" ]; then
        log_error "未找到 docker-compose 文件"
        return 1
    fi
    
    # 使用 docker compose 或 docker-compose
    local compose_cmd
    if docker compose version &> /dev/null; then
        compose_cmd="docker compose"
    else
        compose_cmd="docker-compose"
    fi
    
    # 设置环境变量（如果未设置）
    export INSTALL_LOCAL="${INSTALL_LOCAL:-$DATA_ROOT}"
    
    log_info "启动服务..."
    if $compose_cmd up -d; then
        log_success "组件 $component_name 部署成功"
        
        # 显示服务状态
        log_info "服务状态:"
        $compose_cmd ps
        
        return 0
    else
        log_error "组件 $component_name 部署失败"
        return 1
    fi
}

# ========================================
# 检查服务健康状态
# ========================================
check_service_health() {
    local service_name="$1"
    local health_url="$2"
    local max_attempts="${3:-10}"
    local interval="${4:-3}"
    
    log_info "检查服务 $service_name 健康状态..."
    
    for i in $(seq 1 $max_attempts); do
        if curl -sf "$health_url" > /dev/null 2>&1; then
            log_success "服务 $service_name 已就绪"
            return 0
        fi
        if [ $i -lt $max_attempts ]; then
            log_info "等待服务启动... ($i/$max_attempts)"
            sleep $interval
        fi
    done
    
    log_warning "服务 $service_name 健康检查超时"
    return 1
}

