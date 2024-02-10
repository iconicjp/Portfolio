drop database if exists  jep18d;
create database if not exists jep18d;
use jep18d;
-- -----------------------------------------------------------------------------------------
-- company Table
-- -----------------------------------------------------------------------------------------
drop table if exists company;
create table if not exists company
(
cmp_id int unsigned not null auto_increment,
cmp_type enum('c-corp', 's-corp', 'non-profit-corp', 'llc', 'partnership'),
cmp_street varchar(30) not null,
cmp_city varchar(30) not null,
cmp_state char(2) not null,
cmp_zip char(9) not null,
cmp_phone bigint unsigned not null,
cmp_ytd_sales decimal(10,2) not null comment '12,345,678.90',
cmp_email varchar(100) null,
cmp_url varchar(100) null,
cmp_notes varchar(255) null,
primary key (cmp_id)
)
engine = InnoDB character set utf8mb4 collate utf8mb4_0900_ai_ci;
show warnings;

insert into company
values
(null,'c-corp', '507 20th Ave.', 'Seattle', 'WA', '081226749', '2065559857', '12345678.00', null, 'http://nytimes.com', 'company note1'),
(null,'s-corp', '908 W. Capital Way', 'Tacoma', 'WA', '004011298', '2065559482', '34567890.12', null, 'https://guardian.co.uk', 'company note2'),
(null,'non-profit-corp', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '000337845', '2065553412', '56789012.34', null, 'http://twitter.com', 'company note3'),
(null,'llc', '4110 Old Redmond Rd.', 'redmond', 'WA', '000029021', '2065558122', '78901234.56', null, 'http://walmart.com', 'company note4'),
(null,'partnership', '4726 - 11th Ave.', 'Seattle', 'WA', '001051082', '2065551189', '90123456.78', null, 'http://pinterest.com', 'company note5');

show warnings;

-- -----------------------------------------------------------------------------------------
-- customer Table
-- -----------------------------------------------------------------------------------------
drop table if exists customer;
create table if not exists customer
(
cus_id int unsigned not null auto_increment,
cmp_id int unsigned not null,
cus_ssn binary(64) not null,
cus_salt binary(64) not null comment '*ONLY* demo purpose- *DO NOT* use salt in name!',
cus_type enum('loyal', 'discount','impulse', 'need-based', 'wandering'),
cus_first varchar(15) not null,
cus_last varchar(30) not null,
cus_street varchar(30) null,
cus_city varchar(30) null,
cus_state char(2) null,
cus_zip char(9) null,
cus_phone bigint unsigned not null,
cus_email varchar(100) null,
cus_balance decimal (7,2) null comment '12,345.67',
cus_tot_sales decimal (7,2) null,
cus_notes varchar(255) null,
primary key (cus_id),

unique index uk_cus_ssn (cus_ssn asc),
index ndx_cmp_id (cmp_id asc),

constraint fk_customer_company
foreign key (cmp_id)
references company (cmp_id)
on update cascade
on delete restrict
)

engine = InnoDB character set utf8mb4 collate utf8mb4_0900_ai_ci;
show warnings;

set @salt = random_bytes(64);

insert into customer
values
(null, 2, unhex(sha2(concat(@salt, 000456789),512)), @salt, 'discount', 'wilbur', 'denaway', '23 Billings Gate', 'El Paso', 'TX', '085703412', '2145559857', 'test1@mymail.com', '8391.87', '37642.00', 'customer notes1'),
(null, 3, unhex(sha2(concat(@salt, 001456789),512)), @salt, 'loyal', 'bradford', 'casis', '891 Drift Dr.', 'Stanton', 'TX', '005819045', '2145559482', 'test2@mymail.com', '657.57', '87341.00', 'customer notes2'),
(null, 5, unhex(sha2(concat(@salt, 002456789),512)), @salt, 'impulse', 'valerie', 'lieblong', '421 Calamari Vista', 'Odessa', 'TX', '00621134', '2145553412', 'test3@mymail.com', '8730.23', '92678.00', 'customer notes3'),
(null, 4, unhex(sha2(concat(@salt, 003456789),512)), @salt, 'need-based', 'kathy', 'jeffries', '915 Drive Past', 'Penwell', 'TX', '009135674', '2145558122', 'tes4@mymail.com', '2651.19', '78345.00', 'customer notes4'),
(null, 1, unhex(sha2(concat(@salt, 004456789),512)), @salt, 'wandering', 'steve', 'rogers', '329 Volume Ave.', 'Tarzan', 'TX', '000054426', '2145551189', 'test5@mymail.com', '782.73', '23471.00', 'customer notes5');

