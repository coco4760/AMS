-- SELECT pg_terminate_backend(pg_stat_activity.pid) 
-- FROM pg_stat_activity 
-- WHERE datname='kong' AND pid <> pg_backend_pid();
-- DROP DATABASE kong;
create database rag_service;

\c rag_service;

-- public.alembic_version definition

-- Drop table

-- DROP TABLE public.alembic_version;

-- public.alembic_version definition

-- Drop table

-- DROP TABLE public.alembic_version;

CREATE TABLE public.alembic_version ( version_num varchar(32) NOT NULL, CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num));


-- public.models definition

-- Drop table

-- DROP TABLE public.models;

CREATE TABLE public.models ( id varchar(64) NOT NULL, model_name varchar(255) NOT NULL, model_type varchar(50) NOT NULL, provider varchar(50) NOT NULL, model_configs json NOT NULL, created_at timestamp NULL, updated_at timestamp NULL, CONSTRAINT models_pkey PRIMARY KEY (id));
CREATE INDEX ix_models_id ON public.models USING btree (id);


-- public.system_settings definition

-- Drop table

-- DROP TABLE public.system_settings;

CREATE TABLE public.system_settings ( id serial4 NOT NULL, "key" varchar(255) NOT NULL, value text NULL, description varchar(512) NULL, created_at timestamp NULL, updated_at timestamp NULL, CONSTRAINT system_settings_pkey PRIMARY KEY (id));
CREATE INDEX ix_system_settings_id ON public.system_settings USING btree (id);
CREATE UNIQUE INDEX ix_system_settings_key ON public.system_settings USING btree (key);


-- public.users definition

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users ( id serial4 NOT NULL, username varchar NOT NULL, email varchar NULL, hashed_password varchar NOT NULL, is_active bool NULL, created_at timestamp NULL, updated_at timestamp NULL, CONSTRAINT users_pkey PRIMARY KEY (id));
CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);
CREATE INDEX ix_users_id ON public.users USING btree (id);
CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


-- public.api_keys definition

-- Drop table

-- DROP TABLE public.api_keys;

CREATE TABLE public.api_keys ( id varchar(64) NOT NULL, api_key varchar(64) NULL, "name" varchar(64) NULL, remark varchar(256) NULL, owner_id int4 NOT NULL, created_at timestamp NULL, expired_time timestamp NULL, CONSTRAINT api_keys_pkey PRIMARY KEY (id), CONSTRAINT api_keys_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id));
CREATE UNIQUE INDEX ix_api_keys_api_key ON public.api_keys USING btree (api_key);
CREATE INDEX ix_api_keys_id ON public.api_keys USING btree (id);
CREATE INDEX ix_api_keys_name ON public.api_keys USING btree (name);
CREATE INDEX ix_api_keys_owner_id ON public.api_keys USING btree (owner_id);


-- public.backups definition

-- Drop table

-- DROP TABLE public.backups;

CREATE TABLE public.backups ( id varchar(64) NOT NULL, owner_id int4 NOT NULL, status varchar(255) NOT NULL, zip_type varchar(255) NOT NULL, description varchar(255) NULL, error_message varchar(1024) NULL, created_at timestamp NULL, CONSTRAINT backups_pkey PRIMARY KEY (id), CONSTRAINT backups_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE);
CREATE INDEX ix_backups_id ON public.backups USING btree (id);
CREATE INDEX ix_backups_owner_id ON public.backups USING btree (owner_id);


-- public.knowledge_bases definition

-- Drop table

-- DROP TABLE public.knowledge_bases;

CREATE TABLE public.knowledge_bases ( id varchar(64) NOT NULL, "name" varchar(255) NOT NULL, description text NULL, owner_id int4 NOT NULL, created_at timestamp NULL, updated_at timestamp NULL, doc_updated_at timestamp NULL, embedding_model_id varchar(64) NULL, embedding_model_dimension int4 NULL, vector_store varchar(64) NULL, chunk_size int4 NULL, chunk_lines_overlap int4 NULL, CONSTRAINT knowledge_bases_pkey PRIMARY KEY (id), CONSTRAINT knowledge_bases_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id));
CREATE INDEX ix_knowledge_bases_embedding_model_id ON public.knowledge_bases USING btree (embedding_model_id);
CREATE INDEX ix_knowledge_bases_id ON public.knowledge_bases USING btree (id);
CREATE INDEX ix_knowledge_bases_owner_id ON public.knowledge_bases USING btree (owner_id);


-- public.documents definition

-- Drop table

-- DROP TABLE public.documents;

CREATE TABLE public.documents ( id varchar(64) NOT NULL, kb_id varchar(64) NOT NULL, "name" varchar(255) NOT NULL, "path" varchar(255) NOT NULL, "size" int4 NOT NULL, status varchar(20) NULL, created_at timestamp NULL, finish_time timestamp NULL, doc_metadata json NULL, from_id varchar(255) NULL, total_chunks int4 NULL, error_message varchar(1024) NULL, sha256 varchar(64) NULL, CONSTRAINT documents_pkey PRIMARY KEY (id), CONSTRAINT documents_kb_id_fkey FOREIGN KEY (kb_id) REFERENCES public.knowledge_bases(id));
CREATE INDEX ix_documents_id ON public.documents USING btree (id);


-- public.tasks definition

-- Drop table

-- DROP TABLE public.tasks;

CREATE TABLE public.tasks ( task_id varchar(64) NOT NULL, doc_id varchar(64) NOT NULL, kb_id varchar(64) NOT NULL, task_type varchar(64) NOT NULL, task_status varchar(64) NOT NULL, error_message varchar(1024) NULL, created_at timestamp NULL, updated_at timestamp NULL, CONSTRAINT tasks_pkey PRIMARY KEY (task_id), CONSTRAINT tasks_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES public.documents(id) ON DELETE CASCADE);
CREATE INDEX ix_tasks_doc_id ON public.tasks USING btree (doc_id);
CREATE INDEX ix_tasks_kb_id ON public.tasks USING btree (kb_id);
CREATE INDEX ix_tasks_task_id ON public.tasks USING btree (task_id);
