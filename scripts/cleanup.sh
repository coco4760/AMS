#!/bin/bash
# cleanup.sh - SecCortex 环境清理脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ========================================
# 清理选项
# ========================================
CLEAN_CONTAINERS=true
CLEAN_DATA=true
CLEAN_IMAGES=false
CLEAN_VOLUMES=false
CLEAN_NETWORKS=false

# ========================================
# 显示清理菜单
# ========================================
show_cleanup_menu() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║            SecCortex 环境清理脚本                         ║
║                                                           ║
║              警告：此操作不可逆！                          ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    log_warning "⚠️  警告：清理操作将删除以下内容，且不可恢复！"
    echo ""
    
    echo -e "${BLUE}清理选项:${NC}"
    echo -e "  ${CYAN}[1]${NC} 清理容器 (停止并删除所有 SecCortex 相关容器)"
    echo -e "  ${CYAN}[2]${NC} 清理数据目录 (删除所有数据文件: $DATA_ROOT)"
    echo -e "  ${CYAN}[3]${NC} 清理镜像 (删除所有 SecCortex 相关镜像)"
    echo -e "  ${CYAN}[4]${NC} 清理卷 (删除所有未使用的 Docker 卷)"
    echo -e "  ${CYAN}[5]${NC} 清理网络 (删除所有未使用的 Docker 网络)"
    echo -e "  ${CYAN}[6]${NC} 全部清理 (上述所有选项)"
    echo -e "  ${CYAN}[0]${NC} 退出"
    echo ""
    
    read -p "请选择要清理的内容 (可多选，用逗号分隔，如: 1,2,3): " selections
    
    if [ -z "$selections" ] || [ "$selections" = "0" ]; then
        log_info "清理已取消"
        exit 0
    fi
    
    # 重置选项
    CLEAN_CONTAINERS=false
    CLEAN_DATA=false
    CLEAN_IMAGES=false
    CLEAN_VOLUMES=false
    CLEAN_NETWORKS=false
    
    # 解析选择
    IFS=',' read -ra SELECTED <<< "$selections"
    
    for sel in "${SELECTED[@]}"; do
        case "$sel" in
            1) CLEAN_CONTAINERS=true ;;
            2) CLEAN_DATA=true ;;
            3) CLEAN_IMAGES=true ;;
            4) CLEAN_VOLUMES=true ;;
            5) CLEAN_NETWORKS=true ;;
            6) 
                CLEAN_CONTAINERS=true
                CLEAN_DATA=true
                CLEAN_IMAGES=true
                CLEAN_VOLUMES=true
                CLEAN_NETWORKS=true
                ;;
            *) log_warning "无效的选择: $sel，已跳过" ;;
        esac
    done
    
    # 显示将要清理的内容
    show_cleanup_summary
}

