# CortexRAG - 检索增强生成服务

## 📖 项目简介

CortexRAG 是基于 **FastAPI** 和 **LlamaIndex** 构建的检索增强生成（Retrieval-Augmented Generation, RAG）服务，为 SecCortex 平台提供完整的知识库管理、文档管理和语义检索功能。通过向量数据库和语义搜索技术，实现智能文档检索和知识问答。

## ✨ 功能特性

### 📚 知识库管理
- **知识库创建**：支持创建多个独立的知识库
- **知识库配置**：自定义嵌入模型、分块大小、重叠参数
- **知识库检索**：基于语义相似度的智能检索
- **知识库统计**：文档数量、更新状态等统计信息

### 📄 文档管理
- **多格式支持**：支持 PDF、Word、Excel、PPT、TXT、Markdown 等格式
- **文档上传**：支持单文件和多文件批量上传
- **文档解析**：自动解析文档内容并提取文本
- **文档分块**：智能文档分块，支持自定义分块策略
- **文档状态跟踪**：实时跟踪文档处理状态（解析中、向量化中、完成、失败）

### 🔍 语义检索
- **向量化存储**：使用嵌入模型将文档转换为向量
- **相似度搜索**：基于向量相似度的语义检索
- **混合检索**：支持向量检索和关键词检索的混合模式
- **结果排序**：智能排序检索结果，提供最相关的文档片段

### ⚙️ 技术架构
- **FastAPI 框架**：高性能异步 Web 框架
- **LlamaIndex**：强大的 RAG 框架，支持多种检索策略
- **Celery 异步任务**：文档解析、向量化等耗时任务异步处理
- **向量数据库**：PostgreSQL (pgvector) + Qdrant 双向量存储
- **任务队列**：Redis 作为 Celery 消息代理

## 🏗️ 架构设计

```
┌─────────────────────────────────────────────────────────┐
│                     Frontend (8082)                       │
│              Web UI for Knowledge Management              │
└──────────────────────┬────────────────────────────────────┘
                       │
┌──────────────────────▼────────────────────────────────────┐
│              Backend API (8081)                           │
│         FastAPI + LlamaIndex RAG Engine                   │
└──────┬──────────────┬──────────────┬──────────────────────┘
       │              │              │
   ┌───▼───┐      ┌───▼───┐      ┌───▼────┐
   │Redis  │      │Postgres│      │Qdrant  │
   │Queue  │      │+pgvector│     │Vector  │
   └───┬───┘      └───┬───┘      └────────┘
       │              │
┌──────▼──────────────▼─────────────────────────────────────┐
│              Celery Workers                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │Parse Worker │  │Vectorize    │  │System       │     │
│  │(4并发)      │  │Worker(4并发)│  │Worker(4并发)│     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│  ┌─────────────┐                                       │
│  │Slow Parse   │                                       │
│  │Worker(1并发)│                                       │
│  └─────────────┘                                       │
└──────────────────────────────────────────────────────────┘
```

## 🚀 快速开始

### 前置要求

- Docker 和 Docker Compose
- 至少 8GB 可用内存（推荐 16GB+）
- 足够的磁盘空间用于存储文档和向量数据

### 环境变量配置

创建 `.env` 文件，配置以下环境变量：

```bash
# PostgreSQL 配置
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_DB=rag_service
POSTGRES_HOST=rag_service_postgres
POSTGRES_PORT=5432

# Redis 配置
REDIS_HOST=rag_service_redis
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# Qdrant 配置
QDRANT_HOST=rag_service_qdrant
QDRANT_PORT=6333
QDRANT_API_KEY=your_api_key

# 向量存储配置
VECTOR_STORE_SERVER_HOST=rag_service_postgres
VECTOR_STORE_TYPE=postgres  # 或 qdrant

# 嵌入模型配置
EMBEDDING_MODEL=text-embedding-ada-002  # 或其他模型
EMBEDDING_DIMENSION=1536

# API 配置
API_KEY=your_api_key
SECRET_KEY=your_secret_key

# 文档解析配置
CHUNK_SIZE=512
CHUNK_OVERLAP=50
MAX_FILE_SIZE=100MB

# 日志配置
LOG_LEVEL=INFO
```

