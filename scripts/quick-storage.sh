#!/bin/bash

# 快速Storage服务管理脚本
# 提供启动、停止、重启、状态查看等功能的快捷方式

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 显示使用方法
show_usage() {
    echo -e "${BLUE}快速Storage服务管理脚本${NC}"
    echo ""
    echo "使用方法: $0 <命令> [选项]"
    echo ""
    echo "命令:"
echo "  start    启动所有storage服务"
echo "  stop     停止所有storage服务"
echo "  restart  重启所有storage服务"
echo "  status   查看所有服务状态"
echo "  logs     查看服务日志"
echo "  clean    清理有问题的数据目录"
echo "  help     显示此帮助信息"
    echo ""
    echo "选项:"
    echo "  -v       详细模式"
    echo "  -f       强制模式"
    echo "  -r       停止时移除容器"
    echo ""
    echo "示例:"
    echo "  $0 start        # 启动所有服务"
    echo "  $0 stop -r      # 停止并移除容器"
    echo "  $0 restart -v   # 详细模式重启"
    echo "  $0 status       # 查看服务状态"
}

# 检查脚本是否存在
check_script() {
    local script_name="$1"
    if [[ ! -f "scripts/$script_name" ]]; then
        echo -e "${RED}错误: 脚本 scripts/$script_name 不存在${NC}"
        exit 1
    fi
}

