# SecCortex 端口优化方案

## 📊 当前端口使用情况分析

### 基础设施层 (CortexInfra)

| 服务 | 当前端口 | 容器端口 | 说明 | 问题 |
|------|---------|---------|------|------|
| MySQL | `${MYSQL_PORT}` (13306) | 3306 | 关系数据库 | ✅ 使用环境变量 |
| PostgreSQL | `${PG_PORT}` (15432) | 5432 | 向量数据库 | ✅ 使用环境变量 |
| Redis | `${HOST_PORT:-16379}` | 6379 | 缓存服务 | ✅ 使用环境变量 |
| RabbitMQ AMQP | 8672 | 5672 | 消息队列 | ❌ 硬编码 |
| RabbitMQ UI | 18672 | 15672 | 管理控制台 | ❌ 硬编码 |
| MinIO API | 19000 | 9000 | 对象存储 | ❌ 硬编码 |
| MinIO Console | 19001 | 9001 | 管理控制台 | ❌ 硬编码 |
| Nacos HTTP | 18848 | 8848 | 配置中心 | ❌ 硬编码 |
| Nacos gRPC | 19848 | 9848 | gRPC 接口 | ❌ 硬编码 |
| Qdrant REST | `${QDRANT_REST_API_PORT}` | 6333 | 向量数据库 | ⚠️ 未统一 |
| Qdrant gRPC | `${QDRANT_GRPC_API_PORT}` | 6334 | gRPC 接口 | ⚠️ 未统一 |
| Elasticsearch HTTP | 9200 | 9200 | 搜索引擎 | ❌ 硬编码 |
| Elasticsearch Cluster | 9300 | 9300 | 集群通信 | ❌ 硬编码 |
| MongoDB | `${MONGO_PORT}` (17017) | 27017 | 文档数据库 | ✅ 使用环境变量 |
| Keycloak | 18080 | 8080 | 认证服务 | ❌ 硬编码 |
| Firecrawl | 3002 | 3002 | 网页抓取 | ❌ 硬编码 |
| MinerU | 48000 | 8000 | ETL 服务 | ❌ 硬编码 |

### 业务服务层

| 服务 | 当前端口 | 容器端口 | 说明 | 问题 |
|------|---------|---------|------|------|
| Auth API | `${AUTH_HTTP_PORT}` (8080) | 80 | 认证 API | ✅ 使用环境变量 |
| Server API | `${CLIENT_HTTP_PORT}` (80) | 80 | 服务端 API | ⚠️ 可能与 Web 冲突 |
| Web Frontend | 80 | 80 | 前端界面 | ⚠️ 可能与 Server 冲突 |
| Gateway (Kong) | 8000, 8001, 8002, 8443, 8444 | 8000, 8001, 8002, 8443, 8444 | API 网关 | ❌ 硬编码多个端口 |
| RAG Backend | 58081 | 8081 | RAG 后端 API | ❌ 硬编码 |
| RAG Frontend | 58082 | 8080 | RAG 前端 | ❌ 硬编码 |
| RAG PostgreSQL | 55432 | 5432 | RAG 数据库 | ❌ 硬编码 |
| RAG Redis | 56379 | 6379 | RAG 缓存 | ⚠️ 与基础设施 Redis 端口混乱 |
| RAG Qdrant | 56333, 56334 | 6333, 6334 | RAG 向量库 | ⚠️ 与基础设施 Qdrant 端口混乱 |
| SOP API | 15001 | 5001 | 工作流 API | ❌ 硬编码 |
| SOP Sandbox | 18194 | 8194 | 代码沙箱 | ❌ 硬编码 |
| SOP Plugin | 15004, 15003 | 5002, 5003 | 插件服务 | ❌ 硬编码 |
| SOP Nginx | 10081 | 80 | 工作流前端 | ❌ 硬编码 |

## 🔍 主要问题

1. **端口分配混乱**
   - 没有统一的端口规划规则
   - 基础设施和业务服务端口混用
   - RAG 服务内部端口与基础设施端口冲突

2. **配置方式不统一**
   - 部分服务使用环境变量，部分硬编码
   - 环境变量命名不统一

3. **端口范围分散**
   - 没有按服务类型分组
   - 难以记忆和管理

4. **潜在冲突**
   - Web Frontend (80) 和 Server API (80) 可能冲突
   - RAG Redis (56379) 和基础设施 Redis (16379) 容易混淆

