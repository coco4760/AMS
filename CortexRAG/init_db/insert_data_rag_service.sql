INSERT INTO public.alembic_version (version_num) VALUES
	 ('857a576c00c7');
INSERT INTO public.models (id,model_name,model_type,provider,model_configs,created_at,updated_at) VALUES
	 ('3979e143763243609f8a60f120e859a3','bge-reranker-v2-m3','rerank','xinference','{"model": "bge-reranker-v2-m3", "base_url": "http://10.20.25.2:9997", "batch_size": 10, "timeout": 30}','2025-11-25 11:33:14.66515','2025-11-25 11:33:14.665166'),
	 ('43a142a50bee4070abf46d9af3c93f53','Qwen3-Embedding-0.6B','embedding','xinference','{"model_uid": "Qwen3-Embedding-0.6B", "base_url": "http://10.20.25.2:9997", "vector_dimension": 1024, "timeout": 30}','2025-11-25 11:32:30.014653','2025-11-25 11:34:01.956754');
INSERT INTO public.users (username,email,hashed_password,is_active,created_at,updated_at) VALUES
	 ('admin@clouditera.com','admin@clouditera.com','$2b$12$QEEsLbdACzC0VUz548iqE.qpOPEb88bv88gwY4YMFHNt3pOSbE.Oe',true,'2025-11-25 08:17:47.093095','2025-11-25 08:17:47.093108');
INSERT INTO public.api_keys (id,api_key,"name",remark,owner_id,created_at,expired_time) VALUES
	 ('670adc90684c4231b7bf33248f881daa','cddb4cf4651f455a94b8366e16d145ce','test','',1,'2025-11-25 09:12:32.249786',NULL);
INSERT INTO public.knowledge_bases (id,"name",description,owner_id,created_at,updated_at,doc_updated_at,embedding_model_id,embedding_model_dimension,vector_store,chunk_size,chunk_lines_overlap) VALUES
	 ('89889f2665cd427e98039d7a73cbe9f5','paper_peruse','论文研读',1,'2025-11-25 12:29:40.326117','2025-11-25 12:29:40.32612',NULL,'43a142a50bee4070abf46d9af3c93f53',1024,'qdrant',1024,100),
	 ('02982bfe67a8498fb29448f50d6a1d4a','paper_ainote','安全论文检索',1,'2025-11-25 11:52:12.980488','2025-11-25 16:03:51.052282','2025-11-25 16:03:51.049349','43a142a50bee4070abf46d9af3c93f53',1024,'qdrant',1024,100),
	 ('8be558b7f36744a7b2e70f5ecdd470ae','document_speed_read','文档速读',1,'2025-11-25 12:08:46.741856','2025-11-25 12:08:46.741861',NULL,'43a142a50bee4070abf46d9af3c93f53',1024,'qdrant',1024,100);
INSERT INTO public.system_settings ("key",value,description,created_at,updated_at) VALUES
	 ('default_vector_store','qdrant','默认向量存储','2025-11-25 11:30:40.371452','2025-11-25 11:30:40.371469'),
	 ('default_embedding_model','43a142a50bee4070abf46d9af3c93f53','默认向量模型','2025-11-25 11:33:26.984436','2025-11-25 11:33:26.98445'),
	 ('default_rerank_model','3979e143763243609f8a60f120e859a3','默认重排模型','2025-11-25 11:33:28.083999','2025-11-25 11:33:28.084006');