### 启动服务

```bash
# 进入目录
cd CortexRAG

# 启动所有服务
docker compose up -d

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f rag_service_backend
```

### 验证服务

```bash
# 检查后端 API 健康状态
curl http://localhost:8081/health

# 检查前端服务
curl http://localhost:8082

# 访问 Flower 监控界面（Celery 任务监控）
# http://localhost:35555
```

## 📁 项目结构

```
CortexRAG/
├── docker-compose.yml          # Docker Compose 配置文件
├── .env                        # 环境变量文件（需自行创建）
├── data/                       # 文档数据目录（挂载到容器）
├── postgres-data/              # PostgreSQL 数据目录
├── redis-data/                 # Redis 数据目录
├── qdrant-data/                # Qdrant 数据目录
├── redis.conf                  # Redis 配置文件
└── README.md                   # 项目文档
```

## ⚙️ 服务组件说明

### 1. Backend API (rag_service_backend)

**功能**：提供 FastAPI RESTful API 接口

**端口**：8081

**主要功能**：
- 知识库 CRUD 操作
- 文档上传和管理
- 语义检索接口
- 任务状态查询

**健康检查**：
```bash
curl http://localhost:8081/health
```

### 2. Frontend (rag_service_frontend)

**功能**：Web 用户界面

**端口**：8082

**访问地址**：`http://localhost:8082`

**功能**：
- 知识库管理界面
- 文档上传界面
- 检索测试界面
- 任务监控界面

### 3. Celery Workers

#### Parse Worker (parse_worker)
- **队列**：`document_parse_queue`
- **并发数**：4
- **功能**：快速文档解析任务

#### Slow Parse Worker (slow_parse_worker)
- **队列**：`document_slow_parse_queue`
- **并发数**：1
- **功能**：处理复杂文档解析任务（如大型 PDF、扫描件等）

#### Vectorize Worker (vectorize_worker)
- **队列**：`document_vectorize_queue`
- **并发数**：4
- **功能**：文档向量化任务

#### System Worker (system_worker)
- **队列**：`system_task_queue`
- **并发数**：4
- **功能**：系统级任务（如知识库重建、批量操作等）

### 4. Flower (rag_service_flower)

**功能**：Celery 任务监控和管理界面

**端口**：35555

**访问地址**：`http://localhost:35555`

**功能**：
- 查看任务执行状态
- 监控 Worker 状态
- 查看任务历史
- 任务统计信息

### 5. PostgreSQL (rag_service_postgres)

**功能**：关系数据库 + 向量存储（pgvector）

**端口**：5432

**镜像**：`rd.clouditera.com/docker/vchord-postgres:pg17-v0.5.3`

**特性**：
- 支持 pgvector 扩展
- 优化的连接池配置
- 支持高并发访问

### 6. Redis (rag_service_redis)

**功能**：Celery 消息代理和缓存

**端口**：6379

**镜像**：`rd.clouditera.com/docker/redis:8.0.2`

**配置**：通过 `redis.conf` 文件配置

### 7. Qdrant (rag_service_qdrant)

**功能**：向量数据库（可选）

**端口**：
- REST API: 6333
- gRPC API: 6334

**镜像**：`rd.clouditera.com/docker/qdrant:v1.15`

**用途**：可作为 PostgreSQL 的补充或替代向量存储

## 📡 API 接口文档

### 基础路径

所有 API 接口的基础路径为：`http://localhost:8081/api/v1`

### 知识库管理接口

#### 1. 创建知识库

**接口地址**：`POST /knowledge-bases`

**请求参数**：
```json
{
  "name": "技术文档库",
  "description": "存储技术相关文档",
  "embedding_model_id": "text-embedding-ada-002",
  "embedding_model_dimension": 1536,
  "chunk_size": 512,
  "chunk_lines_overlap": 50
}
```

