---
feature: docker-deployment
complexity: standard
generated_by: clarify
generated_at: 2026-01-19T10:30:00Z
version: 1
---

# 需求文档: Docker 部署授权码生成系统

> **功能标识**: docker-deployment
> **复杂度**: standard
> **生成方式**: clarify
> **生成时间**: 2026-01-19

## 1. 概述

### 1.1 一句话描述
将授权码生成系统（Python API + Web UI）Docker 化，支持 Windows 开发环境和 Linux 生产环境的一键部署。

### 1.2 核心价值
- **环境一致性**：消除"在我机器上能跑"的问题，开发和生产环境完全一致
- **快速部署**：通过 Docker Compose 实现一键启动，无需手动安装依赖
- **跨平台支持**：同一套配置同时支持 Windows 和 Linux 环境
- **配置灵活性**：通过环境变量管理配置，无需修改代码

### 1.3 目标用户
- **主要用户**：开发人员（在 Windows 上开发和测试）
- **次要用户**：运维人员（在 Linux 服务器上部署生产环境）

---

## 2. 需求与用户故事

### 2.1 需求清单

| ID | 需求点 | 优先级 | 用户故事 |
|----|--------|--------|----------|
| R-001 | Docker 镜像构建 | P0 | As a 开发人员, I want 构建包含所有依赖的 Docker 镜像, so that 无需手动安装 Python 和依赖包 |
| R-002 | Docker Compose 编排 | P0 | As a 用户, I want 使用 docker-compose up 一键启动服务, so that 简化部署流程 |
| R-003 | 环境变量配置 | P0 | As a 运维人员, I want 通过环境变量配置数据库连接, so that 无需修改代码或配置文件 |
| R-004 | 跨平台支持 | P0 | As a 团队, I want 同一套 Docker 配置在 Windows 和 Linux 上都能运行, so that 减少维护成本 |
| R-005 | 日志输出 | P1 | As a 运维人员, I want 日志输出到控制台, so that 可以使用 docker logs 查看 |
| R-006 | 外部数据库连接 | P0 | As a 系统, I want 连接到外部 MySQL 数据库, so that 数据持久化和共享 |

### 2.2 验收标准

#### R-001: Docker 镜像构建
- **WHEN** 执行 `docker build` 命令, **THEN** 系统 **SHALL** 成功构建包含 Python 3.x、所有依赖包和应用代码的镜像
- **WHEN** 镜像构建完成, **THEN** 镜像大小 **SHOULD** 小于 500MB（使用精简基础镜像）
- **WHEN** 镜像启动, **THEN** Gunicorn 服务 **SHALL** 自动启动并监听 30111 端口

#### R-002: Docker Compose 编排
- **WHEN** 执行 `docker-compose up -d`, **THEN** 系统 **SHALL** 启动授权码 API 服务
- **WHEN** 服务启动完成, **THEN** 用户 **SHALL** 能够通过 `http://localhost:30111` 访问 Web UI
- **WHEN** 执行 `docker-compose down`, **THEN** 系统 **SHALL** 优雅停止所有服务

#### R-003: 环境变量配置
- **WHEN** 在 docker-compose.yml 中设置数据库环境变量, **THEN** 应用 **SHALL** 读取这些变量并连接数据库
- **WHEN** 环境变量未设置, **THEN** 应用 **SHALL** 使用 config.json 中的默认值（向后兼容）
- **WHEN** 环境变量和 config.json 同时存在, **THEN** 环境变量 **SHALL** 优先

#### R-004: 跨平台支持
- **WHEN** 在 Windows 上执行 `docker-compose up`, **THEN** 服务 **SHALL** 正常启动
- **WHEN** 在 Linux 上执行 `docker-compose up`, **THEN** 服务 **SHALL** 正常启动
- **WHEN** 在不同平台上运行, **THEN** 功能和性能 **SHALL** 保持一致

#### R-005: 日志输出
- **WHEN** 服务运行时, **THEN** 所有日志 **SHALL** 输出到标准输出（stdout）和标准错误（stderr）
- **WHEN** 执行 `docker logs <container>`, **THEN** 用户 **SHALL** 看到完整的应用日志

#### R-006: 外部数据库连接
- **WHEN** 容器启动, **THEN** 应用 **SHALL** 连接到配置的外部 MySQL 数据库（192.168.34.6:10001）
- **WHEN** 数据库连接失败, **THEN** 应用 **SHALL** 输出清晰的错误信息并退出
- **WHEN** 数据库连接成功, **THEN** 健康检查接口 `/api/health` **SHALL** 返回 200 状态码

---

## 3. 功能验收清单

| ID | 功能点 | 验收步骤 | 优先级 | 关联需求 | 通过 |
|----|--------|----------|--------|----------|------|
| F-001 | Dockerfile 创建 | 1. 创建 Dockerfile<br>2. 基于 python:3.11-slim<br>3. 安装 requirements_api.txt<br>4. 复制应用代码<br>5. 暴露 30111 端口<br>6. 设置启动命令 | P0 | R-001 | ☐ |
| F-002 | docker-compose.yml 创建 | 1. 定义 invitation-code-api 服务<br>2. 配置端口映射 30111:30111<br>3. 设置环境变量<br>4. 配置重启策略 | P0 | R-002 | ☐ |
| F-003 | 环境变量支持 | 1. 修改 app.py 读取环境变量<br>2. 支持 DB_HOST、DB_PORT、DB_NAME、DB_USER、DB_PASSWORD<br>3. 环境变量优先于 config.json | P0 | R-003 | ☐ |
| F-004 | .dockerignore 创建 | 1. 排除 __pycache__、*.pyc<br>2. 排除 .git、logs<br>3. 排除 config.json（敏感信息） | P1 | R-001 | ☐ |
| F-005 | Windows 环境测试 | 1. 在 Windows 上执行 docker-compose up<br>2. 访问 http://localhost:30111<br>3. 测试生成授权码功能 | P0 | R-004 | ☐ |
| F-006 | Linux 环境测试 | 1. 在 Linux 上执行 docker-compose up<br>2. 从外部访问 http://server-ip:30111<br>3. 测试生成授权码功能 | P0 | R-004 | ☐ |
| F-007 | 日志验证 | 1. 启动服务<br>2. 执行 docker logs invitation-code-api<br>3. 验证日志包含启动信息和请求日志 | P1 | R-005 | ☐ |
| F-008 | 数据库连接验证 | 1. 配置正确的数据库环境变量<br>2. 启动服务<br>3. 访问 /api/health<br>4. 验证返回 200 和数据库连接状态 | P0 | R-006 | ☐ |

