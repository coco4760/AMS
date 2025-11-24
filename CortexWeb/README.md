## CortexWeb - 智能体应用前端

CortexWeb 是 SecCortex 智能体平台的前端界面，基于 WuJi 系列 Web 应用，负责提供交互式的智能体管理、任务编排、可视化运行和结果展示。前端通过 Nginx 代理接入 Kong 网关，再统一转发至后端服务，如 `clientapi`、`authapi`、`sastapi` 和插件接口。

---

## 架构概览

```
Browser
  │
  ▼
CortexWeb (Nginx, port 80/自定义)
  │  ├── 静态页面 (Vue/React 构建的 WuJi 前端)
  │  └── 反向代理 /clientapi、/authapi、/sastapi、/plugin → Kong
  ▼
Kong API Gateway
  ├── clientapi → CortexServer client-http
  ├── authapi   → CortexAuth
  ├── sastapi   → SAST 服务
  └── plugin    → 各类插件/Agent 服务
```

支持多套品牌 / UI 方案：

| 服务 | 镜像 | 场景 | 启动方式 |
| --- | --- | --- | --- |
| `client-web-html` | `rd.clouditera.com/aigc/wuji/client-web:v3.5.5` | 默认（标准版） | 默认启用 |
| `client-web-html-jibei` | `rd.clouditera.com/aigc/wuji/jibei-web:v1.0.23` | 集贝定制 | `--profile jibei` |
| `client-web-html-guowang` | `rd.clouditera.com/aigc/wuji/guowang-web:v1.0.10` | 国网定制 | `--profile guowang` |

---

## 快速启动

1. **准备环境变量**

在 `CortexWeb/.env` 中至少配置：

```bash
KONG_HOST=192.168.34.7   # Kong 实例地址（供前端容器解析）
WEB_PORT=18080            # 可选：对外暴露端口（如需映射非 80）
```

2. **启动标准版前端**

```bash
cd CortexWeb
docker compose up -d
```

3. **启动定制版本**

```bash
docker compose --profile jibei up -d       # 集贝
docker compose --profile guowang up -d     # 国网
```

4. **访问**

- 标准版：`http://<HOST>:80`（若有端口映射按实际为准）
- 通过 Nginx 自动转发 `/clientapi`、`/authapi` 等路由

---

## Nginx 配置要点

`config/nginx.conf` 已预配置以下策略：

- **大文件上传**：`client_max_body_size 5120M`，支持多 GB 资源上传
- **长连接/超时**：`proxy_*_timeout 3600s`，适配大模型长响应
- **WebSocket 支持**：`proxy_set_header Upgrade/Connection`，提升实时交互体验
- **静态资源**：`root /usr/share/nginx/html` + `try_files ... /index.html`，兼容单页应用
- **反向代理**：
  - `/clientapi/` → `http://kong:8000`
  - `/authapi/`   → `http://kong:8000`
  - `/sastapi/`   → `http://kong:8000`
  - `/plugin/`    → `http://kong:8000`

如需新增路由，可在该配置中追加 `location` 块并挂载到容器内。

---

## 部署建议

1. **Kong 解析**：Compose 中使用 `extra_hosts` 将 `kong.host.com` / `kong` 映射至实际 Kong IP；若部署在同一网络，可改为 `network_mode` 共享网络。
2. **端口冲突**：默认占用宿主机 80 端口，如需部署多套前端，建议在 compose 中调换 `HOST:CONTAINER` 映射，例如 `8080:80`。
3. **HTTPS 支持**：可在 `config/nginx.conf` 中启用 SSL 证书；生产环境建议通过外部负载或 Kubenetes Ingress 统一管理 TLS。
4. **跨域设置**：若直接访问后端 API，可在 Nginx 里添加 CORS 头，或通过 Kong 完成。
5. **缓存与压缩**：可启用 `gzip`、`expires` 等指令提升静态资源效率。

---

## 常见问题

| 问题 | 排查思路 |
| --- | --- |
| 页面空白或 404 | 检查静态资源是否正确挂载；确认构建产物位于镜像默认路径 `/usr/share/nginx/html` |
| 接口请求报错 `502/504` | 查看 Nginx 日志、Kong 日志，确认后端 API 是否可达 |
| WebSocket 连接失败 | 核对 `proxy_set_header Upgrade/Connection` 是否生效；确认后端支持 WS |
| 定制版 UI 未生效 | 是否通过 `--profile jibei/guowang` 启动；确认镜像 tag |
| 静态资源缓存问题 | 清理浏览器缓存或在 Nginx 配置中调整缓存策略 |

---

## 文件结构

```
CortexWeb/
├── docker-compose.yaml   # 前端/品牌版本定义
├── config/
│   └── nginx.conf        # Nginx 主配置
└── README.md             # 当前文档
```

---

## 相关组件

- `CortexServer`：提供 `/clientapi` 后端能力
- `CortexAuth`：认证服务 `/authapi`
- `CortexGateway`：Kong 网关（代理所有 API）
- `CortexSOP`：工作流编排前端的后端服务（可通过 Kong 接入）

确保上述服务已启动并在 Kong 中正确注册路由，即可为 CortexWeb 提供完整的智能体应用体验。

