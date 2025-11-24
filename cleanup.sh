#!/bin/bash
# cleanup.sh - SecCortex 环境清理脚本入口

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/scripts/cleanup.sh" "$@"

