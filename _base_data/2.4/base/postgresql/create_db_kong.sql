-- SELECT pg_terminate_backend(pg_stat_activity.pid) 
-- FROM pg_stat_activity 
-- WHERE datname='kong' AND pid <> pg_backend_pid();
-- DROP DATABASE kong;
create database kong;