---

## 4. 技术约束

### 4.1 技术栈
- **基础镜像**: `python:3.11-slim`（精简镜像，减小体积）
- **Web 服务器**: Gunicorn（已有配置 gunicorn_config.py）
- **容器编排**: Docker Compose v2.x
- **数据库**: 外部 MySQL 5.7+（不在容器内）

### 4.2 集成点
- **外部数据库**: 192.168.34.6:10001（clouditera_aigc 数据库）
- **端口映射**: 30111:30111（主机端口:容器端口）
- **网络模式**: bridge（默认）

### 4.3 环境变量清单
| 变量名 | 说明 | 默认值 | 必需 |
|--------|------|--------|------|
| DB_HOST | 数据库主机 | 192.168.34.6 | 是 |
| DB_PORT | 数据库端口 | 10001 | 是 |
| DB_NAME | 数据库名称 | clouditera_aigc | 是 |
| DB_USER | 数据库用户 | root | 是 |
| DB_PASSWORD | 数据库密码 | - | 是 |
| API_HOST | API 监听地址 | 0.0.0.0 | 否 |
| API_PORT | API 监听端口 | 30111 | 否 |
| API_DEBUG | 调试模式 | false | 否 |

### 4.4 性能要求
- 容器启动时间 < 10 秒
- 镜像大小 < 500MB
- 内存占用 < 512MB（正常运行）

---

## 5. 排除项

- ❌ **不 Docker 化数据库**：使用现有的外部 MySQL 数据库，不在容器内运行数据库
- ❌ **不使用 Kubernetes**：仅使用 Docker Compose，不涉及 K8s 编排
- ❌ **不实现 CI/CD**：仅提供 Docker 配置，不包含自动化构建和部署流水线
- ❌ **不修改业务逻辑**：仅进行 Docker 化改造，不改变现有功能
- ❌ **不实现多阶段构建优化**：首次实现使用简单的单阶段构建，后续可优化

---

## 6. 实现要点

### 6.1 Dockerfile 设计
```dockerfile
# 基础镜像
FROM python:3.11-slim

# 工作目录
WORKDIR /app

# 复制依赖文件并安装
COPY requirements_api.txt .
RUN pip install --no-cache-dir -r requirements_api.txt

# 复制应用代码
COPY . .

# 暴露端口
EXPOSE 30111

# 启动命令
CMD ["gunicorn", "-c", "gunicorn_config.py", "app:app"]
```

### 6.2 docker-compose.yml 设计
```yaml
version: '3.8'

services:
  invitation-code-api:
    build: .
    container_name: invitation-code-api
    ports:
      - "30111:30111"
    environment:
      - DB_HOST=192.168.34.6
      - DB_PORT=10001
      - DB_NAME=clouditera_aigc
      - DB_USER=root
      - DB_PASSWORD=${DB_PASSWORD}  # 从 .env 文件读取
      - API_HOST=0.0.0.0
      - API_PORT=30111
      - API_DEBUG=false
    restart: unless-stopped
```

### 6.3 环境变量读取逻辑
```python
import os
import json

# 优先读取环境变量，其次读取 config.json
def get_config():
    config = {}

    # 尝试读取 config.json
    if os.path.exists('config.json'):
        with open('config.json') as f:
            config = json.load(f)

    # 环境变量覆盖
    config['database'] = {
        'host': os.getenv('DB_HOST', config.get('database', {}).get('host', 'localhost')),
        'port': int(os.getenv('DB_PORT', config.get('database', {}).get('port', 3306))),
        'database': os.getenv('DB_NAME', config.get('database', {}).get('database', 'test')),
        'user': os.getenv('DB_USER', config.get('database', {}).get('user', 'root')),
        'password': os.getenv('DB_PASSWORD', config.get('database', {}).get('password', '')),
    }

    return config
```

---

## 7. 文档更新

需要更新以下文档：
- **README.md**: 添加 Docker 部署章节
- **DEPLOY_LINUX.md**: 添加 Docker 部署说明
- 创建 **DEPLOY_DOCKER.md**: Docker 部署完整指南

---

## 8. 下一步

✅ 需求澄清完成！

**推荐流程**：
1. 阅读本文档的"概述"章节（1.1-1.2）确认需求方向
2. 查看"功能验收清单"了解具体实现内容
3. 在新会话中执行：
   ```bash
   /dev:spec-dev docker-deployment --skip-requirements
   ```

**或者直接开始实施**：
如果你认为需求已经足够清晰，也可以直接告诉我开始实施，我会：
1. 创建 Dockerfile
2. 创建 docker-compose.yml
3. 修改 app.py 支持环境变量
4. 创建 .dockerignore
5. 更新文档
6. 提供测试步骤

---

**生成时间**: 2026-01-19
**文档版本**: v1
**预计工作量**: 2-4 小时（包括测试）
