## CortexServer 总览

CortexServer 汇聚了大模型应用的核心**服务端**（`service/`）以及一组面向 Agent / 工作流的**插件服务**（`plugins/`）。这一目录的 Compose 脚本可单独启动，也能与 `CortexAuth`、`CortexGateway`、`CortexInfra` 等组件协同，组成完整的 SecCortex AI 解决方案。

```
CortexServer/
├── service/                # 大模型业务服务端 (WuJi client-http API)
│   ├── docker-compose.yaml
│   └── config/
│       └── application.yml
└── plugins/                # Agent / Workflow 插件
    ├── asset_judgment/
    ├── cloudflow/
    ├── clouditera_paper/
    ├── clouditera_plugin/
    ├── clouditera_plugin_for_vul/
    ├── clouditera_plugin_sectools/
    ├── clouditera_plugin_wireshark/
    ├── defect_judgement/
    ├── email-check/
    ├── filems/
    ├── knowledge-base-filemeta/
    ├── mcp-tools/
    └── pdf_translate/
```

---

## 服务端（`service/`）

### 作用

- 提供 **WuJi Client API** (`/clientapi`) —— 供前端、Agent、第三方应用调取
- 统一接入 Nacos 配置、SM2 加密、邀请注册、Redis/MySQL/PostgreSQL 等依赖
- 暴露 OpenAPI/Swagger 文档（可通过 `springdoc.swagger-ui.enabled` 控制）

### 关键镜像

| 服务 | 镜像 | 默认端口 |
| --- | --- | --- |
| `client-http` | `rd.clouditera.com/aigc/wuji/client-http-api:v3.10.33` | `CLIENT_HTTP_PORT` → 80 |

### 主要配置（`config/application.yml`）

- `nacos.config.server-addr`：集中配置中心地址，包含 redis/security/mysql/postgresql/webide/dify/plugin/keycloak/minio/rag/rabbitmq 等配置片段
- `clouditera.sm2`：SM2 公私钥，用于敏感数据加密
- `spring.servlet.multipart.*`：上传大小限制（默认 100MB）
- `entity.vulid` / `vul.allow.offline-update`：漏洞相关业务开关

### 快速启动

```bash
cd CortexServer/service
cp .env.example .env   # 若仓库未提供可自建
# 配置 CLIENT_HTTP_PORT、NACOS、数据库等变量

docker compose up -d
docker compose logs -f client-http
```

访问 `http://<host>:<CLIENT_HTTP_PORT>/clientapi` 或 `.../swagger-ui.html` 验证是否运行。

---

## 插件（`plugins/`）

插件目录下每个子文件夹都含独立的 `docker-compose.yml`，用于暴露给 Agent / Workflow 调用的业务能力。常见用途包括资产识别、缺陷判读、文档处理、知识库解析等。以下为内置插件列表（如需启用，请进入对应目录执行 `docker compose up -d`）：

| 插件 | 说明 | 主要镜像/端口（示例） |
| --- | --- | --- |
| `asset_judgment` | 资产判定与评估能力（含 `sgcc.yaml` 预设） | `rd.clouditera.com/aigc/plugins/assetmind`，默认暴露 58000 |
| `cloudflow` | CloudFlow 工作流执行器 | `rd.clouditera.com/aigc/cloudflow:0.5.3.1`，默认 65000 |
| `clouditera_paper` | 论文检索与分析 | `rd.clouditera.com/aigc/plugins/paper-api:2.2` |
| `clouditera_plugin` | 通用插件集成入口 | `rd.clouditera.com/aigc/plugin/*` |
| `clouditera_plugin_for_vul` | 漏洞扫描/分析插件 | `rd.clouditera.com/aigc/plguins/ai-plugin-for-vul` |
| `clouditera_plugin_sectools` | 安全工具箱 | `rd.clouditera.com/aigc/plugins/sectoolsapi` |
| `clouditera_plugin_wireshark` | 报文/协议解析 | `rd.clouditera.com/aigc/plugins/wireshark` |
| `defect_judgement` | 缺陷判读，附带 `data/` 训练示例 | `rd.clouditera.com/aigc/plugins/zhiku` 等 |
| `email-check` | 邮件检测 / 合规插件 | `rd.clouditera.com/aigc/plugins/email-plugin` |
| `filems` | 文件管理 & OCR 服务，支持 `config/config.json` | `rd.clouditera.com/infra/filems:sast-v2.5-0` |
| `knowledge-base-filemeta` | 文档元数据抽取 | `rd.clouditera.com/aigc/plugins/knowledge-base-filemeta` |
| `mcp-tools` | MCP 工具集，支持命令执行、调试 | `rd.clouditera.com/aigc/plugins/mcp-tool` |
| `pdf_translate` | PDF 翻译 / 数学公式识别 | `rd.clouditera.com/docker/pdfmathtranslate-next:dev` |

> ⚠️ 端口及镜像版本可在各自的 `docker-compose.yml` 内查看；如需自定义，请修改 `.env` 或 Compose 文件再启动。

### 插件启动示例

```bash
cd CortexServer/plugins/pdf_translate
cp .env.example .env          # 若需要配置 OPENAI_KEY / Redis 等
docker compose up -d

# 验证
curl http://<host>:<port>/health
```

### 常见依赖

- **Nacos**：多数插件会从 Nacos 获取数据库/Redis/第三方服务配置
- **Redis / RabbitMQ / MinIO**：用于缓存、任务队列、文件存储
- **向量库（PostgreSQL + pgvector / Qdrant）**：部分插件需要向量检索能力

请先保证 `CortexInfra` 中的对应服务已启动。

---

## 运维建议

1. **统一配置**：优先在 Nacos 或 `.env` 中维护公共配置（数据库、Redis、MinIO 等），避免在各插件中重复硬编码。
2. **日志与监控**：可借助 `docker compose logs`、Kong / Prometheus / Loki 等统一采集插件日志，便于排障。
3. **资源规划**：某些插件（如 CloudFlow、PDF 翻译、文件解析）对 CPU/内存要求较高，建议分布式部署或限制容器资源。
4. **安全**：公开服务务必配置 WAF / Kong 路由 / Auth 组件，避免直接暴露在公网；敏感配置（SM2、API Key）切勿提交到仓库。
5. **版本管理**：推荐通过 `pull-images.sh` 定期拉取最新镜像，同时在变更前记录当前版本，便于回滚。

---

## 常见问题

| 问题 | 排查思路 |
| --- | --- |
| 服务端无法访问 Nacos | 确认 `service/.env` 中的 `NACOS_ADDR`，查看 `docker compose logs client-http` 中是否有 `connect timeout`，并验证网络连通性 |
| 插件启动后接口 404 | 检查对应插件 `docker-compose.yml` 是否映射了正确端口，或通过 Kong 统一路由 |
| 调用插件报错 “配置缺失” | 登录 Nacos 校验该插件要求的 `data-id` 是否存在（如 redis、plugin、rag 等） |
| 文件上传失败 | 调整服务端 `spring.servlet.multipart.max-*`，或确认 MinIO / 文件系统权限是否充足 |

---

如需新增自研插件：复制 `plugins/<模板>`，修改镜像、环境变量与端口，并在 README 中补充说明即可。欢迎提交 PR / Issue，一起丰富 CortexServer 的插件生态。💪