**响应示例**：
```json
{
  "id": "kb_123456",
  "name": "技术文档库",
  "description": "存储技术相关文档",
  "created_at": "2025-11-24T10:00:00Z",
  "embedding_model_id": "text-embedding-ada-002",
  "embedding_model_dimension": 1536,
  "chunk_size": 512,
  "chunk_lines_overlap": 50
}
```

#### 2. 获取知识库列表

**接口地址**：`GET /knowledge-bases`

**查询参数**：
- `page`: 页码（默认：1）
- `page_size`: 每页数量（默认：20）

**响应示例**：
```json
{
  "total": 10,
  "page": 1,
  "page_size": 20,
  "items": [
    {
      "id": "kb_123456",
      "name": "技术文档库",
      "description": "存储技术相关文档",
      "document_count": 25,
      "created_at": "2025-11-24T10:00:00Z",
      "updated_at": "2025-11-24T10:00:00Z"
    }
  ]
}
```

#### 3. 获取知识库详情

**接口地址**：`GET /knowledge-bases/{kb_id}`

**响应示例**：
```json
{
  "id": "kb_123456",
  "name": "技术文档库",
  "description": "存储技术相关文档",
  "document_count": 25,
  "total_chunks": 1250,
  "embedding_model_id": "text-embedding-ada-002",
  "embedding_model_dimension": 1536,
  "chunk_size": 512,
  "chunk_lines_overlap": 50,
  "created_at": "2025-11-24T10:00:00Z",
  "updated_at": "2025-11-24T10:00:00Z"
}
```

#### 4. 更新知识库

**接口地址**：`PUT /knowledge-bases/{kb_id}`

**请求参数**：
```json
{
  "name": "更新后的名称",
  "description": "更新后的描述"
}
```

#### 5. 删除知识库

**接口地址**：`DELETE /knowledge-bases/{kb_id}`

**响应示例**：
```json
{
  "message": "知识库删除成功"
}
```

### 文档管理接口

#### 1. 上传文档

**接口地址**：`POST /knowledge-bases/{kb_id}/documents`

**请求类型**：`multipart/form-data`

**请求参数**：
- `file`: 文档文件（必填）
- `name`: 文档名称（可选，默认使用文件名）
- `metadata`: 文档元数据 JSON 字符串（可选）

**响应示例**：
```json
{
  "id": "doc_123456",
  "kb_id": "kb_123456",
  "name": "技术文档.pdf",
  "size": 1024000,
  "status": "parsing",
  "created_at": "2025-11-24T10:00:00Z"
}
```

#### 2. 获取文档列表

**接口地址**：`GET /knowledge-bases/{kb_id}/documents`

**查询参数**：
- `page`: 页码（默认：1）
- `page_size`: 每页数量（默认：20）
- `status`: 文档状态过滤（parsing, vectorizing, completed, failed）

**响应示例**：
```json
{
  "total": 25,
  "page": 1,
  "page_size": 20,
  "items": [
    {
      "id": "doc_123456",
      "name": "技术文档.pdf",
      "size": 1024000,
      "status": "completed",
      "total_chunks": 50,
      "created_at": "2025-11-24T10:00:00Z",
      "finish_time": "2025-11-24T10:05:00Z"
    }
  ]
}
```

#### 3. 获取文档详情

**接口地址**：`GET /documents/{doc_id}`

**响应示例**：
```json
{
  "id": "doc_123456",
  "kb_id": "kb_123456",
  "name": "技术文档.pdf",
  "path": "/app/data/documents/doc_123456.pdf",
  "size": 1024000,
  "status": "completed",
  "total_chunks": 50,
  "sha256": "abc123...",
  "created_at": "2025-11-24T10:00:00Z",
  "finish_time": "2025-11-24T10:05:00Z",
  "doc_metadata": {
    "pages": 10,
    "author": "John Doe"
  }
}
```

#### 4. 删除文档

**接口地址**：`DELETE /documents/{doc_id}`

**响应示例**：
```json
{
  "message": "文档删除成功"
}
```

