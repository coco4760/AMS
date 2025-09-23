
# 2.5升级内容说明

## rag
论文账号下新增知识库:知识库名：paper_peruse，描述:论文研读

## nacos
路径：nacos/nacos_config_export_20250919180311.zip
- rag配置文件中新增knowledge-base-file-meta-service-url，值为plugins/knowledge_base_filemeta服务地址
- rag配置文件中新增paper-file-meta-service-url，值为plugins/clouditera_paper服务地址


## dify工作流
### 【论文研读】 对话 20250918工作流
- 修改环境变量：RAG_HOST:rag地址，API_KEY:rag论文的apiKey
- 修改AGENT表ID=2的APP_ID和KEY

### 【论文研读】摘要总结-20250918工作流
- 修改环境变量：RAG_SERVICE_HOST：rag地址，API_KEY：rag论文的apiKey，KB_ID：rag中论文研读(paper_peruse)的知识库id
- 修改AGENT表ID=119的APP_ID和KEY


## clouditera_paper
路径：plugins/clouditera_paper
- 修改mysql信息
- 修改.env中的PAPER_FOR_USERS_WORK_FLOW_API_KEY，值为【【论文研读】文件元数据提取 20250917】工作流的key
- 修改.env中的PAPER_WORK_FLOW_BASE_URL，值为dify地址

## knowledge_base_filemeta
路径：plugins/knowledge_base_filemeta
- 修改.env中的EXTERNAL_AI_AGGREGATE_API_KEY，值为【【安全智库】文件元数据提取 20250921】工作流的key
- 修改.env中的EXTERNAL_AI_AGGREGATE_API_BASE_URL，值为dify地址





