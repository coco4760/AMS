# 使用官方 Python 精简镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# 复制依赖文件
COPY requirements_api.txt .

# 安装依赖
RUN pip install --no-cache-dir -r requirements_api.txt

# 复制应用代码
COPY app.py .
COPY invitation_code_api.py .
COPY gunicorn_config.py .
COPY invitation_code_generator.html .
COPY invitation_code_manager.html .

# 创建日志目录
RUN mkdir -p logs

# 暴露端口
EXPOSE 30111

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:30111/api/health')" || exit 1

# 启动命令
CMD ["gunicorn", "-c", "gunicorn_config.py", "app:app"]
