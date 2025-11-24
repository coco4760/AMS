## CortexInfra 概览

CortexInfra 汇总了 SecCortex 平台所需的基础设施服务（数据库、消息、对象存储、搜索引擎以及 AI/抓取配套等）。每个子目录均包含独立的 `docker-compose` 编排，可按需单独启动，也可组合成一套完整的基础设施栈。

当前内置的服务如下：

| 目录 | 组件 | 主要用途 | 默认端口（宿主） |
| --- | --- | --- | --- |
| `es/` | Elasticsearch 8.12.2 | 全文检索、日志/指标索引 | 9200（HTTP）、9300（集群） |
| `firecrawl/` | Firecrawl API + Worker + Playwright + Redis | 网页抓取、异步解析流水线 | 3002（API） |
| `iam/` | Keycloak 22.0.0 | 身份认证中心（CortexAuth 依赖） | 18080（HTTP） |
| `mineru/` | MinerU CPU/GPU 服务 | AIGC 相关 ETL/识别组件 | 48000 → 8000 |
| `minio/` | MinIO | 兼容 S3 的对象存储 | 19000（API）、19001（Console） |
| `mongo/` | MongoDB 5.0.5 | 文档数据库 | `${MONGO_PORT}` → 27017 |
| `mysql/` | MySQL 8.0.34 | 关系数据库、Keycloak 存储 | `${MYSQL_PORT}` → 3306 |
| `nacos/` | Nacos 2.4.3 | 配置中心/服务发现 | 18848（HTTP）、19848（gRPC） |
| `postgres/` | PostgreSQL (pgvector) | 矢量/关系存储 | `${PG_PORT}` → 5432 |
| `qdrant/` | Qdrant 1.15 | 向量数据库/相似度检索 | `${QDRANT_REST_API_PORT}` / `${QDRANT_GRPC_API_PORT}` |
| `rabbitmq/` | RabbitMQ 4.1.3 | 消息队列 + 管理控制台 | 8672（AMQP）、18672（UI） |
| `redis/` | Redis 7.2.0 | 缓存、会话、队列 | `${HOST_PORT:-16379}` → 6379 |

> ✅ **提示**：若需要其他基础组件，可参考现有目录结构添加新的 `docker-compose` 配置。

---

## 通用先决条件

1. **Docker / Docker Compose** 已安装并运行。
2. **统一数据根目录**：所有 compose 文件使用 `${INSTALL_LOCAL}` 作为宿主机数据目录前缀，请提前创建并确保磁盘空间充足（建议 ≥ 200 GB）。
3. **环境变量文件**：
   - 在相应目录创建 `.env`（若不存在），用于存放密码、端口、令牌等敏感信息。
   - 示例：
     ```bash
     INSTALL_LOCAL=/data/secCortex
     MYSQL_PORT=13306
     MYSQL_ROOT_PASSWORD=change_me
     REDIS_PASSWORD=change_me
     ```

4. **网络/主机名**：部分服务（例如 `iam/`、`CortexGateway`）通过 `extra_hosts` 解析内部域名，请根据实际情况配置 `/etc/hosts` 或 docker 网络。

---

## 快速启动流程

每个子服务的启动方式基本一致：

```bash
cd CortexInfra/<service>
cp .env.example .env   # 如仓库未提供，可自行创建
docker compose pull    # 拉取镜像
docker compose up -d   # 后台启动
docker compose ps      # 查看运行状态
docker compose logs -f # 观察日志（可选）
```

启动完成后，可通过相应端口或健康检查命令确认服务可用：

```bash
# Elasticsearch
curl http://localhost:9200

# MinIO 控制台
open http://localhost:19001

# Keycloak
curl http://localhost:18080/realms/master

# Qdrant
curl http://localhost:${QDRANT_REST_API_PORT}/collections
```

---

## 各组件补充说明

### Elasticsearch (`es/`)
- 镜像：`rd.clouditera.com/docker/elasticsearch:8.12.2`
- 已启用 `xpack.security.enabled=true`，需配置 `ES_USER`、`ELASTIC_PASSWORD`
- 单节点模式（`discovery.type=single-node`）
- 数据、插件目录持久化到 `${INSTALL_LOCAL}/es`

### Firecrawl (`firecrawl/`)
- 包含 `playwright-service`、`api`、`worker`、`redis` 四个服务
- 通过环境变量控制 OpenAI、Supabase、Slack 等外部集成
- 默认对外暴露 3002 端口
- 如需代理/多工作队列，可调整 `.env` 中对应变量

