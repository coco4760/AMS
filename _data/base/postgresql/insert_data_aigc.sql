INSERT INTO public.accounts (id,"name",email,"password",password_salt,avatar,interface_language,interface_theme,timezone,last_login_at,last_login_ip,status,initialized_at,created_at,updated_at,last_active_at) VALUES
	 ('8b3128aa-cf5a-47c7-be68-fee8bcec51f7'::uuid,'admin','admin@clouditera.com','ZmQ5YmNlOWE5MGEyODAyMTk0NmI4MWJkY2M0YWM2YzVjMGFjOTc3YTg2MjM4ZjQ0ZmYyZDU5NmZkNzVmNDI3NA==','hKtrkpkZI56k7jST4S7PeA==',NULL,'en-US','light','America/New_York','2025-08-13 13:09:15.975223','192.168.35.37','active','2025-08-13 12:42:27.277037','2025-08-13 12:42:27','2025-08-13 12:42:27','2025-08-13 13:09:16.184274');
INSERT INTO public.alembic_version (version_num) VALUES
	 ('6a9f914f656c');
INSERT INTO public.dify_setups ("version",setup_at) VALUES
	 ('1.3.1','2025-08-13 12:42:28');
INSERT INTO public.tenant_account_joins (id,tenant_id,account_id,"role",invited_by,created_at,updated_at,"current") VALUES
	 ('d159f6cb-7ffe-4fe5-b33c-f1539e50b56b'::uuid,'9186e376-3969-473c-b9ba-cbd90872f749'::uuid,'8b3128aa-cf5a-47c7-be68-fee8bcec51f7'::uuid,'owner',NULL,'2025-08-13 12:42:27','2025-08-13 12:42:27',true);
INSERT INTO public.tenants (id,"name",encrypt_public_key,plan,status,created_at,updated_at,custom_config) VALUES
	 ('9186e376-3969-473c-b9ba-cbd90872f749'::uuid,'admin''s Workspace','-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmFC4JcZKhkuPqtqIn4jP
sqNFQX3tssF9f3dipgBg86RKnfhTyLVL6artXu+KDD2b9UNYIj3peakg/eH2SIjT
5/eXodYte97Ncz+hfJcr5Ad5WuiMZmtBKYDdZiKPQQ0b+/StcUEAk05Utb/NU70r
6wHzjd1DOgxis6F0G1poGWgTjrVOw7mrKx0MfYLF2dXBLeC9uLSSs5ptzkX9+L0F
/b4PY7vugP2SiYzKv9w8sDBAMKrr5leiGEZZ8FzfsOgcaIHoK7Po92j0+Esrqu/m
TNKglaMPbni94QLhl9K41knzqEx8RU8Re1TrKxwjjGNIRBJujvp8kYpFq/Sa8YT6
VwIDAQAB
-----END PUBLIC KEY-----','basic','normal','2025-08-13 12:42:27','2025-08-13 12:42:27',NULL);
