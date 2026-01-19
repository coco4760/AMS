# Linux 服务器部署指南

## 部署概述

本指南将帮助您将授权码生成系统部署到Linux服务器上，使其可以通过IP地址访问。

## 系统要求

- Linux操作系统（Ubuntu 20.04+, CentOS 7+, Debian 10+等）
- Python 3.7+
- MySQL数据库（已安装并运行）
- 网络访问权限

### 系统依赖

**Ubuntu/Debian系统需要安装：**
```bash
sudo apt-get update
sudo apt-get install -y python3-venv python3-pip
```

**CentOS/RHEL系统需要安装：**
```bash
sudo yum install -y python3-venv python3-pip
```

**注意：** 部署脚本会自动检测并尝试安装缺失的依赖，但建议提前安装。

## 部署步骤

### 1. 上传项目文件

将项目文件上传到Linux服务器，例如：
```bash
# 使用scp上传
scp -r SecCortex/ user@your-server-ip:/opt/invitation-code/

# 或使用git克隆
git clone <repository-url> /opt/invitation-code
```

### 2. 运行部署脚本

```bash
cd /opt/invitation-code
chmod +x deploy.sh
./deploy.sh
```

部署脚本会自动：
- 检查系统环境
- 创建Python虚拟环境
- 安装依赖包
- 创建必要目录
- 生成启动脚本

### 3. 配置数据库信息

编辑配置文件：
```bash
nano config.json
```

修改数据库连接信息：
```json
{
    "database": {
        "host": "192.168.34.6",
        "port": 10001,
        "database": "clouditera_aigc",
        "user": "root",
        "password": "your_password",
        ...
    },
    "api": {
        "host": "0.0.0.0",  // 监听所有网络接口
        "port": 5000,
        "debug": false      // 生产环境建议设为false
    }
}
```

### 4. 启动API服务

**方式一：直接启动（开发/测试）**
```bash
./start.sh
```

**方式二：后台运行**
```bash
nohup ./start.sh > logs/startup.log 2>&1 &
```

**方式三：使用systemd服务（推荐生产环境）**
```bash
# 创建systemd服务
sudo ./systemd_service.sh

# 启动服务
sudo systemctl start invitation-code-api

# 设置开机自启
sudo systemctl enable invitation-code-api

# 查看服务状态
sudo systemctl status invitation-code-api
```

### 5. 启动服务（UI和API已集成）

```bash
# 启动集成服务（UI和API在同一服务中）
./start.sh
```

服务启动后，可以通过以下地址访问：
- 本地: `http://localhost:30111`
- 网络: `http://your-server-ip:30111`
- UI界面: 访问根路径 `/`
- API接口: 访问 `/api/*` 路径

### 6. 配置防火墙

**重要**: 如果要从Windows客户端访问Linux服务器，必须开放30111端口。

**Ubuntu/Debian (ufw)**
```bash
sudo ufw allow 30111/tcp  # 集成服务端口
sudo ufw reload
```

**CentOS/RHEL (firewalld)**
```bash
sudo firewall-cmd --permanent --add-port=30111/tcp
sudo firewall-cmd --reload
```

**验证端口是否开放**
```bash
# Ubuntu/Debian
sudo ufw status | grep 30111

# CentOS/RHEL
sudo firewall-cmd --list-ports | grep 30111
```

## 服务管理

### 手动管理

```bash
# 启动服务
./start.sh

# 停止服务
./stop.sh

# 重启服务
./restart.sh

# 查看日志
tail -f logs/error.log
tail -f logs/access.log
```

### systemd服务管理

```bash
# 启动
sudo systemctl start invitation-code-api

# 停止
sudo systemctl stop invitation-code-api

# 重启
sudo systemctl restart invitation-code-api

# 查看状态
sudo systemctl status invitation-code-api

# 查看日志
sudo journalctl -u invitation-code-api -f
```

## 使用Nginx反向代理（可选）

### 安装Nginx

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nginx

