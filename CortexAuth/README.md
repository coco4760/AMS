# CortexAuth - 统一认证服务

## 📖 项目简介

CortexAuth 是基于 **Keycloak** 构建的统一认证服务，为 SecCortex 平台提供完整的身份认证和授权功能。支持多种登录方式，包括用户名密码登录、微信登录等，并提供用户注册、密码重置等完整的用户管理功能。

## ✨ 功能特性

### 🔐 核心认证功能
- **用户登录**：支持用户名/邮箱 + 密码登录
- **用户注册**：新用户注册，支持邮箱验证
- **密码管理**：密码重置、密码修改
- **会话管理**：Token 刷新、登出功能

### 🔗 第三方登录
- **微信登录**：支持微信 OAuth2.0 登录
- **可扩展**：架构支持接入更多第三方登录方式（QQ、GitHub、Google 等）

### 🛡️ 安全特性
- **SM2 国密加密**：支持 SM2 公钥加密算法
- **JWT Token**：基于 Keycloak 的 JWT 令牌机制
- **会话管理**：安全的会话管理和 Token 刷新机制
- **密码加密**：密码采用安全加密存储

### ⚙️ 技术特性
- **配置中心集成**：基于 Nacos 的配置管理
- **微服务架构**：RESTful API 设计，易于集成
- **容器化部署**：Docker Compose 一键部署

## 🚀 快速开始

### 前置要求

- Docker 和 Docker Compose
- Keycloak 服务（已在平台中配置）
- Nacos 配置中心（用于配置管理）
- Redis（用于会话存储）
- MySQL/PostgreSQL（用于数据存储）

### 环境变量配置

创建 `.env` 文件，配置以下环境变量：

```bash
# 服务端口
AUTH_HTTP_PORT=8080

# 安装路径
INSTALL_LOCAL=/data/secCortex

# Keycloak 配置（从 Nacos 获取）
# - Keycloak 服务器地址
# - Realm 配置
# - 客户端 ID 和 Secret

# 数据库配置（从 Nacos 获取）
# - MySQL/PostgreSQL 连接信息

# Redis 配置（从 Nacos 获取）
# - Redis 服务器地址和密码
```

### 启动服务

```bash
# 进入目录
cd CortexAuth

# 启动服务
docker compose up -d

# 查看日志
docker compose logs -f auth-http-api
```

### 验证服务

```bash
# 检查服务状态
curl http://localhost:8080/authapi/health

# 或访问 Swagger API 文档（如果已配置）
# http://localhost:8080/authapi/swagger-ui.html
```

## 📁 项目结构

```
CortexAuth/
├── docker-compose.yaml      # Docker Compose 配置文件
├── config/
│   └── application.yml      # 应用配置文件
├── .env                     # 环境变量文件（需自行创建）
└── README.md                # 项目文档
```

## ⚙️ 配置说明

### application.yml 配置

主要配置项说明：

```yaml
server:
  port: 80                                    # 服务端口
  servlet:
    context-path: ${CONTEXT_PATH}             # 上下文路径（默认：/authapi）

nacos:
  config:
    server-addr: 192.168.34.7:18848          # Nacos 服务器地址
    username: nacos                           # Nacos 用户名
    password: clouditera                      # Nacos 密码
    data-ids: redis, security, mysql, postgresql, webide, dify, plugin, keycloak, minio
    enable-remote-sync-config: true           # 启用远程配置同步
    remote-first: true                        # 优先使用远程配置

clouditera:
  sm2:
    privateKey: <SM2私钥>                     # SM2 私钥
    publicKey: <SM2公钥>                      # SM2 公钥
  wx:
    appid: <微信AppID>                         # 微信应用 ID
    serect: <微信Secret>                       # 微信应用密钥
```

### 关键配置说明

1. **Nacos 配置中心**：服务从 Nacos 获取以下配置：
   - `redis`：Redis 连接配置
   - `security`：安全相关配置
   - `mysql`：MySQL 数据库配置
   - `postgresql`：PostgreSQL 数据库配置
   - `keycloak`：Keycloak 服务器配置
   - `minio`：MinIO 对象存储配置
   - 其他业务配置

2. **微信登录配置**：
   - `appid`：微信开放平台应用 ID
   - `serect`：微信开放平台应用密钥
   - 需要在微信开放平台注册应用并配置回调地址

3. **SM2 加密**：
   - 用于敏感数据加密
   - 私钥和公钥需要妥善保管

## 📡 API 接口文档

### 基础路径

所有 API 接口的基础路径为：`http://<host>:<port>/authapi`

### 认证接口

#### 1. 用户登录

**接口地址**：`POST /auth/login`

**请求参数**：
```json
{
  "username": "user@example.com",  // 用户名或邮箱
  "password": "password123"         // 密码
}
```

