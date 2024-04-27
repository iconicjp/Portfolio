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
go

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
go

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
go

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
go

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
go

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
go

-- ---------------------------------------------------------------------------------------
-- Create region
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.region', N'U') is not null
drop table dbo.region;
go

create table dbo.region
(
    reg_id TINYINT NOT NULL identity(1,1),
    reg_name CHAR(1) NOT NULL, -- {n}orth,{e}ast,{s}outh,{w}est,{c}entral
    reg_notes VARCHAR(255) NULL,
    PRIMARY KEY (reg_id)
);
go

-- ---------------------------------------------------------------------------------------
-- Create state
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.state', N'U') is not null
drop table dbo.state;
go

create table dbo.state
(
    ste_id TINYINT NOT NULL identity(1,1),
    reg_id TINYINT NOT NULL,
    ste_name CHAR(2) NOT NULL default 'FL',
    ste_notes VARCHAR(255) NULL,
    PRIMARY KEY (ste_id),

    CONSTRAINT fk_state_region
    FOREIGN KEY (reg_id)
    REFERENCES dbo.region (reg_id)
    ON DELETE cascade
    ON UPDATE cascade
);
go

-- ---------------------------------------------------------------------------------------
-- Create city
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.city', N'U') is not null
drop table dbo.city;
go

create table dbo.city
(
    cty_id SMALLINT NOT NULL identity(1,1),
    ste_id TINYINT NOT NULL,
    cty_name VARCHAR(30) NOT NULL,
    cty_notes VARCHAR(255) NULL,
    PRIMARY KEY (cty_id),

    CONSTRAINT fk_city_state
    FOREIGN KEY (ste_id)
    REFERENCES dbo.state (ste_id)
    ON DELETE cascade
    ON UPDATE cascade
);
go

-- ---------------------------------------------------------------------------------------
-- Create store
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.store', N'U') is not null
drop table dbo.store;
go

