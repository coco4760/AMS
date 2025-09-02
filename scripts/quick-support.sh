#!/bin/bash

# ========================================
# Support服务快速启动脚本
# 一键启动所有support服务
# ========================================

# 移除set -e，允许脚本在失败时继续执行
# set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SUPPORT_DIR="$PROJECT_ROOT/support"

# 获取Docker Compose命令
get_docker_compose_cmd() {
    if command -v docker-compose >/dev/null 2>&1; then
        echo "docker-compose"
    else
        echo "docker compose"
    fi
}

# 发现 support 目录下所有包含 docker-compose 的服务目录（按名称排序）
discover_services() {
    local dir
    while IFS= read -r dir; do
        if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ]; then
            basename "$dir"
        fi
    done < <(find "$SUPPORT_DIR" -mindepth 1 -maxdepth 1 -type d | sort)
}

# 检查Docker环境
check_docker_environment() {
    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED}❌ Docker未运行，请先启动Docker服务${NC}"
        return 1
    fi
    
    if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
        echo -e "${RED}❌ Docker Compose未安装${NC}"
        return 1
    fi
    
    return 0
}

# 启动服务函数
start_service() {
    local service_dir="$1"
    local service_name="$2"
    local compose_cmd="$3"
    
    if [ -d "$service_dir" ]; then
        echo -e "${GREEN}📦 启动 $service_name...${NC}"
        cd "$service_dir"
        
        # 查找docker-compose文件
        local compose_file=""
        if [ -f "docker-compose.yml" ]; then
            compose_file="docker-compose.yml"
        elif [ -f "docker-compose.yaml" ]; then
            compose_file="docker-compose.yaml"
        fi
        
        if [ -n "$compose_file" ]; then
            if $compose_cmd -f "$compose_file" up -d; then
                echo -e "${GREEN}✅ $service_name 启动成功${NC}"
                return 0
            else
                echo -e "${RED}❌ $service_name 启动失败${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠️  $service_name 未找到docker-compose文件${NC}"
            return 2
        fi
        
        cd - >/dev/null
    else
        echo -e "${YELLOW}⚠️  服务目录 $service_dir 不存在${NC}"
        return 2
    fi
}

# 停止服务函数
stop_service() {
    local service_dir="$1"
    local service_name="$2"
    local compose_cmd="$3"
    
    if [ -d "$service_dir" ]; then
        echo -e "${YELLOW}🛑 停止 $service_name...${NC}"
        cd "$service_dir"
        
        # 查找docker-compose文件
        local compose_file=""
        if [ -f "docker-compose.yml" ]; then
            compose_file="docker-compose.yml"
        elif [ -f "docker-compose.yaml" ]; then
            compose_file="docker-compose.yaml"
        fi
        
        if [ -n "$compose_file" ]; then
            if $compose_cmd -f "$compose_file" down; then
                echo -e "${GREEN}✅ $service_name 停止成功${NC}"
                return 0
            else
                echo -e "${RED}❌ $service_name 停止失败${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠️  $service_name 未找到docker-compose文件${NC}"
            return 2
        fi
        
        cd - >/dev/null
    else
        echo -e "${YELLOW}⚠️  服务目录 $service_dir 不存在${NC}"
        return 2
    fi
}

# 主函数
main() {
    local command="start"
    
    # 解析命令行参数
    if [ $# -gt 0 ]; then
        case "$1" in
            start|stop|status|help)
                command="$1"
                ;;
            *)
                echo -e "${RED}❌ 未知命令: $1${NC}"
                echo -e "${YELLOW}使用方法: $0 [start|stop|status|help]${NC}"
                exit 1
                ;;
        esac
    fi
    
    # 对于help命令，不需要检查Docker环境
    if [ "$command" = "help" ]; then
        show_help
        return 0
    fi
    
    # 检查Docker环境
    if ! check_docker_environment; then
        exit 1
    fi
    
    # 获取Docker Compose命令
    local compose_cmd=$(get_docker_compose_cmd)
    
    case "$command" in
        start)
            start_all_services "$compose_cmd"
            ;;
        stop)
            stop_all_services "$compose_cmd"
            ;;
        status)
            show_services_status "$compose_cmd"
            ;;
    esac
}