**响应示例**：
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600,
    "tokenType": "Bearer",
    "userInfo": {
      "userId": "123456",
      "username": "user@example.com",
      "nickname": "用户昵称",
      "avatar": "https://..."
    }
  }
}
```

#### 2. 用户注册

**接口地址**：`POST /auth/register`

**请求参数**：
```json
{
  "username": "user@example.com",   // 用户名（邮箱）
  "password": "password123",         // 密码
  "nickname": "用户昵称",            // 昵称（可选）
  "email": "user@example.com",       // 邮箱
  "phone": "13800138000"            // 手机号（可选）
}
```

**响应示例**：
```json
{
  "code": 200,
  "message": "注册成功",
  "data": {
    "userId": "123456",
    "username": "user@example.com"
  }
}
```

#### 3. 微信登录

**接口地址**：`GET /auth/wechat/login`

**请求参数**：
- `code`：微信授权码（通过微信 OAuth2.0 授权获取）

**响应示例**：
```json
{
  "code": 200,
  "message": "微信登录成功",
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600,
    "userInfo": {
      "userId": "123456",
      "openid": "wx_openid_123456",
      "nickname": "微信昵称",
      "avatar": "https://..."
    }
  }
}
```

#### 4. 刷新 Token

**接口地址**：`POST /auth/refresh`

**请求参数**：
```json
{
  "refreshToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**响应示例**：
```json
{
  "code": 200,
  "message": "Token 刷新成功",
  "data": {
    "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 3600
  }
}
```

#### 5. 用户登出

**接口地址**：`POST /auth/logout`

**请求头**：
```
Authorization: Bearer <accessToken>
```

**响应示例**：
```json
{
  "code": 200,
  "message": "登出成功"
}
```

#### 6. 密码重置

**接口地址**：`POST /auth/password/reset`

**请求参数**：
```json
{
  "email": "user@example.com",      // 邮箱
  "newPassword": "newPassword123"    // 新密码
}
```

**响应示例**：
```json
{
  "code": 200,
  "message": "密码重置成功，请查收邮件"
}
```

#### 7. 修改密码

**接口地址**：`POST /auth/password/change`

**请求头**：
```
Authorization: Bearer <accessToken>
```

**请求参数**：
```json
{
  "oldPassword": "oldPassword123",   // 旧密码
  "newPassword": "newPassword123"    // 新密码
}
```

**响应示例**：
```json
{
  "code": 200,
  "message": "密码修改成功"
}
```

### 用户信息接口

#### 获取当前用户信息

**接口地址**：`GET /auth/user/info`

**请求头**：
```
Authorization: Bearer <accessToken>
```

**响应示例**：
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "userId": "123456",
    "username": "user@example.com",
    "nickname": "用户昵称",
    "email": "user@example.com",
    "phone": "13800138000",
    "avatar": "https://...",
    "roles": ["user", "admin"],
    "permissions": ["read", "write"]
  }
}
```

## 🔧 部署说明

### Docker Compose 部署

1. **准备环境变量文件**：
   ```bash
   cp .env.example .env
   # 编辑 .env 文件，配置必要的环境变量
   ```

2. **启动服务**：
   ```bash
   docker compose up -d
   ```

3. **查看服务状态**：
   ```bash
   docker compose ps
   ```

4. **查看日志**：
   ```bash
   docker compose logs -f auth-http-api
   ```

5. **停止服务**：
   ```bash
   docker compose down
   ```

### 健康检查

服务启动后，可以通过以下方式检查服务健康状态：

```bash
# 检查服务是否运行
docker compose ps

# 检查服务日志
docker compose logs auth-http-api

# 测试 API 接口
curl http://localhost:8080/authapi/health
```

## 🔒 安全建议

1. **密钥管理**：
   - SM2 私钥和公钥应妥善保管，不要提交到代码仓库
   - 微信 AppID 和 Secret 应使用环境变量或配置中心管理

2. **Token 安全**：
   - Access Token 有效期建议设置为较短时间（如 1 小时）
   - Refresh Token 应安全存储，建议使用 HttpOnly Cookie
   - 生产环境应启用 HTTPS

3. **密码策略**：
   - 实施强密码策略（长度、复杂度要求）
   - 密码应使用安全的哈希算法存储

4. **API 安全**：
   - 实施速率限制，防止暴力破解
   - 使用 HTTPS 传输敏感数据
   - 实施 CORS 策略，限制跨域访问

## 🐛 常见问题

### 1. 服务无法启动

**问题**：Docker Compose 启动失败

**解决方案**：
- 检查端口是否被占用：`netstat -tuln | grep 8080`
- 检查环境变量文件 `.env` 是否正确配置
- 查看日志：`docker compose logs auth-http-api`

### 2. 无法连接到 Keycloak

**问题**：认证失败，提示无法连接 Keycloak

**解决方案**：
- 确认 Keycloak 服务已启动并正常运行
- 检查 Nacos 中的 `keycloak` 配置是否正确
- 验证网络连接：`curl http://<keycloak-host>:<port>/health`

### 3. 微信登录失败

**问题**：微信登录返回错误

**解决方案**：
- 检查微信 AppID 和 Secret 是否正确
- 确认微信开放平台回调地址配置正确
- 检查微信授权码是否过期（授权码有效期通常为 5 分钟）

### 4. Nacos 配置无法加载

**问题**：服务启动后无法从 Nacos 获取配置

**解决方案**：
- 检查 Nacos 服务器地址和端口是否正确
- 验证 Nacos 用户名和密码
- 确认 Nacos 中已创建相应的配置项（data-ids）

## 📞 技术支持

如有问题或建议，请联系 SecCortex 开发团队。

## 📄 许可证

本项目为 SecCortex 平台的一部分，遵循平台相关许可证。

---

**最后更新**：2025-11-24

