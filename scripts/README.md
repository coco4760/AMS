# Wuji Deployment Scripts 脚本使用指南

本目录包含了Wuji部署相关的所有脚本工具，用于自动化部署、服务管理和环境维护。

## 📋 脚本概览

| 脚本名称 | 功能描述 | 适用场景 |
|---------|---------|---------|
| `start-support-services.sh` | Support服务完整管理脚本 | 生产环境、运维管理 |
| `quick-support.sh` | Support服务快速启动脚本 | 开发测试、快速部署 |
| `start-services.sh` | Services服务完整管理脚本 | 生产环境、运维管理 |
| `quick-services.sh` | Services服务快速启动脚本 | 开发测试、快速部署 |
| `start-storage-services.sh` | Storage服务管理脚本 | 存储服务管理 |
| `start-plugins-services.sh` | Plugins服务完整管理脚本 | 生产环境、运维管理 |
| `quick-plugins.sh` | Plugins服务快速启动脚本 | 开发测试、快速部署 |
| `clean-environment.sh` | 环境清理脚本 | 环境重置、故障排除 |
| `setup-aigc-network.sh` | AIGC网络管理脚本 | 网络配置管理 |
| `replace-ip.sh` | IP地址替换工具 | 环境迁移、配置更新 |
| `auto-deploy.sh` | 一键自动部署脚本 | 完整部署流程 |

## 🚀 快速开始

### 1. 一键启动所有服务
```bash
# 启动Support服务
./scripts/quick-support.sh

# 启动Services服务
./scripts/quick-services.sh

# 启动Plugins服务
./scripts/quick-plugins.sh

# 启动Storage服务
./scripts/start-storage-services.sh
```

### 2. 完整服务管理
```bash
# Support服务管理
./scripts/start-support-services.sh start --continue-on-failure
./scripts/start-support-services.sh status
./scripts/start-support-services.sh stop

# Services服务管理
./scripts/start-services.sh start --continue-on-failure
./scripts/start-services.sh status
./scripts/start-services.sh stop

# Plugins服务管理
./scripts/start-plugins-services.sh start
./scripts/start-plugins-services.sh status
./scripts/start-plugins-services.sh stop
```

### 3. 一键自动部署
```bash
# 完整部署流程（包含IP替换）
./scripts/auto-deploy.sh --source-ip 192.168.1.100 --target-ip 10.0.0.100

# 跳过IP替换的部署
./scripts/auto-deploy.sh --skip-ip-replace --skip-sql-init
```

## 🔧 Support服务管理

### 服务列表
- **Nacos**: 配置中心 (端口: 18848)
- **RabbitMQ**: 消息队列 (端口: 15672)
- **Kong**: API网关 (端口: 8000)
- **IAM**: 身份认证 (端口: 9000)
- **FileMS**: 文件管理 (端口: 9001)
- **Collabnet**: 协作网络 (端口: 9002)
- **Mineru**: 数据挖掘 (端口: 9003)
- **Node Manager**: 节点管理 (端口: 9004)
- **RAG Server**: 后端服务 (端口: 9005)

### 使用方法
```bash
# 启动所有服务
./scripts/start-support-services.sh start

# 启动服务（失败时继续）
./scripts/start-support-services.sh start --continue-on-failure

# 查看服务状态
./scripts/start-support-services.sh status

# 停止所有服务
./scripts/start-support-services.sh stop

# 重启所有服务
./scripts/start-support-services.sh restart
```

### 快速启动
```bash
./scripts/quick-support.sh
```

## 🏢 Services服务管理

### 服务列表
- **Auth**: 认证服务 (端口: 8080)
- **Wuji**: 无极服务 (端口: 8081)
- **SAST**: 安全测试 (端口: 8082)
- **Web**: 前端服务 (端口: 80)

### 使用方法
```bash
# 启动所有服务
./scripts/start-services.sh start

# 启动服务（失败时继续）
./scripts/start-services.sh start --continue-on-failure

# 查看服务状态
./scripts/start-services.sh status

# 停止所有服务
./scripts/start-services.sh stop

# 重启所有服务
./scripts/start-services.sh restart
```

### 快速启动
```bash
./scripts/quick-services.sh
```

## 🔌 Plugins服务管理

### 服务特点
- **自动服务发现**: 自动扫描plugins目录下的所有服务
- **配置验证**: 检查docker-compose.yml和.env文件完整性
- **灵活启动**: 支持单个服务启动和批量管理
- **状态监控**: 实时查看服务运行状态

### 使用方法
```bash
# 启动所有插件服务
./scripts/start-plugins-services.sh start

# 查看服务状态
./scripts/start-plugins-services.sh status

# 查看成功启动的服务状态
./scripts/start-plugins-services.sh status-successful

# 停止所有服务
./scripts/start-plugins-services.sh stop

# 重启所有服务
./scripts/start-plugins-services.sh restart

# 清理日志文件
./scripts/start-plugins-services.sh clean-logs
```

### 快速启动
```bash
./scripts/quick-plugins.sh
```

### 服务配置要求
每个插件服务目录需要包含：
- `docker-compose.yml` 或 `docker-compose.yaml` 文件
- `.env` 环境变量文件

## 💾 Storage服务管理

### 使用方法
```bash
# 启动存储服务
./scripts/start-storage-services.sh

# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs
```

## 🧹 环境清理工具

### 功能特性
- **容器清理**: 停止并删除所有Docker容器
- **镜像清理**: 删除所有Docker镜像
- **数据清理**: 删除指定的数据目录
- **系统清理**: 清理Docker系统资源

