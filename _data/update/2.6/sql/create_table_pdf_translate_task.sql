-- clouditera_aigc.PDF_TRANSLATE_TASK definition

CREATE TABLE `PDF_TRANSLATE_TASK` (
  `ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主键ID',
  `NAME` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务名称',
  `STATUS` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '任务状态',
  `FILE_PATH` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上传文件路径',
  `MONO_FILE_PATH` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '翻译文件路径',
  `DUAL_FILE_PATH` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '翻译文件路径',
  `SESSION_HASH` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '翻译引擎session',
  `ERROR_MESSAGE` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '任务失败原因',
  `CREATED_TIME` timestamp(6) NULL DEFAULT NULL COMMENT '创建时间',
  `CREATED_BY` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '创建人',
  `UPDATED_TIME` timestamp(6) NULL DEFAULT NULL COMMENT '更新时间',
  `UPDATED_BY` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PDF文件翻译任务表';
