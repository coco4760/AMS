#!/bin/bash
# 一键启动所有服务（API + UI）

set -e

PROJECT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "========================================"
echo "授权码生成系统 - 一键启动"
echo "========================================"
echo

# 检查配置文件
if [ ! -f "$PROJECT_DIR/config.json" ]; then
    echo "⚠️  配置文件不存在，请先运行 ./deploy.sh"
    exit 1
fi

# 获取API端口
API_PORT=$(python3 -c "import json; f=open('$PROJECT_DIR/config.json'); c=json.load(f); print(c['api']['port']); f.close()" 2>/dev/null || echo "30111")

# 获取服务器IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "启动集成服务（API + UI）..."
cd "$PROJECT_DIR"

# 启动服务（已在start.sh中后台运行）
./start.sh

# 获取服务器IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo
echo "========================================"
echo "✓ 服务已启动"
echo "========================================"
echo
echo "访问地址:"
echo "  本地: http://localhost:${API_PORT}"
echo "  网络: http://${SERVER_IP}:${API_PORT}"
echo
echo "说明:"
echo "  - UI和API已集成在同一服务中"
echo "  - 访问根路径 '/' 查看UI界面"
echo "  - API接口路径: '/api/*'"
echo
echo "管理命令:"
echo "  查看日志: tail -f logs/error.log"
echo "  停止服务: ./stop.sh"
echo "  重启服务: ./restart.sh"
echo "  查看状态: ps aux | grep gunicorn"
echo
echo "========================================"

