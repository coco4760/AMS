# 部署故障排查指南

## 常见问题及解决方案

### 问题1: 虚拟环境创建失败

**错误信息：**
```
The virtual environment was not created successfully because ensurepip is not available.
On Debian/Ubuntu systems, you need to install the python3-venv package
```

**解决方案：**

**Ubuntu/Debian系统：**
```bash
sudo apt-get update
sudo apt-get install -y python3-venv python3-pip
```

**CentOS/RHEL系统：**
```bash
sudo yum install -y python3-venv python3-pip
```

**然后重新运行部署脚本：**
```bash
./deploy.sh
```

### 问题2: 权限不足

**错误信息：**
```
Permission denied
```

**解决方案：**
```bash
# 确保脚本有执行权限
chmod +x deploy.sh

# 如果使用root用户，确保有足够权限
# 或者使用sudo运行
sudo ./deploy.sh
```

### 问题3: Python版本过低

**错误信息：**
```
Python 3.7+ required
```

**解决方案：**

**检查Python版本：**
```bash
python3 --version
```

**如果版本低于3.7，需要升级：**

**Ubuntu/Debian：**
```bash
sudo apt-get update
sudo apt-get install -y python3.10 python3.10-venv python3.10-pip
```

**CentOS/RHEL：**
```bash
sudo yum install -y python3.10 python3.10-venv python3.10-pip
```

### 问题4: pip安装依赖失败

**错误信息：**
```
ERROR: Could not install packages
```

**解决方案：**

1. **升级pip：**
   ```bash
   python3 -m pip install --upgrade pip
   ```

2. **使用国内镜像源（如果网络问题）：**
   ```bash
   pip install -r requirements_api.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
   ```

3. **检查网络连接：**
   ```bash
   ping pypi.org
   ```

### 问题5: 数据库连接失败

**错误信息：**
```
数据库连接失败
```

**解决方案：**

1. **检查数据库服务是否运行：**
   ```bash
   systemctl status mysql
   # 或
   systemctl status mariadb
   ```

2. **验证配置文件：**
   ```bash
   cat config.json
   ```
   确保数据库信息正确

3. **测试数据库连接：**
   ```bash
   mysql -h 192.168.34.6 -P 10001 -u root -p
   ```

4. **检查防火墙：**
   ```bash
   # 确保数据库端口10001已开放
   sudo ufw allow 10001/tcp
   ```

### 问题6: 端口被占用

**错误信息：**
```
Address already in use
```

**解决方案：**

1. **检查端口占用：**
   ```bash
   netstat -tlnp | grep 30111
   # 或
   ss -tlnp | grep 30111
   ```

2. **停止占用端口的进程：**
   ```bash
   # 找到进程ID后
   kill -9 <PID>
   ```

3. **或修改配置文件中的端口：**
   ```bash
   nano config.json
   # 修改 "port": 30111 为其他端口
   ```

### 问题7: 防火墙阻止访问

**症状：**
- 服务已启动但无法从外部访问

**解决方案：**

**Ubuntu/Debian (ufw)：**
```bash
sudo ufw allow 30111/tcp
sudo ufw reload
sudo ufw status
```

**CentOS/RHEL (firewalld)：**
```bash
sudo firewall-cmd --permanent --add-port=30111/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports
```

**iptables：**
```bash
sudo iptables -A INPUT -p tcp --dport 30111 -j ACCEPT
sudo iptables-save
```

### 问题8: SELinux阻止

**症状：**
- 服务无法启动或无法访问

**解决方案：**

**临时禁用（测试用）：**
```bash
sudo setenforce 0
```

**永久配置（生产环境）：**
```bash
sudo vi /etc/selinux/config
# 设置 SELINUX=permissive 或 SELINUX=disabled
sudo reboot
```

### 问题9: 虚拟环境激活失败

**错误信息：**
```
source: command not found
```

**解决方案：**

**使用bash运行脚本：**
```bash
bash deploy.sh
# 而不是
sh deploy.sh
```

**或手动激活虚拟环境：**
```bash
source venv/bin/activate
```

### 问题10: Gunicorn未安装

**错误信息：**
```
command not found: gunicorn
```

**解决方案：**

```bash
source venv/bin/activate
pip install gunicorn
```

## 快速诊断命令

```bash
# 检查Python版本
python3 --version

# 检查pip
pip3 --version

# 检查虚拟环境
python3 -m venv --help

# 检查端口
netstat -tlnp | grep 30111

# 检查服务进程
ps aux | grep gunicorn

# 查看日志
tail -f logs/error.log
tail -f logs/access.log

# 测试API
curl http://localhost:30111/api/health
```

## 完整重新部署

如果遇到无法解决的问题，可以完全重新部署：

```bash
# 1. 停止服务
./stop.sh

# 2. 删除虚拟环境
rm -rf venv

# 3. 删除日志
rm -rf logs/*

# 4. 重新运行部署
./deploy.sh

# 5. 启动服务
./start.sh
```

## 获取帮助

如果以上方法都无法解决问题，请提供以下信息：

1. 操作系统版本：`cat /etc/os-release`
2. Python版本：`python3 --version`
3. 错误日志：`cat logs/error.log`
4. 部署脚本输出：完整的 `./deploy.sh` 输出

