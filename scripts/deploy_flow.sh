#!/bin/bash
# deploy_flow.sh - 工作流组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FLOW_DIR="$PROJECT_ROOT/CortexFlow"

# ========================================
# 部署工作流组件
# ========================================
main() {
    log_step "部署工作流组件 (CortexFlow)"

    if [ ! -d "$FLOW_DIR" ]; then
        log_error "工作流目录不存在: $FLOW_DIR"
        return 1
    fi

    # 检查 docker-compose 文件
    local compose_file=""
    if [ -f "$FLOW_DIR/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    elif [ -f "$FLOW_DIR/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    else
        log_error "未找到 docker-compose 文件"
        return 1
    fi

    log_info "发现工作流服务配置文件: $compose_file"

    # 创建数据目录
    local data_dirs=(
        "$FLOW_DIR/data/backend"
        "$FLOW_DIR/data/postgres"
    )

    for data_dir in "${data_dirs[@]}"; do
        if [ ! -d "$data_dir" ]; then
            log_info "创建数据目录: $data_dir"
            mkdir -p "$data_dir" || {
                log_error "创建数据目录失败: $data_dir"
                return 1
            }
        fi
    done

    # 设置数据目录权限
    for data_dir in "${data_dirs[@]}"; do
        if [ -d "$data_dir" ]; then
            log_info "设置数据目录权限: $data_dir"
            chmod -R 755 "$data_dir" || {
                log_warning "设置权限失败: $data_dir"
            }
        fi
    done

    # 部署组件
    if deploy_component "CortexFlow" "$FLOW_DIR" "$compose_file"; then
        log_success "工作流组件部署成功"
        echo ""
        log_info "CortexFlow 服务信息:"
        log_info "  - 后端服务: http://localhost:${CLOUDFLOW_BACKEND_PORT:-20027}"
        log_info "  - 数据库: PostgreSQL (内部服务)"
        log_info "  - 缓存: Redis (内部服务)"
        return 0
    else
        log_error "工作流组件部署失败"
        return 1
    fi
}

# 执行主函数
main "$@"
