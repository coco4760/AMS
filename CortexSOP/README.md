# CortexSOP - 工作流编排服务

## 📖 项目简介

CortexSOP 是基于 **DIFY** 框架进行定制开发的工作流编排服务，为 SecCortex 平台提供强大的 AI 工作流编排、Agent 构建和插件管理能力。通过可视化的拖拽式界面，用户可以轻松构建复杂的 AI 应用和工作流，支持多种 LLM 模型、RAG 检索、代码执行、插件扩展等功能。

## ✨ 功能特性

### 🔄 工作流编排
- **可视化编排**：拖拽式工作流设计界面
- **多种节点类型**：LLM、知识库检索、代码执行、HTTP 请求、条件判断等
- **复杂流程控制**：支持分支、循环、条件判断等流程控制
- **实时调试**：工作流执行过程可视化，支持断点调试

### 🤖 Agent 构建
- **智能 Agent**：基于 ReAct 和 Function Calling 策略的智能 Agent
- **工具调用**：支持丰富的工具和插件调用
- **多轮对话**：支持上下文记忆和多轮对话
- **自定义策略**：可自定义 Agent 决策策略

### 🔌 插件系统
- **插件管理**：支持插件的安装、更新、卸载
- **MCP 协议支持**：支持 Model Context Protocol (MCP) 协议
- **远程插件**：支持远程插件安装和管理
- **插件市场**：可扩展的插件市场（可选）

### 📚 知识库集成
- **RAG 检索**：集成 RAG 服务，支持语义检索
- **多知识库**：支持多个知识库管理
- **文档处理**：支持多种文档格式的解析和处理
- **向量存储**：支持 Qdrant 向量数据库

### 💻 代码执行
- **安全沙箱**：基于 Docker 的代码执行沙箱
- **多语言支持**：支持 Python、JavaScript 等多种语言
- **依赖管理**：支持自定义依赖包安装
- **资源限制**：可配置 CPU、内存等资源限制

### 🔐 安全与认证
- **Keycloak 集成**：支持 Keycloak 单点登录
- **权限管理**：细粒度的权限控制
- **数据加密**：支持 SM2 国密加密
- **审计日志**：完整的操作审计日志

## 🏗️ 架构设计

```
┌─────────────────────────────────────────────────────────┐
│                    Nginx (10081)                         │
│             反向代理和负载均衡                            │
└──────────────────────┬────────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   ┌────▼────┐    ┌────▼────┐   ┌────▼─────┐
   │   Web   │    │   API   │   │  Worker  │
   │  (3000) │    │  (5001) │   │          │
   └─────────┘    └────┬────┘   └────┬─────┘
                       │              │
        ┌──────────────┼──────────────┼──────────────┐
        │              │              │              │
   ┌────▼────┐   ┌─────▼─────┐  ┌────▼─────┐  ┌─────▼─────┐
   │Sandbox  │   │  Plugin   │  │PostgreSQL│  │   Redis   │
   │ (8194)  │   │  Daemon   │  │          │  │           │
   └─────────┘   │  (5002)   │  └──────────┘  └───────────┘
                  └───────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   ┌────▼────┐   ┌─────▼─────┐  ┌─────▼─────┐
   │ Qdrant  │   │  RAG      │  │  Keycloak │
   │         │   │  Service  │  │           │
   └─────────┘   └───────────┘  └───────────┘
```

## 🚀 快速开始

### 前置要求

- Docker 和 Docker Compose
- PostgreSQL 数据库（用于存储应用数据）
- Redis（用于任务队列和缓存）
- Qdrant（用于向量存储，可选）
- Keycloak（用于认证，可选）

### 环境变量配置

编辑 `base.env` 文件，配置以下环境变量：

