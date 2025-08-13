-- DROP SEQUENCE public.invitation_codes_id_seq;

CREATE SEQUENCE public.invitation_codes_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.task_id_sequence;

CREATE SEQUENCE public.task_id_sequence
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
-- DROP SEQUENCE public.taskset_id_sequence;

CREATE SEQUENCE public.taskset_id_sequence
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;-- public.account_integrates definition

-- Drop table



-- DROP FUNCTION public.uuid_generate_v1();

CREATE OR REPLACE FUNCTION public.uuid_generate_v1()
 RETURNS uuid
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v1$function$
;

-- DROP FUNCTION public.uuid_generate_v1mc();

CREATE OR REPLACE FUNCTION public.uuid_generate_v1mc()
 RETURNS uuid
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v1mc$function$
;

-- DROP FUNCTION public.uuid_generate_v3(uuid, text);

CREATE OR REPLACE FUNCTION public.uuid_generate_v3(namespace uuid, name text)
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v3$function$
;

-- DROP FUNCTION public.uuid_generate_v4();

CREATE OR REPLACE FUNCTION public.uuid_generate_v4()
 RETURNS uuid
 LANGUAGE c
 PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v4$function$
;

-- DROP FUNCTION public.uuid_generate_v5(uuid, text);

CREATE OR REPLACE FUNCTION public.uuid_generate_v5(namespace uuid, name text)
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v5$function$
;

-- DROP FUNCTION public.uuid_nil();

CREATE OR REPLACE FUNCTION public.uuid_nil()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_nil$function$
;

-- DROP FUNCTION public.uuid_ns_dns();

CREATE OR REPLACE FUNCTION public.uuid_ns_dns()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_dns$function$
;

-- DROP FUNCTION public.uuid_ns_oid();

CREATE OR REPLACE FUNCTION public.uuid_ns_oid()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_oid$function$
;

-- DROP FUNCTION public.uuid_ns_url();

CREATE OR REPLACE FUNCTION public.uuid_ns_url()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_url$function$
;

-- DROP FUNCTION public.uuid_ns_x500();

CREATE OR REPLACE FUNCTION public.uuid_ns_x500()
 RETURNS uuid
 LANGUAGE c
 IMMUTABLE PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_ns_x500$function$;

-- DROP TABLE public.account_integrates;

CREATE TABLE public.account_integrates ( id uuid DEFAULT uuid_generate_v4() NOT NULL, account_id uuid NOT NULL, provider varchar(16) NOT NULL, open_id varchar(255) NOT NULL, encrypted_token varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT account_integrate_pkey PRIMARY KEY (id), CONSTRAINT unique_account_provider UNIQUE (account_id, provider), CONSTRAINT unique_provider_open_id UNIQUE (provider, open_id));


-- public.account_plugin_permissions definition

-- Drop table

-- DROP TABLE public.account_plugin_permissions;

CREATE TABLE public.account_plugin_permissions ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, install_permission varchar(16) DEFAULT 'everyone'::character varying NOT NULL, debug_permission varchar(16) DEFAULT 'noone'::character varying NOT NULL, CONSTRAINT account_plugin_permission_pkey PRIMARY KEY (id), CONSTRAINT unique_tenant_plugin UNIQUE (tenant_id));


-- public.accounts definition

-- Drop table

-- DROP TABLE public.accounts;

CREATE TABLE public.accounts ( id uuid DEFAULT uuid_generate_v4() NOT NULL, "name" varchar(255) NOT NULL, email varchar(255) NOT NULL, "password" varchar(255) NULL, password_salt varchar(255) NULL, avatar varchar(255) NULL, interface_language varchar(255) NULL, interface_theme varchar(255) NULL, timezone varchar(255) NULL, last_login_at timestamp NULL, last_login_ip varchar(255) NULL, status varchar(16) DEFAULT 'active'::character varying NOT NULL, initialized_at timestamp NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, last_active_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT account_pkey PRIMARY KEY (id));
CREATE INDEX account_email_idx ON public.accounts USING btree (email);


-- public.alembic_version definition

-- Drop table

-- DROP TABLE public.alembic_version;

CREATE TABLE public.alembic_version ( version_num varchar(32) NOT NULL, CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num));


-- public.api_based_extensions definition

-- Drop table

-- DROP TABLE public.api_based_extensions;

CREATE TABLE public.api_based_extensions ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, "name" varchar(255) NOT NULL, api_endpoint varchar(255) NOT NULL, api_key text NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT api_based_extension_pkey PRIMARY KEY (id));
CREATE INDEX api_based_extension_tenant_idx ON public.api_based_extensions USING btree (tenant_id);


-- public.api_requests definition

-- Drop table

-- DROP TABLE public.api_requests;

CREATE TABLE public.api_requests ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, api_token_id uuid NOT NULL, "path" varchar(255) NOT NULL, request text NULL, response text NULL, ip varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT api_request_pkey PRIMARY KEY (id));
CREATE INDEX api_request_token_idx ON public.api_requests USING btree (tenant_id, api_token_id);


-- public.api_tokens definition

-- Drop table

-- DROP TABLE public.api_tokens;

CREATE TABLE public.api_tokens ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NULL, "type" varchar(16) NOT NULL, "token" varchar(255) NOT NULL, last_used_at timestamp NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, tenant_id uuid NULL, CONSTRAINT api_token_pkey PRIMARY KEY (id));
CREATE INDEX api_token_app_id_type_idx ON public.api_tokens USING btree (app_id, type);
CREATE INDEX api_token_tenant_idx ON public.api_tokens USING btree (tenant_id, type);
CREATE INDEX api_token_token_idx ON public.api_tokens USING btree (token, type);


-- public.app_annotation_hit_histories definition

-- Drop table

-- DROP TABLE public.app_annotation_hit_histories;

CREATE TABLE public.app_annotation_hit_histories ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, annotation_id uuid NOT NULL, "source" text NOT NULL, question text NOT NULL, account_id uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, score float8 DEFAULT 0 NOT NULL, message_id uuid NOT NULL, annotation_question text NOT NULL, annotation_content text NOT NULL, CONSTRAINT app_annotation_hit_histories_pkey PRIMARY KEY (id));
CREATE INDEX app_annotation_hit_histories_account_idx ON public.app_annotation_hit_histories USING btree (account_id);
CREATE INDEX app_annotation_hit_histories_annotation_idx ON public.app_annotation_hit_histories USING btree (annotation_id);
CREATE INDEX app_annotation_hit_histories_app_idx ON public.app_annotation_hit_histories USING btree (app_id);
CREATE INDEX app_annotation_hit_histories_message_idx ON public.app_annotation_hit_histories USING btree (message_id);


-- public.app_annotation_settings definition

-- Drop table

-- DROP TABLE public.app_annotation_settings;

CREATE TABLE public.app_annotation_settings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, score_threshold float8 DEFAULT 0 NOT NULL, collection_binding_id uuid NOT NULL, created_user_id uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_user_id uuid NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT app_annotation_settings_pkey PRIMARY KEY (id));
CREATE INDEX app_annotation_settings_app_idx ON public.app_annotation_settings USING btree (app_id);


-- public.app_dataset_joins definition

-- Drop table

