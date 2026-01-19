# Docker 部署指南

本指南介绍如何使用 Docker 部署授权码生成系统。

## 前置要求

- Docker 20.10+
- Docker Compose 2.0+

### 安装 Docker

**Windows**:
- 下载并安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)

**Linux**:
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## 快速开始

### 1. 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑 .env 文件
# Windows: notepad .env
# Linux: nano .env
```

编辑 `.env` 文件，设置数据库密码：

```bash
DB_HOST=192.168.34.6
DB_PORT=10001
DB_NAME=clouditera_aigc
DB_USER=root
DB_PASSWORD=your_actual_password  # 修改为实际密码
```

### 2. 启动服务

```bash
# 后台启动
docker-compose up -d

# 查看启动日志
docker-compose logs -f
```

### 3. 验证服务

访问 http://localhost:30111

- UI 界面: http://localhost:30111/
- 健康检查: http://localhost:30111/api/health

### 4. 查看日志

```bash
# 实时查看日志
docker logs -f invitation-code-api

# 查看最近 100 行日志
docker logs --tail 100 invitation-code-api
```

## 常用命令

### 服务管理

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看服务状态
docker-compose ps

# 查看资源使用
docker stats invitation-code-api
```

### 镜像管理

```bash
# 重新构建镜像
docker-compose build --no-cache

# 查看镜像
docker images | grep invitation-code

# 删除旧镜像
docker image prune -f
```

### 容器管理

```bash
# 进入容器
docker exec -it invitation-code-api bash

# 查看容器内环境变量
docker exec invitation-code-api env

# 查看容器内进程
docker exec invitation-code-api ps aux
```

## 配置说明

### 环境变量

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

### 端口映射

- `30111:30111` - Web UI 和 API 服务

### 网络配置

服务使用 bridge 网络模式，可以访问宿主机网络。

## 故障排查

### 容器无法启动

**检查日志**:
```bash
docker-compose logs
```

**常见原因**:
1. 端口 30111 被占用
   ```bash
   # Windows
   netstat -ano | findstr 30111
   
   # Linux
   lsof -i :30111
   ```

2. 环境变量配置错误
   ```bash
   docker exec invitation-code-api env | grep DB_
   ```

### 无法连接数据库

**测试数据库连接**:
```bash
docker exec invitation-code-api python -c "
import mysql.connector
try:
    conn = mysql.connector.connect(
        host='192.168.34.6',
        port=10001,
        user='root',
        password='your_password',
        database='clouditera_aigc'
    )
    print('✅ 数据库连接成功')
    conn.close()
except Exception as e:
    print(f'❌ 数据库连接失败: {e}')
"
```

**检查网络连通性**:
```bash
# 从容器内 ping 数据库主机
docker exec invitation-code-api ping -c 3 192.168.34.6

# 测试端口连通性
docker exec invitation-code-api nc -zv 192.168.34.6 10001
```

### 服务响应慢

**查看资源使用**:
```bash
docker stats invitation-code-api
```

**查看容器日志**:
```bash
docker logs --tail 100 invitation-code-api
```

### 更新代码后重新部署

```bash
# 停止并删除容器
docker-compose down

# 重新构建镜像
docker-compose build --no-cache

# 启动服务
docker-compose up -d

# 查看日志确认启动成功
docker logs -f invitation-code-api
```

## 生产环境建议

### 1. 使用外部配置

不要将敏感信息（如数据库密码）提交到 Git。使用 `.env` 文件管理：

```bash
# .env 文件应该在 .gitignore 中
echo ".env" >> .gitignore
```

### 2. 健康检查

服务已配置健康检查，可以通过以下命令查看：

```bash
docker inspect --format='{{json .State.Health}}' invitation-code-api | jq
```

### 3. 日志管理

配置日志轮转，避免日志文件过大：

```yaml
# 在 docker-compose.yml 中添加
services:
  invitation-code-api:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### 4. 资源限制

限制容器资源使用：

```yaml
# 在 docker-compose.yml 中添加
services:
  invitation-code-api:
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

### 5. 备份策略

定期备份数据库（数据库在外部，不在容器内）。

## 从传统部署迁移到 Docker

### 1. 备份现有配置

```bash
cp config.json config.json.backup
```

### 2. 创建 .env 文件

从 `config.json` 提取配置到 `.env`：

```bash
# 手动创建 .env 文件，填入数据库配置
cat > .env << EOF
DB_HOST=192.168.34.6
DB_PORT=10001
DB_NAME=clouditera_aigc
DB_USER=root
DB_PASSWORD=your_password
