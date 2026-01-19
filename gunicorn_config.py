# Gunicorn 配置文件
# 用于生产环境部署

import multiprocessing
import os

# 服务器socket
bind = "0.0.0.0:30111"
backlog = 2048

# Worker进程
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
timeout = 30
keepalive = 2

# 日志
accesslog = "logs/access.log"
errorlog = "logs/error.log"
loglevel = "info"
access_log_format = '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'

# 进程命名
proc_name = "invitation_code_api"

# 服务器机制
daemon = True  # 后台运行
pidfile = "logs/gunicorn.pid"
umask = 0
user = None
group = None
tmp_upload_dir = None

# SSL (如果需要)
# keyfile = None
# certfile = None