-- DROP TABLE public.app_dataset_joins;

CREATE TABLE public.app_dataset_joins ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, dataset_id uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, CONSTRAINT app_dataset_join_pkey PRIMARY KEY (id));
CREATE INDEX app_dataset_join_app_dataset_idx ON public.app_dataset_joins USING btree (dataset_id, app_id);


-- public.app_model_configs definition

-- Drop table

-- DROP TABLE public.app_model_configs;

CREATE TABLE public.app_model_configs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, provider varchar(255) NULL, model_id varchar(255) NULL, configs json NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, opening_statement text NULL, suggested_questions text NULL, suggested_questions_after_answer text NULL, more_like_this text NULL, model text NULL, user_input_form text NULL, pre_prompt text NULL, agent_mode text NULL, speech_to_text text NULL, sensitive_word_avoidance text NULL, retriever_resource text NULL, dataset_query_variable varchar(255) NULL, prompt_type varchar(255) DEFAULT 'simple'::character varying NOT NULL, chat_prompt_config text NULL, completion_prompt_config text NULL, dataset_configs text NULL, external_data_tools text NULL, file_upload text NULL, text_to_speech text NULL, created_by uuid NULL, updated_by uuid NULL, CONSTRAINT app_model_config_pkey PRIMARY KEY (id));
CREATE INDEX app_app_id_idx ON public.app_model_configs USING btree (app_id);


-- public.apps definition

-- Drop table

-- DROP TABLE public.apps;

CREATE TABLE public.apps ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, "name" varchar(255) NOT NULL, "mode" varchar(255) NOT NULL, icon varchar(255) NULL, icon_background varchar(255) NULL, app_model_config_id uuid NULL, status varchar(255) DEFAULT 'normal'::character varying NOT NULL, enable_site bool NOT NULL, enable_api bool NOT NULL, api_rpm int4 DEFAULT 0 NOT NULL, api_rph int4 DEFAULT 0 NOT NULL, is_demo bool DEFAULT false NOT NULL, is_public bool DEFAULT false NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, is_universal bool DEFAULT false NOT NULL, workflow_id uuid NULL, description text DEFAULT ''::character varying NOT NULL, tracing text NULL, max_active_requests int4 NULL, icon_type varchar(255) NULL, created_by uuid NULL, updated_by uuid NULL, use_icon_as_answer_icon bool DEFAULT false NOT NULL, CONSTRAINT app_pkey PRIMARY KEY (id));
CREATE INDEX app_tenant_id_idx ON public.apps USING btree (tenant_id);


-- public.celery_taskmeta definition

-- Drop table

-- DROP TABLE public.celery_taskmeta;

CREATE TABLE public.celery_taskmeta ( id int4 DEFAULT nextval('task_id_sequence'::regclass) NOT NULL, task_id varchar(155) NULL, status varchar(50) NULL, "result" bytea NULL, date_done timestamp NULL, traceback text NULL, "name" varchar(155) NULL, args bytea NULL, kwargs bytea NULL, worker varchar(155) NULL, retries int4 NULL, queue varchar(155) NULL, CONSTRAINT celery_taskmeta_pkey PRIMARY KEY (id), CONSTRAINT celery_taskmeta_task_id_key UNIQUE (task_id));


-- public.celery_tasksetmeta definition

-- Drop table

-- DROP TABLE public.celery_tasksetmeta;

CREATE TABLE public.celery_tasksetmeta ( id int4 DEFAULT nextval('taskset_id_sequence'::regclass) NOT NULL, taskset_id varchar(155) NULL, "result" bytea NULL, date_done timestamp NULL, CONSTRAINT celery_tasksetmeta_pkey PRIMARY KEY (id), CONSTRAINT celery_tasksetmeta_taskset_id_key UNIQUE (taskset_id));


-- public.child_chunks definition

-- Drop table

-- DROP TABLE public.child_chunks;

CREATE TABLE public.child_chunks ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, dataset_id uuid NOT NULL, document_id uuid NOT NULL, segment_id uuid NOT NULL, "position" int4 NOT NULL, "content" text NOT NULL, word_count int4 NOT NULL, index_node_id varchar(255) NULL, index_node_hash varchar(255) NULL, "type" varchar(255) DEFAULT 'automatic'::character varying NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_by uuid NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, indexing_at timestamp NULL, completed_at timestamp NULL, error text NULL, CONSTRAINT child_chunk_pkey PRIMARY KEY (id));
CREATE INDEX child_chunk_dataset_id_idx ON public.child_chunks USING btree (tenant_id, dataset_id, document_id, segment_id, index_node_id);
CREATE INDEX child_chunks_node_idx ON public.child_chunks USING btree (index_node_id, dataset_id);
CREATE INDEX child_chunks_segment_idx ON public.child_chunks USING btree (segment_id);


-- public.conversations definition

-- Drop table

-- DROP TABLE public.conversations;

CREATE TABLE public.conversations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, app_model_config_id uuid NULL, model_provider varchar(255) NULL, override_model_configs text NULL, model_id varchar(255) NULL, "mode" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, summary text NULL, inputs json NOT NULL, introduction text NULL, system_instruction text NULL, system_instruction_tokens int4 DEFAULT 0 NOT NULL, status varchar(255) NOT NULL, from_source varchar(255) NOT NULL, from_end_user_id uuid NULL, from_account_id uuid NULL, read_at timestamp NULL, read_account_id uuid NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, is_deleted bool DEFAULT false NOT NULL, invoke_from varchar(255) NULL, dialogue_count int4 DEFAULT 0 NOT NULL, CONSTRAINT conversation_pkey PRIMARY KEY (id));
CREATE INDEX conversation_app_from_user_idx ON public.conversations USING btree (app_id, from_source, from_end_user_id);


-- public.data_source_api_key_auth_bindings definition

-- Drop table

-- DROP TABLE public.data_source_api_key_auth_bindings;

CREATE TABLE public.data_source_api_key_auth_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, category varchar(255) NOT NULL, provider varchar(255) NOT NULL, credentials text NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, disabled bool DEFAULT false NULL, CONSTRAINT data_source_api_key_auth_binding_pkey PRIMARY KEY (id));
CREATE INDEX data_source_api_key_auth_binding_provider_idx ON public.data_source_api_key_auth_bindings USING btree (provider);
CREATE INDEX data_source_api_key_auth_binding_tenant_id_idx ON public.data_source_api_key_auth_bindings USING btree (tenant_id);


-- public.data_source_oauth_bindings definition

-- Drop table

-- DROP TABLE public.data_source_oauth_bindings;

CREATE TABLE public.data_source_oauth_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, access_token varchar(255) NOT NULL, provider varchar(255) NOT NULL, source_info jsonb NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, disabled bool DEFAULT false NULL, CONSTRAINT source_binding_pkey PRIMARY KEY (id));
CREATE INDEX source_binding_tenant_id_idx ON public.data_source_oauth_bindings USING btree (tenant_id);
CREATE INDEX source_info_idx ON public.data_source_oauth_bindings USING gin (source_info);


-- public.dataset_auto_disable_logs definition

-- Drop table

-- DROP TABLE public.dataset_auto_disable_logs;

