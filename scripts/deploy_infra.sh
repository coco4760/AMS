#!/bin/bash
# deploy_infra.sh - 基础设施组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INFRA_DIR="$PROJECT_ROOT/CortexInfra"

# ========================================
# 部署基础设施组件
# ========================================
main() {
    log_step "部署基础设施组件 (CortexInfra)"
    
    if [ ! -d "$INFRA_DIR" ]; then
        log_error "基础设施目录不存在: $INFRA_DIR"
        return 1
    fi
    
    # 自动扫描子目录，查找所有包含 docker-compose 文件的目录
    local failed=()
    local success=()
    local components_found=0
    
    log_info "扫描基础设施组件..."
    
    # 遍历所有子目录并部署
    while IFS= read -r -d '' component_path; do
        local component_name=$(basename "$component_path")
        
        # 跳过非目录项
        if [ ! -d "$component_path" ]; then
            continue
        fi
        
        # 检查 compose 文件
        local compose_file=""
        if [ -f "$component_path/docker-compose.yaml" ]; then
            compose_file="docker-compose.yaml"
        elif [ -f "$component_path/docker-compose.yml" ]; then
            compose_file="docker-compose.yml"
        else
            # 没有 compose 文件，跳过
            continue
        fi
        
        components_found=$((components_found + 1))
        log_info "发现组件 [$components_found]: $component_name"
        
        # 部署组件
        if deploy_component "$component_name" "$component_path" "$compose_file"; then
            success+=("$component_name")
        else
            failed+=("$component_name")
        fi
        
        echo ""
    done < <(find "$INFRA_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
    
    if [ $components_found -eq 0 ]; then
        log_warning "未找到任何可部署的组件"
        return 0
    fi
    
    # 显示结果
    echo ""
    log_step "基础设施部署结果"
    
    if [ ${#success[@]} -gt 0 ]; then
        log_success "成功部署 (${#success[@]}): ${success[*]}"
    fi
    
    if [ ${#failed[@]} -gt 0 ]; then
        log_error "部署失败 (${#failed[@]}): ${failed[*]}"
        return 1
    fi
    
    return 0
}

# 执行主函数
main "$@"

