#!/bin/bash
# deploy.sh - SecCortex 部署主控脚本

set -euo pipefail

# 加载通用函数库
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/common.sh"

# ========================================
# 主函数
# ========================================
main() {
    # 显示欢迎信息
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║              SecCortex 部署脚本 v1.0                      ║
║                                                           ║
║              智能安全分析平台 - 一键部署                   ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # 检查依赖
    if ! check_dependencies; then
        log_error "依赖检查失败，请先安装必要的依赖后重试"
        exit 1
    fi
    
    echo ""
    
    # IP 地址配置
    if ! select_ip "$DEFAULT_OLD_IP"; then
        log_warning "IP 地址配置已跳过或失败，继续部署..."
    fi
    
    echo ""
    
    # 创建数据目录
    if ! create_data_directories "$DATA_ROOT"; then
        log_error "数据目录创建失败"
        exit 1
    fi
    
    echo ""
    
    # 组件选择菜单
    show_component_menu
}

# ========================================
# 组件选择菜单
# ========================================
show_component_menu() {
    log_step "选择要部署的组件"
    
    echo -e "${BLUE}可用组件:${NC}"
    echo -e "  ${CYAN}[1]${NC} Infrastructure (基础设施: 数据库、Redis、MinIO 等)"
    echo -e "  ${CYAN}[2]${NC} Auth (认证服务: Keycloak)"
    echo -e "  ${CYAN}[3]${NC} Gateway (API 网关: Kong)"
    echo -e "  ${CYAN}[4]${NC} Server (服务端: 大模型应用服务)"
    echo -e "  ${CYAN}[5]${NC} RAG (检索增强生成服务)"
    echo -e "  ${CYAN}[6]${NC} SOP (工作流编排服务: DIFY)"
    echo -e "  ${CYAN}[7]${NC} Web (前端服务)"
    echo -e "  ${CYAN}[8]${NC} All (部署所有组件)"
    echo -e "  ${CYAN}[0]${NC} 退出"
    echo ""
    
    read -p "请选择要部署的组件 (可多选，用逗号分隔，如: 1,2,3): " selections
    
    if [ -z "$selections" ] || [ "$selections" = "0" ]; then
        log_info "部署已取消"
        exit 0
    fi
    
    # 解析选择
    IFS=',' read -ra SELECTED <<< "$selections"
    
    local components=()
    for sel in "${SELECTED[@]}"; do
        case "$sel" in
            1) components+=("infra") ;;
            2) components+=("auth") ;;
            3) components+=("gateway") ;;
            4) components+=("server") ;;
            5) components+=("rag") ;;
            6) components+=("sop") ;;
            7) components+=("web") ;;
            8) components=("infra" "auth" "gateway" "server" "rag" "sop" "web") ;;
            *) log_warning "无效的选择: $sel，已跳过" ;;
        esac
    done
    
    if [ ${#components[@]} -eq 0 ]; then
        log_error "未选择任何组件"
        exit 1
    fi
    
    echo ""
    log_info "将部署以下组件: ${components[*]}"
    echo ""
    
    if ! confirm_action "确认开始部署"; then
        log_info "部署已取消"
        exit 0
    fi
    
    echo ""
    
    # 按顺序部署组件
    local failed_components=()
    for component in "${components[@]}"; do
        if ! deploy_component_by_name "$component"; then
            failed_components+=("$component")
        fi
        echo ""
    done
    
    # 显示部署结果
    show_deployment_summary "${components[@]}" "${failed_components[@]}"
}

# ========================================
# 根据组件名称部署
# ========================================
deploy_component_by_name() {
    local component="$1"
    
    case "$component" in
        infra)
            if [ -f "$SCRIPT_DIR/scripts/deploy_infra.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_infra.sh"
            else
                log_error "部署脚本不存在: deploy_infra.sh"
                return 1
            fi
            ;;
        auth)
            if [ -f "$SCRIPT_DIR/scripts/deploy_auth.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_auth.sh"
            else
                log_error "部署脚本不存在: deploy_auth.sh"
                return 1
            fi
            ;;
        gateway)
            if [ -f "$SCRIPT_DIR/scripts/deploy_gateway.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_gateway.sh"
            else
                log_error "部署脚本不存在: deploy_gateway.sh"
                return 1
            fi
            ;;
        server)
            if [ -f "$SCRIPT_DIR/scripts/deploy_server.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_server.sh"
            else
                log_error "部署脚本不存在: deploy_server.sh"
                return 1
            fi
            ;;
        rag)
            if [ -f "$SCRIPT_DIR/scripts/deploy_rag.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_rag.sh"
            else
                log_error "部署脚本不存在: deploy_rag.sh"
                return 1
            fi
            ;;
        sop)
            if [ -f "$SCRIPT_DIR/scripts/deploy_sop.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_sop.sh"
            else
                log_error "部署脚本不存在: deploy_sop.sh"
                return 1
            fi
            ;;
        web)
            if [ -f "$SCRIPT_DIR/scripts/deploy_web.sh" ]; then
                bash "$SCRIPT_DIR/scripts/deploy_web.sh"
            else
                log_error "部署脚本不存在: deploy_web.sh"
                return 1
            fi
            ;;
        *)
            log_error "未知组件: $component"
            return 1
            ;;
    esac
}

# ========================================
# 显示部署结果汇总
# ========================================
show_deployment_summary() {
    local all_components=("$@")
    local failed_components=()
    
    # 分离失败组件（从参数中提取）
    for arg in "$@"; do
        if [[ "$arg" == "failed:"* ]]; then
            failed_components+=("${arg#failed:}")
        fi
    done
    
    log_step "部署结果汇总"
    
    echo -e "${BLUE}已部署组件:${NC}"
    for component in "${all_components[@]}"; do
        if [[ ! "$component" == "failed:"* ]]; then
            local is_failed=false
            for failed in "${failed_components[@]}"; do
                if [ "$component" = "$failed" ]; then
                    is_failed=true
                    break
                fi
            done
            if [ "$is_failed" = false ]; then
                echo -e "  ${GREEN}✅ $component${NC}"
            else
                echo -e "  ${RED}❌ $component${NC}"
            fi
        fi
    done
    
    echo ""
    
    if [ ${#failed_components[@]} -gt 0 ]; then
        log_warning "以下组件部署失败: ${failed_components[*]}"
        echo ""
        log_info "请检查日志并手动处理失败的组件"
    else
        log_success "所有组件部署成功！"
    fi
    
    echo ""
    log_info "查看服务状态: docker ps"
    log_info "查看服务日志: docker compose logs -f [service_name]"
    log_info "停止服务: docker compose down"
}

# 执行主函数
main "$@"

