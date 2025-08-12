#!/bin/bash

# ========================================
# 自动虚拟环境镜像管理器启动脚本
# ========================================

# 检查虚拟环境
if [ -d "venv" ]; then
    echo "激活虚拟环境..."
    source venv/bin/activate
else
    echo "创建虚拟环境..."
    python3 -m venv venv
    source venv/bin/activate
    echo "安装依赖..."
    pip install pyyaml
fi

# 运行镜像管理器
echo "启动镜像管理器..."
python smart-image-manager.py "$@"
