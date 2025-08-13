# Wuji Deployment Docker 脚本管理文档

本目录包含了用于管理Wuji部署Docker环境的完整脚本集合，涵盖支持服务、业务服务、存储服务和环境清理等各个方面。

## 📚 文档导航

- [脚本概览](#脚本概览)
- [支持服务管理](#支持服务管理)
- [业务服务管理](#业务服务管理)
- [存储服务管理](#存储服务管理)
- [环境清理工具](#环境清理工具)
- [网络管理工具](#网络管理工具)
- [通用工具](#通用工具)
- [最佳实践](#最佳实践)
- [故障排除](#故障排除)

## 🎯 脚本概览

### 按功能分类

| 类别 | 脚本名称 | 主要功能 | 适用场景 |
|------|----------|----------|----------|
| **支持服务** | `start-support-services.sh` | 完整支持服务管理 | 生产环境部署 |
| **支持服务** | `quick-support.sh` | 快速启动支持服务 | 日常开发测试 |
| **业务服务** | `start-services.sh` | 完整业务服务管理 | 生产环境部署 |
| **业务服务** | `quick-services.sh` | 快速启动业务服务 | 日常开发测试 |
| **存储服务** | `start-storage-services.sh` | 存储服务管理 | 存储环境部署 |
| **存储服务** | `quick-storage.sh` | 快速启动存储服务 | 存储服务测试 |
| **存储服务** | `stop-storage-services.sh` | 停止存储服务 | 服务维护 |
| **环境清理** | `clean-environment.sh` | 完全环境清理 | 环境重置 |
| **网络管理** | `setup-aigc-network.sh` | AIGC网络配置 | 网络环境搭建 |

## 🚀 支持服务管理

### 服务列表

支持服务是系统的基础组件，包括：

1. **nacos** - 配置中心服务
2. **rabbitmq** - 消息队列服务
3. **kong** - API网关服务
4. **iam** - 身份认证服务
5. **filems** - 文件管理服务
6. **collabnet** - 协作网络服务
7. **mineru** - 数据挖掘服务
8. **node_manager** - 节点管理服务
9. **rag-server** - RAG服务后端

### 使用方法

#### 完整功能脚本（推荐生产环境）
```bash
# 启动所有支持服务
./start-support-services.sh

# 启动失败时继续执行其他服务
./start-support-services.sh start --continue-on-failure

# 查看服务状态
./start-support-services.sh status

# 停止所有服务
./start-support-services.sh stop

# 重启所有服务
./start-support-services.sh restart
```

#### 快速启动脚本（推荐日常使用）
```bash
# 一键启动所有支持服务
./quick-support.sh
```

### 特性
- **智能依赖管理**: 按服务依赖关系自动排序启动
- **失败时继续执行**: 可选择在服务启动失败时继续执行其他服务
- **详细日志记录**: 完整的启动日志和错误日志
- **状态监控**: 实时显示服务启动状态和运行情况

## 💼 业务服务管理

### 服务列表

业务服务是系统的核心应用组件，包括：

1. **auth** - 认证服务
2. **wuji** - 无极服务
3. **sast** - SAST服务
4. **web** - Web前端服务

### 使用方法

#### 完整功能脚本（推荐生产环境）
```bash
# 启动所有业务服务
./start-services.sh

# 启动失败时继续执行其他服务
./start-services.sh start --continue-on-failure

# 查看服务状态
./start-services.sh status

# 停止所有服务
./start-services.sh stop

# 重启所有服务
./start-services.sh restart
```

#### 快速启动脚本（推荐日常使用）
```bash
# 一键启动所有业务服务
./quick-services.sh
```

### 特性
- **环境变量检查**: 自动检查每个服务的.env配置文件
- **配置文件验证**: 确保必要的配置文件存在
- **端口冲突检测**: 检查服务端口是否被占用
- **启动顺序优化**: 按依赖关系智能排序启动

## 💾 存储服务管理

### 服务列表

存储服务负责系统的数据存储和管理：

- **存储后端服务**
- **数据管理服务**
- **备份恢复服务**

### 使用方法

```bash
# 启动所有存储服务
./start-storage-services.sh

# 快速启动存储服务
./quick-storage.sh

# 停止所有存储服务
./stop-storage-services.sh

# 查看存储服务状态
./start-storage-services.sh status
```

### 特性
- **数据安全**: 支持数据备份和恢复
- **性能优化**: 针对存储场景的性能调优
- **监控告警**: 存储状态监控和异常告警

## 🧹 环境清理工具

### 功能特性

环境清理脚本提供完整的Docker环境清理功能：

- **容器清理**: 停止并删除所有容器
- **镜像清理**: 删除所有Docker镜像
- **数据清理**: 删除指定数据目录
- **系统清理**: 清理Docker系统、网络和卷

### 使用方法

```bash
# 完整清理（需要确认）
./clean-environment.sh

# 强制清理（跳过确认）
./clean-environment.sh --force

# 仅显示清理预览
./clean-environment.sh --preview-only

# 不删除数据目录
./clean-environment.sh --no-data-dir

# 不清理Docker系统
./clean-environment.sh --no-docker-clean
```

### 安全特性
- **预览模式**: 先查看将要清理的内容
- **确认提示**: 需要输入 'YES' 确认执行
- **权限检查**: 自动检测权限并尝试使用sudo
- **备份提醒**: 提醒用户备份重要数据

## 🌐 网络管理工具

### AIGC网络配置

`setup-aigc-network.sh` 脚本用于管理AIGC Docker网络：

```bash
# 创建AIGC网络
./setup-aigc-network.sh create

# 查看网络信息
./setup-aigc-network.sh info

# 删除网络
./setup-aigc-network.sh remove

# 重新创建网络
./setup-aigc-network.sh recreate
```

### 网络配置
- **网络名称**: aigc
- **子网**: 172.20.0.0/16
- **网关**: 172.20.0.1

## 🛠️ 通用工具

### IP地址替换工具

`replace-ip.sh` 脚本用于批量替换配置文件中的IP地址：

```bash
# 替换IP地址
./replace-ip.sh 192.168.1.100 10.0.0.100

# 替换其他字符串
./replace-ip.sh old_string new_string
```

### 特性
- **智能搜索**: 自动查找包含源字符串的文件
- **多文件类型支持**: 支持多种配置文件格式
- **安全确认**: 需要用户确认后才执行替换
- **详细统计**: 显示替换成功和失败的文件数量

## 🚀 快速开始

### 1. 环境准备

```bash
# 检查Docker状态
docker info

# 检查Docker Compose
docker-compose --version
```

### 2. 启动支持服务

```bash
# 快速启动支持服务
./quick-support.sh

# 或使用完整功能脚本
./start-support-services.sh start --continue-on-failure
```

### 3. 启动业务服务

```bash
# 快速启动业务服务
./quick-services.sh

# 或使用完整功能脚本
./start-services.sh start --continue-on-failure
```

### 4. 启动存储服务

```bash
# 快速启动存储服务
./quick-storage.sh

# 或使用完整功能脚本
./start-storage-services.sh
```

### 5. 查看服务状态

```bash
# 查看所有服务状态
docker ps

# 查看特定服务状态
./start-support-services.sh status
./start-services.sh status
```

## 🔧 最佳实践

### 1. 环境管理

- **开发环境**: 使用快速启动脚本，启用继续执行模式
- **测试环境**: 使用完整功能脚本，保留数据目录
- **生产环境**: 使用完整功能脚本，谨慎操作，充分测试

### 2. 服务启动顺序

1. 先启动支持服务（nacos, rabbitmq, kong等）
2. 再启动业务服务（auth, wuji, sast, web）
3. 最后启动存储服务

### 3. 故障处理

- **服务启动失败**: 使用 `--continue-on-failure` 选项
- **端口冲突**: 检查端口占用情况
- **权限问题**: 使用sudo运行脚本
- **数据丢失**: 定期备份重要数据

### 4. 监控和维护

- **定期检查**: 使用状态查看命令监控服务
- **日志分析**: 查看启动日志和错误日志
- **性能优化**: 根据实际使用情况调整配置
- **安全更新**: 定期更新Docker镜像和系统

## 🚨 故障排除

### 常见问题

#### 1. Docker服务未运行
```bash
# 启动Docker服务
sudo systemctl start docker

# 检查Docker状态
sudo systemctl status docker
```

#### 2. 权限不足
```bash
# 添加用户到docker组
sudo usermod -aG docker $USER

# 重新登录后生效
newgrp docker
```

#### 3. 端口冲突
```bash
# 检查端口占用
sudo netstat -tulpn | grep :端口号

# 停止占用端口的服务
sudo lsof -ti:端口号 | xargs kill -9
```

#### 4. 服务启动失败
```bash
# 查看服务日志
docker logs 容器名

# 检查配置文件
cat services/服务名/.env

# 检查Docker Compose配置
docker-compose config
```

#### 5. 网络问题
```bash
# 检查网络配置
docker network ls

# 重新创建网络
./setup-aigc-network.sh recreate

# 检查网络连接
docker network inspect 网络名
```

### 恢复策略

#### 1. 服务恢复
```bash
# 重启失败的服务
./start-support-services.sh restart
./start-services.sh restart

# 或手动启动单个服务
cd services/服务名
docker-compose up -d
```

#### 2. 数据恢复
```bash
# 从备份恢复
cp 备份文件 原文件

# 重新部署服务
./start-services.sh start --continue-on-failure
```

#### 3. 环境重置
```bash
# 完全清理环境
./clean-environment.sh --force

# 重新部署所有服务
./quick-support.sh
./quick-services.sh
./quick-storage.sh
```

## 📋 脚本配置

### 环境变量

每个服务都需要配置相应的环境变量，主要配置文件：

```bash
# 支持服务环境变量
support/*/.env

# 业务服务环境变量
services/*/.env

# 存储服务环境变量
storage/*/.env
```

### 配置文件

重要的配置文件包括：

- **Docker Compose**: `docker-compose.yml` 或 `docker-compose.yaml`
- **应用配置**: `application.yml`, `nginx.conf` 等
- **环境变量**: `.env` 文件
- **网络配置**: 网络定义和配置

### 端口配置

默认端口配置：

| 服务 | 端口 | 说明 |
|------|------|------|
| nacos | 18848:8848 | 配置中心 |
| rabbitmq | 15672:15672 | 管理界面 |
| kong | 8000:8000 | API网关 |
| auth | ${AUTH_HTTP_PORT}:80 | 认证服务 |
| wuji | ${CLIENT_HTTP_PORT}:80 | 无极服务 |
| sast | ${SAST_HTTP_PORT}:80 | SAST服务 |
| web | 80:80 | Web前端 |

## 🔄 更新和维护

### 脚本更新

```bash
# 拉取最新代码
git pull origin main

# 更新脚本权限
chmod +x scripts/*.sh

# 测试脚本功能
./scripts/start-support-services.sh help
```

### 服务更新

```bash
# 更新Docker镜像
docker-compose pull

# 重启服务
docker-compose up -d

# 清理旧镜像
docker image prune -f
```

### 配置更新

```bash
# 更新配置文件
vim services/服务名/.env

# 重启服务
docker-compose restart

# 验证配置
docker-compose config
```

## 📞 技术支持

### 获取帮助

```bash
# 查看脚本帮助
./start-support-services.sh help
./start-services.sh help
./clean-environment.sh help
./setup-aigc-network.sh help
```

### 日志文件

- **支持服务日志**: `support-services-start.log`, `support-services-error.log`
- **业务服务日志**: `services-start.log`, `services-error.log`
- **存储服务日志**: `storage-services-start.log`, `storage-services-error.log`

### 联系支持

如果遇到问题：

1. 检查脚本日志输出
2. 查看Docker服务状态
3. 参考故障排除指南
4. 联系系统管理员
5. 提交问题报告

---

**注意**: 本脚本集合用于生产环境部署，请在使用前充分测试，确保理解每个脚本的功能和影响。
