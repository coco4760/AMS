SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

create database if not exists clouditera_cncert;

use clouditera_cncert;

-- clouditera_cncert.CHECK_TEMPLATE definition

CREATE TABLE `CHECK_TEMPLATE` (
  `ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键',
  `TEMPLATE_NAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CHECK_STYLE` enum('COMMON_CHECK','DEEP_CHECK') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CHECK_CODE_LANGUAGE` enum('CSHARP','C_C_PLUS_PLUS','GO','HTML','JAVA','JAVASCRIPT','JSP','OBJECTIVE_C','OCAML','PHP','PYTHON','XML') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CHECK_FRAME` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CHECK_TAGS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `TEMPLATE_STATUS` bit(1) DEFAULT NULL,
  `CHECK_RULES` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '检测器ID',
  `CREATED_TIME` datetime(6) DEFAULT NULL,
  `CREATED_BY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UPDATED_TIME` datetime(6) DEFAULT NULL,
  `UPDATED_BY` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='检测模板';


-- clouditera_cncert.CODE_QUALITY_METRIC definition

CREATE TABLE `CODE_QUALITY_METRIC` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `task_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `code_quality` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `code_quality_metric` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '新增的代码质量度量列',
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.DEDUPLICATED_VULNERABILITY_INFO definition

CREATE TABLE `DEDUPLICATED_VULNERABILITY_INFO` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `BUG_ID` varchar(255) DEFAULT NULL,
  `FILE_PATH` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `LINE` int DEFAULT NULL,
  `METHOD_NAME` varchar(255) DEFAULT NULL,
  `VARIABLE` varchar(255) DEFAULT NULL,
  `BUG_TYPE` varchar(255) DEFAULT NULL,
  `MESSAGE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `WEAKNESS_LEVEL` varchar(255) DEFAULT NULL,
  `STEPS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `TASK_ID` varchar(255) DEFAULT NULL,
  `BUG_STATE` enum('IGNORE','INIT','RECONFIRMED','REOPEN','REPAIRING','SOLVED','TP') DEFAULT NULL,
  `CREATED_TIME` datetime(6) DEFAULT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED_TIME` datetime(6) DEFAULT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uniq_file_line_bugtype_taskid` (`FILE_PATH`(255),`LINE`,`BUG_TYPE`,`TASK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='缺陷信息';


-- clouditera_cncert.DETECTION_RULE definition

CREATE TABLE `DETECTION_RULE` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `ENGINE_ID` varchar(64) DEFAULT NULL COMMENT '引擎ID',
  `RULE_NAME` varchar(255) DEFAULT NULL COMMENT '规则名称',
  `KNOWLEDGE_INFORMATION_ID` varchar(64) DEFAULT NULL COMMENT '知识库信息ID',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='检测规则表';


-- clouditera_cncert.ENGINEID_AND_KNOWLEDGEID definition

CREATE TABLE `ENGINEID_AND_KNOWLEDGEID` (
  `KNOWLEDGE_ID` varchar(255) DEFAULT NULL,
  `ENGINE_ID` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='映射引擎下语言关系表';


-- clouditera_cncert.ENGINE_TOOL definition

CREATE TABLE `ENGINE_TOOL` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `TOOL_NAME` varchar(255) DEFAULT NULL,
  `TOOL_TYPE` enum('CLOUDITERA_FUZZ','CLOUDITERA_SAST','CLOUDITERA_SCA','OTHER_FUZZ','OTHER_SAST','OTHER_SCA','UN_SUPPORT') DEFAULT NULL,
  `SOURCE_FROM` varchar(255) DEFAULT NULL,
  `CALL_TYPE` enum('COMMAND_CALL','HTTP_CALL','OTHER','SDK_CALL') DEFAULT NULL,
  `STATUS` bit(1) DEFAULT NULL,
  `CREATED_TIME` datetime(6) DEFAULT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED_TIME` datetime(6) DEFAULT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  `SUPPORT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `VERSION` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `BASE_URL` varchar(225) DEFAULT NULL,
  `ACCESS_TOKEN` varchar(225) DEFAULT NULL,
  `TOOL_USER_NAME` varchar(225) DEFAULT NULL,
  `TOOL_PASSWORD` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `INTEGRATED` bit(1) DEFAULT b'0' COMMENT '是否在无暇平台',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='安全引擎工具列表';


-- clouditera_cncert.KNOWLEDGE_CATALOG definition

CREATE TABLE `KNOWLEDGE_CATALOG` (
  `ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '知识库目录ID',
  `NAME` varchar(255) DEFAULT NULL,
  `PARENT_ID` varchar(255) DEFAULT NULL,
  `LEVEL` int DEFAULT NULL COMMENT '等级',
  `SORT_INDEX` int DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.KNOWLEDGE_INFORMATION definition

CREATE TABLE `KNOWLEDGE_INFORMATION` (
  `ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `CATALOG_ID` varchar(255) DEFAULT NULL,
  `BUG_NO` varchar(255) DEFAULT NULL,
  `PARENT_BUG_NO` varchar(255) DEFAULT NULL,
  `BUG_NAME` varchar(255) DEFAULT NULL,
  `BUG_NAME_EN` varchar(255) DEFAULT NULL,
  `BUG_SIGN` varchar(255) DEFAULT NULL,
  `BUG_LEVEL` enum('DEADLY','LOW_RISK','POOR_RISK','SAFE','SEVERITY','UN_KNOWN') DEFAULT NULL,
  `CODE_LANGUAGE` enum('CSHARP','C_C_PLUS_PLUS','GO','HTML','JAVA','JAVASCRIPT','JSP','PHP','PYTHON','XML') DEFAULT NULL,
  `DESCRIPTION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '描述',
  `FREQUENT_RESULT_KEYWORD` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '常见后果关键词',
  `FREQUENT_RESULT` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '常见后果',
  `REPAIR_OPINION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '修复意见',
  `EXAMPLE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '示例',
  `ERROR_EXAMPLE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '错误示例',
  `CREATED_TIME` datetime(6) DEFAULT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED_TIME` datetime(6) DEFAULT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `BUG_SIGN` (`BUG_SIGN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCAN_DOMAIN definition

CREATE TABLE `SCAN_DOMAIN` (
  `ID` varchar(64) DEFAULT NULL,
  `TASK_ID` varchar(100) DEFAULT NULL,
  `DOMAIN_ID` varchar(100) DEFAULT NULL,
  `DOMAIN` text,
  `HOST_SUM` bigint DEFAULT NULL,
  `HOSTS` text,
  `VULNS` text,
  `CREATED_TIME` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCAN_HOST definition

CREATE TABLE `SCAN_HOST` (
  `ID` varchar(64) DEFAULT NULL,
  `HOST_ID` varchar(100) DEFAULT NULL,
  `DOMAINS` longtext,
  `IP_ADDRESS` varchar(100) DEFAULT NULL,
  `STATE` varchar(100) DEFAULT NULL,
  `SERVICE_SUM` bigint DEFAULT NULL,
  `SERVICES` longtext,
  `VULNS` longtext,
  `SEVERITY` varchar(100) DEFAULT NULL,
  `OS_MATCHES` varchar(100) DEFAULT NULL,
  `CREATED_TIME` datetime DEFAULT NULL,
  `TASK_ID` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCAN_SERVICE definition

CREATE TABLE `SCAN_SERVICE` (
  `ID` varchar(64) DEFAULT NULL,
  `TASK_ID` varchar(100) DEFAULT NULL,
  `SERVICE_ID` varchar(100) DEFAULT NULL,
  `HOST_ID` varchar(255) DEFAULT NULL,
  `PORT` varchar(255) DEFAULT NULL,
  `PROTOCOL` longtext,
  `NAME` longtext,
  `VULNS` text,
  `BANNER` longtext,
  `VERSION` varchar(255) DEFAULT NULL,
  `CREATED_TIME` datetime DEFAULT NULL,
  `PRODUCT` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCAN_VULN definition

CREATE TABLE `SCAN_VULN` (
  `ID` varchar(64) DEFAULT NULL,
  `TASK_ID` varchar(100) DEFAULT NULL,
  `VULN_ID` varchar(100) DEFAULT NULL,
  `TARGET` text,
  `PARAMS` text,
  `PROTOCOL` varchar(100) DEFAULT NULL,
  `TITLE` varchar(255) DEFAULT NULL,
  `STATUS` varchar(255) DEFAULT NULL,
  `POC` text,
  `EXP` text,
  `SUMMARY` text,
  `IMPACT` text,
  `DETAIL` text,
  `SOLUTION` text,
  `SEVERITY` varchar(100) DEFAULT NULL,
  `CATEGORY` varchar(255) DEFAULT NULL,
  `EXPOSURES` text,
  `DEFINITENESS` varchar(100) DEFAULT NULL,
  `CVSS` text,
  `PUBLISHED_DATE_TIME` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCAN_WEBPAGE definition

CREATE TABLE `SCAN_WEBPAGE` (
  `ID` varchar(64) DEFAULT NULL,
  `WEBPAGE_ID` varchar(100) DEFAULT NULL,
  `URL` text,
  `TASK_ID` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCAN_WEBSITE definition

CREATE TABLE `SCAN_WEBSITE` (
  `ID` varchar(64) DEFAULT NULL,
  `TASK_ID` varchar(100) DEFAULT NULL,
  `WEBSITE_ID` varchar(100) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `TITLE` varchar(255) DEFAULT NULL,
  `RAW_REQUEST` longtext,
  `RAW_RESPONSE` longtext,
  `FRAMEWORK` text,
  `WEBPAGE_SUM` bigint DEFAULT NULL,
  `WEBPAGES` text,
  `VULNS` text,
  `SEVERITY` varchar(255) DEFAULT NULL,
  `CREATED_TIME` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCA_LICENSE definition

CREATE TABLE `SCA_LICENSE` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `task_id` varchar(255) DEFAULT NULL,
  `license_key` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '许可证名称',
  `title` varchar(255) DEFAULT NULL,
  `license_risk_level` enum('DEADLY','LOW_RISK','POOR_RISK','SAFE','SEVERITY','UN_KNOWN') DEFAULT NULL,
  `category_en` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型_英文',
  `category_ch` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '类型_中文',
  `osi_approval` int DEFAULT NULL,
  `fsf_approval` int DEFAULT NULL,
  `spdx_approval` int DEFAULT NULL,
  `spdx_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'SPDX Id',
  `spdx_url` varchar(255) DEFAULT NULL,
  `publication_year` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '发布日期',
  `text_urls` varchar(255) DEFAULT NULL,
  `full_text` varchar(255) DEFAULT NULL,
  `quick_summary_en` varchar(255) DEFAULT NULL,
  `quick_summary_ch` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `owner_name` varchar(255) DEFAULT NULL,
  `owner_type` varchar(255) DEFAULT NULL,
  `owner_alias` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所有者别名',
  `owner_home_page` varchar(255) DEFAULT NULL,
  `owner_contact_information` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '所有者联系信息',
  `owner_notes` varchar(255) DEFAULT NULL,
  `n_used` int DEFAULT NULL COMMENT '使用频率',
  `is_add` int DEFAULT NULL COMMENT '是否新增',
  `update_time` datetime(6) DEFAULT NULL,
  `lawer_verified` int DEFAULT NULL,
  `map_id` int DEFAULT NULL,
  `sca_rank` int DEFAULT NULL,
  `license_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '原文下载链接',
  `create_time` datetime(6) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='许可证基础信息';


-- clouditera_cncert.SCA_PACKAGE_DEPENDENCE definition

CREATE TABLE `SCA_PACKAGE_DEPENDENCE` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `task_id` varchar(255) DEFAULT NULL,
  `manage` int DEFAULT NULL,
  `package_id` bigint DEFAULT '0' COMMENT '组件id',
  `package_name` varchar(255) DEFAULT NULL,
  `package_type` varchar(255) DEFAULT NULL,
  `package_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '组件版本',
  `dependency_package_id` int DEFAULT '0' COMMENT '依赖组件id',
  `dependency_package_type` varchar(255) DEFAULT NULL,
  `dependency_package_name` varchar(255) DEFAULT NULL,
  `dependency_kind` varchar(255) DEFAULT NULL,
  `dependency_environment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '依赖环境',
  `dependency_package_version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '依赖组件版本表达式',
  `dependency_version_expression` varchar(255) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `TASK_ID` (`task_id`),
  KEY `idx_package_name` (`package_name`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_update_time` (`update_time`),
  KEY `dep_id` (`dependency_package_id`),
  KEY `dep_name` (`dependency_package_name`),
  KEY `dep_version` (`dependency_package_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='小众组件depend信息';


-- clouditera_cncert.SCA_PACKAGE_INFO definition

CREATE TABLE `SCA_PACKAGE_INFO` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `sca_id` bigint DEFAULT NULL COMMENT 'sca主键Id',
  `package_id` bigint DEFAULT '0' COMMENT '组件id',
  `task_id` varchar(255) DEFAULT NULL,
  `project_id` bigint DEFAULT NULL COMMENT '项目id',
  `package_name` varchar(255) DEFAULT NULL,
  `package_type` varchar(255) DEFAULT NULL,
  `home_page` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '主页',
  `github_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT 'github链接',
  `first_release_time` datetime(6) DEFAULT NULL,
  `latest_release_time` datetime(6) DEFAULT NULL,
  `latest_release` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '最新的版本',
  `description` varchar(255) DEFAULT NULL,
  `versions_count` int DEFAULT '0' COMMENT '总共的版本数',
  `language` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '语言',
  `keywords` varchar(255) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `verified_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '许可证',
  `license_relation` int DEFAULT '0' COMMENT '许可证关系',
  `move_to` int DEFAULT NULL COMMENT '迁移id',
  `project_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '项目名称',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '厂商名称',
  `create_time` varchar(255) DEFAULT NULL,
  `update_time` varchar(255) DEFAULT NULL,
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `project_id` (`project_id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_update_time` (`update_time`) USING BTREE,
  KEY `idx_license` (`verified_license`) USING BTREE,
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='小众组件info信息';


-- clouditera_cncert.SCA_PACKAGE_VERSION definition

CREATE TABLE `SCA_PACKAGE_VERSION` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `task_id` varchar(255) DEFAULT NULL,
  `package_type` varchar(255) DEFAULT NULL,
  `package_name` varchar(255) DEFAULT NULL,
  `package_id` bigint DEFAULT '0' COMMENT '组件id',
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '版本',
  `published_time` datetime(6) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `verified_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '' COMMENT '许可证',
  `license_relation` int DEFAULT '0' COMMENT '许可证关系',
  `severity` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '风险等级',
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `idx_package_name` (`package_name`),
  KEY `index_package_id` (`package_id`),
  KEY `idx_license` (`verified_license`),
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='小众组件version信息';


-- clouditera_cncert.SCA_RELATION_TASK definition

CREATE TABLE `SCA_RELATION_TASK` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `TASK_ID` varchar(64) DEFAULT NULL COMMENT '任务id',
  `package_id` bigint DEFAULT NULL COMMENT '组件id',
  `package_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件类型',
  `package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '组件名称',
  `path` varchar(255) DEFAULT NULL,
  `version` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '当前版本',
  `engine_status` bit(1) DEFAULT NULL COMMENT '引擎状态',
  `status` varchar(255) DEFAULT NULL COMMENT '状态',
  `CREATED_TIME` datetime(6) DEFAULT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED_TIME` datetime(6) DEFAULT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  `groupId` varchar(255) DEFAULT NULL,
  `artifactId` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `classifier` varchar(255) DEFAULT NULL,
  `scope` varchar(255) DEFAULT NULL,
  `systemPath` varchar(255) DEFAULT NULL,
  `exclusions` varchar(255) DEFAULT NULL,
  `optional` varchar(255) DEFAULT NULL,
  `managementKey` varchar(255) DEFAULT NULL,
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_key` (`TASK_ID`,`package_type`,`package_name`,`version`) USING BTREE,
  UNIQUE KEY `unq` (`TASK_ID`,`package_id`,`version`) USING BTREE,
  KEY `package_id` (`package_id`) USING BTREE,
  KEY `package_name` (`package_name`) USING BTREE,
  KEY `package_type` (`package_type`) USING BTREE,
  KEY `TASK_ID` (`TASK_ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- clouditera_cncert.SCA_VUL_PACKAGE definition

CREATE TABLE `SCA_VUL_PACKAGE` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `sca_id` bigint DEFAULT NULL COMMENT 'sca主键ID',
  `task_id` varchar(255) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `modify_time` datetime(6) DEFAULT NULL,
  `status` enum('AFFECTED','DUPLICATE','REJECT','RESERVED','UNKNOWN') DEFAULT NULL,
  `duplicate_id` varchar(255) DEFAULT NULL,
  `sca_match` varchar(255) DEFAULT NULL,
  `affected_version_expression` varchar(255) DEFAULT NULL,
  `unaffected_version_expression` varchar(255) DEFAULT NULL,
  `cve_id` varchar(255) DEFAULT NULL,
  `title_cn` varchar(255) DEFAULT NULL,
  `title_en` varchar(255) DEFAULT NULL,
  `description_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '中文描述',
  `description_en` varchar(255) DEFAULT NULL,
  `submit_time` datetime(6) DEFAULT NULL,
  `published_time` datetime(6) DEFAULT NULL,
  `modified_time` datetime(6) DEFAULT NULL,
  `cvss2_vector` varchar(255) DEFAULT NULL,
  `cvss2_base_score` decimal(38,2) DEFAULT NULL,
  `cvss3_vector` varchar(255) DEFAULT NULL,
  `cvss3_base_score` decimal(38,2) DEFAULT NULL,
  `severity` enum('DEADLY','LOW_RISK','POOR_RISK','SAFE','SEVERITY','UN_KNOWN') DEFAULT NULL,
  `solution_cn` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '中文修复方案',
  `solution_en` varchar(255) DEFAULT NULL,
  `relieve_cn` varchar(255) DEFAULT NULL,
  `relieve_en` varchar(255) DEFAULT NULL,
  `cwes` varchar(255) DEFAULT NULL,
  `verify_status` enum('STATUS_0','STATUS_10','STATUS_20','STATUS_30','STATUS_40') DEFAULT NULL,
  `first_verify_time` datetime(6) DEFAULT NULL,
  `verify_time` datetime(6) DEFAULT NULL,
  `modified_user_name` varchar(255) DEFAULT NULL,
  `source_type` enum('AVD','CNNVD','CNVD','CVE','DEBIAN','GITHUB_ADVISORY','GITLAB_GEMNASINUM','JVN','NPMJS_ADVISORY','NVD','OSV','REDHAT','RUST','SECLISTS','SNYK','UBUNTU','VERACODE','VULDB','WHITESOURCE','YQ','YQ_SCRIPT') DEFAULT NULL,
  `flag` varchar(255) DEFAULT NULL,
  `pkg_vul_id` varchar(255) DEFAULT NULL,
  `affect_package_id` bigint DEFAULT NULL COMMENT '受影响组件',
  `affect_package_name` varchar(255) DEFAULT NULL,
  `affect_package_type` varchar(255) DEFAULT NULL,
  `vul_id` varchar(255) DEFAULT NULL,
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `vul_package_create_time_d7fd22f8` (`create_time`) USING BTREE,
  KEY `vul_package_modify_time_baa3ff0a` (`modify_time`) USING BTREE,
  KEY `vul_package_cve_id_58667219` (`cve_id`) USING BTREE,
  KEY `vul_package_affect_package_type_ff2dcecf` (`affect_package_type`) USING BTREE,
  KEY `vul_package_vul_id_7d606d6d` (`vul_id`) USING BTREE,
  KEY `temp_affected_version_expression` (`affected_version_expression`) USING BTREE,
  KEY `vul_packagh_affect_package_id` (`affect_package_id`),
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响组件最终表';


-- clouditera_cncert.SCA_VUL_PACKAGE_VERSION definition

CREATE TABLE `SCA_VUL_PACKAGE_VERSION` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `sca_id` bigint DEFAULT NULL COMMENT 'sca主键ID',
  `task_id` varchar(255) DEFAULT NULL,
  `create_time` varchar(255) DEFAULT NULL,
  `modify_time` varchar(255) DEFAULT NULL,
  `affect_package_id` bigint DEFAULT NULL COMMENT '受影响组件',
  `affect_package_version` varchar(255) DEFAULT NULL,
  `affect_package_type` varchar(255) DEFAULT NULL,
  `pkg_vul_id` varchar(255) DEFAULT NULL,
  `vul_id` varchar(255) DEFAULT NULL,
  `engine_id` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `vul_packageversion_create_time_d67167e4` (`create_time`) USING BTREE,
  KEY `vul_packageversion_modify_time_0cd1329f` (`modify_time`) USING BTREE,
  KEY `vul_packageversion_affect_package_type_1f6b4795` (`affect_package_type`) USING BTREE,
  KEY `vul_packageversion_pkg_vul_id_dc5ce7cd` (`pkg_vul_id`) USING BTREE,
  KEY `vul_packageversion_vul_id_8a366853` (`vul_id`) USING BTREE,
  KEY `idx_task_id` (`task_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='漏洞影响组件版本表';


-- clouditera_cncert.VULNERABILITY_INFO definition

CREATE TABLE `VULNERABILITY_INFO` (
  `ID` varchar(64) NOT NULL COMMENT '主键',
  `BUG_ID` varchar(255) DEFAULT NULL,
  `FILE_PATH` varchar(255) DEFAULT NULL,
  `LINE` int DEFAULT NULL,
  `METHOD_NAME` varchar(255) DEFAULT NULL,
  `VARIABLE` varchar(255) DEFAULT NULL,
  `BUG_TYPE` varchar(255) DEFAULT NULL,
  `MESSAGE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `WEAKNESS_LEVEL` varchar(255) DEFAULT NULL,
  `STEPS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `TASK_ID` varchar(255) DEFAULT NULL,
  `BUG_STATE` enum('IGNORE','INIT','RECONFIRMED','REOPEN','REPAIRING','SOLVED','TP') DEFAULT NULL,
  `CREATED_TIME` datetime(6) DEFAULT NULL,
  `CREATED_BY` varchar(255) DEFAULT NULL,
  `UPDATED_TIME` datetime(6) DEFAULT NULL,
  `UPDATED_BY` varchar(255) DEFAULT NULL,
  `ENGINE_ID` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `taskid` (`TASK_ID`) USING BTREE,
  KEY `bugstate` (`BUG_STATE`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='缺陷信息';


-- clouditera_cncert.VUL_JUDGEMENT definition

CREATE TABLE `VUL_JUDGEMENT` (
  `ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键标识',
  `VULINFO_ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联的漏洞信息ID',
  `AI_REPAIR_SUGGESTION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'AI修复建议描述',
  `AI_BASIS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'AI分析依据说明',
  `MANUAL_REPAIR_SUGGESTION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '人工修复建议描述',
  `MANUAL_BASIS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '人工分析依据说明',
  `AI_ANALYSIS_STATUS` tinyint(1) DEFAULT NULL COMMENT 'AI分析结果，0或者1',
  `MANUAL_ANALYSIS_STATUS` tinyint(1) DEFAULT NULL COMMENT '人工分析结果，0或者1',
  `CREATED_TIME` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) COMMENT '记录创建时间',
  `CREATED_BY` varchar(255) DEFAULT NULL COMMENT '记录创建者',
  `UPDATED_TIME` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT '记录更新时间',
  `UPDATED_BY` varchar(255) DEFAULT NULL COMMENT '记录更新者',
  `MAN_AUD_RISK_LEVEL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '人工安全等级',
  `AI_AUD_RISK_LEVEL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'AI安全等级',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='漏洞判断表';