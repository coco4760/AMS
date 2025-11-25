# SecCortex - 智能安全分析平台

## 📖 项目简介

SecCortex 是一个基于微服务架构的智能安全分析平台，集成了 AI 大模型、RAG 检索增强生成、工作流编排、知识库管理等核心功能。平台采用 Docker Compose 进行容器化部署，提供一键部署脚本，支持灵活的服务组合和配置。

## ✨ 核心特性

- 🚀 **一键部署**：自动化部署脚本，支持交互式组件选择
- 🏗️ **微服务架构**：模块化设计，各组件可独立部署和扩展
- 🔧 **灵活配置**：基于 Nacos 的集中配置管理
- 📊 **完整监控**：集成健康检查和服务状态监控
- 🔐 **安全可靠**：支持 Keycloak 认证、SM2 国密加密
- 📦 **容器化部署**：基于 Docker Compose，易于维护和扩展

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                      CortexWeb (前端)                        │
│                    Nginx + Web UI                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                  CortexGateway (API 网关)                    │
│                      Kong Gateway                            │
└──────┬──────────┬──────────┬──────────┬──────────┬──────────┘
       │          │          │          │          │
   ┌───▼───┐  ┌───▼───┐  ┌───▼───┐  ┌───▼───┐  ┌───▼───┐
   │ Auth  │  │Server │  │  RAG  │  │  SOP  │  │Plugin │
   │       │  │       │  │       │  │       │  │       │
   └───┬───┘  └───┬───┘  └───┬───┘  └───┬───┘  └───┬───┘
       │         │           │          │          │
┌──────▼─────────▼───────────▼──────────▼──────────▼──────────┐
│              CortexInfra (基础设施层)                        │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐      │
│  │MySQL   │ │Postgres│ │ Redis  │ │RabbitMQ│ │ MinIO  │      │
│  │        │ │+pgvector│ │        │ │        │ │        │      │
│  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘      │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐      │
│  │ Nacos  │ │Keycloak│ │ Qdrant │ │Elastic │ │MongoDB │      │
│  │        │ │        │ │        │ │ Search │ │        │      │
│  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘      │
└──────────────────────────────────────────────────────────────┘
```

## 📁 项目结构

```
SecCortex/
├── deploy.sh                    # 主部署脚本（一键部署）
├── scripts/                     # 部署脚本目录
│   ├── common.sh               # 通用函数库
│   ├── deploy_infra.sh         # 基础设施部署脚本
│   ├── deploy_auth.sh          # 认证服务部署脚本
│   ├── deploy_gateway.sh       # API网关部署脚本
│   ├── deploy_server.sh        # 服务端部署脚本
│   ├── deploy_rag.sh           # RAG服务部署脚本
│   ├── deploy_sop.sh           # 工作流编排服务部署脚本
│   ├── deploy_web.sh           # 前端服务部署脚本
│   └── replace-ip.sh           # IP地址替换脚本
├── CortexInfra/                # 基础设施组件
│   ├── mysql/                  # MySQL 数据库
│   ├── postgres/               # PostgreSQL (pgvector)
│   ├── redis/                  # Redis 缓存
│   ├── rabbitmq/               # RabbitMQ 消息队列
│   ├── minio/                  # MinIO 对象存储
│   ├── nacos/                  # Nacos 配置中心
│   ├── iam/                    # Keycloak 认证服务
│   ├── qdrant/                 # Qdrant 向量数据库
│   ├── es/                     # Elasticsearch 搜索引擎
│   ├── mongo/                  # MongoDB 文档数据库
│   └── README.md               # 基础设施组件说明
├── CortexAuth/                 # 统一认证服务
│   ├── docker-compose.yaml
│   ├── config/
│   └── README.md
├── CortexGateway/              # API 网关服务
│   ├── docker-compose.yaml
│   ├── volumes/
│   └── README.md
├── CortexServer/               # 服务端（大模型应用）
│   ├── service/                # 主服务
│   ├── plugins/                # 插件服务
│   └── README.md
├── CortexRAG/                  # 检索增强生成服务
│   ├── docker-compose.yml
│   ├── .env                    # 环境变量配置
│   └── README.md
├── CortexSOP/                  # 工作流编排服务 (DIFY)
│   ├── docker-compose.yaml
│   ├── base.env                # 环境变量配置
│   └── README.md
├── CortexWeb/                  # 前端服务
│   ├── docker-compose.yaml
│   └── README.md
├── _data/                      # 初始化数据
│   └── base/                   # 数据库初始化脚本
│       ├── mysql/              # MySQL 初始化脚本
│       └── postgresql/          # PostgreSQL 初始化脚本
└── README.md                   # 本文档
```

## 🚀 快速开始

### 系统要求

- **操作系统**：Linux (推荐 Ubuntu 20.04+ / CentOS 7+)
- **Docker**：20.10+ 
- **Docker Compose**：2.0+ (或 docker-compose 1.29+)
- **内存**：至少 16GB (推荐 32GB+)
- **磁盘空间**：至少 200GB 可用空间
- **CPU**：至少 4 核 (推荐 8 核+)
- **网络**：能够访问 Docker 镜像仓库

### 前置准备

1. **安装 Docker 和 Docker Compose**

```bash
# 检查 Docker 版本
docker --version
docker compose version  # 或 docker-compose --version

