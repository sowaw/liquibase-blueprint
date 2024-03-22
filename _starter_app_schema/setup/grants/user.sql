--liquibase formatted sql
--changeset wsowa:basicGrantsAPP_SCHEMA
grant connect to app_schema;

-- replace app_schema with your schema_name. See also the changeset header.