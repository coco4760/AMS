# 服务启动顺序说明

## 概述

本项目的服务分为几个层次，需要按照特定顺序启动以确保依赖关系正确。

## 启动顺序

### 1. 存储服务层 (Storage)
**脚本**: `./scripts/start-storage-services.sh start`

**说明**: 存储相关服务，需要首先启动以提供数据存储基础。

### 2. 基础服务层 (Support Services)
**脚本**: `./scripts/start-support-services.sh start`

**服务列表**:
- `nacos` - 配置中心
- `rabbitmq` - 消息队列
- `kong` - API网关
- `iam` - 身份认证
- `filems` - 文件管理
- `collabnet` - 协作网络
- `mineru` - 核心服务
- `node_manager` - 节点管理
- `mineru_cpu` - CPU计算服务
- `rag_service` - RAG服务
- `ragflow` - RAG流程服务

**说明**: 这些是基础支撑服务，依赖存储服务。

### 3. 插件服务层 (Plugins)
**脚本**: `./scripts/start-plugins-services.sh start`

**说明**: 各种插件服务，依赖基础服务。

### 4. AI Brain 服务层
**脚本**: `./scripts/start-ai-brain.sh start`

**服务列表**:
- `api` - AI智能API服务
- `worker` - 后台工作进程
- `web` - Web前端界面
- `sandbox` - 代码执行沙箱
- `plugin_daemon` - 插件守护进程
- `nginx` - 反向代理

**说明**: AI Brain 服务依赖基础服务和插件服务，应在插件服务启动完成后启动。

### 5. 业务服务层 (Services)
**脚本**: `./scripts/start-services.sh start`

**服务列表**:
- `auth` - 认证服务
- `wuji` - 无极服务
- `sast` - SAST服务
- `web` - Web前端服务

**说明**: 业务服务依赖基础服务、AI Brain服务和插件服务。

## 推荐启动流程

### 方式一：分步启动（推荐用于开发和调试）

```bash
# 1. 启动存储服务
./scripts/start-storage-services.sh start

# 2. 等待存储服务完全启动（约1-2分钟）
echo "等待存储服务启动完成..."

# 3. 启动基础服务
./scripts/start-support-services.sh start

# 4. 等待基础服务完全启动（约2-3分钟）
echo "等待基础服务启动完成..."

# 5. 启动插件服务
./scripts/start-plugins-services.sh start

# 6. 等待插件服务启动（约1-2分钟）
echo "等待插件服务启动完成..."

# 7. 启动AI Brain服务
./scripts/start-ai-brain.sh start

# 8. 等待AI Brain服务启动（约1-2分钟）
echo "等待AI Brain服务启动完成..."

# 9. 启动业务服务
./scripts/start-services.sh start
```

### 方式二：使用自动部署脚本

```bash
# 使用自动部署脚本（会按顺序启动所有服务）
./scripts/auto-deploy.sh
```

## 启动检查

### 检查基础服务状态
```bash
./scripts/start-support-services.sh status
```

### 检查AI Brain服务状态
```bash
./scripts/start-ai-brain.sh status
./scripts/check-ai-brain-status.sh
```

### 检查业务服务状态
```bash
./scripts/start-services.sh status
```

## 停止顺序

停止服务时应按照相反顺序：

```bash
# 1. 停止业务服务
./scripts/start-services.sh stop

# 2. 停止AI Brain服务
./scripts/start-ai-brain.sh stop

# 3. 停止插件服务
./scripts/start-plugins-services.sh stop

# 4. 停止基础服务
./scripts/start-support-services.sh stop

# 5. 停止存储服务
./scripts/start-storage-services.sh stop
```

## 重启服务

### 重启单个服务组
```bash
# 重启基础服务
./scripts/start-support-services.sh restart

# 重启AI Brain服务
./scripts/start-ai-brain.sh restart

# 重启业务服务
./scripts/start-services.sh restart
```

### 重启所有服务
```bash
# 使用自动部署脚本重启
./scripts/auto-deploy.sh restart
```

## 故障排除

### 服务启动失败
1. 检查依赖服务是否已启动
2. 查看错误日志
3. 检查端口占用
4. 检查环境变量配置

### 依赖问题
- 基础服务依赖存储服务提供的数据存储
- 插件服务依赖基础服务
- AI Brain 服务需要 `nacos`、`rabbitmq`、`kong` 等基础服务和插件服务
- 业务服务依赖基础服务、插件服务和AI Brain服务
- 确保按顺序启动

### 端口冲突
```bash
# 检查端口占用
netstat -tuln | grep :15001
netstat -tuln | grep :10081
netstat -tuln | grep :8000
```

## 性能优化建议

1. **并行启动**: 同一层级的服务可以并行启动
2. **健康检查**: 等待服务健康检查通过后再启动下一层
3. **资源监控**: 监控系统资源使用情况
4. **日志管理**: 定期清理日志文件

## 注意事项

1. **环境变量**: 确保所有必要的环境变量已设置
2. **网络配置**: 检查网络配置和防火墙设置
3. **磁盘空间**: 确保有足够的磁盘空间
4. **权限设置**: 检查文件和目录权限
5. **依赖版本**: 确保Docker和Docker Compose版本兼容
