Set ANSI_WARNINGS ON;
go

use master;
go

if exists(select name from master.dbo.sysdatabases where name = N'jep18d')
drop database jep18d;
go

if not exists(select name from master.dbo.sysdatabases where name = N'jep18d')
create database jep18d;
go

use jep18d;
go

-- ---------------------------------------------------------------------------------------
-- Create Person
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.person', N'U') is not null
drop table dbo.person;
go

create table dbo.person
(
    per_id smallint not null identity(1,1),
    per_ssn binary(64) null,
    per_salt binary(64) null,
    per_fname varchar(15) not null,
    per_lname varchar(30) not null,
    per_gender char(1) not null check (per_gender in('m','f')),
    per_dob date not null,
    per_street varchar(30) not null,
    per_city varchar(30) not null,
    per_state char(2) not null default 'FL',
    per_zip int not null check (per_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    per_email varchar(100) null,
    per_type char(1) not null check (per_type in('c','s')),
    per_notes varchar(45) null,
    primary key (per_id),

    constraint uk_per_ssn unique nonclustered (per_ssn asc)
);
go


-- ---------------------------------------------------------------------------------------
-- Create Phone
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.phone', N'U') is not null
drop table dbo.phone;
go

create table dbo.phone
(
    phn_id smallint not null identity(1,1),
    per_id smallint not null,
    phn_num bigint not null check (phn_num like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phn_type char(1) not null check (phn_type in ('h','c','w','f')),
    phn_notes varchar(255) null,
    primary key (phn_id),

    constraint fk_phone_person
    foreign key (per_id)
    references dbo.person (per_id)
    on delete cascade
    on update cascade
);

-- ---------------------------------------------------------------------------------------
-- Create Customer
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.customer', N'U') is not null
drop table dbo.customer;
go

create table dbo.customer
(
    per_id smallint not null,
    cus_balance decimal(7,2) not null check (cus_balance >= 0),
    cus_total_sales decimal(7,2) not null check (cus_total_sales >= 0),
    cus_notes varchar(45) null,
    primary key (per_id),

    constraint fk_customer_person
    foreign key (per_id)
    references dbo.person (per_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create slsrep
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.slsrep', N'U') is not null
drop table dbo.slsrep;
go

create table dbo.slsrep
(
    per_id smallint not null,
    srp_yr_sales_goal decimal(8,2) not null check (srp_yr_sales_goal >= 0),
    srp_ytd_sales decimal(8,2) not null check (srp_ytd_sales >= 0),
    srp_ytd_comm decimal(7,2) not null check (srp_ytd_comm >= 0),
    srp_notes varchar(45) null,
    primary key (per_id),

    constraint fk_slsrep_person
    foreign key (per_id)
    references dbo.person (per_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create srp_hist
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.srp_hist', N'U') is not null
drop table dbo.srp_hist;
go

create table dbo.srp_hist
(
    sht_id smallint not null identity(1,1),
    per_id smallint not null,
    sht_type char(1) not null check(sht_type in('i','u','d')),
    sht_modified datetime not null,
	sht_modifier varchar(45) not null default system_user,
    sht_date date not null default getDate(),
    sht_yr_sales_goal decimal(8,2) not null check (sht_yr_sales_goal >= 0),
    sht_yr_total_sales decimal(8,2) not null check (sht_yr_total_sales >= 0),
    sht_yr_total_comm decimal(7,2) not null check (sht_yr_total_comm >= 0),
    sht_notes varchar(45) null,
    primary key (sht_id),

    constraint fk_srp_hist_slsrep
    foreign key (per_id)
    references dbo.slsrep (per_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create contact
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.contact', N'U') is not null
drop table dbo.contact;
go

create table dbo.contact
(
    cnt_id int not null identity(1,1),
    per_cid smallint not null,
    per_sid smallint not null,
    cnt_date datetime not null,
    cnt_notes varchar(255) null,
    primary key (cnt_id),

    constraint fk_contact_customer
    foreign key (per_cid)
    references dbo.customer (per_id)
    on delete cascade
    on update cascade,

    constraint fk_contact_slsrep
    foreign key (per_sid)
    references dbo.slsrep (per_id)
    on delete no action
    on update no action
);
-- ---------------------------------------------------------------------------------------
-- Create order
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.[order]', N'U') is not null
drop table dbo.[order];
go

create table dbo.[order]
(
    ord_id int not null identity(1,1),
    cnt_id int not null,
    ord_placed_date datetime not null,
    ord_filled_date datetime null,
    ord_notes varchar(255) null,
    primary key (ord_id),

    constraint fk_order_contact
    foreign key (cnt_id)
    references dbo.contact (cnt_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create store
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.store', N'U') is not null
drop table dbo.store;
go

create table dbo.store
(
    str_id smallint not null identity(1,1),
    str_name varchar(45) not null,
    str_street varchar(30) not null,
    str_city varchar(30) not null,
    str_state char(2) not null default 'FL',
    str_zip int not null check (str_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_phone bigint not null check (str_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_email varchar(100) not null,
    str_url varchar(100) not null,
    str_notes varchar(255),
    primary key (str_id)
);
-- ---------------------------------------------------------------------------------------
-- Create invoice
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.invoice', N'U') is not null
drop table dbo.invoice;
go

create table dbo.invoice
(
    inv_id int not null identity(1,1),
    ord_id int not null,
    str_id smallint not null,
    inv_date datetime not null,
    inv_total decimal(8,2) not null check (inv_total >= 0),
    inv_paid bit not null,
    inv_notes varchar(255) null,
    primary key (inv_id),

    constraint uk_ord_id unique nonclustered (ord_id asc),

    constraint fk_invoice_order
    foreign key (ord_id)
    references dbo.[order] (ord_id)
    on delete cascade
    on update cascade,

    constraint fk_invoice_store
    foreign key (str_id)
    references dbo.store (str_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create payment
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.payment', N'U') is not null
drop table dbo.payment;
go

create table dbo.payment
(
    pay_id int not null identity(1,1),
    inv_id int not null,
    pay_date datetime not null,
    pay_amt decimal(7,2) not null check (pay_amt >= 0),
    pay_notes varchar(255) null,
    primary key (pay_id),

    constraint fk_payment_invoice
    foreign key (inv_id)
    references dbo.invoice (inv_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create vendor
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.vendor', N'U') is not null
drop table dbo.vendor;
go

create table dbo.vendor
(
    ven_id smallint not null identity(1,1),
    ven_name varchar(45) not null,
    ven_street varchar(30) not null,
    ven_city varchar(30) not null,
    ven_state char(2) not null default 'FL',
    ven_zip int not null check (ven_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ven_phone bigint not null check (ven_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    ven_email varchar(100) null,
    ven_url varchar(100) null,
    ven_notes varchar(255) null,
    primary key(ven_id)
);
-- ---------------------------------------------------------------------------------------
-- Create product
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.product', N'U') is not null
drop table dbo.product;
go

create table dbo.product
(
    pro_id smallint not null identity(1,1),
    ven_id smallint not null,
    pro_name varchar(30) not null,
    pro_descript varchar(45) null,
    pro_weight float not null check(pro_weight >= 0),
    pro_qoh smallint not null check(pro_qoh >= 0),
    pro_cost decimal(7,2) not null check(pro_cost >= 0),
    pro_price decimal(7,2) not null check(pro_price >= 0),
    pro_discount decimal(3,0) null,
    pro_notes varchar(255) null,
    primary key (pro_id),

    constraint fk_product_vendor
    foreign key (ven_id)
    references dbo.vendor (ven_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create product_hist
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.product_hist', N'U') is not null
drop table dbo.product_hist;
go

create table dbo.product_hist
(
    pht_id int not null identity(1,1),
    pro_id smallint not null,
    pht_date datetime not null,
    pht_cost decimal(7,2) not null check(pht_cost >= 0),
    pht_price decimal(7,2) not null check (pht_price >= 0),
    pht_discount decimal(3,0) null,
    pht_notes varchar(255) null,
    primary key(pht_id),

    constraint fk_product_hist_product
    foreign key (pro_id)
    references dbo.product(pro_id)
    on delete cascade
    on update cascade
);
-- ---------------------------------------------------------------------------------------
-- Create order_line
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.order_line', N'U') is not null
drop table dbo.order_line;
go

create table dbo.order_line
(
    oln_id int not null identity(1,1),
    ord_id int not null,
    pro_id smallint not null,
    oln_qty smallint not null check(oln_qty >= 0),
    oln_price decimal(7,2) not null check (oln_price >= 0),
    oln_notes varchar(255) null,
    primary key (oln_id),

    constraint fk_order_line_order
    foreign key (ord_id)
    references dbo.[order](ord_id)
    on delete cascade
    on update cascade,

    constraint fk_order_line_product
    foreign key (pro_id)
    references dbo.product(pro_id)
    on delete cascade
    on update cascade
);

select * from information_schema.tables;

-- ---------------------------------------------------------------------------------------
-- Person Values
-- ---------------------------------------------------------------------------------------
insert into dbo.person
(per_ssn, per_salt, per_fname, per_lname, per_gender, per_dob, per_street, per_city, per_state, per_zip, per_email, per_type, per_notes)
values
(1, NULL, 'Steve', 'Rogers', 'm', '1923-10-03', '437 Southern Drive', 'Rochester', 'NY', 324402222, 'srogers@comcast.net', 's', NULL),
(2, NULL, 'Bruce', 'Wayne', 'm', '1968-03-20', '1007 Mountain Drive', 'Gotham', 'NY', 983208440, 'bwayne@knology.net', 's', NULL),
(3, NULL, 'Peter', 'Parker', 'm', '1988-09-12', '20 Ingram Street', 'New York', 'NY', 102862341, 'pparker@msn.com', 's', NULL),
(4, NULL, 'Jane', 'Thompson', 'f', '1978-05-08', '13563 Ocean View Drive', 'Seattle', 'WA', 132084409, 'jthompson@gmail.com', 's', NULL),
(5, NULL, 'Debra', 'Steele', 'f', '1994-07-19', '543 Oak Ln', 'Milwaukee', 'WI', 286234178, 'dsteele@verizon.net', 's', NULL),
(6, NULL, 'Tony', 'Smith', 'm', '1972-05-04', '332 Palm Avenue', 'Malibu', 'CA', 902638332, 'tstark@yahoo.com', 'c', NULL),
(7, NULL, 'Hank', 'Pymi', 'm', '1980-08-28', '2355 Brown Street', 'Cleveland', 'OH', 822348890, 'hpym@aol.com', 'c', NULL),
(8, NULL, 'Bob', 'Best', 'm', '1992-02-10', '4902 Avendale Avenue', 'Scottsdale', 'AZ', 872638332, 'bbest@yahoo.com', 'c', NULL),
(9, NULL, 'Sandra', 'Smith', 'f', '1990-01-26', '87912 Lawrence Ave', 'Atlanta', 'GA', 672348890, 'sdole@gmail.com', 'c', NULL),
(10, NULL, 'Ben', 'Avery', 'm', '1983-12-24', '6432 Thunderbird Ln', 'Sioux Falls', 'SD', 562638332, 'bavery@hotmail.com', 'c', NULL),
(11, NULL, 'Arthur', 'Curry', 'm', '1975-12-15', '3304 Euclid Avenue', 'Miami', 'FL', 342219932, 'acurry@gmail.com', 'c', NULL),
(12, NULL, 'Diana', 'Price', 'f', '1980-08-22', '944 Green Street', 'Las Vegas', 'NV', 332048823, 'dprice@symaptico.com', 'c', NULL),
(13, NULL, 'Adam', 'Smith', 'm', '1995-01-31', '98435 Valencia Dr.', 'Gulf Shores', 'AL', 870219932, 'ajurris@gmx.com', 'c', NULL),
(14, NULL, 'Judy', 'Sleen', 'f', '1970-03-22', '56343 Rover Ct.', 'Billings', 'MT', 672048823, 'jsleen@symaptico.com', 'c', NULL),
(15, NULL, 'Bill', 'Neiderheim', 'm', '1982-06-13', '43567 Netherland Blvd', 'South Bend', 'IN', 320219932, 'bneiderheim@comcast.net', 'c', NULL);
go

-- ---------------------------------------------------------------------------------------
-- slsrep Values
-- ---------------------------------------------------------------------------------------
insert into dbo.slsrep
(per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
values
(1, 100000, 60000, 1800, NULL),
(2, 80000, 35000, 3500, NULL),
(3, 150000, 84000, 9650, 'Great salesperson!'),
(4, 125000, 87000, 15300, NULL),
(5, 98000, 43000, 8750, NULL);
go

-- ---------------------------------------------------------------------------------------
-- Customer Values
-- ---------------------------------------------------------------------------------------
insert into dbo.customer
(per_id, cus_balance, cus_total_sales, cus_notes)
values
(6, 120, 14789, NULL),
(7, 98.46, 234.92, NULL),
(8, 0, 4578, 'Customer always pays on time.'),
(9, 981.73, 1672.38, 'High balance.'),
(10, 541.23, 782.57, NULL),
(11, 251.02, 13782.96, 'Good customer.'),
(12, 582.67, 963.12, 'Previously paid in full.'),
(13, 121.67, 1057.45, 'Recent customer.'),
(14, 765.43, 6789.42, 'Buys bulk quantities.'),
(15, 304.39, 456.81, 'Has not purchased recently.');
go

-- ---------------------------------------------------------------------------------------
-- contact Values
-- ---------------------------------------------------------------------------------------
insert into dbo.contact
(per_sid, per_cid, cnt_date, cnt_notes)
values
(1, 6, '1999-01-01', NULL),
(2, 6, '2001-09-29', NULL),
(3, 7, '2002-08-15', NULL),
(2, 7, '2002-09-01', NULL),
(4, 7, '2004-01-05', NULL),
(5, 8, '2004-02-28', NULL),
(4, 8, '2004-03-03', NULL),
(1, 9, '2004-04-07', NULL),
(5, 9, '2004-07-29', NULL),
(3, 11, '2005-05-02', NULL),
(4, 13, '2005-06-14', NULL),
(2, 15, '2005-07-02', NULL);
go

-- ---------------------------------------------------------------------------------------
-- order Values
-- ---------------------------------------------------------------------------------------
insert into dbo.[order]
(cnt_id, ord_placed_date, ord_filled_date, ord_notes)
values
(1, '2010-11-23', '2010-12-24', NULL),
(2, '2005-03-19', '2005-07-28', NULL),
(3, '2011-07-01', '2011-07-06', NULL),
(4, '2009-12-24', '2010-01-05', NULL),
(5, '2008-09-21', '2008-11-26', NULL),
(6, '2009-04-17', '2009-04-30', NULL),
(7, '2010-05-31', '2010-06-07', NULL),
(8, '2007-09-02', '2007-09-16', NULL),
(9,'2011-12-08', '2011-12-23', NULL),
(10, '2012-02-29', '2012-05-02', NULL);
go

-- ---------------------------------------------------------------------------------------
-- store Values
-- ---------------------------------------------------------------------------------------
insert into dbo.store
(str_name, str_street, str_city, str_state, str_zip, str_phone, str_email, str_url, str_notes)
values
('Walgreens', '14567 Walnut Ln', 'Aspen', 'IL', '475315690', '3127658127', 'info@walgreens.com', 'http://www.walgreens.com', NULL),
('CVS', '572 Casper Rd', 'Chicago', 'IL', '505231519', '3128926534', 'help@cvs.com', 'http://www.cvs.com', 'Rumor of merger.'),
('Lowes', '81309 Catapult Ave', 'Clover', 'WA', '802345671', '9017653421', 'sales@lowes.com', 'http://www.lowes.com', NULL),
('Walmart', '14567 Walnut Ln', 'St. Louis', 'FL', '387563628', '8722718923', 'info@walmart.com', 'http://www.walmart.com', NULL),
('Dollar General', '47583 Davison Rd', 'Detroit', 'MI', '482983456', '3137583492', 'ask@dollargeneral.com', 'http://www.dollargeneral.com', 'recently sold property');
go

-- ---------------------------------------------------------------------------------------
-- invoice Values
-- ---------------------------------------------------------------------------------------
insert into dbo.invoice
(ord_id, str_id, inv_date, inv_total, inv_paid, inv_notes)
values
(5, 1, '2001-05-03', 58.32, 0, NULL),
(4, 1, '2006-11-11', 100.59, 0, NULL),
(1, 1, '2010-09-16', 57.34, 0, NULL),
(3, 2, '2011-01-10', 99.32, 1, NULL),
(2, 3, '2008-06-24', 1109.67, 1, NULL),
(6, 4, '2009-04-20', 239.83, 0, NULL),
(7, 5, '2010-06-05', 537.29, 0, NULL),
(8, 2, '2007-09-09', 644.21, 1, NULL),
(9, 3, '2011-12-17', 934.12, 1, NULL),
(10, 4, '2012-03-18', 27.45, 0, NULL);
go

-- ---------------------------------------------------------------------------------------
-- vendor Values
-- ---------------------------------------------------------------------------------------
insert into dbo.vendor
(ven_name, ven_street, ven_city, ven_state, ven_zip, ven_phone, ven_email, ven_url, ven_notes)
values
('Sysco', '531 Dolphin Run', 'Orlano', 'FL', '344761234', '7641238543', 'sales@sysco.com', 'http://www.sysco.com', NULL),
('General Electric', '100 Happy Trails Dr.', 'Boston', 'MA', '123458743', '2134569641', 'support@ge.com', 'http://www.ge.com', 'Very good turnaround'),
('Cisco', '300 Cisco Dr.', 'Stanford', 'OR', '872315492', '7823456723', 'cisco@cisco.com', 'http://www.cisco.com', NULL),
('Goodyear', '100 Goodyear Dr.', 'Gary', 'IN', '485321956', '5784218427', 'sales@goodyear.com', 'http://www.goodyear.com', 'Competing well with Firestone.'),
('Snap-On', '42185 Magenta Ave', 'Lake Falls', 'ND', '387513649', '9197345632', 'support@snapon.com', 'http://www.snap-on.com', 'Good quality tools!');
go

-- ---------------------------------------------------------------------------------------
-- product Values
-- ---------------------------------------------------------------------------------------
insert into dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
values
(1, 'hammer','', 2.5, 45, 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, 'screwdriver','', 1.8, 120, 1.99, 3.49, NULL, NULL),
(4, 'pail', '16 Galllon', 2.8, 48, 3.89, 7.99, 40, NULL),
(5, 'cooking oil', 'Peanut oil', 15, 19, 19.99, 28.99, NULL, 'gallons'),
(3, 'frying pan', '', 3.5, 178, 8.45, 13.99, 50, 'Currently 1/2 price sale.');
go

-- ---------------------------------------------------------------------------------------
-- order_line Values
-- ---------------------------------------------------------------------------------------
insert into dbo.order_line
(ord_id, pro_id, oln_qty, oln_price, oln_notes)
values
(1, 2, 10, 8.0, NULL),
(2, 3, 7, 9.88, NULL),
(3, 4, 3, 6.99, NULL),
(5, 1, 2, 12.76, NULL),
(4, 5, 13, 58.99, NULL);
go

-- ---------------------------------------------------------------------------------------
-- payment Values
-- ---------------------------------------------------------------------------------------
insert into dbo.payment
(inv_id, pay_date, pay_amt, pay_notes)
values
(5, '2008-07-01', 5.99, NULL),
(4, '2010-09-28', 4.99, NULL),
(1, '2008-07-23', 8.75, NULL),
(3, '2010-10-31', 19.55, NULL),
(2, '2011-03-29', 32.5, NULL),
(6, '2010-10-03', 20.00, NULL),
(8, '2008-08-09', 1000.00, NULL),
(9, '2009-01-10', 103.68, NULL),
(7, '2007-03-15', 25.00, NULL),
(10, '2007-05-12', 40.00, NULL),
(4, '2007-05-22', 9.33, NULL);
go

-- ---------------------------------------------------------------------------------------
-- product_hist Values
-- ---------------------------------------------------------------------------------------
insert into dbo.product_hist
(pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
values
(1,'2005-01-02 11:53:34', 4.99, 7.99, 30, 'Discounted only when purchased with screwdriver set.'),
(2, '2005-02-03 09:13:56', 1.99, 3.49, NULL, NULL),
(3, '2005-03-04 23:21:49', 3.89, 7.99, 40, NULL),
(4, '2006-05-06 18:09:04', 19.99, 28.99, NULL, 'gallons'),
(5,'2006-05-07 15:07:29', 8.45, 13.99, 50, 'Currently 1/2 price sale.');
go

-- ---------------------------------------------------------------------------------------
-- srp_hist Values
-- ---------------------------------------------------------------------------------------
insert into dbo.srp_hist
(per_id, sht_type, sht_modified,sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
values
(1,'i', getDate(), SYSTEM_USER, getDate(), 100000, 110000, 11000, NULL),
(4, 'i', getDate(), SYSTEM_USER, getDate(), 150000, 175000, 17500, NULL),
(3, 'u', getDate(), SYSTEM_USER, getDate(), 200000, 185000, 18500, NULL),
(2,'u', getDate(), ORIGINAL_LOGIN(), getDate(), 210000, 220000, 22000, NULL),
(5,'i', getDate(), ORIGINAL_LOGIN(), getDate(), 225000, 230000, 2300, NULL);

select year(sht_date) from dbo.srp_hist;
go

-- ---------------------------------------------------------------------------------------
-- Phone Values
-- ---------------------------------------------------------------------------------------
insert into phone
(per_id, phn_num, phn_type, phn_notes)
values
(1, 8032288827, 'c', NULL),
(2, 2052338293, 'h', NULL),
(4, 1034325598, 'w', 'has 2 office numbers'),
(5, 6402338494, 'w', NULL),
(6, 5508329842, 'f', 'fax number ont currently working'),
(7, 8202052203, 'c', 'prefers home calls'),
(8, 4008338294, 'h', NULL),
(9, 7654328912, 'w', NULL),
(10, 5463721984, 'f', 'work fax number'),
(10, 4537821902, 'h', 'prefers cell phone calls'),
(12, 7867821902, 'w', 'best number to reach'),
(13, 4537821654, 'w', 'call during lunch'),
(14, 3721821902, 'c', NULL),
(15, 9217821945, 'f', 'use for faxing legal docs');
go

-- ---------------------------------------------------------------------------------------
-- CreatePersonSSN
-- ---------------------------------------------------------------------------------------
create proc dbo.CreatePersonSSN
as
begin

    declare @salt binary(64);
    declare @ran_num int;
    declare @ssn binary(64);
    declare @x int, @y int;
    set @x = 1;

    set @y = (select count(*) from dbo.person);

    while(@x <= @y)
    begin

        set @salt = crypt_gen_random(64);
        set @ran_num = floor(rand() * (999999999 - 111111111 + 1)) + 111111111;
        set @ssn = hashbytes('SHA2_512', concat(@salt, @ran_num));

        update dbo.person
        set per_ssn = @ssn, per_salt = @salt
        where per_id = @x;

        set @x = @x + 1;

    end;

end;
go

exec dbo.CreatePersonSSN

-- ---------------------------------------------------------------------------------------
-- summary
-- ---------------------------------------------------------------------------------------
-- list tables 
select * from [jep18d].information_schema.tables;
go

-- metadata of db tables
select * from [jep18d].information_schema.columns;
go


select * from dbo.person;
go

-- ---------------------------------------------------------------------------------------
-- 1) Create a view that displays the sum of all paid invoice totals for each customer, sort by the largest invoice total sum appearing first.
-- ---------------------------------------------------------------------------------------
use jep18d;
if object_id(N'dbo.v_paid_invoice_total', N'V') is not null
drop view dbo.v_paid_invoice_total;
go

create view dbo.v_paid_invoice_total as
    select p.per_id, per_fname, per_lname, sum(inv_total) as sum_total, format(sum(inv_total), 'C', 'en-us') as paid_invoice_total
    from dbo.person p join dbo.customer c on p.per_id = c.per_id
    join dbo.contact ct on c.per_id = ct.per_cid
    join dbo.[order] o on ct.cnt_id = o.cnt_id
    join dbo.invoice i on o.ord_id = i.ord_id
    where inv_paid != 0
    group by p.per_id, per_fname, per_lname
go
-- order by used outside of view

-- ---------------------------------------------------------------------------------------
-- 2) Create a stored procedure that displays all customers’ outstanding balances (unstored derived attribute based upon the difference of a customer's invoice total and their respective payments). List their invoice totals, what was paid, and the difference.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.sp_all_customers_outstanding_balances', N'P') is not null
drop proc dbo.sp_all_customers_outstanding_balances;
go

create proc dbo.sp_all_customers_outstanding_balances as
begin
    select p.per_id, per_fname, per_lname,
    sum(pay_amt) as total_paid, (inv_total - sum(pay_amt)) as invoice_diff
    from person p join dbo.customer c on p.per_id = c.per_id
    join dbo.contact ct on c.per_id = ct.per_cid
    join dbo.[order] o on ct.cnt_id = o.cnt_id
    join dbo.invoice i on o.ord_id = i.ord_id
    join dbo.payment pt on i.inv_id = pt.inv_id
    group by p.per_id, per_fname, per_lname, inv_total
    order by invoice_diff desc;
end
go

-- calling stored procedure
exec dbo.sp_all_customers_outstanding_balances

-- listing stored procedures
select * from jep18d.information_schema.routines
where routine_type = 'PROCEDURE';
go


-- ---------------------------------------------------------------------------------------
-- 3) Create a stored procedure that populates the sales rep history table w/sales reps’ data when called.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.sp_populate_srp_hist_table', N'P') is not null
drop proc dbo.sp_populate_srp_hist_table;
go

create proc dbo.sp_populate_srp_hist_table as
begin
    insert into dbo.srp_hist
    (per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
    select per_id, 'i', getDate(), SYSTEM_USER, getDate(), srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes
    from dbo.slsrep;
end
go


-- ---------------------------------------------------------------------------------------
-- 4) Create a trigger that automatically adds a record to the sales reps’ history table for every record added to the sales rep table.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.trg_sales_history_insert', N'TR') is not null
drop trigger dbo.trg_sales_history_insert;
go

create trigger dbo.trg_sales_history_insert
on dbo.slsrep
after insert as
begin
    declare
    @per_id_v smallint,
    @sht_type_v char(1),
    @sht_modified_v date,
    @sht_modifier_v varchar(45),
    @sht_date_v date,
    @sht_yr_sales_goal_v decimal(8,2),
    @sht_yr_total_sales_v decimal(8,2),
    @sht_yr_total_comm_v decimal(7,2),
    @sht_notes_v varchar(255);

    select
    @per_id_v = per_id,
    @sht_type_v = 'i',
    @sht_modified_v = getDate(),
    @sht_modifier_v = SYSTEM_USER,
    @sht_date_v = getDate(),
    @sht_yr_sales_goal_v = srp_yr_sales_goal,
    @sht_yr_total_sales_v = srp_ytd_sales,
    @sht_yr_total_comm_v =srp_ytd_comm,
    @sht_notes_v = srp_notes
    from inserted;

    insert into dbo.srp_hist
    (per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes)
    values
    (@per_id_v, @sht_type_v, @sht_modified_v, @sht_modifier_v, @sht_date_v, @sht_yr_sales_goal_v, @sht_yr_total_sales_v, @sht_yr_total_comm_v, @sht_notes_v);
end
go

-- fire trigger
insert into dbo.slsrep
(per_id, srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes)
values
(6, 98000, 43000, 8750, 'per_id values 1-5 already used');

-- ---------------------------------------------------------------------------------------
-- 5) Create a trigger that automatically adds a record to the product history table for every record added to the product table.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.trg_product_history_insert', N'TR') is not null
drop trigger dbo.trg_product_history_insert;
go

create trigger dbo.trg_product_history_insert
on dbo.product
after insert as
begin
    declare
    @pro_id_v smallint,
    @pht_modified_v date,
    @pht_cost_v decimal(7,2),
    @pht_price_v decimal(7,2),
    @pht_discount_v decimal(3,0),
    @pht_notes_v varchar(255);

    select
    @pro_id_v = pro_id,
    @pht_modified_v = getDate(),
    @pht_cost_v = pro_cost,
    @pht_price_v = pro_price,
    @pht_discount_v = pro_discount,
    @pht_notes_v = pro_notes
    from inserted;

    insert into dbo.product_hist
    (pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes)
    values
    (@pro_id_v, @pht_modified_v, @pht_cost_v, @pht_price_v, @pht_discount_v, @pht_notes_v);
end
go

-- fire trigger
insert into dbo.product
(ven_id, pro_name, pro_descript, pro_weight, pro_qoh, pro_cost, pro_price, pro_discount, pro_notes)
values
(3, 'desk lamp', 'small desk lamp with led lights', 3.6, 14, 5.98, 11.99, 15, 'No discounts after sale');

-- ---------------------------------------------------------------------------------------
-- 6) Create a stored procedure that updates sales reps’ yearly_sales_goal in the slsrep table, based upon 8% more than their previous year’s total sales (sht_yr_total_sales), name it sp_annual_salesrep_sales_goal. (See Notes above.)
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.sp_annual_salesrep_sales_goal', N'P') is not null
drop proc dbo.sp_annual_salesrep_sales_goal;
go

create proc dbo.sp_annual_salesrep_sales_goal as
begin
    update slsrep
    set srp_yr_sales_goal = sht_yr_total_sales * 1.08
    from slsrep as sr join srp_hist as sh on sr.per_id = sh.per_id
    where sht_date=(select max(sht_date) from srp_hist); -- max() since all data is recent
end
go

exec dbo.sp_annual_salesrep_sales_goal
go