#### 5. 重新处理文档

**接口地址**：`POST /documents/{doc_id}/reprocess`

**功能**：重新解析和向量化文档

**响应示例**：
```json
{
  "message": "文档重新处理任务已提交",
  "task_id": "task_123456"
}
```

### 语义检索接口

#### 1. 语义检索

**接口地址**：`POST /knowledge-bases/{kb_id}/search`

**请求参数**：
```json
{
  "query": "如何配置数据库连接？",
  "top_k": 5,
  "score_threshold": 0.7,
  "search_type": "hybrid"  // "vector", "keyword", "hybrid"
}
```

**响应示例**：
```json
{
  "query": "如何配置数据库连接？",
  "results": [
    {
      "chunk_id": "chunk_123",
      "document_id": "doc_123456",
      "document_name": "技术文档.pdf",
      "content": "数据库连接配置需要设置以下参数...",
      "score": 0.95,
      "metadata": {
        "page": 5,
        "chunk_index": 10
      }
    }
  ],
  "total": 5
}
```

#### 2. 问答检索

**接口地址**：`POST /knowledge-bases/{kb_id}/qa`

**请求参数**：
```json
{
  "query": "如何配置数据库连接？",
  "top_k": 5,
  "llm_model": "gpt-3.5-turbo",
  "temperature": 0.7,
  "max_tokens": 500
}
```

**响应示例**：
```json
{
  "query": "如何配置数据库连接？",
  "answer": "根据文档，数据库连接配置需要设置以下参数：\n1. 主机地址\n2. 端口号\n3. 用户名和密码\n...",
  "sources": [
    {
      "document_id": "doc_123456",
      "document_name": "技术文档.pdf",
      "chunk_id": "chunk_123",
      "content": "数据库连接配置...",
      "score": 0.95
    }
  ]
}
```

### 任务管理接口

#### 1. 获取任务状态

**接口地址**：`GET /tasks/{task_id}`

**响应示例**：
```json
{
  "task_id": "task_123456",
  "doc_id": "doc_123456",
  "kb_id": "kb_123456",
  "task_type": "parse",
  "task_status": "completed",
  "created_at": "2025-11-24T10:00:00Z",
  "updated_at": "2025-11-24T10:05:00Z"
}
```

#### 2. 获取文档任务列表

**接口地址**：`GET /documents/{doc_id}/tasks`

**响应示例**：
```json
{
  "total": 3,
  "items": [
    {
      "task_id": "task_123456",
      "task_type": "parse",
      "task_status": "completed",
      "created_at": "2025-11-24T10:00:00Z"
    }
  ]
}
```

## 🔧 配置说明

### 文档解析配置

- **CHUNK_SIZE**：文档分块大小（字符数），默认 512
- **CHUNK_OVERLAP**：分块重叠大小，默认 50
- **MAX_FILE_SIZE**：最大文件大小限制

### 向量化配置

- **EMBEDDING_MODEL**：嵌入模型名称
- **EMBEDDING_DIMENSION**：向量维度
- **VECTOR_STORE_TYPE**：向量存储类型（postgres 或 qdrant）

### Worker 配置

可以通过修改 `docker-compose.yml` 中的 `--concurrency` 参数调整 Worker 并发数：

```yaml
parse_worker:
  command: >
    celery -A backend.core.celery_app
    worker --loglevel=info
    --concurrency=4  # 调整并发数
    --pool=prefork
```

### PostgreSQL 优化配置

PostgreSQL 已优化以下参数：

- `max_connections=1000`：最大连接数
- `shared_buffers=256MB`：共享缓冲区
- `effective_cache_size=1GB`：有效缓存大小
- `work_mem=4MB`：工作内存
- `maintenance_work_mem=64MB`：维护工作内存

## 📊 监控与运维

### 查看服务日志

```bash
# 查看后端服务日志
docker compose logs -f rag_service_backend

# 查看解析 Worker 日志
docker compose logs -f parse_worker

# 查看向量化 Worker 日志
docker compose logs -f vectorize_worker

# 查看所有服务日志
docker compose logs -f
```

