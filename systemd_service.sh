#!/bin/bash
# 创建systemd服务文件

set -e

PROJECT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_NAME="invitation-code-api"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"
CURRENT_USER=$(whoami)

echo "创建systemd服务文件..."

# 检查是否为root或有sudo权限
if [ "$EUID" -ne 0 ]; then
    echo "需要使用sudo权限运行此脚本"
    echo "运行: sudo $0"
    exit 1
fi

# 创建服务文件
cat > "$SERVICE_FILE" << EOF
[Unit]
Description=授权码生成系统 API服务
After=network.target mysql.service

[Service]
Type=notify
User=${CURRENT_USER}
WorkingDirectory=${PROJECT_DIR}
Environment="PATH=${PROJECT_DIR}/venv/bin"
ExecStart=${PROJECT_DIR}/venv/bin/gunicorn -c ${PROJECT_DIR}/gunicorn_config.py app:app
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "✓ 服务文件已创建: $SERVICE_FILE"
echo
echo "使用以下命令管理服务:"
echo "  启动: sudo systemctl start ${APP_NAME}"
echo "  停止: sudo systemctl stop ${APP_NAME}"
echo "  重启: sudo systemctl restart ${APP_NAME}"
echo "  状态: sudo systemctl status ${APP_NAME}"
echo "  开机自启: sudo systemctl enable ${APP_NAME}"
echo "  禁用自启: sudo systemctl disable ${APP_NAME}"
echo
echo "重新加载systemd配置:"
echo "  sudo systemctl daemon-reload"