# 如果未安装，请参考官方文档安装
# https://docs.docker.com/engine/install/
```

2. **获取项目代码**

**方式一：使用 Git 克隆（推荐）**

```bash
git clone <repository-url>
cd SecCortex
```

**方式二：下载压缩包**

如果无法使用 Git，可以直接下载项目压缩包：

1. 访问项目仓库页面
2. 点击 "Code" → "Download ZIP" 下载压缩包
3. 解压到目标目录：

```bash
unzip SecCortex-main.zip
cd SecCortex-main
# 或重命名为 SecCortex
mv SecCortex-main SecCortex
cd SecCortex
```

3. **配置环境变量（可选）**

项目使用统一的数据目录，默认路径为 `/var/lib/clouditera/data`。如需修改，可在部署脚本中设置 `DATA_ROOT` 环境变量。

### 一键部署

#### 方式一：交互式部署（推荐）

```bash
# 运行主部署脚本
./deploy.sh
```

脚本将引导您完成：
1. ✅ 依赖检查（Docker、Docker Compose）
2. 🌐 IP 地址配置（自动检测或手动输入）
3. 📁 数据目录创建
4. 📦 组件选择（支持多选）

**可用组件：**
- `[1]` Infrastructure - 基础设施（数据库、Redis、MinIO 等）
- `[2]` Auth - 认证服务（Keycloak）
- `[3]` Gateway - API 网关（Kong）
- `[4]` Server - 服务端（大模型应用服务）
- `[5]` RAG - 检索增强生成服务
- `[6]` SOP - 工作流编排服务（DIFY）
- `[7]` Web - 前端服务
- `[8]` All - 部署所有组件

#### 方式二：命令行部署

```bash
# 部署基础设施
bash scripts/deploy_infra.sh

# 部署认证服务
bash scripts/deploy_auth.sh

# 部署 API 网关
bash scripts/deploy_gateway.sh

# 部署服务端
bash scripts/deploy_server.sh

# 部署 RAG 服务
bash scripts/deploy_rag.sh

# 部署工作流编排服务
bash scripts/deploy_sop.sh

