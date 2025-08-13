#!/bin/bash

# ========================================
# Linux环境镜像管理器启动脚本
# ========================================

echo "检测Python环境..."

# 检查Python命令
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
    echo "使用 python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
    echo "使用 python"
else
    echo "错误: 未找到Python或Python3"
    echo "请安装Python: sudo apt-get install python3 python3-pip"
    exit 1
fi

# 检查虚拟环境
if [ -d "venv" ]; then
    echo "发现虚拟环境，尝试激活..."
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        echo "虚拟环境已激活"
    elif [ -f "venv/bin/python" ] || [ -f "venv/bin/python3" ]; then
        echo "使用虚拟环境中的Python"
        if [ -f "venv/bin/python3" ]; then
            PYTHON_CMD="venv/bin/python3"
        else
            PYTHON_CMD="venv/bin/python"
        fi
    else
        echo "虚拟环境损坏，重新创建..."
        rm -rf venv
    fi
fi

# 如果没有虚拟环境，创建一个
if [ ! -d "venv" ]; then
    echo "创建虚拟环境..."
    $PYTHON_CMD -m venv venv
    
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        echo "安装依赖..."
        pip install pyyaml
        echo "虚拟环境创建完成"
    else
        echo "虚拟环境创建失败"
        exit 1
    fi
fi

# 检查PyYAML
echo "检查依赖..."
if ! $PYTHON_CMD -c "import yaml" 2>/dev/null; then
    echo "PyYAML未安装，尝试安装..."
    if [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        pip install pyyaml
    else
        $PYTHON_CMD -m pip install pyyaml
    fi
fi

# 运行镜像管理器
echo "启动镜像管理器..."
$PYTHON_CMD smart-image-manager.py "$@"
