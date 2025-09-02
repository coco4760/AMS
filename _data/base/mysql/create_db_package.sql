
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

create database if not exists package;

use package;

-- package.product_info definition

CREATE TABLE `product_info` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `vendor` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '厂商',
  `product` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品',
  `home_page` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '首页',
  `repository_url` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '仓库主页',
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '类别',
  `summary` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '摘要',
  `license` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '许可证',
  `license_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '许可证',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '描述',
  `published_time` datetime(6) DEFAULT NULL COMMENT '上次发布时间',
  `tags` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '标签',
  `rank` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT '评分',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'openhub' COMMENT '来源',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `product_name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '产品名称',
  `repository_urls` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '仓库主页(多个)',
  `summary_cn` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '中文摘要',
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_info_product_vendor_99e80f7a_uniq` (`vendor`,`product`),
  KEY `product_info_create_time_dc580b6b` (`create_time`) USING BTREE,
  KEY `product_info_modify_time_f1cb4b6e` (`modify_time`) USING BTREE,
  KEY `product_info_rank_c40ca813` (`rank`) USING BTREE,
  KEY `product_info_license_key` (`license_key`),
  KEY `product_info_description` (`description`(100)),
  KEY `product_info_summary` (`summary`(100)),
  KEY `product_info_license` (`license`(100)),
  KEY `product_info_home_page` (`home_page`(100))
) ENGINE=InnoDB AUTO_INCREMENT=58078902 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='软件/产品info信息';


-- package.vul_cwe definition

CREATE TABLE `vul_cwe` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `cwe_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞分类标识',
  `title_en` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '英文标题',
  `title_cn` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '中文标题',
  `description_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文描述',
  `description_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文描述',
  `applicable_platforms_languages` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '适用平台语言',
  `extended_description` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '扩展描述',
  `likelihood_of_exploit` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '利用可能性',
  `observed_examples` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT 'CVE示例',
  `detection_methods` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '检测方法',
  `error_code_example` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '错误示例',
  `repair_suggestions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '修复建议',
  `common_consequences` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '常见后果',
  `keywords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '关键字',
  `correct_code_example` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '正确示例',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `cwe_id` (`cwe_id`) USING BTREE,
  KEY `vul_cwe_create_time_9942c2b5` (`create_time`) USING BTREE,
  KEY `vul_cwe_modify_time_9bd96ebf` (`modify_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=231050 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞分类';


-- package.vul_extinfo definition

CREATE TABLE `vul_extinfo` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '来源类型',
  `cve_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cve_id',
  `ext_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '扩展类型',
  `ext_key` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '扩展标识',
  `title` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '标题',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '描述',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '详情',
  `file_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件链接',
  `file_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件类型',
  `submit_time` datetime(6) DEFAULT NULL COMMENT '提交时间',
  `published_time` datetime(6) DEFAULT NULL COMMENT '公开时间',
  `modified_time` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_extinfo_source_type_ext_key_source_id_eeb9d988_uniq` (`source_type`,`ext_key`,`source_id`) USING BTREE,
  KEY `vul_extinfo_create_time_c532fdcf` (`create_time`) USING BTREE,
  KEY `vul_extinfo_modify_time_f064a375` (`modify_time`) USING BTREE,
  KEY `vul_extinfo_source_id_bd526c8f` (`source_id`) USING BTREE,
  KEY `vul_extinfo_cve_id_0b3b1f3e` (`cve_id`) USING BTREE,
  KEY `vul_extinfo_ext_key_cbfc5a62` (`ext_key`) USING BTREE,
  KEY `vul_extinfo_vul_id_df33c07d` (`vul_id`) USING BTREE,
  KEY `vul_extinfo_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11447938 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='扩展信息';


-- package.vul_info definition

CREATE TABLE `vul_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '云起漏洞标识',
  `cve_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cve_id',
  `cnvd_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cnvd_id',
  `cnnvd_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cnnvd_id',
  `is_open_source` tinyint(1) DEFAULT NULL COMMENT '是否开源',
  `verify_status` int NOT NULL DEFAULT '10' COMMENT '审核状态',
  `first_verify_time` datetime(6) DEFAULT NULL COMMENT '首次审核时间',
  `verify_time` datetime(6) DEFAULT NULL COMMENT '审核时间',
  `title_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文标题',
  `title_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文标题',
  `description_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文描述',
  `description_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文描述',
  `submit_time` datetime(6) DEFAULT NULL COMMENT '提交时间',
  `published_time` datetime(6) DEFAULT NULL COMMENT '公开时间',
  `modified_time` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `cvss2_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss2向量字符串',
  `cvss2_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss2分数',
  `cvss3_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss3向量字符串',
  `cvss3_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss3分数',
  `severity` int NOT NULL DEFAULT '0' COMMENT '危险等级',
  `solution_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文修复方案',
  `solution_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文修复方案',
  `relieve_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文缓解措施',
  `relieve_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文缓解措施',
  `modified_user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '最后修改人',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '首次来源',
  `flag` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '批次',
  `cwes` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '漏洞类型',
  `level` int NOT NULL DEFAULT '0' COMMENT '利用级别',
  PRIMARY KEY (`id`),
  UNIQUE KEY `vul_id` (`vul_id`),
  KEY `vul_info_create_time_e8b28807` (`create_time`),
  KEY `vul_info_modify_time_dec48afe` (`modify_time`),
  KEY `vul_info_cve_id_2cf73774` (`cve_id`),
  KEY `vul_info_cnvd_id_62f898e4` (`cnvd_id`),
  KEY `vul_info_cnnvd_id_6ba21fc3` (`cnnvd_id`),
  KEY `vul_info_severity` (`severity`),
  KEY `vul_info_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4906042 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='漏洞';


-- package.vul_infohistory definition

CREATE TABLE `vul_infohistory` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '操作人',
  `change` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '修改内容',
  `remark` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '修改备注',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `vul_infohistory_create_time_b7624ed5` (`create_time`) USING BTREE,
  KEY `vul_infohistory_modify_time_e0353f92` (`modify_time`) USING BTREE,
  KEY `vul_infohistory_vul_id_7ffbcd78` (`vul_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞修改历史';


-- package.vul_package definition

CREATE TABLE `vul_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `match` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '匹配原始串',
  `affected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '受影响版本表达式()',
  `unaffected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '安全版本表达式()',
  `cve_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cve_id',
  `title_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文标题',
  `title_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文标题',
  `description_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文描述',
  `description_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文描述',
  `submit_time` datetime(6) DEFAULT NULL COMMENT '提交时间',
  `published_time` datetime(6) DEFAULT NULL COMMENT '公开时间',
  `modified_time` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `cvss2_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss2向量字符串',
  `cvss2_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss2分数',
  `cvss3_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss3向量字符串',
  `cvss3_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss3分数',
  `severity` int NOT NULL DEFAULT '0' COMMENT '危险等级',
  `solution_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文修复方案',
  `solution_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文修复方案',
  `relieve_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '中文缓解措施',
  `relieve_en` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '英文缓解措施',
  `cwes` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '漏洞类型',
  `verify_status` int NOT NULL DEFAULT '10' COMMENT '审核状态',
  `first_verify_time` datetime(6) DEFAULT NULL COMMENT '首次审核时间',
  `verify_time` datetime(6) DEFAULT NULL COMMENT '审核时间',
  `modified_user_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '最后修改人',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '首次来源',
  `flag` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '批次',
  `pkg_vul_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '组件漏洞标识',
  `affect_package_id` bigint DEFAULT NULL COMMENT '受影响组件',
  `affect_package_name` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '受影响组件名',
  `affect_package_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '受影响类型',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `pkg_vul_id` (`pkg_vul_id`) USING BTREE,
  UNIQUE KEY `vul_package_vul_id_affect_package_id_765a60eb_uniq` (`vul_id`,`affect_package_id`) USING BTREE,
  KEY `vul_package_create_time_d7fd22f8` (`create_time`) USING BTREE,
  KEY `vul_package_modify_time_baa3ff0a` (`modify_time`) USING BTREE,
  KEY `vul_package_cve_id_58667219` (`cve_id`) USING BTREE,
  KEY `vul_package_affect_package_type_ff2dcecf` (`affect_package_type`) USING BTREE,
  KEY `vul_package_vul_id_7d606d6d` (`vul_id`) USING BTREE,
  KEY `temp_affected_version_expression` (`affected_version_expression`(512)) USING BTREE,
  KEY `vul_packagh_affect_package_id` (`affect_package_id`),
  KEY `vul_package_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6661598 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响组件最终表';


-- package.vul_packageversion definition

CREATE TABLE `vul_packageversion` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `affect_package_id` bigint NOT NULL COMMENT '受影响组件',
  `affect_package_version` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '受影响组件版本',
  `affect_package_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '受影响类型',
  `pkg_vul_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '组件漏洞标识',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_packageversion_affect_package_id_affect_2ce9289e_uniq` (`affect_package_id`,`affect_package_version`,`pkg_vul_id`) USING BTREE,
  KEY `vul_packageversion_create_time_d67167e4` (`create_time`) USING BTREE,
  KEY `vul_packageversion_modify_time_0cd1329f` (`modify_time`) USING BTREE,
  KEY `vul_packageversion_affect_package_type_1f6b4795` (`affect_package_type`) USING BTREE,
  KEY `vul_packageversion_pkg_vul_id_dc5ce7cd` (`pkg_vul_id`) USING BTREE,
  KEY `vul_packageversion_vul_id_8a366853` (`vul_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=128766954 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响组件版本表';


-- package.vul_raw definition

CREATE TABLE `vul_raw` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源类型',
  `cve_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cve_id',
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '标题',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '描述',
  `submit_time` datetime(6) DEFAULT NULL COMMENT '提交时间',
  `published_time` datetime(6) DEFAULT NULL COMMENT '公开时间',
  `modified_time` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `cvss2_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss2向量字符串',
  `cvss2_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss2分数',
  `cvss3_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss3向量字符串',
  `cvss3_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss3分数',
  `severity` int NOT NULL DEFAULT '0' COMMENT '危险等级',
  `solution` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '修复方案',
  `relieve` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '缓解措施',
  `cwes` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '漏洞类型',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '漏洞标识',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_raw_source_id_source_type_bc63a0a7_uniq` (`source_id`,`source_type`) USING BTREE,
  KEY `vul_raw_create_time_cc838441` (`create_time`) USING BTREE,
  KEY `vul_raw_modify_time_e236a647` (`modify_time`) USING BTREE,
  KEY `vul_raw_source_id_da12768d` (`source_id`) USING BTREE,
  KEY `vul_raw_cve_id_c80ab85a` (`cve_id`) USING BTREE,
  KEY `vul_raw_vul_id_15c0bfb2` (`vul_id`) USING BTREE,
  KEY `vul_raw_severity` (`severity`),
  KEY `vul_raw_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13410530 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞原始信息';


-- package.vul_rawpackage definition

CREATE TABLE `vul_rawpackage` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源类型',
  `cve_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cve_id',
  `title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '标题',
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '描述',
  `submit_time` datetime(6) DEFAULT NULL COMMENT '提交时间',
  `published_time` datetime(6) DEFAULT NULL COMMENT '公开时间',
  `modified_time` datetime(6) DEFAULT NULL COMMENT '修改时间',
  `cvss2_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss2向量字符串',
  `cvss2_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss2分数',
  `cvss3_vector` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'cvss3向量字符串',
  `cvss3_base_score` decimal(3,1) NOT NULL DEFAULT '-1.0' COMMENT 'cvss3分数',
  `severity` int NOT NULL DEFAULT '0' COMMENT '危险等级',
  `solution` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '修复方案',
  `relieve` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '缓解措施',
  `cwes` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '漏洞类型',
  `match` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '匹配原始串',
  `affected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '受影响版本表达式()',
  `unaffected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '安全版本表达式()',
  `affect_package_id` bigint DEFAULT NULL COMMENT '受影响组件',
  `affect_package_name` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '受影响组件名',
  `affect_package_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '受影响类型',
  `pkg_vul_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '组件漏洞标识',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_rawpackage_affect_package_id_source_8d89e74b_uniq` (`affect_package_id`,`source_type`,`source_id`) USING BTREE,
  KEY `vul_rawpackage_create_time_a0d71c40` (`create_time`) USING BTREE,
  KEY `vul_rawpackage_modify_time_c031ca9b` (`modify_time`) USING BTREE,
  KEY `vul_rawpackage_source_id_ff609723` (`source_id`) USING BTREE,
  KEY `vul_rawpackage_cve_id_7452d1f1` (`cve_id`) USING BTREE,
  KEY `vul_rawpackage_affect_package_type_9f5ef384` (`affect_package_type`) USING BTREE,
  KEY `vul_rawpackage_pkg_vul_id_3540190d` (`pkg_vul_id`) USING BTREE,
  KEY `vul_rawpackage_vul_id_2accd17c` (`vul_id`) USING BTREE,
  KEY `temp_affected_version_expression` (`affected_version_expression`(512)) USING BTREE,
  KEY `vul_rawpackage_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=192947463 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响组件原始表';


-- package.vul_rawproduct definition

CREATE TABLE `vul_rawproduct` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源类型',
  `vendor_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '厂商名称',
  `product_name` varchar(480) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '产品名称',
  `affect_product_id` bigint DEFAULT NULL COMMENT '关联产品',
  `open_source_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'unknown' COMMENT '开源类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_rawproduct_product_name_vendor_name_ffa41f5a_uniq` (`product_name`,`vendor_name`,`source_type`),
  KEY `vul_rawproduct_create_time_7ebd0946` (`create_time`) USING BTREE,
  KEY `vul_rawproduct_modify_time_f8030f17` (`modify_time`) USING BTREE,
  KEY `vul_rawproduct_source_id_38308db8` (`source_id`) USING BTREE,
  KEY `vul_rawproduct_affect_product_id_fbcc4b8f` (`affect_product_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2587421 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞平台原始软件信息';


-- package.vul_rawrelproduct definition

CREATE TABLE `vul_rawrelproduct` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源类型',
  `match` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '匹配原始串',
  `affected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '受影响版本表达式',
  `unaffected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '安全版本表达式',
  `affect_raw_vendor_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '受影响厂商名称',
  `affect_raw_product_name` varchar(480) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '受影响产品名称',
  `affect_product_id` bigint DEFAULT NULL COMMENT '受影响产品',
  `affect_raw_product_id` bigint DEFAULT NULL COMMENT '受影响产品',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`),
  UNIQUE KEY `vul_rawrelproduct_vul_id_affect_raw_produc_2fa588f0_uniq` (`vul_id`,`affect_raw_product_id`,`source_type`,`source_id`),
  KEY `vul_rawrelproduct_create_time_828ba571` (`create_time`),
  KEY `vul_rawrelproduct_modify_time_f98e869e` (`modify_time`),
  KEY `vul_rawrelproduct_source_id_41d8cfcc` (`source_id`),
  KEY `vul_rawrelproduct_affect_product_id_6361e6a2` (`affect_product_id`),
  KEY `vul_rawrelproduct_affect_raw_product_id_e7494a1d` (`affect_raw_product_id`),
  KEY `vul_rawrelproduct_vul_id_d9924d4d` (`vul_id`),
  KEY `temp_affected_version_expression` (`affected_version_expression`(512)),
  KEY `vul_rawrelproduct_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3388501 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='漏洞影响产品原始表';


-- package.vul_reference definition

CREATE TABLE `vul_reference` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源类型',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '链接地址',
  `url_crc32` bigint NOT NULL COMMENT '链接crc32',
  `name` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '名称',
  `ref_source` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '参考源',
  `tags` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '标签',
  `pkg_vul_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '组件漏洞标识',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '漏洞',
  `level` int NOT NULL DEFAULT '0' COMMENT '优先级',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_reference_url_crc32_source_type_source_id_23af33e6_uniq` (`url_crc32`,`source_type`,`source_id`) USING BTREE,
  KEY `vul_reference_create_time_a3fe886c` (`create_time`) USING BTREE,
  KEY `vul_reference_modify_time_66d62a59` (`modify_time`) USING BTREE,
  KEY `vul_reference_source_id_c556bcd5` (`source_id`) USING BTREE,
  KEY `vul_reference_pkg_vul_id_b7468b9e` (`pkg_vul_id`) USING BTREE,
  KEY `vul_reference_vul_id_442a387f` (`vul_id`) USING BTREE,
  KEY `vul_reference_source_type` (`source_type`),
  KEY `vul_reference_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1420457760 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='参考链接';


-- package.vul_relcommit definition

CREATE TABLE `vul_relcommit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ljqc' COMMENT '来源类型',
  `affect_project_id` bigint DEFAULT NULL COMMENT '受影响项目',
  `commit_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'fix commit_url链接',
  `commit_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'fix commit_id',
  `is_analysis` int NOT NULL DEFAULT '0' COMMENT '是否已经分析',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  `patch_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'patch链接',
  `level` int NOT NULL DEFAULT '100' COMMENT '置信级别',
  `rel_project_id` bigint DEFAULT NULL COMMENT '影响项目',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_relcommit_commit_url_vul_id_affect_project_id_74d0584e_uniq` (`commit_url`,`vul_id`,`affect_project_id`) USING BTREE,
  KEY `vul_relcommit_create_time_ab47d6ee` (`create_time`) USING BTREE,
  KEY `vul_relcommit_modify_time_03f09ddf` (`modify_time`) USING BTREE,
  KEY `vul_relcommit_source_id_128ba9fe` (`source_id`) USING BTREE,
  KEY `vul_relcommit_vul_id_8dceb8dd` (`vul_id`) USING BTREE,
  KEY `vul_relcommit_rel_project_id_845b6081` (`rel_project_id`) USING BTREE,
  KEY `vul_relcommit_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=385123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞修复commit';


-- package.vul_relfile definition

CREATE TABLE `vul_relfile` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件名',
  `file_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件路径',
  `file_md5` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '文件md5',
  `code_info` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '代码信息',
  `rel_project_id` bigint DEFAULT NULL COMMENT '影响项目',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  `status` int NOT NULL DEFAULT '0' COMMENT '状态',
  `commit_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'commit_id',
  `rel_commit_id` bigint DEFAULT NULL COMMENT '所属commit',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_relfile_file_path_rel_project_id_3beea2c4_uniq` (`file_path`,`rel_project_id`,`vul_id`,`commit_id`) USING BTREE,
  KEY `vul_relfile_create_time_dd9017c2` (`create_time`) USING BTREE,
  KEY `vul_relfile_modify_time_d7b715aa` (`modify_time`) USING BTREE,
  KEY `vul_relfile_rel_project_id_f5d3bdc8` (`rel_project_id`) USING BTREE,
  KEY `vul_relfile_vul_id_b38673d2` (`vul_id`) USING BTREE,
  KEY `vul_relfile_rel_commit_id_ab9c7d50` (`rel_commit_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=186738 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响文件';


-- package.vul_relproduct definition

CREATE TABLE `vul_relproduct` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `match` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '匹配原始串',
  `affected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '受影响版本表达式()',
  `unaffected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '安全版本表达式()',
  `affect_product_name` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '受影响产品名',
  `affect_product_id` bigint DEFAULT NULL COMMENT '受影响产品',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_relproduct_vul_id_affect_product_id_8703d790_uniq` (`vul_id`,`affect_product_id`) USING BTREE,
  KEY `vul_relproduct_create_time_e3308898` (`create_time`) USING BTREE,
  KEY `vul_relproduct_modify_time_a90e78dc` (`modify_time`) USING BTREE,
  KEY `vul_relproduct_affect_product_id_5ad515d2` (`affect_product_id`) USING BTREE,
  KEY `vul_relproduct_vul_id_72c39a65` (`vul_id`) USING BTREE,
  KEY `temp_affected_version_expression` (`affected_version_expression`(512)) USING BTREE,
  KEY `vul_relproduct_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1785538 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响产品';


-- package.vul_relproject definition

CREATE TABLE `vul_relproject` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT '创建时间',
  `modify_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '修改时间',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'affected' COMMENT '状态',
  `duplicate_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '重复ID',
  `source_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源ID',
  `source_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源类型',
  `match` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '匹配原始串',
  `affected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '受影响版本表达式()',
  `unaffected_version_expression` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT (_utf8mb4'') COMMENT '安全版本表达式()',
  `affect_project_url` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '受影响项目地址',
  `affect_project_id` bigint DEFAULT NULL COMMENT '受影响项目',
  `affect_project_name` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '受影响项目名',
  `affected_versions` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '受影响分支列表',
  `unaffected_versions` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '安全分支列表',
  `fix_commit_url` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '修复commit 链接',
  `patch_url` json NOT NULL DEFAULT (_utf8mb4'[]') COMMENT '修复patch',
  `vul_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '漏洞',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vul_relproject_vul_id_affect_project_id_70dd733a_uniq` (`vul_id`,`affect_project_id`) USING BTREE,
  KEY `vul_relproject_create_time_13b630a6` (`create_time`) USING BTREE,
  KEY `vul_relproject_modify_time_47cc32b1` (`modify_time`) USING BTREE,
  KEY `vul_relproject_source_id_df2e121b` (`source_id`) USING BTREE,
  KEY `vul_relproject_vul_id_262fde63` (`vul_id`) USING BTREE,
  KEY `temp_affected_version_expression` (`affected_version_expression`(512)) USING BTREE,
  KEY `vul_relproject_duplicate_id` (`duplicate_id`)
) ENGINE=InnoDB AUTO_INCREMENT=296804 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响项目';
