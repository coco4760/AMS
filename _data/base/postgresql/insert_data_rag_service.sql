\c rag_service;

INSERT INTO public.alembic_version (version_num) VALUES
	 ('5865b7ababe7');
INSERT INTO public.users (username,email,hashed_password,is_active,created_at,updated_at) VALUES
	 ('aigc','aigc@clouditera.com','$2b$12$RzWmSwDnefYn5pJi7RtnG.woUgj.QuTeo.UM50exkXhrx6hICtMam',true,'2025-09-03 06:52:18.682463','2025-09-03 06:52:18.68247'),
	 ('aigc_paper','aigc_paper@clouditera.com','$2b$12$/FX1cO2ms./kOIeeAI1WuuH.YfCyyHSihSIIMSD7RB9XnkkoQwOKe',true,'2025-09-03 06:54:19.430166','2025-09-03 06:54:19.430177');
INSERT INTO public.api_keys (id,api_key,name,remark,owner_id,created_at,expired_time) VALUES
	 ('3325c9a0f83d4bbcb206ec3d9450e188','02988ca9d78640f7989cd64e1a34df15','安全智库','',1,'2025-09-03 06:53:40.485569',NULL),
	 ('da0101d82ded4096869d5d78dc5dff6d','2dd13f7a99d9451db8ae751a7b069fd2','论文','',2,'2025-09-03 06:54:37.263461',NULL);

INSERT INTO public.knowledge_bases (id, "name", description, owner_id, created_at, updated_at, doc_updated_at, embedding_model_id, embedding_model_dimension, chunk_size, chunk_lines_overlap) VALUES('1', 'paper_ainote', NULL, 2, '2025-09-03 06:52:18.682', '2025-09-03 06:52:18.682', NULL, NULL, NULL, 1024, 100);
