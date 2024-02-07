set Ansi_warnings on;
go

use master;
go

if exists (select name from master.dbo.sysdatabases where name = N'jep18d')
drop database jep18d;
go

use jep18d;
go


-- ------------------------------------------------------------------
-- dbo.applicant
-- ------------------------------------------------------------------
if object_id (N'dbo.applicant', N'U') is not null
drop table dbo.applicant;
go

create table dbo.applicant
(
    app_id smallint not null identity(1,1),
    app_ssn int not null check (app_ssn > 0 and app_ssn <= 999999999),
    app_state_id varchar(45) not null,
    app_fname varchar(15) not null,
    app_lname varchar(30) not null,
    app_street varchar(30) not null,
    app_city varchar(30) not null,
    app_state char(2) not null default 'FL',
    app_zip char(9) not null check (app_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    app_email varchar(100) not null,
    app_dob date not null,
    app_gender char(1) not null check (app_gender in ('m','f')),
    app_bckgd_check char(1) not null check (app_bckgd_check in ('y','n')),
    app_notes varchar(255) null,
    primary key (app_id),

    constraint uk_app_ssn unique nonclustered (app_ssn asc),
    constraint uk_app_state_id unique nonclustered (app_state_id asc)
);

-- ------------------------------------------------------------------
-- dbo.property
-- ------------------------------------------------------------------
if object_id (N'dbo.property', N'U') is not null
drop table dbo.property;

create table dbo.property
(
    prp_id smallint not null identity(1,1),
    prp_street varchar(30) not null,
    prp_city varchar(30) not null,
    prp_state char(2) not null default 'FL',
    prp_zip char(9) not null check (prp_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    prp_type varchar(15) not null check (prp_type in('house','condo','townhouse','duplex','apt','mobile home','room')),
    prp_rental_rate decimal(7,2) not null check (prp_rental_rate > 0),
    prp_status char(1) not null check(prp_status in('a','u')),
    prp_notes varchar(255) null,
    primary key (prp_id)
);

-- ------------------------------------------------------------------
-- dbo.agreement
-- ------------------------------------------------------------------
if object_id (N'dbo.agreement', N'U') is not null
drop table dbo.agreement;

create table dbo.agreement
(
    agr_id smallint not null identity(1,1),
    prp_id smallint not null,
    app_id smallint not null,
    agr_signed date not null,
    agr_start date not null,
    agr_enn date not null,
    agr_amt decimal(7,2) not null check (agr_amt > 0),
    agr_notes varchar(255) null,
    primary key (agr_id),

    constraint uk_prp_id_app_id_agr_signed unique (prp_id asc, app_id asc, agr_signed desc),

    constraint fk_agreement_property
        foreign key (prp_id)
        references dbo.property (prp_id)
        on delete cascade
        on update cascade,

    constraint fk_agreement_applicant
        foreign key (app_id)
        references dbo.applicant (app_id)
        on delete cascade
        on update cascade
);

-- ------------------------------------------------------------------
-- dbo.feature
-- ------------------------------------------------------------------
if object_id (N'dbo.feature', N'U') is not null
drop table dbo.feature;

create table dbo.feature
(
    ftr_id tinyint not null identity(1,1),
    ftr_type varchar(45) not null,
    ftr_notes varchar(255) null,
    primary key (ftr_id)
);

-- ------------------------------------------------------------------
-- dbo.prop_feature
-- ------------------------------------------------------------------
if object_id (N'dbo.prop_feature', N'U') is not null
drop table dbo.prop_feature;

create table dbo.prop_feature
(
    pft_id smallint not null identity(1,1),
    prp_id smallint not null,
    ftr_id tinyint not null,
    pft_notes varchar(255) null,

    constraint uk_prp_id_ftr_id unique nonclustered (prp_id asc, ftr_id asc),

    constraint fk_prop_feat_property
        foreign key (prp_id)
        references dbo.property (prp_id)
        on delete cascade
        on update cascade,

    constraint fk_prop_feat_feature
        foreign key (ftr_id)
        references dbo.feature (ftr_id)
        on delete cascade
        on update cascade
);

-- ------------------------------------------------------------------
-- dbo.occupant
-- ------------------------------------------------------------------
if object_id (N'dbo.occupant', N'U') is not null
drop table dbo.occupant;

create table dbo.occupant
(
    ocp_id smallint not null identity(1,1),
    app_id smallint not null,
    ocp_ssn int not null check (ocp_ssn > 0 and ocp_ssn <= 999999999),
    ocp_state_id varchar(45) null,
    ocp_fname varchar(15) not null ,
    ocp_lname varchar(30) not null,
    ocp_email varchar(100) null,
    ocp_dob date not null,
    ocp_gender char(1) not null check (ocp_gender in ('m','f')),
    ocp_bckgd_check char(1) not null check (ocp_bckgd_check in ('y','n')),
    ocp_notes varchar(45) null,
    primary key (ocp_id),

    constraint uk_ocp_ssn unique nonclustered (ocp_ssn asc),
    constraint uk_ocp_state_id unique nonclustered (ocp_state_id asc),

    constraint fk_occupant_applicant
        foreign key (app_id)
        references dbo.applicant (app_id)
        on delete cascade
        on update cascade
);


-- ------------------------------------------------------------------
-- dbo.phone
-- ------------------------------------------------------------------
if object_id (N'dbo.phone', N'U') is not null
drop table dbo.phone;

create table dbo.phone
(
    phn_id smallint not null identity(1,1),
    app_id smallint null,
    ocp_id smallint null,
    phn_num char(10) not null check (phn_num like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phn_type char(1) not null check (phn_type in ('c','h','w','f')),
    phn_notes varchar(255) null,
    primary key (phn_id),

    constraint uk_app_id_phn_num unique nonclustered(app_id asc, phn_num asc),

    constraint uk_ocp_id_phn_num unique nonclustered (ocp_id asc, phn_num asc),

    constraint fk_phone_applicant
        foreign key (app_id)
        references dbo.applicant (app_id)
        on delete cascade
        on update cascade,

    constraint fk_phone_occupant
        foreign key (ocp_id)
        references dbo.occupant (ocp_id)
        on delete no action
        on update no action
);


-- ------------------------------------------------------------------
-- dbo.room_type
-- ------------------------------------------------------------------
if object_id (N'dbo.room_type', N'U') is not null
drop table dbo.room_type;

create table dbo.room_type
(
    rtp_id tinyint not null identity(1,1),
    rtp_name varchar(45) not null,
    rtp_notes varchar(255) null,
    primary key (rtp_id)
);


-- ------------------------------------------------------------------
-- dbo.room
-- ------------------------------------------------------------------
if object_id (N'dbo.room', N'U') is not null
drop table dbo.room;

create table dbo.room
(
    rom_id smallint not null identity(1,1),
    prp_id smallint not null,
    rtp_id tinyint not null,
    rom_size varchar(45) not null,
    rom_notes varchar(255) null,
    primary key (rom_id),
    
    constraint fk_room_property
        foreign key (prp_id)
        references dbo.property (prp_id)
        on delete cascade
        on update cascade,

    constraint fk_room_roomtype
        foreign key (rtp_id)
        references dbo.room_type (rtp_id)
        on delete cascade
        on update cascade
);

select * from information_schema.tables;

-- disable all constraints after table creation before inserts
exec sp_msforeachtable "alter table ? nocheck constraint all"

-- INSERTS

-- ------------------------------------------------------------------
-- dbo.feature
-- ------------------------------------------------------------------
INSERT INTO dbo.feature
(ftr_type, ftr_notes)

VALUES
('Central A/C', NULL),
('Pool', NULL),
('Close to school', NULL),
('Furnished', NULL),
('Cable', NULL),
('Washer/Dryer', NULL),
('Refrigerator', NULL),
('Microwave', NULL),
('Oven', NULL),
('1-car garage', NULL),
('2-car garage', NULL),
('Sprinkler system', NULL),
('Security', NULL),
('Wi-Fi', NULL),
('Storage', NULL),
('Fireplace', NULL);

-- ------------------------------------------------------------------
-- dbo.featurroom_type
-- ------------------------------------------------------------------
INSERT INTO dbo.room_type
(rtp_name, rtp_notes)
VALUES
('Bed', NULL),
('Bath', NULL),
('Kitchen', NULL),
('Lanai', NULL),
('Dining', NULL),
('Living', NULL),
('Basement', NULL),
('Office', NULL);

-- ------------------------------------------------------------------
-- dbo.prop_feature
-- ------------------------------------------------------------------
INSERT INTO dbo.prop_feature
(prp_id, ftr_id, pft_notes)
VALUES
(1, 4, NULL),
(2, 5, NULL),
(3, 3, NULL),
(4, 2, NULL),
(5, 1, NULL),
(1, 1, NULL),
(1, 5, NULL);

-- ------------------------------------------------------------------
-- dbo.room
-- ------------------------------------------------------------------
INSERT INTO dbo.room
(prp_id, rtp_id, rom_size, rom_notes)

VALUES
(1,1, '10'' x 10"', NULL),
(3,2, '20'' x 15"', NULL),
(4,3, '8'' x 8"', NULL),
(5,4, '50'' x 50"', NULL),
(2,5, '30'' x 30"', NULL);

-- ------------------------------------------------------------------
-- dbo.property
-- ------------------------------------------------------------------
INSERT INTO dbo.property
(prp_street, prp_city, prp_state, prp_zip, prp_type, prp_rental_rate, prp_status, prp_notes)

VALUES
('5133 3rd Road', 'Lake Worth', 'FL', '334671234', 'house', 1800.00, 'u', NULL),
('92E Blah Way', 'Tallahassee', 'FL', '323011234', 'apt', 641.00, 'u', NULL),
('756 Diet Coke Lane', 'Panama City', 'FL', '342001234', 'condo', 2400.00, 'a', NULL),
('574 Doritos Circle', 'Jacksonville', 'FL', '365231234', 'townhouse', 1942.99, 'a', NULL),
('2241 W. Pensacola Street', 'Tallahassee', 'FL', '323041234', 'apt', 610.00, 'u', NULL);

-- ------------------------------------------------------------------
-- dbo.applicant
-- ------------------------------------------------------------------
INSERT INTO dbo.applicant
(app_ssn, app_state_id, app_fname, app_lname, app_street, app_city, app_state, app_zip, app_email, app_dob, app_gender, app_bckgd_check, app_notes)

VALUES
('123456789', 'A12C34S56Q78', 'Carla', 'Vanderbilt', '5133 3rd Road', 'Lake Worth', 'FL', '334671234', 'csweeney@yahoo.com', '1961-11-26', 'F', 'y', NULL),
('590123654', 'B123A456D789', 'Amanda', 'Lindell', '2241 W. Pensacola Street', 'Tallahassee', 'FL', '323041234', 'acc10c@my.fsu.edu', '1981-04-04', 'F', 'y', NULL),
('987456321', 'dfed66532sedd', 'David', 'Stephens', '1293 Banana Code Drive', 'Panama City', 'FL', '323081234', 'mjowett@comcast.net', '1965-05-15', 'M', 'n', NULL),
('365214986', 'dgfgr56597224', 'Chris', 'Thrombough', '987 Learning Drive', 'Tallahassee', 'FL', '323011234', 'landbeck@fsu.edu', '1969-07-25', 'M', 'y', NULL),
('326598236', 'yadayada4517', 'Spencer', 'Moore', '787 Tharpe Road', 'Tallahassee', 'FL', '323061234', 'spencer@my.fsu.edu', '1990-08-14', 'M', 'n', NULL);

-- ------------------------------------------------------------------
-- dbo.agreement
-- ------------------------------------------------------------------
INSERT INTO dbo.agreement
(prp_id, app_id, agr_signed, agr_start, agr_end, agr_amt, agr_notes)

VALUES
(3, 4, '2011-12-01', '2012-01-01', '2012-12-31', 1000.00, NULL),
(1, 1, '1983-01-01', '1983-01-01', '1987-12-31', 800.00, NULL),
(4, 2, '1999-12-31', '2000-01-01', '2004-12-31', 1200.00, NULL),
(5, 3, '1999-07-31', '1999-08-01', '2004-07-31', 750.00, NULL),
(2, 5, '2011-01-01', '2011-01-01', '2013-12-31', 900.00, NULL);

-- ------------------------------------------------------------------
-- dbo.occupant
-- ------------------------------------------------------------------
INSERT INTO dbo.occupant
(app_id, ocp_ssn, ocp_state_id, ocp_fname, ocp_lname, ocp_email, ocp_dob, ocp_gender, ocp_bckgd_check, ocp_notes)

VALUES
(1, '326532165', 'okd557ig4125', 'Bridget', 'Case-Sweeney', 'bcs10c@gmail.com', '1988-03-23', 'F', 'y', NULL),
(1, '187452457', 'fjkd654345', 'Brian', 'Sweeney', 'brian@sweeney.com', '1956-07-28', 'M', 'y', NULL),
(2, '123456780', 'zalfj768591', 'Skittles', 'McGoobs', 'skittles@mcgoobs.com', '2011-01-01', 'F', 'n', NULL),
(2, '098123664', '8964orierue', 'Jane', 'Doe', 'jdoe@aol.com', '1988-03-05', 'M', 'n', NULL),
(5, '857694032', '324woruq', 'Bam', 'Bam', 'bbam@fstones.com', '2013-04-08', 'F', 'n', NULL);

-- ------------------------------------------------------------------
-- dbo.phone
-- ------------------------------------------------------------------
INSERT INTO dbo.phone
(app_id, ocp_id, phn_num, phn_type, phn_notes)
-- Note: unless indicated in notes, if both app_id and ocp_id it is a shared phone
VALUES
(1, NULL, '5615233044', 'H', NULL),
(2, NULL, '5616859976', 'F', NULL),
(5, 5, '8504569872', 'H', NULL),
(NULL, 1, '5613080898', 'C', 'occupant''s number only'),
(NULL, 1, '8182345678', 'W', NULL),
(NULL, 3, '3124567890', 'W', NULL),
(4, NULL, '2137890123', 'W', NULL),
(4, 2, '3049876543', 'W', NULL),
(3, 4, '3136543210', 'C', NULL),
(3, 1, '2123210987', 'C', NULL);

-- enable all constraints
exec sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

/*
first CHECK with WITH (ensures data gets checked for consistency when activating constraint)
second CHECK with CONSTRAINT (type of constraint)
*/

-- show data
select * from dbo.feature;
select * from dbo.prop_feature;
select * from dbo.room_type;
select * from dbo.room;
select * from dbo.property;
select * from dbo.applicant;
select * from dbo.agreement;
select * from dbo.occupant;
select * from dbo.phone;

-- ------------------------------------------------------------------
-- A.
-- ------------------------------------------------------------------
use jep18d;
go

begin transaction;
    select * from dbo.property;
    select * from dbo.prop_feature;
    select * from dbo.room;
    select * from dbo.agreement;

    delete from dbo.property
    where prp_id = 1;

    select * from dbo.property;
    select * from dbo.prop_feature;
    select * from dbo.room;
    select * from dbo.agreement;

commit;

-- ------------------------------------------------------------------
-- B.
-- ------------------------------------------------------------------
use jep18d;
go

if object_id(N'dbo.v_prop_info', N'V') is  not null
drop view dbo.v_prop_info;
go

create view dbo.v_prop_info as
    select p.prp_id, prp_type, prp_rental_rate, rtp_name, rom_size
    from property p
    join room r on p.prp_id = r.prp_id
    join room_type rt on r.rtp_id = rt.rtp_id
    where p.prp_id = 3;

go

select * from information_schema.tables;

-- Show view definition
select view_definition
from information_schema.views;
go
select * from dbo.v_prop_info;

-- ------------------------------------------------------------------
-- C.
-- ------------------------------------------------------------------
use jep18d;
go

if object_id(N'dbo.v_prop_info_feature', N'V') is  not null
drop view dbo.v_prop_info_feature;
go

create view dbo.v_prop_info_feature as
    select p.prp_id, prp_type, prp_rental_rate, ftr_type
    from property p
    join prop_feature pf on p.prp_id = pf.prp_id
    join feature f on pf.ftr_id = f.ftr_id
    where p.prp_id >= 4 and p.prp_id < 6;
go

select * from dbo.v_prop_info_feature order by prp_rental_rate desc;
go

select * from  information_schema.tables;
go

-- Show view definition
select view_definition from information_schema.views;
go

select * from dbo.v_prop_info_feature;
go

-- ------------------------------------------------------------------
-- D.
-- ------------------------------------------------------------------
use jep18d;
go

if object_id('dbo.ApplicantInfo') is  not null
drop procedure dbo.ApplicantInfo;
go

create procedure dbo.ApplicantInfo(@appid int) as
    select app_ssn, app_state_id, app_fname, app_lname, phn_num, phn_type
    from applicant a, phone p
    where a.app_id = p.app_id
    and a.app_id = @appid;
go

exec dbo.ApplicantInfo 3;

-- or
-- declare @myvar int = 2
-- exec dbo.ApplicantInfo @myvar;
go

drop procedure dbo.ApplicantInfo;
go
-- ------------------------------------------------------------------
-- E.
-- ------------------------------------------------------------------
use jep18d;
go

if object_id('dbo.OccupantInfo') is not null
drop procedure dbo.OccupantInfo;
go

create procedure dbo.OccupantInfo as
    select ocp_ssn, ocp_state_id, ocp_fname, ocp_lname, phn_num, phn_type
    from phone p left outer join occupant o on o.ocp_id = p.ocp_id;

go

exec dbo.OccupantInfo;
go
-- ------------------------------------------------------------------