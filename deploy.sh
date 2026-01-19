#!/bin/bash
# 授权码生成系统 - Linux部署脚本

set -e

echo "========================================"
echo "授权码生成系统 - Linux部署"
echo "========================================"
echo

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否为root用户
if [ "$EUID" -eq 0 ]; then 
    echo -e "${YELLOW}警告: 不建议使用root用户运行${NC}"
fi

# 项目目录
PROJECT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_NAME="invitation-code-api"
SERVICE_USER="${APP_NAME}"

echo "[1/6] 检查系统环境..."

# 检查Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}错误: 未找到Python3，请先安装Python 3.7+${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
PYTHON_MAJOR_MINOR=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2 | tr -d '.')
echo "✓ Python版本: $(python3 --version)"

# 检查pip
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}错误: 未找到pip3${NC}"
    exit 1
fi

echo "✓ pip3已安装"

# 检查python3-venv包（Debian/Ubuntu）
if [ -f /etc/debian_version ]; then
    if ! python3 -m venv --help &> /dev/null; then
        echo -e "${YELLOW}检测到缺少python3-venv包，正在安装...${NC}"
        if command -v apt-get &> /dev/null; then
            apt-get update -qq
            apt-get install -y python3-venv python3-pip
            echo "✓ python3-venv已安装"
        else
            echo -e "${RED}错误: 无法自动安装python3-venv，请手动运行:${NC}"
            echo -e "${YELLOW}  apt-get install -y python3-venv python3-pip${NC}"
            exit 1
        fi
    else
        echo "✓ python3-venv已安装"
    fi
fi

echo
echo "[2/7] 检查配置文件..."

# 检查配置文件
if [ ! -f "$PROJECT_DIR/config.json" ]; then
    if [ -f "$PROJECT_DIR/config.json.example" ]; then
        echo "配置文件不存在，从示例文件创建..."
        cp "$PROJECT_DIR/config.json.example" "$PROJECT_DIR/config.json"
    else
        echo -e "${YELLOW}⚠️  警告: 配置文件不存在，将使用默认配置${NC}"
    fi
else
    echo "✓ 配置文件已存在"
fi

echo
echo "[3/7] 配置数据库信息..."

# 检查配置文件是否已存在且有数据库配置
NEED_CONFIG=true
if [ -f "$PROJECT_DIR/config.json" ]; then
    # 检查是否已有数据库配置
    if python3 -c "import json; f=open('$PROJECT_DIR/config.json'); c=json.load(f); f.close(); db=c.get('database', {}); exit(0 if db.get('host') and db.get('password') else 1)" 2>/dev/null; then
        echo "检测到已有数据库配置"
        echo ""
        echo "当前数据库配置："
        python3 << EOF
import json
with open('$PROJECT_DIR/config.json', 'r', encoding='utf-8') as f:
    config = json.load(f)
db = config.get('database', {})
print(f"  主机: {db.get('host', 'N/A')}")
print(f"  端口: {db.get('port', 'N/A')}")
print(f"  数据库: {db.get('database', 'N/A')}")
print(f"  用户: {db.get('user', 'N/A')}")
print(f"  密码: {'*' * len(str(db.get('password', ''))) if db.get('password') else 'N/A'}")
print(f"  字符集: {db.get('charset', 'N/A')}")
EOF
        echo ""
        echo -e "${YELLOW}是否需要重新配置数据库信息？${NC}"
        read -p "输入 y/Y 重新配置，直接回车使用现有配置: " reconfigure
        if [ "$reconfigure" != "y" ] && [ "$reconfigure" != "Y" ]; then
            NEED_CONFIG=false
            echo "✓ 使用现有数据库配置"
        fi
    else
        # 没有数据库配置，显示默认配置
        echo "未检测到数据库配置"
        echo ""
        echo "默认将使用以下配置："
        echo "  主机: 10.20.25.3"
        echo "  端口: 13306"
        echo "  数据库: clouditera_aigc"
        echo "  用户: root"
        echo "  密码: Clouditera@2023"
        echo "  字符集: utf8mb4"
        echo ""
        echo -e "${YELLOW}是否使用默认配置？${NC}"
        read -p "输入 y/Y 继续使用默认配置，输入 n/N 自定义配置，直接回车使用默认配置: " use_default
        if [ "$use_default" = "n" ] || [ "$use_default" = "N" ]; then
            echo "将进入自定义配置流程..."
        else
            echo "将使用默认配置（包括默认密码）"
        fi
    fi
fi

if [ "$NEED_CONFIG" = true ]; then
    # 创建Python脚本来更新配置
    cat > "$PROJECT_DIR/update_config.py" << 'PYEOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
import sys
import os