CREATE TABLE public.dataset_auto_disable_logs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, dataset_id uuid NOT NULL, document_id uuid NOT NULL, notified bool DEFAULT false NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT dataset_auto_disable_log_pkey PRIMARY KEY (id));
CREATE INDEX dataset_auto_disable_log_created_atx ON public.dataset_auto_disable_logs USING btree (created_at);
CREATE INDEX dataset_auto_disable_log_dataset_idx ON public.dataset_auto_disable_logs USING btree (dataset_id);
CREATE INDEX dataset_auto_disable_log_tenant_idx ON public.dataset_auto_disable_logs USING btree (tenant_id);


-- public.dataset_collection_bindings definition

-- Drop table

-- DROP TABLE public.dataset_collection_bindings;

CREATE TABLE public.dataset_collection_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, provider_name varchar(255) NOT NULL, model_name varchar(255) NOT NULL, collection_name varchar(64) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, "type" varchar(40) DEFAULT 'dataset'::character varying NOT NULL, CONSTRAINT dataset_collection_bindings_pkey PRIMARY KEY (id));
CREATE INDEX provider_model_name_idx ON public.dataset_collection_bindings USING btree (provider_name, model_name);


-- public.dataset_keyword_tables definition

-- Drop table

-- DROP TABLE public.dataset_keyword_tables;

CREATE TABLE public.dataset_keyword_tables ( id uuid DEFAULT uuid_generate_v4() NOT NULL, dataset_id uuid NOT NULL, keyword_table text NOT NULL, data_source_type varchar(255) DEFAULT 'database'::character varying NOT NULL, CONSTRAINT dataset_keyword_table_pkey PRIMARY KEY (id), CONSTRAINT dataset_keyword_tables_dataset_id_key UNIQUE (dataset_id));
CREATE INDEX dataset_keyword_table_dataset_id_idx ON public.dataset_keyword_tables USING btree (dataset_id);


-- public.dataset_metadata_bindings definition

-- Drop table

-- DROP TABLE public.dataset_metadata_bindings;

CREATE TABLE public.dataset_metadata_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, dataset_id uuid NOT NULL, metadata_id uuid NOT NULL, document_id uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, created_by uuid NOT NULL, CONSTRAINT dataset_metadata_binding_pkey PRIMARY KEY (id));
CREATE INDEX dataset_metadata_binding_dataset_idx ON public.dataset_metadata_bindings USING btree (dataset_id);
CREATE INDEX dataset_metadata_binding_document_idx ON public.dataset_metadata_bindings USING btree (document_id);
CREATE INDEX dataset_metadata_binding_metadata_idx ON public.dataset_metadata_bindings USING btree (metadata_id);
CREATE INDEX dataset_metadata_binding_tenant_idx ON public.dataset_metadata_bindings USING btree (tenant_id);


-- public.dataset_metadatas definition

-- Drop table

-- DROP TABLE public.dataset_metadatas;

CREATE TABLE public.dataset_metadatas ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, dataset_id uuid NOT NULL, "type" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, created_by uuid NOT NULL, updated_by uuid NULL, CONSTRAINT dataset_metadata_pkey PRIMARY KEY (id));
CREATE INDEX dataset_metadata_dataset_idx ON public.dataset_metadatas USING btree (dataset_id);
CREATE INDEX dataset_metadata_tenant_idx ON public.dataset_metadatas USING btree (tenant_id);


-- public.dataset_permissions definition

-- Drop table

-- DROP TABLE public.dataset_permissions;

CREATE TABLE public.dataset_permissions ( id uuid DEFAULT uuid_generate_v4() NOT NULL, dataset_id uuid NOT NULL, account_id uuid NOT NULL, has_permission bool DEFAULT true NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, tenant_id uuid NOT NULL, CONSTRAINT dataset_permission_pkey PRIMARY KEY (id));
CREATE INDEX idx_dataset_permissions_account_id ON public.dataset_permissions USING btree (account_id);
CREATE INDEX idx_dataset_permissions_dataset_id ON public.dataset_permissions USING btree (dataset_id);
CREATE INDEX idx_dataset_permissions_tenant_id ON public.dataset_permissions USING btree (tenant_id);


-- public.dataset_process_rules definition

-- Drop table

-- DROP TABLE public.dataset_process_rules;

CREATE TABLE public.dataset_process_rules ( id uuid DEFAULT uuid_generate_v4() NOT NULL, dataset_id uuid NOT NULL, "mode" varchar(255) DEFAULT 'automatic'::character varying NOT NULL, rules text NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT dataset_process_rule_pkey PRIMARY KEY (id));
CREATE INDEX dataset_process_rule_dataset_id_idx ON public.dataset_process_rules USING btree (dataset_id);


-- public.dataset_queries definition

-- Drop table

-- DROP TABLE public.dataset_queries;

CREATE TABLE public.dataset_queries ( id uuid DEFAULT uuid_generate_v4() NOT NULL, dataset_id uuid NOT NULL, "content" text NOT NULL, "source" varchar(255) NOT NULL, source_app_id uuid NULL, created_by_role varchar NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, CONSTRAINT dataset_query_pkey PRIMARY KEY (id));
CREATE INDEX dataset_query_dataset_id_idx ON public.dataset_queries USING btree (dataset_id);


-- public.dataset_retriever_resources definition

-- Drop table

-- DROP TABLE public.dataset_retriever_resources;

CREATE TABLE public.dataset_retriever_resources ( id uuid DEFAULT uuid_generate_v4() NOT NULL, message_id uuid NOT NULL, "position" int4 NOT NULL, dataset_id uuid NOT NULL, dataset_name text NOT NULL, document_id uuid NULL, document_name text NOT NULL, data_source_type text NULL, segment_id uuid NULL, score float8 NULL, "content" text NOT NULL, hit_count int4 NULL, word_count int4 NULL, segment_position int4 NULL, index_node_hash text NULL, retriever_from text NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, CONSTRAINT dataset_retriever_resource_pkey PRIMARY KEY (id));
CREATE INDEX dataset_retriever_resource_message_id_idx ON public.dataset_retriever_resources USING btree (message_id);


-- public.datasets definition

-- Drop table

-- DROP TABLE public.datasets;

CREATE TABLE public.datasets ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, "name" varchar(255) NOT NULL, description text NULL, provider varchar(255) DEFAULT 'vendor'::character varying NOT NULL, "permission" varchar(255) DEFAULT 'only_me'::character varying NOT NULL, data_source_type varchar(255) NULL, indexing_technique varchar(255) NULL, index_struct text NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_by uuid NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, embedding_model varchar(255) DEFAULT 'text-embedding-ada-002'::character varying NULL, embedding_model_provider varchar(255) DEFAULT 'openai'::character varying NULL, collection_binding_id uuid NULL, retrieval_model jsonb NULL, built_in_field_enabled bool DEFAULT false NOT NULL, CONSTRAINT dataset_pkey PRIMARY KEY (id));
CREATE INDEX dataset_tenant_idx ON public.datasets USING btree (tenant_id);
CREATE INDEX retrieval_model_idx ON public.datasets USING gin (retrieval_model);


-- public.dify_setups definition

-- Drop table

-- DROP TABLE public.dify_setups;