# CentOS/RHEL
sudo yum install nginx
```

### 配置Nginx

创建配置文件 `/etc/nginx/sites-available/invitation-code`：

```nginx
server {
    listen 80;
    server_name your-domain.com;  # 或使用IP地址

    # 集成服务（API + UI）
    location / {
        proxy_pass http://127.0.0.1:30111;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

启用配置：
```bash
sudo ln -s /etc/nginx/sites-available/invitation-code /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 访问地址

部署完成后，可以通过以下方式访问：

### 从Windows客户端访问

1. **获取Linux服务器IP地址**
   ```bash
   hostname -I
   ```

2. **在Windows浏览器中访问**
   ```
   http://linux-server-ip:30111
   ```
   例如：`http://192.168.1.100:30111`

3. **访问路径**
   - **UI界面**: `http://linux-server-ip:30111/` (根路径)
   - **API接口**: `http://linux-server-ip:30111/api/*`

**注意**: 
- 确保防火墙已开放30111端口
- 确保Windows和Linux在同一网络或网络互通
- UI会自动检测服务器IP并连接API，无需手动配置

### 使用Nginx反向代理（可选）

- **访问**: `http://your-server-ip` 或 `http://your-domain.com`

详细说明请参考 [WINDOWS_ACCESS.md](WINDOWS_ACCESS.md)

## 故障排查

详细故障排查指南请参考 [DEPLOY_TROUBLESHOOTING.md](DEPLOY_TROUBLESHOOTING.md)

### 问题1: 虚拟环境创建失败

如果遇到 `ensurepip is not available` 错误：

**Ubuntu/Debian：**
```bash
sudo apt-get install -y python3-venv python3-pip
```

**CentOS/RHEL：**
```bash
sudo yum install -y python3-venv python3-pip
```

然后重新运行 `./deploy.sh`

### 问题2: 无法访问服务

1. 检查服务是否运行：
   ```bash
   ps aux | grep gunicorn
   ```

2. 检查端口是否监听：
   ```bash
   netstat -tlnp | grep 5000
   ```

3. 检查防火墙规则：
   ```bash
   sudo ufw status
   # 或
   sudo firewall-cmd --list-all
   ```

### 问题2: 数据库连接失败

1. 检查数据库服务是否运行
2. 验证配置文件中的数据库信息
3. 检查网络连接和防火墙规则
4. 查看错误日志：`tail -f logs/error.log`

### 问题3: 权限错误

```bash
# 确保文件权限正确
chmod +x start.sh stop.sh restart.sh start_all.sh stop_all.sh deploy.sh
chmod 644 config.json
chmod -R 755 logs/
```

## 性能优化

### 调整Gunicorn配置

编辑 `gunicorn_config.py`：
```python
# 根据服务器CPU核心数调整
workers = multiprocessing.cpu_count() * 2 + 1

# 调整超时时间
timeout = 60
```

### 使用进程管理器

可以使用supervisor管理服务：
```bash
sudo apt install supervisor

# 创建配置文件 /etc/supervisor/conf.d/invitation-code.conf
```

## 安全建议

1. **修改默认密码**：确保配置文件中的数据库密码安全
2. **使用HTTPS**：生产环境建议配置SSL证书
3. **限制访问**：使用防火墙限制访问来源
4. **定期更新**：保持依赖包和系统更新
5. **日志监控**：定期检查日志文件

## 更新部署

```bash
# 1. 停止服务
./stop.sh

# 2. 更新代码
git pull  # 或上传新文件

# 3. 更新依赖（如有变化）
source venv/bin/activate
pip install -r requirements_api.txt

# 4. 重启服务
./start.sh
```

## 备份

定期备份：
- 配置文件：`config.json`
- 数据库：定期备份MySQL数据库
- 日志文件：`logs/` 目录

## 技术支持

如有问题，请查看：
- 服务日志：`logs/error.log`, `logs/access.log`
- systemd日志：`sudo journalctl -u invitation-code-api`
- 数据库连接状态

