#!/bin/bash
# deploy_rag.sh - RAG 服务组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RAG_DIR="$PROJECT_ROOT/CortexRAG"

# ========================================
# 部署 RAG 服务组件
# ========================================
main() {
    log_step "部署 RAG 服务组件 (CortexRAG)"
    
    if [ ! -d "$RAG_DIR" ]; then
        log_error "RAG 服务目录不存在: $RAG_DIR"
        return 1
    fi
    
    # 检查 compose 文件
    local compose_file=""
    if [ -f "$RAG_DIR/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    elif [ -f "$RAG_DIR/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    else
        log_error "未找到 docker-compose 文件"
        return 1
    fi
    
    # 部署组件
    if deploy_component "CortexRAG" "$RAG_DIR" "$compose_file"; then
        log_success "RAG 服务部署完成"
        return 0
    else
        log_error "RAG 服务部署失败"
        return 1
    fi
}

# 执行主函数
main "$@"

