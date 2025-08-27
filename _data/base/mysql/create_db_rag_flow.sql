SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

create database if not exists rag_flow;

use rag_flow;

-- rag_flow.api_4_conversation definition

CREATE TABLE `api_4_conversation` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `dialog_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci,
  `reference` longtext COLLATE utf8mb4_unicode_ci,
  `tokens` int NOT NULL,
  `source` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsl` longtext COLLATE utf8mb4_unicode_ci,
  `duration` float NOT NULL,
  `round` int NOT NULL,
  `thumb_up` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `api4conversation_create_time` (`create_time`),
  KEY `api4conversation_create_date` (`create_date`),
  KEY `api4conversation_update_time` (`update_time`),
  KEY `api4conversation_update_date` (`update_date`),
  KEY `api4conversation_dialog_id` (`dialog_id`),
  KEY `api4conversation_user_id` (`user_id`),
  KEY `api4conversation_source` (`source`),
  KEY `api4conversation_duration` (`duration`),
  KEY `api4conversation_round` (`round`),
  KEY `api4conversation_thumb_up` (`thumb_up`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.api_token definition

CREATE TABLE `api_token` (
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dialog_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `beta` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`tenant_id`,`token`),
  KEY `apitoken_create_time` (`create_time`),
  KEY `apitoken_create_date` (`create_date`),
  KEY `apitoken_update_time` (`update_time`),
  KEY `apitoken_update_date` (`update_date`),
  KEY `apitoken_tenant_id` (`tenant_id`),
  KEY `apitoken_token` (`token`),
  KEY `apitoken_dialog_id` (`dialog_id`),
  KEY `apitoken_source` (`source`),
  KEY `apitoken_beta` (`beta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.canvas_template definition

CREATE TABLE `canvas_template` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `avatar` text COLLATE utf8mb4_unicode_ci,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `canvas_type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsl` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `canvastemplate_create_time` (`create_time`),
  KEY `canvastemplate_create_date` (`create_date`),
  KEY `canvastemplate_update_time` (`update_time`),
  KEY `canvastemplate_update_date` (`update_date`),
  KEY `canvastemplate_canvas_type` (`canvas_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.conversation definition

CREATE TABLE `conversation` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `dialog_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci,
  `reference` longtext COLLATE utf8mb4_unicode_ci,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `conversation_create_time` (`create_time`),
  KEY `conversation_create_date` (`create_date`),
  KEY `conversation_update_time` (`update_time`),
  KEY `conversation_update_date` (`update_date`),
  KEY `conversation_dialog_id` (`dialog_id`),
  KEY `conversation_name` (`name`),
  KEY `conversation_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.dialog definition

CREATE TABLE `dialog` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `icon` text COLLATE utf8mb4_unicode_ci,
  `language` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `llm_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `llm_setting` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `prompt_type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `prompt_config` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `similarity_threshold` float NOT NULL,
  `vector_similarity_weight` float NOT NULL,
  `top_n` int NOT NULL,
  `top_k` int NOT NULL,
  `do_refer` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rerank_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kb_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dialog_create_time` (`create_time`),
  KEY `dialog_create_date` (`create_date`),
  KEY `dialog_update_time` (`update_time`),
  KEY `dialog_update_date` (`update_date`),
  KEY `dialog_tenant_id` (`tenant_id`),
  KEY `dialog_name` (`name`),
  KEY `dialog_language` (`language`),
  KEY `dialog_prompt_type` (`prompt_type`),
  KEY `dialog_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.document definition

CREATE TABLE `document` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `thumbnail` text COLLATE utf8mb4_unicode_ci,
  `kb_id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parser_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parser_config` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int NOT NULL,
  `token_num` int NOT NULL,
  `chunk_num` int NOT NULL,
  `progress` float NOT NULL,
  `progress_msg` text COLLATE utf8mb4_unicode_ci,
  `process_begin_at` datetime DEFAULT NULL,
  `process_duation` float NOT NULL,
  `meta_fields` longtext COLLATE utf8mb4_unicode_ci,
  `run` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `document_create_time` (`create_time`),
  KEY `document_create_date` (`create_date`),
  KEY `document_update_time` (`update_time`),
  KEY `document_update_date` (`update_date`),
  KEY `document_kb_id` (`kb_id`),
  KEY `document_parser_id` (`parser_id`),
  KEY `document_source_type` (`source_type`),
  KEY `document_type` (`type`),
  KEY `document_created_by` (`created_by`),
  KEY `document_name` (`name`),
  KEY `document_location` (`location`),
  KEY `document_size` (`size`),
  KEY `document_token_num` (`token_num`),
  KEY `document_chunk_num` (`chunk_num`),
  KEY `document_progress` (`progress`),
  KEY `document_process_begin_at` (`process_begin_at`),
  KEY `document_run` (`run`),
  KEY `document_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.document_bibl definition

CREATE TABLE `document_bibl` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `kb_id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci,
  `authors` text COLLATE utf8mb4_unicode_ci,
  `booktitle` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pages` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `publisher` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `origin` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `year` int DEFAULT NULL,
  `url` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doi` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `biburl` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bibsource` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timestamp` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pdf_path` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `documentbibl_document_id` (`document_id`),
  KEY `documentbibl_create_time` (`create_time`),
  KEY `documentbibl_create_date` (`create_date`),
  KEY `documentbibl_update_time` (`update_time`),
  KEY `documentbibl_update_date` (`update_date`),
  KEY `documentbibl_kb_id` (`kb_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.document_translation definition

CREATE TABLE `document_translation` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `kb_id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci,
  `abstract` text COLLATE utf8mb4_unicode_ci,
  `authors` text COLLATE utf8mb4_unicode_ci,
  `title_zh` text COLLATE utf8mb4_unicode_ci,
  `abstract_zh` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `documenttranslation_create_time` (`create_time`),
  KEY `documenttranslation_create_date` (`create_date`),
  KEY `documenttranslation_update_time` (`update_time`),
  KEY `documenttranslation_update_date` (`update_date`),
  KEY `documenttranslation_kb_id` (`kb_id`),
  KEY `documenttranslation_document_id` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.file definition

CREATE TABLE `file` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `parent_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `file_create_time` (`create_time`),
  KEY `file_create_date` (`create_date`),
  KEY `file_update_time` (`update_time`),
  KEY `file_update_date` (`update_date`),
  KEY `file_parent_id` (`parent_id`),
  KEY `file_tenant_id` (`tenant_id`),
  KEY `file_created_by` (`created_by`),
  KEY `file_name` (`name`),
  KEY `file_location` (`location`),
  KEY `file_size` (`size`),
  KEY `file_type` (`type`),
  KEY `file_source_type` (`source_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.file2document definition

CREATE TABLE `file2document` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `file_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `document_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `file2document_create_time` (`create_time`),
  KEY `file2document_create_date` (`create_date`),
  KEY `file2document_update_time` (`update_time`),
  KEY `file2document_update_date` (`update_date`),
  KEY `file2document_file_id` (`file_id`),
  KEY `file2document_document_id` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.invitation_code definition

CREATE TABLE `invitation_code` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `code` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `visit_time` datetime DEFAULT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invitationcode_create_time` (`create_time`),
  KEY `invitationcode_create_date` (`create_date`),
  KEY `invitationcode_update_time` (`update_time`),
  KEY `invitationcode_update_date` (`update_date`),
  KEY `invitationcode_code` (`code`),
  KEY `invitationcode_visit_time` (`visit_time`),
  KEY `invitationcode_user_id` (`user_id`),
  KEY `invitationcode_tenant_id` (`tenant_id`),
  KEY `invitationcode_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.knowledgebase definition

CREATE TABLE `knowledgebase` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `avatar` text COLLATE utf8mb4_unicode_ci,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `embd_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `doc_num` int NOT NULL,
  `token_num` int NOT NULL,
  `chunk_num` int NOT NULL,
  `similarity_threshold` float NOT NULL,
  `vector_similarity_weight` float NOT NULL,
  `parser_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parser_config` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `pagerank` int NOT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `knowledgebase_create_time` (`create_time`),
  KEY `knowledgebase_create_date` (`create_date`),
  KEY `knowledgebase_update_time` (`update_time`),
  KEY `knowledgebase_update_date` (`update_date`),
  KEY `knowledgebase_tenant_id` (`tenant_id`),
  KEY `knowledgebase_name` (`name`),
  KEY `knowledgebase_language` (`language`),
  KEY `knowledgebase_embd_id` (`embd_id`),
  KEY `knowledgebase_permission` (`permission`),
  KEY `knowledgebase_created_by` (`created_by`),
  KEY `knowledgebase_doc_num` (`doc_num`),
  KEY `knowledgebase_token_num` (`token_num`),
  KEY `knowledgebase_chunk_num` (`chunk_num`),
  KEY `knowledgebase_similarity_threshold` (`similarity_threshold`),
  KEY `knowledgebase_vector_similarity_weight` (`vector_similarity_weight`),
  KEY `knowledgebase_parser_id` (`parser_id`),
  KEY `knowledgebase_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.llm definition

CREATE TABLE `llm` (
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `llm_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_type` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fid` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_tokens` int NOT NULL,
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_tools` tinyint(1) NOT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`fid`,`llm_name`),
  KEY `llm_create_time` (`create_time`),
  KEY `llm_create_date` (`create_date`),
  KEY `llm_update_time` (`update_time`),
  KEY `llm_update_date` (`update_date`),
  KEY `llm_llm_name` (`llm_name`),
  KEY `llm_model_type` (`model_type`),
  KEY `llm_fid` (`fid`),
  KEY `llm_tags` (`tags`),
  KEY `llm_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.llm_factories definition

CREATE TABLE `llm_factories` (
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `logo` text COLLATE utf8mb4_unicode_ci,
  `tags` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `llmfactories_create_time` (`create_time`),
  KEY `llmfactories_create_date` (`create_date`),
  KEY `llmfactories_update_time` (`update_time`),
  KEY `llmfactories_update_date` (`update_date`),
  KEY `llmfactories_tags` (`tags`),
  KEY `llmfactories_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.task definition

CREATE TABLE `task` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `doc_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_page` int NOT NULL,
  `to_page` int NOT NULL,
  `task_type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int NOT NULL,
  `begin_at` datetime DEFAULT NULL,
  `process_duation` float NOT NULL,
  `progress` float NOT NULL,
  `progress_msg` text COLLATE utf8mb4_unicode_ci,
  `retry_count` int NOT NULL,
  `digest` text COLLATE utf8mb4_unicode_ci,
  `chunk_ids` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `task_create_time` (`create_time`),
  KEY `task_create_date` (`create_date`),
  KEY `task_update_time` (`update_time`),
  KEY `task_update_date` (`update_date`),
  KEY `task_doc_id` (`doc_id`),
  KEY `task_begin_at` (`begin_at`),
  KEY `task_progress` (`progress`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.tenant definition

CREATE TABLE `tenant` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `llm_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `embd_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `asr_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `img2txt_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rerank_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tts_id` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parser_ids` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `credit` int NOT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tenant_create_time` (`create_time`),
  KEY `tenant_create_date` (`create_date`),
  KEY `tenant_update_time` (`update_time`),
  KEY `tenant_update_date` (`update_date`),
  KEY `tenant_name` (`name`),
  KEY `tenant_public_key` (`public_key`),
  KEY `tenant_llm_id` (`llm_id`),
  KEY `tenant_embd_id` (`embd_id`),
  KEY `tenant_asr_id` (`asr_id`),
  KEY `tenant_img2txt_id` (`img2txt_id`),
  KEY `tenant_rerank_id` (`rerank_id`),
  KEY `tenant_tts_id` (`tts_id`),
  KEY `tenant_parser_ids` (`parser_ids`),
  KEY `tenant_credit` (`credit`),
  KEY `tenant_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.tenant_langfuse definition

CREATE TABLE `tenant_langfuse` (
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `secret_key` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `public_key` varchar(2048) COLLATE utf8mb4_unicode_ci NOT NULL,
  `host` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`tenant_id`),
  KEY `tenantlangfuse_create_time` (`create_time`),
  KEY `tenantlangfuse_create_date` (`create_date`),
  KEY `tenantlangfuse_update_time` (`update_time`),
  KEY `tenantlangfuse_update_date` (`update_date`),
  KEY `tenantlangfuse_secret_key` (`secret_key`(768)),
  KEY `tenantlangfuse_public_key` (`public_key`(768)),
  KEY `tenantlangfuse_host` (`host`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.tenant_llm definition

CREATE TABLE `tenant_llm` (
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `llm_factory` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_type` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `llm_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_key` varchar(2048) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_base` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_tokens` int NOT NULL,
  `used_tokens` int NOT NULL,
  PRIMARY KEY (`tenant_id`,`llm_factory`,`llm_name`),
  KEY `tenantllm_create_time` (`create_time`),
  KEY `tenantllm_create_date` (`create_date`),
  KEY `tenantllm_update_time` (`update_time`),
  KEY `tenantllm_update_date` (`update_date`),
  KEY `tenantllm_tenant_id` (`tenant_id`),
  KEY `tenantllm_llm_factory` (`llm_factory`),
  KEY `tenantllm_model_type` (`model_type`),
  KEY `tenantllm_llm_name` (`llm_name`),
  KEY `tenantllm_api_key` (`api_key`(768)),
  KEY `tenantllm_max_tokens` (`max_tokens`),
  KEY `tenantllm_used_tokens` (`used_tokens`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.`user` definition

CREATE TABLE `user` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `access_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nickname` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` text COLLATE utf8mb4_unicode_ci,
  `language` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color_schema` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login_time` datetime DEFAULT NULL,
  `is_authenticated` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_anonymous` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_channel` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_superuser` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_create_time` (`create_time`),
  KEY `user_create_date` (`create_date`),
  KEY `user_update_time` (`update_time`),
  KEY `user_update_date` (`update_date`),
  KEY `user_access_token` (`access_token`),
  KEY `user_nickname` (`nickname`),
  KEY `user_password` (`password`),
  KEY `user_email` (`email`),
  KEY `user_language` (`language`),
  KEY `user_color_schema` (`color_schema`),
  KEY `user_timezone` (`timezone`),
  KEY `user_last_login_time` (`last_login_time`),
  KEY `user_is_authenticated` (`is_authenticated`),
  KEY `user_is_active` (`is_active`),
  KEY `user_is_anonymous` (`is_anonymous`),
  KEY `user_login_channel` (`login_channel`),
  KEY `user_status` (`status`),
  KEY `user_is_superuser` (`is_superuser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.user_canvas definition

CREATE TABLE `user_canvas` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `avatar` text COLLATE utf8mb4_unicode_ci,
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `permission` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `canvas_type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dsl` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `usercanvas_create_time` (`create_time`),
  KEY `usercanvas_create_date` (`create_date`),
  KEY `usercanvas_update_time` (`update_time`),
  KEY `usercanvas_update_date` (`update_date`),
  KEY `usercanvas_user_id` (`user_id`),
  KEY `usercanvas_permission` (`permission`),
  KEY `usercanvas_canvas_type` (`canvas_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.user_canvas_version definition

CREATE TABLE `user_canvas_version` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `user_canvas_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `dsl` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `usercanvasversion_create_time` (`create_time`),
  KEY `usercanvasversion_create_date` (`create_date`),
  KEY `usercanvasversion_update_time` (`update_time`),
  KEY `usercanvasversion_update_date` (`update_date`),
  KEY `usercanvasversion_user_canvas_id` (`user_canvas_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- rag_flow.user_tenant definition

CREATE TABLE `user_tenant` (
  `id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_time` bigint DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_time` bigint DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  `user_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tenant_id` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `invited_by` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usertenant_create_time` (`create_time`),
  KEY `usertenant_create_date` (`create_date`),
  KEY `usertenant_update_time` (`update_time`),
  KEY `usertenant_update_date` (`update_date`),
  KEY `usertenant_user_id` (`user_id`),
  KEY `usertenant_tenant_id` (`tenant_id`),
  KEY `usertenant_role` (`role`),
  KEY `usertenant_invited_by` (`invited_by`),
  KEY `usertenant_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;