### Flower 监控

访问 `http://localhost:35555` 查看：

- **Workers**：Worker 状态和统计
- **Tasks**：任务执行历史和状态
- **Monitor**：实时任务监控
- **Broker**：Redis 连接状态

### 健康检查

```bash
# 检查后端 API
curl http://localhost:8081/health

# 检查 PostgreSQL
docker compose exec rag_service_postgres pg_isready -U postgres

# 检查 Redis
docker compose exec rag_service_redis redis-cli ping
```

### 性能监控

- **文档处理速度**：通过 Flower 监控任务执行时间
- **向量化速度**：监控 `vectorize_worker` 任务耗时
- **检索响应时间**：通过 API 响应时间监控

## 🔒 安全建议

1. **API 密钥管理**：
   - 使用强密码保护 API 密钥
   - 定期轮换密钥
   - 不要在代码中硬编码密钥

2. **数据库安全**：
   - 使用强密码保护 PostgreSQL
   - 限制数据库网络访问
   - 定期备份数据库

3. **文件上传安全**：
   - 限制文件大小和类型
   - 扫描上传文件防止恶意文件
   - 验证文件内容完整性

4. **网络安全**：
   - 生产环境使用 HTTPS
   - 配置防火墙规则
   - 限制 API 访问来源

## 🐛 常见问题

### 1. 文档解析失败

**问题**：文档上传后一直处于解析状态

**解决方案**：
- 检查 `parse_worker` 和 `slow_parse_worker` 是否正常运行
- 查看 Worker 日志：`docker compose logs parse_worker`
- 检查文档格式是否支持
- 验证文档文件是否损坏

### 2. 向量化任务堆积

**问题**：向量化任务执行缓慢

**解决方案**：
- 增加 `vectorize_worker` 并发数
- 检查嵌入模型 API 是否正常
- 查看 Redis 队列状态
- 考虑使用更快的嵌入模型

### 3. 检索结果不准确

**问题**：语义检索返回不相关结果

**解决方案**：
- 调整 `top_k` 和 `score_threshold` 参数
- 检查嵌入模型是否匹配
- 优化文档分块策略
- 尝试混合检索模式

### 4. 数据库连接失败

**问题**：无法连接到 PostgreSQL

**解决方案**：
- 检查 PostgreSQL 服务是否运行
- 验证数据库连接配置
- 检查网络连接
- 查看 PostgreSQL 日志

### 5. 内存不足

**问题**：服务运行缓慢或崩溃

**解决方案**：
- 增加系统内存
- 减少 Worker 并发数
- 优化文档分块大小
- 清理不需要的数据

## 🔄 数据备份与恢复

### 备份数据

```bash
# 备份 PostgreSQL 数据库
docker compose exec rag_service_postgres pg_dump -U postgres rag_service > rag_backup.sql

# 备份文档数据
tar -czf documents_backup.tar.gz ./data

# 备份向量数据
tar -czf qdrant_backup.tar.gz ./qdrant-data
```

### 恢复数据

```bash
# 恢复 PostgreSQL 数据库
docker compose exec -T rag_service_postgres psql -U postgres rag_service < rag_backup.sql

# 恢复文档数据
tar -xzf documents_backup.tar.gz

# 恢复向量数据
tar -xzf qdrant_backup.tar.gz
```

## 📚 相关资源

- [FastAPI 官方文档](https://fastapi.tiangolo.com/)
- [LlamaIndex 官方文档](https://docs.llamaindex.ai/)
- [Celery 官方文档](https://docs.celeryq.dev/)
- [pgvector 文档](https://github.com/pgvector/pgvector)
- [Qdrant 官方文档](https://qdrant.tech/documentation/)

## 📞 技术支持

如有问题或建议，请联系 SecCortex 开发团队。

## 📄 许可证

本项目为 SecCortex 平台的一部分，遵循平台相关许可证。

---

**最后更新**：2025-11-24

