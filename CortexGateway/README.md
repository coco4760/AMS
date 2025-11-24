# CortexGateway - API 网关服务

## 📖 项目简介

CortexGateway 是基于 **Kong API Gateway** 构建的统一 API 网关服务，为 SecCortex 平台提供请求路由、负载均衡、认证授权、限流熔断、监控日志等核心网关功能。作为平台的前置入口，统一管理所有微服务的 API 访问。

## ✨ 功能特性

### 🚪 核心网关功能
- **统一入口**：所有 API 请求通过网关统一接入
- **请求路由**：智能路由到后端微服务
- **负载均衡**：自动分发请求到多个后端实例
- **服务发现**：支持动态服务注册与发现

### 🔐 安全与认证
- **认证授权**：集成 Keycloak 认证服务
- **API 密钥管理**：支持 API Key 认证
- **JWT 验证**：自动验证 JWT Token
- **IP 白名单**：支持 IP 访问控制

### 📊 监控与可观测性
- **Prometheus 集成**：提供丰富的监控指标
- **访问日志**：记录所有 API 请求日志
- **性能监控**：监控延迟、吞吐量等指标
- **健康检查**：自动检测后端服务健康状态

### ⚡ 流量控制
- **限流**：支持基于 IP、用户、API 的限流策略
- **熔断**：自动熔断异常服务，保护系统稳定性
- **重试机制**：自动重试失败的请求
- **超时控制**：可配置的连接和读取超时

### 🔧 高级功能
- **请求/响应转换**：支持请求和响应数据转换
- **插件系统**：丰富的插件生态，支持自定义插件
- **配置管理**：使用 Kong Deck 进行声明式配置管理
- **HTTPS 支持**：支持 SSL/TLS 加密传输

## 🏗️ 架构设计

```
                    ┌─────────────┐
                    │   Client    │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │   Kong      │
                    │   Gateway   │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
   ┌────▼────┐      ┌──────▼──────┐    ┌─────▼─────┐
   │ AuthAPI │      │  ClientAPI   │    │  SASTAPI  │
   └─────────┘      └──────────────┘    └───────────┘
                           │
                    ┌──────▼──────┐
                    │   Plugin    │
                    │    API      │
                    └─────────────┘
```

## 🚀 快速开始

### 前置要求

- Docker 和 Docker Compose
- PostgreSQL 数据库（用于 Kong 数据存储）
- 后端微服务已部署并正常运行

### 环境变量配置

创建 `.env` 文件，配置以下环境变量：

```bash
# Kong 数据库配置
KONG_DATABASE=postgres
KONG_PG_DATABASE=kong
KONG_PG_HOST=postgres
KONG_PG_PORT=5432
KONG_PG_USER=kong
KONG_PG_PASSWORD=your_password

# Kong 监听配置
KONG_ADMIN_GUI_LISTEN=0.0.0.0:8002
KONG_ADMIN_LISTEN=0.0.0.0:8001
KONG_PROXY_LISTEN=0.0.0.0:8000

# 代理端口配置
KONG_INBOUND_PROXY_LISTEN=0.0.0.0:8000
KONG_INBOUND_SSL_PROXY_LISTEN=0.0.0.0:8443

# Deck 配置
DECK_KONG_ADDR=http://kong:8001

# 后端服务主机映射（用于服务发现）
AUTH_HTTP_HOST=192.168.1.100
CLIENT_HTTP_HOST=192.168.1.101
AI_PLUGIN_HOST=192.168.1.102
SAST_HTTP_HOST=192.168.1.103
```

### 启动服务

```bash
# 进入目录
cd CortexGateway

# 启动服务
docker compose up -d

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f kong
```

### 验证服务

```bash
# 检查 Kong 健康状态
curl http://localhost:8001/health

# 检查代理服务
curl http://localhost:8000/

# 访问管理界面（如果已配置）
# http://localhost:8002
```

## 📁 项目结构

```
CortexGateway/
├── docker-compose.yaml              # Docker Compose 配置文件
├── volumes/
│   └── kong/
│       ├── config/
│       │   └── kong.yaml            # Kong 基础配置文件
│       └── deck/
│           └── kong.yaml             # Kong Deck 声明式配置
├── .env                             # 环境变量文件（需自行创建）
└── README.md                        # 项目文档
```

## ⚙️ 配置说明

### Kong 服务配置

Kong 网关包含以下服务：

1. **kong-migrations**：数据库迁移服务
   - 负责初始化 Kong 数据库表结构
   - 仅在首次启动或数据库结构变更时运行

2. **kong**：Kong 网关主服务
   - 提供 API 代理功能
   - 管理路由、服务、插件等配置
   - 提供 Admin API 和管理界面