# 部署前端服务
bash scripts/deploy_web.sh
```

## 📋 详细部署步骤

### 第一步：部署基础设施（CortexInfra）

基础设施组件是其他服务的基础，**必须优先部署**。

```bash
cd CortexInfra
bash ../scripts/deploy_infra.sh
```

**包含的组件：**
- MySQL 8.0.34 - 关系数据库
- PostgreSQL 17 (pgvector) - 向量数据库
- Redis 7.2.0 - 缓存和消息队列
- RabbitMQ 4.1.3 - 消息队列
- MinIO - 对象存储
- Nacos 2.4.3 - 配置中心
- Keycloak 22.0.0 - 身份认证
- Qdrant 1.15 - 向量数据库
- Elasticsearch 8.12.2 - 搜索引擎
- MongoDB 5.0.5 - 文档数据库

**重要提示：**
- 基础设施部署完成后会自动等待 10 秒，确保服务完全启动
- 某些组件（如 Elasticsearch、PostgreSQL）需要特殊权限，脚本会自动处理

### 第二步：部署认证服务（CortexAuth）

```bash
cd CortexAuth
bash ../scripts/deploy_auth.sh
```

**服务说明：**
- 基于 Keycloak 的统一认证服务
- 依赖 MySQL 数据库（需先部署基础设施）
- 默认端口：18080

### 第三步：部署 API 网关（CortexGateway）

```bash
cd CortexGateway
bash ../scripts/deploy_gateway.sh
```

**服务说明：**
- 基于 Kong 的 API 网关
- 提供统一 API 入口、负载均衡、认证授权等功能
- 依赖 PostgreSQL 数据库

### 第四步：部署服务端（CortexServer）

```bash
cd CortexServer
bash ../scripts/deploy_server.sh
```

**服务说明：**
- 大模型应用服务端
- 提供 WuJi Client API
- 依赖 Nacos 配置中心、MySQL、PostgreSQL、Redis 等

### 第五步：部署 RAG 服务（CortexRAG）

```bash
cd CortexRAG
bash ../scripts/deploy_rag.sh
```

**服务说明：**
- 检索增强生成服务
- 提供知识库管理、文档管理、语义检索等功能
- 包含多个 Celery Worker 处理异步任务
- 依赖 PostgreSQL (pgvector)、Redis、Qdrant

**环境变量配置：**
需要在 `CortexRAG/.env` 中配置相关参数（详见 `CortexRAG/README.md`）

### 第六步：部署工作流编排服务（CortexSOP）

```bash
cd CortexSOP
bash ../scripts/deploy_sop.sh
```

**服务说明：**
- 基于 DIFY 的工作流编排服务
- 提供可视化工作流设计、Agent 构建、插件管理等功能
- 依赖 PostgreSQL、Redis、Qdrant、RAG 服务等
- 部署完成后会自动等待 15 秒，确保服务完全启动

**环境变量配置：**
需要在 `CortexSOP/base.env` 中配置相关参数（详见 `CortexSOP/README.md`）

### 第七步：部署前端服务（CortexWeb）

```bash
cd CortexWeb
bash ../scripts/deploy_web.sh
```

**服务说明：**
- 前端 Web 界面
- 基于 Nginx 的反向代理
- 依赖 Kong API 网关

## ⚙️ 配置说明

### 环境变量

各组件使用 `.env` 文件进行配置，主要配置项包括：

#### 通用配置

```bash
# 数据根目录（所有组件共享）
INSTALL_LOCAL=/var/lib/clouditera/data

# 服务器 IP 地址
SERVER_IP=192.168.34.7
```

#### 数据库配置

```bash
# MySQL
MYSQL_PORT=13306
MYSQL_ROOT_PASSWORD=your_password

# PostgreSQL
PG_PORT=15432
POSTGRES_PASSWORD=your_password
POSTGRES_DB=aigc

# Redis
REDIS_PORT=16379
REDIS_PASSWORD=your_password

# MongoDB
MONGO_PORT=17017
MONGO_INITDB_ROOT_PASSWORD=your_password
```

#### 服务配置

```bash
# Nacos
NACOS_PORT=18848
NACOS_PASSWORD=clouditera

# Keycloak
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=your_password

# RabbitMQ
RABBITMQ_DEFAULT_USER=clouditera
RABBITMQ_DEFAULT_PASS=clouditera

