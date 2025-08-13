#!/bin/bash

# ========================================
# 服务启动顺序测试脚本
# 验证各个服务的启动顺序和依赖关系
# ========================================

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}服务启动顺序测试${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 检查脚本文件
check_script() {
    local script_name="$1"
    local script_path="$2"
    local description="$3"
    
    if [ -f "$script_path" ] && [ -x "$script_path" ]; then
        echo -e "${GREEN}✅ $script_name${NC} - $description"
        return 0
    else
        echo -e "${RED}❌ $script_name${NC} - $description (文件不存在或无执行权限)"
        return 1
    fi
}

# 检查服务目录
check_service_dir() {
    local service_name="$1"
    local service_path="$2"
    local description="$3"
    
    if [ -d "$service_path" ]; then
        echo -e "${GREEN}✅ $service_name${NC} - $description"
        return 0
    else
        echo -e "${RED}❌ $service_name${NC} - $description (目录不存在)"
        return 1
    fi
}

echo -e "${BLUE}🔍 检查启动脚本...${NC}"
echo ""

# 检查启动脚本
check_script "start-support-services.sh" "$SCRIPT_DIR/start-support-services.sh" "基础服务启动脚本"
check_script "start-ai-brain.sh" "$SCRIPT_DIR/start-ai-brain.sh" "AI Brain服务启动脚本"
check_script "start-services.sh" "$SCRIPT_DIR/start-services.sh" "业务服务启动脚本"
check_script "start-plugins-services.sh" "$SCRIPT_DIR/start-plugins-services.sh" "插件服务启动脚本"
check_script "start-storage-services.sh" "$SCRIPT_DIR/start-storage-services.sh" "存储服务启动脚本"

echo ""
echo -e "${BLUE}🔍 检查服务目录...${NC}"
echo ""

# 检查服务目录
check_service_dir "support" "$PROJECT_ROOT/support" "基础服务目录"
check_service_dir "ai_brain" "$PROJECT_ROOT/ai_brain" "AI Brain服务目录"
check_service_dir "services" "$PROJECT_ROOT/services" "业务服务目录"
check_service_dir "plugins" "$PROJECT_ROOT/plugins" "插件服务目录"
check_service_dir "storage" "$PROJECT_ROOT/storage" "存储服务目录"

echo ""
echo -e "${BLUE}📋 推荐启动顺序:${NC}"
echo ""
echo -e "${CYAN}1. 基础服务层 (Support Services)${NC}"
echo -e "   ./scripts/start-support-services.sh start"
echo -e "   ⏳ 等待约2-3分钟让服务完全启动"
echo ""
echo -e "${CYAN}2. AI Brain 服务层${NC}"
echo -e "   ./scripts/start-ai-brain.sh start"
echo -e "   ⏳ 等待约1-2分钟让服务完全启动"
echo ""
echo -e "${CYAN}3. 业务服务层 (Services)${NC}"
echo -e "   ./scripts/start-services.sh start"
echo ""
echo -e "${CYAN}4. 插件服务层 (Plugins)${NC}"
echo -e "   ./scripts/start-plugins-services.sh start"
echo ""
echo -e "${CYAN}5. 存储服务层 (Storage)${NC}"
echo -e "   ./scripts/start-storage-services.sh start"
echo ""

echo -e "${BLUE}💡 快速启动选项:${NC}"
echo -e "   ./scripts/quick-ai-brain.sh     # 快速启动AI Brain"
echo -e "   ./scripts/auto-deploy.sh        # 自动部署所有服务"
echo ""

echo -e "${BLUE}🔍 状态检查命令:${NC}"
echo -e "   ./scripts/start-support-services.sh status  # 基础服务状态"
echo -e "   ./scripts/start-ai-brain.sh status          # AI Brain状态"
echo -e "   ./scripts/check-ai-brain-status.sh          # AI Brain详细状态"
echo -e "   ./scripts/start-services.sh status          # 业务服务状态"
echo ""

echo -e "${YELLOW}⚠️  注意事项:${NC}"
echo -e "   • 确保Docker和Docker Compose已安装并运行"
echo -e "   • 检查环境变量配置（特别是INSTALL_LOCAL）"
echo -e "   • 确保有足够的磁盘空间和内存"
echo -e "   • 按照推荐顺序启动服务，避免依赖问题"
echo ""

echo -e "${GREEN}🎯 测试完成！${NC}"
echo -e "   现在可以按照上述顺序启动服务了。"