3. **kong-deck**：配置同步服务
   - 使用 Kong Deck 工具同步声明式配置
   - 从 `volumes/kong/deck/kong.yaml` 读取配置并同步到 Kong

### 端口说明

| 端口 | 用途 | 说明 |
|------|------|------|
| 8000 | Proxy | HTTP 代理端口，客户端请求入口 |
| 8443 | Proxy SSL | HTTPS 代理端口 |
| 8001 | Admin API | Kong 管理 API，用于配置管理 |
| 8444 | Admin API SSL | Kong 管理 API HTTPS 端口 |
| 8002 | Admin GUI | Kong 管理界面（如果启用） |

### 路由配置

当前网关配置了以下路由：

#### 1. 认证服务 (authapi)
- **路径**：`/authapi`
- **后端服务**：`authhttp:18889`
- **说明**：处理所有认证相关请求

#### 2. 客户端服务 (clientapi)
- **路径**：`/clientapi`
- **后端服务**：`clienthttp:18888`
- **说明**：处理客户端相关请求

#### 3. AI 插件服务 (plugin)
- **路径**：`/plugin`
- **后端服务**：`ai-plugin:18002`
- **说明**：处理 AI 插件相关请求
- **特殊配置**：`strip_path: true`（移除路径前缀）

#### 4. SAST 服务 (sastapi)
- **路径**：`/sastapi`
- **后端服务**：`sasthttp:18887`
- **说明**：处理 SAST 相关请求
- **超时配置**：`read_timeout: 6000000`（10 分钟）

### 插件配置

#### Prometheus 监控插件

已启用 Prometheus 插件，提供以下指标：

- **带宽指标** (`bandwidth_metrics`)：监控请求和响应带宽
- **延迟指标** (`latency_metrics`)：监控请求延迟
- **状态码指标** (`status_code_metrics`)：统计 HTTP 状态码
- **上游健康指标** (`upstream_health_metrics`)：监控后端服务健康状态
- **消费者指标** (`per_consumer`)：按消费者统计指标

**访问指标**：
```bash
# 获取 Prometheus 指标
curl http://localhost:8001/metrics
```

## 📡 API 使用示例

### 通过网关访问认证服务

```bash
# 用户登录
curl -X POST http://localhost:8000/authapi/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "user@example.com",
    "password": "password123"
  }'
```

### 通过网关访问客户端服务

```bash
# 获取客户端信息
curl http://localhost:8000/clientapi/client/info \
  -H "Authorization: Bearer <token>"
```

### 通过网关访问 SAST 服务

```bash
# 提交扫描任务
curl -X POST http://localhost:8000/sastapi/scan/submit \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "projectId": "123",
    "scanType": "sast"
  }'
```

### 通过网关访问插件服务

```bash
# 调用 AI 插件
curl http://localhost:8000/plugin/api/endpoint \
  -H "Authorization: Bearer <token>"
```

## 🔧 管理操作

### 使用 Kong Admin API

Kong 提供了完整的 Admin API 用于管理配置：

```bash
# 查看所有服务
curl http://localhost:8001/services

# 查看所有路由
curl http://localhost:8001/routes

# 查看所有插件
curl http://localhost:8001/plugins

# 添加新服务
curl -X POST http://localhost:8001/services \
  -H "Content-Type: application/json" \
  -d '{
    "name": "myservice",
    "url": "http://backend:8080"
  }'

# 为服务添加路由
curl -X POST http://localhost:8001/services/myservice/routes \
  -H "Content-Type: application/json" \
  -d '{
    "paths": ["/myservice"]
  }'
```

### 使用 Kong Deck 管理配置

Kong Deck 支持声明式配置管理：

```bash
# 同步配置到 Kong
docker compose exec kong-deck deck sync

# 从 Kong 导出配置
docker compose exec kong-deck deck dump

# 验证配置
docker compose exec kong-deck deck validate
```

### 查看日志

```bash
# 查看 Kong 代理日志
docker compose logs -f kong | grep proxy

# 查看 Kong 管理日志
docker compose logs -f kong | grep admin

# 查看所有日志
docker compose logs -f
```

## 📊 监控与指标

### Prometheus 指标

Kong 通过 Prometheus 插件暴露以下指标：

- `kong_http_requests_total`：HTTP 请求总数
- `kong_http_requests_latency_ms`：请求延迟（毫秒）
- `kong_bandwidth_bytes`：带宽使用量（字节）
- `kong_upstream_latency_ms`：上游服务延迟
- `kong_http_status`：HTTP 状态码统计

### 集成 Prometheus