# 启动所有服务
start_all_services() {
    local compose_cmd="$1"
    echo -e "${GREEN}🔍 扫描support目录...${NC}"
    
    # 自动扫描 support 下的所有服务目录（仅包含 docker-compose 的目录）
    mapfile -t services < <(discover_services)
    
    # 统计变量
    success_count=0
    failed_count=0
    skipped_count=0
    
    for service in "${services[@]}"; do
        service_path="$SUPPORT_DIR/$service"
        start_service "$service_path" "$service" "$compose_cmd"
        exit_code=$?
        
        case $exit_code in
            0)
                success_count=$((success_count + 1))
                ;;
            1)
                failed_count=$((failed_count + 1))
                echo -e "${YELLOW}⚠️  继续启动下一个服务...${NC}"
                ;;
            2)
                skipped_count=$((skipped_count + 1))
                ;;
        esac
        
        echo ""
    done
    
    # 显示启动结果摘要
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}启动结果摘要${NC}"
    echo -e "${GREEN}========================================${NC}"
    
    if [ $success_count -gt 0 ]; then
        echo -e "${GREEN}✅ 成功启动: $success_count 个服务${NC}"
    fi
    
    if [ $failed_count -gt 0 ]; then
        echo -e "${RED}❌ 启动失败: $failed_count 个服务${NC}"
    fi
    
    if [ $skipped_count -gt 0 ]; then
        echo -e "${YELLOW}⚠️  跳过: $skipped_count 个服务${NC}"
    fi
    
    echo ""
    
    if [ $failed_count -eq 0 ] && [ $skipped_count -eq 0 ]; then
        echo -e "${GREEN}🎉 所有服务启动完成！${NC}"
    else
        echo -e "${YELLOW}⚠️  部分服务启动失败或跳过，但脚本已继续执行完成${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}💡 使用以下命令查看服务状态：${NC}"
    echo -e "   docker ps"
    echo -e "   $0 status"
    echo ""
    echo -e "${YELLOW}💡 使用以下命令停止所有服务：${NC}"
    echo -e "   $0 stop"
}

# 停止所有服务
stop_all_services() {
    local compose_cmd="$1"
    echo -e "${YELLOW}🔍 扫描support目录...${NC}"
    
    # 自动扫描 support 下的所有服务目录，并按相反顺序停止
    mapfile -t services < <(discover_services | tac)
    
    # 统计变量
    success_count=0
    failed_count=0
    skipped_count=0
    
    for service in "${services[@]}"; do
        service_path="$SUPPORT_DIR/$service"
        stop_service "$service_path" "$service" "$compose_cmd"
        exit_code=$?
        
        case $exit_code in
            0)
                success_count=$((success_count + 1))
                ;;
            1)
                failed_count=$((failed_count + 1))
                echo -e "${YELLOW}⚠️  继续停止下一个服务...${NC}"
                ;;
            2)
                skipped_count=$((skipped_count + 1))
                ;;
        esac
        
        echo ""
    done
    
    # 显示停止结果摘要
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}停止结果摘要${NC}"
    echo -e "${YELLOW}========================================${NC}"
    
    if [ $success_count -gt 0 ]; then
        echo -e "${GREEN}✅ 成功停止: $success_count 个服务${NC}"
    fi
    
    if [ $failed_count -gt 0 ]; then
        echo -e "${RED}❌ 停止失败: $failed_count 个服务${NC}"
    fi
    
    if [ $skipped_count -gt 0 ]; then
        echo -e "${YELLOW}⚠️  跳过: $skipped_count 个服务${NC}"
    fi
    
    echo ""
    
    if [ $failed_count -eq 0 ] && [ $skipped_count -eq 0 ]; then
        echo -e "${GREEN}🎉 所有服务停止完成！${NC}"
    else
        echo -e "${YELLOW}⚠️  部分服务停止失败或跳过，但脚本已继续执行完成${NC}"
    fi
}

# 显示服务状态
show_services_status() {
    local compose_cmd="$1"
    echo -e "${GREEN}🔍 检查support服务状态...${NC}"
    echo ""
    
    # 自动扫描 support 下的所有服务目录（仅包含 docker-compose 的目录）
    mapfile -t services < <(discover_services)
    
    for service in "${services[@]}"; do
        service_path="$SUPPORT_DIR/$service"
        if [ -d "$service_path" ]; then
            echo -e "${GREEN}📦 $service:${NC}"
            cd "$service_path"
            
            # 查找docker-compose文件
            local compose_file=""
            if [ -f "docker-compose.yml" ]; then
                compose_file="docker-compose.yml"
            elif [ -f "docker-compose.yaml" ]; then
                compose_file="docker-compose.yaml"
            fi
            
            if [ -n "$compose_file" ]; then
                if $compose_cmd -f "$compose_file" ps | grep -q "Up"; then
                    echo -e "  ${GREEN}✅ 正在运行${NC}"
                    $compose_cmd -f "$compose_file" ps
                else
                    echo -e "  ${YELLOW}⚠️  未运行${NC}"
                fi
            else
                echo -e "  ${YELLOW}⚠️  未找到docker-compose文件${NC}"
            fi
            
            cd - >/dev/null
            echo ""
        fi
    done
}

# 显示帮助信息
show_help() {
    cat << EOF
Support服务快速管理脚本

使用方法:
  $0 [命令]

命令:
  start     启动所有Support服务 (默认)
  stop      停止所有Support服务
  status    显示所有Support服务状态
  help      显示此帮助信息

示例:
  $0              # 启动所有服务
  $0 start        # 启动所有服务
  $0 stop         # 停止所有服务
  $0 status       # 查看服务状态
  $0 help         # 显示帮助

注意事项:
  - 确保Docker和Docker Compose已安装并运行
  - 服务按依赖顺序启动，按相反顺序停止
  - 启动失败时会继续执行下一个服务
  - 建议在启动前检查环境变量配置

EOF
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