CREATE TABLE public.dify_setups ( "version" varchar(255) NOT NULL, setup_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT dify_setup_pkey PRIMARY KEY (version));


-- public.document_segments definition

-- Drop table

-- DROP TABLE public.document_segments;

CREATE TABLE public.document_segments ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, dataset_id uuid NOT NULL, document_id uuid NOT NULL, "position" int4 NOT NULL, "content" text NOT NULL, word_count int4 NOT NULL, tokens int4 NOT NULL, keywords json NULL, index_node_id varchar(255) NULL, index_node_hash varchar(255) NULL, hit_count int4 NOT NULL, enabled bool DEFAULT true NOT NULL, disabled_at timestamp NULL, disabled_by uuid NULL, status varchar(255) DEFAULT 'waiting'::character varying NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, indexing_at timestamp NULL, completed_at timestamp NULL, error text NULL, stopped_at timestamp NULL, answer text NULL, updated_by uuid NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT document_segment_pkey PRIMARY KEY (id));
CREATE INDEX document_segment_dataset_id_idx ON public.document_segments USING btree (dataset_id);
CREATE INDEX document_segment_document_id_idx ON public.document_segments USING btree (document_id);
CREATE INDEX document_segment_node_dataset_idx ON public.document_segments USING btree (index_node_id, dataset_id);
CREATE INDEX document_segment_tenant_dataset_idx ON public.document_segments USING btree (dataset_id, tenant_id);
CREATE INDEX document_segment_tenant_document_idx ON public.document_segments USING btree (document_id, tenant_id);
CREATE INDEX document_segment_tenant_idx ON public.document_segments USING btree (tenant_id);


-- public.documents definition

-- Drop table

-- DROP TABLE public.documents;

CREATE TABLE public.documents ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, dataset_id uuid NOT NULL, "position" int4 NOT NULL, data_source_type varchar(255) NOT NULL, data_source_info text NULL, dataset_process_rule_id uuid NULL, batch varchar(255) NOT NULL, "name" varchar(255) NOT NULL, created_from varchar(255) NOT NULL, created_by uuid NOT NULL, created_api_request_id uuid NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, processing_started_at timestamp NULL, file_id text NULL, word_count int4 NULL, parsing_completed_at timestamp NULL, cleaning_completed_at timestamp NULL, splitting_completed_at timestamp NULL, tokens int4 NULL, indexing_latency float8 NULL, completed_at timestamp NULL, is_paused bool DEFAULT false NULL, paused_by uuid NULL, paused_at timestamp NULL, error text NULL, stopped_at timestamp NULL, indexing_status varchar(255) DEFAULT 'waiting'::character varying NOT NULL, enabled bool DEFAULT true NOT NULL, disabled_at timestamp NULL, disabled_by uuid NULL, archived bool DEFAULT false NOT NULL, archived_reason varchar(255) NULL, archived_by uuid NULL, archived_at timestamp NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, doc_type varchar(40) NULL, doc_metadata jsonb NULL, doc_form varchar(255) DEFAULT 'text_model'::character varying NOT NULL, doc_language varchar(255) NULL, CONSTRAINT document_pkey PRIMARY KEY (id));
CREATE INDEX document_dataset_id_idx ON public.documents USING btree (dataset_id);
CREATE INDEX document_is_paused_idx ON public.documents USING btree (is_paused);
CREATE INDEX document_metadata_idx ON public.documents USING gin (doc_metadata);
CREATE INDEX document_tenant_idx ON public.documents USING btree (tenant_id);


-- public.embeddings definition

-- Drop table

-- DROP TABLE public.embeddings;

CREATE TABLE public.embeddings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, hash varchar(64) NOT NULL, embedding bytea NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, model_name varchar(255) DEFAULT 'text-embedding-ada-002'::character varying NOT NULL, provider_name varchar(255) DEFAULT ''::character varying NOT NULL, CONSTRAINT embedding_hash_idx UNIQUE (model_name, hash, provider_name), CONSTRAINT embedding_pkey PRIMARY KEY (id));
CREATE INDEX created_at_idx ON public.embeddings USING btree (created_at);


-- public.end_users definition

-- Drop table

-- DROP TABLE public.end_users;

CREATE TABLE public.end_users ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, app_id uuid NULL, "type" varchar(255) NOT NULL, external_user_id varchar(255) NULL, "name" varchar(255) NULL, is_anonymous bool DEFAULT true NOT NULL, session_id varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT end_user_pkey PRIMARY KEY (id));
CREATE INDEX end_user_session_id_idx ON public.end_users USING btree (session_id, type);
CREATE INDEX end_user_tenant_session_id_idx ON public.end_users USING btree (tenant_id, session_id, type);


-- public.external_knowledge_apis definition

-- Drop table

-- DROP TABLE public.external_knowledge_apis;

CREATE TABLE public.external_knowledge_apis ( id uuid DEFAULT uuid_generate_v4() NOT NULL, "name" varchar(255) NOT NULL, description varchar(255) NOT NULL, tenant_id uuid NOT NULL, settings text NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_by uuid NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT external_knowledge_apis_pkey PRIMARY KEY (id));
CREATE INDEX external_knowledge_apis_name_idx ON public.external_knowledge_apis USING btree (name);
CREATE INDEX external_knowledge_apis_tenant_idx ON public.external_knowledge_apis USING btree (tenant_id);


-- public.external_knowledge_bindings definition

-- Drop table

-- DROP TABLE public.external_knowledge_bindings;

CREATE TABLE public.external_knowledge_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, external_knowledge_api_id uuid NOT NULL, dataset_id uuid NOT NULL, external_knowledge_id text NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_by uuid NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT external_knowledge_bindings_pkey PRIMARY KEY (id));
CREATE INDEX external_knowledge_bindings_dataset_idx ON public.external_knowledge_bindings USING btree (dataset_id);
CREATE INDEX external_knowledge_bindings_external_knowledge_api_idx ON public.external_knowledge_bindings USING btree (external_knowledge_api_id);
CREATE INDEX external_knowledge_bindings_external_knowledge_idx ON public.external_knowledge_bindings USING btree (external_knowledge_id);
CREATE INDEX external_knowledge_bindings_tenant_idx ON public.external_knowledge_bindings USING btree (tenant_id);


-- public.installed_apps definition

-- Drop table

-- DROP TABLE public.installed_apps;

CREATE TABLE public.installed_apps ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, app_id uuid NOT NULL, app_owner_tenant_id uuid NOT NULL, "position" int4 NOT NULL, is_pinned bool DEFAULT false NOT NULL, last_used_at timestamp NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT installed_app_pkey PRIMARY KEY (id), CONSTRAINT unique_tenant_app UNIQUE (tenant_id, app_id));
CREATE INDEX installed_app_app_id_idx ON public.installed_apps USING btree (app_id);
CREATE INDEX installed_app_tenant_id_idx ON public.installed_apps USING btree (tenant_id);


-- public.invitation_codes definition

-- Drop table

-- DROP TABLE public.invitation_codes;

