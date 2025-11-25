INSERT INTO nacos.config_info (data_id,group_id,content,md5,gmt_create,gmt_modified,src_user,src_ip,app_name,tenant_id,c_desc,c_use,effect,`type`,c_schema,encrypted_data_key) VALUES
	 ('mysql','aigc','url=jdbc:mysql://192.168.34.7:10001/clouditera_aigc?serverTimezone=Asia/Shanghai
mysqlusername=root
password=Clouditera@2023','d6f565ffb77dcf30493c0831628982db','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('postgresql','aigc','url=jdbc:postgresql://192.168.34.7:10002/aigc
pgUsername=postgres
password=clouditera','39f4a31d773b0c96fca028bf6f524ff8','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('redis','aigc','ip=192.168.34.7
port=10003
index=2
password=clouditera','4619795d08f94413ff0db0f8c24d3e31','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('dify','aigc','host: http://192.168.34.7:20009
compressedAppKey: app-8yeUYPPR06MA8nXpTdXgxFG0
datasetsAppKey: dataset-gZdX8OFBpThhFbJz81nWeGlS
token: dataset-gZdX8OFBpThhFbJz81nWeGlS
ragFlowHost: http://192.168.34.7:1111
ragFlowApiKey: ragflow-E2NzBiMmYwZjNlNjExZWZiMjQ1MDI0Mj
modelActivity: false','1c786d5f79b8012d43ef9df461c1aff9','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('plugin','aigc','host: http://192.168.34.7:20017
local-host: http://183.242.161.27:21682
search-host: http://192.168.34.7:20018
penetration-tools-host: http://192.168.34.7:20020
codeInvoke: http://192.168.34.7:1111
# izPull true: 漏洞情报数据私有化部署 local-host 应该为本地地址 可以进行远程拉取漏洞数据 search-host 配置为 http://183.242.161.27:21682
# izPull false: 漏洞情报数据公网查询 local-host 应该为公网地址 http://183.242.161.27:21682 或 http://192.168.31.42:18882
izPull: false','273a428e5c560b122d9dafa009cbb237','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('keycloak','aigc','iamUrl: http://192.168.34.7:10015
realm: Clouditera-IAM
clientId: clouditera-aigc
clientSecret: jbSM7ihAH8i5AlYlUF5fLYn5BTJEs1B5
jwkSetUri=http://192.168.34.7:10015/realms/Clouditera-IAM/protocol/openid-connect/certs
defaultPassword=P@ss1234','9d33a596812d1400d72987c1089e81d2','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('minio','aigc','endpoint: http://192.168.34.7:10006
accessKey: clouditera
secretKey: HwaJ1L5QMxSmyoO6','d0951a5c36cc24b116bd979b8395d7f6','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('rag','aigc','base-url=http://192.168.34.7:30002
api-key=cddb4cf4651f455a94b8366e16d145ce
paper-api-key=cddb4cf4651f455a94b8366e16d145ce','654273d5169774a4c010591ee95ce1c4','2025-08-13 01:29:01','2025-11-25 19:51:19','nacos','192.168.32.30','','','','','','text','',''),
	 ('rabbitmq','aigc','host=192.168.34.7
port=10004
account=clouditera
password=clouditera','8dfc938ffd3b0f3e1e4de8cde8e62355','2025-08-13 01:29:01','2025-08-13 01:29:01','nacos','10.8.0.20','','',NULL,NULL,NULL,'text',NULL,''),
	 ('safety-information','aigc','baseUrl=http://183.242.161.27:20180
enabled=true
apiVersion=v1
apiKey=3c456f01-b496-451a-9a61-908233679317
apiKeyHeaderName=X-API-Key
enableApiKeyAuth=true','efd31f0fe6bd3204e94700e08ed2bd41','2025-09-02 14:35:32','2025-11-25 19:56:53','nacos','192.168.32.30','','','','','','text','','');
INSERT INTO nacos.config_info (data_id,group_id,content,md5,gmt_create,gmt_modified,src_user,src_ip,app_name,tenant_id,c_desc,c_use,effect,`type`,c_schema,encrypted_data_key) VALUES
	 ('knowledge','aigc','baseUrl=http://183.242.161.27:20180
enabled=true
apiVersion=v1
apiKey=3c456f01-b496-451a-9a61-908233679317
apiKeyHeaderName=X-API-Key
enableApiKeyAuth=true','efd31f0fe6bd3204e94700e08ed2bd41','2025-09-02 14:35:32','2025-11-25 19:45:46','nacos','192.168.32.30','','','','','','text','',''),
	 ('paper','aigc','baseUrl=http://183.242.161.27:20180
enabled=true
apiVersion=v1
apiKey=3c456f01-b496-451a-9a61-908233679317
apiKeyHeaderName=X-API-Key
enableApiKeyAuth=true','efd31f0fe6bd3204e94700e08ed2bd41','2025-09-02 14:35:32','2025-11-25 19:45:35','nacos','192.168.32.30','','','','','','text','',''),
	 ('cloudflow','aigc','baseUrl=http://192.168.34.7:20027
key=ZGVmYXVsdC1hZG1pbi1hcGkta2V5','997231e0cbadd8b59c9a0733c7cb563d','2025-11-25 14:15:18','2025-11-25 14:15:18','nacos','192.168.32.50','','',NULL,NULL,NULL,'text',NULL,''),
	 ('pdf-translate','aigc','baseUrl=http://192.168.34.7:20026
xinferenceHost=http://10.20.25.2:9997
xinferenceModelId=SecGPT','1b2c4156d9ceb981ab7a746c48895892','2025-11-25 14:15:18','2025-11-25 14:15:18','nacos','192.168.32.50','','',NULL,NULL,NULL,'text',NULL,''),
	 ('api-token','aigc','prefix: sec_
secretKey: 7hhqRj8A59BgU7Q8jcauPn3Q4e1gufMA
randomBytesLength: 32
# expirationSeconds 不配置，默认为 null，永不过期','237b4ec45c638634e6fe8c8bb845be1d','2025-11-25 14:15:18','2025-11-25 14:15:18','nacos','192.168.32.50','','',NULL,NULL,NULL,'text',NULL,''),
	 ('api-token-security','aigc','# 速率限制配置
rate-limit.enabled=true
rate-limit.requests-per-minute=60
rate-limit.strict-requests-per-minute=20
rate-limit.window-seconds=60

# 失败锁定配置
failure-lock.enabled=true
failure-lock.max-failures-per-ip=5
failure-lock.ip-lock-duration-minutes=15
failure-lock.max-failures-per-token=10
failure-lock.token-lock-duration-minutes=30

# 延迟配置
delay.enabled=true
delay.base-delay-ms=100
delay.max-delay-ms=2000
delay.exponential-base=2

# 监控告警配置
monitoring.enabled=true
monitoring.alert-threshold-ip-hourly=50
monitoring.alert-threshold-global-minute=1000
monitoring.alert-threshold-lock-daily=10','115f5141c0af0e60a1ad5548b17e4580','2025-11-25 14:15:19','2025-11-25 14:15:19','nacos','192.168.32.50','','',NULL,NULL,NULL,'text',NULL,'');
INSERT INTO nacos.his_config_info (id,data_id,group_id,app_name,content,md5,gmt_create,gmt_modified,src_user,src_ip,op_type,tenant_id,encrypted_data_key) VALUES
	 (4,'webide','aigc','','url: http://192.168.34.7:8080/','0926d37df72fd22c447dde025172221c','2025-11-25 14:14:07','2025-11-25 14:14:08','nacos','192.168.32.50','D','',''),
	 (0,'cloudflow','aigc','','baseUrl=http://192.168.34.7:8032
key=ZGVmYXVsdC1hZG1pbi1hcGkta2V5','997231e0cbadd8b59c9a0733c7cb563d','2025-11-25 14:15:18','2025-11-25 14:15:18','nacos','192.168.32.50','I','',''),
	 (0,'pdf-translate','aigc','','baseUrl=http://192.168.34.7:7860
xinferenceHost=http://10.20.25.2:9997
xinferenceModelId=SecGPT','1b2c4156d9ceb981ab7a746c48895892','2025-11-25 14:15:18','2025-11-25 14:15:18','nacos','192.168.32.50','I','',''),
	 (0,'api-token','aigc','','prefix: sec_
secretKey: 7hhqRj8A59BgU7Q8jcauPn3Q4e1gufMA
randomBytesLength: 32
# expirationSeconds 不配置，默认为 null，永不过期','237b4ec45c638634e6fe8c8bb845be1d','2025-11-25 14:15:18','2025-11-25 14:15:18','nacos','192.168.32.50','I','',''),
	 (0,'api-token-security','aigc','','# 速率限制配置
rate-limit.enabled=true
rate-limit.requests-per-minute=60
rate-limit.strict-requests-per-minute=20
rate-limit.window-seconds=60

# 失败锁定配置
failure-lock.enabled=true
failure-lock.max-failures-per-ip=5
failure-lock.ip-lock-duration-minutes=15
failure-lock.max-failures-per-token=10
failure-lock.token-lock-duration-minutes=30

# 延迟配置
delay.enabled=true
delay.base-delay-ms=100
delay.max-delay-ms=2000
delay.exponential-base=2

# 监控告警配置
monitoring.enabled=true
monitoring.alert-threshold-ip-hourly=50
monitoring.alert-threshold-global-minute=1000
monitoring.alert-threshold-lock-daily=10','115f5141c0af0e60a1ad5548b17e4580','2025-11-25 14:15:18','2025-11-25 14:15:19','nacos','192.168.32.50','I','',''),
	 (12,'paper','aigc','','baseUrl=http://192.168.31.74:18080
enabled=true
apiVersion=v1
apiKey=3c456f01-b496-451a-9a61-908233679317
apiKeyHeaderName=X-API-Key
enableApiKeyAuth=true','60160e4d13271b95de9b593f2652f58b','2025-11-25 19:45:35','2025-11-25 19:45:35','nacos','192.168.32.30','U','',''),
	 (11,'knowledge','aigc','','baseUrl=http://192.168.31.74:18080
enabled=true
apiVersion=v1
apiKey=3c456f01-b496-451a-9a61-908233679317
apiKeyHeaderName=X-API-Key
enableApiKeyAuth=true','60160e4d13271b95de9b593f2652f58b','2025-11-25 19:45:46','2025-11-25 19:45:46','nacos','192.168.32.30','U','',''),
	 (8,'rag','aigc','','base-url=http://192.168.34.7:30002
api-key=02988ca9d78640f7989cd64e1a34df15
paper-api-key=2dd13f7a99d9451db8ae751a7b069fd2','88e111d8bbd37bea247699282d82e590','2025-11-25 19:51:18','2025-11-25 19:51:19','nacos','192.168.32.30','U','',''),
	 (10,'safety-information','aigc','','baseUrl=http://192.168.31.74:18080
enabled=true
apiVersion=v1
apiKey=3c456f01-b496-451a-9a61-908233679317
apiKeyHeaderName=X-API-Key
enableApiKeyAuth=true','60160e4d13271b95de9b593f2652f58b','2025-11-25 19:56:52','2025-11-25 19:56:53','nacos','192.168.32.30','U','','');
INSERT INTO nacos.roles (username,`role`) VALUES
	 ('nacos','ROLE_ADMIN');
INSERT INTO nacos.users (username,password,enabled) VALUES
	 ('nacos','$2a$10$ljWomTYz4hK7mZZq02kJsOdAE2tAkDh7KLeN6vpDr5Qua1cD4TNze',1);
