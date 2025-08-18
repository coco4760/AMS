INSERT INTO public.accounts (id,"name",email,"password",password_salt,avatar,interface_language,interface_theme,timezone,last_login_at,last_login_ip,status,initialized_at,created_at,updated_at,last_active_at) VALUES
	 ('8b3128aa-cf5a-47c7-be68-fee8bcec51f7'::uuid,'admin','admin@clouditera.com','ZWEzZjZkY2Q5YWM2OGExOGQ3ZmYxNDU0NzdjODUxOTYwN2QwNTZhOTkxMGFhZWY4Y2Q1MjgyMTcyMTJiMGM1ZA==','NvP+wJ/GG+inEpsUlzC8Yg==',NULL,'en-US','light','America/New_York','2025-08-18 06:03:14.74237','192.168.35.34','active','2025-08-18 06:03:10.962781','2025-08-18 06:03:11','2025-08-18 06:03:11','2025-08-18 09:41:03.052276');
INSERT INTO public.alembic_version (version_num) VALUES
	 ('6a9f914f656c');
INSERT INTO public.dify_setups ("version",setup_at) VALUES
	 ('1.3.1','2025-08-18 06:03:11');
INSERT INTO public.tenant_account_joins (id,tenant_id,account_id,"role",invited_by,created_at,updated_at,"current") VALUES
	 ('a0e90a89-b15a-492a-bc3f-fe7d2aac50d6'::uuid,'5a1eb0a8-9ccf-4a4a-9101-7d6273ee5bb3'::uuid,'8b3128aa-cf5a-47c7-be68-fee8bcec51f7'::uuid,'owner',NULL,'2025-08-18 06:03:11','2025-08-18 06:03:11',true);
INSERT INTO public.tenants (id,"name",encrypt_public_key,plan,status,created_at,updated_at,custom_config) VALUES
	 ('5a1eb0a8-9ccf-4a4a-9101-7d6273ee5bb3'::uuid,'admin''s Workspace','-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArNp+wyv0pUf5qvaf9vOW
zHhG06oocLKlEfWlX+2w9sL+XYy6ojV9M5TjYTB8LL7Nle5Jwr4IkZralWBgjRdp
4pnwO7eyEXobXRCeY51QwxrjEefLnRGAldKJ04yWCK+IzDvfQI7hspQ8637HBqRM
mtSEbM7v0cAwhB2Ed2n34ULj3WdZt+Wug1v71bUkDr/MDx8Qf7ChzIUqgdet+J+I
0tjuvjj8UX8UpPXh3Mero2w2C2itNWEBTr4E2C1qc8rVIX1CIsey+GCbT965za9A
3DO7zkgnHeINJkF+A2E7IORqw3xsX79Yb3pgSEFxIzfr8I7bdSn4T90zzRZDloWC
AwIDAQAB
-----END PUBLIC KEY-----','basic','normal','2025-08-18 06:03:11','2025-08-18 06:03:11',NULL);
INSERT INTO public.tool_builtin_providers (id,tenant_id,user_id,provider,encrypted_credentials,created_at,updated_at) VALUES
	 ('be51dd48-8b87-4733-8ead-031e69ab0ea6'::uuid,'5a1eb0a8-9ccf-4a4a-9101-7d6273ee5bb3'::uuid,'8b3128aa-cf5a-47c7-be68-fee8bcec51f7'::uuid,'junjiem/mcp_sse/mcp_sse','{"servers_config": "{     \"mcpServers\":     {         \"nmap_tool\":         {             \"url\": \"http://192.168.31.92:18089/sse\",             \"transport\": \"sse\",         \t\"timeout\": 3600,         \t\"sse_read_timeout\": 3600         }     } }"}','2025-08-18 09:42:21','2025-08-18 09:42:21');
