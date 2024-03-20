CREATE USER "LOGGER_USER" IDENTIFIED BY "Qwerty!23456";
ALTER USER "LOGGER_USER" QUOTA UNLIMITED ON "DATA";
grant connect,create view, create job, create table, create sequence, create trigger, create procedure, create any context to LOGGER_USER;