```bash
# 1. 用户和认证
SECRET_KEY=your_secret_key
OPENAI_API_KEY=your_openai_api_key

KEYCLOAK_SERVER_URL=http://your-keycloak:18080
KEYCLOAK_NOTION_CLIENT_ID=clouditera-aigc
KEYCLOAK_REALM_NAME=Clouditera-IAM
KEYCLOAK_CLIENT_SECRET_KEY=your_client_secret

ALLOW_REGISTER=True
ALLOW_CREATE_WORKSPACE=True

# 2. PostgreSQL 数据库配置
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_HOST=your_postgres_host
DB_PORT=5432
DB_DATABASE=aigc
SQLALCHEMY_POOL_SIZE=200
MIGRATION_ENABLED='true'

# 3. Redis 配置
REDIS_HOST=your_redis_host
REDIS_PORT=6379
REDIS_USERNAME=''
REDIS_PASSWORD=your_redis_password
REDIS_USE_SSL='false'
REDIS_DB=0

# 异步任务
CELERY_WORKER_AMOUNT=30
CELERY_BROKER_URL=redis://:password@host:port/1

# 4. Qdrant 向量数据库
VECTOR_STORE=qdrant
QDRANT_URL=http://your_qdrant:6333
QDRANT_API_KEY=your_api_key
QDRANT_CLIENT_TIMEOUT=100

# 5. 文档解析配置
ETL_TYPE=Unstructured
UNSTRUCTURED_API_URL=http://your_unstructured:15002/general/v0/general
UNSTRUCTURED_API_KEY=your_api_key

# 6. 代码执行沙箱
CODE_EXECUTION_ENDPOINT=http://sandbox:8194
CODE_EXECUTION_API_KEY=your_api_key

# 7. RAG 服务配置
RAG_IP=your_rag_host
RAG_PORT=9380

# 8. 工作流配置
WORKFLOW_FILE_UPLOAD_LIMIT=10
WORKFLOW_MAX_EXECUTION_STEPS=500
WORKFLOW_MAX_EXECUTION_TIME=1200
WORKFLOW_CALL_MAX_DEPTH=10
MAX_VARIABLE_SIZE=204800

# 9. 插件配置
PLUGIN_DAEMON_URL=http://plugin_daemon:5002
PLUGIN_DAEMON_KEY=your_plugin_key
SERVER_KEY=your_server_key
PLUGIN_REMOTE_INSTALL_HOST=your_host
PLUGIN_REMOTE_INSTALL_PORT=5003
PLUGIN_MAX_PACKAGE_SIZE=15728640
MARKETPLACE_ENABLED=false

# 10. 其他配置
INSTALL_LOCAL=/data/secCortex
XINFERENCE_SERVICE=your_xinference_host
AI_PLUGIN=your_ai_plugin_host
AI_PLUGIN_VUL=your_vul_plugin_host
EMAIL_PLUGIN=your_email_plugin_host
```

### 启动服务

```bash
# 进入目录
cd CortexSOP

# 启动所有服务
docker compose up -d

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f api
```

### 验证服务

```bash
# 检查 API 服务
curl http://localhost:15001/health

# 检查 Web 服务（通过 Nginx）
curl http://localhost:10081

# 访问 Web 界面
# http://localhost:10081
```

## 📁 项目结构

```
CortexSOP/
├── docker-compose.yaml          # Docker Compose 配置文件
├── base.env                     # 环境变量配置文件
├── nginx/                       # Nginx 配置
│   ├── nginx.conf              # Nginx 主配置文件
│   ├── proxy.conf              # 代理配置
│   └── conf.d/                 # 站点配置
│       └── default.conf
├── plugin_daemon/               # 插件守护进程数据
│   ├── assets/                 # 插件资源文件
│   ├── cwd/                    # 插件工作目录
│   ├── plugin/                 # 已安装插件
│   └── plugin_packages/        # 插件包
└── privkeys/                   # 私钥目录
```

## ⚙️ 服务组件说明

### 1. API 服务 (api)

**功能**：提供 RESTful API 接口

**端口**：15001

**镜像**：`rd.clouditera.com/aigc/brain/api:v6.3.1.post7`

**主要功能**：
- 工作流管理 API
- Agent 管理 API
- 知识库管理 API
- 插件管理 API
- 用户认证 API

**环境变量**：
- `MODE=api`：运行模式为 API 服务

### 2. Worker 服务 (worker)

**功能**：异步任务处理

**镜像**：`rd.clouditera.com/aigc/brain/api:v6.3.1.post7`

**主要功能**：
- 工作流执行
- 文档处理任务
- 向量化任务
- 其他异步任务

**环境变量**：
- `MODE=worker`：运行模式为 Worker
- `CELERY_WORKER_AMOUNT=30`：Worker 数量

### 3. Web 服务 (web)

**功能**：前端 Web 界面

**端口**：3000（容器内）

**镜像**：`rd.clouditera.com/aigc/brain/web:v6.3.1`

**访问方式**：通过 Nginx 反向代理访问（端口 10081）

### 4. Sandbox 服务 (sandbox)

**功能**：代码执行沙箱

**端口**：18194

**镜像**：`rd.clouditera.com/aigc/brain/sandbox:0.2.11`

**主要功能**：
- 安全执行 Python、JavaScript 等代码
- 支持自定义依赖包
- 资源限制和隔离

**特殊权限**：需要 `SYS_ADMIN` 权限

### 5. Plugin Daemon 服务 (plugin_daemon)

**功能**：插件守护进程

**端口**：
- 5002：插件服务端口
- 5003：远程安装端口

**镜像**：`rd.clouditera.com/aigc/brain/plugin-daemon:0.0.7`

**主要功能**：
- 插件生命周期管理
- 插件远程安装
- 插件执行环境管理

