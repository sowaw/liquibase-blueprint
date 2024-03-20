--liquibase formatted sql
--changeset wsowa:grantLoggerAPP_SCHEMA
grant execute on logger_user.logger to app_schema;
grant select, delete on logger_user.logger_logs to app_schema;
grant select on logger_user.logger_logs_apex_items to app_schema;
grant select, update on logger_user.logger_prefs to app_schema;
grant select on logger_user.logger_prefs_by_client_id to app_schema;
grant select on logger_user.logger_logs_5_min to app_schema;
grant select on logger_user.logger_logs_60_min to app_schema;
grant select on logger_user.logger_logs_terse to app_schema;

-- replace app_schema with your schema_name