CREATE TABLE public.invitation_codes ( id serial4 NOT NULL, batch varchar(255) NOT NULL, code varchar(32) NOT NULL, status varchar(16) DEFAULT 'unused'::character varying NOT NULL, used_at timestamp NULL, used_by_tenant_id uuid NULL, used_by_account_id uuid NULL, deprecated_at timestamp NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT invitation_code_pkey PRIMARY KEY (id));
CREATE INDEX invitation_codes_batch_idx ON public.invitation_codes USING btree (batch);
CREATE INDEX invitation_codes_code_idx ON public.invitation_codes USING btree (code, status);


-- public.load_balancing_model_configs definition

-- Drop table

-- DROP TABLE public.load_balancing_model_configs;

CREATE TABLE public.load_balancing_model_configs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, model_name varchar(255) NOT NULL, model_type varchar(40) NOT NULL, "name" varchar(255) NOT NULL, encrypted_config text NULL, enabled bool DEFAULT true NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT load_balancing_model_config_pkey PRIMARY KEY (id));
CREATE INDEX load_balancing_model_config_tenant_provider_model_idx ON public.load_balancing_model_configs USING btree (tenant_id, provider_name, model_type);


-- public.message_agent_thoughts definition

-- Drop table

-- DROP TABLE public.message_agent_thoughts;

CREATE TABLE public.message_agent_thoughts ( id uuid DEFAULT uuid_generate_v4() NOT NULL, message_id uuid NOT NULL, message_chain_id uuid NULL, "position" int4 NOT NULL, thought text NULL, tool text NULL, tool_input text NULL, observation text NULL, tool_process_data text NULL, message text NULL, message_token int4 NULL, message_unit_price numeric NULL, answer text NULL, answer_token int4 NULL, answer_unit_price numeric NULL, tokens int4 NULL, total_price numeric NULL, currency varchar NULL, latency float8 NULL, created_by_role varchar NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, message_price_unit numeric(10, 7) DEFAULT 0.001 NOT NULL, answer_price_unit numeric(10, 7) DEFAULT 0.001 NOT NULL, message_files text NULL, tool_labels_str text DEFAULT '{}'::text NOT NULL, tool_meta_str text DEFAULT '{}'::text NOT NULL, CONSTRAINT message_agent_thought_pkey PRIMARY KEY (id));
CREATE INDEX message_agent_thought_message_chain_id_idx ON public.message_agent_thoughts USING btree (message_chain_id);
CREATE INDEX message_agent_thought_message_id_idx ON public.message_agent_thoughts USING btree (message_id);


-- public.message_annotations definition

-- Drop table

-- DROP TABLE public.message_annotations;

CREATE TABLE public.message_annotations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, conversation_id uuid NULL, message_id uuid NULL, "content" text NOT NULL, account_id uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, question text NULL, hit_count int4 DEFAULT 0 NOT NULL, CONSTRAINT message_annotation_pkey PRIMARY KEY (id));
CREATE INDEX message_annotation_app_idx ON public.message_annotations USING btree (app_id);
CREATE INDEX message_annotation_conversation_idx ON public.message_annotations USING btree (conversation_id);
CREATE INDEX message_annotation_message_idx ON public.message_annotations USING btree (message_id);


-- public.message_chains definition

-- Drop table

-- DROP TABLE public.message_chains;

CREATE TABLE public.message_chains ( id uuid DEFAULT uuid_generate_v4() NOT NULL, message_id uuid NOT NULL, "type" varchar(255) NOT NULL, "input" text NULL, "output" text NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, CONSTRAINT message_chain_pkey PRIMARY KEY (id));
CREATE INDEX message_chain_message_id_idx ON public.message_chains USING btree (message_id);


-- public.message_feedbacks definition

-- Drop table

-- DROP TABLE public.message_feedbacks;

CREATE TABLE public.message_feedbacks ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, conversation_id uuid NOT NULL, message_id uuid NOT NULL, rating varchar(255) NOT NULL, "content" text NULL, from_source varchar(255) NOT NULL, from_end_user_id uuid NULL, from_account_id uuid NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT message_feedback_pkey PRIMARY KEY (id));
CREATE INDEX message_feedback_app_idx ON public.message_feedbacks USING btree (app_id);
CREATE INDEX message_feedback_conversation_idx ON public.message_feedbacks USING btree (conversation_id, from_source, rating);
CREATE INDEX message_feedback_message_idx ON public.message_feedbacks USING btree (message_id, from_source);


-- public.message_files definition

-- Drop table

-- DROP TABLE public.message_files;

CREATE TABLE public.message_files ( id uuid DEFAULT uuid_generate_v4() NOT NULL, message_id uuid NOT NULL, "type" varchar(255) NOT NULL, transfer_method varchar(255) NOT NULL, url text NULL, upload_file_id uuid NULL, created_by_role varchar(255) NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, belongs_to varchar(255) NULL, CONSTRAINT message_file_pkey PRIMARY KEY (id));
CREATE INDEX message_file_created_by_idx ON public.message_files USING btree (created_by);
CREATE INDEX message_file_message_idx ON public.message_files USING btree (message_id);


-- public.messages definition

-- Drop table

-- DROP TABLE public.messages;

CREATE TABLE public.messages ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, model_provider varchar(255) NULL, model_id varchar(255) NULL, override_model_configs text NULL, conversation_id uuid NOT NULL, inputs json NOT NULL, query text NOT NULL, message json NOT NULL, message_tokens int4 DEFAULT 0 NOT NULL, message_unit_price numeric(10, 4) NOT NULL, answer text NOT NULL, answer_tokens int4 DEFAULT 0 NOT NULL, answer_unit_price numeric(10, 4) NOT NULL, provider_response_latency float8 DEFAULT 0 NOT NULL, total_price numeric(10, 7) NULL, currency varchar(255) NOT NULL, from_source varchar(255) NOT NULL, from_end_user_id uuid NULL, from_account_id uuid NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, agent_based bool DEFAULT false NOT NULL, message_price_unit numeric(10, 7) DEFAULT 0.001 NOT NULL, answer_price_unit numeric(10, 7) DEFAULT 0.001 NOT NULL, workflow_run_id uuid NULL, status varchar(255) DEFAULT 'normal'::character varying NOT NULL, error text NULL, message_metadata text NULL, invoke_from varchar(255) NULL, parent_message_id uuid NULL, CONSTRAINT message_pkey PRIMARY KEY (id));
CREATE INDEX message_account_idx ON public.messages USING btree (app_id, from_source, from_account_id);
CREATE INDEX message_app_id_idx ON public.messages USING btree (app_id, created_at);
CREATE INDEX message_conversation_id_idx ON public.messages USING btree (conversation_id);
CREATE INDEX message_created_at_idx ON public.messages USING btree (created_at);
CREATE INDEX message_end_user_idx ON public.messages USING btree (app_id, from_source, from_end_user_id);
CREATE INDEX message_workflow_run_id_idx ON public.messages USING btree (conversation_id, workflow_run_id);


-- public.operation_logs definition

-- Drop table

-- DROP TABLE public.operation_logs;

CREATE TABLE public.operation_logs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, account_id uuid NOT NULL, "action" varchar(255) NOT NULL, "content" json NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, created_ip varchar(255) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT operation_log_pkey PRIMARY KEY (id));
CREATE INDEX operation_log_account_action_idx ON public.operation_logs USING btree (tenant_id, account_id, action);


-- public.pinned_conversations definition

-- Drop table

