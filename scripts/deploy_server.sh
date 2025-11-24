#!/bin/bash
# deploy_server.sh - 服务端组件部署脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SERVER_DIR="$PROJECT_ROOT/CortexServer"

# ========================================
# 部署服务端组件
# ========================================
main() {
    log_step "部署服务端组件 (CortexServer)"
    
    if [ ! -d "$SERVER_DIR" ]; then
        log_error "服务端目录不存在: $SERVER_DIR"
        return 1
    fi
    
    local failed=()
    local success=()
    
    # 1. 部署 service（服务端主服务）
    if [ -d "$SERVER_DIR/service" ]; then
        log_info "部署服务端主服务 (service)..."
        
        local compose_file=""
        if [ -f "$SERVER_DIR/service/docker-compose.yaml" ]; then
            compose_file="docker-compose.yaml"
        elif [ -f "$SERVER_DIR/service/docker-compose.yml" ]; then
            compose_file="docker-compose.yml"
        fi
        
        if [ -n "$compose_file" ]; then
            if deploy_component "Server-Service" "$SERVER_DIR/service" "$compose_file"; then
                success+=("service")
            else
                failed+=("service")
            fi
            echo ""
        fi
    fi
    
    # 2. 自动扫描并部署 plugins 下的所有插件
    if [ -d "$SERVER_DIR/plugins" ]; then
        log_info "扫描并部署插件服务 (plugins)..."
        
        local plugins_found=0
        while IFS= read -r -d '' plugin_path; do
            local plugin_name=$(basename "$plugin_path")
            
            # 跳过非目录项
            if [ ! -d "$plugin_path" ]; then
                continue
            fi
            
            # 检查 compose 文件
            local compose_file=""
            if [ -f "$plugin_path/docker-compose.yaml" ]; then
                compose_file="docker-compose.yaml"
            elif [ -f "$plugin_path/docker-compose.yml" ]; then
                compose_file="docker-compose.yml"
            else
                continue
            fi
            
            plugins_found=$((plugins_found + 1))
            log_info "发现插件 [$plugins_found]: $plugin_name"
            
            # 部署插件
            if deploy_component "Plugin-$plugin_name" "$plugin_path" "$compose_file"; then
                success+=("plugin-$plugin_name")
            else
                failed+=("plugin-$plugin_name")
            fi
            
            echo ""
        done < <(find "$SERVER_DIR/plugins" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
        
        if [ $plugins_found -eq 0 ]; then
            log_warning "未找到任何可部署的插件"
        fi
    fi
    
    # 显示结果
    echo ""
    log_step "服务端部署结果"
    
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

