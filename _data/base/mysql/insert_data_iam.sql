
INSERT INTO clouditera_iam.RESOURCE_SERVER (ID,ALLOW_RS_REMOTE_MGMT,POLICY_ENFORCE_MODE,DECISION_STRATEGY) VALUES
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016',1,0,1);
INSERT INTO clouditera_iam.RESOURCE_SERVER_POLICY (ID,NAME,DESCRIPTION,`TYPE`,DECISION_STRATEGY,LOGIC,RESOURCE_SERVER_ID,OWNER) VALUES
	 ('4a6dac54-3d20-4a22-97e4-5ecc38956b31','Default Permission','A permission that applies to the default resource type','resource',1,0,'f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL),
	 ('ffdc6e2e-3636-413e-9e23-666cbd7b81d4','Default Policy','A policy that grants access only for users within this realm','js',0,0,'f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL);
INSERT INTO clouditera_iam.ASSOCIATED_POLICY (POLICY_ID,ASSOCIATED_POLICY_ID) VALUES
	 ('4a6dac54-3d20-4a22-97e4-5ecc38956b31','ffdc6e2e-3636-413e-9e23-666cbd7b81d4');
INSERT INTO clouditera_iam.RESOURCE_SERVER_RESOURCE (ID,NAME,`TYPE`,ICON_URI,OWNER,RESOURCE_SERVER_ID,OWNER_MANAGED_ACCESS,DISPLAY_NAME) VALUES
	 ('aa07691c-e17c-484b-b5f9-d925eb552641','Default Resource','urn:clouditera-aigc:resources:default',NULL,'f4e8abbb-ea16-4f52-a616-3c56d5099016','f4e8abbb-ea16-4f52-a616-3c56d5099016',0,NULL);
INSERT INTO clouditera_iam.RESOURCE_URIS (RESOURCE_ID,VALUE) VALUES
	 ('aa07691c-e17c-484b-b5f9-d925eb552641','/*');
INSERT INTO clouditera_iam.REALM (ID,ACCESS_CODE_LIFESPAN,USER_ACTION_LIFESPAN,ACCESS_TOKEN_LIFESPAN,ACCOUNT_THEME,ADMIN_THEME,EMAIL_THEME,ENABLED,EVENTS_ENABLED,EVENTS_EXPIRATION,LOGIN_THEME,NAME,NOT_BEFORE,PASSWORD_POLICY,REGISTRATION_ALLOWED,REMEMBER_ME,RESET_PASSWORD_ALLOWED,SOCIAL,SSL_REQUIRED,SSO_IDLE_TIMEOUT,SSO_MAX_LIFESPAN,UPDATE_PROFILE_ON_SOC_LOGIN,VERIFY_EMAIL,MASTER_ADMIN_CLIENT,LOGIN_LIFESPAN,INTERNATIONALIZATION_ENABLED,DEFAULT_LOCALE,REG_EMAIL_AS_USERNAME,ADMIN_EVENTS_ENABLED,ADMIN_EVENTS_DETAILS_ENABLED,EDIT_USERNAME_ALLOWED,OTP_POLICY_COUNTER,OTP_POLICY_WINDOW,OTP_POLICY_PERIOD,OTP_POLICY_DIGITS,OTP_POLICY_ALG,OTP_POLICY_TYPE,BROWSER_FLOW,REGISTRATION_FLOW,DIRECT_GRANT_FLOW,RESET_CREDENTIALS_FLOW,CLIENT_AUTH_FLOW,OFFLINE_SESSION_IDLE_TIMEOUT,REVOKE_REFRESH_TOKEN,ACCESS_TOKEN_LIFE_IMPLICIT,LOGIN_WITH_EMAIL_ALLOWED,DUPLICATE_EMAILS_ALLOWED,DOCKER_AUTH_FLOW,REFRESH_TOKEN_MAX_REUSE,ALLOW_USER_MANAGED_ACCESS,SSO_MAX_LIFESPAN_REMEMBER_ME,SSO_IDLE_TIMEOUT_REMEMBER_ME,DEFAULT_ROLE) VALUES
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b',60,300,60,NULL,NULL,NULL,1,0,0,NULL,'master',0,NULL,0,0,0,0,'EXTERNAL',1800,36000,0,0,'3d4280b2-bb1c-4887-8993-7224db306067',1800,0,NULL,0,0,0,0,0,1,30,6,'HmacSHA1','totp','a61a92eb-c29c-4933-bdae-6e5148e93635','a361366b-2dcd-4f86-b159-b0d7cd5c9d41','859f6d3b-698d-4c33-b4df-5075359ceae0','ec045387-89ef-4b01-b949-f080c833ab59','b4fd06e2-1fb7-46bb-9dd3-7fa2b71a4330',2592000,0,900,1,0,'42a572fb-c1fe-477d-ae59-e1c161d81527',0,0,0,0,'c9730148-aec2-4a68-aba6-b42f489e4c5c'),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66',86400,86400,86400,NULL,NULL,NULL,1,0,0,NULL,'Clouditera-IAM',0,NULL,0,0,0,0,'EXTERNAL',86400,86400,0,0,'d47426f4-d00b-4660-ab3c-7cc504993d5e',86400,0,NULL,0,0,0,0,0,1,30,6,'HmacSHA1','totp','77739319-f4e0-4fcd-84bf-e83ee89170ef','221bc73f-e1fe-4d1d-bef9-c3d0b8223d93','4583e5cd-70f1-4dc2-8397-15456c7b799c','18bf1b99-9346-4e59-a67a-08324436eb05','b5c610f9-0002-4771-8e87-94cacafd3773',86400,0,86400,1,0,'7a74dfc6-d94b-4509-bb77-2bc1be28bb4d',0,0,0,0,'26d8c85f-6a60-4b25-a424-2af677dd225d');
INSERT INTO clouditera_iam.AUTHENTICATION_FLOW (ID,ALIAS,DESCRIPTION,REALM_ID,PROVIDER_ID,TOP_LEVEL,BUILT_IN) VALUES
	 ('09f27f09-0b63-4c83-9f3f-65e021ca3071','Handle Existing Account','Handle what to do if there is existing account with same email/username like authenticated identity provider','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('15b477b1-68f3-41f8-8647-e9d9de210ef2','Browser - Conditional OTP','Flow to determine if the OTP is required for the authentication','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('18bf1b99-9346-4e59-a67a-08324436eb05','reset credentials','Reset credentials for a user if they forgot their password or something','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('2043085a-009b-493b-b0e9-083fcffcf858','User creation or linking','Flow for the existing/non-existing user alternatives','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('221bc73f-e1fe-4d1d-bef9-c3d0b8223d93','registration','registration flow','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('2a63dad3-5ed0-4533-96ef-7d8cd8f66ae4','first broker login','Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1),
	 ('2be0b728-c72a-41e6-81ec-1904bf7a5446','User creation or linking','Flow for the existing/non-existing user alternatives','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('3b0f2615-7f76-4a16-9476-b2b376d24876','First broker login - Conditional OTP','Flow to determine if the OTP is required for the authentication','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('42a572fb-c1fe-477d-ae59-e1c161d81527','docker auth','Used by Docker clients to authenticate against the IDP','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1),
	 ('448aac02-e2db-4c7f-abbf-4a7c0f17f5b4','Handle Existing Account','Handle what to do if there is existing account with same email/username like authenticated identity provider','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1);
INSERT INTO clouditera_iam.AUTHENTICATION_FLOW (ID,ALIAS,DESCRIPTION,REALM_ID,PROVIDER_ID,TOP_LEVEL,BUILT_IN) VALUES
	 ('45634520-b6e2-4be8-8d74-6a5a34e7432d','saml ecp','SAML ECP Profile Authentication Flow','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('4583e5cd-70f1-4dc2-8397-15456c7b799c','direct grant','OpenID Connect Resource Owner Grant','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('6075f910-4600-4161-abd4-89c396badaa9','Browser - Conditional OTP','Flow to determine if the OTP is required for the authentication','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('6863ab9b-269e-4475-a649-f27aec1ce8ee','Reset - Conditional OTP','Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('6ed6b3fd-a8a8-4d76-90db-ef3a8cae32e7','forms','Username, password, otp and other auth forms.','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('6f1750b5-0a81-45d7-a6b4-4c138d4c6ee9','first broker login','Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('77739319-f4e0-4fcd-84bf-e83ee89170ef','browser','browser based authentication','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('7a74dfc6-d94b-4509-bb77-2bc1be28bb4d','docker auth','Used by Docker clients to authenticate against the IDP','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',1,1),
	 ('7cc3f16d-2717-4fcf-888c-8e1923f55a5c','Reset - Conditional OTP','Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('7fada7ee-e07d-4ec2-bd2d-26189a8805fc','forms','Username, password, otp and other auth forms.','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1);
INSERT INTO clouditera_iam.AUTHENTICATION_FLOW (ID,ALIAS,DESCRIPTION,REALM_ID,PROVIDER_ID,TOP_LEVEL,BUILT_IN) VALUES
	 ('859f6d3b-698d-4c33-b4df-5075359ceae0','direct grant','OpenID Connect Resource Owner Grant','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1),
	 ('8c464f53-732e-43c8-b3f6-500980f6c61f','Account verification options','Method with which to verity the existing account','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('919f4d14-a9ed-4baf-8247-2a3ccf3bf276','Direct Grant - Conditional OTP','Flow to determine if the OTP is required for the authentication','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('991a0b4c-3451-4eb5-9991-82e720a33d07','registration form','registration form','c433f707-f45a-4a7b-b213-efe294a99f66','form-flow',0,1),
	 ('a361366b-2dcd-4f86-b159-b0d7cd5c9d41','registration','registration flow','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1),
	 ('a50d0568-d101-4de0-bed3-dbb797ef4287','saml ecp','SAML ECP Profile Authentication Flow','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1),
	 ('a61a92eb-c29c-4933-bdae-6e5148e93635','browser','browser based authentication','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1),
	 ('b2bcc88f-90f2-497c-9185-a60a0956ba51','Direct Grant - Conditional OTP','Flow to determine if the OTP is required for the authentication','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('b4fd06e2-1fb7-46bb-9dd3-7fa2b71a4330','clients','Base authentication for clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','client-flow',1,1),
	 ('b5c610f9-0002-4771-8e87-94cacafd3773','clients','Base authentication for clients','c433f707-f45a-4a7b-b213-efe294a99f66','client-flow',1,1);
INSERT INTO clouditera_iam.AUTHENTICATION_FLOW (ID,ALIAS,DESCRIPTION,REALM_ID,PROVIDER_ID,TOP_LEVEL,BUILT_IN) VALUES
	 ('b5f42884-66a1-48a1-b6f7-a74ebe045553','Account verification options','Method with which to verity the existing account','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('cc3a3c48-43f4-4369-b96e-1b29eb6b4f2b','Verify Existing Account by Re-authentication','Reauthentication of existing account','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',0,1),
	 ('d4132a36-4e82-4f1f-b04a-fd7902a736ba','registration form','registration form','73b44a4b-16ae-442b-adf5-60e57d986b2b','form-flow',0,1),
	 ('dc376a9b-a3f0-4e84-b7a1-d0f3abd23c1e','First broker login - Conditional OTP','Flow to determine if the OTP is required for the authentication','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('e97972d0-948b-45c9-b934-6a25b92683a5','Verify Existing Account by Re-authentication','Reauthentication of existing account','c433f707-f45a-4a7b-b213-efe294a99f66','basic-flow',0,1),
	 ('ec045387-89ef-4b01-b949-f080c833ab59','reset credentials','Reset credentials for a user if they forgot their password or something','73b44a4b-16ae-442b-adf5-60e57d986b2b','basic-flow',1,1);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('022c0d9c-d582-47d5-aa9e-8812bb2f6da4',NULL,'http-basic-authenticator','c433f707-f45a-4a7b-b213-efe294a99f66','45634520-b6e2-4be8-8d74-6a5a34e7432d',0,10,0,NULL,NULL),
	 ('02743709-8971-47ff-9f94-1ba6863d243b',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','859f6d3b-698d-4c33-b4df-5075359ceae0',1,30,1,'b2bcc88f-90f2-497c-9185-a60a0956ba51',NULL),
	 ('0940dad3-5398-4bd5-82a9-5988dd90bcf7',NULL,'auth-username-password-form','c433f707-f45a-4a7b-b213-efe294a99f66','6ed6b3fd-a8a8-4d76-90db-ef3a8cae32e7',0,10,0,NULL,NULL),
	 ('0af8a49c-3259-45a0-bc5e-4a52a601be14',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','2043085a-009b-493b-b0e9-083fcffcf858',2,20,1,'448aac02-e2db-4c7f-abbf-4a7c0f17f5b4',NULL),
	 ('0cab19d8-32a6-4758-a54f-7294623ff3fe',NULL,'docker-http-basic-authenticator','c433f707-f45a-4a7b-b213-efe294a99f66','7a74dfc6-d94b-4509-bb77-2bc1be28bb4d',0,10,0,NULL,NULL),
	 ('0e974141-6fed-4d11-8d5d-1087d1050abe',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','6ed6b3fd-a8a8-4d76-90db-ef3a8cae32e7',1,20,1,'15b477b1-68f3-41f8-8647-e9d9de210ef2',NULL),
	 ('152e4911-b47b-4f78-bfa3-68a2488a1e59',NULL,'idp-email-verification','c433f707-f45a-4a7b-b213-efe294a99f66','8c464f53-732e-43c8-b3f6-500980f6c61f',2,10,0,NULL,NULL),
	 ('16d65793-20d7-48eb-b405-0df51b007556',NULL,'client-secret-jwt','73b44a4b-16ae-442b-adf5-60e57d986b2b','b4fd06e2-1fb7-46bb-9dd3-7fa2b71a4330',2,30,0,NULL,NULL),
	 ('18db1caa-a6ae-4dac-9a59-dc4d856b0339',NULL,'reset-password','73b44a4b-16ae-442b-adf5-60e57d986b2b','ec045387-89ef-4b01-b949-f080c833ab59',0,30,0,NULL,NULL),
	 ('1a2b2e19-40fa-4131-a089-8439684e2ecd',NULL,'registration-password-action','c433f707-f45a-4a7b-b213-efe294a99f66','991a0b4c-3451-4eb5-9991-82e720a33d07',0,50,0,NULL,NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('1fd3fa4e-b845-4f6c-8c8e-5be6e5ee4ff5',NULL,'direct-grant-validate-username','c433f707-f45a-4a7b-b213-efe294a99f66','4583e5cd-70f1-4dc2-8397-15456c7b799c',0,10,0,NULL,NULL),
	 ('2142886a-642e-4606-ba0e-41dcf4cf8524',NULL,'reset-credential-email','73b44a4b-16ae-442b-adf5-60e57d986b2b','ec045387-89ef-4b01-b949-f080c833ab59',0,20,0,NULL,NULL),
	 ('222e6b1f-0197-4f6f-97c2-cdbc64095961',NULL,'auth-otp-form','73b44a4b-16ae-442b-adf5-60e57d986b2b','6075f910-4600-4161-abd4-89c396badaa9',0,20,0,NULL,NULL),
	 ('28a3d576-aa76-4da4-8d56-a3b1b13c86dd',NULL,'client-secret','73b44a4b-16ae-442b-adf5-60e57d986b2b','b4fd06e2-1fb7-46bb-9dd3-7fa2b71a4330',2,10,0,NULL,NULL),
	 ('2991a84e-3115-482f-aaa0-e2178e7de171',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','b5f42884-66a1-48a1-b6f7-a74ebe045553',2,20,1,'cc3a3c48-43f4-4369-b96e-1b29eb6b4f2b',NULL),
	 ('2bd8d6bf-0aa1-44b5-9546-147c4427f347',NULL,'registration-recaptcha-action','73b44a4b-16ae-442b-adf5-60e57d986b2b','d4132a36-4e82-4f1f-b04a-fd7902a736ba',3,60,0,NULL,NULL),
	 ('2bfefeb8-8ef1-452b-8506-80ffd65313f8',NULL,'direct-grant-validate-username','73b44a4b-16ae-442b-adf5-60e57d986b2b','859f6d3b-698d-4c33-b4df-5075359ceae0',0,10,0,NULL,NULL),
	 ('31a97400-84e2-425e-8c1e-f5937656d5f8',NULL,'auth-otp-form','73b44a4b-16ae-442b-adf5-60e57d986b2b','3b0f2615-7f76-4a16-9476-b2b376d24876',0,20,0,NULL,NULL),
	 ('33ff27f8-09fd-474c-9bcb-cb842464ee63',NULL,'registration-password-action','73b44a4b-16ae-442b-adf5-60e57d986b2b','d4132a36-4e82-4f1f-b04a-fd7902a736ba',0,50,0,NULL,NULL),
	 ('35d2ada2-ace0-4542-8a5b-df1c06ba029f',NULL,'conditional-user-configured','73b44a4b-16ae-442b-adf5-60e57d986b2b','6075f910-4600-4161-abd4-89c396badaa9',0,10,0,NULL,NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('37009cd1-a81c-45fe-b750-899ac2aeaa23',NULL,'client-x509','c433f707-f45a-4a7b-b213-efe294a99f66','b5c610f9-0002-4771-8e87-94cacafd3773',2,40,0,NULL,NULL),
	 ('3b3416b6-dedd-43cb-98eb-c97ea4928a5f',NULL,'idp-username-password-form','73b44a4b-16ae-442b-adf5-60e57d986b2b','cc3a3c48-43f4-4369-b96e-1b29eb6b4f2b',0,10,0,NULL,NULL),
	 ('3db5fb57-bc72-4328-a333-beebbc4bfb33',NULL,'registration-terms-and-conditions','73b44a4b-16ae-442b-adf5-60e57d986b2b','d4132a36-4e82-4f1f-b04a-fd7902a736ba',3,70,0,NULL,NULL),
	 ('3f231a63-d07d-45a5-b744-ab8d2cb60276',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','2be0b728-c72a-41e6-81ec-1904bf7a5446',2,20,1,'09f27f09-0b63-4c83-9f3f-65e021ca3071',NULL),
	 ('42a2ed23-798b-4bde-b521-e3e0270893e0',NULL,'conditional-user-configured','c433f707-f45a-4a7b-b213-efe294a99f66','919f4d14-a9ed-4baf-8247-2a3ccf3bf276',0,10,0,NULL,NULL),
	 ('45d2ed67-a258-4f41-adb6-e59e5a9fcccc',NULL,'conditional-user-configured','c433f707-f45a-4a7b-b213-efe294a99f66','6863ab9b-269e-4475-a649-f27aec1ce8ee',0,10,0,NULL,NULL),
	 ('47372edf-0407-403a-a239-f6176c462d20',NULL,'registration-profile-action','73b44a4b-16ae-442b-adf5-60e57d986b2b','d4132a36-4e82-4f1f-b04a-fd7902a736ba',0,40,0,NULL,NULL),
	 ('474716f1-af1c-4a4a-b55f-ab4695b4d85b',NULL,'client-secret-jwt','c433f707-f45a-4a7b-b213-efe294a99f66','b5c610f9-0002-4771-8e87-94cacafd3773',2,30,0,NULL,NULL),
	 ('4766f582-76d7-4526-a6e4-e51a2b72e197',NULL,'identity-provider-redirector','c433f707-f45a-4a7b-b213-efe294a99f66','77739319-f4e0-4fcd-84bf-e83ee89170ef',2,25,0,NULL,NULL),
	 ('482d7ba4-1556-403c-8ce8-5ae30000a8d5',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','cc3a3c48-43f4-4369-b96e-1b29eb6b4f2b',1,20,1,'3b0f2615-7f76-4a16-9476-b2b376d24876',NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('4967f299-6e6e-4677-bf2a-93c17f0ffdf9',NULL,'reset-credential-email','c433f707-f45a-4a7b-b213-efe294a99f66','18bf1b99-9346-4e59-a67a-08324436eb05',0,20,0,NULL,NULL),
	 ('4d4c486c-802b-46bd-bcd2-7424cd2c9b54',NULL,'idp-create-user-if-unique','c433f707-f45a-4a7b-b213-efe294a99f66','2043085a-009b-493b-b0e9-083fcffcf858',2,10,0,NULL,'db8529b6-4b41-4103-b603-de8677dcf878'),
	 ('4e3cd52c-72cb-4fd9-8f2c-b29077bf26ee',NULL,'idp-username-password-form','c433f707-f45a-4a7b-b213-efe294a99f66','e97972d0-948b-45c9-b934-6a25b92683a5',0,10,0,NULL,NULL),
	 ('4fdc1f32-5f67-4c5f-82b0-9171c6a46b14',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','8c464f53-732e-43c8-b3f6-500980f6c61f',2,20,1,'e97972d0-948b-45c9-b934-6a25b92683a5',NULL),
	 ('51913623-087d-47df-843d-cbc5408eb32a',NULL,'idp-review-profile','73b44a4b-16ae-442b-adf5-60e57d986b2b','2a63dad3-5ed0-4533-96ef-7d8cd8f66ae4',0,10,0,NULL,'5884b1d2-579f-431a-91f9-fc27f4a96329'),
	 ('519cc2da-ea25-43aa-bb35-1950994bfb24',NULL,'client-jwt','c433f707-f45a-4a7b-b213-efe294a99f66','b5c610f9-0002-4771-8e87-94cacafd3773',2,20,0,NULL,NULL),
	 ('578901cd-352d-4b69-b445-003a485562d1',NULL,'reset-credentials-choose-user','c433f707-f45a-4a7b-b213-efe294a99f66','18bf1b99-9346-4e59-a67a-08324436eb05',0,10,0,NULL,NULL),
	 ('61fa43ed-afd8-492b-88f7-e6d2680ae23d',NULL,'direct-grant-validate-otp','c433f707-f45a-4a7b-b213-efe294a99f66','919f4d14-a9ed-4baf-8247-2a3ccf3bf276',0,20,0,NULL,NULL),
	 ('6436c9fa-7b13-403f-8ddd-57c78c715503',NULL,'client-x509','73b44a4b-16ae-442b-adf5-60e57d986b2b','b4fd06e2-1fb7-46bb-9dd3-7fa2b71a4330',2,40,0,NULL,NULL),
	 ('64c86d2f-ec64-4e73-bf5d-474159e6e0eb',NULL,'conditional-user-configured','c433f707-f45a-4a7b-b213-efe294a99f66','dc376a9b-a3f0-4e84-b7a1-d0f3abd23c1e',0,10,0,NULL,NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('64d63586-139d-4f26-bdfc-cc71f6e88f18',NULL,'direct-grant-validate-otp','73b44a4b-16ae-442b-adf5-60e57d986b2b','b2bcc88f-90f2-497c-9185-a60a0956ba51',0,20,0,NULL,NULL),
	 ('67c39468-20c8-4930-b73e-fce4f8597825',NULL,'auth-otp-form','c433f707-f45a-4a7b-b213-efe294a99f66','dc376a9b-a3f0-4e84-b7a1-d0f3abd23c1e',0,20,0,NULL,NULL),
	 ('6c0a3acd-22f9-4a3a-9f9c-d6634bb91066',NULL,'idp-confirm-link','73b44a4b-16ae-442b-adf5-60e57d986b2b','09f27f09-0b63-4c83-9f3f-65e021ca3071',0,10,0,NULL,NULL),
	 ('6f9d7617-fb49-4c01-ace3-1b4c107e80d9',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','18bf1b99-9346-4e59-a67a-08324436eb05',1,40,1,'6863ab9b-269e-4475-a649-f27aec1ce8ee',NULL),
	 ('7146d908-57d0-480f-a77f-65c385c9c71f',NULL,'idp-email-verification','73b44a4b-16ae-442b-adf5-60e57d986b2b','b5f42884-66a1-48a1-b6f7-a74ebe045553',2,10,0,NULL,NULL),
	 ('78136d8f-6ed6-446b-944d-8c3b2255c445',NULL,'direct-grant-validate-password','73b44a4b-16ae-442b-adf5-60e57d986b2b','859f6d3b-698d-4c33-b4df-5075359ceae0',0,20,0,NULL,NULL),
	 ('782ba09c-2d52-411f-8589-51c5650b14b0',NULL,'idp-confirm-link','c433f707-f45a-4a7b-b213-efe294a99f66','448aac02-e2db-4c7f-abbf-4a7c0f17f5b4',0,10,0,NULL,NULL),
	 ('7c3c7cad-0bda-4feb-ac35-3be8165e454c',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','77739319-f4e0-4fcd-84bf-e83ee89170ef',2,30,1,'6ed6b3fd-a8a8-4d76-90db-ef3a8cae32e7',NULL),
	 ('7d210720-40ba-4392-b9e2-ae31f8412e04',NULL,'auth-username-password-form','73b44a4b-16ae-442b-adf5-60e57d986b2b','7fada7ee-e07d-4ec2-bd2d-26189a8805fc',0,10,0,NULL,NULL),
	 ('810e651a-ea65-4b44-aab2-604c98f276b8',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','a61a92eb-c29c-4933-bdae-6e5148e93635',2,30,1,'7fada7ee-e07d-4ec2-bd2d-26189a8805fc',NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('87e5da06-9308-4873-9dc6-fe0a013485ca',NULL,'auth-spnego','c433f707-f45a-4a7b-b213-efe294a99f66','77739319-f4e0-4fcd-84bf-e83ee89170ef',3,20,0,NULL,NULL),
	 ('8883cddc-2ec3-45a7-9be1-34002cbbf955',NULL,'registration-page-form','c433f707-f45a-4a7b-b213-efe294a99f66','221bc73f-e1fe-4d1d-bef9-c3d0b8223d93',0,10,1,'991a0b4c-3451-4eb5-9991-82e720a33d07',NULL),
	 ('916e5d1c-1b33-4d6d-9119-22f49ca12bbe',NULL,'registration-user-creation','73b44a4b-16ae-442b-adf5-60e57d986b2b','d4132a36-4e82-4f1f-b04a-fd7902a736ba',0,20,0,NULL,NULL),
	 ('96fbbe3a-e8b7-4a62-8c35-eaab6abd2a74',NULL,'http-basic-authenticator','73b44a4b-16ae-442b-adf5-60e57d986b2b','a50d0568-d101-4de0-bed3-dbb797ef4287',0,10,0,NULL,NULL),
	 ('a48cd0fe-da3d-4d7c-9908-baf1787b47dc',NULL,'reset-otp','73b44a4b-16ae-442b-adf5-60e57d986b2b','7cc3f16d-2717-4fcf-888c-8e1923f55a5c',0,20,0,NULL,NULL),
	 ('a4aea4c8-4496-4339-a32a-024e8158a10f',NULL,'conditional-user-configured','73b44a4b-16ae-442b-adf5-60e57d986b2b','b2bcc88f-90f2-497c-9185-a60a0956ba51',0,10,0,NULL,NULL),
	 ('a8333185-9422-4b73-9e06-1f0ddf7238ef',NULL,'conditional-user-configured','c433f707-f45a-4a7b-b213-efe294a99f66','15b477b1-68f3-41f8-8647-e9d9de210ef2',0,10,0,NULL,NULL),
	 ('a854d159-58c0-4bd4-a3ad-3cda4bb6b562',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','2a63dad3-5ed0-4533-96ef-7d8cd8f66ae4',0,20,1,'2be0b728-c72a-41e6-81ec-1904bf7a5446',NULL),
	 ('aa99bb7f-d0ef-4904-9d74-db8aa31454a7',NULL,'auth-spnego','73b44a4b-16ae-442b-adf5-60e57d986b2b','a61a92eb-c29c-4933-bdae-6e5148e93635',3,20,0,NULL,NULL),
	 ('b186cb6c-df20-444d-af69-35159c48906f',NULL,'idp-create-user-if-unique','73b44a4b-16ae-442b-adf5-60e57d986b2b','2be0b728-c72a-41e6-81ec-1904bf7a5446',2,10,0,NULL,'bae77825-c8bd-459b-8f43-79661476e9f0');
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('b51beb9f-a4da-4ff4-9f6b-ab020ecaefd2',NULL,'registration-user-creation','c433f707-f45a-4a7b-b213-efe294a99f66','991a0b4c-3451-4eb5-9991-82e720a33d07',0,20,0,NULL,NULL),
	 ('c16730db-ce71-44ea-a3ff-aab3c74a38cb',NULL,'registration-profile-action','c433f707-f45a-4a7b-b213-efe294a99f66','991a0b4c-3451-4eb5-9991-82e720a33d07',0,40,0,NULL,NULL),
	 ('c191cb83-c9fb-48e9-bd63-63f713282e7b',NULL,'registration-recaptcha-action','c433f707-f45a-4a7b-b213-efe294a99f66','991a0b4c-3451-4eb5-9991-82e720a33d07',3,60,0,NULL,NULL),
	 ('c20dd3ec-a019-4fa1-8399-7c6beee7d19b',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','448aac02-e2db-4c7f-abbf-4a7c0f17f5b4',0,20,1,'8c464f53-732e-43c8-b3f6-500980f6c61f',NULL),
	 ('c22dffad-da20-4fe2-8c0d-2b674a49dd9f',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','ec045387-89ef-4b01-b949-f080c833ab59',1,40,1,'7cc3f16d-2717-4fcf-888c-8e1923f55a5c',NULL),
	 ('c3c97abc-5528-479e-b9e8-dec0890739ec',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','6f1750b5-0a81-45d7-a6b4-4c138d4c6ee9',0,20,1,'2043085a-009b-493b-b0e9-083fcffcf858',NULL),
	 ('c8eb31e3-394e-4278-afee-fb2b928cff8c',NULL,'reset-credentials-choose-user','73b44a4b-16ae-442b-adf5-60e57d986b2b','ec045387-89ef-4b01-b949-f080c833ab59',0,10,0,NULL,NULL),
	 ('cad87191-6fb7-40eb-8371-98ca23290596',NULL,'client-jwt','73b44a4b-16ae-442b-adf5-60e57d986b2b','b4fd06e2-1fb7-46bb-9dd3-7fa2b71a4330',2,20,0,NULL,NULL),
	 ('cdd96df3-6468-49d9-bba7-df6a46e3f28a',NULL,'auth-otp-form','c433f707-f45a-4a7b-b213-efe294a99f66','15b477b1-68f3-41f8-8647-e9d9de210ef2',0,20,0,NULL,NULL),
	 ('d3aac03d-21cb-4235-97b6-81b63ab6f245',NULL,'docker-http-basic-authenticator','73b44a4b-16ae-442b-adf5-60e57d986b2b','42a572fb-c1fe-477d-ae59-e1c161d81527',0,10,0,NULL,NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('d49b88f4-77e4-4a02-b221-d0bda34bb776',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','4583e5cd-70f1-4dc2-8397-15456c7b799c',1,30,1,'919f4d14-a9ed-4baf-8247-2a3ccf3bf276',NULL),
	 ('d4b1cb20-42cd-4f22-bed1-6152ffb53591',NULL,'direct-grant-validate-password','c433f707-f45a-4a7b-b213-efe294a99f66','4583e5cd-70f1-4dc2-8397-15456c7b799c',0,20,0,NULL,NULL),
	 ('d6b2ffe5-2ca5-4fe5-907b-c1503fcf5a9f',NULL,'client-secret','c433f707-f45a-4a7b-b213-efe294a99f66','b5c610f9-0002-4771-8e87-94cacafd3773',2,10,0,NULL,NULL),
	 ('d7395699-f959-4239-a3f3-dcadec17d9bd',NULL,'registration-page-form','73b44a4b-16ae-442b-adf5-60e57d986b2b','a361366b-2dcd-4f86-b159-b0d7cd5c9d41',0,10,1,'d4132a36-4e82-4f1f-b04a-fd7902a736ba',NULL),
	 ('d784b063-a1ba-4d85-8ba4-c90f29c0ecd0',NULL,'auth-cookie','73b44a4b-16ae-442b-adf5-60e57d986b2b','a61a92eb-c29c-4933-bdae-6e5148e93635',2,10,0,NULL,NULL),
	 ('db3d4b04-07fa-48a6-aefe-2aa006d4a469',NULL,'reset-password','c433f707-f45a-4a7b-b213-efe294a99f66','18bf1b99-9346-4e59-a67a-08324436eb05',0,30,0,NULL,NULL),
	 ('e187ef61-be22-4681-bd31-9679c5957ef6',NULL,'identity-provider-redirector','73b44a4b-16ae-442b-adf5-60e57d986b2b','a61a92eb-c29c-4933-bdae-6e5148e93635',2,25,0,NULL,NULL),
	 ('e4348563-24e8-44a1-b77d-aea8c3a26b16',NULL,'idp-review-profile','c433f707-f45a-4a7b-b213-efe294a99f66','6f1750b5-0a81-45d7-a6b4-4c138d4c6ee9',0,10,0,NULL,'3b26a0a5-c906-40e5-991e-555f3babe1c1'),
	 ('ec112380-243c-43d5-b4b8-6396f5739c66',NULL,'conditional-user-configured','73b44a4b-16ae-442b-adf5-60e57d986b2b','7cc3f16d-2717-4fcf-888c-8e1923f55a5c',0,10,0,NULL,NULL),
	 ('ee10e56d-7b89-49e2-bae7-79b47233503d',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','09f27f09-0b63-4c83-9f3f-65e021ca3071',0,20,1,'b5f42884-66a1-48a1-b6f7-a74ebe045553',NULL);
INSERT INTO clouditera_iam.AUTHENTICATION_EXECUTION (ID,ALIAS,AUTHENTICATOR,REALM_ID,FLOW_ID,REQUIREMENT,PRIORITY,AUTHENTICATOR_FLOW,AUTH_FLOW_ID,AUTH_CONFIG) VALUES
	 ('f18e67ae-2e72-48f7-b7ad-6de4795a3f02',NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','7fada7ee-e07d-4ec2-bd2d-26189a8805fc',1,20,1,'6075f910-4600-4161-abd4-89c396badaa9',NULL),
	 ('f41fe5eb-3162-4efa-a99e-d715d7f5ae6d',NULL,'conditional-user-configured','73b44a4b-16ae-442b-adf5-60e57d986b2b','3b0f2615-7f76-4a16-9476-b2b376d24876',0,10,0,NULL,NULL),
	 ('f67ffb8d-4d2f-472a-91b0-8bfc28b21d1f',NULL,'auth-cookie','c433f707-f45a-4a7b-b213-efe294a99f66','77739319-f4e0-4fcd-84bf-e83ee89170ef',2,10,0,NULL,NULL),
	 ('fc4d1537-a5a2-4483-8a89-337b42e7fdb9',NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','e97972d0-948b-45c9-b934-6a25b92683a5',1,20,1,'dc376a9b-a3f0-4e84-b7a1-d0f3abd23c1e',NULL),
	 ('fe5b797c-cbb3-4ba8-9326-e971839ecc10',NULL,'reset-otp','c433f707-f45a-4a7b-b213-efe294a99f66','6863ab9b-269e-4475-a649-f27aec1ce8ee',0,20,0,NULL,NULL);

INSERT INTO clouditera_iam.AUTHENTICATOR_CONFIG (ID,ALIAS,REALM_ID) VALUES
	 ('3b26a0a5-c906-40e5-991e-555f3babe1c1','review profile config','c433f707-f45a-4a7b-b213-efe294a99f66'),
	 ('5884b1d2-579f-431a-91f9-fc27f4a96329','review profile config','73b44a4b-16ae-442b-adf5-60e57d986b2b'),
	 ('bae77825-c8bd-459b-8f43-79661476e9f0','create unique user config','73b44a4b-16ae-442b-adf5-60e57d986b2b'),
	 ('db8529b6-4b41-4103-b603-de8677dcf878','create unique user config','c433f707-f45a-4a7b-b213-efe294a99f66');
INSERT INTO clouditera_iam.AUTHENTICATOR_CONFIG_ENTRY (AUTHENTICATOR_ID,VALUE,NAME) VALUES
	 ('3b26a0a5-c906-40e5-991e-555f3babe1c1','missing','update.profile.on.first.login'),
	 ('5884b1d2-579f-431a-91f9-fc27f4a96329','missing','update.profile.on.first.login'),
	 ('bae77825-c8bd-459b-8f43-79661476e9f0','false','require.password.update.after.registration'),
	 ('db8529b6-4b41-4103-b603-de8677dcf878','false','require.password.update.after.registration');
INSERT INTO clouditera_iam.CLIENT (ID,ENABLED,FULL_SCOPE_ALLOWED,CLIENT_ID,NOT_BEFORE,PUBLIC_CLIENT,SECRET,BASE_URL,BEARER_ONLY,MANAGEMENT_URL,SURROGATE_AUTH_REQUIRED,REALM_ID,PROTOCOL,NODE_REREG_TIMEOUT,FRONTCHANNEL_LOGOUT,CONSENT_REQUIRED,NAME,SERVICE_ACCOUNTS_ENABLED,CLIENT_AUTHENTICATOR_TYPE,ROOT_URL,DESCRIPTION,REGISTRATION_TOKEN,STANDARD_FLOW_ENABLED,IMPLICIT_FLOW_ENABLED,DIRECT_ACCESS_GRANTS_ENABLED,ALWAYS_DISPLAY_IN_CONSOLE) VALUES
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,0,'account',0,1,NULL,'/realms/master/account/',0,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b','openid-connect',0,0,0,'${client_account}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae',1,0,'broker',0,0,NULL,NULL,1,NULL,0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',0,0,0,'${client_broker}',0,'client-secret',NULL,NULL,NULL,1,0,0,0),
	 ('206f7b06-c863-4604-ac80-407a44557b88',1,0,'admin-cli',0,1,NULL,NULL,0,NULL,0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',0,0,0,'${client_admin-cli}',0,'client-secret',NULL,NULL,NULL,0,0,1,0),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444',1,0,'account-console',0,1,NULL,'/realms/master/account/',0,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b','openid-connect',0,0,0,'${client_account-console}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0),
	 ('3d4280b2-bb1c-4887-8993-7224db306067',1,0,'master-realm',0,0,NULL,NULL,1,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,0,0,0,'master Realm',0,'client-secret',NULL,NULL,NULL,1,0,0,0),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,0,'realm-management',0,0,NULL,NULL,1,NULL,0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',0,0,0,'${client_realm-management}',0,'client-secret',NULL,NULL,NULL,1,0,0,0),
	 ('46dcb18d-572f-4131-92f3-c02d12458660',1,0,'security-admin-console',0,1,NULL,'/admin/Clouditera-IAM/console/',0,NULL,0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',0,0,0,'${client_security-admin-console}',0,'client-secret','${authAdminUrl}',NULL,NULL,1,0,0,0),
	 ('9c882096-4926-49b1-983d-dcd46a530518',1,0,'admin-cli',0,1,NULL,NULL,0,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b','openid-connect',0,0,0,'${client_admin-cli}',0,'client-secret',NULL,NULL,NULL,0,0,1,0),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520',1,0,'broker',0,0,NULL,NULL,1,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b','openid-connect',0,0,0,'${client_broker}',0,'client-secret',NULL,NULL,NULL,1,0,0,0),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09',1,0,'security-admin-console',0,1,NULL,'/admin/master/console/',0,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b','openid-connect',0,0,0,'${client_security-admin-console}',0,'client-secret','${authAdminUrl}',NULL,NULL,1,0,0,0);
INSERT INTO clouditera_iam.CLIENT (ID,ENABLED,FULL_SCOPE_ALLOWED,CLIENT_ID,NOT_BEFORE,PUBLIC_CLIENT,SECRET,BASE_URL,BEARER_ONLY,MANAGEMENT_URL,SURROGATE_AUTH_REQUIRED,REALM_ID,PROTOCOL,NODE_REREG_TIMEOUT,FRONTCHANNEL_LOGOUT,CONSENT_REQUIRED,NAME,SERVICE_ACCOUNTS_ENABLED,CLIENT_AUTHENTICATOR_TYPE,ROOT_URL,DESCRIPTION,REGISTRATION_TOKEN,STANDARD_FLOW_ENABLED,IMPLICIT_FLOW_ENABLED,DIRECT_ACCESS_GRANTS_ENABLED,ALWAYS_DISPLAY_IN_CONSOLE) VALUES
	 ('d47426f4-d00b-4660-ab3c-7cc504993d5e',1,0,'Clouditera-IAM-realm',0,0,NULL,NULL,1,NULL,0,'73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,0,0,0,'Clouditera-IAM Realm',0,'client-secret',NULL,NULL,NULL,1,0,0,0),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073',1,0,'account',0,1,NULL,'/realms/Clouditera-IAM/account/',0,NULL,0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',0,0,0,'${client_account}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016',1,1,'clouditera-aigc',0,0,'jbSM7ihAH8i5AlYlUF5fLYn5BTJEs1B5','',0,'',0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',-1,1,0,'clouditera-aigc',1,'client-secret','','',NULL,1,1,1,0),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005',1,0,'account-console',0,1,NULL,'/realms/Clouditera-IAM/account/',0,NULL,0,'c433f707-f45a-4a7b-b213-efe294a99f66','openid-connect',0,0,0,'${client_account-console}',0,'client-secret','${authBaseUrl}',NULL,NULL,1,0,0,0);
INSERT INTO clouditera_iam.CLIENT_ATTRIBUTES (CLIENT_ID,NAME,VALUE) VALUES
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','post.logout.redirect.uris','+'),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','pkce.code.challenge.method','S256'),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','post.logout.redirect.uris','+'),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','pkce.code.challenge.method','S256'),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','post.logout.redirect.uris','+'),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','pkce.code.challenge.method','S256'),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','post.logout.redirect.uris','+'),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','post.logout.redirect.uris','+'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','acr.loa.map','{}'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','backchannel.logout.revoke.offline.tokens','false');
INSERT INTO clouditera_iam.CLIENT_ATTRIBUTES (CLIENT_ID,NAME,VALUE) VALUES
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','backchannel.logout.session.required','true'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','client_credentials.use_refresh_token','false'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','client.secret.creation.time','1694678825'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','display.on.consent.screen','false'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','oauth2.device.authorization.grant.enabled','true'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','oidc.ciba.grant.enabled','false'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','require.pushed.authorization.requests','false'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','tls.client.certificate.bound.access.tokens','false'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','token.response.type.bearer.lower-case','false'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','use.refresh.tokens','true');
INSERT INTO clouditera_iam.CLIENT_ATTRIBUTES (CLIENT_ID,NAME,VALUE) VALUES
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','pkce.code.challenge.method','S256'),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','post.logout.redirect.uris','+');
INSERT INTO clouditera_iam.CLIENT_SCOPE (ID,NAME,REALM_ID,DESCRIPTION,PROTOCOL) VALUES
	 ('10a651c8-01bf-4e12-a518-d71e0c65898a','phone','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect built-in scope: phone','openid-connect'),
	 ('1d3b3c83-3006-465c-b232-fc2d53eda769','email','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect built-in scope: email','openid-connect'),
	 ('36ebeacf-777b-476f-a3aa-4963d45e41ae','roles','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect scope for add user roles to the access token','openid-connect'),
	 ('4ee2871d-ede3-4857-b73d-3f7662ecf0c0','profile','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect built-in scope: profile','openid-connect'),
	 ('565d39c5-e11b-4b52-9c06-e94eb40cf822','microprofile-jwt','c433f707-f45a-4a7b-b213-efe294a99f66','Microprofile - JWT built-in scope','openid-connect'),
	 ('6da29c8a-45b8-4905-af4f-41f01a8425e1','web-origins','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect scope for add allowed web origins to the access token','openid-connect'),
	 ('7303ff3f-7670-4f73-a376-05b60aa0defb','offline_access','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect built-in scope: offline_access','openid-connect'),
	 ('7cf45c65-103f-4ea9-9f3c-243e2435f172','roles','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect scope for add user roles to the access token','openid-connect'),
	 ('810c8afd-856f-4daf-9635-0d11c15e6cc4','phone','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect built-in scope: phone','openid-connect'),
	 ('86858db1-8e7c-4ee6-a77f-3474d63b4c55','acr','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect scope for add acr (authentication context class reference) to the token','openid-connect');
INSERT INTO clouditera_iam.CLIENT_SCOPE (ID,NAME,REALM_ID,DESCRIPTION,PROTOCOL) VALUES
	 ('88e86a8c-0468-43b3-991c-d7f8b55bb210','role_list','73b44a4b-16ae-442b-adf5-60e57d986b2b','SAML role list','saml'),
	 ('ae50ee14-a052-4985-a542-e21a798b1e92','profile','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect built-in scope: profile','openid-connect'),
	 ('b9cb3955-3bec-4cc8-b79b-8b463c49be5e','address','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect built-in scope: address','openid-connect'),
	 ('df60fb8f-4695-40d0-b436-ac84819e9248','acr','73b44a4b-16ae-442b-adf5-60e57d986b2b','OpenID Connect scope for add acr (authentication context class reference) to the token','openid-connect'),
	 ('e5ae7bdb-86e5-4d7a-8eeb-098c734492df','role_list','c433f707-f45a-4a7b-b213-efe294a99f66','SAML role list','saml'),
	 ('e673a90f-38bd-4221-93ca-c4043e27b012','offline_access','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect built-in scope: offline_access','openid-connect'),
	 ('eb746e3a-0234-487d-8fe6-db5a19978066','address','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect built-in scope: address','openid-connect'),
	 ('ec0e25fd-09f1-4f49-8700-ac33f94676b1','email','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect built-in scope: email','openid-connect'),
	 ('f4363b05-5882-4034-9682-413a16956e0e','microprofile-jwt','73b44a4b-16ae-442b-adf5-60e57d986b2b','Microprofile - JWT built-in scope','openid-connect'),
	 ('ff347623-d286-4d78-be8d-414f2022c755','web-origins','c433f707-f45a-4a7b-b213-efe294a99f66','OpenID Connect scope for add allowed web origins to the access token','openid-connect');
INSERT INTO clouditera_iam.CLIENT_SCOPE_ATTRIBUTES (SCOPE_ID,VALUE,NAME) VALUES
	 ('10a651c8-01bf-4e12-a518-d71e0c65898a','${phoneScopeConsentText}','consent.screen.text'),
	 ('10a651c8-01bf-4e12-a518-d71e0c65898a','true','display.on.consent.screen'),
	 ('10a651c8-01bf-4e12-a518-d71e0c65898a','true','include.in.token.scope'),
	 ('1d3b3c83-3006-465c-b232-fc2d53eda769','${emailScopeConsentText}','consent.screen.text'),
	 ('1d3b3c83-3006-465c-b232-fc2d53eda769','true','display.on.consent.screen'),
	 ('1d3b3c83-3006-465c-b232-fc2d53eda769','true','include.in.token.scope'),
	 ('36ebeacf-777b-476f-a3aa-4963d45e41ae','${rolesScopeConsentText}','consent.screen.text'),
	 ('36ebeacf-777b-476f-a3aa-4963d45e41ae','true','display.on.consent.screen'),
	 ('36ebeacf-777b-476f-a3aa-4963d45e41ae','false','include.in.token.scope'),
	 ('4ee2871d-ede3-4857-b73d-3f7662ecf0c0','${profileScopeConsentText}','consent.screen.text');
INSERT INTO clouditera_iam.CLIENT_SCOPE_ATTRIBUTES (SCOPE_ID,VALUE,NAME) VALUES
	 ('4ee2871d-ede3-4857-b73d-3f7662ecf0c0','true','display.on.consent.screen'),
	 ('4ee2871d-ede3-4857-b73d-3f7662ecf0c0','true','include.in.token.scope'),
	 ('565d39c5-e11b-4b52-9c06-e94eb40cf822','false','display.on.consent.screen'),
	 ('565d39c5-e11b-4b52-9c06-e94eb40cf822','true','include.in.token.scope'),
	 ('6da29c8a-45b8-4905-af4f-41f01a8425e1','','consent.screen.text'),
	 ('6da29c8a-45b8-4905-af4f-41f01a8425e1','false','display.on.consent.screen'),
	 ('6da29c8a-45b8-4905-af4f-41f01a8425e1','false','include.in.token.scope'),
	 ('7303ff3f-7670-4f73-a376-05b60aa0defb','${offlineAccessScopeConsentText}','consent.screen.text'),
	 ('7303ff3f-7670-4f73-a376-05b60aa0defb','true','display.on.consent.screen'),
	 ('7cf45c65-103f-4ea9-9f3c-243e2435f172','${rolesScopeConsentText}','consent.screen.text');
INSERT INTO clouditera_iam.CLIENT_SCOPE_ATTRIBUTES (SCOPE_ID,VALUE,NAME) VALUES
	 ('7cf45c65-103f-4ea9-9f3c-243e2435f172','true','display.on.consent.screen'),
	 ('7cf45c65-103f-4ea9-9f3c-243e2435f172','false','include.in.token.scope'),
	 ('810c8afd-856f-4daf-9635-0d11c15e6cc4','${phoneScopeConsentText}','consent.screen.text'),
	 ('810c8afd-856f-4daf-9635-0d11c15e6cc4','true','display.on.consent.screen'),
	 ('810c8afd-856f-4daf-9635-0d11c15e6cc4','true','include.in.token.scope'),
	 ('86858db1-8e7c-4ee6-a77f-3474d63b4c55','false','display.on.consent.screen'),
	 ('86858db1-8e7c-4ee6-a77f-3474d63b4c55','false','include.in.token.scope'),
	 ('88e86a8c-0468-43b3-991c-d7f8b55bb210','${samlRoleListScopeConsentText}','consent.screen.text'),
	 ('88e86a8c-0468-43b3-991c-d7f8b55bb210','true','display.on.consent.screen'),
	 ('ae50ee14-a052-4985-a542-e21a798b1e92','${profileScopeConsentText}','consent.screen.text');
INSERT INTO clouditera_iam.CLIENT_SCOPE_ATTRIBUTES (SCOPE_ID,VALUE,NAME) VALUES
	 ('ae50ee14-a052-4985-a542-e21a798b1e92','true','display.on.consent.screen'),
	 ('ae50ee14-a052-4985-a542-e21a798b1e92','true','include.in.token.scope'),
	 ('b9cb3955-3bec-4cc8-b79b-8b463c49be5e','${addressScopeConsentText}','consent.screen.text'),
	 ('b9cb3955-3bec-4cc8-b79b-8b463c49be5e','true','display.on.consent.screen'),
	 ('b9cb3955-3bec-4cc8-b79b-8b463c49be5e','true','include.in.token.scope'),
	 ('df60fb8f-4695-40d0-b436-ac84819e9248','false','display.on.consent.screen'),
	 ('df60fb8f-4695-40d0-b436-ac84819e9248','false','include.in.token.scope'),
	 ('e5ae7bdb-86e5-4d7a-8eeb-098c734492df','${samlRoleListScopeConsentText}','consent.screen.text'),
	 ('e5ae7bdb-86e5-4d7a-8eeb-098c734492df','true','display.on.consent.screen'),
	 ('e673a90f-38bd-4221-93ca-c4043e27b012','${offlineAccessScopeConsentText}','consent.screen.text');
INSERT INTO clouditera_iam.CLIENT_SCOPE_ATTRIBUTES (SCOPE_ID,VALUE,NAME) VALUES
	 ('e673a90f-38bd-4221-93ca-c4043e27b012','true','display.on.consent.screen'),
	 ('eb746e3a-0234-487d-8fe6-db5a19978066','${addressScopeConsentText}','consent.screen.text'),
	 ('eb746e3a-0234-487d-8fe6-db5a19978066','true','display.on.consent.screen'),
	 ('eb746e3a-0234-487d-8fe6-db5a19978066','true','include.in.token.scope'),
	 ('ec0e25fd-09f1-4f49-8700-ac33f94676b1','${emailScopeConsentText}','consent.screen.text'),
	 ('ec0e25fd-09f1-4f49-8700-ac33f94676b1','true','display.on.consent.screen'),
	 ('ec0e25fd-09f1-4f49-8700-ac33f94676b1','true','include.in.token.scope'),
	 ('f4363b05-5882-4034-9682-413a16956e0e','false','display.on.consent.screen'),
	 ('f4363b05-5882-4034-9682-413a16956e0e','true','include.in.token.scope'),
	 ('ff347623-d286-4d78-be8d-414f2022c755','','consent.screen.text');
INSERT INTO clouditera_iam.CLIENT_SCOPE_ATTRIBUTES (SCOPE_ID,VALUE,NAME) VALUES
	 ('ff347623-d286-4d78-be8d-414f2022c755','false','display.on.consent.screen'),
	 ('ff347623-d286-4d78-be8d-414f2022c755','false','include.in.token.scope');
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','6da29c8a-45b8-4905-af4f-41f01a8425e1',1),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','7303ff3f-7670-4f73-a376-05b60aa0defb',0),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','df60fb8f-4695-40d0-b436-ac84819e9248',1),
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','f4363b05-5882-4034-9682-413a16956e0e',0),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','10a651c8-01bf-4e12-a518-d71e0c65898a',0);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('0d7809fa-2645-4607-80ae-82335105f4ae','ff347623-d286-4d78-be8d-414f2022c755',1),
	 ('206f7b06-c863-4604-ac80-407a44557b88','10a651c8-01bf-4e12-a518-d71e0c65898a',0),
	 ('206f7b06-c863-4604-ac80-407a44557b88','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('206f7b06-c863-4604-ac80-407a44557b88','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('206f7b06-c863-4604-ac80-407a44557b88','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('206f7b06-c863-4604-ac80-407a44557b88','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('206f7b06-c863-4604-ac80-407a44557b88','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('206f7b06-c863-4604-ac80-407a44557b88','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('206f7b06-c863-4604-ac80-407a44557b88','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('206f7b06-c863-4604-ac80-407a44557b88','ff347623-d286-4d78-be8d-414f2022c755',1),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','6da29c8a-45b8-4905-af4f-41f01a8425e1',1);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','7303ff3f-7670-4f73-a376-05b60aa0defb',0),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','df60fb8f-4695-40d0-b436-ac84819e9248',1),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','f4363b05-5882-4034-9682-413a16956e0e',0),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','6da29c8a-45b8-4905-af4f-41f01a8425e1',1),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','7303ff3f-7670-4f73-a376-05b60aa0defb',0);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('3d4280b2-bb1c-4887-8993-7224db306067','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','df60fb8f-4695-40d0-b436-ac84819e9248',1),
	 ('3d4280b2-bb1c-4887-8993-7224db306067','f4363b05-5882-4034-9682-413a16956e0e',0),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','10a651c8-01bf-4e12-a518-d71e0c65898a',0),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('4681786f-6fd2-4955-b5e3-74fe0ea3b5d8','ff347623-d286-4d78-be8d-414f2022c755',1),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','10a651c8-01bf-4e12-a518-d71e0c65898a',0),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','e673a90f-38bd-4221-93ca-c4043e27b012',0);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('46dcb18d-572f-4131-92f3-c02d12458660','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','ff347623-d286-4d78-be8d-414f2022c755',1),
	 ('9c882096-4926-49b1-983d-dcd46a530518','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('9c882096-4926-49b1-983d-dcd46a530518','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('9c882096-4926-49b1-983d-dcd46a530518','6da29c8a-45b8-4905-af4f-41f01a8425e1',1),
	 ('9c882096-4926-49b1-983d-dcd46a530518','7303ff3f-7670-4f73-a376-05b60aa0defb',0),
	 ('9c882096-4926-49b1-983d-dcd46a530518','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('9c882096-4926-49b1-983d-dcd46a530518','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('9c882096-4926-49b1-983d-dcd46a530518','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('9c882096-4926-49b1-983d-dcd46a530518','df60fb8f-4695-40d0-b436-ac84819e9248',1),
	 ('9c882096-4926-49b1-983d-dcd46a530518','f4363b05-5882-4034-9682-413a16956e0e',0),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','6da29c8a-45b8-4905-af4f-41f01a8425e1',1),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','7303ff3f-7670-4f73-a376-05b60aa0defb',0),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0),
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','df60fb8f-4695-40d0-b436-ac84819e9248',1);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('b24689d7-ff63-4331-b52b-1f51035cd520','f4363b05-5882-4034-9682-413a16956e0e',0),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','6da29c8a-45b8-4905-af4f-41f01a8425e1',1),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','7303ff3f-7670-4f73-a376-05b60aa0defb',0),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','df60fb8f-4695-40d0-b436-ac84819e9248',1),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','f4363b05-5882-4034-9682-413a16956e0e',0);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','10a651c8-01bf-4e12-a518-d71e0c65898a',0),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','ff347623-d286-4d78-be8d-414f2022c755',1),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','10a651c8-01bf-4e12-a518-d71e0c65898a',0);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','ff347623-d286-4d78-be8d-414f2022c755',1),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','10a651c8-01bf-4e12-a518-d71e0c65898a',0),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1);
INSERT INTO clouditera_iam.CLIENT_SCOPE_CLIENT (CLIENT_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','ff347623-d286-4d78-be8d-414f2022c755',1);
INSERT INTO clouditera_iam.CLIENT_SCOPE_ROLE_MAPPING (SCOPE_ID,ROLE_ID) VALUES
	 ('7303ff3f-7670-4f73-a376-05b60aa0defb','da0d65f8-c81b-4a74-806f-0554fa18ab00'),
	 ('e673a90f-38bd-4221-93ca-c4043e27b012','d8f3865d-9b6b-4b6c-a79c-0c8337958773');
INSERT INTO clouditera_iam.COMPONENT (ID,NAME,PARENT_ID,PROVIDER_ID,PROVIDER_TYPE,REALM_ID,SUB_TYPE) VALUES
	 ('00bb16d7-fd25-444c-a5af-bfc68b16a262','Full Scope Disabled','73b44a4b-16ae-442b-adf5-60e57d986b2b','scope','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','anonymous'),
	 ('01087978-0f8e-4570-babd-d3b11c306e36','Allowed Protocol Mapper Types','c433f707-f45a-4a7b-b213-efe294a99f66','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','authenticated'),
	 ('28c86263-b7b1-4a2e-b75e-1cdb58b36eb2','Max Clients Limit','73b44a4b-16ae-442b-adf5-60e57d986b2b','max-clients','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','anonymous'),
	 ('33d234a4-8bfc-410d-a56c-8e65e3da626e','Allowed Protocol Mapper Types','73b44a4b-16ae-442b-adf5-60e57d986b2b','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','anonymous'),
	 ('47e9ab9a-3650-47e6-a079-08aa9c59d171','rsa-enc-generated','73b44a4b-16ae-442b-adf5-60e57d986b2b','rsa-enc-generated','org.keycloak.keys.KeyProvider','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL),
	 ('48527418-9e21-4dfa-9b77-8e862a5c584b','Trusted Hosts','73b44a4b-16ae-442b-adf5-60e57d986b2b','trusted-hosts','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','anonymous'),
	 ('4c351bc1-6d07-482b-982a-8e0ac59cb008','Allowed Protocol Mapper Types','73b44a4b-16ae-442b-adf5-60e57d986b2b','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','authenticated'),
	 ('70dd610d-a7b3-419b-8988-13ec28e087c7','rsa-enc-generated','c433f707-f45a-4a7b-b213-efe294a99f66','rsa-enc-generated','org.keycloak.keys.KeyProvider','c433f707-f45a-4a7b-b213-efe294a99f66',NULL),
	 ('74d09bef-c5fb-45f0-9647-8199ec4e1795','rsa-generated','73b44a4b-16ae-442b-adf5-60e57d986b2b','rsa-generated','org.keycloak.keys.KeyProvider','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL),
	 ('7b021cb9-ffd6-4f41-b97d-64046bd86110',NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','declarative-user-profile','org.keycloak.userprofile.UserProfileProvider','c433f707-f45a-4a7b-b213-efe294a99f66',NULL);
INSERT INTO clouditera_iam.COMPONENT (ID,NAME,PARENT_ID,PROVIDER_ID,PROVIDER_TYPE,REALM_ID,SUB_TYPE) VALUES
	 ('907f462e-8eb7-4df7-9fec-45bbd02812ab','hmac-generated','73b44a4b-16ae-442b-adf5-60e57d986b2b','hmac-generated','org.keycloak.keys.KeyProvider','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL),
	 ('955b7999-7afe-4320-a467-0d51fe5582fa','aes-generated','73b44a4b-16ae-442b-adf5-60e57d986b2b','aes-generated','org.keycloak.keys.KeyProvider','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL),
	 ('9fe14809-5c0a-414a-85da-c411086912f1','Trusted Hosts','c433f707-f45a-4a7b-b213-efe294a99f66','trusted-hosts','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','anonymous'),
	 ('a8be44cd-f657-49a1-a5ec-0733cdc35408','Allowed Protocol Mapper Types','c433f707-f45a-4a7b-b213-efe294a99f66','allowed-protocol-mappers','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','anonymous'),
	 ('ae3d4f4a-4b68-425b-ae8f-afe5f32d12d1','Consent Required','c433f707-f45a-4a7b-b213-efe294a99f66','consent-required','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','anonymous'),
	 ('b068f39c-f485-49e7-8147-2b0066cd3c6e','rsa-generated','c433f707-f45a-4a7b-b213-efe294a99f66','rsa-generated','org.keycloak.keys.KeyProvider','c433f707-f45a-4a7b-b213-efe294a99f66',NULL),
	 ('b333eb02-1334-4fcc-8ca9-e2fd84e5e06b','Allowed Client Scopes','73b44a4b-16ae-442b-adf5-60e57d986b2b','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','anonymous'),
	 ('b79c09ee-bf15-4fbd-be00-0b07805c5392','Max Clients Limit','c433f707-f45a-4a7b-b213-efe294a99f66','max-clients','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','anonymous'),
	 ('b7a0a412-5c2c-479b-ba0f-b38c79cdd5ab','Allowed Client Scopes','c433f707-f45a-4a7b-b213-efe294a99f66','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','anonymous'),
	 ('c4c8af5c-00c7-48bc-8492-0f918681b3df','Allowed Client Scopes','c433f707-f45a-4a7b-b213-efe294a99f66','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','authenticated');
INSERT INTO clouditera_iam.COMPONENT (ID,NAME,PARENT_ID,PROVIDER_ID,PROVIDER_TYPE,REALM_ID,SUB_TYPE) VALUES
	 ('d8680d1d-772b-4267-9698-e55a99476099','Consent Required','73b44a4b-16ae-442b-adf5-60e57d986b2b','consent-required','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','anonymous'),
	 ('dd920326-05b8-45ca-8a5a-9d34b6e3365a','aes-generated','c433f707-f45a-4a7b-b213-efe294a99f66','aes-generated','org.keycloak.keys.KeyProvider','c433f707-f45a-4a7b-b213-efe294a99f66',NULL),
	 ('df03a9f1-660d-4696-b1a8-953691fe8080','Full Scope Disabled','c433f707-f45a-4a7b-b213-efe294a99f66','scope','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','anonymous'),
	 ('f4374194-e1c0-4211-9b08-e5cc8731bcc2','Allowed Client Scopes','73b44a4b-16ae-442b-adf5-60e57d986b2b','allowed-client-templates','org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','authenticated'),
	 ('fb75cb2a-5c29-4f49-9667-6e3e1fd38afb','hmac-generated','c433f707-f45a-4a7b-b213-efe294a99f66','hmac-generated','org.keycloak.keys.KeyProvider','c433f707-f45a-4a7b-b213-efe294a99f66',NULL);
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('04f97bea-8407-4cea-9a5b-8aa388e94ea7','9fe14809-5c0a-414a-85da-c411086912f1','client-uris-must-match','true'),
	 ('06b1b464-067c-44c5-9c5c-47ac9ea9587a','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','saml-user-attribute-mapper'),
	 ('0e9caed4-b4f9-4b4b-b03f-866e39d2ebde','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','saml-user-property-mapper'),
	 ('0fc347dc-3b94-4114-a14d-0a41af211ba7','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','saml-user-property-mapper'),
	 ('17537a74-f78d-4059-9cca-23cdc7015386','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','saml-role-list-mapper'),
	 ('181a2f52-ee4f-4d49-b2c7-ee6f1db4913d','70dd610d-a7b3-419b-8988-13ec28e087c7','certificate','MIICqzCCAZMCBgGYn4NUTDANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5DbG91ZGl0ZXJhLUlBTTAeFw0yNTA4MTIxODE5MDBaFw0zNTA4MTIxODIwNDBaMBkxFzAVBgNVBAMMDkNsb3VkaXRlcmEtSUFNMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4kIHIMNxR53PST2g/3qgzb52a/mv3xLwesGf/gOTy/ggb2NZY2EwipBT2KgZcfiMrlKojZSKV4X1KLTbVoUviaYACF7FE5k2WlUBH0jMwPHYFYQhIpmYCaie3FrzCzpSJwCh/BSGjfYLlART7Ea+5UCDfhqTklNXU+6oH2312OXfKSqPWapDuSiX/uNiWCokV4jRSxcjZQJL/iuSmYF9KqqrJht51RV5tCaP7hu1k8sAd85O1WO+WdZCqifFxpOUu2f4RAkf0QPLgSvI2QcfG8aO0rjY9yKNvHSrjpCL1E6wRgS0IVGTKR/TjBOhQ9EibzoAzNy1uKpxoMuqMrQ4cQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCyatyTaK6qWmiD+aTCYOfhiRrplf9p9c/Z3ktTjS7OwC0WJE3532rg+Rm1XBAWS0aOHKAwZsr1EuOFJc3kbaiPJ8mxynKswfxjQsBajmO3AdyZKozyvWOKCif65C2aP1ga5qODp6yA76zvLpYp5O3WfMtcz7FGlBRonq5MmOuyA5nb06tjC6cJblYF4UgJbvOIVc2XslBiQvBA/4/YSKAktqaFK5jFpoQNTlOUGhPEO0ceuQPZQmB1qFUJ37FJY7eh9/ZDYUmti2fWGsmtgRwUV/GSaIYXXPkYJswPbFGyjCr7D3kCDAgc9pIoLicsmT4hF+cTdiAWRAzCisv0dCVI'),
	 ('18c2e7f9-4f44-4bd0-ab6c-0a8aa6628a66','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','oidc-full-name-mapper'),
	 ('1c647c87-eed1-4ee8-bb14-99e5a80d4b3b','74d09bef-c5fb-45f0-9647-8199ec4e1795','priority','100'),
	 ('1c8e4ddb-a6d1-4222-931b-9c31cc3eb7e8','47e9ab9a-3650-47e6-a079-08aa9c59d171','certificate','MIICmzCCAYMCBgGYn1CUSzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwODEyMTcyMzM0WhcNMzUwODEyMTcyNTE0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCnI6m7rKMZXZZrtvIOvd5F9HSe474tFRon4TFE7FhOLngRxU/ugU1TlGFflPNRBHKZVMIeo7TkXLW+uu6dPqsZzT3mA2/tQNbnnfQgP07UsEYFptuECridG2naxV57873RiyNMTbUes6dWXgliThyEBG5vRbhnsLFfNbk/fbsdkPLE2XJUIAq8Qsr6CMcQSyPKq+B4kgYgJcMNvv0MagO9OLTS/c4hQeyQs4E7dBw4uRZk1CA2zHopqDJpuKRqKh/OFLNgReQN+BOr2vFBOYLEtqKpibCw+eXDVKiJfDmeOWmvxQ0cFHTFVAsrG53RGowAxJXwKcxZ7jpimukUc0DbAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAEcARzxPp46/D60LhfKSEgQvMEc7bhVM9uv5bF5y3a/KsMsUd4czu/e3tC12UIrU+5W+lbnRT6i5+galzLKBSlWg9Y61RIwwOd23fVdPNh+XxqVv9wub24F2XzIsZfA9PQOoRhIlkYXdiG+LHTaTFLGEJIR1G+qw/gjSipTj81R8czYao01iABfWCf+RVqba5SxlacrcE+ZY7zDeZDRLGNNy1+/DODL4BLGPFgvfAUBnd6+izIyDI0DfaAT6f6Ksd6edOWJs+VUiFDbU4WWCmbgswquOlfSIjvtofTMB7VWoXRfRSUFmhlZazO9xdlyDnn8x23RhX46O+OaqoRrtSmk='),
	 ('1f750dd6-f54d-4cd0-9597-4904bb865216','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','oidc-full-name-mapper');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('24fd2ce5-c4db-4645-8758-8bceeec1c627','907f462e-8eb7-4df7-9fec-45bbd02812ab','secret','2styUCKvzWxeFlcSqqeD_v45E-O_pOxfzCrow0fsNv0Lxvt3GHJgofD8GVpJwzRjkJj8MfkXYafxWlVqwxffsw'),
	 ('2dc43c1f-8536-4217-98a8-bf858579bc27','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','saml-user-attribute-mapper'),
	 ('3090d9ec-abbc-47e7-86cc-98954c89d39f','b068f39c-f485-49e7-8147-2b0066cd3c6e','privateKey','MIIEpAIBAAKCAQEAwkqc9vPffN6lAC/an48xBNvGr41lINasTkrP/j+F5lZ5D3mp78HUy+265OWstp4IUYVH9VV0wbUCJ1jqxmZ6ObGaGlaFCOnJCcDaFiZqrUkEiBqwBaDgvCvmwB7LCL/SaHXPEnc3lKtDWSpqaGB3ECToVchEnheHyLInooegU2IVTo/h6O9naG6ZYaPQCm/xc6f83onSMfJcA8xAB58YyBXKBLChB7aD7Fu2WEZWl9hHufmNKrWyegg9ziexTmHA1HKVmDAAAi1V/zlCnSxwt4TPmFqp2TQYpgg+MqoOejECS9leO+7yTYPEfqZ5B9+clrDXdvS0fWFLipcJxnsuMQIDAQABAoIBAA+9x1NbxVzi1gf6mJIqYgyUeNfC0zFyqyGpvonJIEJd+a93Cj1mXSULlQOUFybxjVd7fq3CF3RVQ8An3FeoOFlhygw9u8gR1uuvIAxA3w48lv0m+mFuXB7qyKaCqC0Ei5nSh60lkw98w7de8CGWRTc94kQG9oY/fk0UoBDzP5pZuR0MWQA4T9AcUIiTnQ19x2btb2NtSXICzVIbhCJ9CklCqHafVIfIsubOBbtkiZR8bLzzSmMe3ayMrRXKFdFDkWrm+tkBD83FqliljixDVtLvt1v1wmoqGREz9kBBftU8bR8dVrksJtmn/5Ja76xG4bTxHgR/MXtI8euTvZlPa6UCgYEA5PN0PyxLo455/AOBCaWZSbNdlnoodRlq5w4dL7kcAa+IXt4lyLszE2+5WRblYPOGI2fhOpMI96yPjiK98GhxNi0EvySbbBMBzvFMXS0uicM8DVygi4MKi8jNZMBQKsTmkNtxSOwA76pr1RVAuUu1ofPCF1WvdBkODydxiqvycd0CgYEA2T7kn0ANxa/ufBTt17vJfHUxwoWpv/d6pv9Pa9Cqzf1+1dhKTd+QjnaWTyg4+uVfTinobj89UaREt8uQJnFE6wJvt9AR2FIUtHfd1pvOEgslusm1i1aVZFnASBj2y4e3ghtZLl7YfntfhVNdF+UFo57CNBbYpwCvHs6zzSJeKmUCgYEAgybLAp03PxwQ2MKRGpuYMdXj2J1lq57B1FYLdhkN6BFLhzyuXEyQN6QaguRQxbb6sjGBnfI4gtiA66UPNTY/FA+51lz8A27n7EnhusZ1EEmcjvLurLyGQAjpT7uysK1WfsiWHnXDG4d+efPQvdSW2Y0vM/rLpS/tE9U+f3d8TKkCgYA1BxoNGTiDYZ9H4F/yAd97pqufvLqjpgflTXqYaZXXtCHKlwIEIicJ7z5fUgUekPCDhs06Y+tWy08OwfyMtadJ6g1VA8/nSpnNN1kJ8nwJgXkTL/tFaLwMg6/gqV9MbPNJKd3J6NLVhM3bIG8fzwJiXvUue8kkcpFMZs4Sq2nq1QKBgQCKKp/Mg9ZKS8qotYP9yWLNATY2CL8cry+/uG7yAjlqhB7oy9uSWfS+egOstDCPN6bGvVod+yBs67VEFYigblrpqQhcn9pLThStMKoa99JWZGV6oGZzHpAIBNtfvmB00sthg4ai7Bp/NIZsuoE0MSlcVDYn5xxLP+8YanHlkK45OQ=='),
	 ('32145698-6053-4445-a772-13aaea932414','dd920326-05b8-45ca-8a5a-9d34b6e3365a','priority','100'),
	 ('351ddaa9-de23-4f84-a2d3-42106641eccf','955b7999-7afe-4320-a467-0d51fe5582fa','priority','100'),
	 ('3537358b-f244-4252-bade-481dd5ba80f7','74d09bef-c5fb-45f0-9647-8199ec4e1795','privateKey','MIIEowIBAAKCAQEAhHD6znLUiSP8FRiDxxOunTiTruuPWSjTRfdSBpE/iN0BmJTgMV56/6LikmQgi/G17gOzoeGUVNJNfNRLQzvD6w1dxU875pA1nGUptwUh044osPu4Y5mFdbD7ENGHmMOB42Uw5Vcf7FN7OOkcfRav6cZPvxOJtD2JaVKBAX+2qa2h7qmoMHDft/zNqNHuX4S3nkb4HThBzHi//0sEDqS2ojDfCrvyt+KiQr/tYt015Q0zLs8554nYhmS6Hy1UX5AuyP5R4N8p296sIW0bcvVKLtKHfLlK95k7Wp6eoYoQYeepiDO1MJboTVdc4gI+nKN8uj226T4ubHRChtm6LegubQIDAQABAoIBABkIC3cqf939pZ7NF9bv8uA3Ob5lOh4lV60RHfksyZ/R+YO/m5HpJAEd5Ym6j+YzRGncXD6b1n+jkc6mhyUJbjGGQLNSkuU0W1WYTyaOu0JzS2CL6uE0OmOwk/stRt4KEYoLbY7jBR8S9iae9Gn1+ECMYTUhebTNrqNv2v8QBtORvn5QKHsjbz6EV+7e4TuwMVasmgIzTjvASNjkslJXq68ObcL2KCezRi1Jbe4CMLSq56Jda4i+fVdMLIjObLon5ddoOjV2yFqi22tpsaOLn4gsNXFG9kTePJX+IfGJcFA8zwDMMExuy7kVo18yXPWWcdma0ZixnPFO3cyF9MKJU9ECgYEAuh9svOURNjRPsUk9Q42IYJdJxVQ9ExdV9/RVRZRGKzoV3/NE7uZtKBChZ1jbNCVx8MVE5YuGPMf6Z4/quLcYTC6qIDqa5G8zdQw+/dnTWd1XehQU2VvIUfy6r3j5BgCjJ76+kGfNTB0TjEkoSCQv2LECpQwKXHH/Oh0hpYWk7ckCgYEAtiokPGC8RsFDl9Zpz4uX2my6E4zNAH5Vzs7Lo7u11XmROsWU0LXEBFj2P4hba8lugfhXqjL9ANgVkWEe14p8vfvZCxRk/eqChPaW84YyEXky7iDoKRGUjXk9UBYXlG0Lr8UyMvsCDN8ApVUuPgXh7Lkj2xgxpbW4cDAFH7bx/YUCgYEAt3V4Qm1sXMiNcQvnJmog7kzRu39AQEw1QhaF4vK3g65al4f7/5wEJoTWA7+TOkBaomBge/7ej5Ty3xf93psjiRxKN0BtIxP1Xb93a9NFQAQsULnwnxuYRjBed84/cEo6iFe9ESwwMYFLnnESEqIQw4AfQj6vC9aWJFtIqhYkrvkCgYBXuG1godioXdK14GttpTQH28mzNl9VuICLqSuI+hBy7yqPWavy4US2LzzNlVUoz4QmlDdq30jUSjoAmvsmIis1tXxsCHMljvMxIinItTuRDIMJBtGlTTDy+4oZ8bmDIQu6pcQpppPzLMP72cv91AlaXEE29SybNqnNZGJjRk67nQKBgBzgXzCAzPiNc1ZoDrK5C73pMqJt+OfCwks0B350NokgQk2iX28hcTTzQsQkwfyC2ETaUYu/ko3PNohcyR1QB7jrtlbPZoZhFW4o0PTNNdvcuSOod88dP5IDiNddcEZbbStkpfDgDcIdE/0fyw6V/BURqGabH2TLrWHmjlqFxJdo'),
	 ('376e6177-2353-4952-8580-994c84e93a54','70dd610d-a7b3-419b-8988-13ec28e087c7','privateKey','MIIEowIBAAKCAQEA4kIHIMNxR53PST2g/3qgzb52a/mv3xLwesGf/gOTy/ggb2NZY2EwipBT2KgZcfiMrlKojZSKV4X1KLTbVoUviaYACF7FE5k2WlUBH0jMwPHYFYQhIpmYCaie3FrzCzpSJwCh/BSGjfYLlART7Ea+5UCDfhqTklNXU+6oH2312OXfKSqPWapDuSiX/uNiWCokV4jRSxcjZQJL/iuSmYF9KqqrJht51RV5tCaP7hu1k8sAd85O1WO+WdZCqifFxpOUu2f4RAkf0QPLgSvI2QcfG8aO0rjY9yKNvHSrjpCL1E6wRgS0IVGTKR/TjBOhQ9EibzoAzNy1uKpxoMuqMrQ4cQIDAQABAoIBAB9G2FxnmAu53XM28UAP0BXQ6+beM7knEZYumPLQxMgP60/qkGtD/qVQ8T5EcowGO1BHveQgcgVKT8sKQT3TGHCzQVLm4uBkMBbJpGeSNTfA1smWo8v4JoPDSv6UFf/p1nxswnep0LXkGtKhzIYfe3kOc37lppu2KJ7CIXyCw1bxoV6taIVG1snAM37+gLMeY3b+maOiMg3tWCQBtY9jSz0SN/ysiKbzD7Ut1vX3gxKReUkOTP2V3WNfWVfrd5FP+RAXAW4tFCyM7+68msaDnvKWz4Cb1Bm4QGrm72yf3MAvY5BV7anVvMOq/dwFHso3JoAKsJtFiTRAGLLEbXJ6spcCgYEA8qiHAi4rouoVxrBJ/T0FPCICfqDngwBAP8h4bxzaxR0PP4sMqoNjCdkSEl/RJFdMDfFEy/jmQC20PsxHrHcnDFXEQvWWHnSDNSLx2jyO0JR3pTI0V6WZEccD2OD+EQer3tfeXvIDKgnqFER70MRvZpqkc3+BJ2WzHN32+vjfAwsCgYEA7rKpQP8JBKBdK6teeOlEV2C+LzkeKHNbHgtm/x3Z3JgVt7waxIoQoRofGOS7bVxpXNgSdeFP7Z0g4PJhs+2YSxOBulTHWC3jYGQd8UrWKmGQGbIOZX9caM9TSNXqfdmPV2+MeFDSmNZs2Upc43aNjiHkRgX9LRh6fYbLPYiyH/MCgYAkvbWrc9gxk6X2bozVZh7byv57s9s575jKz4zEribFv6+mXGRvkPM284IT/CQLj5g5aDWVeLtMLl9jPsT/bQ8hg/7ycILpW5TeP8tE0vSAymoPPjnEp5M0qOCBPxfY9kNku2S1FYm7HMMvjGr+4i9H5tRNlJm2oGRtU4Jo37PMnwKBgQDnXqxqwQrXvi2xl6GyJ8HDxJV0prPR18cZf0ntvdygU5axixaTLZTi47QC6Cu43JuQkCyMsMJN+0GUab1Er+gv1Y+osmar1YcRttnDOpwPZpRMI+iKf4JuYZBECH4MUOb9hLWvJgCMf0Pw94DERvT9MWLYcROwM4r/w7mbQrYN+wKBgBmyCfvw6tFOm+t3BSq5x+amk3aku5JJtIMEAOiai7XSzDcUdXo6livJfaIEhE8fXI1cDxOw5Xz2ODO0MW9XLU17MJfPvE9d1nlvxrNtbvsOMGYrr9jotqoK7iquqahrl4fMU+/yvso/sEQFxZAGIUSnzBdmdbkIQMwrovtDAzQM'),
	 ('3b0d7907-1549-473e-ba6b-3af36bb96f1c','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),
	 ('3b3abf7d-2cc0-4c16-b611-4d9d0290ea3b','b333eb02-1334-4fcc-8ca9-e2fd84e5e06b','allow-default-scopes','true'),
	 ('3b3b22b7-67f8-4b40-95de-cd0d7eda83ce','b068f39c-f485-49e7-8147-2b0066cd3c6e','keyUse','SIG');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('3e4d8906-6f12-4199-8ec5-ee721a64bcd4','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),
	 ('3f770e3b-3aff-4121-8a11-841fe82a5b79','74d09bef-c5fb-45f0-9647-8199ec4e1795','keyUse','SIG'),
	 ('4b65e002-ddd8-43ad-9ed6-65bffe748326','48527418-9e21-4dfa-9b77-8e862a5c584b','host-sending-registration-request-must-match','true'),
	 ('4c65a2ba-50ec-4bfb-badb-31f7d4d0f90f','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),
	 ('50422833-1aa8-40c4-a15f-388f2d0d480b','907f462e-8eb7-4df7-9fec-45bbd02812ab','algorithm','HS256'),
	 ('50ecd39b-5925-442e-bcff-ddb868db10b5','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),
	 ('515093b3-8151-43f2-aefe-371c947d0304','b068f39c-f485-49e7-8147-2b0066cd3c6e','certificate','MIICqzCCAZMCBgGYn4NTmDANBgkqhkiG9w0BAQsFADAZMRcwFQYDVQQDDA5DbG91ZGl0ZXJhLUlBTTAeFw0yNTA4MTIxODE5MDBaFw0zNTA4MTIxODIwNDBaMBkxFzAVBgNVBAMMDkNsb3VkaXRlcmEtSUFNMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwkqc9vPffN6lAC/an48xBNvGr41lINasTkrP/j+F5lZ5D3mp78HUy+265OWstp4IUYVH9VV0wbUCJ1jqxmZ6ObGaGlaFCOnJCcDaFiZqrUkEiBqwBaDgvCvmwB7LCL/SaHXPEnc3lKtDWSpqaGB3ECToVchEnheHyLInooegU2IVTo/h6O9naG6ZYaPQCm/xc6f83onSMfJcA8xAB58YyBXKBLChB7aD7Fu2WEZWl9hHufmNKrWyegg9ziexTmHA1HKVmDAAAi1V/zlCnSxwt4TPmFqp2TQYpgg+MqoOejECS9leO+7yTYPEfqZ5B9+clrDXdvS0fWFLipcJxnsuMQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQB+HFNwqt8Vj6W22CyYtdatdQSuUA9hmiPCYq8gltn6BvQdmJYS9d6dmeddR+Rn5ZoUlryXWoxgpejoKq/XAhKSjPkepi8vhHjDHHPLJnd3mOyzkz7zdNFRsCgDw6eiei3W806vH91DQ6Hh0R/kQ2+ncEbr72bSpcMCHPoF/qcilXC8MIsnnp+BmFAj2fkE5tmReqEjCgmFEdZ01VLjBCi7FnpTQ/Qg4gZG1FmmFY2xVRQVVVsplRJiMq4ZIfxu0r8dH0y7kz9aQDeIeM/ZZzYV10DlHsz7wbN/rtQwa78zHkU2MUS1Mmv6Wr/K+4wdxicsSxUwto+JUrGURZ0fWdO8'),
	 ('51570a3f-dd69-4867-a2a6-35f22e6da325','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','saml-role-list-mapper'),
	 ('5971d2ac-f467-4e7a-bf97-406f3dd4c1ff','fb75cb2a-5c29-4f49-9667-6e3e1fd38afb','priority','100'),
	 ('5c297670-6807-419f-9d31-cc4d6dec8a33','fb75cb2a-5c29-4f49-9667-6e3e1fd38afb','kid','f15b2128-98a9-43e3-9b76-3f2d115ea1ad');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('5dc344f9-8b2a-48f8-adcc-aead31fc4610','48527418-9e21-4dfa-9b77-8e862a5c584b','client-uris-must-match','true'),
	 ('64f2a7ed-9a23-4f7f-93e8-a75bd2cc8d56','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),
	 ('67ffab15-267e-445e-a041-e775a7593b1d','fb75cb2a-5c29-4f49-9667-6e3e1fd38afb','algorithm','HS256'),
	 ('7039f2a7-eda3-49b5-9334-20346d461973','f4374194-e1c0-4211-9b08-e5cc8731bcc2','allow-default-scopes','true'),
	 ('784e79ef-bad3-4426-8bdd-e44e93f6d3c8','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),
	 ('8039a0c6-efe0-489b-8faf-10a78a8d6f3a','c4c8af5c-00c7-48bc-8492-0f918681b3df','allow-default-scopes','true'),
	 ('837119e9-242c-4301-bf3c-e972a666bbce','b79c09ee-bf15-4fbd-be00-0b07805c5392','max-clients','200'),
	 ('8764de84-2faf-429c-b361-ec4615d7f7cf','47e9ab9a-3650-47e6-a079-08aa9c59d171','algorithm','RSA-OAEP'),
	 ('87e61496-5a63-475f-9b15-2c298f8ed3b1','70dd610d-a7b3-419b-8988-13ec28e087c7','keyUse','ENC'),
	 ('8923e65b-f826-4e30-a7a3-7ed212a86e2a','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','saml-user-property-mapper');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('8b800ece-2a72-4c84-bffb-8ee8c80e4e63','9fe14809-5c0a-414a-85da-c411086912f1','host-sending-registration-request-must-match','true'),
	 ('9124d4b2-503e-4696-a059-d3bdb93bb7df','47e9ab9a-3650-47e6-a079-08aa9c59d171','priority','100'),
	 ('93ab0c65-20a6-4b7a-ba1b-61c02dfe0b1b','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','oidc-address-mapper'),
	 ('9a7835f0-6dad-47c6-b66b-bcc99379d908','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','oidc-usermodel-property-mapper'),
	 ('9f51869a-5c88-4138-bf1d-3f4d5bc96901','28c86263-b7b1-4a2e-b75e-1cdb58b36eb2','max-clients','200'),
	 ('a292dc69-acd0-42a1-a1f5-d5eba1d28fcb','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),
	 ('a5e25d63-3075-4032-b5d5-152b2cb7e4db','47e9ab9a-3650-47e6-a079-08aa9c59d171','keyUse','ENC'),
	 ('a6594f84-7b99-4619-9d60-e8de6e48403f','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','saml-user-property-mapper'),
	 ('a6c9bb8f-d8ef-4bf4-adb4-fe5ac59ee7c4','907f462e-8eb7-4df7-9fec-45bbd02812ab','kid','1c977c0c-7804-434f-8c8b-db94fffaa3a4'),
	 ('a974d83d-2b5d-4d83-b733-afcc955db5e0','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','oidc-usermodel-property-mapper');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('aa3ba708-5587-42fd-bce1-6b1873f2a1e1','907f462e-8eb7-4df7-9fec-45bbd02812ab','priority','100'),
	 ('aa663591-6bf1-4aa1-8c9d-3b2f26e2ba92','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','oidc-address-mapper'),
	 ('ab94b76b-0920-423a-b5ae-ce72892a108e','b068f39c-f485-49e7-8147-2b0066cd3c6e','priority','100'),
	 ('ac12c232-0ce0-4e8d-a5f0-2f50c19608c2','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','saml-user-attribute-mapper'),
	 ('ac323444-014c-458b-95c3-40b3bf6bd2fc','b7a0a412-5c2c-479b-ba0f-b38c79cdd5ab','allow-default-scopes','true'),
	 ('b13aaaf8-f695-4577-b389-cd4e7d6d1dd6','70dd610d-a7b3-419b-8988-13ec28e087c7','algorithm','RSA-OAEP'),
	 ('b6ea6385-a5a2-48e1-803a-a95100b439c7','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),
	 ('bfca60b4-f9b9-4904-a81c-08c9c5c6a082','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','saml-role-list-mapper'),
	 ('c6d578b2-6470-4a9e-accf-0d476acaa558','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','oidc-address-mapper'),
	 ('c9740094-f3e4-4f82-9e3c-857f20c4c949','70dd610d-a7b3-419b-8988-13ec28e087c7','priority','100');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('c9a0e3e6-80e8-41be-9524-63de486a1c3c','4c351bc1-6d07-482b-982a-8e0ac59cb008','allowed-protocol-mapper-types','oidc-address-mapper'),
	 ('d0c00f14-3b6e-406c-91f5-ea5a6565ee9b','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','oidc-sha256-pairwise-sub-mapper'),
	 ('d5380447-63c5-4a92-bd86-fbf4435e5b57','dd920326-05b8-45ca-8a5a-9d34b6e3365a','secret','FD4JCj6gAyyXHim4Z0UHng'),
	 ('da2afc42-b6ac-4fff-b08d-dffceead0cb1','74d09bef-c5fb-45f0-9647-8199ec4e1795','certificate','MIICmzCCAYMCBgGYn1CTjTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwODEyMTcyMzM0WhcNMzUwODEyMTcyNTE0WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCEcPrOctSJI/wVGIPHE66dOJOu649ZKNNF91IGkT+I3QGYlOAxXnr/ouKSZCCL8bXuA7Oh4ZRU0k181EtDO8PrDV3FTzvmkDWcZSm3BSHTjiiw+7hjmYV1sPsQ0YeYw4HjZTDlVx/sU3s46Rx9Fq/pxk+/E4m0PYlpUoEBf7apraHuqagwcN+3/M2o0e5fhLeeRvgdOEHMeL//SwQOpLaiMN8Ku/K34qJCv+1i3TXlDTMuzznnidiGZLofLVRfkC7I/lHg3ynb3qwhbRty9Uou0od8uUr3mTtanp6hihBh56mIM7UwluhNV1ziAj6co3y6PbbpPi5sdEKG2bot6C5tAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFzK2lPPLs0aE7GSt0P09vEjW1ISd2pAeEiIdFkhhXvVJkiER//DRMjB8qoTJY6GKJGIhv+P1Asu8ds/aXGgpo2ETRL1KggVy8CK1dev2xPys3UDWBa7We0edmVMrgYMJPpZUbPON7KCY+yfi2mrnPuU13BmsJfZMCSkDIsfsKdhh04mslKKBIr0Yn+WRLWqULyRmsc9C2OZ+ogF1g6gVp/qt2jyqDbbXU8ftGEalOmKPiPGNmeJWlD2BcSWlpdJyNtkNottEmRoVDLYAOhQ+C+HiCxwWy4+mMrQaFmIpfJ+VGsL+mjfvMiwzoJh4lCO6La4vw5slcPpfg/EeayWv1w='),
	 ('dd438cae-4bb1-413e-b031-96e9ae534923','955b7999-7afe-4320-a467-0d51fe5582fa','secret','_8eB9mwqR5GISD6f7rnUcQ'),
	 ('e38f3c2d-1488-4e63-9a35-4e36d26f1a5b','fb75cb2a-5c29-4f49-9667-6e3e1fd38afb','secret','YOqSv_6C6nrDWiXNU7Gb3OQqC3OXIU9cPj_-5wC0ZODabyec9m_9CV3cZnh7Z50s0ovUcOeFVKwX_zu8tv_iYw'),
	 ('e48c57f1-9928-4e91-9697-a4246c9c1d36','dd920326-05b8-45ca-8a5a-9d34b6e3365a','kid','3c8c276a-1557-437a-a946-2a7a3d6f2f30'),
	 ('e6487172-5244-4799-a85c-7e8b9667be9c','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','oidc-usermodel-attribute-mapper'),
	 ('e8c19f42-8a70-4062-9e31-7f075b114128','955b7999-7afe-4320-a467-0d51fe5582fa','kid','4c95a04d-aad1-4d3e-9590-a4fe5736f088'),
	 ('e977ae41-8b7a-4d1b-b5c3-4b0dbc453a13','33d234a4-8bfc-410d-a56c-8e65e3da626e','allowed-protocol-mapper-types','oidc-full-name-mapper');
INSERT INTO clouditera_iam.COMPONENT_CONFIG (ID,COMPONENT_ID,NAME,VALUE) VALUES
	 ('eaf4b233-4942-4d23-9062-8a55ad122329','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','saml-role-list-mapper'),
	 ('f1b76f4e-b1f7-40e3-be81-3b84da193b0f','01087978-0f8e-4570-babd-d3b11c306e36','allowed-protocol-mapper-types','oidc-full-name-mapper'),
	 ('f9337976-3e39-461e-bd5f-a64842105462','47e9ab9a-3650-47e6-a079-08aa9c59d171','privateKey','MIIEowIBAAKCAQEApyOpu6yjGV2Wa7byDr3eRfR0nuO+LRUaJ+ExROxYTi54EcVP7oFNU5RhX5TzUQRymVTCHqO05Fy1vrrunT6rGc095gNv7UDW5530ID9O1LBGBabbhAq4nRtp2sVee/O90YsjTE21HrOnVl4JYk4chARub0W4Z7CxXzW5P327HZDyxNlyVCAKvELK+gjHEEsjyqvgeJIGICXDDb79DGoDvTi00v3OIUHskLOBO3QcOLkWZNQgNsx6KagyabikaiofzhSzYEXkDfgTq9rxQTmCxLaiqYmwsPnlw1SoiXw5njlpr8UNHBR0xVQLKxud0RqMAMSV8CnMWe46YprpFHNA2wIDAQABAoIBAASRacpVJxCtPqG2BSVC/4gGQjO012tFrYp+fJ68yOhmG7unRWPS3olUv66MPx7X53E/tZ3UbUAP3/BqYoAjXityhmkQGfyFg6TJQTVVFZ35grMVLYsNJ0uKnBjca78pLmcY4upAdh1J3V5zwSo8e/SzEaOdPQjUdZyRDChAkvR1XjXQtLisS+HN/QoCtMhu++Dx/foxim3JiEeONkutAaa/6O9L2xo9AQiHxlJ4jAiz+/+zgzD1C3BeQmVynWK5ZLn0X8d/PydlWSOjlNSUQImQHn83REFIuvcfoIZrP4ywYS61Eu3rs06QhmSDDhtkfGdQeMeq9bomHfdZo5RnDz0CgYEA3MyCFVmixOY5TZFb+gFTYQuRq1Y/qBn12OIjeO+6Gl9UQCF3Lnd7N3yNfxmg54lQ52ClTKPrP45lRu0ecHaedVbLX7B9SSkVLEB+kgMbfR5fWNkDJCIo33TeNlXJB9QmR0gCHM8XlRvRbgIGNudFY5EZtQsqESQh/LJSHGmH/SUCgYEAwckkDGMJEWqTuCaPxPab3SZb/L98zFB3IPgPl2AIT4tbb+x20j6jxXZdSw89ZbhKF9wppiDdUDlm3//aL2CCPW/dJd/NXxWA/w0ea0Xe+eKPl3gvWJL2oCMSeT8MEtr5QoDIuzqszc50x78W4r2JcAWWnhTkR/lvUv0piHac5f8CgYA4ZRe4oktbpT3vnPf0FBCa0dyj+YSKyA6uFZxf0EMlZ0Ham3GYcbYMBwkQ9JfPa5g5cMrnl1qHwjQF+Jx0tydj6wZI64gkfpTE17g8TQThYTeTNuKBgSQVZwE2uZR+JmacgDzh5NcuI4vLYEL8FPf5JV9+iVp2RFdV9qnYTfAI7QKBgDWQZoFyAnio7+nv5r93tv968eQ7/b/v4e3gA1dBOSrbh0u5neJhZB1ZqVHtBXiPZxOPTIfZ/7KEG1aBPwrnbziSKhuk7/x/UiettaHLL2X85NnmY5flD3yWFS4kai7wDgP+2v09q7Q7g/YOcMH9x/aJ5OcPOUZXwRi8V3Wb66R7AoGBAL23dhbd/7TNlv53fri4JlOdRF6xqlbeqyAbb6gSOJ60SMYmtbQ9A/wxBmUnoIITj6TzvPAmcsknLfgfenj6PQsKj8iEZpknxujdDQDZRCWdSjkDVlVW7GyTUW3QIavoTJJuqFQPDimoDNDFOQ/lqFhMa8UCuXiPbnHcsS39a9TZ'),
	 ('fb8d1fe6-a66b-47b6-9d32-e688cd81de16','a8be44cd-f657-49a1-a5ec-0733cdc35408','allowed-protocol-mapper-types','saml-user-attribute-mapper');
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('008365ea-7ebe-4b5c-ba9a-1bfc874c9182','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_manage-account-links}','manage-account-links','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('016c3fb5-f5b1-480e-a458-31883d6bc654','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_manage-users}','manage-users','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('01eedfbf-d953-4ca3-b268-47ef9f469260','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_query-groups}','query-groups','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('0d628253-8f77-4f65-b372-0e13e450dfae','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_view-realm}','view-realm','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('0df39b41-d4cc-4f6a-a69a-d93b4bdd7146','f4e8abbb-ea16-4f52-a616-3c56d5099016',1,'','clouditera_common','c433f707-f45a-4a7b-b213-efe294a99f66','f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL),
	 ('112593ea-07f0-41d4-8fe5-6adad976918b','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_manage-account}','manage-account','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('175422c0-15ed-4dd4-909c-5db51f97f1d8','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_query-clients}','query-clients','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('19756da7-d88e-46b0-b229-a85cf4727679','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_view-events}','view-events','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('1d5459d2-8ef9-488f-a16e-865ffdd9f521','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_view-consent}','view-consent','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('1e38122e-cd06-4899-b8f5-46dadc0a2c16','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,'${role_uma_authorization}','uma_authorization','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('2558d5f8-1d1f-47c3-9f3c-bcfd0bee7dfb','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_view-profile}','view-profile','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','c433f707-f45a-4a7b-b213-efe294a99f66',0,'${role_default-roles}','default-roles-clouditera-iam','c433f707-f45a-4a7b-b213-efe294a99f66',NULL,NULL),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,'${role_admin}','admin','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,NULL),
	 ('2932059a-ff53-43dd-b2d4-b9aa267254c0','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_view-realm}','view-realm','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('3309b212-36e9-41a6-89b9-1ce5b89740cb','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_view-identity-providers}','view-identity-providers','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('34c8d1f5-2d45-4016-9227-3e885a882411','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_view-identity-providers}','view-identity-providers','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('352e1bfe-2c1b-4be4-8398-c4441ca0d4b1','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_manage-identity-providers}','manage-identity-providers','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('3614b79a-684b-430a-b464-b5e9bf2c8b11','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_view-clients}','view-clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('38a5054d-a93c-4784-b659-1e63224466a1','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_manage-realm}','manage-realm','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('3a4d277c-e143-4953-b07a-22cd3b15658e','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_view-groups}','view-groups','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('3af9589d-0c8b-4612-86e6-f98da687b902','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_view-consent}','view-consent','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('3dc6dab4-7ed9-4e42-b134-f8115a7089cc','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_manage-identity-providers}','manage-identity-providers','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('44ed8377-f52a-4eb5-93c0-3f3121648f9a','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_manage-account}','manage-account','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('471753a8-25db-4e77-afd2-3bb3fb6c12c9','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_manage-account-links}','manage-account-links','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('4f17ab16-dea9-4d25-9509-c957c22008a7','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_manage-events}','manage-events','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('50d5aaf7-55de-4a3e-a128-355b0d4f9e87','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_query-realms}','query-realms','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('593ed4e6-d1ca-4bfd-b456-a6bc0ceb269f','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_view-identity-providers}','view-identity-providers','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('5a2a776e-4e50-4aa4-9695-14677bb4ae8e','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_create-client}','create-client','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('60496768-9eb1-4be5-942a-f0084614a758','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_manage-consent}','manage-consent','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('611ec8d9-5fc8-4748-ada3-0a676723cba4','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_query-groups}','query-groups','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('61ed6d69-6d73-4d90-9300-f36847da0a8c','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_manage-clients}','manage-clients','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('65d5fc9a-d8d2-41b3-b240-fdee4df52b61','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_query-groups}','query-groups','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('70e3224d-87c3-4ad2-9008-c09b204925f0','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_impersonation}','impersonation','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('71755f2b-ec4a-4e3f-a75d-4880251de328','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_view-profile}','view-profile','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('755f09cc-b61e-48cd-8a5b-0835872115be','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_impersonation}','impersonation','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('777bace6-998c-4f1f-a53e-81dcf04f64b6','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_query-clients}','query-clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('785e944b-151a-4fcc-bdac-cca9ae002a6e','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_view-users}','view-users','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('7f7d2e51-5771-4690-a4a6-3126abd916c1','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_manage-clients}','manage-clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('7fe775e9-f8f7-42b7-ad61-d1a90ef13be3','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_delete-account}','delete-account','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('82cfa445-d58a-473c-8921-6a134af34d86','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_view-clients}','view-clients','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('856eb073-ebb5-4499-b401-6a05d15e23ce','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,'${role_create-realm}','create-realm','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,NULL),
	 ('8893d3d1-aff4-4f23-b9d5-a93ce276efbb','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_create-client}','create-client','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('890ca2d7-3168-4419-b1a9-fe7ea7fbb009','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_query-realms}','query-realms','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('89e0d337-348f-4187-95ca-4ca7d1995c51','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_query-users}','query-users','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('8b0baac8-114a-4876-b5b9-ae2cd44233b0','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_manage-authorization}','manage-authorization','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('8b75fbbd-97cc-4cfc-ac23-54af3bace3f1','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_view-events}','view-events','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('8d1656a4-64aa-474e-be0b-9e52e149ef8c','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_view-applications}','view-applications','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('8eb86775-dd4d-4b06-bf97-9c3a4d3934ac','0d7809fa-2645-4607-80ae-82335105f4ae',1,'${role_read-token}','read-token','c433f707-f45a-4a7b-b213-efe294a99f66','0d7809fa-2645-4607-80ae-82335105f4ae',NULL),
	 ('8f2c2482-95f9-4805-aaf9-74ec21b5d298','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_query-users}','query-users','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('987fb8ab-1b83-4666-a126-9393ef04c025','f4e8abbb-ea16-4f52-a616-3c56d5099016',1,'','clouditera_group_admin','c433f707-f45a-4a7b-b213-efe294a99f66','f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('9c502b59-e12f-4f2d-ad64-954ad4dcf8cb','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_create-client}','create-client','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('a13bf1e8-f9a9-42d1-b8af-15696701ec7d','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_view-users}','view-users','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('a69bccc8-44e8-495f-ac0b-ca71a4f5519d','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_manage-identity-providers}','manage-identity-providers','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('a9aceec3-2486-4ca6-b760-abdf3841a68b','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_view-applications}','view-applications','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('af6ef797-bb90-4a4a-a22f-165293ec368f','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_view-groups}','view-groups','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_realm-admin}','realm-admin','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('b0b78727-c8b6-4489-aa03-62185d362d11','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_manage-authorization}','manage-authorization','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('b2a33d18-3a0b-499f-bd57-6d210965b78f','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_view-authorization}','view-authorization','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('b43dac3c-d280-418c-8814-c8bb5e5d07f1','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_view-users}','view-users','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('ba772400-2cd7-4a69-aaa7-29a3094ea9f4','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_view-realm}','view-realm','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('bdd8193e-4f09-4db2-b64d-7039101a8013','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_query-realms}','query-realms','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('be50a27d-1480-49db-b7e0-d921c757358d','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_view-authorization}','view-authorization','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('c887490c-a194-4c7c-ab00-143131b660d5','b24689d7-ff63-4331-b52b-1f51035cd520',1,'${role_read-token}','read-token','73b44a4b-16ae-442b-adf5-60e57d986b2b','b24689d7-ff63-4331-b52b-1f51035cd520',NULL),
	 ('c9730148-aec2-4a68-aba6-b42f489e4c5c','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,'${role_default-roles}','default-roles-master','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,NULL),
	 ('cca07fa2-d909-480d-a1b5-f62759887277','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_manage-authorization}','manage-authorization','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('d1eebc0e-f374-4c2d-a5bc-1f535981343a','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_manage-users}','manage-users','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('d5756d92-333c-4b83-9dee-978da2cbd455','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_query-clients}','query-clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('d8f3865d-9b6b-4b6c-a79c-0c8337958773','c433f707-f45a-4a7b-b213-efe294a99f66',0,'${role_offline-access}','offline_access','c433f707-f45a-4a7b-b213-efe294a99f66',NULL,NULL),
	 ('da0d65f8-c81b-4a74-806f-0554fa18ab00','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,'${role_offline-access}','offline_access','73b44a4b-16ae-442b-adf5-60e57d986b2b',NULL,NULL),
	 ('dd0c0ced-89b6-4b50-9952-07b277b6ae25','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_query-users}','query-users','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('dd7ce5f7-6fb6-4205-b20a-859fb0e9fcea','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_view-authorization}','view-authorization','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('dffa6bc3-f48e-4cca-bb5d-e1c8e4d62d7a','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_manage-events}','manage-events','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL),
	 ('e55e49c5-fd22-427c-bc84-57d4bcdd0510','f4e8abbb-ea16-4f52-a616-3c56d5099016',1,'','clouditera_admin','c433f707-f45a-4a7b-b213-efe294a99f66','f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL),
	 ('e7a94fc0-9096-4421-a28c-195276818b03','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_view-events}','view-events','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('e829cf6c-9cbd-4bdb-8e6e-95a475de602c','05131bf9-a52d-464f-8be7-5ccfaf205cf3',1,'${role_manage-consent}','manage-consent','73b44a4b-16ae-442b-adf5-60e57d986b2b','05131bf9-a52d-464f-8be7-5ccfaf205cf3',NULL),
	 ('e8f83d10-e69f-46a7-9577-47c7ab35cbf2','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_view-clients}','view-clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('f1669553-9e19-49e5-afed-85915f4d124e','d47426f4-d00b-4660-ab3c-7cc504993d5e',1,'${role_manage-users}','manage-users','73b44a4b-16ae-442b-adf5-60e57d986b2b','d47426f4-d00b-4660-ab3c-7cc504993d5e',NULL),
	 ('f1e26ddb-c978-4db5-948f-ac682fd0c5e2','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_manage-realm}','manage-realm','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('f3ba4668-f913-4b49-b24e-604453addcdd','de808745-fdc5-4fa6-a13c-a3e1d7188073',1,'${role_delete-account}','delete-account','c433f707-f45a-4a7b-b213-efe294a99f66','de808745-fdc5-4fa6-a13c-a3e1d7188073',NULL),
	 ('f4903850-f30b-44df-9728-8549cf789ac0','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_manage-realm}','manage-realm','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL);
INSERT INTO clouditera_iam.KEYCLOAK_ROLE (ID,CLIENT_REALM_CONSTRAINT,CLIENT_ROLE,DESCRIPTION,NAME,REALM_ID,CLIENT,REALM) VALUES
	 ('fae34ad7-6639-4080-9ebb-242848b8687c','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_manage-clients}','manage-clients','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('fb0d6bf6-528a-444f-a14d-dbf2fb65c1ae','c433f707-f45a-4a7b-b213-efe294a99f66',0,'${role_uma_authorization}','uma_authorization','c433f707-f45a-4a7b-b213-efe294a99f66',NULL,NULL),
	 ('fbed591e-71ba-49fb-9b0d-a57b1a084c68','3d4280b2-bb1c-4887-8993-7224db306067',1,'${role_manage-events}','manage-events','73b44a4b-16ae-442b-adf5-60e57d986b2b','3d4280b2-bb1c-4887-8993-7224db306067',NULL),
	 ('fd7a3066-9459-4c43-8c18-4428538aa190','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',1,'${role_impersonation}','impersonation','c433f707-f45a-4a7b-b213-efe294a99f66','4681786f-6fd2-4955-b5e3-74fe0ea3b5d8',NULL);
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('112593ea-07f0-41d4-8fe5-6adad976918b','471753a8-25db-4e77-afd2-3bb3fb6c12c9'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','0df39b41-d4cc-4f6a-a69a-d93b4bdd7146'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','112593ea-07f0-41d4-8fe5-6adad976918b'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','175422c0-15ed-4dd4-909c-5db51f97f1d8'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','1d5459d2-8ef9-488f-a16e-865ffdd9f521'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','2558d5f8-1d1f-47c3-9f3c-bcfd0bee7dfb'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','2932059a-ff53-43dd-b2d4-b9aa267254c0'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','34c8d1f5-2d45-4016-9227-3e885a882411'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','3dc6dab4-7ed9-4e42-b134-f8115a7089cc'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','471753a8-25db-4e77-afd2-3bb3fb6c12c9');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','5a2a776e-4e50-4aa4-9695-14677bb4ae8e'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','60496768-9eb1-4be5-942a-f0084614a758'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','61ed6d69-6d73-4d90-9300-f36847da0a8c'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','65d5fc9a-d8d2-41b3-b240-fdee4df52b61'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','82cfa445-d58a-473c-8921-6a134af34d86'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','89e0d337-348f-4187-95ca-4ca7d1995c51'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','8b0baac8-114a-4876-b5b9-ae2cd44233b0'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','8b75fbbd-97cc-4cfc-ac23-54af3bace3f1'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','8eb86775-dd4d-4b06-bf97-9c3a4d3934ac'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','987fb8ab-1b83-4666-a126-9393ef04c025');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','a9aceec3-2486-4ca6-b760-abdf3841a68b'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','af6ef797-bb90-4a4a-a22f-165293ec368f'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','b054825d-8ffb-4ec5-b6f4-2585cb90c91a'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','b43dac3c-d280-418c-8814-c8bb5e5d07f1'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','bdd8193e-4f09-4db2-b64d-7039101a8013'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','be50a27d-1480-49db-b7e0-d921c757358d'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','d1eebc0e-f374-4c2d-a5bc-1f535981343a'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','d8f3865d-9b6b-4b6c-a79c-0c8337958773'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','dffa6bc3-f48e-4cca-bb5d-e1c8e4d62d7a'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','e55e49c5-fd22-427c-bc84-57d4bcdd0510');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','f3ba4668-f913-4b49-b24e-604453addcdd'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','f4903850-f30b-44df-9728-8549cf789ac0'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','fb0d6bf6-528a-444f-a14d-dbf2fb65c1ae'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','fd7a3066-9459-4c43-8c18-4428538aa190'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','016c3fb5-f5b1-480e-a458-31883d6bc654'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','01eedfbf-d953-4ca3-b268-47ef9f469260'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','0d628253-8f77-4f65-b372-0e13e450dfae'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','19756da7-d88e-46b0-b229-a85cf4727679'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','3309b212-36e9-41a6-89b9-1ce5b89740cb'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','352e1bfe-2c1b-4be4-8398-c4441ca0d4b1');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','3614b79a-684b-430a-b464-b5e9bf2c8b11'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','38a5054d-a93c-4784-b659-1e63224466a1'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','4f17ab16-dea9-4d25-9509-c957c22008a7'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','50d5aaf7-55de-4a3e-a128-355b0d4f9e87'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','593ed4e6-d1ca-4bfd-b456-a6bc0ceb269f'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','611ec8d9-5fc8-4748-ada3-0a676723cba4'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','70e3224d-87c3-4ad2-9008-c09b204925f0'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','755f09cc-b61e-48cd-8a5b-0835872115be'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','777bace6-998c-4f1f-a53e-81dcf04f64b6'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','785e944b-151a-4fcc-bdac-cca9ae002a6e');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','7f7d2e51-5771-4690-a4a6-3126abd916c1'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','856eb073-ebb5-4499-b401-6a05d15e23ce'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','8893d3d1-aff4-4f23-b9d5-a93ce276efbb'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','890ca2d7-3168-4419-b1a9-fe7ea7fbb009'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','8f2c2482-95f9-4805-aaf9-74ec21b5d298'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','9c502b59-e12f-4f2d-ad64-954ad4dcf8cb'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','a13bf1e8-f9a9-42d1-b8af-15696701ec7d'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','a69bccc8-44e8-495f-ac0b-ca71a4f5519d'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','b0b78727-c8b6-4489-aa03-62185d362d11'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','b2a33d18-3a0b-499f-bd57-6d210965b78f');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','ba772400-2cd7-4a69-aaa7-29a3094ea9f4'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','cca07fa2-d909-480d-a1b5-f62759887277'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','d5756d92-333c-4b83-9dee-978da2cbd455'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','dd0c0ced-89b6-4b50-9952-07b277b6ae25'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','dd7ce5f7-6fb6-4205-b20a-859fb0e9fcea'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','e7a94fc0-9096-4421-a28c-195276818b03'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','e8f83d10-e69f-46a7-9577-47c7ab35cbf2'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','f1669553-9e19-49e5-afed-85915f4d124e'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','f1e26ddb-c978-4db5-948f-ac682fd0c5e2'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','fae34ad7-6639-4080-9ebb-242848b8687c');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','fbed591e-71ba-49fb-9b0d-a57b1a084c68'),
	 ('3614b79a-684b-430a-b464-b5e9bf2c8b11','d5756d92-333c-4b83-9dee-978da2cbd455'),
	 ('44ed8377-f52a-4eb5-93c0-3f3121648f9a','008365ea-7ebe-4b5c-ba9a-1bfc874c9182'),
	 ('60496768-9eb1-4be5-942a-f0084614a758','1d5459d2-8ef9-488f-a16e-865ffdd9f521'),
	 ('785e944b-151a-4fcc-bdac-cca9ae002a6e','611ec8d9-5fc8-4748-ada3-0a676723cba4'),
	 ('785e944b-151a-4fcc-bdac-cca9ae002a6e','8f2c2482-95f9-4805-aaf9-74ec21b5d298'),
	 ('82cfa445-d58a-473c-8921-6a134af34d86','175422c0-15ed-4dd4-909c-5db51f97f1d8'),
	 ('a13bf1e8-f9a9-42d1-b8af-15696701ec7d','01eedfbf-d953-4ca3-b268-47ef9f469260'),
	 ('a13bf1e8-f9a9-42d1-b8af-15696701ec7d','dd0c0ced-89b6-4b50-9952-07b277b6ae25'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','175422c0-15ed-4dd4-909c-5db51f97f1d8');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','2932059a-ff53-43dd-b2d4-b9aa267254c0'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','34c8d1f5-2d45-4016-9227-3e885a882411'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','3dc6dab4-7ed9-4e42-b134-f8115a7089cc'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','5a2a776e-4e50-4aa4-9695-14677bb4ae8e'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','61ed6d69-6d73-4d90-9300-f36847da0a8c'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','65d5fc9a-d8d2-41b3-b240-fdee4df52b61'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','82cfa445-d58a-473c-8921-6a134af34d86'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','89e0d337-348f-4187-95ca-4ca7d1995c51'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','8b0baac8-114a-4876-b5b9-ae2cd44233b0'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','8b75fbbd-97cc-4cfc-ac23-54af3bace3f1');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','b43dac3c-d280-418c-8814-c8bb5e5d07f1'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','bdd8193e-4f09-4db2-b64d-7039101a8013'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','be50a27d-1480-49db-b7e0-d921c757358d'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','d1eebc0e-f374-4c2d-a5bc-1f535981343a'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','dffa6bc3-f48e-4cca-bb5d-e1c8e4d62d7a'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','f4903850-f30b-44df-9728-8549cf789ac0'),
	 ('b054825d-8ffb-4ec5-b6f4-2585cb90c91a','fd7a3066-9459-4c43-8c18-4428538aa190'),
	 ('b43dac3c-d280-418c-8814-c8bb5e5d07f1','65d5fc9a-d8d2-41b3-b240-fdee4df52b61'),
	 ('b43dac3c-d280-418c-8814-c8bb5e5d07f1','89e0d337-348f-4187-95ca-4ca7d1995c51'),
	 ('c9730148-aec2-4a68-aba6-b42f489e4c5c','1e38122e-cd06-4899-b8f5-46dadc0a2c16');
INSERT INTO clouditera_iam.COMPOSITE_ROLE (COMPOSITE,CHILD_ROLE) VALUES
	 ('c9730148-aec2-4a68-aba6-b42f489e4c5c','44ed8377-f52a-4eb5-93c0-3f3121648f9a'),
	 ('c9730148-aec2-4a68-aba6-b42f489e4c5c','71755f2b-ec4a-4e3f-a75d-4880251de328'),
	 ('c9730148-aec2-4a68-aba6-b42f489e4c5c','da0d65f8-c81b-4a74-806f-0554fa18ab00'),
	 ('e829cf6c-9cbd-4bdb-8e6e-95a475de602c','3af9589d-0c8b-4612-86e6-f98da687b902'),
	 ('e8f83d10-e69f-46a7-9577-47c7ab35cbf2','777bace6-998c-4f1f-a53e-81dcf04f64b6');
INSERT INTO clouditera_iam.USER_ENTITY (ID,EMAIL,EMAIL_CONSTRAINT,EMAIL_VERIFIED,ENABLED,FEDERATION_LINK,FIRST_NAME,LAST_NAME,REALM_ID,USERNAME,CREATED_TIMESTAMP,SERVICE_ACCOUNT_CLIENT_LINK,NOT_BEFORE) VALUES
	 ('8b3128aa-cf5a-47c7-be68-fee8bcec51f7','admin@clouditera.com','admin@clouditera.com',0,1,NULL,'云起','无垠','c433f707-f45a-4a7b-b213-efe294a99f66','admin',1755026659864,NULL,1755030216),
	 ('d0414396-2c33-4906-8fbe-7933388f7412',NULL,'54316f64-1895-4736-a693-d9bb8a057bb9',0,1,NULL,NULL,NULL,'73b44a4b-16ae-442b-adf5-60e57d986b2b','admin',1755019515345,NULL,0),
	 ('eb5118b0-5db9-497b-b2dc-4a5c21569c12',NULL,'e0b6c26f-b8a2-4306-9e13-9cb87e1525aa',0,1,NULL,NULL,NULL,'c433f707-f45a-4a7b-b213-efe294a99f66','service-account-clouditera-aigc',1755022908757,'f4e8abbb-ea16-4f52-a616-3c56d5099016',0);
INSERT INTO clouditera_iam.CREDENTIAL (ID,SALT,`TYPE`,USER_ID,CREATED_DATE,USER_LABEL,SECRET_DATA,CREDENTIAL_DATA,PRIORITY) VALUES
	 ('96e478b8-9f24-4fea-a7ef-7df17e94fa1f',NULL,'password','8b3128aa-cf5a-47c7-be68-fee8bcec51f7',1755026684791,'My password','{"value":"ttdfIpx3+RJvSCoZP3cT/8uHchMmZY2gPI5LRHFmBNg=","salt":"zJERV2c8RNXC92c1nSbwHg==","additionalParameters":{}}','{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}',10),
	 ('e4df49dc-240c-418c-9a45-2ae339934827',NULL,'password','d0414396-2c33-4906-8fbe-7933388f7412',1755019515454,NULL,'{"value":"UvNDFTAQ/wh2g4AKCiM0FTLsHgpAouSkMClt4l0xc78=","salt":"WSZapDSy6B9pAdSRG3hNvA==","additionalParameters":{}}','{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}',10);
INSERT INTO clouditera_iam.DEFAULT_CLIENT_SCOPE (REALM_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','1d3b3c83-3006-465c-b232-fc2d53eda769',1),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','36ebeacf-777b-476f-a3aa-4963d45e41ae',1),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','6da29c8a-45b8-4905-af4f-41f01a8425e1',1),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','7303ff3f-7670-4f73-a376-05b60aa0defb',0),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','810c8afd-856f-4daf-9635-0d11c15e6cc4',0),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','88e86a8c-0468-43b3-991c-d7f8b55bb210',1),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','ae50ee14-a052-4985-a542-e21a798b1e92',1),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','b9cb3955-3bec-4cc8-b79b-8b463c49be5e',0),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','df60fb8f-4695-40d0-b436-ac84819e9248',1),
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','f4363b05-5882-4034-9682-413a16956e0e',0);
INSERT INTO clouditera_iam.DEFAULT_CLIENT_SCOPE (REALM_ID,SCOPE_ID,DEFAULT_SCOPE) VALUES
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','10a651c8-01bf-4e12-a518-d71e0c65898a',0),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','4ee2871d-ede3-4857-b73d-3f7662ecf0c0',1),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','565d39c5-e11b-4b52-9c06-e94eb40cf822',0),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','7cf45c65-103f-4ea9-9f3c-243e2435f172',1),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','86858db1-8e7c-4ee6-a77f-3474d63b4c55',1),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','e5ae7bdb-86e5-4d7a-8eeb-098c734492df',1),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','e673a90f-38bd-4221-93ca-c4043e27b012',0),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','eb746e3a-0234-487d-8fe6-db5a19978066',0),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','ec0e25fd-09f1-4f49-8700-ac33f94676b1',1),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','ff347623-d286-4d78-be8d-414f2022c755',1);
INSERT INTO clouditera_iam.EVENT_ENTITY (ID,CLIENT_ID,DETAILS_JSON,ERROR,IP_ADDRESS,REALM_ID,SESSION_ID,EVENT_TIME,`TYPE`,USER_ID) VALUES
	 ('7000f427-79f9-4293-9788-09f3a00c8736','clouditera-aigc','{"auth_method":"openid-connect","grant_type":"password","client_auth_method":"client-secret","username":"admin@clouditera.com"}','resolve_required_actions','10.10.11.1','c433f707-f45a-4a7b-b213-efe294a99f66',NULL,1755026767942,'LOGIN_ERROR',NULL);

INSERT INTO clouditera_iam.KEYCLOAK_GROUP (ID,NAME,PARENT_GROUP,REALM_ID) VALUES
	 ('887a71af-b06a-4b5e-bfb7-e8a737637bbc','admingroup',' ','c433f707-f45a-4a7b-b213-efe294a99f66'),
	 ('b04c2fcb-72a5-4032-b961-147062c35668','group20250813035356199',' ','c433f707-f45a-4a7b-b213-efe294a99f66');
INSERT INTO clouditera_iam.GROUP_ATTRIBUTE (ID,NAME,VALUE,GROUP_ID) VALUES
	 ('2ff996f5-05d1-4d44-861b-cd271a66c653','createById','8b3128aa-cf5a-47c7-be68-fee8bcec51f7','b04c2fcb-72a5-4032-b961-147062c35668'),
	 ('40ac0def-56f9-48e1-81a9-152e5edeb04d','groupDescribe','组织','b04c2fcb-72a5-4032-b961-147062c35668'),
	 ('42147301-8e49-4b96-8d63-4ac09d40660f','groupManagerId','8b3128aa-cf5a-47c7-be68-fee8bcec51f7','887a71af-b06a-4b5e-bfb7-e8a737637bbc'),
	 ('4cdadbd0-d9f9-40b0-b173-551cdbb7300c','groupManagerName','admin','b04c2fcb-72a5-4032-b961-147062c35668'),
	 ('9b4b68cf-8839-42a3-961a-82010b3b7ba7','groupManagerId','8b3128aa-cf5a-47c7-be68-fee8bcec51f7','b04c2fcb-72a5-4032-b961-147062c35668'),
	 ('a6a5bff1-62fb-4cd2-be3c-cd04723b5610','groupType','GROUP_TYPE','b04c2fcb-72a5-4032-b961-147062c35668'),
	 ('c0b946e0-77b0-4e87-8fc3-abc51515405f','createBy','admin','b04c2fcb-72a5-4032-b961-147062c35668');

INSERT INTO clouditera_iam.MIGRATION_MODEL (ID,VERSION,UPDATE_TIME) VALUES
	 ('52uvs','22.0.0',1755019513);
INSERT INTO clouditera_iam.POLICY_CONFIG (POLICY_ID,NAME,VALUE) VALUES
	 ('4a6dac54-3d20-4a22-97e4-5ecc38956b31','defaultResourceType','urn:clouditera-aigc:resources:default'),
	 ('ffdc6e2e-3636-413e-9e23-666cbd7b81d4','code','// by default, grants any permission associated with this policy
$evaluation.grant();
');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','updated at','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('04fc2e53-9c4b-4b00-8a73-fdf8f00d9038','realm roles','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'36ebeacf-777b-476f-a3aa-4963d45e41ae'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','Client ID','openid-connect','oidc-usersessionmodel-note-mapper','f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL),
	 ('0b854b32-027e-41c1-8721-ff95380efa65','nickname','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','phone number verified','openid-connect','oidc-usermodel-attribute-mapper',NULL,'10a651c8-01bf-4e12-a518-d71e0c65898a'),
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','locale','openid-connect','oidc-usermodel-attribute-mapper','b4d6375d-3d4e-4ef7-a693-c5e1aed78c09',NULL),
	 ('125f69d3-054d-4a4f-858a-13c5e0754d16','role list','saml','saml-role-list-mapper',NULL,'e5ae7bdb-86e5-4d7a-8eeb-098c734492df'),
	 ('12fe2f1c-863d-4470-95e6-8c9274d2273f','full name','openid-connect','oidc-full-name-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','zoneinfo','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','given name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('20082043-c055-442d-925d-2e60cea0ecd6','updated at','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','nickname','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','gender','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('3f6a4a47-3ebb-45d0-9234-97a71545eacc','allowed web origins','openid-connect','oidc-allowed-origins-mapper',NULL,'6da29c8a-45b8-4905-af4f-41f01a8425e1'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','username','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('4bab55f2-2808-4dc7-8eb6-3514daae52fc','allowed web origins','openid-connect','oidc-allowed-origins-mapper',NULL,'ff347623-d286-4d78-be8d-414f2022c755'),
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','email verified','openid-connect','oidc-usermodel-property-mapper',NULL,'1d3b3c83-3006-465c-b232-fc2d53eda769'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','groups','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'565d39c5-e11b-4b52-9c06-e94eb40cf822'),
	 ('5a2ce59e-7a5d-4ca5-ae0c-286b8a058fcf','client roles','openid-connect','oidc-usermodel-client-role-mapper',NULL,'7cf45c65-103f-4ea9-9f3c-243e2435f172'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','upn','openid-connect','oidc-usermodel-attribute-mapper',NULL,'565d39c5-e11b-4b52-9c06-e94eb40cf822');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('6b6254e2-fca9-4ee1-8d16-90bc586658d7','full name','openid-connect','oidc-full-name-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','birthdate','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','website','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','family name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','family name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','Client IP Address','openid-connect','oidc-usersessionmodel-note-mapper','f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL),
	 ('74c1882e-057f-4ba0-8d81-bcea29cc681c','acr loa level','openid-connect','oidc-acr-mapper',NULL,'df60fb8f-4695-40d0-b436-ac84819e9248'),
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','Client Host','openid-connect','oidc-usersessionmodel-note-mapper','f4e8abbb-ea16-4f52-a616-3c56d5099016',NULL),
	 ('7a452670-73b6-42df-b1c6-1ce482b5b43d','realm roles','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'7cf45c65-103f-4ea9-9f3c-243e2435f172'),
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','email verified','openid-connect','oidc-usermodel-property-mapper',NULL,'ec0e25fd-09f1-4f49-8700-ac33f94676b1');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','phone number','openid-connect','oidc-usermodel-attribute-mapper',NULL,'810c8afd-856f-4daf-9635-0d11c15e6cc4'),
	 ('926dd706-30f6-4fe4-99b5-efbcd318fc9d','client roles','openid-connect','oidc-usermodel-client-role-mapper',NULL,'36ebeacf-777b-476f-a3aa-4963d45e41ae'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','picture','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('982ec755-4000-4a2a-8d4c-93b8f267f439','audience resolve','openid-connect','oidc-audience-resolve-mapper',NULL,'36ebeacf-777b-476f-a3aa-4963d45e41ae'),
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','profile','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','middle name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','zoneinfo','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','address','openid-connect','oidc-address-mapper',NULL,'eb746e3a-0234-487d-8fe6-db5a19978066'),
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','birthdate','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','email','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ec0e25fd-09f1-4f49-8700-ac33f94676b1');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','email','openid-connect','oidc-usermodel-attribute-mapper',NULL,'1d3b3c83-3006-465c-b232-fc2d53eda769'),
	 ('a7842f30-032a-47f2-a22b-ed9f949a14f1','role list','saml','saml-role-list-mapper',NULL,'88e86a8c-0468-43b3-991c-d7f8b55bb210'),
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','locale','openid-connect','oidc-usermodel-attribute-mapper','46dcb18d-572f-4131-92f3-c02d12458660',NULL),
	 ('a9aa6d69-75f1-48cd-aad7-c736a4d355b4','audience resolve','openid-connect','oidc-audience-resolve-mapper','32d1dc0b-a490-42b4-b374-6e2a72e32444',NULL),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','phone number','openid-connect','oidc-usermodel-attribute-mapper',NULL,'10a651c8-01bf-4e12-a518-d71e0c65898a'),
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','profile','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','locale','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','username','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','groups','openid-connect','oidc-usermodel-realm-role-mapper',NULL,'f4363b05-5882-4034-9682-413a16956e0e'),
	 ('cb636bb4-e25d-4b8b-a51f-87e64291a9ac','audience resolve','openid-connect','oidc-audience-resolve-mapper','f4fc18a0-a064-455d-9e4d-29b826bb1005',NULL);
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','upn','openid-connect','oidc-usermodel-attribute-mapper',NULL,'f4363b05-5882-4034-9682-413a16956e0e'),
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','locale','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('d77ebaac-b3d3-4b45-9afa-02eda4d8c61f','acr loa level','openid-connect','oidc-acr-mapper',NULL,'86858db1-8e7c-4ee6-a77f-3474d63b4c55'),
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','picture','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('dd028794-e870-4e38-b020-d911915fe718','audience resolve','openid-connect','oidc-audience-resolve-mapper',NULL,'7cf45c65-103f-4ea9-9f3c-243e2435f172'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','gender','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','middle name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','given name','openid-connect','oidc-usermodel-attribute-mapper',NULL,'4ee2871d-ede3-4857-b73d-3f7662ecf0c0'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','website','openid-connect','oidc-usermodel-attribute-mapper',NULL,'ae50ee14-a052-4985-a542-e21a798b1e92'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','address','openid-connect','oidc-address-mapper',NULL,'b9cb3955-3bec-4cc8-b79b-8b463c49be5e');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER (ID,NAME,PROTOCOL,PROTOCOL_MAPPER_NAME,CLIENT_ID,CLIENT_SCOPE_ID) VALUES
	 ('fcf56598-5375-4de3-b5af-f4641181d690','phone number verified','openid-connect','oidc-usermodel-attribute-mapper',NULL,'810c8afd-856f-4daf-9635-0d11c15e6cc4');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','true','access.token.claim'),
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','updated_at','claim.name'),
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','true','id.token.claim'),
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','long','jsonType.label'),
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','updatedAt','user.attribute'),
	 ('028ae06f-00aa-444a-af6f-6a226fb1ae0a','true','userinfo.token.claim'),
	 ('04fc2e53-9c4b-4b00-8a73-fdf8f00d9038','true','access.token.claim'),
	 ('04fc2e53-9c4b-4b00-8a73-fdf8f00d9038','realm_access.roles','claim.name'),
	 ('04fc2e53-9c4b-4b00-8a73-fdf8f00d9038','String','jsonType.label'),
	 ('04fc2e53-9c4b-4b00-8a73-fdf8f00d9038','true','multivalued');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('04fc2e53-9c4b-4b00-8a73-fdf8f00d9038','foo','user.attribute'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','true','access.token.claim'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','client_id','claim.name'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','true','id.token.claim'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','String','jsonType.label'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','client_id','user.session.note'),
	 ('0594d300-e2a7-4341-a84e-2bc9858f82bf','true','userinfo.token.claim'),
	 ('0b854b32-027e-41c1-8721-ff95380efa65','true','access.token.claim'),
	 ('0b854b32-027e-41c1-8721-ff95380efa65','nickname','claim.name'),
	 ('0b854b32-027e-41c1-8721-ff95380efa65','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('0b854b32-027e-41c1-8721-ff95380efa65','String','jsonType.label'),
	 ('0b854b32-027e-41c1-8721-ff95380efa65','nickname','user.attribute'),
	 ('0b854b32-027e-41c1-8721-ff95380efa65','true','userinfo.token.claim'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','true','access.token.claim'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','phone_number_verified','claim.name'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','true','id.token.claim'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','boolean','jsonType.label'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','phoneNumberVerified','user.attribute'),
	 ('0d1646a4-9df4-45f2-89da-e18c91ce607e','true','userinfo.token.claim'),
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','locale','claim.name'),
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','true','id.token.claim'),
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','String','jsonType.label'),
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','locale','user.attribute'),
	 ('121389a8-bf14-433d-adcd-8189b2c9199b','true','userinfo.token.claim'),
	 ('125f69d3-054d-4a4f-858a-13c5e0754d16','Role','attribute.name'),
	 ('125f69d3-054d-4a4f-858a-13c5e0754d16','Basic','attribute.nameformat'),
	 ('125f69d3-054d-4a4f-858a-13c5e0754d16','false','single'),
	 ('12fe2f1c-863d-4470-95e6-8c9274d2273f','true','access.token.claim'),
	 ('12fe2f1c-863d-4470-95e6-8c9274d2273f','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('12fe2f1c-863d-4470-95e6-8c9274d2273f','true','userinfo.token.claim'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','true','access.token.claim'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','zoneinfo','claim.name'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','true','id.token.claim'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','String','jsonType.label'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','zoneinfo','user.attribute'),
	 ('1c69e947-1351-447d-b710-10187bf9ce22','true','userinfo.token.claim'),
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','true','access.token.claim'),
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','given_name','claim.name'),
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','String','jsonType.label'),
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','firstName','user.attribute'),
	 ('1e0f51fa-8501-471a-b0e9-0be660dfe38a','true','userinfo.token.claim'),
	 ('20082043-c055-442d-925d-2e60cea0ecd6','true','access.token.claim'),
	 ('20082043-c055-442d-925d-2e60cea0ecd6','updated_at','claim.name'),
	 ('20082043-c055-442d-925d-2e60cea0ecd6','true','id.token.claim'),
	 ('20082043-c055-442d-925d-2e60cea0ecd6','long','jsonType.label'),
	 ('20082043-c055-442d-925d-2e60cea0ecd6','updatedAt','user.attribute'),
	 ('20082043-c055-442d-925d-2e60cea0ecd6','true','userinfo.token.claim'),
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','nickname','claim.name'),
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','true','id.token.claim'),
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','String','jsonType.label'),
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','nickname','user.attribute'),
	 ('2769a49e-1ef1-4718-81a1-078ab0082c28','true','userinfo.token.claim'),
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','true','access.token.claim'),
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','gender','claim.name'),
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','true','id.token.claim'),
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','String','jsonType.label'),
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','gender','user.attribute');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('36920f34-dec3-4bb2-9741-7a48ce5d0085','true','userinfo.token.claim'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','true','access.token.claim'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','preferred_username','claim.name'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','true','id.token.claim'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','String','jsonType.label'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','username','user.attribute'),
	 ('428a9757-ac00-46dc-9067-986fd2a744ee','true','userinfo.token.claim'),
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','true','access.token.claim'),
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','email_verified','claim.name'),
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','boolean','jsonType.label'),
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','emailVerified','user.attribute'),
	 ('4dcd0134-c9a6-43e2-bb6f-aa5a6a52e671','true','userinfo.token.claim'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','true','access.token.claim'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','groups','claim.name'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','true','id.token.claim'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','String','jsonType.label'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','true','multivalued'),
	 ('52d2db11-34b2-42a8-a14e-fe2df2414742','foo','user.attribute'),
	 ('5a2ce59e-7a5d-4ca5-ae0c-286b8a058fcf','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('5a2ce59e-7a5d-4ca5-ae0c-286b8a058fcf','resource_access.${client_id}.roles','claim.name'),
	 ('5a2ce59e-7a5d-4ca5-ae0c-286b8a058fcf','String','jsonType.label'),
	 ('5a2ce59e-7a5d-4ca5-ae0c-286b8a058fcf','true','multivalued'),
	 ('5a2ce59e-7a5d-4ca5-ae0c-286b8a058fcf','foo','user.attribute'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','true','access.token.claim'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','upn','claim.name'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','true','id.token.claim'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','String','jsonType.label'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','username','user.attribute'),
	 ('5e144597-db51-4430-8b13-009bae7d6c63','true','userinfo.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('6b6254e2-fca9-4ee1-8d16-90bc586658d7','true','access.token.claim'),
	 ('6b6254e2-fca9-4ee1-8d16-90bc586658d7','true','id.token.claim'),
	 ('6b6254e2-fca9-4ee1-8d16-90bc586658d7','true','userinfo.token.claim'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','true','access.token.claim'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','birthdate','claim.name'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','true','id.token.claim'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','String','jsonType.label'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','birthdate','user.attribute'),
	 ('6c984815-aec7-4c7d-b0c1-4c8132ab2112','true','userinfo.token.claim'),
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','website','claim.name'),
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','true','id.token.claim'),
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','String','jsonType.label'),
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','website','user.attribute'),
	 ('6caf8b7f-128c-47ff-aac8-b9b773a47c69','true','userinfo.token.claim'),
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','true','access.token.claim'),
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','family_name','claim.name'),
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','true','id.token.claim'),
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','String','jsonType.label'),
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','lastName','user.attribute');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('70644e71-2bf5-4bbe-92bb-df404000e158','true','userinfo.token.claim'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','true','access.token.claim'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','family_name','claim.name'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','true','id.token.claim'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','String','jsonType.label'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','lastName','user.attribute'),
	 ('733faf83-0578-44a1-b559-4d50586fbaba','true','userinfo.token.claim'),
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','true','access.token.claim'),
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','clientAddress','claim.name'),
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','String','jsonType.label'),
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','clientAddress','user.session.note'),
	 ('7348edf9-9d49-46d7-8bc7-642defc5de00','true','userinfo.token.claim'),
	 ('74c1882e-057f-4ba0-8d81-bcea29cc681c','true','access.token.claim'),
	 ('74c1882e-057f-4ba0-8d81-bcea29cc681c','true','id.token.claim'),
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','true','access.token.claim'),
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','clientHost','claim.name'),
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','true','id.token.claim'),
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','String','jsonType.label'),
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','clientHost','user.session.note');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('74fe7f3f-4019-440f-8e00-713a9deecbdf','true','userinfo.token.claim'),
	 ('7a452670-73b6-42df-b1c6-1ce482b5b43d','true','access.token.claim'),
	 ('7a452670-73b6-42df-b1c6-1ce482b5b43d','realm_access.roles','claim.name'),
	 ('7a452670-73b6-42df-b1c6-1ce482b5b43d','String','jsonType.label'),
	 ('7a452670-73b6-42df-b1c6-1ce482b5b43d','true','multivalued'),
	 ('7a452670-73b6-42df-b1c6-1ce482b5b43d','foo','user.attribute'),
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','true','access.token.claim'),
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','email_verified','claim.name'),
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','true','id.token.claim'),
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','boolean','jsonType.label');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','emailVerified','user.attribute'),
	 ('7d1640ad-bf60-43da-b62b-c3ef2032cf25','true','userinfo.token.claim'),
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','true','access.token.claim'),
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','phone_number','claim.name'),
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','true','id.token.claim'),
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','String','jsonType.label'),
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','phoneNumber','user.attribute'),
	 ('85b95ed4-7162-4257-ae67-14104ff60c08','true','userinfo.token.claim'),
	 ('926dd706-30f6-4fe4-99b5-efbcd318fc9d','true','access.token.claim'),
	 ('926dd706-30f6-4fe4-99b5-efbcd318fc9d','resource_access.${client_id}.roles','claim.name');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('926dd706-30f6-4fe4-99b5-efbcd318fc9d','String','jsonType.label'),
	 ('926dd706-30f6-4fe4-99b5-efbcd318fc9d','true','multivalued'),
	 ('926dd706-30f6-4fe4-99b5-efbcd318fc9d','foo','user.attribute'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','true','access.token.claim'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','picture','claim.name'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','true','id.token.claim'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','String','jsonType.label'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','picture','user.attribute'),
	 ('95db0709-dd0e-4aaf-9e11-8f9a91c946c7','true','userinfo.token.claim'),
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','profile','claim.name'),
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','true','id.token.claim'),
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','String','jsonType.label'),
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','profile','user.attribute'),
	 ('9aeacf49-d7b5-4cd2-9c7f-9c1c804b2ef1','true','userinfo.token.claim'),
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','true','access.token.claim'),
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','middle_name','claim.name'),
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','true','id.token.claim'),
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','String','jsonType.label'),
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','middleName','user.attribute');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('9bf3db55-65c5-4f0a-b45c-f5fdc47f75cc','true','userinfo.token.claim'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','true','access.token.claim'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','zoneinfo','claim.name'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','true','id.token.claim'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','String','jsonType.label'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','zoneinfo','user.attribute'),
	 ('9e061233-3bb4-4151-85b1-7904ca1ddc3a','true','userinfo.token.claim'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','true','access.token.claim'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','true','id.token.claim'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','country','user.attribute.country');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','formatted','user.attribute.formatted'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','locality','user.attribute.locality'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','postal_code','user.attribute.postal_code'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','region','user.attribute.region'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','street','user.attribute.street'),
	 ('a4909abc-e7e2-45ec-a600-bd95da017ce0','true','userinfo.token.claim'),
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','true','access.token.claim'),
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','birthdate','claim.name'),
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','true','id.token.claim'),
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','String','jsonType.label');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','birthdate','user.attribute'),
	 ('a5c61406-a12b-41a9-a95a-c8b25e237d0c','true','userinfo.token.claim'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','true','access.token.claim'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','email','claim.name'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','true','id.token.claim'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','String','jsonType.label'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','email','user.attribute'),
	 ('a7083291-49ef-4f78-8133-41fe34286e00','true','userinfo.token.claim'),
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','true','access.token.claim'),
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','email','claim.name');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','true','id.token.claim'),
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','String','jsonType.label'),
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','email','user.attribute'),
	 ('a7398158-5b7a-4a22-8387-1f3838ce6346','true','userinfo.token.claim'),
	 ('a7842f30-032a-47f2-a22b-ed9f949a14f1','Role','attribute.name'),
	 ('a7842f30-032a-47f2-a22b-ed9f949a14f1','Basic','attribute.nameformat'),
	 ('a7842f30-032a-47f2-a22b-ed9f949a14f1','false','single'),
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','true','access.token.claim'),
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','locale','claim.name'),
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','String','jsonType.label'),
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','locale','user.attribute'),
	 ('a8a62bc0-aeb6-4429-a752-239360942d50','true','userinfo.token.claim'),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','true','access.token.claim'),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','phone_number','claim.name'),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','true','id.token.claim'),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','String','jsonType.label'),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','phoneNumber','user.attribute'),
	 ('ad03a272-2868-4dac-9b52-3aea3199e952','true','userinfo.token.claim'),
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','profile','claim.name'),
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','true','id.token.claim'),
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','String','jsonType.label'),
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','profile','user.attribute'),
	 ('b1b9e84f-d874-4757-868e-7f83631c3398','true','userinfo.token.claim'),
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','true','access.token.claim'),
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','locale','claim.name'),
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','true','id.token.claim'),
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','String','jsonType.label'),
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','locale','user.attribute');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('b1d2c33f-3ade-4fe7-a751-ded8a3732bcf','true','userinfo.token.claim'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','true','access.token.claim'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','preferred_username','claim.name'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','true','id.token.claim'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','String','jsonType.label'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','username','user.attribute'),
	 ('b6f0d7e5-3967-4bc7-87b4-9134f3eab045','true','userinfo.token.claim'),
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','true','access.token.claim'),
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','groups','claim.name'),
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','String','jsonType.label'),
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','true','multivalued'),
	 ('bebc9d9f-b482-4045-bbd9-20c5ff1f0b68','foo','user.attribute'),
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','true','access.token.claim'),
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','upn','claim.name'),
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','true','id.token.claim'),
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','String','jsonType.label'),
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','username','user.attribute'),
	 ('cb8a876e-58e0-4283-ad83-6431a932ae70','true','userinfo.token.claim'),
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','locale','claim.name'),
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','true','id.token.claim'),
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','String','jsonType.label'),
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','locale','user.attribute'),
	 ('d10cff32-aee0-4d7d-b1a2-440b6b133806','true','userinfo.token.claim'),
	 ('d77ebaac-b3d3-4b45-9afa-02eda4d8c61f','true','access.token.claim'),
	 ('d77ebaac-b3d3-4b45-9afa-02eda4d8c61f','true','id.token.claim'),
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','true','access.token.claim'),
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','picture','claim.name'),
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','true','id.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','String','jsonType.label'),
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','picture','user.attribute'),
	 ('d9b3c061-2c66-463a-818d-9cf04245e9a3','true','userinfo.token.claim'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','true','access.token.claim'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','gender','claim.name'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','true','id.token.claim'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','String','jsonType.label'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','gender','user.attribute'),
	 ('e5e3b10a-0c89-4ef4-9908-b8da408fe711','true','userinfo.token.claim'),
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','true','access.token.claim');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','middle_name','claim.name'),
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','true','id.token.claim'),
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','String','jsonType.label'),
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','middleName','user.attribute'),
	 ('f80eac52-86ef-46ed-b618-3dc23aa53acb','true','userinfo.token.claim'),
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','true','access.token.claim'),
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','given_name','claim.name'),
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','true','id.token.claim'),
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','String','jsonType.label'),
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','firstName','user.attribute');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('f9d2c222-ca82-4586-a4e6-6feaeffd53e1','true','userinfo.token.claim'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','true','access.token.claim'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','website','claim.name'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','true','id.token.claim'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','String','jsonType.label'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','website','user.attribute'),
	 ('f9e043aa-476b-4b2e-bde4-e80d088aa0e2','true','userinfo.token.claim'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','true','access.token.claim'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','true','id.token.claim'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','country','user.attribute.country');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','formatted','user.attribute.formatted'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','locality','user.attribute.locality'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','postal_code','user.attribute.postal_code'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','region','user.attribute.region'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','street','user.attribute.street'),
	 ('fc5625dd-190c-4b98-83b8-6398f287320a','true','userinfo.token.claim'),
	 ('fcf56598-5375-4de3-b5af-f4641181d690','true','access.token.claim'),
	 ('fcf56598-5375-4de3-b5af-f4641181d690','phone_number_verified','claim.name'),
	 ('fcf56598-5375-4de3-b5af-f4641181d690','true','id.token.claim'),
	 ('fcf56598-5375-4de3-b5af-f4641181d690','boolean','jsonType.label');
INSERT INTO clouditera_iam.PROTOCOL_MAPPER_CONFIG (PROTOCOL_MAPPER_ID,VALUE,NAME) VALUES
	 ('fcf56598-5375-4de3-b5af-f4641181d690','phoneNumberVerified','user.attribute'),
	 ('fcf56598-5375-4de3-b5af-f4641181d690','true','userinfo.token.claim');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('_browser_header.contentSecurityPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','frame-src ''self''; frame-ancestors ''self''; object-src ''none'';'),
	 ('_browser_header.contentSecurityPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','frame-src ''self''; frame-ancestors ''self''; object-src ''none'';'),
	 ('_browser_header.contentSecurityPolicyReportOnly','73b44a4b-16ae-442b-adf5-60e57d986b2b',''),
	 ('_browser_header.contentSecurityPolicyReportOnly','c433f707-f45a-4a7b-b213-efe294a99f66',''),
	 ('_browser_header.referrerPolicy','73b44a4b-16ae-442b-adf5-60e57d986b2b','no-referrer'),
	 ('_browser_header.referrerPolicy','c433f707-f45a-4a7b-b213-efe294a99f66','no-referrer'),
	 ('_browser_header.strictTransportSecurity','73b44a4b-16ae-442b-adf5-60e57d986b2b','max-age=31536000; includeSubDomains'),
	 ('_browser_header.strictTransportSecurity','c433f707-f45a-4a7b-b213-efe294a99f66','max-age=31536000; includeSubDomains'),
	 ('_browser_header.xContentTypeOptions','73b44a4b-16ae-442b-adf5-60e57d986b2b','nosniff'),
	 ('_browser_header.xContentTypeOptions','c433f707-f45a-4a7b-b213-efe294a99f66','nosniff');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('_browser_header.xFrameOptions','73b44a4b-16ae-442b-adf5-60e57d986b2b','SAMEORIGIN'),
	 ('_browser_header.xFrameOptions','c433f707-f45a-4a7b-b213-efe294a99f66','SAMEORIGIN'),
	 ('_browser_header.xRobotsTag','73b44a4b-16ae-442b-adf5-60e57d986b2b','none'),
	 ('_browser_header.xRobotsTag','c433f707-f45a-4a7b-b213-efe294a99f66','none'),
	 ('_browser_header.xXSSProtection','73b44a4b-16ae-442b-adf5-60e57d986b2b','1; mode=block'),
	 ('_browser_header.xXSSProtection','c433f707-f45a-4a7b-b213-efe294a99f66','1; mode=block'),
	 ('actionTokenGeneratedByAdminLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','43200'),
	 ('actionTokenGeneratedByUserLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','300'),
	 ('bruteForceProtected','73b44a4b-16ae-442b-adf5-60e57d986b2b','false'),
	 ('bruteForceProtected','c433f707-f45a-4a7b-b213-efe294a99f66','false');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('cibaAuthRequestedUserHint','c433f707-f45a-4a7b-b213-efe294a99f66','login_hint'),
	 ('cibaBackchannelTokenDeliveryMode','c433f707-f45a-4a7b-b213-efe294a99f66','poll'),
	 ('cibaExpiresIn','c433f707-f45a-4a7b-b213-efe294a99f66','120'),
	 ('cibaInterval','c433f707-f45a-4a7b-b213-efe294a99f66','5'),
	 ('client-policies.policies','c433f707-f45a-4a7b-b213-efe294a99f66','{"policies":[]}'),
	 ('client-policies.profiles','c433f707-f45a-4a7b-b213-efe294a99f66','{"profiles":[]}'),
	 ('clientOfflineSessionIdleTimeout','c433f707-f45a-4a7b-b213-efe294a99f66','0'),
	 ('clientOfflineSessionMaxLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','0'),
	 ('clientSessionIdleTimeout','c433f707-f45a-4a7b-b213-efe294a99f66','0'),
	 ('clientSessionMaxLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','0');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('defaultSignatureAlgorithm','73b44a4b-16ae-442b-adf5-60e57d986b2b','RS256'),
	 ('defaultSignatureAlgorithm','c433f707-f45a-4a7b-b213-efe294a99f66','RS256'),
	 ('displayName','73b44a4b-16ae-442b-adf5-60e57d986b2b','Keycloak'),
	 ('displayNameHtml','73b44a4b-16ae-442b-adf5-60e57d986b2b','<div class="kc-logo-text"><span>Keycloak</span></div>'),
	 ('failureFactor','73b44a4b-16ae-442b-adf5-60e57d986b2b','30'),
	 ('failureFactor','c433f707-f45a-4a7b-b213-efe294a99f66','30'),
	 ('maxDeltaTimeSeconds','73b44a4b-16ae-442b-adf5-60e57d986b2b','43200'),
	 ('maxDeltaTimeSeconds','c433f707-f45a-4a7b-b213-efe294a99f66','43200'),
	 ('maxFailureWaitSeconds','73b44a4b-16ae-442b-adf5-60e57d986b2b','900'),
	 ('maxFailureWaitSeconds','c433f707-f45a-4a7b-b213-efe294a99f66','900');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('minimumQuickLoginWaitSeconds','73b44a4b-16ae-442b-adf5-60e57d986b2b','60'),
	 ('minimumQuickLoginWaitSeconds','c433f707-f45a-4a7b-b213-efe294a99f66','60'),
	 ('oauth2DeviceCodeLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','600'),
	 ('oauth2DevicePollingInterval','c433f707-f45a-4a7b-b213-efe294a99f66','5'),
	 ('offlineSessionMaxLifespan','73b44a4b-16ae-442b-adf5-60e57d986b2b','5184000'),
	 ('offlineSessionMaxLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','5184000'),
	 ('offlineSessionMaxLifespanEnabled','73b44a4b-16ae-442b-adf5-60e57d986b2b','false'),
	 ('offlineSessionMaxLifespanEnabled','c433f707-f45a-4a7b-b213-efe294a99f66','false'),
	 ('parRequestUriLifespan','c433f707-f45a-4a7b-b213-efe294a99f66','60'),
	 ('permanentLockout','73b44a4b-16ae-442b-adf5-60e57d986b2b','false');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('permanentLockout','c433f707-f45a-4a7b-b213-efe294a99f66','false'),
	 ('quickLoginCheckMilliSeconds','73b44a4b-16ae-442b-adf5-60e57d986b2b','1000'),
	 ('quickLoginCheckMilliSeconds','c433f707-f45a-4a7b-b213-efe294a99f66','1000'),
	 ('realmReusableOtpCode','73b44a4b-16ae-442b-adf5-60e57d986b2b','false'),
	 ('realmReusableOtpCode','c433f707-f45a-4a7b-b213-efe294a99f66','false'),
	 ('waitIncrementSeconds','73b44a4b-16ae-442b-adf5-60e57d986b2b','60'),
	 ('waitIncrementSeconds','c433f707-f45a-4a7b-b213-efe294a99f66','60'),
	 ('webAuthnPolicyAttestationConveyancePreference','c433f707-f45a-4a7b-b213-efe294a99f66','not specified'),
	 ('webAuthnPolicyAttestationConveyancePreferencePasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','not specified'),
	 ('webAuthnPolicyAuthenticatorAttachment','c433f707-f45a-4a7b-b213-efe294a99f66','not specified');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('webAuthnPolicyAuthenticatorAttachmentPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','not specified'),
	 ('webAuthnPolicyAvoidSameAuthenticatorRegister','c433f707-f45a-4a7b-b213-efe294a99f66','false'),
	 ('webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','false'),
	 ('webAuthnPolicyCreateTimeout','c433f707-f45a-4a7b-b213-efe294a99f66','0'),
	 ('webAuthnPolicyCreateTimeoutPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','0'),
	 ('webAuthnPolicyRequireResidentKey','c433f707-f45a-4a7b-b213-efe294a99f66','not specified'),
	 ('webAuthnPolicyRequireResidentKeyPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','not specified'),
	 ('webAuthnPolicyRpEntityName','c433f707-f45a-4a7b-b213-efe294a99f66','keycloak'),
	 ('webAuthnPolicyRpEntityNamePasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','keycloak'),
	 ('webAuthnPolicyRpId','c433f707-f45a-4a7b-b213-efe294a99f66','');
INSERT INTO clouditera_iam.REALM_ATTRIBUTE (NAME,REALM_ID,VALUE) VALUES
	 ('webAuthnPolicyRpIdPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66',''),
	 ('webAuthnPolicySignatureAlgorithms','c433f707-f45a-4a7b-b213-efe294a99f66','ES256'),
	 ('webAuthnPolicySignatureAlgorithmsPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','ES256'),
	 ('webAuthnPolicyUserVerificationRequirement','c433f707-f45a-4a7b-b213-efe294a99f66','not specified'),
	 ('webAuthnPolicyUserVerificationRequirementPasswordless','c433f707-f45a-4a7b-b213-efe294a99f66','not specified');
INSERT INTO clouditera_iam.REALM_EVENTS_LISTENERS (REALM_ID,VALUE) VALUES
	 ('73b44a4b-16ae-442b-adf5-60e57d986b2b','jboss-logging'),
	 ('c433f707-f45a-4a7b-b213-efe294a99f66','jboss-logging');
INSERT INTO clouditera_iam.REALM_REQUIRED_CREDENTIAL (`TYPE`,FORM_LABEL,`INPUT`,SECRET,REALM_ID) VALUES
	 ('password','password',1,1,'73b44a4b-16ae-442b-adf5-60e57d986b2b'),
	 ('password','password',1,1,'c433f707-f45a-4a7b-b213-efe294a99f66');
INSERT INTO clouditera_iam.REDIRECT_URIS (CLIENT_ID,VALUE) VALUES
	 ('05131bf9-a52d-464f-8be7-5ccfaf205cf3','/realms/master/account/*'),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','/realms/master/account/*'),
	 ('46dcb18d-572f-4131-92f3-c02d12458660','/admin/Clouditera-IAM/console/*'),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','/admin/master/console/*'),
	 ('de808745-fdc5-4fa6-a13c-a3e1d7188073','/realms/Clouditera-IAM/account/*'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016',''),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','http://127.0.0.1/'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','http://192.168.32.46/'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','http://localhost:8888/'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','http://scaconverthttp/');
INSERT INTO clouditera_iam.REDIRECT_URIS (CLIENT_ID,VALUE) VALUES
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','http://scahttp/'),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','/realms/Clouditera-IAM/account/*');
INSERT INTO clouditera_iam.REQUIRED_ACTION_PROVIDER (ID,ALIAS,NAME,REALM_ID,ENABLED,DEFAULT_ACTION,PROVIDER_ID,PRIORITY) VALUES
	 ('155df340-8a45-4020-9ce7-72f5629660a5','UPDATE_PASSWORD','Update Password','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'UPDATE_PASSWORD',30),
	 ('15bd84b5-7cb8-444e-a192-7b9b4fad8813','VERIFY_EMAIL','Verify Email','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'VERIFY_EMAIL',50),
	 ('27af1817-ca6b-4a15-a6e2-d9eba2e556ba','webauthn-register-passwordless','Webauthn Register Passwordless','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'webauthn-register-passwordless',80),
	 ('296f00ea-5b06-4121-a297-6b28caad1ade','update_user_locale','Update User Locale','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'update_user_locale',1000),
	 ('2bef140a-aed0-45b8-a456-fc23b44e82a7','webauthn-register-passwordless','Webauthn Register Passwordless','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'webauthn-register-passwordless',80),
	 ('3775dbe8-6102-489c-b39a-a1d68f1b6369','update_user_locale','Update User Locale','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'update_user_locale',1000),
	 ('492ada0e-b543-455d-b818-3d7d9de17695','VERIFY_EMAIL','Verify Email','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'VERIFY_EMAIL',50),
	 ('6d5cba9c-5269-4e21-9d27-58b3b15e6740','UPDATE_PROFILE','Update Profile','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'UPDATE_PROFILE',40),
	 ('9c1e2d13-0179-476b-adff-36f67424c6fb','CONFIGURE_TOTP','Configure OTP','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'CONFIGURE_TOTP',10),
	 ('9ed266e1-34b7-4f8d-a95e-3fb5ae0a44d9','CONFIGURE_TOTP','Configure OTP','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'CONFIGURE_TOTP',10);
INSERT INTO clouditera_iam.REQUIRED_ACTION_PROVIDER (ID,ALIAS,NAME,REALM_ID,ENABLED,DEFAULT_ACTION,PROVIDER_ID,PRIORITY) VALUES
	 ('b8798b12-86ac-4222-921b-a3729e3eff99','TERMS_AND_CONDITIONS','Terms and Conditions','c433f707-f45a-4a7b-b213-efe294a99f66',0,0,'TERMS_AND_CONDITIONS',20),
	 ('c3e034b5-c9d8-470c-92a0-d80593ba2810','TERMS_AND_CONDITIONS','Terms and Conditions','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,0,'TERMS_AND_CONDITIONS',20),
	 ('c41bfb85-4934-4db3-994e-ae6e705e85b2','UPDATE_PASSWORD','Update Password','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'UPDATE_PASSWORD',30),
	 ('d8a2d109-967d-41b4-b028-8c91d14649c9','delete_account','Delete Account','c433f707-f45a-4a7b-b213-efe294a99f66',0,0,'delete_account',60),
	 ('de630668-1ce8-4b42-8fbf-74251c783798','UPDATE_PROFILE','Update Profile','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'UPDATE_PROFILE',40),
	 ('edc2df45-24b3-464d-8502-a4067cbbfb40','webauthn-register','Webauthn Register','c433f707-f45a-4a7b-b213-efe294a99f66',1,0,'webauthn-register',70),
	 ('feb19e3e-15e6-47c6-ab43-22ecf31ee0ca','delete_account','Delete Account','73b44a4b-16ae-442b-adf5-60e57d986b2b',0,0,'delete_account',60),
	 ('ff14c73f-ae2a-47c5-9cfb-494e25a3bddf','webauthn-register','Webauthn Register','73b44a4b-16ae-442b-adf5-60e57d986b2b',1,0,'webauthn-register',70);
INSERT INTO clouditera_iam.SCOPE_MAPPING (CLIENT_ID,ROLE_ID) VALUES
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','112593ea-07f0-41d4-8fe5-6adad976918b'),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','3a4d277c-e143-4953-b07a-22cd3b15658e'),
	 ('32d1dc0b-a490-42b4-b374-6e2a72e32444','44ed8377-f52a-4eb5-93c0-3f3121648f9a'),
	 ('f4fc18a0-a064-455d-9e4d-29b826bb1005','af6ef797-bb90-4a4a-a22f-165293ec368f');

INSERT INTO clouditera_iam.USER_GROUP_MEMBERSHIP (GROUP_ID,USER_ID) VALUES
	 ('887a71af-b06a-4b5e-bfb7-e8a737637bbc','8b3128aa-cf5a-47c7-be68-fee8bcec51f7'),
	 ('b04c2fcb-72a5-4032-b961-147062c35668','8b3128aa-cf5a-47c7-be68-fee8bcec51f7');
INSERT INTO clouditera_iam.USER_ROLE_MAPPING (ROLE_ID,USER_ID) VALUES
	 ('0df39b41-d4cc-4f6a-a69a-d93b4bdd7146','8b3128aa-cf5a-47c7-be68-fee8bcec51f7'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','8b3128aa-cf5a-47c7-be68-fee8bcec51f7'),
	 ('987fb8ab-1b83-4666-a126-9393ef04c025','8b3128aa-cf5a-47c7-be68-fee8bcec51f7'),
	 ('e55e49c5-fd22-427c-bc84-57d4bcdd0510','8b3128aa-cf5a-47c7-be68-fee8bcec51f7'),
	 ('19756da7-d88e-46b0-b229-a85cf4727679','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('284f833f-d23f-41ba-b7c8-b59fb9ecb8fa','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('3309b212-36e9-41a6-89b9-1ce5b89740cb','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('352e1bfe-2c1b-4be4-8398-c4441ca0d4b1','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('3614b79a-684b-430a-b464-b5e9bf2c8b11','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('38a5054d-a93c-4784-b659-1e63224466a1','d0414396-2c33-4906-8fbe-7933388f7412');
INSERT INTO clouditera_iam.USER_ROLE_MAPPING (ROLE_ID,USER_ID) VALUES
	 ('4f17ab16-dea9-4d25-9509-c957c22008a7','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('611ec8d9-5fc8-4748-ada3-0a676723cba4','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('785e944b-151a-4fcc-bdac-cca9ae002a6e','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('7f7d2e51-5771-4690-a4a6-3126abd916c1','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('8893d3d1-aff4-4f23-b9d5-a93ce276efbb','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('890ca2d7-3168-4419-b1a9-fe7ea7fbb009','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('8f2c2482-95f9-4805-aaf9-74ec21b5d298','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('b0b78727-c8b6-4489-aa03-62185d362d11','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('b2a33d18-3a0b-499f-bd57-6d210965b78f','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('ba772400-2cd7-4a69-aaa7-29a3094ea9f4','d0414396-2c33-4906-8fbe-7933388f7412');
INSERT INTO clouditera_iam.USER_ROLE_MAPPING (ROLE_ID,USER_ID) VALUES
	 ('c9730148-aec2-4a68-aba6-b42f489e4c5c','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('d5756d92-333c-4b83-9dee-978da2cbd455','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('f1669553-9e19-49e5-afed-85915f4d124e','d0414396-2c33-4906-8fbe-7933388f7412'),
	 ('26d8c85f-6a60-4b25-a424-2af677dd225d','eb5118b0-5db9-497b-b2dc-4a5c21569c12');
INSERT INTO clouditera_iam.WEB_ORIGINS (CLIENT_ID,VALUE) VALUES
	 ('46dcb18d-572f-4131-92f3-c02d12458660','+'),
	 ('b4d6375d-3d4e-4ef7-a693-c5e1aed78c09','+'),
	 ('f4e8abbb-ea16-4f52-a616-3c56d5099016','+');
