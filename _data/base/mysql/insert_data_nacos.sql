SET NAMES utf8mb4;

INSERT INTO nacos.config_info (data_id,group_id,content,md5,gmt_create,gmt_modified,src_user,src_ip,app_name,tenant_id,c_desc,c_use,effect,`type`,c_schema,encrypted_data_key) VALUES
	 ('mysql','aigc','url=jdbc:mysql://192.168.31.92:13306/clouditera_aigc?serverTimezone=Asia/Shanghai
mysqlusername=root
password=Clouditera@2023','d6f565ffb77dcf30493c0831628982db','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('postgresql','aigc','url=jdbc:postgresql://192.168.31.92:15432/aigc
pgUsername=postgres
password=clouditera','39f4a31d773b0c96fca028bf6f524ff8','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('redis','aigc','ip=192.168.31.92
port=16379
index=2
password=clouditera','4619795d08f94413ff0db0f8c24d3e31','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('webide','aigc','url: http://192.168.31.92:8080/','8bbb0fa94f4fdec725e8bce38328ab6b','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('dify','aigc','host: http://192.168.31.92:15001
compressedAppKey: app-8yeUYPPR06MA8nXpTdXgxFG0
datasetsAppKey: dataset-gZdX8OFBpThhFbJz81nWeGlS
token: dataset-gZdX8OFBpThhFbJz81nWeGlS
ragFlowHost: http://192.168.31.92:9380
ragFlowApiKey: ragflow-E2NzBiMmYwZjNlNjExZWZiMjQ1MDI0Mj
modelActivity: false','1c786d5f79b8012d43ef9df461c1aff9','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('plugin','aigc','host: http://192.168.31.92:18002
local-host: http://192.168.31.92:18882
search-host: http://192.168.31.92:18882
penetration-tools-host: http://192.168.31.92:18005
codeInvoke: http://192.168.31.92:18887
izPull: true','b40718d9715842acb5f1d98b2876cb91','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('keycloak','aigc','iamUrl: http://192.168.31.92:18080
realm: Clouditera-IAM
clientId: clouditera-aigc
clientSecret: jbSM7ihAH8i5AlYlUF5fLYn5BTJEs1B5
jwkSetUri=http://192.168.31.92:18080/realms/Clouditera-IAM/protocol/openid-connect/certs
defaultPassword=P@ss1234','9d33a596812d1400d72987c1089e81d2','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('minio','aigc','endpoint: http://192.168.31.92:19000
accessKey: clouditera
secretKey: HwaJ1L5QMxSmyoO6','d0951a5c36cc24b116bd979b8395d7f6','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('searching','aigc','host: http://192.168.31.92:8000
token: AXkL9pwkf46vgD6kSI5u6ZCHQMXRMtxr
summaryThreadNum: 1','5d0f6f6f4be12c97f48cdb3764c0bc25','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('secpaper','aigc','host: http://192.168.31.92:18082','a1a4a86787c1dcc431c5cf5bea232561','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,'');
INSERT INTO nacos.config_info (data_id,group_id,content,md5,gmt_create,gmt_modified,src_user,src_ip,app_name,tenant_id,c_desc,c_use,effect,`type`,c_schema,encrypted_data_key) VALUES
	 ('rag','aigc','base-url=http://192.168.31.92
api-key=55a3983c0c0440c693e437df8cfb735b','fa0022442e2b0a7e6fcb06b65183fef0','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('sast','aigc','host: http://192.168.31.92:8031','ca2b3454903beeea2344ea7ed469f3a4','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('rabbitmq','aigc','host: 192.168.31.92
port: 8672
username: clouditera
password: clouditera','8dfc938ffd3b0f3e1e4de8cde8e62355','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,'');
INSERT INTO nacos.his_config_info (id,data_id,group_id,app_name,content,md5,gmt_create,gmt_modified,src_user,src_ip,op_type,tenant_id,encrypted_data_key) VALUES
	 (0,'mysql','aigc','','url=jdbc:mysql://192.168.31.92:13306/clouditera_aigc?serverTimezone=Asia/Shanghai
mysqlusername=root
password=Clouditera@2023','d6f565ffb77dcf30493c0831628982db','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'postgresql','aigc','','url=jdbc:postgresql://192.168.31.92:15432/aigc
pgUsername=postgres
password=clouditera','39f4a31d773b0c96fca028bf6f524ff8','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'redis','aigc','','ip=192.168.31.92
port=16379
index=2
password=clouditera','4619795d08f94413ff0db0f8c24d3e31','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'webide','aigc','','url: http://192.168.31.92:8080/','8bbb0fa94f4fdec725e8bce38328ab6b','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'dify','aigc','','host: http://192.168.31.92:15001
compressedAppKey: app-8yeUYPPR06MA8nXpTdXgxFG0
datasetsAppKey: dataset-gZdX8OFBpThhFbJz81nWeGlS
token: dataset-gZdX8OFBpThhFbJz81nWeGlS
ragFlowHost: http://192.168.31.92:9380
ragFlowApiKey: ragflow-E2NzBiMmYwZjNlNjExZWZiMjQ1MDI0Mj
modelActivity: false','1c786d5f79b8012d43ef9df461c1aff9','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'plugin','aigc','','host: http://192.168.31.92:18002
local-host: http://192.168.31.92:18882
search-host: http://192.168.31.92:18882
penetration-tools-host: http://192.168.31.92:18005
codeInvoke: http://192.168.31.92:18887
izPull: true','b40718d9715842acb5f1d98b2876cb91','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'keycloak','aigc','','iamUrl: http://192.168.31.92:18080
realm: Clouditera-IAM
clientId: clouditera-aigc
clientSecret: jbSM7ihAH8i5AlYlUF5fLYn5BTJEs1B5
jwkSetUri=http://192.168.31.92:18080/realms/Clouditera-IAM/protocol/openid-connect/certs
defaultPassword=P@ss1234','9d33a596812d1400d72987c1089e81d2','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'minio','aigc','','endpoint: http://192.168.31.92:19000
accessKey: clouditera
secretKey: HwaJ1L5QMxSmyoO6','d0951a5c36cc24b116bd979b8395d7f6','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'searching','aigc','','host: http://192.168.31.92:8000
token: AXkL9pwkf46vgD6kSI5u6ZCHQMXRMtxr
summaryThreadNum: 1','5d0f6f6f4be12c97f48cdb3764c0bc25','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'secpaper','aigc','','host: http://192.168.31.92:18082','a1a4a86787c1dcc431c5cf5bea232561','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','','');
INSERT INTO nacos.his_config_info (id,data_id,group_id,app_name,content,md5,gmt_create,gmt_modified,src_user,src_ip,op_type,tenant_id,encrypted_data_key) VALUES
	 (0,'rag','aigc','','base-url=http://rag.clouditera.com
api-key=55a3983c0c0440c693e437df8cfb735b','fa0022442e2b0a7e6fcb06b65183fef0','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'sast','aigc','','host: http://192.168.31.92:8031','ca2b3454903beeea2344ea7ed469f3a4','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','',''),
	 (0,'rabbitmq','aigc','','host: 192.168.31.92
port: 8672
username: clouditera
password: clouditera','8dfc938ffd3b0f3e1e4de8cde8e62355','2025-08-13 01:29:00','2025-08-13 01:29:01','nacos','10.8.0.20','I','','');
