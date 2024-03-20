--liquibase formatted sql
--changeset wsowa:app
CREATE USER "APP_SCHEMA" IDENTIFIED BY "Qwerty!23456";

--changeset wsowa:createUSER2
ALTER USER "APP_SCHEMA" QUOTA UNLIMITED ON "DATA";

-- replace app_schema with your schema_name