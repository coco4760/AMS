
-- 登录日志表
CREATE TABLE `OPERATION_LOG` (
  `ID` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `USER_ID` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户ID',
  `WE_CHART_ID` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '微信ID',
  `EMAIL` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `IP_ADDRESS` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP地址',
  `REQUEST_URI` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '请求URI',
  `REQUEST_TYPE` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '请求类型',
  `REQUEST_PARAMS` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '请求参数',
  `RESPONSE` text COLLATE utf8mb4_unicode_ci COMMENT '响应',
  `MODULE` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作模块',
  `DESCRIPTION` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `STATUS` tinyint DEFAULT NULL COMMENT '状态-0-失败，1-成功',
  `ERROR_MESSAGE` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '失败原因',
  `EXECUTION_TIME` bigint DEFAULT NULL COMMENT '执行时间(毫秒)',
  `CREATED_TIME` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `CREATED_BY` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `UPDATED_TIME` timestamp NULL DEFAULT NULL COMMENT '最后一次时间',
  `UPDATED_BY` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '最后一次修改人',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';
