#!/bin/bash
# 停止服务（UI和API已集成）

PROJECT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "停止服务..."

# 停止集成服务
if [ -f "$PROJECT_DIR/stop.sh" ]; then
    cd "$PROJECT_DIR"
    ./stop.sh
fi

echo "✓ 服务已停止"

