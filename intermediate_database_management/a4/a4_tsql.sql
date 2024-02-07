-- A4 Practice

use master;
GO

if exists(select name from master.dbo.sysdatabases where name = N'jep18d')
drop database jep18d;
GO

if not exists (select name from master.dbo.sysdatabases where name = N'jep18d')
create database jep18d;
GO

use jep18d;
GO

---------------------------------------------------------------------------------------

if object_id (N'dbo.petstore', N'U') is not null
drop table dbo.petstore;
GO

create table dbo.petstore
(
    pst_id TINYINT not null identity(1,1),
    pst_name VARCHAR(30) NOT NULL,
    pst_street VARCHAR(30) NOT NULL,
    pst_city VARCHAR(30) NOT NULL,
    pst_state CHAR(2) NOT NULL default 'AZ',
    pst_zip INT NOT NULL check (pst_zip > 0 and pst_zip <= 999999999),
    pst_phone CHAR(10) NOT NULL,
    pst_email VARCHAR(100) NOT NULL,
    pst_url VARCHAR(100) NOT NULL,
    pst_ytd_sales DECIMAL(10,2) NOT NULL check (pst_ytd_sales > 0),
    pst_notes VARCHAR(255) NULL,
    primary key(pst_id)
);

select * from information_schema.tables;

------------------------------------------------------------------------

if object_id (N'dbo.pet', N'U') is not null
drop table dbo.pet;
GO

create table dbo.pet
(
    pet_id SMALLINT not null identity(1,1),
    pst_id TINYINT NOT NULL,
    pet_type VARCHAR(45) NOT NULL,
    pet_sex CHAR(1) NOT NULL CHECK (pet_sex IN ('m', 'f')),
    pet_cost DECIMAL(6,2) NOT NULL check (pet_cost > 0),
    pet_price DECIMAL(6,2) NOT NULL check (pet_price > 0),
    pet_age SMALLINT NOT NULL check (pet_age > 0 and pet_age <= 10500),
    pet_color VARCHAR(30) NOT NULL,
    pet_sale_date DATE,
    pet_vaccine CHAR(1) NOT NULL CHECK (pet_vaccine IN ('y', 'n')),
    pet_neuter CHAR(1) NOT NULL CHECK (pet_neuter IN ('y', 'n')),
    pet_notes VARCHAR(255) NULL,
    primary key (pet_id),
    constraint fs_pet_petstore
        foreign key (pst_id)
        references dbo.petstore (pst_id)
        on delete cascade
        on update cascade
);

select * from information_schema.tables;


insert into dbo.petstore
(pst_name, pst_street, pst_city, pst_state, pst_zip, pst_phone, pst_email, pst_url, pst_ytd_sales)
values
('ABC Pets','123 Main','Tallahassee','FL',32301,8501234567,'abcpets@gmail.com','abcpets.com',10000.00),
('DEF Pets','123 Main','Atlanta','GA',32302,8508912345,'defpets@gmail.com','defpets.com',15000.00),
('GHI Pets','123 Main','Dallas','TX',32303,8506789123,'ghipets@gmail.com','ghipets.com',5000.00),
('JKL Pets','123 Main','Albany','NY',32304,8504567891,'jklpets@gmail.com','jklpets.com',20000.00),
('MNO Pets','123 Main','Sacramento','CA',32305,8502345678,'mnopets@gmail.com','mnopets.com',30000.00);

insert into dbo.pet
(pst_id, pet_type, pet_sex, pet_cost, pet_price, pet_age, pet_color, pet_sale_date, pet_vaccine, pet_neuter)
values
(1, 'dog', 'm', 100.00, 200.00, 7, 'brown', NULL, 'y', 'y'),
(3, 'cat', 'f', 50.00, 125.00, 4, 'orange', NULL, 'y', 'y'),
(5, 'lizard', 'm', 200.00, 500.00, 1, 'green', NULL, 'n', 'n'),
(2, 'parrot', 'f', 50.00, 300.00, 2, 'red', NULL, 'n', 'n'),
(4, 'rabbit', 'm', 25.00, 75.00, 3, 'white', NULL, 'y', 'n');

select * from dbo.petstore;
select * from dbo.pet;