-- DROP TABLE public.pinned_conversations;

CREATE TABLE public.pinned_conversations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, conversation_id uuid NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, created_by_role varchar(255) DEFAULT 'end_user'::character varying NOT NULL, CONSTRAINT pinned_conversation_pkey PRIMARY KEY (id));
CREATE INDEX pinned_conversation_conversation_idx ON public.pinned_conversations USING btree (app_id, conversation_id, created_by_role, created_by);


-- public.provider_model_settings definition

-- Drop table

-- DROP TABLE public.provider_model_settings;

CREATE TABLE public.provider_model_settings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, model_name varchar(255) NOT NULL, model_type varchar(40) NOT NULL, enabled bool DEFAULT true NOT NULL, load_balancing_enabled bool DEFAULT false NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT provider_model_setting_pkey PRIMARY KEY (id));
CREATE INDEX provider_model_setting_tenant_provider_model_idx ON public.provider_model_settings USING btree (tenant_id, provider_name, model_type);


-- public.provider_models definition

-- Drop table

-- DROP TABLE public.provider_models;

CREATE TABLE public.provider_models ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, model_name varchar(255) NOT NULL, model_type varchar(40) NOT NULL, encrypted_config text NULL, is_valid bool DEFAULT false NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT provider_model_pkey PRIMARY KEY (id), CONSTRAINT unique_provider_model_name UNIQUE (tenant_id, provider_name, model_name, model_type));
CREATE INDEX provider_model_tenant_id_provider_idx ON public.provider_models USING btree (tenant_id, provider_name);


-- public.provider_orders definition

-- Drop table

-- DROP TABLE public.provider_orders;

CREATE TABLE public.provider_orders ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, account_id uuid NOT NULL, payment_product_id varchar(191) NOT NULL, payment_id varchar(191) NULL, transaction_id varchar(191) NULL, quantity int4 DEFAULT 1 NOT NULL, currency varchar(40) NULL, total_amount int4 NULL, payment_status varchar(40) DEFAULT 'wait_pay'::character varying NOT NULL, paid_at timestamp NULL, pay_failed_at timestamp NULL, refunded_at timestamp NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT provider_order_pkey PRIMARY KEY (id));
CREATE INDEX provider_order_tenant_provider_idx ON public.provider_orders USING btree (tenant_id, provider_name);


-- public.providers definition

-- Drop table

-- DROP TABLE public.providers;

CREATE TABLE public.providers ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, provider_type varchar(40) DEFAULT 'custom'::character varying NOT NULL, encrypted_config text NULL, is_valid bool DEFAULT false NOT NULL, last_used timestamp NULL, quota_type varchar(40) DEFAULT ''::character varying NULL, quota_limit int8 NULL, quota_used int8 NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT provider_pkey PRIMARY KEY (id), CONSTRAINT unique_provider_name_type_quota UNIQUE (tenant_id, provider_name, provider_type, quota_type));
CREATE INDEX provider_tenant_id_provider_idx ON public.providers USING btree (tenant_id, provider_name);


-- public.rate_limit_logs definition

-- Drop table

-- DROP TABLE public.rate_limit_logs;

CREATE TABLE public.rate_limit_logs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, subscription_plan varchar(255) NOT NULL, operation varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT rate_limit_log_pkey PRIMARY KEY (id));
CREATE INDEX rate_limit_log_operation_idx ON public.rate_limit_logs USING btree (operation);
CREATE INDEX rate_limit_log_tenant_idx ON public.rate_limit_logs USING btree (tenant_id);


-- public.recommended_apps definition

-- Drop table

-- DROP TABLE public.recommended_apps;

CREATE TABLE public.recommended_apps ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, description json NOT NULL, copyright varchar(255) NOT NULL, privacy_policy varchar(255) NOT NULL, category varchar(255) NOT NULL, "position" int4 NOT NULL, is_listed bool NOT NULL, install_count int4 NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, "language" varchar(255) DEFAULT 'en-US'::character varying NOT NULL, custom_disclaimer text NOT NULL, CONSTRAINT recommended_app_pkey PRIMARY KEY (id));
CREATE INDEX recommended_app_app_id_idx ON public.recommended_apps USING btree (app_id);
CREATE INDEX recommended_app_is_listed_idx ON public.recommended_apps USING btree (is_listed, language);


-- public.saved_messages definition

-- Drop table

-- DROP TABLE public.saved_messages;

CREATE TABLE public.saved_messages ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, message_id uuid NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, created_by_role varchar(255) DEFAULT 'end_user'::character varying NOT NULL, CONSTRAINT saved_message_pkey PRIMARY KEY (id));
CREATE INDEX saved_message_message_idx ON public.saved_messages USING btree (app_id, message_id, created_by_role, created_by);


-- public.sites definition

-- Drop table

-- DROP TABLE public.sites;

CREATE TABLE public.sites ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, title varchar(255) NOT NULL, icon varchar(255) NULL, icon_background varchar(255) NULL, description text NULL, default_language varchar(255) NOT NULL, copyright varchar(255) NULL, privacy_policy varchar(255) NULL, customize_domain varchar(255) NULL, customize_token_strategy varchar(255) NOT NULL, prompt_public bool DEFAULT false NOT NULL, status varchar(255) DEFAULT 'normal'::character varying NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, code varchar(255) NULL, custom_disclaimer text NOT NULL, show_workflow_steps bool DEFAULT true NOT NULL, chat_color_theme varchar(255) NULL, chat_color_theme_inverted bool DEFAULT false NOT NULL, icon_type varchar(255) NULL, created_by uuid NULL, updated_by uuid NULL, use_icon_as_answer_icon bool DEFAULT false NOT NULL, CONSTRAINT site_pkey PRIMARY KEY (id));
CREATE INDEX site_app_id_idx ON public.sites USING btree (app_id);
CREATE INDEX site_code_idx ON public.sites USING btree (code, status);


-- public.tag_bindings definition

-- Drop table

-- DROP TABLE public.tag_bindings;

CREATE TABLE public.tag_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NULL, tag_id uuid NULL, target_id uuid NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tag_binding_pkey PRIMARY KEY (id));
CREATE INDEX tag_bind_tag_id_idx ON public.tag_bindings USING btree (tag_id);
CREATE INDEX tag_bind_target_id_idx ON public.tag_bindings USING btree (target_id);


-- public.tags definition

-- Drop table

-- DROP TABLE public.tags;

CREATE TABLE public.tags ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NULL, "type" varchar(16) NOT NULL, "name" varchar(255) NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tag_pkey PRIMARY KEY (id));
CREATE INDEX tag_name_idx ON public.tags USING btree (name);
CREATE INDEX tag_type_idx ON public.tags USING btree (type);


-- public.tenant_account_joins definition

-- Drop table

-- DROP TABLE public.tenant_account_joins;

CREATE TABLE public.tenant_account_joins ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, account_id uuid NOT NULL, "role" varchar(16) DEFAULT 'normal'::character varying NOT NULL, invited_by uuid NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, "current" bool DEFAULT false NOT NULL, CONSTRAINT tenant_account_join_pkey PRIMARY KEY (id), CONSTRAINT unique_tenant_account_join UNIQUE (tenant_id, account_id));
CREATE INDEX tenant_account_join_account_id_idx ON public.tenant_account_joins USING btree (account_id);
CREATE INDEX tenant_account_join_tenant_id_idx ON public.tenant_account_joins USING btree (tenant_id);


