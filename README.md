# 授权码生成系统

完整的授权码生成和管理系统，支持Windows和Linux部署。

## 功能特性

- ✅ 自动生成唯一的6位授权码
- ✅ 可视化配置授权码信息
- ✅ 数据库自动保存
- ✅ 支持Windows和Linux部署
- ✅ 可通过IP地址访问

## 快速开始

### Windows 环境

1. **安装依赖**
   ```bash
   install_dependencies.bat
   ```

2. **启动服务**
   ```bash
   start.bat
   ```

### Linux 环境

1. **部署系统**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

2. **配置数据库**
   ```bash
   nano config.json  # 编辑数据库信息
   ```

3. **启动服务**
   ```bash
   # 启动集成服务（UI和API已集成）
   ./start.sh
   ```

## 项目结构

```
SecCortex/
├── invitation_code_api.py      # API服务主文件
├── app.py                      # 生产环境入口
├── invitation_code_generator.html  # 授权码生成页面
├── invitation_code_manager.html   # 授权码管理页面
├── config.json                 # 配置文件（需创建）
├── config.json.example         # 配置模板
├── requirements_api.txt         # Python依赖
├── gunicorn_config.py          # Gunicorn配置
├── deploy.sh                   # Linux部署脚本
├── start.sh                    # 启动脚本（Linux，由deploy.sh生成）
├── stop.sh                     # 停止脚本（Linux，由deploy.sh生成）
├── start_all.sh                # 一键启动（Linux）
├── stop_all.sh                 # 停止服务（Linux）
├── systemd_service.sh          # systemd服务配置（可选）
├── start.bat                   # Windows启动脚本
├── install_dependencies.bat    # Windows依赖安装脚本
├── package_for_linux.bat       # Windows打包脚本
├── README.md                   # 本文件
├── DEPLOY_LINUX.md            # Linux部署指南
├── WINDOWS_ACCESS.md           # Windows访问Linux服务指南
└── DEPLOY_TROUBLESHOOTING.md   # 故障排查指南
```

## 配置文件

首次使用需要创建 `config.json`（可从 `config.json.example` 复制）：

```json
{
    "database": {
        "host": "192.168.34.6",
        "port": 10001,
        "database": "clouditera_aigc",
        "user": "root",
        "password": "your_password",
        "charset": "utf8mb4",
        "collation": "utf8mb4_unicode_ci"
    },
    "api": {
        "host": "0.0.0.0",
        "port": 30111,
        "debug": false
    },
    "default_values": {
        "expired": "2027-03-01 10:16:00",
        "person_knowledge_count": 3,
        "group_knowledge_count": 10,
        "document_count": 100,
        "created_by": "admin"
    }
}
```

## 访问地址

### Windows本地开发
- 集成服务: http://localhost:30111
  - UI界面: http://localhost:30111/ (根路径)
  - API接口: http://localhost:30111/api/*

### Linux服务器部署（从Windows访问）

1. **获取Linux服务器IP**
   ```bash
   # 在Linux服务器上运行
   hostname -I
   ```

2. **在Windows浏览器中访问**
   ```
   http://linux-server-ip:30111
   ```
   例如：`http://192.168.1.100:30111`

3. **访问路径**
   - UI界面: `http://linux-server-ip:30111/` (根路径)
   - API接口: `http://linux-server-ip:30111/api/*`

**重要提示**:
- ✅ 服务已配置为监听 `0.0.0.0:30111`，支持外部访问
- ✅ UI会自动检测服务器IP并连接API
- ⚠️ 确保Linux防火墙已开放30111端口
- ⚠️ 确保Windows和Linux网络互通

详细说明请参考 [WINDOWS_ACCESS.md](WINDOWS_ACCESS.md)

## API接口

- `GET /api/health` - 健康检查
- `GET /api/generate-code` - 生成授权码
- `POST /api/check-code` - 检查授权码
- `POST /api/create-invitation` - 创建授权码

## 部署文档

- **Linux 部署**: 参考 [DEPLOY_LINUX.md](DEPLOY_LINUX.md)
- **Windows 访问 Linux 服务**: 参考 [WINDOWS_ACCESS.md](WINDOWS_ACCESS.md)
- **故障排查**: 参考 [DEPLOY_TROUBLESHOOTING.md](DEPLOY_TROUBLESHOOTING.md)

## 故障排查

### 无法连接数据库
1. 检查数据库服务是否运行
2. 验证 `config.json` 中的数据库信息
3. 检查网络和防火墙

### 无法访问服务
1. 检查服务是否启动：`ps aux | grep gunicorn`
2. 检查端口是否监听：`netstat -tlnp | grep 30111`
3. 检查防火墙规则

### 查看日志
```bash
# Linux
tail -f logs/error.log
tail -f logs/access.log

# Windows
# 查看API服务窗口的输出
```

## 许可证

内部使用

