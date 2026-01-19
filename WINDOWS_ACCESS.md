# Windows客户端访问Linux服务器指南

## 概述

本系统已配置为支持从Windows客户端通过IP地址访问部署在Linux服务器上的服务。

## 配置说明

### 服务器端配置（Linux）

1. **服务监听配置**
   - 服务已配置为监听 `0.0.0.0:30111`
   - 这意味着服务会监听所有网络接口，允许外部访问

2. **防火墙配置**

   确保Linux服务器防火墙开放30111端口：

   **Ubuntu/Debian (ufw)**
   ```bash
   sudo ufw allow 30111/tcp
   sudo ufw reload
   ```

   **CentOS/RHEL (firewalld)**
   ```bash
   sudo firewall-cmd --permanent --add-port=30111/tcp
   sudo firewall-cmd --reload
   ```

   **检查端口是否开放**
   ```bash
   # Ubuntu/Debian
   sudo ufw status | grep 30111
   
   # CentOS/RHEL
   sudo firewall-cmd --list-ports | grep 30111
   
   # 通用检查
   netstat -tlnp | grep 30111
   ```

### 客户端访问（Windows）

1. **获取Linux服务器IP地址**

   在Linux服务器上运行：
   ```bash
   hostname -I
   # 或
   ip addr show
   ```

2. **从Windows浏览器访问**

   打开浏览器，访问：
   ```
   http://linux-server-ip:30111
   ```

   例如，如果Linux服务器IP是 `192.168.1.100`：
   ```
   http://192.168.1.100:30111
   ```

3. **自动API连接**

   - UI界面会自动检测当前访问的IP和端口
   - API请求会自动使用相同的IP和端口
   - 无需手动配置API地址

## 访问验证

### 1. 检查服务是否运行

在Linux服务器上：
```bash
# 检查进程
ps aux | grep gunicorn
# 或
ps aux | grep python | grep invitation_code

# 检查端口监听
netstat -tlnp | grep 30111
# 或
ss -tlnp | grep 30111
```

### 2. 测试连接

在Windows上使用PowerShell或CMD：
```powershell
# 测试端口连通性
Test-NetConnection -ComputerName linux-server-ip -Port 30111

# 或使用curl（如果已安装）
curl http://linux-server-ip:30111/api/health
```

### 3. 浏览器访问测试

1. 在Windows浏览器中访问：`http://linux-server-ip:30111`
2. 应该能看到授权码生成界面
3. 打开浏览器开发者工具（F12），查看Console标签
4. 应该能看到 "API地址: http://linux-server-ip:30111/api"

## 常见问题

### 问题1: 无法访问服务

**可能原因：**
- 防火墙未开放端口
- 服务未启动
- IP地址不正确
- 网络不通

**解决方法：**
1. 检查服务状态：`ps aux | grep gunicorn`
2. 检查端口监听：`netstat -tlnp | grep 30111`
3. 检查防火墙：`sudo ufw status` 或 `sudo firewall-cmd --list-all`
4. 测试网络连通性：`ping linux-server-ip`

### 问题2: API请求失败

**可能原因：**
- CORS配置问题
- API地址不正确

**解决方法：**
1. 检查浏览器控制台错误信息
2. 确认API地址是否正确（查看Console中的"API地址"）
3. 检查服务器日志：`tail -f logs/error.log`

### 问题3: 连接超时

**可能原因：**
- 防火墙阻止
- 服务未监听0.0.0.0

**解决方法：**
1. 确认 `config.json` 中 `host` 设置为 `"0.0.0.0"`
2. 检查防火墙规则
3. 检查服务器网络配置

## 安全建议

1. **生产环境建议：**
   - 使用Nginx反向代理
   - 配置SSL/TLS证书（HTTPS）
   - 限制防火墙访问来源IP

2. **内网环境：**
   - 确保Windows和Linux在同一网络
   - 检查网络路由配置

## 示例配置

### Linux服务器信息
- IP地址: `192.168.1.100`
- 端口: `30111`

### Windows访问地址
- UI界面: `http://192.168.1.100:30111`
- API接口: `http://192.168.1.100:30111/api/*`

### 配置文件示例 (config.json)
```json
{
    "api": {
        "host": "0.0.0.0",  // 监听所有网络接口
        "port": 30111,      // 服务端口
        "debug": false      // 生产环境建议设为false
    }
}
```

## 快速检查清单

- [ ] Linux服务器服务已启动
- [ ] 服务监听在 `0.0.0.0:30111`
- [ ] 防火墙已开放30111端口
- [ ] Windows可以ping通Linux服务器IP
- [ ] Windows可以访问 `http://linux-server-ip:30111`
- [ ] 浏览器控制台显示正确的API地址
- [ ] API请求可以正常响应