# MinIO
MINIO_ROOT_USER=clouditera
MINIO_ROOT_PASSWORD=your_password
```

### Nacos 配置中心

平台使用 Nacos 作为配置中心，主要配置项包括：

- `redis` - Redis 配置
- `mysql` - MySQL 配置
- `postgresql` - PostgreSQL 配置
- `rabbitmq` - RabbitMQ 配置
- `keycloak` - Keycloak 配置
- `minio` - MinIO 配置
- `rag` - RAG 服务配置
- `dify` - DIFY 服务配置
- `plugin` - 插件配置

配置初始化脚本位于 `_data/base/mysql/insert_data_nacos.sql`

## 🔍 服务端口说明

### 端口分配规则

采用**分层端口规划**，按服务类型分配端口范围：

- **10000-19999**：基础设施层（数据库、缓存、消息队列等）
- **20000-29999**：业务服务层（API 服务、网关、插件等）
- **30000-39999**：前端服务层（Web 界面）
- **40000-49999**：工具服务层（监控、工具等）
- **50000-59999**：内部服务层（不对外暴露，仅容器间通信）

### 按目录结构的端口映射

#### `CortexInfra/`（基础设施层 10000-19999）

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `mysql/` | MySQL | 10001 | 3306 | 关系数据库 |
| `postgres/` | PostgreSQL | 10002 | 5432 | 向量数据库 |
| `redis/` | Redis | 10003 | 6379 | 缓存服务 |
| `rabbitmq/` | RabbitMQ AMQP | 10004 | 5672 | 消息队列 |
| `rabbitmq/` | RabbitMQ UI | 10005 | 15672 | 管理控制台 |
| `minio/` | MinIO API | 10006 | 9000 | 对象存储 API |
| `minio/` | MinIO Console | 10007 | 9001 | 管理控制台 |
| `nacos/` | Nacos HTTP | 10008 | 8848 | 配置中心 |
| `nacos/` | Nacos gRPC | 10009 | 9848 | gRPC 接口 |
| `qdrant/` | Qdrant REST | 10010 | 6333 | 向量数据库 |
| `qdrant/` | Qdrant gRPC | 10011 | 6334 | gRPC 接口 |
| `es/` | Elasticsearch HTTP | 10012 | 9200 | 搜索引擎 |
| `es/` | Elasticsearch Cluster | 10013 | 9300 | 集群通信 |
| `mongo/` | MongoDB | 10014 | 27017 | 文档数据库 |
| `iam/` | Keycloak | 10015 | 8080 | 认证服务 |
| `firecrawl/` | Firecrawl API | 10016 | 3002 | 网页抓取 API |
| `mineru/` | MinerU | 10017 | 8000 | ETL 服务 |
| `firecrawl/` | Firecrawl Playwright Service | — | 3000 | 内部服务（不暴露主机端口） |
| `firecrawl/` | Firecrawl Redis | — | 6379 | 内部缓存（不暴露主机端口） |

#### `CortexAuth/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | Auth API | 20001 | 80 | 认证 API |

#### `CortexServer/service/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | Server API | 20002 | 80 | 服务端 API |

#### `CortexGateway/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | Gateway Proxy | 20003 | 8000/tcp | API 网关代理 |
| `.` | Gateway Admin | 20004 | 8001/tcp | API 网关管理 API |
| `.` | Gateway Admin GUI | 20005 | 8002/tcp | 管理界面 |
| `.` | Gateway SSL | 20006 | 8443/tcp | HTTPS 代理 |
| `.` | Gateway Admin SSL | 20007 | 8444/tcp | 管理 HTTPS |

#### `CortexRAG/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | RAG Backend | 20008 | 8081 | RAG 后端 API |
| `.` | RAG Frontend | 30002 | 8080 | RAG 前端界面 |
| `.` | Flower (Celery) | 40001 | 5555 | 任务监控 |
| `.` | RAG PostgreSQL | 50001 | 5432 | 向量入库数据库 |
| `.` | RAG Redis | 50002 | 6379 | RAG 缓存 |
| `.` | RAG Qdrant | 50003, 50004 | 6333, 6334 | RAG 向量库 |
| `milvus/` | Milvus MinIO API/Console | 50005, 50006 | 9000, 9001 | Milvus 依赖对象存储（profile: milvus） |
| `milvus/` | Milvus Service / Monitor | 50007, 50008 | 19530, 9091 | Milvus standalone 服务（profile: milvus） |
| `chroma/` | Chroma API | 50009 | 8000 | Chroma 方案（profile: chroma） |