-- public.tenant_default_models definition

-- Drop table

-- DROP TABLE public.tenant_default_models;

CREATE TABLE public.tenant_default_models ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, model_name varchar(255) NOT NULL, model_type varchar(40) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tenant_default_model_pkey PRIMARY KEY (id));
CREATE INDEX tenant_default_model_tenant_id_provider_type_idx ON public.tenant_default_models USING btree (tenant_id, provider_name, model_type);


-- public.tenant_preferred_model_providers definition

-- Drop table

-- DROP TABLE public.tenant_preferred_model_providers;

CREATE TABLE public.tenant_preferred_model_providers ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, provider_name varchar(255) NOT NULL, preferred_provider_type varchar(40) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tenant_preferred_model_provider_pkey PRIMARY KEY (id));
CREATE INDEX tenant_preferred_model_provider_tenant_provider_idx ON public.tenant_preferred_model_providers USING btree (tenant_id, provider_name);


-- public.tenants definition

-- Drop table

-- DROP TABLE public.tenants;

CREATE TABLE public.tenants ( id uuid DEFAULT uuid_generate_v4() NOT NULL, "name" varchar(255) NOT NULL, encrypt_public_key text NULL, plan varchar(255) DEFAULT 'basic'::character varying NOT NULL, status varchar(255) DEFAULT 'normal'::character varying NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, custom_config text NULL, CONSTRAINT tenant_pkey PRIMARY KEY (id));


-- public.tidb_auth_bindings definition

-- Drop table

-- DROP TABLE public.tidb_auth_bindings;

CREATE TABLE public.tidb_auth_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NULL, cluster_id varchar(255) NOT NULL, cluster_name varchar(255) NOT NULL, active bool DEFAULT false NOT NULL, status varchar(255) DEFAULT 'CREATING'::character varying NOT NULL, account varchar(255) NOT NULL, "password" varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tidb_auth_bindings_pkey PRIMARY KEY (id));
CREATE INDEX tidb_auth_bindings_active_idx ON public.tidb_auth_bindings USING btree (active);
CREATE INDEX tidb_auth_bindings_created_at_idx ON public.tidb_auth_bindings USING btree (created_at);
CREATE INDEX tidb_auth_bindings_status_idx ON public.tidb_auth_bindings USING btree (status);
CREATE INDEX tidb_auth_bindings_tenant_idx ON public.tidb_auth_bindings USING btree (tenant_id);


-- public.tool_api_providers definition

-- Drop table

-- DROP TABLE public.tool_api_providers;

CREATE TABLE public.tool_api_providers ( id uuid DEFAULT uuid_generate_v4() NOT NULL, "name" varchar(255) NOT NULL, "schema" text NOT NULL, schema_type_str varchar(40) NOT NULL, user_id uuid NOT NULL, tenant_id uuid NOT NULL, tools_str text NOT NULL, icon varchar(255) NOT NULL, credentials_str text NOT NULL, description text NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, privacy_policy varchar(255) NULL, custom_disclaimer text NOT NULL, CONSTRAINT tool_api_provider_pkey PRIMARY KEY (id), CONSTRAINT unique_api_tool_provider UNIQUE (name, tenant_id));


-- public.tool_builtin_providers definition

-- Drop table

-- DROP TABLE public.tool_builtin_providers;

CREATE TABLE public.tool_builtin_providers ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NULL, user_id uuid NOT NULL, provider varchar(256) NOT NULL, encrypted_credentials text NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tool_builtin_provider_pkey PRIMARY KEY (id), CONSTRAINT unique_builtin_tool_provider UNIQUE (tenant_id, provider));


-- public.tool_conversation_variables definition

-- Drop table

-- DROP TABLE public.tool_conversation_variables;

CREATE TABLE public.tool_conversation_variables ( id uuid DEFAULT uuid_generate_v4() NOT NULL, user_id uuid NOT NULL, tenant_id uuid NOT NULL, conversation_id uuid NOT NULL, variables_str text NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tool_conversation_variables_pkey PRIMARY KEY (id));
CREATE INDEX conversation_id_idx ON public.tool_conversation_variables USING btree (conversation_id);
CREATE INDEX user_id_idx ON public.tool_conversation_variables USING btree (user_id);


-- public.tool_files definition

-- Drop table

-- DROP TABLE public.tool_files;

CREATE TABLE public.tool_files ( id uuid DEFAULT uuid_generate_v4() NOT NULL, user_id uuid NOT NULL, tenant_id uuid NOT NULL, conversation_id uuid NULL, file_key varchar(255) NOT NULL, mimetype varchar(255) NOT NULL, original_url varchar(2048) NULL, "name" varchar NOT NULL, "size" int4 NOT NULL, CONSTRAINT tool_file_pkey PRIMARY KEY (id));
CREATE INDEX tool_file_conversation_id_idx ON public.tool_files USING btree (conversation_id);


-- public.tool_label_bindings definition

-- Drop table

-- DROP TABLE public.tool_label_bindings;

CREATE TABLE public.tool_label_bindings ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tool_id varchar(64) NOT NULL, tool_type varchar(40) NOT NULL, label_name varchar(40) NOT NULL, CONSTRAINT tool_label_bind_pkey PRIMARY KEY (id), CONSTRAINT unique_tool_label_bind UNIQUE (tool_id, label_name));


-- public.tool_model_invokes definition

-- Drop table

-- DROP TABLE public.tool_model_invokes;

CREATE TABLE public.tool_model_invokes ( id uuid DEFAULT uuid_generate_v4() NOT NULL, user_id uuid NOT NULL, tenant_id uuid NOT NULL, provider varchar(255) NOT NULL, tool_type varchar(40) NOT NULL, tool_name varchar(40) NOT NULL, model_parameters text NOT NULL, prompt_messages text NOT NULL, model_response text NOT NULL, prompt_tokens int4 DEFAULT 0 NOT NULL, answer_tokens int4 DEFAULT 0 NOT NULL, answer_unit_price numeric(10, 4) NOT NULL, answer_price_unit numeric(10, 7) DEFAULT 0.001 NOT NULL, provider_response_latency float8 DEFAULT 0 NOT NULL, total_price numeric(10, 7) NULL, currency varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT tool_model_invoke_pkey PRIMARY KEY (id));


-- public.tool_workflow_providers definition

-- Drop table

-- DROP TABLE public.tool_workflow_providers;

CREATE TABLE public.tool_workflow_providers ( id uuid DEFAULT uuid_generate_v4() NOT NULL, "name" varchar(255) NOT NULL, icon varchar(255) NOT NULL, app_id uuid NOT NULL, user_id uuid NOT NULL, tenant_id uuid NOT NULL, description text NOT NULL, parameter_configuration text DEFAULT '[]'::text NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, privacy_policy varchar(255) DEFAULT ''::character varying NULL, "version" varchar(255) DEFAULT ''::character varying NOT NULL, "label" varchar(255) DEFAULT ''::character varying NOT NULL, CONSTRAINT tool_workflow_provider_pkey PRIMARY KEY (id), CONSTRAINT unique_workflow_tool_provider UNIQUE (name, tenant_id), CONSTRAINT unique_workflow_tool_provider_app_id UNIQUE (tenant_id, app_id));