在 Prometheus 配置中添加：

```yaml
scrape_configs:
  - job_name: 'kong'
    static_configs:
      - targets: ['kong:8001']
    metrics_path: '/metrics'
```

### 健康检查

```bash
# 检查 Kong 健康状态
curl http://localhost:8001/health

# 检查数据库连接
curl http://localhost:8001/status
```

## 🔒 安全建议

1. **管理接口安全**：
   - 生产环境应限制 Admin API 访问（仅允许内网访问）
   - 使用防火墙规则限制 8001、8444、8002 端口访问
   - 考虑使用认证机制保护 Admin API

2. **HTTPS 配置**：
   - 生产环境应启用 HTTPS（8443 端口）
   - 配置有效的 SSL 证书
   - 启用 HTTP 到 HTTPS 的重定向

3. **数据库安全**：
   - 使用强密码保护 PostgreSQL 数据库
   - 限制数据库网络访问
   - 定期备份数据库

4. **API 安全**：
   - 启用认证插件（JWT、OAuth2 等）
   - 配置限流插件防止 DDoS 攻击
   - 使用 IP 白名单限制访问

5. **日志安全**：
   - 避免在日志中记录敏感信息（密码、Token 等）
   - 定期轮转日志文件
   - 监控异常访问模式

## 🐛 常见问题

### 1. Kong 启动失败

**问题**：Kong 服务无法启动

**解决方案**：
- 检查 PostgreSQL 是否正常运行
- 验证数据库连接配置是否正确
- 查看日志：`docker compose logs kong-migrations`
- 确认数据库迁移是否成功完成

### 2. 路由无法访问

**问题**：通过网关访问后端服务返回 404

**解决方案**：
- 检查路由配置是否正确：`curl http://localhost:8001/routes`
- 验证后端服务是否正常运行
- 检查 `extra_hosts` 配置是否正确
- 查看 Kong 日志：`docker compose logs kong`

### 3. 配置同步失败

**问题**：Kong Deck 同步配置失败

**解决方案**：
- 检查 `volumes/kong/deck/kong.yaml` 文件格式是否正确
- 验证 Kong Admin API 是否可访问
- 查看 Deck 日志：`docker compose logs kong-deck`
- 手动验证配置：`docker compose exec kong-deck deck validate`

### 4. 性能问题

**问题**：网关响应慢或超时

**解决方案**：
- 检查后端服务响应时间
- 调整超时配置（`connect_timeout`、`read_timeout`、`write_timeout`）
- 检查网络连接质量
- 查看 Prometheus 指标分析瓶颈

### 5. 数据库连接问题

**问题**：Kong 无法连接 PostgreSQL

**解决方案**：
- 验证 PostgreSQL 服务是否运行
- 检查数据库连接参数（主机、端口、用户名、密码）
- 确认网络连接：`docker compose exec kong ping postgres`
- 检查数据库用户权限

## 🔄 升级与维护

### 升级 Kong 版本

1. **备份数据**：
   ```bash
   # 备份 PostgreSQL 数据库
   docker compose exec postgres pg_dump -U kong kong > kong_backup.sql
   ```

2. **更新镜像版本**：
   ```bash
   # 修改 docker-compose.yaml 中的镜像版本
   # 拉取新镜像
   docker compose pull
   ```

3. **执行数据库迁移**：
   ```bash
   # Kong 会自动检测并执行必要的数据库迁移
   docker compose up -d
   ```

4. **验证升级**：
   ```bash
   # 检查 Kong 版本
   curl http://localhost:8001/ | jq .version
   ```

### 配置备份

定期备份 Kong 配置：

```bash
# 导出所有配置
docker compose exec kong-deck deck dump --output-file kong-config.yaml

# 或使用 Admin API 导出
curl http://localhost:8001/config > kong-config.json
```

### 性能调优

1. **调整超时配置**：根据后端服务响应时间调整超时参数
2. **启用缓存**：使用 Redis 缓存插件提高性能
3. **连接池优化**：调整数据库连接池大小
4. **日志级别**：生产环境降低日志级别减少 I/O

## 📚 相关资源

- [Kong 官方文档](https://docs.konghq.com/)
- [Kong Admin API 参考](https://docs.konghq.com/gateway/latest/admin-api/)
- [Kong Deck 文档](https://docs.konghq.com/deck/)
- [Kong 插件市场](https://docs.konghq.com/hub/)

## 📞 技术支持

如有问题或建议，请联系 SecCortex 开发团队。

## 📄 许可证

本项目为 SecCortex 平台的一部分，遵循平台相关许可证。

---

**最后更新**：2025-11-24