#### `CortexSOP/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | SOP API | 20009 | 5001 | 工作流 API |
| `plugin_daemon/` | SOP Plugin (1) | 20010 | 5002 | 插件服务 A |
| `plugin_daemon/` | SOP Plugin (2) | 20011 | 5003 | 插件服务 B |
| `sandbox/` | SOP Sandbox | 20012 | 8194 | 代码沙箱 |
| `web/` | SOP Frontend | 30003 | 80 | 前端界面 |

#### `CortexFlow/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | CloudFlow Backend | 20027 | 8082 | 工作流后端 |
| `.` | CloudFlow PostgreSQL | — | 5432 | 内部数据库 |
| `.` | CloudFlow Redis | — | 6379 | 内部缓存 |

#### `CortexWeb/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `.` | Web Frontend | 30001 | 80 | 主前端界面 |

#### `CortexServer/plugins/`

| 路径 | 服务 | 主机端口 | 容器端口 | 说明 |
|------|------|---------|---------|------|
| `defect_judgement/` | Backend | 20013 | 8081 | 缺陷研判后端 |
| `defect_judgement/` | Frontend | 20014 | 8080 | 缺陷研判前端 |
| `defect_judgement/` | PostgreSQL | — | 5432 | 插件内部数据库 |
| `asset_judgment/` | Asset Judgment | 20015 | 8000 | 资产研判 |
| `clouditera_paper/` | Paper API | 20016 | 8000 | 论文服务 |
| `clouditera_plugin/` | AI Plugin | 20017 | 8001 | AI 插件 |
| `clouditera_plugin_for_vul/` | Vul Plugin | 20018 | 8001 | 漏洞插件 |
| `clouditera_plugin_sectools/` | SecTools Plugin | 20019 | 5000 | 安全工具插件 |
| `clouditera_plugin_wireshark/` | Wireshark Plugin | 20020 | 5000 | Wireshark 插件 |
| `email-check/` | Email Plugin | 20021 | 8080 | 邮件检查 |
| `filems/` | FileMS Core | 20022 | 8840 | 文件管理服务 |
| `filems/` | FileMS Agent | 20023 | 2201 | 文件 Agent |
| `knowledge-base-filemeta/` | Knowledge Base | 20024 | 8000 | 文件元数据插件 |
| `mcp-tools/` | MCP Tools | 20025 | 8081 | MCP 工具 |
| `pdf_translate/` | PDF Translate | 20026 | 7860 | PDF 翻译 |

## 📊 部署顺序建议

为确保服务正常启动，建议按以下顺序部署：

1. **基础设施层** (CortexInfra)
   - 优先部署数据库和缓存服务
   - 等待 10 秒确保服务完全启动

2. **认证服务** (CortexAuth)
   - 依赖 MySQL 和 Keycloak

3. **API 网关** (CortexGateway)
   - 依赖 PostgreSQL

4. **服务端** (CortexServer)
   - 依赖 Nacos、MySQL、PostgreSQL、Redis

5. **RAG 服务** (CortexRAG)
   - 依赖 PostgreSQL、Redis、Qdrant

6. **工作流编排** (CortexSOP)
   - 依赖 PostgreSQL、Redis、RAG 服务
   - 部署后等待 15 秒

7. **前端服务** (CortexWeb)
   - 依赖 Kong 网关

## 🔧 运维管理

### 查看服务状态

```bash
# 查看所有服务状态
docker ps

# 查看特定组件状态
cd CortexInfra/mysql
docker compose ps

# 查看服务日志
docker compose logs -f
```

### 重启服务

```bash
# 重启单个服务
cd CortexInfra/mysql
docker compose restart

# 重启所有服务
cd CortexInfra
docker compose restart
```

