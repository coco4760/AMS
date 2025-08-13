#!/bin/bash

# ========================================
# AI Brain服务状态检查脚本
# 检查AI Brain服务的运行状态和健康情况
# ========================================

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
AI_BRAIN_DIR="$PROJECT_ROOT/ai_brain"

# 检查函数
check_service_status() {
    local service_name="$1"
    local container_name="$2"
    local port="$3"
    local health_endpoint="$4"
    
    echo -e "${BLUE}🔍 检查 $service_name 服务...${NC}"
    
    # 检查容器状态
    if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "$container_name.*Up"; then
        echo -e "   📦 容器状态: ${GREEN}运行中${NC}"
        
        # 检查端口
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            echo -e "   🌐 端口 $port: ${GREEN}监听中${NC}"
        else
            echo -e "   🌐 端口 $port: ${RED}未监听${NC}"
        fi
        
        # 检查健康状态
        if [ -n "$health_endpoint" ]; then
            if curl -s "$health_endpoint" >/dev/null 2>&1; then
                echo -e "   🏥 健康检查: ${GREEN}通过${NC}"
            else
                echo -e "   🏥 健康检查: ${YELLOW}失败${NC}"
            fi
        fi
    else
        echo -e "   📦 容器状态: ${RED}未运行${NC}"
    fi
    
    echo ""
}

# 主函数
main() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}AI Brain服务状态检查${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    
    # 检查AI Brain目录
    if [ ! -d "$AI_BRAIN_DIR" ]; then
        echo -e "${RED}❌ AI Brain目录不存在: $AI_BRAIN_DIR${NC}"
        exit 1
    fi
    
    # 检查Docker是否运行
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}❌ Docker未运行${NC}"
        exit 1
    fi
    
    # 获取Docker Compose命令
    if command -v docker-compose >/dev/null 2>&1; then
        COMPOSE_CMD="docker-compose"
    else
        COMPOSE_CMD="docker compose"
    fi
    
    # 显示Docker Compose状态
    echo -e "${BLUE}📋 Docker Compose状态:${NC}"
    cd "$AI_BRAIN_DIR"
    $COMPOSE_CMD ps
    echo ""
    
    # 检查各个服务
    echo -e "${BLUE}🔍 详细服务状态检查:${NC}"
    echo ""
    
    # API服务
    check_service_status "API服务" "ai_brain-api" "15001" "http://localhost:15001/health"
    
    # Worker服务
    check_service_status "Worker服务" "ai_brain-worker" "" ""
    
    # Web服务
    check_service_status "Web服务" "ai_brain-web" "" ""
    
    # Sandbox服务
    check_service_status "Sandbox服务" "ai_brain-sandbox" "18194" ""
    
    # Plugin Daemon服务
    check_service_status "Plugin Daemon服务" "ai_brain-plugin_daemon" "15004" ""
    
    # Nginx服务
    check_service_status "Nginx服务" "ai_brain-nginx" "10081" "http://localhost:10081"
    
    # 显示网络连接
    echo -e "${BLUE}🌐 网络连接状态:${NC}"
    echo -e "   Web界面: http://localhost:10081"
    echo -e "   API服务: http://localhost:15001"
    echo -e "   沙箱服务: http://localhost:18194"
    echo -e "   插件守护进程: http://localhost:15004"
    echo ""
    
    # 显示日志信息
    echo -e "${BLUE}📝 最近日志信息:${NC}"
    echo -e "   使用以下命令查看详细日志："
    echo -e "   docker logs ai_brain-api --tail 20"
    echo -e "   docker logs ai_brain-worker --tail 20"
    echo -e "   docker logs ai_brain-web --tail 20"
    echo -e "   docker logs ai_brain-sandbox --tail 20"
    echo -e "   docker logs ai_brain-plugin_daemon --tail 20"
    echo -e "   docker logs ai_brain-nginx --tail 20"
    
    cd - >/dev/null
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
