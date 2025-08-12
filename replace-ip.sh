#!/bin/bash

# ========================================
# 简单IP替换脚本
# 将所有的 ${replace_ip} 替换为指定的IP地址
# ========================================

# 检查参数
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <目标IP地址>"
    echo "示例: $0 192.168.1.100"
    exit 1
fi

TARGET_IP=$1

echo "开始替换IP地址..."
echo "目标IP: $TARGET_IP"
echo "========================================"

# 查找所有包含 ${replace_ip} 的文件
echo "查找需要替换的文件..."
FILES_TO_REPLACE=$(grep -r '\${replace_ip}' . --include="*.env" --include="*.yml" --include="*.yaml" --include="*.json" --include="*.conf" --include="*.sh" --include="*.md" 2>/dev/null | cut -d: -f1 | sort | uniq | grep -v "replace-ip.sh" | grep -v "README-IP-REPLACE.md")

if [ -z "$FILES_TO_REPLACE" ]; then
    echo "未找到包含 \${replace_ip} 的文件"
    echo "请确保已经将需要替换的IP地址标记为 \${replace_ip}"
    exit 1
fi

echo "找到以下文件需要替换："
echo "$FILES_TO_REPLACE"
echo "========================================"

# 确认是否继续
read -p "是否继续替换？(y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "操作已取消"
    exit 0
fi

# 执行替换
echo "开始替换..."
REPLACED_COUNT=0

for file in $FILES_TO_REPLACE; do
    if [ -f "$file" ]; then
        echo "处理文件: $file"
        
        # 创建备份
        cp "$file" "$file.bak"
        
        # 执行替换 (兼容 macOS 和 Linux)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/\${replace_ip}/$TARGET_IP/g" "$file"
        else
            # Linux
            sed -i "s/\${replace_ip}/$TARGET_IP/g" "$file"
        fi
        
        # 检查替换结果
        if grep -q "$TARGET_IP" "$file"; then
            echo "  ✓ 替换成功"
            REPLACED_COUNT=$((REPLACED_COUNT + 1))
        else
            echo "  ✗ 替换失败"
        fi
    fi
done

echo "========================================"
echo "替换完成！"
echo "总共处理文件数: $REPLACED_COUNT"
echo "备份文件已创建（.bak后缀）"
echo
echo "替换后的IP地址: $TARGET_IP"
echo "请检查配置文件是否正确"
