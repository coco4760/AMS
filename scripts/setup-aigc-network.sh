#!/bin/bash

# ========================================
# AIGC网络设置脚本
# 创建和管理aigc Docker网络
# ========================================

set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}🌐 AIGC网络设置脚本${NC}"
echo ""

# 网络名称
NETWORK_NAME="aigc"
NETWORK_SUBNET="172.20.0.0/16"
NETWORK_GATEWAY="172.20.0.1"

# 检查Docker是否运行
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}❌ Docker未运行，请先启动Docker服务${NC}"
        echo -e "${YELLOW}💡 启动Docker: sudo systemctl start docker${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker服务运行正常${NC}"
}

# 检查网络是否存在
check_network() {
    if docker network ls | grep -q "$NETWORK_NAME"; then
        echo -e "${GREEN}✅ 网络 $NETWORK_NAME 已存在${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  网络 $NETWORK_NAME 不存在${NC}"
        return 1
    fi
}

# 创建网络
create_network() {
    echo -e "${BLUE}🔧 创建网络 $NETWORK_NAME...${NC}"
    
    if docker network create \
        --driver bridge \
        --subnet="$NETWORK_SUBNET" \
        --gateway="$NETWORK_GATEWAY" \
        "$NETWORK_NAME"; then
        echo -e "${GREEN}✅ 网络 $NETWORK_NAME 创建成功${NC}"
        return 0
    else
        echo -e "${RED}❌ 网络 $NETWORK_NAME 创建失败${NC}"
        return 1
    fi
}

# 显示网络信息
show_network_info() {
    echo -e "${BLUE}📊 网络 $NETWORK_NAME 信息:${NC}"
    docker network inspect "$NETWORK_NAME" | grep -E "(Name|Driver|Subnet|Gateway|Containers)" | head -10
}

# 删除网络
remove_network() {
    echo -e "${YELLOW}🗑️  删除网络 $NETWORK_NAME...${NC}"
    
    # 检查是否有容器使用此网络
    local container_count=$(docker network inspect "$NETWORK_NAME" 2>/dev/null | grep -c "Containers" || echo "0")
    
    if [ "$container_count" -gt 0 ]; then
        echo -e "${RED}⚠️  警告: 网络 $NETWORK_NAME 正在被容器使用${NC}"
        echo -e "${YELLOW}💡 请先停止使用此网络的容器${NC}"
        return 1
    fi
    
    if docker network rm "$NETWORK_NAME"; then
        echo -e "${GREEN}✅ 网络 $NETWORK_NAME 删除成功${NC}"
    else
        echo -e "${RED}❌ 网络 $NETWORK_NAME 删除失败${NC}"
        return 1
    fi
}

# 重新创建网络
recreate_network() {
    echo -e "${BLUE}🔄 重新创建网络 $NETWORK_NAME...${NC}"
    
    if check_network; then
        remove_network
    fi
    
    create_network
}

# 显示帮助
show_help() {
    cat << EOF
AIGC网络设置脚本

使用方法:
  $0 <命令> [选项]

命令:
  create      创建aigc网络
  remove      删除aigc网络
  recreate    重新创建aigc网络
  info        显示网络信息
  check       检查网络状态
  help        显示此帮助信息

选项:
  --force     强制删除网络（即使有容器使用）

网络配置:
  名称: $NETWORK_NAME
  子网: $NETWORK_SUBNET
  网关: $NETWORK_GATEWAY

示例:
  $0 create        # 创建网络
  $0 info          # 查看网络信息
  $0 remove        # 删除网络
  $0 recreate      # 重新创建网络

EOF
}

# 主函数
main() {
    local command="check"
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            create|remove|recreate|info|check|help)
                command="$1"
                shift
                ;;
            --force)
                FORCE_REMOVE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}❌ 未知参数: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 检查Docker环境
    check_docker
    echo ""
    
    # 执行命令
    case $command in
        create)
            if check_network; then
                echo -e "${YELLOW}⚠️  网络已存在，无需创建${NC}"
            else
                create_network
            fi
            ;;
        remove)
            if check_network; then
                remove_network
            else
                echo -e "${YELLOW}⚠️  网络不存在，无需删除${NC}"
            fi
            ;;
        recreate)
            recreate_network
            ;;
        info)
            if check_network; then
                show_network_info
            else
                echo -e "${YELLOW}⚠️  网络不存在，无法显示信息${NC}"
            fi
            ;;
        check)
            if check_network; then
                echo -e "${GREEN}✅ 网络状态正常${NC}"
                show_network_info
            else
                echo -e "${RED}❌ 网络不存在${NC}"
                echo -e "${YELLOW}💡 使用 '$0 create' 创建网络${NC}"
            fi
            ;;
        help)
            show_help
            ;;
        *)
            echo -e "${RED}❌ 未知命令: $command${NC}"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${PURPLE}🎯 命令执行完成！${NC}"
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