**配置**：
- `PLUGIN_WORKING_PATH=/app/storage/cwd`：插件工作目录
- `FORCE_VERIFYING_SIGNATURE=false`：是否强制验证签名

### 6. Nginx 服务 (nginx)

**功能**：反向代理和负载均衡

**端口**：10081

**镜像**：`rd.clouditera.com/docker/nginx:latest`

**主要功能**：
- API 请求代理
- Web 前端代理
- 静态资源服务
- 负载均衡

**配置**：
- `client_max_body_size=150M`：最大上传文件大小

## 🔌 插件系统

### 内置插件

#### 1. MCP SSE Plugin
- **作者**：Junjie.M
- **类型**：工具插件
- **功能**：通过 HTTP SSE 或 Streamable HTTP 传输方式使用 MCP 协议调用工具
- **版本**：0.2.1

#### 2. Agent Plugin
- **作者**：LangGenius
- **类型**：Agent 策略插件
- **功能**：提供 ReAct 和 Function Calling 策略
- **版本**：0.0.19

#### 3. Xinference Plugin
- **作者**：LangGenius
- **类型**：模型提供插件
- **功能**：集成 Xinference 模型服务
- **版本**：0.0.4

### 插件安装

#### 通过远程安装

```bash
# 插件守护进程会监听 15003 端口
# 可以通过 API 或 Web 界面安装插件
```

#### 手动安装

1. 将插件包放置到 `plugin_daemon/plugin_packages/` 目录
2. 重启 `plugin_daemon` 服务
3. 在 Web 界面中启用插件

### 插件开发

插件需要遵循 DIFY 插件规范：

- `manifest.yaml`：插件清单文件
- `main.py`：插件主程序
- `requirements.txt`：Python 依赖
- `README.md`：插件文档

## 📡 API 接口文档

### 基础路径

所有 API 接口的基础路径为：`http://localhost:15001`

### 工作流接口

#### 1. 创建工作流

**接口地址**：`POST /api/v1/workflows`

**请求参数**：
```json
{
  "name": "我的工作流",
  "description": "工作流描述",
  "graph": {
    "nodes": [...],
    "edges": [...]
  }
}
```

#### 2. 执行工作流

**接口地址**：`POST /api/v1/workflows/{workflow_id}/run`

**请求参数**：
```json
{
  "inputs": {
    "key": "value"
  }
}
```

#### 3. 获取工作流列表

**接口地址**：`GET /api/v1/workflows`

### Agent 接口

#### 1. 创建 Agent

**接口地址**：`POST /api/v1/agents`

#### 2. 对话 Agent

**接口地址**：`POST /api/v1/agents/{agent_id}/chat`

**请求参数**：
```json
{
  "query": "用户问题",
  "conversation_id": "conversation_id",
  "user": "user_id"
}
```

### 知识库接口

#### 1. 创建知识库

**接口地址**：`POST /api/v1/datasets`

#### 2. 上传文档

**接口地址**：`POST /api/v1/datasets/{dataset_id}/documents`

#### 3. 检索知识库

**接口地址**：`POST /api/v1/datasets/{dataset_id}/retrieve`

## 🔧 配置说明

### 工作流配置

- **WORKFLOW_FILE_UPLOAD_LIMIT**：工作流文件上传限制（MB）
- **WORKFLOW_MAX_EXECUTION_STEPS**：最大执行步数
- **WORKFLOW_MAX_EXECUTION_TIME**：最大执行时间（秒）
- **WORKFLOW_CALL_MAX_DEPTH**：最大调用深度
- **MAX_VARIABLE_SIZE**：最大变量大小（字节）

### 文件上传配置

- **UPLOAD_FILE_SIZE_LIMIT**：文件大小限制（MB）
- **UPLOAD_FILE_BATCH_LIMIT**：批量上传限制
- **UPLOAD_IMAGE_FILE_SIZE_LIMIT**：图片文件大小限制（MB）
- **UPLOAD_VIDEO_FILE_SIZE_LIMIT**：视频文件大小限制（MB）
- **UPLOAD_AUDIO_FILE_SIZE_LIMIT**：音频文件大小限制（MB）

### 代码执行配置

- **CODE_EXECUTION_ENDPOINT**：代码执行服务地址
- **CODE_EXECUTION_API_KEY**：代码执行 API 密钥
- **CODE_MAX_NUMBER**：最大数值限制
- **CODE_MAX_STRING_LENGTH**：最大字符串长度
- **CODE_MAX_DEPTH**：最大嵌套深度

### 插件配置

