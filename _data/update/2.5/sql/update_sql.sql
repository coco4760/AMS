-- AGENT表新增字段
ALTER TABLE `clouditera_aigc`.`AGENT` 
ADD COLUMN `AGENT_METADATA` text NULL COMMENT '智能体元数据配置' AFTER `PARENT_ID`;

-- AGENT表添加智能体说明标识字段
UPDATE `clouditera_aigc`.`AGENT` SET AGENT_METADATA = '{"agentHasDes":1,"desOnLine":0}' WHERE ID IN ('3','13','4');

-- AGENT表新增安全论文检索智能体数据
INSERT INTO `clouditera_aigc`.`AGENT` (`ID`, `AGENT_NAME`, `WORKFLOW_NAME`, `AGENT_TYPE`, `TAG`, `PROMPT`, `APP_ID`, `FLAG`, `SORT`, `SHORTCUT`, `KL_STATUS`, `KEY`, `CREATED_TIME`, `CREATED_BY`, `UPDATED_TIME`, `UPDATED_BY`, `MODE_TYPE`, `CONFIG`, `VERSION`, `STATUS`, `TYPE`, `COUNT_TOKENS`, `COMMON_HOME`, `COMMON_CONVERSATION`, `COMMON_QUESTION`, `PARENT_ID`, `AGENT_METADATA`) VALUES ('24', '安全论文检索', '安全论文检索', 'PAPER_RETRIEVE', 'PAPER_RETRIEVE', 'query_type', 'cd62865f-fc64-4736-9c27-7670ece24c05', 1, 24, 0, 0, 'app-ZppraoZNJPXkpb1GSBTvmR2h', NULL, NULL, '2025-09-04 16:44:25', '2d8c6945-a3b4-43c1-9dcc-d21a4e780d99', 'CHAT_WORKFLOW', '{\"database\":[],\"llm\":[]}', '1.0', 'AGENT_ALPHA', 'KNOWLEDGE', 1, 1, 1, 0, NULL, NULL);
INSERT INTO `clouditera_aigc`.`AGENT` (`ID`, `AGENT_NAME`, `WORKFLOW_NAME`, `AGENT_TYPE`, `TAG`, `PROMPT`, `APP_ID`, `FLAG`, `SORT`, `SHORTCUT`, `KL_STATUS`, `KEY`, `CREATED_TIME`, `CREATED_BY`, `UPDATED_TIME`, `UPDATED_BY`, `MODE_TYPE`, `CONFIG`, `VERSION`, `STATUS`, `TYPE`, `COUNT_TOKENS`, `COMMON_HOME`, `COMMON_CONVERSATION`, `COMMON_QUESTION`, `PARENT_ID`, `AGENT_METADATA`) VALUES ('118', '安全论文检索', '摘要总结', 'PAPER_RETRIEVE', 'PAPER_RETRIEVE', NULL, '4b0e7737-3012-47fa-a3ae-3aa545e70885', 0, 118, 0, 0, 'app-sHItm3PG1LWuiukfdCibCFWu', NULL, NULL, '2025-07-16 10:02:18', 'ff6c23a8-47c5-46a9-b3c5-8d9c3df4c1bf', 'WORKFLOW', '{\"database\":[],\"llm\":[]}', '1.0', 'AGENT_ALPHA', 'KNOWLEDGE', 1, 1, 1, 0, NULL, NULL);

-- DATASETS表新增安全论文检索智能体
INSERT INTO `clouditera_aigc`.`DATASETS` (`ID`, `AGENT_ID`, `DATASETS_ID`, `NAME`, `STATUS`, `ALL`, `SHOW`, `CREATED_TIME`, `CREATED_BY`, `UPDATED_TIME`, `UPDATED_BY`) VALUES ('24', '24', NULL, '安全论文检索', 0, 0, 1, '2024-04-17 09:52:29', 'admin', '2024-04-17 09:52:29', 'admin');

-- 隐藏之前的论文检索智能体
UPDATE `clouditera_aigc`.`AGENT` SET FLAG = 0 where id = "11";
DELETE FROM `clouditera_aigc`.`AGENT_SHORTCUT` WHERE AGENT_ID = "11";

-- 安全智库智能体添加prompt
UPDATE `clouditera_aigc`.`AGENT` SET PROMPT = "kb_ids" WHERE ID = "21";


-- 20250919提测内容-start--------------------------------

-- 缺陷研判新增开始时间，结束时间
ALTER TABLE `clouditera_aigc`.`DEFECT_ANALYSIS_INFO` 
ADD COLUMN `START_TIME` datetime NULL COMMENT '开始时间' AFTER `FIX_SUGGEST`,
ADD COLUMN `END_TIME` datetime NULL COMMENT '结束时间' AFTER `START_TIME`;

-- 论文研读智能体修改prompt，mode_type
UPDATE AGENT SET PROMPT ="kb_id,doc_id",MODE_TYPE = "CHAT_WORKFLOW" WHERE ID = "2";

-- AGENT表新增论文研读摘要总结
INSERT INTO `clouditera_aigc`.`AGENT` (`ID`, `AGENT_NAME`, `WORKFLOW_NAME`, `AGENT_TYPE`, `TAG`, `PROMPT`, `APP_ID`, `FLAG`, `SORT`, `SHORTCUT`, `KL_STATUS`, `KEY`, `CREATED_TIME`, `CREATED_BY`, `UPDATED_TIME`, `UPDATED_BY`, `MODE_TYPE`, `CONFIG`, `VERSION`, `STATUS`, `TYPE`, `COUNT_TOKENS`, `COMMON_HOME`, `COMMON_CONVERSATION`, `COMMON_QUESTION`, `PARENT_ID`, `AGENT_METADATA`) VALUES ('119', '论文研读', '摘要总结', 'PAPER_ANALYSIS', 'PAPER_ANALYSIS', NULL, '28984c0f-2cca-4266-a581-fe00a423079a', 0, 119, 0, 0, 'app-bUXwZ1m2vY9od4tdXatv11dA', NULL, NULL, NULL, NULL, 'CHAT_WORKFLOW', NULL, '1.3', 'AGENT_ALPHA', 'KNOWLEDGE', 1, 0, 0, 0, NULL, NULL);



-- 20250919提测内容-end----------------------------------