#!/bin/bash

# ========================================
# 通用字符串替换脚本
# 将指定的源字符串替换为目标字符串
# 主要用于IP地址替换
# ========================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 检查参数
if [ $# -ne 2 ]; then
    echo -e "${RED}使用方法: $0 <源字符串> <目标字符串>${NC}"
    echo -e "${YELLOW}示例: $0 192.168.1.100 10.0.0.100${NC}"
    echo -e "${YELLOW}示例: $0 172.16.0.1 192.168.0.1${NC}"
    echo ""
    echo -e "${BLUE}说明:${NC}"
    echo "  源字符串: 要被替换的IP地址或字符串"
    echo "  目标字符串: 替换后的新IP地址或字符串"
    exit 1
fi

SOURCE_STRING=$1
TARGET_STRING=$2

echo -e "${PURPLE}========================================${NC}"
echo -e "${PURPLE}通用字符串替换脚本${NC}"
echo -e "${PURPLE}========================================${NC}"
echo -e "${BLUE}源字符串:${NC} $SOURCE_STRING"
echo -e "${BLUE}目标字符串:${NC} $TARGET_STRING"
echo -e "${PURPLE}========================================${NC}"

# 查找所有包含源字符串的文件
echo -e "${BLUE}🔍 查找包含源字符串的文件...${NC}"

# 定义要搜索的文件类型
SEARCH_PATTERNS=(
    "*.env"
    "*.yml"
    "*.yaml"
    "*.json"
    "*.conf"
    "*.sh"
    "*.md"
    "*.txt"
    "*.cfg"
    "*.ini"
    "*.sql"
)

# 构建搜索命令
SEARCH_CMD="grep -r '$SOURCE_STRING' ."
for pattern in "${SEARCH_PATTERNS[@]}"; do
    SEARCH_CMD="$SEARCH_CMD --include=\"$pattern\""
done

# 执行搜索并排除脚本本身
FILES_TO_REPLACE=$(eval $SEARCH_CMD 2>/dev/null | cut -d: -f1 | sort | uniq | grep -v "replace-ip.sh")

if [ -z "$FILES_TO_REPLACE" ]; then
    echo -e "${YELLOW}⚠️  未找到包含源字符串 '$SOURCE_STRING' 的文件${NC}"
    echo -e "${BLUE}💡 请检查源字符串是否正确，或者文件是否存在于当前目录${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 找到以下文件需要替换：${NC}"
echo "$FILES_TO_REPLACE"
echo -e "${PURPLE}========================================${NC}"

# 显示替换预览
echo -e "${BLUE}📋 替换预览:${NC}"
echo -e "  将所有的 '$SOURCE_STRING' 替换为 '$TARGET_STRING'"
echo ""

# 确认是否继续
echo -e "${YELLOW}⚠️  确认替换操作${NC}"
read -p "是否继续替换？(y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}操作已取消${NC}"
    exit 0
fi

# 执行替换
echo -e "${BLUE}🔄 开始替换...${NC}"
REPLACED_COUNT=0
FAILED_COUNT=0

for file in $FILES_TO_REPLACE; do
    if [ -f "$file" ]; then
        echo -e "${BLUE}📄 处理文件: $file${NC}"
        
        # 直接替换，不创建备份文件
        
        # 执行替换 (兼容 macOS 和 Linux)
        sed_success=false
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if sed -i '' "s|$SOURCE_STRING|$TARGET_STRING|g" "$file"; then
                sed_success=true
            fi
        else
            # Linux
            if sed -i "s|$SOURCE_STRING|$TARGET_STRING|g" "$file"; then
                sed_success=true
            fi
        fi
        
        # 检查替换结果
        if [ "$sed_success" = true ] && grep -q "$TARGET_STRING" "$file"; then
            # 统计替换次数
            occurrences=$(grep -o "$SOURCE_STRING" "$file" 2>/dev/null | wc -l || echo "0")
            if [ "$occurrences" -eq 0 ]; then
                echo -e "  ${GREEN}✅ 替换成功 (所有匹配项已替换)${NC}"
                REPLACED_COUNT=$((REPLACED_COUNT + 1))
            else
                echo -e "  ${YELLOW}⚠️  部分替换成功 (还有 $occurrences 个源字符串未替换)${NC}"
                REPLACED_COUNT=$((REPLACED_COUNT + 1))
            fi
        else
            echo -e "  ${RED}❌ 替换失败${NC}"
            FAILED_COUNT=$((FAILED_COUNT + 1))
        fi
    fi
done

echo -e "${PURPLE}========================================${NC}"
echo -e "${GREEN}🎯 替换完成！${NC}"
echo -e "${BLUE}📊 统计信息:${NC}"
echo -e "   ✅ 成功处理: $REPLACED_COUNT 个文件"
if [ $FAILED_COUNT -gt 0 ]; then
    echo -e "   ❌ 处理失败: $FAILED_COUNT 个文件"
fi
echo ""
echo -e "${BLUE}🔍 替换结果:${NC}"
echo -e "   源字符串: $SOURCE_STRING"
echo -e "   目标字符串: $TARGET_STRING"
echo ""
echo -e "${YELLOW}⚠️  建议:${NC}"
echo -e "   • 检查替换后的配置文件是否正确"
echo -e "   • 验证服务是否正常运行"
echo -e "   • 注意：此操作未创建备份文件，请谨慎操作"