### 使用方法
```bash
# 预览清理内容
./scripts/clean-environment.sh --preview-only

# 执行完整清理
./scripts/clean-environment.sh

# 跳过数据目录清理
./scripts/clean-environment.sh --no-data-dir

# 跳过Docker系统清理
./scripts/clean-environment.sh --no-docker-clean

# 强制清理（跳过确认）
./scripts/clean-environment.sh --force
```

## 🌐 网络管理工具

### 功能特性
- **网络创建**: 创建aigc Docker网络
- **网络配置**: 设置子网和网关
- **网络管理**: 查看、删除、重建网络

### 使用方法
```bash
# 创建网络
./scripts/setup-aigc-network.sh create

# 查看网络信息
./scripts/setup-aigc-network.sh info

# 检查网络状态
./scripts/setup-aigc-network.sh check

# 删除网络
./scripts/setup-aigc-network.sh remove

# 重建网络
./scripts/setup-aigc-network.sh recreate
```

## 🔄 IP地址替换工具

### 功能特性
- **批量替换**: 递归替换所有配置文件中的IP地址
- **多格式支持**: 支持.env、.yml、.yaml等配置文件
- **安全操作**: 不生成备份文件，直接替换
- **跨平台**: 兼容Linux和macOS

### 使用方法
```bash
# 替换IP地址
./replace-ip.sh <源IP地址> <目标IP地址>

# 示例：将192.168.1.100替换为10.0.0.100
./replace-ip.sh 192.168.1.100 10.0.0.100

# 多个IP替换
./replace-ip.sh 172.16.0.1 192.168.0.1
./replace-ip.sh 192.168.0.100 10.0.0.100
```

## 🚀 自动部署工具

### 部署流程
1. **IP地址替换**: 替换配置文件中的IP地址
2. **启动Storage服务**: 启动基础存储服务
3. **SQL数据初始化**: 执行数据初始化脚本
4. **启动Support服务**: 启动基础支持服务
5. **启动AI Brain服务**: 启动AI核心服务
6. **启动Plugins服务**: 启动插件服务
7. **启动Services服务**: 启动业务服务

### 使用方法
```bash
# 完整部署（包含IP替换）
./scripts/auto-deploy.sh --source-ip 192.168.1.100 --target-ip 10.0.0.100

# 跳过IP替换的部署
./scripts/auto-deploy.sh --skip-ip-replace

# 跳过SQL初始化的部署
./scripts/auto-deploy.sh --skip-sql-init

# 强制部署（跳过确认）
./scripts/auto-deploy.sh --force

# 详细输出模式
./scripts/auto-deploy.sh --verbose
```

## 📊 测试和演示

### 测试脚本
```bash
# 测试Support服务脚本
./scripts/test-support-scripts.sh

# 测试Services服务脚本
./scripts/test-services-scripts.sh

# 测试Plugins服务脚本
./scripts/test-plugins-scripts.sh
```

### 演示脚本
```bash
# 演示Support服务脚本功能
./scripts/demo-support.sh

# 演示Services服务脚本功能
./scripts/demo-services.sh

# 演示Plugins服务脚本功能
./scripts/demo-plugins.sh
```

## 🔧 脚本配置

### 环境变量
- `SCRIPT_DIR`: 脚本目录路径
- `PROJECT_ROOT`: 项目根目录路径
- `LOG_FILE`: 日志文件路径
- `ERROR_LOG_FILE`: 错误日志文件路径

### 端口配置
各服务的默认端口配置在对应的`.env`文件中，可根据需要修改。

## 📝 最佳实践

### 部署前准备
1. **环境检查**: 确保Docker和Docker Compose已安装
2. **配置验证**: 检查所有服务的配置文件
3. **资源确认**: 确认系统资源充足
4. **备份配置**: 备份重要配置文件

### 启动顺序
1. Storage服务（数据库、存储）
2. Support服务（基础支持）
3. AI Brain服务（AI核心）
4. Plugins服务（插件扩展）
5. Services服务（业务应用）

### 故障排除
1. **查看日志**: 检查各服务的日志文件
2. **状态检查**: 使用status命令检查服务状态
3. **依赖验证**: 确认服务依赖关系
4. **网络检查**: 验证Docker网络配置

## 🆘 故障排除

### 常见问题

#### 1. Docker服务未启动
```bash
# 启动Docker服务
sudo systemctl start docker

# 检查Docker状态
sudo systemctl status docker
```

#### 2. 端口冲突
```bash
# 检查端口占用
sudo netstat -tulpn | grep :端口号

# 停止占用端口的服务
sudo lsof -ti:端口号 | xargs kill -9
```

#### 3. 权限问题
```bash
# 添加用户到docker组
sudo usermod -aG docker $USER

# 重新登录或重启
newgrp docker
```

#### 4. 网络问题
```bash
# 检查Docker网络
docker network ls

# 重建网络
./scripts/setup-aigc-network.sh recreate
```

## 📞 技术支持

### 获取帮助
```bash
# 查看脚本帮助
./scripts/start-support-services.sh help
./scripts/start-services.sh help
./scripts/start-plugins-services.sh help
./scripts/clean-environment.sh help
```

### 日志文件位置
- **Support服务日志**: `support-services-start.log`, `support-services-error.log`
- **Services服务日志**: `services-start.log`, `services-error.log`
- **Plugins服务日志**: `plugins-start.log`, `plugins-error.log`
- **自动部署日志**: `auto-deploy.log`, `auto-deploy-error.log`

### 联系支持
如果遇到问题：
1. 检查脚本日志输出
2. 查看Docker服务状态
3. 参考故障排除指南
4. 联系系统管理员
5. 提交问题报告

---

**重要提醒**: 
- 本脚本适用于生产环境，请确保在测试环境充分验证
- 每个脚本都有详细的帮助信息，使用前请查看帮助
- 建议在部署过程中记录详细的操作日志
- 如遇到问题，请参考故障排除指南或联系技术支持
