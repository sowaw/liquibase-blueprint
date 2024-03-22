--liquibase formatted sql

--changeset wsowa:1
create table user123.emp(
  id number primary key,
  name varchar2(255)
);