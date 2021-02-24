CREATE DATABASE soil_2020;
USE soil_2020;
CREATE USER 'jza18'@'localhost' IDENTIFIED BY 'sfusoil2021';
grant select, insert, update, delete, create, execute, show view on soil_2020.* to'jza18'@'localhost';
alter user 'jza18'@'localhost' identified with mysql_native_password by'sfusoil2021';