### IAM/Keycloak (`iam/`)
- 镜像：`rd.clouditera.com/docker/keycloak:22.0.0`
- 依赖外部 MySQL（示例配置 `jdbc:mysql://clouditera.mysql.com:13306/clouditera_iam`）
- 需配置 `KEYCLOAK_ADMIN`/`KEYCLOAK_ADMIN_PASSWORD`
- 可通过 `KC_DB_*` 环境变量切换数据库后端

### MinerU (`mineru/`)
- 提供 CPU 版与可选 GPU 版（`profiles: [mineru-gpu]`）
- GPU 版本需要宿主启用 NVIDIA Container Runtime
- 默认暴露 `48000` 端口，可用于 OCR/ETL 相关任务

### MinIO (`minio/`)
- 控制台端口 `19001`，API 端口 `19000`
- 默认通过环境变量 `MINIO_ROOT_USER`/`MINIO_ROOT_PASSWORD` 初始化
- 数据保存在 `${INSTALL_LOCAL}/minioData`

### MongoDB (`mongo/`)
- 镜像：`rd.clouditera.com/docker/mongo:5.0.5`
- 需配置 `MONGO_INITDB_ROOT_USERNAME`/`MONGO_INITDB_ROOT_PASSWORD`
- 数据目录 `${INSTALL_LOCAL}/mongod`

### MySQL (`mysql/`)
- 镜像：`rd.clouditera.com/docker/mysql:8.0.34`
- 默认 charset `utf8mb4`
- 自动执行 `../../_data/base/mysql` 下的初始化脚本
- 自定义配置通过 `mysql_conf/my.cnf` 挂载

### Nacos (`nacos/`)
- 镜像：`rd.clouditera.com/docker/nacos/nacos-server:v2.4.3`
- 默认端口：8848 → 18848，9848 → 19848
- 建议在 `.env` 中配置数据库连接与鉴权

### PostgreSQL (`postgres/`)
- 镜像包含 `pgvector` 扩展，满足向量检索场景
- 支持初始化脚本（`../../_data/base/postgresql`）
- 健康检查使用 `pg_isready`

### Qdrant (`qdrant/`)
- 镜像：`rd.clouditera.com/docker/qdrant:v1.15`
- 支持 REST 与 gRPC 接口
- 如需鉴权，设置 `QDRANT_API_KEY`

### RabbitMQ (`rabbitmq/`)
- 镜像：`rd.clouditera.com/docker/rabbitmq:4.1.3-management`
- 默认账户密码 `clouditera/clouditera`（请及时修改）
- 管理控制台访问 `http://localhost:18672`

### Redis (`redis/`)
- 镜像：`rd.clouditera.com/docker/redis:7.2.0`
- 启用 AOF 持久化与 `--requirepass`
- 默认健康检查 `redis-cli ping`

---

## 运维与最佳实践

1. **存储与备份**
   - 所有数据目录集中于 `${INSTALL_LOCAL}`，建议定期快照/备份。
   - 对数据库类组件（MySQL/PostgreSQL/Mongo）建立自动备份策略。

2. **安全**
   - `*.env` 中的凭据不要提交到版本库。
   - 将管理端口（Keycloak、Nacos、RabbitMQ 控制台等）限制在内网。
   - 为暴露在公网的服务配备防火墙与 SSL。

3. **监控与日志**
   - 建议使用 Prometheus + Grafana 收集 Elasticsearch、RabbitMQ、Redis 等指标。
   - 日志文件建议重定向到宿主机或集中式日志系统。

4. **资源规划**
   - Elasticsearch、Firecrawl、MinerU 等组件 CPU/内存开销较大，建议单独部署或限制资源。
   - 若同机运行多组件，优先保证数据库和缓存服务的 I/O 带宽。

5. **升级**
   - 升级前先 `docker compose pull`，再 `docker compose up -d --remove-orphans`。
   - 对数据库类组件务必提前备份。

---

## 常见问题排查

| 问题 | 排查步骤 |
| --- | --- |
| 服务启动失败 | `docker compose logs -f` 查看详细日志；确认端口未被占用；验证 `.env` 变量。 |
| 密码/端口冲突 | 在 `.env` 中重新定义端口或凭据，重新 `up -d`。 |
| 数据丢失 | 检查 `${INSTALL_LOCAL}` 是否挂载正确；确认磁盘未满。 |
| 网络无法访问后端 | 通过 `docker compose exec <svc> ping <host>` 检查内部 DNS/网络。 |
| GPU 服务无法启动 | 检查宿主机是否安装 NVIDIA 驱动，并设置 `--gpus` / `runtime: nvidia`。 |

---

如需扩展或定制，请以现有服务目录为模板新增 `docker-compose` 文件，并在本文档中补充说明即可。欢迎提 issue/PR 共享改进方案。一起让 CortexInfra 更稳、更快、更好用！💪