### 停止服务

```bash
# 停止单个服务
cd CortexInfra/mysql
docker compose down

# 停止所有服务
cd CortexInfra
docker compose down
```

### 更新服务

```bash
# 拉取最新镜像
docker compose pull

# 重新部署
docker compose up -d
```

### 数据备份

所有数据存储在 `/var/lib/clouditera/data` 目录下，建议定期备份：

```bash
# 备份数据目录
tar -czf secCortex-backup-$(date +%Y%m%d).tar.gz /var/lib/clouditera/data

# 恢复数据
tar -xzf secCortex-backup-YYYYMMDD.tar.gz -C /
```

## 🐛 常见问题排查

### 1. 服务启动失败

**问题**：容器无法启动或立即退出

**排查步骤**：
```bash
# 查看容器日志
docker compose logs -f

# 检查端口占用
netstat -tulpn | grep <端口号>

# 检查磁盘空间
df -h

# 检查 Docker 资源
docker system df
```

### 2. 数据库连接失败

**问题**：应用无法连接到数据库

**排查步骤**：
```bash
# 检查数据库容器状态
docker ps | grep mysql
docker ps | grep postgres

# 检查数据库日志
docker compose logs mysql
docker compose logs postgres

# 测试数据库连接
docker exec -it <mysql-container> mysql -u root -p
```

### 3. 配置中心连接失败

**问题**：无法从 Nacos 读取配置

**排查步骤**：
```bash
# 检查 Nacos 状态
curl http://localhost:18848/nacos/v1/console/health

# 检查 Nacos 配置
# 访问 http://<server-ip>:18848/nacos
# 用户名：nacos，密码：clouditera
```

### 4. 权限问题

**问题**：Elasticsearch、PostgreSQL 等服务因权限问题无法启动

**解决方案**：
```bash
# 修复 Elasticsearch 权限
sudo chown -R 1000:1000 /var/lib/clouditera/data/es

# 修复 PostgreSQL 权限
sudo chown -R 999:999 /var/lib/clouditera/data/pgdata
sudo find /var/lib/clouditera/data/pgdata -type f -exec chmod 600 {} \;
sudo find /var/lib/clouditera/data/pgdata -type d -exec chmod 700 {} \;
```

### 5. 端口冲突

**问题**：端口已被占用

**解决方案**：
- 修改对应服务的 `.env` 文件中的端口配置
- 或停止占用端口的服务

### 6. 内存不足

**问题**：容器因内存不足被 OOM 杀死

**解决方案**：
- 增加系统内存
- 或减少并发服务数量
- 调整 Docker 内存限制

## 📚 组件详细文档

- [CortexInfra 基础设施组件](./CortexInfra/README.md)
- [CortexAuth 认证服务](./CortexAuth/README.md)
- [CortexGateway API 网关](./CortexGateway/README.md)
- [CortexServer 服务端](./CortexServer/README.md)
- [CortexRAG 检索增强生成服务](./CortexRAG/README.md)
- [CortexSOP 工作流编排服务](./CortexSOP/README.md)
- [CortexWeb 前端服务](./CortexWeb/README.md)

## 🔐 安全建议

1. **修改默认密码**
   - 所有服务的默认密码应在生产环境中修改
   - 特别是数据库、Redis、RabbitMQ 等关键服务

2. **网络安全**
   - 将管理端口（Nacos、RabbitMQ UI、MinIO Console 等）限制在内网访问
   - 使用防火墙规则限制端口访问

3. **数据加密**
   - 敏感数据使用 SM2 国密加密
   - 传输使用 HTTPS/TLS

4. **定期备份**
   - 建立自动备份策略
   - 定期测试备份恢复流程

## 📞 技术支持

如遇到问题，请：

1. 查看相关组件的 README 文档
2. 检查服务日志：`docker compose logs -f`
3. 查看 [常见问题排查](#-常见问题排查) 章节
4. 联系技术支持团队

## 📄 许可证

本项目采用 MIT 许可证。

---

**最后更新**：2025-11-25
