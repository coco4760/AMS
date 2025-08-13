# Wuji Deployment Docker

## 项目概述

这是一个基于 Docker 的微服务部署项目，包含多个服务层和完整的部署脚本系统。

## 项目结构

```
wuji-deployment-docker/
├── deployment.sh              # 统一部署脚本（主脚本）
├── quick-deploy.sh            # 快速部署脚本（交互式）
├── examples.sh                # 使用示例脚本
├── README.md                  # 项目说明文档
├── README-deployment.md       # 部署脚本使用说明
├── scripts/                   # 脚本目录
│   ├── start-support-services.sh    # 基础服务启动脚本
│   ├── start-ai-brain.sh            # AI Brain服务启动脚本
│   ├── start-services.sh            # 业务服务启动脚本
│   ├── start-plugins-services.sh    # 插件服务启动脚本
│   ├── start-storage-services.sh    # 存储服务启动脚本
│   ├── quick-ai-brain.sh            # AI Brain快速启动脚本
│   ├── check-ai-brain-status.sh     # AI Brain状态检查脚本
│   ├── test-startup-order.sh        # 启动顺序测试脚本
│   ├── startup-order.md             # 启动顺序说明文档
│   └── README-ai-brain.md           # AI Brain服务说明文档
├── support/                   # 基础服务目录
│   ├── nacos/                 # 配置中心
│   ├── rabbitmq/              # 消息队列
│   ├── kong/                  # API网关
│   ├── iam/                   # 身份认证
│   ├── filems/                # 文件管理
│   ├── collabnet/             # 协作网络
│   ├── mineru/                # 核心服务
│   ├── node_manager/          # 节点管理
│   ├── mineru_cpu/            # CPU计算服务
│   ├── rag_service/           # RAG服务
│   └── ragflow/               # RAG流程服务
├── ai_brain/                  # AI Brain服务目录
│   ├── docker-compose.yaml    # Docker Compose配置
│   ├── base.env               # 环境变量配置
│   └── nginx/                 # Nginx配置
├── services/                  # 业务服务目录
│   ├── auth/                  # 认证服务
│   ├── wuji/                  # 无极服务
│   ├── sast/                  # SAST服务
│   └── web/                   # Web前端服务
├── plugins/                   # 插件服务目录
├── storage/                   # 存储服务目录
└── logs/                      # 日志目录
```

## 快速开始

### 1. 一键启动所有服务
```bash
./deployment.sh start
```

### 2. 使用交互式菜单
```bash
./quick-deploy.sh
```

### 3. 分别启动不同服务组
```bash
# 启动基础服务
./deployment.sh quick support

# 启动AI Brain服务
./deployment.sh quick ai_brain

# 启动业务服务
./deployment.sh quick business
```

### 4. 查看使用示例
```bash
./examples.sh
```

## 服务架构

### 服务层次结构

1. **基础服务层** (Support Services)
   - 配置中心、消息队列、API网关等基础设施

2. **AI Brain 服务层**
   - AI智能API、Web界面、代码执行沙箱等

3. **业务服务层** (Services)
   - 认证、无极、SAST、Web前端等业务服务

4. **插件服务层** (Plugins)
   - 各种插件和扩展服务

5. **存储服务层** (Storage)
   - 数据存储和管理服务

## 主要特性

- 🚀 **一键部署**: 支持一键启动所有服务
- 🔧 **灵活配置**: 支持分别启动不同服务组
- 📊 **状态监控**: 完整的服务状态检查
- 🛡️ **错误处理**: 完善的错误处理和日志记录
- ⚡ **快速启动**: 交互式快速部署选项
- 🔍 **健康检查**: 自动服务健康检查
- 📝 **详细日志**: 完整的部署和错误日志

## 系统要求

- Docker 20.10+
- Docker Compose 2.0+
- Linux/macOS 系统
- 至少 8GB 内存
- 至少 20GB 可用磁盘空间

## 文档

- [部署脚本使用说明](README-deployment.md)
- [AI Brain服务说明](scripts/README-ai-brain.md)
- [服务启动顺序说明](scripts/startup-order.md)

## 支持

如果遇到问题，请：
1. 查看错误日志
2. 检查服务状态
3. 参考故障排除文档
4. 联系技术支持团队

## 许可证

本项目采用 MIT 许可证。