show warnings;

select * from company;
select * from customer;
-- -----------------------------------------------------------------------------------------
-- DB Prep
-- -----------------------------------------------------------------------------------------
describe mysql.user;
describe mysql.db;
describe mysql.tables_priv;
describe mysql.columns_priv;

select * from mysql.user;
select * from mysql.db;
select * from mysql.tables_priv;
select * from mysql.columns_priv;

-- -----------------------------------------------------------------------------------------
-- Creating users
-- -----------------------------------------------------------------------------------------
drop user if exists user1;
create user if not exists 'user1'@'localhost' identified by 'password1';
drop user if exists user2;
create user if not exists 'user2'@'localhost' identified by 'password2';
-- -----------------------------------------------------------------------------------------
-- 1. Limit user1 to select, update, and delete privileges on company and customer tables
-- -----------------------------------------------------------------------------------------
grant select, update, delete 
on jep18d.company
to 'user1'@'localhost';

grant select, update, delete 
on jep18d.customer
to 'user1'@'localhost';

-- -----------------------------------------------------------------------------------------
-- 2. Limit user2 to select, and insert privileges on customer table
-- -----------------------------------------------------------------------------------------

grant select, insert
on jep18d.customer
to 'user2'@'localhost';

flush privileges;

-- -----------------------------------------------------------------------------------------
/*3. Verify database/table permissions, show grants:
    a. yours/admin
    b. user1 (logged in as user1)
    c. user2 (logged in as admin)*/
-- -----------------------------------------------------------------------------------------
show grants;
show grants for user2;
-- -----------------------------------------------------------------------------------------
-- 4. Display current user2 (logged in as user2) and MySQL version
-- -----------------------------------------------------------------------------------------
select user(), version();
-- -----------------------------------------------------------------------------------------
-- 5. List tables (as admin)
-- -----------------------------------------------------------------------------------------
use jep18d;
show tables; 
-- -----------------------------------------------------------------------------------------
-- 6. Display structures for both tables (as admin)
-- -----------------------------------------------------------------------------------------
describe company; 
describe customer;
-- -----------------------------------------------------------------------------------------
/*7. Display data for both tables:
    a. company (as user2)
    b. customer (as user1)*/
-- -----------------------------------------------------------------------------------------
select * from company;
select * from customer;
-- -----------------------------------------------------------------------------------------
/*8. Log in as user1:
    a. show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the company table
    b. show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the customer table*/
-- -----------------------------------------------------------------------------------------
insert into company
values
(null,'c-corp', '507 20th Ave.', 'Seattle', 'WA', '081226749', '2065559857', '12345678.00', null, 'http://nytimes.com', 'company note6');

insert into customer
values
(null, 2, unhex(sha2(concat(@salt, 001456789),512)), @salt, 'discount', 'wilbur', 'denaway', '23 Billings Gate', 'El Paso', 'TX', '085703412', '2145559857', 'test6@mymail.com', '8391.87', '37642.00', 'customer notes6');
-- -----------------------------------------------------------------------------------------
/*9. Log in as user2:
    a. show the SQL statement, and corresponding query result set that prevented user2 from “seeing” company table:
    b. same as above, though, prevented from being able to delete from the customer table:*/
-- -----------------------------------------------------------------------------------------
select * from company;
delete from customer;
-- -----------------------------------------------------------------------------------------
-- 10. Log in as admin: remove both tables (structure and data), and show commands:
-- -----------------------------------------------------------------------------------------
drop table customer;
drop table company;