create table dbo.store
(
    str_id smallint not null identity(1,1),
    cty_id smallint not null,
    str_name varchar(45) not null,
    str_street varchar(30) not null,
    str_zip int not null check (str_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_phone bigint not null check (str_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    str_email varchar(100) not null,
    str_url varchar(100) not null,
    str_notes varchar(255),
    primary key (str_id),

    constraint fk_store_city
    foreign key (cty_id)
    references dbo.city (cty_id)
    on delete cascade
    on update cascade
);
go

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
go

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
go

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
go

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
go

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
go

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
go

-- ---------------------------------------------------------------------------------------
-- Create time
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.time', N'U') is not null
drop table dbo.time;
go

create table dbo.time
(
    tim_id INT NOT NULL identity(1,1),
    tim_yr SMALLINT NOT NULL,
    tim_qtr TINYINT NOT NULL,
    tim_month TINYINT NOT NULL,
    tim_week TINYINT NOT NULL,
    tim_day TINYINT NOT NULL,
    tim_time TIME NOT NULL,
    tim_notes VARCHAR(255) NULL,
    PRIMARY KEY (tim_id)
);
go

-- ---------------------------------------------------------------------------------------
-- Create sale
-- ---------------------------------------------------------------------------------------
  if object_id(N'dbo.sale', N'U') is not null
drop table dbo.sale;
go


create table dbo.sale
(
    pro_id SMALLINT NOT NULL,
    str_id SMALLINT NOT NULL,
    cnt_id INT NOT NULL,
    tim_id INT NOT NULL,
    sal_qty SMALLINT NOT NULL,
    sal_price DECIMAL(8,2) NOT NULL,
    sal_total DECIMAL(8,2) NOT NULL,
    sal_notes VARCHAR(255) NULL,
    PRIMARY KEY (pro_id, str_id, cnt_id, tim_id),

    CONSTRAINT fk_sale_product
    FOREIGN KEY (pro_id)
    REFERENCES dbo.product (pro_id)
    ON DELETE cascade
    ON UPDATE cascade,

    CONSTRAINT fk_sale_store
    FOREIGN KEY (str_id)
    REFERENCES dbo.store (str_id)
    ON DELETE cascade
    ON UPDATE cascade,

    CONSTRAINT fk_sale_contact
    FOREIGN KEY (cnt_id)
    REFERENCES dbo.contact (cnt_id)
    ON DELETE cascade
    ON UPDATE cascade,

    CONSTRAINT fk_sale_time
    FOREIGN KEY (tim_id)
    REFERENCES dbo.time (tim_id)
    ON DELETE cascade
    ON UPDATE cascade
);
go

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
-- region Values
-- ---------------------------------------------------------------------------------------
insert into dbo.region
(reg_name, reg_notes)
values
('c', null),
('n', null),
('e', null),
('s', null),
('w', null);

go
-- ---------------------------------------------------------------------------------------
-- state Values
-- ---------------------------------------------------------------------------------------
insert into dbo.state
(reg_id, ste_name, ste_notes)
values
(1, 'MI', null),
(3, 'IL', null),
(4, 'WA', null),
(5, 'FL', null),
(2, 'TX', null);
go
-- ---------------------------------------------------------------------------------------
-- city Values
-- ---------------------------------------------------------------------------------------
insert into dbo.city
(ste_id, cty_name, cty_notes)
values
(1,'Detroit', null),
(2, 'Aspen', null),
(2, 'Chicago', null),
(4, 'Clover', null),
(5, 'St. Louis', null);
go
-- ---------------------------------------------------------------------------------------
-- store Values
-- ---------------------------------------------------------------------------------------
insert into dbo.store
(cty_id, str_name, str_street, str_zip, str_phone, str_email, str_url, str_notes)
values
(2,'Walgreens', '14567 Walnut Ln', '475315690', '3127658127', 'info@walgreens.com', 'http://www.walgreens.com', NULL),
(3,'CVS', '572 Casper Rd', '505231519', '3128926534', 'help@cvs.com', 'http://www.cvs.com', 'Rumor of merger.'),
(4,'Lowes', '81309 Catapult Ave', '802345671', '9017653421', 'sales@lowes.com', 'http://www.lowes.com', NULL),
(5,'Walmart', '14567 Walnut Ln', '387563628', '8722718923', 'info@walmart.com', 'http://www.walmart.com', NULL),
(1,'Dollar General', '47583 Davison Rd', '482983456', '3137583492', 'ask@dollargeneral.com', 'http://www.dollargeneral.com', 'recently sold property');
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
-- Time Values
-- ---------------------------------------------------------------------------------------
insert into dbo.time
(tim_yr, tim_qtr, tim_month, tim_week, tim_day, tim_time, tim_notes)
values
(2008, 2, 5, 19, 7, '11:59:59', null),
(2010, 4, 12, 49, 4, '08:34:21', null),
(1999, 4, 12, 52, 5, '05:21:34', null),
(2011, 3, 8, 36, 1, '09:32:18', null),
(2001, 3, 7, 27, 2, '23:56:32', null),
(2008, 1, 1, 5, 4, '04:22:36', null),
(2010, 2, 4, 14, 5, '02:49:11', null),
(2014, 1, 2, 8, 2, '12:27:14', null),
(2013, 3, 9, 38, 4, '10:12:28', null),
(2012, 4, 11, 47, 3, '22:36:22', null),
(2014, 2, 6, 23, 3, '19:07:10', null);
go
-- ---------------------------------------------------------------------------------------
-- Sale Values
-- ---------------------------------------------------------------------------------------
insert into dbo.sale
(pro_id, str_id, cnt_id, tim_id, sal_qty, sal_price, sal_total, sal_notes)
values
(1, 5, 5, 3, 20, 9.99, 199.8, null),
(2, 4, 6, 2, 5, 5.99, 29.95, null),
(3, 3, 4, 1, 30, 3.99, 119.7, null),
(4, 2, 1, 5, 15, 18.99, 284.85, null),
(5, 1, 2, 4, 6, 11.99, 71.94, null),
(5, 2, 5, 6, 10, 9.99, 199.8, null),
(4, 3, 6, 7, 5, 5.99, 29.95, null),
(3, 1, 4, 8, 30, 3.99, 119.7, null),
(2, 3, 1, 9, 15, 18.99, 284.85, null),
(1, 4, 2, 10, 6, 11.99, 71.94, null),
(1, 2, 3, 11, 10, 11.99, 119.9, null),
(2, 1, 6, 1, 6, 3.99, 25.5, null),
(3, 1, 2, 2, 8, 19.99, 40.5, null),
(4, 1, 2, 3, 13, 2.99, 6.30, null),
(5, 2, 4, 4, 14, 4.99, 15.65, null),
(5, 3, 1, 5, 15, 13.99, 16.25, null),
(4, 2, 3, 6, 16, 10.99, 16.65, null),
(3, 3, 5, 7, 17, 14.99, 21.75, null),
(2, 3, 6, 8, 18, 1.99, 4.85, null),
(1, 3, 5, 9, 19, 18.99, 23.35, null),
(1, 4, 1, 10, 20, 29.99, 50.5, null),
(2, 4, 2, 11, 25, 9.99, 18.95, null),
(3, 4, 6, 10, 50, 5.99, 12.5, null),
(4, 5, 4, 9, 35, 4.99, 8.5, null),
(5, 5, 1, 8, 30, 19.99, 30.5, null); 
go
-- ---------------------------------------------------------------------------------------
-- CreatePersonSSN
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.CreatePersonSSN', N'P') is not null
drop proc dbo.CreatePersonSSN;
go

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
-- 1. Create a stored procedure (product_days_of_week) listing the product names, descriptions, and the day of the week in which they were sold, in ascending order of the day of week.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.product_days_of_week', N'P') is not null
drop proc dbo.product_days_of_week;
go

-- DATENAME(datepart, date)
-- tim_day - 1 so Monday is start of the week
create proc dbo.product_days_of_week as
begin
    select pro_name, pro_descript, datename(dw, tim_day - 1) 'day_of_week'
    from product p join sale s on p.pro_id = s.pro_id
    join time t on s.tim_id = s.tim_id
    order by tim_day - 1;
end
go

exec dbo.product_days_of_week;

-- ---------------------------------------------------------------------------------------
-- 2. Create a stored procedure (product_drill_down) listing the product name, quantity on hand, store name, city name, state name, and region name where each product was purchased, in descending order of quantity on hand.
-- --------------------------------------------------------------------------------------
if object_id(N'dbo.product_drill_down', N'P') is not null
drop proc dbo.product_drill_down;
go

create proc dbo.product_drill_down as
begin
    select pro_name, pro_qoh,
    format(pro_cost, 'C', 'en-us') as cost,
    format(pro_price, 'C', 'en-us') as price,
    str_name, cty_name, ste_name, reg_name
    from product p join sale s on p.pro_id = s.pro_id
    join store sr on s.str_id = sr.str_id
    join city c on sr.cty_id = c.cty_id
    join state st on c.ste_id = st.ste_id
    join region r on st.reg_id = r.reg_id
    order by pro_qoh desc
end
go

exec dbo.product_drill_down;

-- ---------------------------------------------------------------------------------------
-- 3. Create a stored procedure (add_payment) that adds a payment record. Use variables and pass suitable arguments.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.add_payment', N'P') is not null
drop proc dbo.add_payment;
go

create proc dbo.add_payment
    @inv_id_p int,
    @pay_date_p datetime,
    @pay_amt_p decimal(7,2),
    @pay_notes_p varchar(255)
as
begin
    insert into payment
    (inv_id, pay_date, pay_amt, pay_notes)
    values(@inv_id_p, @pay_date_p, @pay_amt_p, @pay_notes_p);
end
go

-- table before call
select * from payment;

declare
@inv_id_v int = 6,
@pay_date_v datetime = '2014-01-05 11:56:38',
@pay_amt_v decimal(7,2) = 159.99,
@pay_notes_v varchar(255) = 'testing add_payment';

exec dbo.add_payment @inv_id_v, @pay_date_v, @pay_amt_v, pay_notes_v;

-- table after call
select * from payment;

-- ---------------------------------------------------------------------------------------
-- 4. Create a stored procedure (customer_balance) listing the customer’s id, name, invoice id, total paid on invoice, balance (derived attribute from the difference of a customer’s invoice total and their respective payments), pass customer’s last name as argument—which may return more than one value.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.customer_balance', N'P') is not null
drop proc dbo.customer_balance;
go

create proc dbo.customer_balance
    @per_lname_p varchar(30)
as
begin
    select p.per_id, per_fname, per_lname, i.inv_id,
    format(sum(pay_amt), 'C', 'en-us') as total_paid,
    format((inv_total - sum(pay_amt)), 'C', 'en-us') as invoice_diff
    from person p join dbo.customer c on p.per_id = c.per_id
    join dbo.contact ct on c.per_id = ct. per_cid
    join dbo.[order] o on ct.cnt_id = o.cnt_id
    join dbo.invoice i on o.ord_id = i.ord_id
    join dbo.payment pt on i.inv_id = pt.inv_id
    where per_lname = @per_lname_p
    group by p.per_id, i.inv_id, per_lname, per_fname, inv_total;
end
go

-- execution
declare @per_lname_v varchar(30) = 'smith';

exec dbo.customer_balance @per_lname_v;

-- ---------------------------------------------------------------------------------------
-- 5. Create and display the results of a stored procedure (store_sales_between_dates) that lists each store's id, sum of total sales (formatted), and years for a given time period, by passing the start/end dates, group by years, and sort by total sales then years, both in descending order.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.store_sales_between_dates', N'P') is not null
drop proc dbo.store_sales_between_dates;
go

create proc dbo.store_sales_between_dates
    @start_date_p smallint,
    @end_date_p smallint
as
begin
    select st.str_id, format(sum(sal_total), 'C', 'en-us') as 'total sales', tim_yr as year
    from store st join sale s on st.str_id = s.str_id
    join time t on s.tim_id = t.tim_id
    where tim_yr between @start_date_p and @end_date_p
    group by tim_yr, st.str_id
    order by sum(sal_total) desc, tim_yr desc;
end
go

-- execution
declare
@start_date_v smallint = 2010,
@end_date_v smallint = 2013;

exec dbo.store_sales_between_dates @start_date_v, @end_date_v;

-- ---------------------------------------------------------------------------------------
-- 6. Create a trigger (trg_check_inv_paid) that updates an invoice record, after a payment has been made, indicating whether or not the invoice has been paid.
-- ---------------------------------------------------------------------------------------
if object_id(N'dbo.trg_check_inv_paid', N'TR') is not null
drop trigger dbo.trg_check_inv_paid;
go

create trigger dbo.trg_check_inv_paid
on dbo.payment
after insert as
begin
    /*-- for testing
    update invoice
    set inv_paid = 0*/

    update invoice
    set inv_paid = 1
    from invoice as i join
    (
        select inv_id, sum(pay_amt) as total_paid
        from payment 
        group by inv_id
    ) as v on i.inv_id = v.inv_id
    where total_paid >= inv_total;
end
go

-- fire trigger
select * from invoice;

insert into dbo.payment
(inv_id, pay_date, pay_amt, pay_notes)
values
(3, '2014-07-04', 75.00, 'Paid by check.');

select * from invoice
select * from payment

-- ----------------------------------------------------------------------
-- XC. Create and display the results of a stored procedure (order_line_total) that calculates the total price for each order line, based upon the product price times quantity, which yields a subtotal (oln_price), total column includes 6% sales tax. Query result set should display order line id, product id, name, description, price, order line quantity, subtotal (oln_price), and total with 6% sales tax. Sort by product ID.
-- ----------------------------------------------------------------------
if object_id(N'dbo.order_line_total', N'P') is not null
drop proc dbo.order_line_total;
go

create proc dbo.order_line_total as
begin
    select oln_id, p.pro_id, pro_name, pro_descript,
    format(pro_price, 'C', 'en-us') as pro_price,
    oln_qty,
    format((oln_qty * pro_price), 'C', 'en-us') as oln_price,
    format((oln_qty * pro_price) * 1.06, 'C', 'en-us') as total_with_6pct_tax
    from product p join order_line ol on p.pro_id = ol.pro_id
    order by p.pro_id;
end
go

exec dbo.order_line_total;