## 🎯 优化方案

### 端口分配规则

采用**分层端口规划**，按服务类型分配端口范围：

```
10000-19999: 基础设施层 (Infrastructure)
20000-29999: 业务服务层 (Business Services)
30000-39999: 前端服务层 (Frontend Services)
40000-49999: 工具服务层 (Tool Services)
50000-59999: 内部服务层 (Internal Services) - 不对外暴露
```

### 优化后的端口分配

#### 基础设施层 (10000-19999)

| 服务 | 优化端口 | 容器端口 | 说明 |
|------|---------|---------|------|
| MySQL | 10001 | 3306 | 关系数据库 |
| PostgreSQL | 10002 | 5432 | 向量数据库 |
| Redis | 10003 | 6379 | 缓存服务 |
| RabbitMQ AMQP | 10004 | 5672 | 消息队列 |
| RabbitMQ UI | 10005 | 15672 | 管理控制台 |
| MinIO API | 10006 | 9000 | 对象存储 |
| MinIO Console | 10007 | 9001 | 管理控制台 |
| Nacos HTTP | 10008 | 8848 | 配置中心 |
| Nacos gRPC | 10009 | 9848 | gRPC 接口 |
| Qdrant REST | 10010 | 6333 | 向量数据库 |
| Qdrant gRPC | 10011 | 6334 | gRPC 接口 |
| Elasticsearch HTTP | 10012 | 9200 | 搜索引擎 |
| Elasticsearch Cluster | 10013 | 9300 | 集群通信 |
| MongoDB | 10014 | 27017 | 文档数据库 |
| Keycloak | 10015 | 8080 | 认证服务 |
| Firecrawl | 10016 | 3002 | 网页抓取 |
| MinerU | 10017 | 8000 | ETL 服务 |

#### 业务服务层 (20000-29999)

| 服务 | 优化端口 | 容器端口 | 说明 |
|------|---------|---------|------|
| Auth API | 20001 | 80 | 认证 API |
| Server API | 20002 | 80 | 服务端 API |
| Gateway Proxy | 20003 | 8000 | API 网关代理 |
| Gateway Admin | 20004 | 8001 | API 网关管理 |
| Gateway Admin GUI | 20005 | 8002 | API 网关管理界面 |
| Gateway SSL | 20006 | 8443 | API 网关 SSL |
| Gateway Admin SSL | 20007 | 8444 | API 网关管理 SSL |
| RAG Backend | 20008 | 8081 | RAG 后端 API |
| SOP API | 20009 | 5001 | 工作流 API |
| SOP Plugin | 20010, 20011 | 5002, 5003 | 插件服务 |
| SOP Sandbox | 20012 | 8194 | 代码沙箱 |

#### 前端服务层 (30000-39999)

| 服务 | 优化端口 | 容器端口 | 说明 |
|------|---------|---------|------|
| Web Frontend | 30001 | 80 | 主前端界面 |
| RAG Frontend | 30002 | 8080 | RAG 前端界面 |
| SOP Frontend | 30003 | 80 | 工作流前端界面 |

#### 工具服务层 (40000-49999)

| 服务 | 优化端口 | 容器端口 | 说明 |
|------|---------|---------|------|
| Flower (Celery) | 40001 | 5555 | Celery 监控 |
| 其他工具服务 | 40002-49999 | - | 预留 |

#### 内部服务层 (50000-59999)

**注意：这些端口不对外暴露，仅用于容器间通信**

| 服务 | 容器端口 | 说明 |
|------|---------|------|
| RAG PostgreSQL | 5432 | RAG 内部数据库 |
| RAG Redis | 6379 | RAG 内部缓存 |
| RAG Qdrant | 6333, 6334 | RAG 内部向量库 |

## 📝 实施步骤

### 第一步：创建统一的端口配置文件

创建 `/root/SecCortex/.env.ports` 文件，统一管理所有端口：

