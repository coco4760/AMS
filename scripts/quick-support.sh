#!/bin/bash

# ========================================
# Support服务快速启动脚本
# 一键启动所有support服务
# ========================================

# 移除set -e，允许脚本在失败时继续执行
# set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 正在启动Support服务...${NC}"

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SUPPORT_DIR="$PROJECT_ROOT/support"

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

# 启动服务函数
start_service() {
    local service_dir="$1"
    local service_name="$2"
    
    if [ -d "$service_dir" ]; then
        echo -e "${GREEN}📦 启动 $service_name...${NC}"
        cd "$service_dir"
        
        # 查找docker-compose文件
        local compose_file=""
        if [ -f "docker-compose.yml" ]; then
            compose_file="docker-compose.yml"
        elif [ -f "docker-compose.yaml" ]; then
            compose_file="docker-compose.yaml"
        fi
        
        if [ -n "$compose_file" ]; then
            if $COMPOSE_CMD -f "$compose_file" up -d; then
                echo -e "${GREEN}✅ $service_name 启动成功${NC}"
                return 0
            else
                echo -e "${RED}❌ $service_name 启动失败${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠️  $service_name 未找到docker-compose文件${NC}"
            return 2
        fi
        
        cd - >/dev/null
    else
        echo -e "${YELLOW}⚠️  服务目录 $service_dir 不存在${NC}"
        return 2
    fi
}

# 启动所有服务
echo -e "${GREEN}🔍 扫描support目录...${NC}"

# 按依赖顺序启动服务
services=(
    "nacos"
    "rabbitmq" 
    "kong"
    "iam"
    "filems"
    "collabnet"
    "mineru"
    "node_manager"
    "rag-server"
)

# 统计变量
success_count=0
failed_count=0
skipped_count=0

for service in "${services[@]}"; do
    service_path="$SUPPORT_DIR/$service"
    result=$(start_service "$service_path" "$service")
    exit_code=$?
    
    case $exit_code in
        0)
            success_count=$((success_count + 1))
            ;;
        1)
            failed_count=$((failed_count + 1))
            echo -e "${YELLOW}⚠️  继续启动下一个服务...${NC}"
            ;;
        2)
            skipped_count=$((skipped_count + 1))
            ;;
    esac
    
    echo ""
done

# 显示启动结果摘要
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}启动结果摘要${NC}"
echo -e "${GREEN}========================================${NC}"

if [ $success_count -gt 0 ]; then
    echo -e "${GREEN}✅ 成功启动: $success_count 个服务${NC}"
fi

if [ $failed_count -gt 0 ]; then
    echo -e "${RED}❌ 启动失败: $failed_count 个服务${NC}"
fi

if [ $skipped_count -gt 0 ]; then
    echo -e "${YELLOW}⚠️  跳过: $skipped_count 个服务${NC}"
fi

echo ""

if [ $failed_count -eq 0 ] && [ $skipped_count -eq 0 ]; then
    echo -e "${GREEN}🎉 所有服务启动完成！${NC}"
else
    echo -e "${YELLOW}⚠️  部分服务启动失败或跳过，但脚本已继续执行完成${NC}"
fi

echo ""
echo -e "${YELLOW}💡 使用以下命令查看服务状态：${NC}"
echo -e "   docker ps"
echo -e "   $0 status"
echo ""
echo -e "${YELLOW}💡 使用以下命令停止所有服务：${NC}"
echo -e "   $0 stop"