def update_database_config(config_path):
    """更新数据库配置信息"""
    # 读取现有配置
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            config = json.load(f)
    except Exception as e:
        print(f"错误: 无法读取配置文件: {e}")
        sys.exit(1)
    
    print("\n" + "="*50)
    print("请输入数据库连接信息")
    print("="*50)
    
    # 获取当前配置（如果有）
    current_db = config.get('database', {})
    
    # 数据库主机
    default_host = current_db.get('host', '10.20.25.3')
    host = input(f"数据库主机地址 [{default_host}]: ").strip()
    if not host:
        host = default_host
    
    # 数据库端口
    default_port = current_db.get('port', 13306)
    port_input = input(f"数据库端口 [{default_port}]: ").strip()
    if port_input:
        try:
            port = int(port_input)
        except ValueError:
            print("警告: 端口号必须是数字，使用默认值")
            port = default_port
    else:
        port = default_port
    
    # 数据库名称
    default_database = current_db.get('database', 'clouditera_aigc')
    database = input(f"数据库名称 [{default_database}]: ").strip()
    if not database:
        database = default_database
    
    # 数据库用户名
    default_user = current_db.get('user', 'root')
    user = input(f"数据库用户名 [{default_user}]: ").strip()
    if not user:
        user = default_user
    
    # 数据库密码（默认值：Clouditera@2023）
    default_password = current_db.get('password', 'Clouditera@2023')
    password_input = input(f"数据库密码 [默认: Clouditera@2023]: ").strip()
    if not password_input:
        password = default_password
        print("使用默认密码")
    else:
        password = password_input
    
    # 更新配置
    config['database'] = {
        'host': host,
        'port': port,
        'database': database,
        'user': user,
        'password': password,
        'charset': current_db.get('charset', 'utf8mb4'),
        'collation': current_db.get('collation', 'utf8mb4_unicode_ci')
    }
    
    # 保存配置（临时保存用于测试连接）
    try:
        with open(config_path, 'w', encoding='utf-8') as f:
            json.dump(config, f, indent=4, ensure_ascii=False)
    except Exception as e:
        print(f"\n错误: 无法保存配置文件: {e}")
        sys.exit(1)
    
    # 测试数据库连接
    print("\n正在测试数据库连接...")
    try:
        import mysql.connector
        from mysql.connector import Error
        
        connection = None
        try:
            connection = mysql.connector.connect(
                host=host,
                port=port,
                database=database,
                user=user,
                password=password,
                connection_timeout=5
            )
            if connection.is_connected():
                db_info = connection.get_server_info()
                print(f"✓ 数据库连接成功！MySQL 版本: {db_info}")
                connection.close()
        except Error as e:
            print(f"\n⚠️  警告: 数据库连接失败 - {e}")
            print("提示: 配置已保存，但请确认数据库信息是否正确")
            retry = input("\n是否重新输入数据库信息？(y/n) [n]: ").strip().lower()
            if retry == 'y':
                return update_database_config(config_path)
    except ImportError:
        print("⚠️  警告: 无法导入 mysql.connector，跳过数据库连接测试")
        print("提示: 配置已保存，但请确认数据库信息是否正确")
    
    print("\n✓ 数据库配置已更新")
    print(f"  主机: {host}")
    print(f"  端口: {port}")
    print(f"  数据库: {database}")
    print(f"  用户: {user}")
    print("  密码: ******")
    return True

if __name__ == '__main__':
    config_path = sys.argv[1] if len(sys.argv) > 1 else 'config.json'
    update_database_config(config_path)
PYEOF

    chmod +x "$PROJECT_DIR/update_config.py"

    # 执行数据库配置
    echo ""
    echo "========================================"
    echo "请输入数据库连接信息"
    echo "========================================"
    echo -e "${YELLOW}提示: 按回车键使用默认值或当前值${NC}"
    echo ""

    if python3 "$PROJECT_DIR/update_config.py" "$PROJECT_DIR/config.json"; then
        echo ""
        echo "✓ 数据库配置完成"
    else
        echo ""
        echo -e "${RED}错误: 数据库配置失败${NC}"
        # 清理临时脚本
        rm -f "$PROJECT_DIR/update_config.py"
        exit 1
    fi

    # 清理临时脚本
    rm -f "$PROJECT_DIR/update_config.py"
fi

echo
echo "[4/7] 安装Python依赖..."

# 创建虚拟环境（如果不存在或不完整）
if [ ! -d "$PROJECT_DIR/venv" ] || [ ! -f "$PROJECT_DIR/venv/bin/activate" ]; then
    if [ -d "$PROJECT_DIR/venv" ]; then
        echo "检测到不完整的虚拟环境，删除并重新创建..."
        rm -rf "$PROJECT_DIR/venv"
    fi
    echo "创建Python虚拟环境..."
    if ! python3 -m venv "$PROJECT_DIR/venv"; then
        echo -e "${RED}错误: 无法创建虚拟环境${NC}"
        echo -e "${YELLOW}请确保已安装python3-venv包:${NC}"
        echo -e "${YELLOW}  Ubuntu/Debian: apt-get install -y python3-venv${NC}"
        echo -e "${YELLOW}  CentOS/RHEL: yum install -y python3-venv${NC}"
        exit 1
    fi
    echo "✓ 虚拟环境创建成功"
fi