```bash
# ============================================
# SecCortex 端口配置
# ============================================

# 基础设施层 (10000-19999)
MYSQL_PORT=10001
POSTGRES_PORT=10002
REDIS_PORT=10003
RABBITMQ_AMQP_PORT=10004
RABBITMQ_UI_PORT=10005
MINIO_API_PORT=10006
MINIO_CONSOLE_PORT=10007
NACOS_HTTP_PORT=10008
NACOS_GRPC_PORT=10009
QDRANT_REST_PORT=10010
QDRANT_GRPC_PORT=10011
ELASTICSEARCH_HTTP_PORT=10012
ELASTICSEARCH_CLUSTER_PORT=10013
MONGO_PORT=10014
KEYCLOAK_PORT=10015
FIRECRAWL_PORT=10016
MINERU_PORT=10017

# 业务服务层 (20000-29999)
AUTH_HTTP_PORT=20001
CLIENT_HTTP_PORT=20002
KONG_PROXY_PORT=20003
KONG_ADMIN_PORT=20004
KONG_ADMIN_GUI_PORT=20005
KONG_SSL_PORT=20006
KONG_ADMIN_SSL_PORT=20007
RAG_BACKEND_PORT=20008
SOP_API_PORT=20009
SOP_PLUGIN_PORT_1=20010
SOP_PLUGIN_PORT_2=20011
SOP_SANDBOX_PORT=20012

# 前端服务层 (30000-39999)
WEB_FRONTEND_PORT=30001
RAG_FRONTEND_PORT=30002
SOP_FRONTEND_PORT=30003

# 工具服务层 (40000-49999)
FLOWER_PORT=40001
```

### 第二步：更新各组件配置

#### 2.1 基础设施组件

**CortexInfra/mysql/docker-compose.yaml**
```yaml
ports:
  - "${MYSQL_PORT:-10001}:3306"
```

**CortexInfra/postgres/docker-compose.yaml**
```yaml
ports:
  - "${POSTGRES_PORT:-10002}:5432"
```

**CortexInfra/redis/docker-compose.yaml**
```yaml
ports:
  - "${REDIS_PORT:-10003}:6379"
```

**CortexInfra/rabbitmq/docker-compose.yml**
```yaml
ports:
  - "${RABBITMQ_AMQP_PORT:-10004}:5672"
  - "${RABBITMQ_UI_PORT:-10005}:15672"
```

**CortexInfra/minio/docker-compose.yaml**
```yaml
ports:
  - "${MINIO_API_PORT:-10006}:9000"
  - "${MINIO_CONSOLE_PORT:-10007}:9001"
```

**CortexInfra/nacos/docker-compose.yaml**
```yaml
ports:
  - "${NACOS_HTTP_PORT:-10008}:8848"
  - "${NACOS_GRPC_PORT:-10009}:9848"
```

**CortexInfra/qdrant/docker-compose.yaml**
```yaml
ports:
  - "${QDRANT_REST_PORT:-10010}:6333"
  - "${QDRANT_GRPC_PORT:-10011}:6334"
```

**CortexInfra/es/docker-compose.yaml**
```yaml
ports:
  - "${ELASTICSEARCH_HTTP_PORT:-10012}:9200"
  - "${ELASTICSEARCH_CLUSTER_PORT:-10013}:9300"
```

**CortexInfra/mongo/docker-compose.yaml**
```yaml
ports:
  - "${MONGO_PORT:-10014}:27017"
```

**CortexInfra/iam/docker-compose.yaml**
```yaml
ports:
  - "${KEYCLOAK_PORT:-10015}:8080"
```

**CortexInfra/firecrawl/docker-compose.yaml**
```yaml
ports:
  - "${FIRECRAWL_PORT:-10016}:3002"
```

**CortexInfra/mineru/docker-compose.yml**
```yaml
ports:
  - "${MINERU_PORT:-10017}:8000"
```

#### 2.2 业务服务组件

**CortexAuth/docker-compose.yaml**
```yaml
ports:
  - "${AUTH_HTTP_PORT:-20001}:80"
```

**CortexServer/service/docker-compose.yaml**
```yaml
ports:
  - "${CLIENT_HTTP_PORT:-20002}:80"
```

**CortexGateway/docker-compose.yaml**
```yaml
ports:
  - "${KONG_PROXY_PORT:-20003}:8000/tcp"
  - "${KONG_SSL_PORT:-20006}:8443/tcp"
  - "${KONG_ADMIN_PORT:-20004}:8001/tcp"
  - "${KONG_ADMIN_SSL_PORT:-20007}:8444/tcp"
  - "${KONG_ADMIN_GUI_PORT:-20005}:8002/tcp"
```