-- public.trace_app_config definition

-- Drop table

-- DROP TABLE public.trace_app_config;

CREATE TABLE public.trace_app_config ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, tracing_provider varchar(255) NULL, tracing_config json NULL, created_at timestamp DEFAULT now() NOT NULL, updated_at timestamp DEFAULT now() NOT NULL, is_active bool DEFAULT true NOT NULL, CONSTRAINT trace_app_config_pkey PRIMARY KEY (id));
CREATE INDEX trace_app_config_app_id_idx ON public.trace_app_config USING btree (app_id);


-- public.upload_files definition

-- Drop table

-- DROP TABLE public.upload_files;

CREATE TABLE public.upload_files ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, storage_type varchar(255) NOT NULL, "key" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "size" int4 NOT NULL, "extension" varchar(255) NOT NULL, mime_type varchar(255) NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, used bool DEFAULT false NOT NULL, used_by uuid NULL, used_at timestamp NULL, hash varchar(255) NULL, created_by_role varchar(255) DEFAULT 'account'::character varying NOT NULL, source_url text DEFAULT ''::character varying NOT NULL, CONSTRAINT upload_file_pkey PRIMARY KEY (id));
CREATE INDEX upload_file_tenant_idx ON public.upload_files USING btree (tenant_id);


-- public.whitelists definition

-- Drop table

-- DROP TABLE public.whitelists;

CREATE TABLE public.whitelists ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NULL, category varchar(255) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT whitelists_pkey PRIMARY KEY (id));
CREATE INDEX whitelists_tenant_idx ON public.whitelists USING btree (tenant_id);


-- public.workflow_app_logs definition

-- Drop table

-- DROP TABLE public.workflow_app_logs;

CREATE TABLE public.workflow_app_logs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, app_id uuid NOT NULL, workflow_id uuid NOT NULL, workflow_run_id uuid NOT NULL, created_from varchar(255) NOT NULL, created_by_role varchar(255) NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT workflow_app_log_pkey PRIMARY KEY (id));
CREATE INDEX workflow_app_log_app_idx ON public.workflow_app_logs USING btree (tenant_id, app_id);


-- public.workflow_conversation_variables definition

-- Drop table

-- DROP TABLE public.workflow_conversation_variables;

CREATE TABLE public.workflow_conversation_variables ( id uuid NOT NULL, conversation_id uuid NOT NULL, app_id uuid NOT NULL, "data" text NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, CONSTRAINT workflow__conversation_variables_pkey PRIMARY KEY (id, conversation_id));
CREATE INDEX workflow_conversation_variables_app_id_idx ON public.workflow_conversation_variables USING btree (app_id);
CREATE INDEX workflow_conversation_variables_created_at_idx ON public.workflow_conversation_variables USING btree (created_at);


-- public.workflow_node_executions definition

-- Drop table

-- DROP TABLE public.workflow_node_executions;

CREATE TABLE public.workflow_node_executions ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, app_id uuid NOT NULL, workflow_id uuid NOT NULL, triggered_from varchar(255) NOT NULL, workflow_run_id uuid NULL, "index" int4 NOT NULL, predecessor_node_id varchar(255) NULL, node_id varchar(255) NOT NULL, node_type varchar(255) NOT NULL, title varchar(255) NOT NULL, inputs text NULL, process_data text NULL, outputs text NULL, status varchar(255) NOT NULL, error text NULL, elapsed_time float8 DEFAULT 0 NOT NULL, execution_metadata text NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, created_by_role varchar(255) NOT NULL, created_by uuid NOT NULL, finished_at timestamp NULL, node_execution_id varchar(255) NULL, CONSTRAINT workflow_node_execution_pkey PRIMARY KEY (id));
CREATE INDEX workflow_node_execution_id_idx ON public.workflow_node_executions USING btree (tenant_id, app_id, workflow_id, triggered_from, node_execution_id);
CREATE INDEX workflow_node_execution_node_run_idx ON public.workflow_node_executions USING btree (tenant_id, app_id, workflow_id, triggered_from, node_id);
CREATE INDEX workflow_node_execution_workflow_run_idx ON public.workflow_node_executions USING btree (tenant_id, app_id, workflow_id, triggered_from, workflow_run_id);


-- public.workflow_runs definition

-- Drop table

-- DROP TABLE public.workflow_runs;

CREATE TABLE public.workflow_runs ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, app_id uuid NOT NULL, sequence_number int4 NOT NULL, workflow_id uuid NOT NULL, "type" varchar(255) NOT NULL, triggered_from varchar(255) NOT NULL, "version" varchar(255) NOT NULL, graph text NULL, inputs text NULL, status varchar(255) NOT NULL, outputs text NULL, error text NULL, elapsed_time float8 DEFAULT 0 NOT NULL, total_tokens int8 DEFAULT 0 NOT NULL, total_steps int4 DEFAULT 0 NULL, created_by_role varchar(255) NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, finished_at timestamp NULL, exceptions_count int4 DEFAULT 0 NULL, CONSTRAINT workflow_run_pkey PRIMARY KEY (id));
CREATE INDEX workflow_run_tenant_app_sequence_idx ON public.workflow_runs USING btree (tenant_id, app_id, sequence_number);
CREATE INDEX workflow_run_triggerd_from_idx ON public.workflow_runs USING btree (tenant_id, app_id, triggered_from);


-- public.workflows definition

-- Drop table

-- DROP TABLE public.workflows;

CREATE TABLE public.workflows ( id uuid DEFAULT uuid_generate_v4() NOT NULL, tenant_id uuid NOT NULL, app_id uuid NOT NULL, "type" varchar(255) NOT NULL, "version" varchar(255) NOT NULL, graph text NOT NULL, features text NOT NULL, created_by uuid NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_by uuid NULL, updated_at timestamp NOT NULL, environment_variables text DEFAULT '{}'::text NOT NULL, conversation_variables text DEFAULT '{}'::text NOT NULL, marked_name varchar DEFAULT ''::character varying NOT NULL, marked_comment varchar DEFAULT ''::character varying NOT NULL, CONSTRAINT workflow_pkey PRIMARY KEY (id));
CREATE INDEX workflow_version_idx ON public.workflows USING btree (tenant_id, app_id, version);


-- public.tool_published_apps definition

-- Drop table

-- DROP TABLE public.tool_published_apps;

CREATE TABLE public.tool_published_apps ( id uuid DEFAULT uuid_generate_v4() NOT NULL, app_id uuid NOT NULL, user_id uuid NOT NULL, description text NOT NULL, llm_description text NOT NULL, query_description text NOT NULL, query_name varchar(40) NOT NULL, tool_name varchar(40) NOT NULL, author varchar(40) NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, updated_at timestamp DEFAULT CURRENT_TIMESTAMP(0) NOT NULL, CONSTRAINT published_app_tool_pkey PRIMARY KEY (id), CONSTRAINT unique_published_app_tool UNIQUE (app_id, user_id), CONSTRAINT tool_published_apps_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.apps(id));

