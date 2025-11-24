#!/bin/bash
# deploy_web.sh - 前端服务组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WEB_DIR="$PROJECT_ROOT/CortexWeb"

# ========================================
# 部署前端服务组件
# ========================================
main() {
    log_step "部署前端服务组件 (CortexWeb)"
    
    if [ ! -d "$WEB_DIR" ]; then
        log_error "前端服务目录不存在: $WEB_DIR"
        return 1
    fi
    
    # 检查 compose 文件
    local compose_file=""
    if [ -f "$WEB_DIR/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    elif [ -f "$WEB_DIR/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    else
        log_error "未找到 docker-compose 文件"
        return 1
    fi
    
    # 部署组件
    if deploy_component "CortexWeb" "$WEB_DIR" "$compose_file"; then
        log_success "前端服务部署完成"
        return 0
    else
        log_error "前端服务部署失败"
        return 1
    fi
}

# 执行主函数
main "$@"

