#!/bin/bash
# deploy_sop.sh - 工作流编排服务组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOP_DIR="$PROJECT_ROOT/CortexSOP"

# ========================================
# 部署工作流编排服务组件
# ========================================
main() {
    log_step "部署工作流编排服务组件 (CortexSOP)"
    
    if [ ! -d "$SOP_DIR" ]; then
        log_error "工作流编排服务目录不存在: $SOP_DIR"
        return 1
    fi
    
    # 检查 compose 文件
    local compose_file=""
    if [ -f "$SOP_DIR/docker-compose.yaml" ]; then
        compose_file="docker-compose.yaml"
    elif [ -f "$SOP_DIR/docker-compose.yml" ]; then
        compose_file="docker-compose.yml"
    else
        log_error "未找到 docker-compose 文件"
        return 1
    fi
    
    # 特殊处理：plugin_daemon 数据初始化
    local plugin_daemon_dir="$SOP_DIR/plugin_daemon"
    local plugin_daemon_archive="$SOP_DIR/plugin_daemon.tar.gz"
    
    # 如果数据目录不存在，但存在压缩包，则解压
    if [ ! -d "$plugin_daemon_dir" ] && [ -f "$plugin_daemon_archive" ]; then
        log_info "检测到 plugin_daemon 数据压缩包，正在解压..."
        if tar -xzf "$plugin_daemon_archive" -C "$SOP_DIR"; then
            log_success "plugin_daemon 数据解压完成"
        else
            log_error "plugin_daemon 数据解压失败"
            return 1
        fi
    elif [ -d "$plugin_daemon_dir" ] && [ -f "$plugin_daemon_archive" ]; then
        log_info "plugin_daemon 数据目录已存在，跳过解压"
    fi
    
    # 部署组件
    if deploy_component "CortexSOP" "$SOP_DIR" "$compose_file"; then
        log_success "工作流编排服务部署完成"
        
        # 等待服务完全启动
        log_info "等待 SOP 服务完全启动（15秒）..."
        sleep 15
        log_success "SOP 服务启动等待完成"
        
        return 0
    else
        log_error "工作流编排服务部署失败"
        return 1
    fi
}

# 执行主函数
main "$@"