**CortexRAG/docker-compose.yml**
```yaml
rag_service_backend:
  ports:
    - "${RAG_BACKEND_PORT:-20008}:8081"

rag_service_frontend:
  ports:
    - "${RAG_FRONTEND_PORT:-30002}:8080"

# 注意：RAG 内部服务不对外暴露端口
rag_service_postgres:
  # 不暴露端口，仅容器间通信

rag_service_redis:
  # 不暴露端口，仅容器间通信

rag_service_qdrant:
  # 不暴露端口，仅容器间通信
```

**CortexSOP/docker-compose.yaml**
```yaml
api:
  ports:
    - "${SOP_API_PORT:-20009}:5001"

sandbox:
  ports:
    - "${SOP_SANDBOX_PORT:-20012}:8194"

plugin_daemon:
  ports:
    - "${SOP_PLUGIN_PORT_1:-20010}:5002"
    - "${SOP_PLUGIN_PORT_2:-20011}:5003"

nginx:
  ports:
    - "${SOP_FRONTEND_PORT:-30003}:80"
```

**CortexWeb/docker-compose.yaml**
```yaml
ports:
  - "${WEB_FRONTEND_PORT:-30001}:80"
```

### 第三步：更新部署脚本

在 `scripts/common.sh` 中添加端口配置加载：

```bash
# 加载端口配置
if [ -f "$PROJECT_ROOT/.env.ports" ]; then
    source "$PROJECT_ROOT/.env.ports"
    log_info "已加载端口配置"
fi
```

### 第四步：更新文档

更新 `README.md` 中的端口说明表格，使用新的端口分配。

## 🔄 迁移计划

### 阶段一：准备阶段（不影响现有服务）

1. 创建 `.env.ports` 文件
2. 更新所有 docker-compose 文件，使用环境变量但保留默认值
3. 测试新配置是否正常工作

### 阶段二：逐步迁移（可选）

1. 如果当前端口没有冲突，可以保持现状
2. 新部署时使用新的端口配置
3. 逐步迁移现有服务到新端口

### 阶段三：完全迁移（推荐）

1. 停止所有服务
2. 更新所有配置文件
3. 更新 Nacos 配置中的端口引用
4. 重新启动所有服务
5. 验证服务正常

## 📋 端口分配表（快速参考）

### 基础设施层 (10000-19999)

```
10001 - MySQL
10002 - PostgreSQL
10003 - Redis
10004 - RabbitMQ AMQP
10005 - RabbitMQ UI
10006 - MinIO API
10007 - MinIO Console
10008 - Nacos HTTP
10009 - Nacos gRPC
10010 - Qdrant REST
10011 - Qdrant gRPC
10012 - Elasticsearch HTTP
10013 - Elasticsearch Cluster
10014 - MongoDB
10015 - Keycloak
10016 - Firecrawl
10017 - MinerU
```

### 业务服务层 (20000-29999)

```
20001 - Auth API
20002 - Server API
20003 - Gateway Proxy
20004 - Gateway Admin
20005 - Gateway Admin GUI
20006 - Gateway SSL
20007 - Gateway Admin SSL
20008 - RAG Backend
20009 - SOP API
20010 - SOP Plugin (1)
20011 - SOP Plugin (2)
20012 - SOP Sandbox
```

### 前端服务层 (30000-39999)

```
30001 - Web Frontend
30002 - RAG Frontend
30003 - SOP Frontend
```

### 工具服务层 (40000-49999)

```
40001 - Flower (Celery)
```

## ✅ 优化效果

1. **统一管理**：所有端口通过 `.env.ports` 统一配置
2. **清晰分类**：按服务类型分层，易于记忆
3. **避免冲突**：端口范围明确，不会相互冲突
4. **易于扩展**：预留端口范围，方便添加新服务
5. **向后兼容**：使用默认值，不影响现有部署

## 🚨 注意事项

1. **端口冲突检查**：迁移前检查新端口是否被占用
2. **配置更新**：更新 Nacos 等配置中心中的端口引用
3. **防火墙规则**：更新防火墙规则以允许新端口
4. **文档同步**：更新所有相关文档和配置文件

## 📞 问题反馈

如遇到端口相关问题，请：
1. 检查 `.env.ports` 配置是否正确
2. 确认端口是否被占用：`netstat -tulpn | grep <端口>`
3. 查看服务日志：`docker compose logs -f`
4. 联系技术支持团队

