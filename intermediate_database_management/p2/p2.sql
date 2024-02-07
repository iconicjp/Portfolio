set ansi_warnings on;
go

use master;
go

if exists (select name from master.dbo.sysdatabases where name = N'jep18d')
drop database jep18d;
go

if not exists (select name from master.dbo.sysdatabases where name = N'jep18d')
create database jep18d;
go

use jep18d;
go
-- -------------------------------------------------------------------------------------
-- Create patient
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.patient',N'U') is not null
drop table dbo.patient;
go

create table dbo.patient
(
    pat_id smallint not null identity(1,1),
    pat_ssn int not null check (pat_ssn > 0 and pat_ssn < 999999999),
    pat_fname varchar(15) not null,
    pat_lname varchar(30) not null,
    pat_street varchar(30) not null,
    pat_city varchar(30) not null,
    pat_state char(2) not null default 'FL',
    pat_zip char(9) not null check (pat_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    pat_phone bigint not null check (pat_phone like '[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    pat_email varchar(100) null,
    pat_dob date not null,
    pat_gender char(1) not null check (pat_gender in ('m','f')),
    pat_notes varchar(45) null,
    primary key(pat_id),
    constraint uk_pat_ssn unique nonclustered (pat_ssn asc)
);
-- -------------------------------------------------------------------------------------
-- Create medication
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.medication',N'U') is not null
drop table dbo.medication;
go

create table dbo.medication
(
    med_id smallint not null identity(1,1),
    med_name varchar(100) not null,
    med_price decimal(5,2) not null check (med_price > 0),
    med_shelf_life date not null,
    med_notes varchar(255) null,
    primary key (med_id)
);
-- -------------------------------------------------------------------------------------
-- Create prescription
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.prescription',N'U') is not null
drop table dbo.prescription;
go

create table dbo.prescription
(
    pre_id smallint not null identity(1,1),
    pat_id smallint not null,
    med_id smallint not null,
    pre_date date not null,
    pre_dosage varchar(255) not null,
    pre_num_refills varchar(3) not null,
    pre_notes varchar(255) null,
    primary key (pre_id),

    constraint uk_pat_id_med_id_pre_date unique 
    (pat_id asc, med_id asc, pre_date asc),

    constraint fk_prescription_patient
        foreign key (pat_id)
        references dbo.patient(pat_id)
        on delete no action
        on update cascade,

    constraint fk_prescription_medication
        foreign key (med_id)
        references dbo.medication(med_id)
        on delete no action
        on update cascade
);
-- -------------------------------------------------------------------------------------
-- Create treatment
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.treatment',N'U') is not null
drop table dbo.treatment;
go

create table dbo.treatment
(
    trt_id smallint not null identity(1,1),
    trt_name varchar(255) not null,
    trt_price decimal(8,2) not null check (trt_price > 0),
    trt_notes varchar(255) null,
    primary key (trt_id)
);
-- -------------------------------------------------------------------------------------
-- Create physician
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.physician',N'U') is not null
drop table dbo.physician;
go

create table dbo.physician
(
    phy_id smallint not null identity(1,1),
    phy_specialty varchar(25) not null,
    phy_fname varchar(15) not null,
    phy_lname varchar(30) not null,
    phy_street varchar(30) not null,
    phy_city varchar(30) not null,
    phy_state char(2) not null default 'FL',
    phy_zip char(9) not null check (phy_zip like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phy_phone bigint not null check (phy_phone like '[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phy_fax bigint not null check (phy_fax like '[2-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    phy_email varchar(100) null,
    phy_url varchar(100) null,
    phy_notes varchar(255) null,
    primary key (phy_id)
);
-- -------------------------------------------------------------------------------------
-- Create patient_treatment
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.patient_treatment',N'U') is not null
drop table dbo.patient_treatment;
go

create table dbo.patient_treatment
(
    ptr_id smallint not null identity(1,1),
    pat_id smallint not null,
    phy_id smallint not null,
    trt_id smallint not null,
    ptr_date date not null,
    ptr_start time(0) not null,
    ptr_end time(0) not null,
    ptr_results varchar(255) null,
    ptr_notes varchar(255) null,
    primary key (ptr_id),

    constraint uk_pat_id_phy_id_trt_id_ptr_date unique 
    (pat_id asc, phy_id asc, trt_id asc, ptr_date asc),

    constraint fk_patient_treatment_patient
        foreign key (pat_id)
        references dbo.patient(pat_id)
        on delete no action
        on update cascade,

    constraint fk_patient_treatment_physician
        foreign key (phy_id)
        references dbo.physician(phy_id)
        on delete no action
        on update cascade,

    constraint fk_patient_treatment_treatment
        foreign key (trt_id)
        references dbo.treatment(trt_id)
        on delete no action
        on update cascade
);
-- -------------------------------------------------------------------------------------
-- Create administration_lu
-- -------------------------------------------------------------------------------------

if object_id (N'dbo.administration_lu', N'U') is not null
drop table dbo.administration_lu;
go

create table dbo.administration_lu
(
    pre_id smallint not null,
    ptr_id smallint not null,
    primary key(pre_id, ptr_id),

    constraint fk_administration_lu_prescription
        foreign key (pre_id)
        references dbo.prescription(pre_id)
        on delete no action
        on update cascade,

    constraint fk_administration_lu_patient_treatment
        foreign key (ptr_id)
        references dbo.patient_treatment(ptr_id)
        on delete no action
        on update no action
);
-- -------------------------------------------------------------------------------------
-- Insert values
-- -------------------------------------------------------------------------------------
select * from information_schema.tables;

-- Disable constraints
exec sp_msforeachtable "alter table ? no check constraint all";

-- -------------------------------------------------------------------------------------
-- Values for patient
-- -------------------------------------------------------------------------------------
insert into dbo.patient
(pat_ssn, pat_fname, pat_lname, pat_street, pat_city, pat_state, pat_zip, pat_phone, pat_email, pat_dob, pat_gender, pat_notes)
values
('123456789', 'Carla', 'Vanderbilt', '5133 3rd Road', 'Lake Worth', 'FL', '334671234', 5674892390, 'csweeney@yahoo.com', '11-26-1961', 'F', NULL),
('590123654', 'Amanda', 'Lindell', '2241 W. Pensacola Street', 'Tallahassee', 'FL', '323041234', 9876543210, 'acm10c@my.fsu.edu', '04-04-1981', 'F', NULL),
('987456321', 'David', 'Stephens', '1293 Banana Code Drive', 'Panama City', 'FL', '323081234', 8507632145, 'dstephens@comcast.net', '05-15-1965', 'M', NULL),
('365214986', 'Chris', 'Thrombough', '987 Learning Drive', 'Tallahassee', 'FL', '323011234', 5768941254, 'cthrombough@fsu.edu', '07-25-1969', 'M', NULL),
('326598236', 'Spencer', 'Moore', '787 Tharpe Road', 'Tallahassee', 'FL', '323061234', 8764930213, 'spencer@my.fsu.edu', '08-14-1990', 'M', NULL);

-- -------------------------------------------------------------------------------------
-- Values for medication
-- -------------------------------------------------------------------------------------
insert into dbo.medication
(med_name, med_price, med_shelf_life, med_notes)
values
('Abilify',200.00,'06-23-2014',NULL),
('Aciphex',125.00,'06-24-2014',NULL),
('Actonel',250.00,'06-25-2014',NULL),
('Actoplus MET',412.00,'06-26-2014',NULL),
('Actos',89.00,'06-27-2014',NULL),
('Adacel',66.00,'06-28-2014',NULL),
('Adderall XR',69.00,'06-29-2014',NULL),
('Advair Diskus',45.00,'06-30-2014',NULL),
('Aggrenox',66.99,'07-01-2014',NULL),
('Aloxi',145.00,'07-02-2014',NULL);

-- -------------------------------------------------------------------------------------
-- Values for prescription
-- -------------------------------------------------------------------------------------
insert into dbo.prescription
(pat_id, med_id, pre_date, pre_dosage, pre_num_refills, pre_notes)
values
(1,1,'2011-12-23','take one per day','1',NULL),
(1,2,'2011-12-24','take as needed','2',NULL),
(2,3,'2011-12-25','take two before and after dinner','1',NULL),
(2,4,'2011-12-26','take one per day','2',NULL),
(3,5,'2011-12-27','take as needed','1',NULL),
(3,6,'2011-12-28','take two before and after dinner','2',NULL),
(4,7,'2011-12-29','take one per day','1',NULL),
(4,8,'2011-12-30','take as needed','2',NULL),
(5,9,'2011-12-31','take two before and after dinner','1',NULL),
(5,10,'2012-01-01','take one per day','rpn',NULL);

-- -------------------------------------------------------------------------------------
-- Values for physician
-- -------------------------------------------------------------------------------------
insert into dbo.physician
(phy_specialty, phy_fname, phy_lname, phy_street, phy_city, phy_state, phy_zip, phy_phone, phy_fax, phy_email, phy_url, phy_notes)
values
('family medicine','tom','smith','987 peach st','tampa','FL','336101432','9876541245','9998854545','tsmith@gmail.com','tsmithfamilymed.com',NULL),
('internal medicine','steve','williams','963 plum lane','miami','FL','363412143','9656547412','8544742121','swilliams@gmail.com','swilliamsmedicine.com',NULL),
('pediatrician','ronald','burns','645 wave circle','orlando','FL','332142314','9657894565','8457411147','rburns@gmail.com','rburnspediatrics.com',NULL),
('psychiatrist','pete','roger','1233 stadium lane','orlando','FL','332142324','7418529999','3213216565','peteroger@gmail.com','progerpysch.com',NULL),
('dermatology','dave','roger','654 hard drive','miami','FL','366311234','9876547412','6546565541','droger@gmail.com','drogerderma.com',NULL),
('anesthesiology','mike','jordan','65464 stallium dr','tallahassee','FL','366311234','6546544545','9639633699','Mjordan@gmail.com','mjordan.com',NULL),
('cardiovascular surgery','ronald','reagan','987 biscayne bay','miami','FL','366311234','3057895412','8528527411','rreagan@gmail.com','rreagancardio.com',NULL),
('cancer surgery','penny','hardaway','8798 collins ave','miami','FL','366311234','3054441414','9876542222','phardaway@gmail.com', 'phardawaysurgery.com',NULL),
('gynecology','kevin','durant','9876 washington ave', 'miami','FL','366311234','3057414125','7897894444','kdurant@gmail.com','kdurantgyn.com',NULL),
('gastroenterology','pat','thomas','3243 Jefferson st','tampa','FL','366311234','8135412541','5554446565','pthomas@gmail.com','pthomasgas.com', NULL);

-- -------------------------------------------------------------------------------------
-- Values for treatment
-- -------------------------------------------------------------------------------------
insert into dbo.treatment
(trt_name, trt_price, trt_notes)
values
('knee replacement',2000.00,NULL),
('heart transplant',130000.00,NULL),
('hip replacement',40000.00,NULL),
('tonsils removed',5000.00,NULL),
('skin graft',2000.00,NULL),
('breast enhancement',20000.00,NULL),
('septorhinoplasty',6000.00,NULL),
('kidney transplant',120000.00,NULL),
('shoulder surgery',18000.00,NULL),
('appendix removal',3000.00,NULL);

-- -------------------------------------------------------------------------------------
-- Values for patient_treatment
-- -------------------------------------------------------------------------------------
insert into dbo.patient_treatment
(pat_id, phy_id, trt_id, ptr_date, ptr_start, ptr_end, ptr_results, ptr_notes)
values
(1,10,5,'2011-12-23','07:08:09','10:12:15','success patient is fine',NULL),
(1,9,6,'2011-12-24','08:08:09','11:12:15','complications patient will repeat procedure at a later time',NULL),
(2,8,7,'2011-12-25','09:08:09','12:12:15','died during surgery',NULL),
(2,7,8,'2011-12-26','10:08:09','13:12:15','success patient is fine', NULL),
(2,6,9,'2011-12-27','11:08:09','14:12:15','complications patient will repeat procedure at a later time',NULL),
(3,5,10,'2011-12-28','12:08:09','15:12:15', 'died during surgery',NULL),
(3,4,1,'2011-12-29','13:08:09','16:12:15','success patient is fine',NULL),
(4,3,2,'2011-12-30','14:08:09','17:12:15','complications patient will repeat procedure at a later time',NULL),
(4,2,3,'2011-12-31','15:08:09','18:12:15','removed wrong one',NULL),
(5,1,4,'2012-01-01','16:08:09','19:12:15','success patient is fine',NULL);

-- -------------------------------------------------------------------------------------
-- Values for administration_lu
-- -------------------------------------------------------------------------------------
insert into dbo.administration_lu
(pre_id, ptr_id)
values
(10,5),(9,6),(8,7),(7,8),(6,9),(5,10),(4,9),(3,8),(2,7),(1,6);

-- enable constraints
exec sp_msforeachtable "alter table ? with check check constraint all"

select * from dbo.patient;
select * from dbo.medication;
select * from dbo.prescription;
select * from dbo.physician;
select * from dbo.treatment;
select * from dbo.patient_treatment;
select * from dbo.administration_lu;

-- -------------------------------------------------------------------------------------
use jep18d;
go

begin transaction;
    select pat_fname, pat_lname, pat_notes, med_name, concat('$', med_price) as med_price, med_shelf_life, pre_dosage,pre_num_refills
    from dbo.medication m
    join dbo.prescription pr on m.med_id = pr.med_id
    join dbo.patient p on pr.pat_id = p.pat_id
    order by med_price desc;
commit;

-- -------------------------------------------------------------------------------------
use jep18d;
go

if object_id (N'dbo.v_physician_patient_treatments',N'V') is not null
drop view dbo.v_physician_patient_treatments;
go

create view dbo.v_physician_patient_treatments as
    select phy_fname, phy_lname, trt_name, concat('$', trt_price) as trt_price, ptr_results, ptr_date, ptr_start, ptr_end
    from physician p, patient_treatment pt, treatment t
    where p.phy_id = pt.phy_id
    and pt.trt_id = t.trt_id;
go
-- SQl Server no order by in views
select * from v_physician_patient_treatments order by trt_price desc;
go

select * from information_schema.tables;
go

-- -------------------------------------------------------------------------------------
use jep18d;
go

if object_id ('dbo.AddRecord',) is not null
drop procedure dbo.AddRecord;
go

create procedure dbo.AddRecord
(
    @patid smallint,
    @phyid smallint,
    @trtid smallint,
    @ptrdate date, 
    @ptrstart time,
    @ptrend time,
    @ptrresults varchar(255)
    @ptrnotes varchar(255)
) as
    select * from dbo.v_physician_patient_treatments;

    insert into dbo.patient_treatment
    (pat_id, phy_id, trt_id, ptr_date, ptr_start, ptr_end, ptr_results, ptr_notes)
    values
    (@patid, @phyid, @trtid, @ptrdate, @ptrstart, @ptrend, @ptrresults, @ptrnotes);
    select * from dbo.v_physician_patient_treatments;
go

exec AddRecord(5,5,5, '2013-04-23', '11:00:00', '12:30:00', 'released', 'ok');

-- -------------------------------------------------------------------------------------
begin transaction;
    select * from dbo.administration_lu;
    delete from dbo.administration_lu where pre_id = 5 and ptr_id=10;
    select * from dbo.administration_lu;
commit;

-- -------------------------------------------------------------------------------------
use jep18d
go

if object_id ('dbo.UpdatePatient') is not null
drop view dbo.UpdatePatient;
go

create procedure dbo.UpdatePatient
(
    @patid smallint,
    @patstreet varchar(30),
    @patcity varchar(30),
    @patstate char(2),
    @patzip char(9),
    @patphone bigint,
    @patemail varchar(100),
    @patnotes varchar(45)
) as
    select * from dbo.patient
    
    update dbo.patient
    set
    pat_street = @patstreet
    pat_city = @patcity
    pat_state = @patstate
    pat_zip = @patzip
    pat_phone = @patphone
    pat_email = @patemail
    pat_notes = @patnotes
    where pat_id = @patid;

select * from dbo.patient;
go

exec UpdatePatient(3,'1600 Pennsylvania Avenue NW','Washington','DC','205001234',2024561111,'comments@whitehouse.gov','Was an IT developer--got a demotion!')

-- -------------------------------------------------------------------------------------
exec sp_help 'dbo.patient_treatment';
alter table dbo.patient_treatment add
ptr_prognosis varchar(255) null default 'testing';
exec sp_help 'dbo.patient_treatment';

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------
use jep18d;
go

if object_id('trgAfterInsertEmp') is not null
drop trigger trgAfterInsertEmp;
go

create trigger trgAfterInsertEmp on dbo.employee
after insert
as
    declare @empid int;
    declare @empsal decimal(8,2);
    declare @audit_action varchar(100);
    declare @empnotes varchar(255);

    select @empid = i.emp_id from inserted i;
    select @empsal = i.emp_salary from inserted i;
    set @audit_action= "inserted employee -- After Insert Trigger.";
    select @empnotes = i.emp_notes from inserted i;

    insert into employee_hist
    (emp_id, eht_date, eht_salary, eht_action, eht_notes)
    values
    (@empid, getdate(), @empsal, @audit_action, @empnotes);
go

insert into employee
(emp_fname, emp_lname, emp_salary, emp_notes)
values
('jack', 'smith', 75000, 'small raise')
