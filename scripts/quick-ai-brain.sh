#!/bin/bash

# ========================================
# AI Brain服务快速启动脚本
# 一键启动AI Brain服务
# ========================================

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}🚀 正在启动AI Brain服务...${NC}"

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
AI_BRAIN_DIR="$PROJECT_ROOT/ai_brain"

# 检查Docker
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker未运行，请先启动Docker服务${NC}"
    exit 1
fi

# 检查Docker Compose
if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker Compose未安装${NC}"
    exit 1
fi

# 获取Docker Compose命令
if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_CMD="docker-compose"
else
    COMPOSE_CMD="docker compose"
fi

# 检查AI Brain目录
if [ ! -d "$AI_BRAIN_DIR" ]; then
    echo -e "${RED}❌ AI Brain目录不存在: $AI_BRAIN_DIR${NC}"
    exit 1
fi

# 检查配置文件
if [ ! -f "$AI_BRAIN_DIR/docker-compose.yaml" ]; then
    echo -e "${RED}❌ AI Brain docker-compose.yaml 文件不存在${NC}"
    exit 1
fi

if [ ! -f "$AI_BRAIN_DIR/base.env" ]; then
    echo -e "${YELLOW}⚠️  AI Brain base.env 文件不存在${NC}"
fi

# 设置环境变量
# if [ -z "$INSTALL_LOCAL" ]; then
#     export INSTALL_LOCAL="$PROJECT_ROOT"
#     echo -e "${BLUE}📋 设置 INSTALL_LOCAL: $INSTALL_LOCAL${NC}"
# fi

# # 创建必要的目录
# echo -e "${BLUE}📁 检查并创建必要的目录...${NC}"
# mkdir -p "$INSTALL_LOCAL/ai_brain/app/storage"
# mkdir -p "$INSTALL_LOCAL/ai_brain/sandbox/dependencies"
# mkdir -p "$INSTALL_LOCAL/ai_brain/plugin_daemon"

# 启动服务
echo -e "${GREEN}📦 启动AI Brain服务...${NC}"
cd "$AI_BRAIN_DIR"

if $COMPOSE_CMD up -d; then
    echo -e "${GREEN}✅ AI Brain服务启动成功${NC}"
    
    # 等待服务启动
    echo -e "${BLUE}⏳ 等待服务启动（15秒）...${NC}"
    sleep 15
    
    # 检查服务状态
    echo -e "${BLUE}🔍 检查服务状态...${NC}"
    if $COMPOSE_CMD ps | grep -q "Up"; then
        echo -e "${GREEN}✅ AI Brain服务运行正常${NC}"
        
        # 等待API服务健康检查
        echo -e "${BLUE}🏥 等待API服务健康检查...${NC}"
        local health_check_attempts=0
        local max_attempts=15
        
        while [ $health_check_attempts -lt $max_attempts ]; do
            if curl -s http://localhost:15001/health >/dev/null 2>&1; then
                echo -e "${GREEN}✅ API服务健康检查通过${NC}"
                break
            fi
            
            echo -e "${BLUE}⏳ 等待API服务健康检查... (尝试 $((health_check_attempts + 1))/$max_attempts)${NC}"
            sleep 3
            health_check_attempts=$((health_check_attempts + 1))
        done
        
        if [ $health_check_attempts -eq $max_attempts ]; then
            echo -e "${YELLOW}⚠️  API服务健康检查超时，但服务已启动${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  AI Brain服务可能未完全启动${NC}"
    fi
    
    # 显示服务状态
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}AI Brain服务状态${NC}"
    echo -e "${GREEN}========================================${NC}"
    $COMPOSE_CMD ps
    
    echo ""
    echo -e "${GREEN}🎉 AI Brain服务启动完成！${NC}"
    echo ""
    echo -e "${BLUE}💡 服务访问地址：${NC}"
    echo -e "   Web界面: http://localhost:10081"
    echo -e "   API服务: http://localhost:15001"
    echo -e "   沙箱服务: http://localhost:18194"
    echo -e "   插件守护进程: http://localhost:15004"
    echo ""
    echo -e "${YELLOW}💡 使用以下命令查看服务状态：${NC}"
    echo -e "   docker ps"
    echo -e "   $0 status"
    echo ""
    echo -e "${YELLOW}💡 使用以下命令停止服务：${NC}"
    echo -e "   $0 stop"
    
else
    echo -e "${RED}❌ AI Brain服务启动失败${NC}"
    exit 1
fi

cd - >/dev/null
