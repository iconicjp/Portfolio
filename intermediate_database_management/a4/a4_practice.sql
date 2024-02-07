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

-- N=string may be in unicode
-- U= only look through tables for name
-- use dbo. before all table references
if object_id (N'dbo.slsrep', N'U') is not null
drop table dbo.slsrep;
GO

create table dbo.slsrep
(
    srp_id SMALLINT not null identity(1,1),
    srp_fname VARCHAR(15) NOT NULL,
    srp_lname VARCHAR(30) NOT NULL,
    srp_sex CHAR(1) NOT NULL CHECK (srp_sex IN('m', 'f')),
    srp_age TINYINT NOT NULL check (srp_age >= 18 and srp_age <= 70),
    srp_street VARCHAR(30) NOT NULL,
    srp_city VARCHAR(30) NOT NULL,
    srp_state CHAR(2) NOT NULL default 'FL',
    srp_zip int NOT NULL check (srp_zip > 0 and srp_zip <= 999999999),
    srp_phone bigint NOT NULL,
    srp_email VARCHAR(100) NOT NULL,
    srp_url VARCHAR(100) NOT NULL,
    srp_tot_sales DECIMAL(10,2) NOT NULL check (srp_tot_sales > 0),
    srp_comm DECIMAL(3,2) NOT NULL check (srp_comm >= 0 and srp_comm <= 1.00),
    srp_notes VARCHAR(255) NULL,
    primary key(srp_id)
);

select * from information_schema.tables;

insert into dbo.slsrep
(srp_fname, srp_lname, srp_sex, srp_age, srp_street, srp_city, srp_state, srp_zip, srp_phone, srp_email, srp_url, srp_tot_sales, srp_comm, srp_notes)
values
('John','Doe','m',18,'123 Main','Tallahassee','FL','999999999','8503457621','jdoe@aol.com','jdoe.com',1000.00,.10,'testing');

select * from dbo.slsrep

------------------------------------------------------------------------

if object_id (N'dbo.customer', N'U') is not null
drop table dbo.customer;
GO

create table dbo.customer
(
    cus_id SMALLINT not null identity(1,1),
    srp_id SMALLINT NULL,
    cus_fname VARCHAR(15) NOT NULL,
    cus_lname VARCHAR(30) NOT NULL,
    cus_sex CHAR(1) NOT NULL CHECK (cus_sex IN('m', 'f')),
    cus_age TINYINT NOT NULL check (cus_age >= 18 and cus_age <= 70),
    cus_street VARCHAR(30) NOT NULL,
    cus_city VARCHAR(30) NOT NULL,
    cus_state CHAR(2) NOT NULL default 'FL',
    cus_zip CHAR(9) NOT NULL check (cus_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    cus_phone CHAR(10) NOT NULL check (cus_phone like '[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    cus_email VARCHAR(100) NOT NULL,
    cus_url VARCHAR(100) NOT NULL,
    cus_balance DECIMAL(7,2) NOT NULL check (cus_balance > 0),
    cus_tot_sales DECIMAL(10,2) NOT NULL check (cus_tot_sales > 0),
    cus_notes VARCHAR(255) NULL,
    primary key (cus_id),
    constraint fs_cus_slsrep
        foreign key (srp_id)
        references dbo.slsrep (srp_id)
        on delete cascade
        on update cascade
);

select * from information_schema.tables;

-- get table info
exec sp_help 'dbo.customer';