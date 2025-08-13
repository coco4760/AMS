#!/bin/bash

# ========================================
# 自动虚拟环境镜像管理器启动脚本
# ========================================

# 检测操作系统
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PYTHON_CMD="python3"
    VENV_ACTIVATE="venv/bin/activate"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PYTHON_CMD="python3"
    VENV_ACTIVATE="venv/bin/activate"
else
    PYTHON_CMD="python"
    VENV_ACTIVATE="venv/Scripts/activate"
fi

# 检查虚拟环境
if [ -d "venv" ]; then
    echo "激活虚拟环境..."
    if [ -f "$VENV_ACTIVATE" ]; then
        source "$VENV_ACTIVATE"
    else
        echo "虚拟环境激活脚本不存在，尝试直接使用Python..."
        PYTHON_CMD="venv/bin/python"
    fi
else
    echo "创建虚拟环境..."
    if command -v python3 &> /dev/null; then
        python3 -m venv venv
    elif command -v python &> /dev/null; then
        python -m venv venv
    else
        echo "错误: 未找到Python或Python3"
        exit 1
    fi
    
    if [ -f "$VENV_ACTIVATE" ]; then
        source "$VENV_ACTIVATE"
        echo "安装依赖..."
        pip install pyyaml
    else
        echo "虚拟环境创建失败"
        exit 1
    fi
fi

# 检查Python是否可用
if ! command -v python &> /dev/null && ! command -v python3 &> /dev/null; then
    echo "错误: Python命令不可用"
    exit 1
fi

# 运行镜像管理器
echo "启动镜像管理器..."
if command -v python &> /dev/null; then
    python smart-image-manager.py "$@"
else
    python3 smart-image-manager.py "$@"
fi