# 主函数
main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    local command="$1"
    shift
    local options="$@"
    
    case "$command" in
        start)
            check_script "start-storage-services.sh"
            echo -e "${GREEN}启动所有Storage服务...${NC}"
            echo -e "${BLUE}注意: 首次启动需要sudo权限来创建数据目录${NC}"
            ./scripts/start-storage-services.sh $options
            ;;
        stop)
            check_script "stop-storage-services.sh"
            echo -e "${YELLOW}停止所有Storage服务...${NC}"
            ./scripts/stop-storage-services.sh $options
            ;;
        restart)
            check_script "start-storage-services.sh"
            check_script "stop-storage-services.sh"
            echo -e "${BLUE}重启所有Storage服务...${NC}"
            echo "1. 停止服务..."
            ./scripts/stop-storage-services.sh $options
            echo "2. 等待5秒..."
            sleep 5
            echo "3. 启动服务..."
            ./scripts/start-storage-services.sh $options
            ;;
        status)
            echo -e "${BLUE}查看Storage服务状态...${NC}"
            for service_dir in storage/*/; do
                if [[ -d "$service_dir" ]]; then
                    service_name=$(basename "$service_dir")
                    compose_file="${service_dir}docker-compose.yaml"
                    
                    if [[ -f "$compose_file" ]]; then
                        echo ""
                        echo -e "${BLUE}=== $service_name ===${NC}"
                        if command -v docker-compose >/dev/null 2>&1; then
                            docker-compose -f "$compose_file" ps
                        else
                            docker compose -f "$compose_file" ps
                        fi
                    fi
                fi
            done
            ;;
        logs)
            echo -e "${BLUE}查看Storage服务日志...${NC}"
            echo "请选择要查看日志的服务:"
            echo "1) es (Elasticsearch)"
            echo "2) mysql"
            echo "3) redis"
            echo "4) mongo"
            echo "5) postgres"
            echo "6) minio"
            echo "7) qdrant"
            echo "8) 所有服务"
            echo ""
            read -p "请输入选择 (1-8): " choice
            
            case $choice in
                1) service="es" ;;
                2) service="mysql" ;;
                3) service="redis" ;;
                4) service="mongo" ;;
                5) service="postgres" ;;
                6) service="minio" ;;
                7) service="qdrant" ;;
                8) service="all" ;;
                *) echo "无效选择"; exit 1 ;;
            esac
            
            if [[ "$service" == "all" ]]; then
                for service_dir in storage/*/; do
                    if [[ -d "$service_dir" ]]; then
                        service_name=$(basename "$service_dir")
                        compose_file="${service_dir}docker-compose.yaml"
                        if [[ -f "$compose_file" ]]; then
                            echo ""
                            echo -e "${BLUE}=== $service_name 日志 ===${NC}"
                            if command -v docker-compose >/dev/null 2>&1; then
                                docker-compose -f "$compose_file" logs --tail=20
                            else
                                docker compose -f "$compose_file" logs --tail=20
                            fi
                        fi
                    fi
                done
            else
                compose_file="storage/$service/docker-compose.yaml"
                if [[ -f "$compose_file" ]]; then
                    if command -v docker-compose >/dev/null 2>&1; then
                        docker-compose -f "$compose_file" logs -f
                    else
                        docker compose -f "$compose_file" logs -f
                    fi
                else
                    echo -e "${RED}错误: 服务 $service 不存在${NC}"
                    exit 1
                fi
            fi
            ;;
        clean)
            echo -e "${YELLOW}清理有问题的数据目录...${NC}"
            echo ""
            echo "请选择清理模式:"
            echo "1) 安全清理 - 只清理损坏的文件，保留数据"
            echo "2) 完全清理 - 删除所有数据（危险！）"
            echo "3) 取消操作"
            echo ""
            read -p "请输入选择 (1-3): " choice
            
            case $choice in
                1)
                    echo -e "${BLUE}执行安全清理...${NC}"
                    echo "1. 停止所有服务..."
                    ./scripts/stop-storage-services.sh -f
                    
                    echo "2. 备份现有数据..."
                    local backup_dir="/var/lib/clouditera/data/backups/$(date +%Y%m%d_%H%M%S)"
                    sudo mkdir -p "$backup_dir"
                    
                    # 备份重要数据
                    if [[ -d "/var/lib/clouditera/data/mysql/data" ]]; then
                        sudo cp -r /var/lib/clouditera/data/mysql/data "$backup_dir/mysql_data"
                        echo "  - MySQL数据已备份到: $backup_dir/mysql_data"
                    fi
                    
                    if [[ -d "/var/lib/clouditera/data/es/data" ]]; then
                        sudo cp -r /var/lib/clouditera/data/es/data "$backup_dir/es_data"
                        echo "  - Elasticsearch数据已备份到: $backup_dir/es_data"
                    fi
                    
                    echo "3. 清理损坏的文件..."
                    sudo find /var/lib/clouditera/data -name "*.lock" -delete 2>/dev/null || true
                    sudo find /var/lib/clouditera/data -name "*.tmp" -delete 2>/dev/null || true
                    sudo find /var/lib/clouditera/data -name "*.pid" -delete 2>/dev/null || true
                    
                    echo "4. 重新创建目录结构..."
                    sudo mkdir -p /var/lib/clouditera/data/{es/{data,plugins},mysql/{data,logs},redis/data,mongo/data,postgres/data,minio/data,qdrant/data}
                    
                    echo "5. 设置目录权限..."
                    sudo chown -R 1000:1000 /var/lib/clouditera/data/es
                    sudo chown -R 999:999 /var/lib/clouditera/data/{mysql,redis,mongo,postgres}
                    sudo chown -R 1000:1000 /var/lib/clouditera/data/{minio,qdrant}
                    sudo chmod -R 755 /var/lib/clouditera/data
                    
                    echo -e "${GREEN}安全清理完成！${NC}"
                    echo "数据已备份到: $backup_dir"
                    echo "现在可以使用 './scripts/quick-storage.sh start' 重新启动服务"
                    ;;
                2)
                    echo -e "${RED}执行完全清理...${NC}"
                    echo "警告: 这将删除所有数据，无法恢复！"
                    read -p "确认删除所有数据? (输入 'DELETE ALL' 确认): " confirm
                    if [[ "$confirm" == "DELETE ALL" ]]; then
                        echo "1. 停止所有服务..."
                        ./scripts/stop-storage-services.sh -f
                        
                        echo "2. 删除所有数据..."
                        sudo rm -rf /var/lib/clouditera/data/*
                        
                        echo "3. 重新创建目录结构..."
                        sudo mkdir -p /var/lib/clouditera/data/{es/{data,plugins},mysql/{data,logs},redis/data,mongo/data,postgres/data,minio/data,qdrant/data}
                        
                        echo "4. 设置目录权限..."
                        sudo chown -R 1000:1000 /var/lib/clouditera/data/es
                        sudo chown -R 999:999 /var/lib/clouditera/data/{mysql,redis,mongo,postgres}
                        sudo chown -R 1000:1000 /var/lib/clouditera/data/{minio,qdrant}
                        sudo chmod -R 755 /var/lib/clouditera/data
                        
                        echo -e "${GREEN}完全清理完成！${NC}"
                        echo "现在可以使用 './scripts/quick-storage.sh start' 重新启动服务"
                    else
                        echo "操作已取消"
                    fi
                    ;;
                3)
                    echo "操作已取消"
                    ;;
                *)
                    echo "无效选择，操作已取消"
                    ;;
            esac
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            echo -e "${RED}错误: 未知命令 '$command'${NC}"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