# 激活虚拟环境
echo "激活虚拟环境..."
if ! source "$PROJECT_DIR/venv/bin/activate"; then
    echo -e "${RED}错误: 虚拟环境激活失败${NC}"
    echo -e "${YELLOW}尝试重新创建虚拟环境...${NC}"
    rm -rf "$PROJECT_DIR/venv"
    if ! python3 -m venv "$PROJECT_DIR/venv"; then
        echo -e "${RED}错误: 重新创建虚拟环境失败${NC}"
        exit 1
    fi
    source "$PROJECT_DIR/venv/bin/activate"
fi

# 验证虚拟环境是否激活成功
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${RED}错误: 虚拟环境激活失败，VIRTUAL_ENV未设置${NC}"
    exit 1
fi
echo "✓ 虚拟环境已激活: $VIRTUAL_ENV"

# 升级pip
echo "升级pip..."
if ! pip install --upgrade pip -q; then
    echo -e "${YELLOW}警告: pip升级失败，继续安装依赖...${NC}"
fi

# 安装依赖
echo "安装依赖包..."
if ! pip install -r "$PROJECT_DIR/requirements_api.txt" -q; then
    echo -e "${RED}错误: 依赖包安装失败${NC}"
    echo -e "${YELLOW}尝试使用详细模式安装...${NC}"
    pip install -r "$PROJECT_DIR/requirements_api.txt"
    exit 1
fi

if ! pip install gunicorn -q; then
    echo -e "${YELLOW}警告: gunicorn安装失败，尝试详细安装...${NC}"
    pip install gunicorn
fi

echo "✓ 依赖包安装完成"

echo
echo "[5/7] 创建必要目录..."

# 创建日志目录
mkdir -p "$PROJECT_DIR/logs"
chmod 755 "$PROJECT_DIR/logs"

echo "✓ 目录创建完成"

echo
echo "[6/7] 设置文件权限..."

# 设置文件权限
chmod +x "$PROJECT_DIR/app.py"
chmod +x "$PROJECT_DIR/invitation_code_api.py"
chmod 644 "$PROJECT_DIR/config.json"

echo "✓ 权限设置完成"

echo
echo "[7/7] 生成启动脚本..."

# 生成启动脚本
cat > "$PROJECT_DIR/start.sh" << 'EOF'
#!/bin/bash
# 启动授权码生成系统API服务（后台运行）

cd "$(dirname "$0")"

# 检查服务是否已在运行
PID_FILE="logs/gunicorn.pid"
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "服务已在运行 (PID: $PID)"
        exit 0
    else
        rm -f "$PID_FILE"
    fi
fi

# 激活虚拟环境
source venv/bin/activate

# 读取配置
API_PORT=$(python3 -c "import json; f=open('config.json'); c=json.load(f); print(c['api']['port']); f.close()" 2>/dev/null || echo "30111")
API_HOST=$(python3 -c "import json; f=open('config.json'); c=json.load(f); print(c['api']['host']); f.close()" 2>/dev/null || echo "0.0.0.0")

echo "正在启动服务..."
echo "服务地址: http://${API_HOST}:${API_PORT}"

# 确保日志目录存在
mkdir -p logs

# 使用gunicorn运行（生产环境，后台运行）
if command -v gunicorn &> /dev/null; then
    nohup gunicorn -c gunicorn_config.py app:app > logs/startup.log 2>&1 &
    sleep 2
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo "✓ 服务已启动 (PID: $PID)"
            echo "查看日志: tail -f logs/error.log"
        else
            echo "✗ 服务启动失败，请查看日志: tail -f logs/startup.log"
            exit 1
        fi
    else
        echo "✗ 服务启动失败，请查看日志: tail -f logs/startup.log"
        exit 1
    fi
else
    # 开发环境直接运行（后台）
    nohup python3 invitation_code_api.py > logs/startup.log 2>&1 &
    echo "✓ 服务已在后台启动"
    echo "查看日志: tail -f logs/startup.log"
fi
EOF

chmod +x "$PROJECT_DIR/start.sh"

# 生成停止脚本
cat > "$PROJECT_DIR/stop.sh" << 'EOF'
#!/bin/bash
# 停止授权码生成系统API服务

PID_FILE="logs/gunicorn.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "停止服务 (PID: $PID)..."
        kill $PID
        rm -f "$PID_FILE"
        echo "✓ 服务已停止"
    else
        echo "服务未运行"
        rm -f "$PID_FILE"
    fi
else
    echo "服务未运行"
fi
EOF

chmod +x "$PROJECT_DIR/stop.sh"

# 生成重启脚本
cat > "$PROJECT_DIR/restart.sh" << 'EOF'
#!/bin/bash
# 重启授权码生成系统API服务

cd "$(dirname "$0")"
./stop.sh
sleep 2
./start.sh
EOF

chmod +x "$PROJECT_DIR/restart.sh"

echo "✓ 启动脚本生成完成"

echo
echo "========================================"
echo -e "${GREEN}部署完成！${NC}"
echo "========================================"
echo
echo "项目目录: $PROJECT_DIR"
echo
echo "启动服务:"
echo "  ./start.sh"
echo
echo "停止服务:"
echo "  ./stop.sh"
echo
echo "重启服务:"
echo "  ./restart.sh"
echo
echo "查看日志:"
echo "  tail -f logs/error.log"
echo "  tail -f logs/access.log"
echo
echo "========================================"

