--liquibase formatted sql
--changeset wsowa:basicGrants1
grant connect to app_schema;

-- replace app_schema with your schema_name