# ========================================
# 显示清理摘要
# ========================================
show_cleanup_summary() {
    echo ""
    log_step "清理内容摘要"
    
    local items=()
    
    if [ "$CLEAN_CONTAINERS" = true ]; then
        # 统计容器数量（简化版，实际清理时会更准确）
        local container_count=$(docker ps -a --filter "name=secCortex\|cortex\|wuji\|rag\|dify\|kong\|keycloak\|nacos\|minio\|qdrant\|elasticsearch\|mysql\|postgres\|redis\|mongo\|rabbitmq\|clouditera" --format "{{.Names}}" 2>/dev/null | wc -l)
        items+=("容器 (约 $container_count 个)")
    fi
    
    if [ "$CLEAN_DATA" = true ]; then
        if [ -d "$DATA_ROOT" ]; then
            local data_size=$(du -sh "$DATA_ROOT" 2>/dev/null | cut -f1 || echo "未知")
            items+=("数据目录 ($DATA_ROOT, 大小: $data_size)")
        else
            items+=("数据目录 ($DATA_ROOT, 不存在)")
        fi
    fi
    
    if [ "$CLEAN_IMAGES" = true ]; then
        local image_count=$(docker images --filter "reference=rd.clouditera.com/*" --format "{{.Repository}}:{{.Tag}}" 2>/dev/null | wc -l)
        items+=("镜像 ($image_count 个)")
    fi
    
    if [ "$CLEAN_VOLUMES" = true ]; then
        local volume_count=$(docker volume ls --filter "dangling=true" -q 2>/dev/null | wc -l)
        items+=("未使用的卷 ($volume_count 个)")
    fi
    
    if [ "$CLEAN_NETWORKS" = true ]; then
        local network_count=$(docker network ls --filter "type=custom" -q 2>/dev/null | wc -l)
        items+=("自定义网络 ($network_count 个)")
    fi
    
    if [ ${#items[@]} -eq 0 ]; then
        log_warning "未选择任何清理项"
        exit 0
    fi
    
    echo -e "${YELLOW}将要清理:${NC}"
    for item in "${items[@]}"; do
        echo -e "  ${RED}❌ $item${NC}"
    done
    
    echo ""
    log_error "⚠️  警告：此操作不可逆！"
    echo ""
    
    if ! confirm_action "确认执行清理操作"; then
        log_info "清理已取消"
        exit 0
    fi
}

# ========================================
# 清理容器
# ========================================
cleanup_containers() {
    log_step "清理容器"
    
    # 方法1: 通过扫描 docker-compose 文件找到所有服务名
    local service_names=()
    while IFS= read -r compose_file; do
        [ ! -f "$compose_file" ] && continue
        local dir=$(dirname "$compose_file")
        cd "$dir" || continue
        
        # 使用 docker compose config 获取服务名
        local compose_cmd
        if docker compose version &> /dev/null; then
            compose_cmd="docker compose"
        else
            compose_cmd="docker-compose"
        fi
        
        local services=$($compose_cmd -f "$(basename "$compose_file")" config --services 2>/dev/null || true)
        while IFS= read -r service; do
            [ -z "$service" ] && continue
            service_names+=("$service")
        done <<< "$services"
    done < <(find "$PROJECT_ROOT" -name "docker-compose.yml" -o -name "docker-compose.yaml" 2>/dev/null | grep -v "_data/update")
    
    # 方法2: 通过容器名称模式查找（作为补充）
    local pattern_containers=$(docker ps -a --filter "name=secCortex\|cortex\|wuji\|rag\|dify\|kong\|keycloak\|nacos\|minio\|qdrant\|elasticsearch\|mysql\|postgres\|redis\|mongo\|rabbitmq\|clouditera" --format "{{.Names}}" 2>/dev/null)
    
    # 合并并去重
    local all_containers=()
    for service in "${service_names[@]}"; do
        # 查找包含服务名的容器
        local found=$(docker ps -a --filter "name=$service" --format "{{.Names}}" 2>/dev/null)
        while IFS= read -r container; do
            [ -z "$container" ] && continue
            all_containers+=("$container")
        done <<< "$found"
    done
    
    # 添加模式匹配的容器
    while IFS= read -r container; do
        [ -z "$container" ] && continue
        # 检查是否已存在
        local exists=false
        for existing in "${all_containers[@]}"; do
            if [ "$container" = "$existing" ]; then
                exists=true
                break
            fi
        done
        if [ "$exists" = false ]; then
            all_containers+=("$container")
        fi
    done <<< "$pattern_containers"
    
    if [ ${#all_containers[@]} -eq 0 ]; then
        log_info "未找到需要清理的容器"
        return 0
    fi
    
    log_info "找到 ${#all_containers[@]} 个相关容器"
    
    local count=0
    for container in "${all_containers[@]}"; do
        count=$((count + 1))
        log_info "[$count/${#all_containers[@]}] 停止并删除容器: $container"
        docker stop "$container" 2>/dev/null || true
        docker rm "$container" 2>/dev/null || {
            log_warning "删除容器失败: $container"
        }
    done
    
    if [ $count -gt 0 ]; then
        log_success "已清理 $count 个容器"
    fi
    
    return 0
}

# ========================================
# 清理数据目录
# ========================================
cleanup_data() {
    log_step "清理数据目录"
    
    if [ ! -d "$DATA_ROOT" ]; then
        log_info "数据目录不存在: $DATA_ROOT"
        return 0
    fi
    
    log_warning "准备删除数据目录: $DATA_ROOT"
    local data_size=$(du -sh "$DATA_ROOT" 2>/dev/null | cut -f1 || echo "未知")
    log_info "数据目录大小: $data_size"
    
    if confirm_action "确认删除数据目录（此操作不可逆）"; then
        if rm -rf "$DATA_ROOT"/* 2>/dev/null; then
            log_success "数据目录已清理"
        else
            log_error "数据目录清理失败，可能需要 root 权限"
            log_warning "请手动执行: sudo rm -rf $DATA_ROOT/*"
            return 1
        fi
    else
        log_info "已跳过数据目录清理"
    fi
    
    return 0
}

# ========================================
# 清理镜像
# ========================================
cleanup_images() {
    log_step "清理镜像"
    
    # 查找所有相关镜像
    local images=$(docker images --filter "reference=rd.clouditera.com/*" --format "{{.Repository}}:{{.Tag}}" 2>/dev/null)
    
    if [ -z "$images" ]; then
        log_info "未找到需要清理的镜像"
        return 0
    fi
    
    local count=0
    while IFS= read -r image; do
        [ -z "$image" ] && continue
        count=$((count + 1))
        log_info "删除镜像: $image"
        docker rmi "$image" 2>/dev/null || {
            log_warning "删除镜像失败: $image (可能正在使用中)"
        }
    done <<< "$images"
    
    if [ $count -gt 0 ]; then
        log_success "已清理 $count 个镜像"
    else
        log_info "未找到需要清理的镜像"
    fi
    
    return 0
}

# ========================================
# 清理卷
# ========================================
cleanup_volumes() {
    log_step "清理未使用的卷"
    
    local volumes=$(docker volume ls --filter "dangling=true" -q 2>/dev/null)
    
    if [ -z "$volumes" ]; then
        log_info "未找到未使用的卷"
        return 0
    fi
    
    local count=0
    while IFS= read -r volume; do
        [ -z "$volume" ] && continue
        count=$((count + 1))
        log_info "删除卷: $volume"
        docker volume rm "$volume" 2>/dev/null || true
    done <<< "$volumes"
    
    if [ $count -gt 0 ]; then
        log_success "已清理 $count 个未使用的卷"
    else
        log_info "未找到未使用的卷"
    fi
    
    return 0
}

# ========================================
# 清理网络
# ========================================
cleanup_networks() {
    log_step "清理自定义网络"
    
    local networks=$(docker network ls --filter "type=custom" --format "{{.ID}}" 2>/dev/null)
    
    if [ -z "$networks" ]; then
        log_info "未找到自定义网络"
        return 0
    fi
    
    local count=0
    while IFS= read -r network; do
        [ -z "$network" ] && continue
        # 跳过默认网络
        if docker network inspect "$network" --format "{{.Name}}" 2>/dev/null | grep -qE "^(bridge|host|none)$"; then
            continue
        fi
        count=$((count + 1))
        local network_name=$(docker network inspect "$network" --format "{{.Name}}" 2>/dev/null || echo "$network")
        log_info "删除网络: $network_name"
        docker network rm "$network" 2>/dev/null || {
            log_warning "删除网络失败: $network_name (可能正在使用中)"
        }
    done <<< "$networks"
    
    if [ $count -gt 0 ]; then
        log_success "已清理 $count 个自定义网络"
    else
        log_info "未找到需要清理的自定义网络"
    fi
    
    return 0
}

# ========================================
# 主函数
# ========================================
main() {
    # 检查 Docker
    if ! check_docker; then
        log_error "Docker 未安装，无法执行清理操作"
        exit 1
    fi
    
    # 显示菜单并获取选择
    show_cleanup_menu
    
    echo ""
    log_step "开始执行清理操作"
    echo ""
    
    local failed=0
    
    # 执行清理操作
    if [ "$CLEAN_CONTAINERS" = true ]; then
        if ! cleanup_containers; then
            failed=1
        fi
        echo ""
    fi
    
    if [ "$CLEAN_DATA" = true ]; then
        if ! cleanup_data; then
            failed=1
        fi
        echo ""
    fi
    
    if [ "$CLEAN_IMAGES" = true ]; then
        if ! cleanup_images; then
            failed=1
        fi
        echo ""
    fi
    
    if [ "$CLEAN_VOLUMES" = true ]; then
        if ! cleanup_volumes; then
            failed=1
        fi
        echo ""
    fi
    
    if [ "$CLEAN_NETWORKS" = true ]; then
        if ! cleanup_networks; then
            failed=1
        fi
        echo ""
    fi
    
    # 显示清理结果
    echo ""
    log_step "清理操作完成"
    
    if [ $failed -eq 0 ]; then
        log_success "所有清理操作已完成"
    else
        log_warning "部分清理操作失败，请检查上述错误信息"
    fi
    
    echo ""
    log_info "清理后的系统状态:"
    log_info "  容器数量: $(docker ps -a -q 2>/dev/null | wc -l)"
    log_info "  镜像数量: $(docker images -q 2>/dev/null | wc -l)"
    log_info "  卷数量: $(docker volume ls -q 2>/dev/null | wc -l)"
    log_info "  网络数量: $(docker network ls -q 2>/dev/null | wc -l)"
}

# 执行主函数
main "$@"