- **PLUGIN_DAEMON_URL**：插件守护进程地址
- **PLUGIN_DAEMON_KEY**：插件守护进程密钥
- **PLUGIN_REMOTE_INSTALL_HOST**：远程安装主机
- **PLUGIN_REMOTE_INSTALL_PORT**：远程安装端口
- **PLUGIN_MAX_PACKAGE_SIZE**：最大插件包大小（字节）
- **MARKETPLACE_ENABLED**：是否启用插件市场

## 📊 监控与运维

### 查看服务日志

```bash
# 查看 API 服务日志
docker compose logs -f api

# 查看 Worker 服务日志
docker compose logs -f worker

# 查看 Web 服务日志
docker compose logs -f web

# 查看 Sandbox 服务日志
docker compose logs -f sandbox

# 查看 Plugin Daemon 服务日志
docker compose logs -f plugin_daemon

# 查看所有服务日志
docker compose logs -f
```

### 健康检查

```bash
# 检查 API 服务
curl http://localhost:15001/health

# 检查 Sandbox 服务
curl http://localhost:18194/health

# 检查 Plugin Daemon 服务
curl http://localhost:15004/health
```

### 性能监控

- **工作流执行时间**：通过日志监控工作流执行时间
- **Worker 任务队列**：监控 Redis 中的任务队列长度
- **数据库连接池**：监控 PostgreSQL 连接池使用情况
- **内存使用**：监控各服务的内存使用情况

## 🔒 安全建议

1. **密钥管理**：
   - 使用强密码保护所有密钥
   - 定期轮换密钥
   - 不要在代码中硬编码密钥

2. **沙箱安全**：
   - 限制代码执行资源（CPU、内存）
   - 配置网络访问限制
   - 定期更新沙箱镜像

3. **API 安全**：
   - 启用 HTTPS
   - 实施 API 限流
   - 使用认证和授权

4. **数据安全**：
   - 加密敏感数据
   - 定期备份数据库
   - 实施访问控制

5. **插件安全**：
   - 验证插件签名
   - 限制插件权限
   - 审查插件代码

## 🐛 常见问题

### 1. 工作流执行失败

**问题**：工作流执行时出错

**解决方案**：
- 检查工作流配置是否正确
- 查看 API 和 Worker 日志
- 验证依赖服务是否正常（数据库、Redis、Qdrant 等）
- 检查资源限制（内存、CPU）

### 2. 插件无法加载

**问题**：插件安装后无法使用

**解决方案**：
- 检查插件守护进程是否运行
- 查看插件日志：`docker compose logs plugin_daemon`
- 验证插件配置是否正确
- 检查插件权限和签名

### 3. 代码执行失败

**问题**：Sandbox 代码执行失败

**解决方案**：
- 检查 Sandbox 服务是否运行
- 查看 Sandbox 日志
- 验证代码执行端点配置
- 检查资源限制和权限

### 4. 知识库检索不准确

**问题**：RAG 检索结果不准确

**解决方案**：
- 检查 Qdrant 服务是否正常
- 验证向量化模型配置
- 优化文档分块策略
- 调整检索参数（top_k、score_threshold）

### 5. 数据库连接失败

**问题**：无法连接到 PostgreSQL

**解决方案**：
- 检查 PostgreSQL 服务是否运行
- 验证数据库连接配置
- 检查网络连接
- 查看数据库日志

## 🔄 升级与维护

### 升级服务

1. **备份数据**：
   ```bash
   # 备份 PostgreSQL 数据库
   docker compose exec postgres pg_dump -U postgres aigc > backup.sql
   
   # 备份插件数据
   tar -czf plugin_daemon_backup.tar.gz ./plugin_daemon
   ```

2. **更新镜像**：
   ```bash
   # 拉取新镜像
   docker compose pull
   
   # 重启服务
   docker compose up -d
   ```

3. **执行数据库迁移**：
   ```bash
   # 数据库迁移会自动执行（MIGRATION_ENABLED=true）
   # 查看迁移日志
   docker compose logs api | grep migration
   ```

### 性能优化

1. **Worker 数量调整**：
   - 根据任务量调整 `CELERY_WORKER_AMOUNT`
   - 监控 Worker 负载情况

2. **数据库优化**：
   - 调整 `SQLALCHEMY_POOL_SIZE`
   - 优化数据库查询
   - 添加必要的索引

3. **缓存优化**：
   - 合理使用 Redis 缓存
   - 设置合适的缓存过期时间

## 📚 相关资源

- [DIFY 官方文档](https://docs.dify.ai/)
- [DIFY GitHub](https://github.com/langgenius/dify)
- [MCP 协议文档](https://modelcontextprotocol.io/)
- [Celery 文档](https://docs.celeryq.dev/)

## 📞 技术支持

如有问题或建议，请联系 SecCortex 开发团队。

## 📄 许可证

本项目为 SecCortex 平台的一部分，遵循平台相关许可证。

---

**最后更新**：2025-11-24

