#!/bin/bash
# deploy_gateway.sh - API 网关组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GATEWAY_DIR="$PROJECT_ROOT/CortexGateway"

# ========================================
# 部署 API 网关组件
# ========================================
main() {
    log_step "部署 API 网关组件 (CortexGateway)"
    
    if [ ! -d "$GATEWAY_DIR" ]; then
        log_error "API 网关目录不存在: $GATEWAY_DIR"
        return 1
    fi
    
    # 检查 compose 文件
    local compose_file=""
    if [ -f "$GATEWAY_DIR/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    elif [ -f "$GATEWAY_DIR/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    else
        log_error "未找到 docker-compose 文件"
        return 1
    fi
    
    # 部署组件
    if deploy_component "CortexGateway" "$GATEWAY_DIR" "$compose_file"; then
        log_success "API 网关部署完成"
        return 0
    else
        log_error "API 网关部署失败"
        return 1
    fi
}

# 执行主函数
main "$@"

