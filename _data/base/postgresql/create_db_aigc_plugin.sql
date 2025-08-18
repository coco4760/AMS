create database dify_plugin;

\c dify_plugin;

-- Enable uuid-ossp extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- DROP FUNCTION public.uuid_generate_v1();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_generate_v1') THEN
--         CREATE FUNCTION public.uuid_generate_v1()
--          RETURNS uuid
--          LANGUAGE c
--          PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_generate_v1$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_generate_v1mc();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_generate_v1mc') THEN
--         CREATE FUNCTION public.uuid_generate_v1mc()
--          RETURNS uuid
--          LANGUAGE c
--          PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_generate_v1mc$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_generate_v3(uuid, text);

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_generate_v3') THEN
--         CREATE FUNCTION public.uuid_generate_v3(namespace uuid, name text)
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_generate_v3$function$;
--     END IF;
-- END $$;

-- DROP FUNCTION public.uuid_generate_v4();
CREATE OR REPLACE FUNCTION public.uuid_generate_v4()
    RETURNS uuid
    LANGUAGE c
    PARALLEL SAFE STRICT
AS '$libdir/uuid-ossp', $function$uuid_generate_v4$function$;

-- -- DROP FUNCTION public.uuid_generate_v5(uuid, text);

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_generate_v5') THEN
--         CREATE FUNCTION public.uuid_generate_v5(namespace uuid, name text)
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_generate_v5$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_nil();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_nil') THEN
--         CREATE FUNCTION public.uuid_nil()
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_nil$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_ns_dns();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_ns_dns') THEN
--         CREATE FUNCTION public.uuid_ns_dns()
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_ns_dns$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_ns_oid();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_ns_oid') THEN
--         CREATE FUNCTION public.uuid_ns_oid()
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_ns_oid$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_ns_url();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_ns_url') THEN
--         CREATE FUNCTION public.uuid_ns_url()
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_ns_url$function$;
--     END IF;
-- END $$;

-- -- DROP FUNCTION public.uuid_ns_x500();

-- DO $$ 
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'uuid_ns_x500') THEN
--         CREATE FUNCTION public.uuid_ns_x500()
--          RETURNS uuid
--          LANGUAGE c
--          IMMUTABLE PARALLEL SAFE STRICT
--         AS '$libdir/uuid-ossp', $function$uuid_ns_x500$function$;
--     END IF;
-- END $$;
-- public.agent_strategy_installations definition

-- Drop table

-- DROP TABLE public.agent_strategy_installations;

CREATE TABLE public.agent_strategy_installations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, tenant_id uuid NOT NULL, provider varchar(127) NOT NULL, plugin_unique_identifier varchar(255) NULL, plugin_id varchar(255) NULL, CONSTRAINT agent_strategy_installations_pkey PRIMARY KEY (id));
CREATE INDEX idx_agent_strategy_installations_plugin_id ON public.agent_strategy_installations USING btree (plugin_id);
CREATE INDEX idx_agent_strategy_installations_plugin_unique_identifier ON public.agent_strategy_installations USING btree (plugin_unique_identifier);
CREATE INDEX idx_agent_strategy_installations_provider ON public.agent_strategy_installations USING btree (provider);
CREATE INDEX idx_agent_strategy_installations_tenant_id ON public.agent_strategy_installations USING btree (tenant_id);


-- public.ai_model_installations definition

-- Drop table

-- DROP TABLE public.ai_model_installations;

CREATE TABLE public.ai_model_installations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, provider varchar(127) NOT NULL, tenant_id uuid NOT NULL, plugin_unique_identifier varchar(255) NULL, plugin_id varchar(255) NULL, CONSTRAINT ai_model_installations_pkey PRIMARY KEY (id));
CREATE INDEX idx_ai_model_installations_plugin_id ON public.ai_model_installations USING btree (plugin_id);
CREATE INDEX idx_ai_model_installations_plugin_unique_identifier ON public.ai_model_installations USING btree (plugin_unique_identifier);
CREATE INDEX idx_ai_model_installations_provider ON public.ai_model_installations USING btree (provider);
CREATE INDEX idx_ai_model_installations_tenant_id ON public.ai_model_installations USING btree (tenant_id);


-- public.endpoints definition

-- Drop table

-- DROP TABLE public.endpoints;

CREATE TABLE public.endpoints ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, "name" varchar(127) DEFAULT 'default'::character varying NULL, hook_id varchar(127) NULL, tenant_id varchar(64) NULL, user_id varchar(64) NULL, plugin_id varchar(64) NULL, expired_at timestamptz NULL, enabled bool NULL, settings text NULL, CONSTRAINT endpoints_pkey PRIMARY KEY (id), CONSTRAINT uni_endpoints_hook_id UNIQUE (hook_id));
CREATE INDEX idx_endpoints_plugin_id ON public.endpoints USING btree (plugin_id);
CREATE INDEX idx_endpoints_tenant_id ON public.endpoints USING btree (tenant_id);
CREATE INDEX idx_endpoints_user_id ON public.endpoints USING btree (user_id);


