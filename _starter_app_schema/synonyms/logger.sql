--liquibase formatted sql
--changeset wsowa:app_schemaLoggerSynonyms
create or replace synonym sc_core.logger for logger_user.logger;
create or replace synonym sc_core.logger_logs for logger_user.logger_logs;
create or replace synonym sc_core.logger_logs_apex_items for logger_user.logger_logs_apex_items;
create or replace synonym sc_core.logger_prefs for logger_user.logger_prefs;
create or replace synonym sc_core.logger_prefs_by_client_id for logger_user.logger_prefs_by_client_id;
create or replace synonym sc_core.logger_logs_5_min for logger_user.logger_logs_5_min;
create or replace synonym sc_core.logger_logs_60_min for logger_user.logger_logs_60_min;
create or replace synonym sc_core.logger_logs_terse for logger_user.logger_logs_terse;

-- replace app_schema with your schema_name. See also the changeset header.