-- public.install_tasks definition

-- Drop table

-- DROP TABLE public.install_tasks;

CREATE TABLE public.install_tasks ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, status text NOT NULL, tenant_id uuid NOT NULL, total_plugins int8 NOT NULL, completed_plugins int8 NOT NULL, plugins text NULL, CONSTRAINT install_tasks_pkey PRIMARY KEY (id));


-- public.plugin_declarations definition

-- Drop table

-- DROP TABLE public.plugin_declarations;

CREATE TABLE public.plugin_declarations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, plugin_unique_identifier varchar(255) NULL, plugin_id varchar(255) NULL, declaration text NULL, CONSTRAINT plugin_declarations_pkey PRIMARY KEY (id), CONSTRAINT uni_plugin_declarations_plugin_unique_identifier UNIQUE (plugin_unique_identifier));
CREATE INDEX idx_plugin_declarations_plugin_id ON public.plugin_declarations USING btree (plugin_id);


-- public.plugin_installations definition

-- Drop table

-- DROP TABLE public.plugin_installations;

CREATE TABLE public.plugin_installations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, tenant_id uuid NULL, plugin_id varchar(255) NULL, plugin_unique_identifier varchar(255) NULL, runtime_type varchar(127) NULL, endpoints_setups int8 NULL, endpoints_active int8 NULL, "source" varchar(63) NULL, meta text NULL, CONSTRAINT plugin_installations_pkey PRIMARY KEY (id));
CREATE INDEX idx_plugin_installations_plugin_id ON public.plugin_installations USING btree (plugin_id);
CREATE INDEX idx_plugin_installations_plugin_unique_identifier ON public.plugin_installations USING btree (plugin_unique_identifier);
CREATE INDEX idx_plugin_installations_tenant_id ON public.plugin_installations USING btree (tenant_id);


-- public.plugins definition

-- Drop table

-- DROP TABLE public.plugins;

CREATE TABLE public.plugins ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, plugin_unique_identifier varchar(255) NULL, plugin_id varchar(255) NULL, refers int8 DEFAULT 0 NULL, install_type varchar(127) NULL, manifest_type varchar(127) NULL, remote_declaration text NULL, CONSTRAINT plugins_pkey PRIMARY KEY (id));
CREATE INDEX idx_plugins_install_type ON public.plugins USING btree (install_type);
CREATE INDEX idx_plugins_plugin_id ON public.plugins USING btree (plugin_id);
CREATE INDEX idx_plugins_plugin_unique_identifier ON public.plugins USING btree (plugin_unique_identifier);


-- public.serverless_runtimes definition

-- Drop table

-- DROP TABLE public.serverless_runtimes;

CREATE TABLE public.serverless_runtimes ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, plugin_unique_identifier varchar(255) NULL, function_url varchar(255) NULL, function_name varchar(127) NULL, "type" varchar(127) NULL, checksum varchar(127) NULL, CONSTRAINT serverless_runtimes_pkey PRIMARY KEY (id), CONSTRAINT uni_serverless_runtimes_plugin_unique_identifier UNIQUE (plugin_unique_identifier));
CREATE INDEX idx_serverless_runtimes_checksum ON public.serverless_runtimes USING btree (checksum);


-- public.tenant_storages definition

-- Drop table

-- DROP TABLE public.tenant_storages;

CREATE TABLE public.tenant_storages ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, tenant_id varchar(255) NOT NULL, plugin_id varchar(255) NOT NULL, "size" int8 NOT NULL, CONSTRAINT tenant_storages_pkey PRIMARY KEY (id));
CREATE INDEX idx_tenant_storages_plugin_id ON public.tenant_storages USING btree (plugin_id);
CREATE INDEX idx_tenant_storages_tenant_id ON public.tenant_storages USING btree (tenant_id);


-- public.tool_installations definition

-- Drop table

-- DROP TABLE public.tool_installations;

CREATE TABLE public.tool_installations ( id uuid DEFAULT uuid_generate_v4() NOT NULL, created_at timestamptz NULL, updated_at timestamptz NULL, tenant_id uuid NOT NULL, provider varchar(127) NOT NULL, plugin_unique_identifier varchar(255) NULL, plugin_id varchar(255) NULL, CONSTRAINT tool_installations_pkey PRIMARY KEY (id));
CREATE INDEX idx_tool_installations_plugin_id ON public.tool_installations USING btree (plugin_id);
CREATE INDEX idx_tool_installations_plugin_unique_identifier ON public.tool_installations USING btree (plugin_unique_identifier);
CREATE INDEX idx_tool_installations_provider ON public.tool_installations USING btree (provider);
CREATE INDEX idx_tool_installations_tenant_id ON public.tool_installations USING btree (tenant_id);



