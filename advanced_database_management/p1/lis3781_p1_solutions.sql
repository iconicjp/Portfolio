select 'drop, create, use database, create tables, display data:' as '';
do sleep(5);

drop database if exists jep18d;
create database if not exists jep18d;
show warnings;
use jep18d;

-- -----------------------------------------------------------------------------
-- person
-- -----------------------------------------------------------------------------
drop table if exists person;
create table if not exists person
(
    per_id smallint unsigned not null auto_increment,
    per_ssn binary(64) null,
    per_salt binary(64) null comment '*demo only- do not use *salt* in name',
    per_fname varchar(30) not null,
    per_lname varchar(30) not null,
    per_street varchar(30) not null,
    per_city varchar(30) not null,
    per_state char(2) not null,
    per_zip varchar(9) not null,
    per_email varchar(100) not null,
    per_dob date not null,
    per_type enum('a', 'c', 'j') not null comment 'a: attorney, c: client, j: judge',
    per_notes varchar(255) null,
    primary key (per_id),
    unique index ux_per_ssn (per_ssn asc)
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- attorney
-- -----------------------------------------------------------------------------
drop table if exists attorney;
create table if not exists attorney
(
    per_id smallint unsigned not null,
    aty_start_date date not null,
    aty_end_date date null,
    aty_hourly_rate decimal(5,2) not null,
    aty_years_in_practice tinyint not null,
    aty_notes varchar(255) null default null,

    primary key (per_id),

    index idx_per_id(per_id asc),

    constraint fk_attorney_person
    foreign key (per_id)
    references person (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- client
-- -----------------------------------------------------------------------------
drop table if exists `client`;
create table if not exists client
(
    per_id smallint unsigned not null,
    cli_notes varchar(255) null default null,

    primary key (per_id),

    index idx_per_id(per_id asc),

    constraint fk_client_person
    foreign key (per_id)
    references person (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- court
-- -----------------------------------------------------------------------------
drop table if exists court;
create table if not exists court
(
    crt_id tinyint unsigned not null auto_increment,
    crt_name varchar(45) not null,
    crt_street varchar(30) not null,
    crt_city varchar(30) not null,
    crt_state char(2) not null,
    crt_zip int(9) not null,
    crt_phone bigint not null,
    crt_email varchar(100) not null,
    crt_url varchar(100) not null,
    crt_notes varchar(255) null,

    primary key (crt_id)
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- judge
-- -----------------------------------------------------------------------------
drop table if exists judge;
create table if not exists judge
(
    per_id smallint unsigned not null,
    crt_id tinyint unsigned null default null,
    jud_salary decimal(8,2) not null,
    jud_years_in_practice tinyint unsigned not null,
    jud_notes varchar(255) null default null,

    primary key (per_id),
    index idx_per_id(per_id asc),
    index idx_crt_id (crt_id asc),

    constraint fk_judge_person
    foreign key (per_id)
    references person (per_id)
    on delete no action
    on update cascade,

    constraint fk_judge_court
    foreign key (crt_id)
    references court (crt_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- judge_hist
-- -----------------------------------------------------------------------------
drop table if exists judge_hist;
create table if not exists judge_hist
(
    jhs_id smallint unsigned not null auto_increment,
    per_id smallint unsigned not null,
    jhs_crt_id tinyint null,
    jhs_date timestamp not null default current_timestamp(),
    jhs_type enum('i','u','d') not null default 'i',
    jhs_salary decimal(8,2) not null,
    jhs_notes varchar(255) null,
    primary key (jhs_id),

    index idx_per_id (per_id asc),

    constraint fk_judge_hist_judge
    foreign key (per_id)
    references judge (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- case
-- -----------------------------------------------------------------------------
drop table if exists `case`;
create table if not exists `case`
(
    cse_id smallint unsigned not null auto_increment,
    per_id smallint unsigned not null,
    cse_type varchar(45) not null,
    cse_description text not null,
    cse_start_date date not null,
    cse_end_date date null,
    cse_notes varchar(255) null,

    primary key (cse_id),

    index idx_per_id (per_id asc),

    constraint fk_court_case_judge
    foreign key (per_id)
    references judge (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- bar
-- -----------------------------------------------------------------------------
drop table if exists bar;
create table if not exists bar
(
    bar_id tinyint unsigned not null auto_increment,
    per_id smallint unsigned not null,
    bar_name varchar(45) not null,
    bar_notes varchar(255) null,

    primary key (bar_id),

    index idx_per_id (per_id asc),

    constraint fk_bar_attorney
    foreign key (per_id)
    references attorney (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- specialty
-- -----------------------------------------------------------------------------
drop table if exists specialty;
create table if not exists specialty
(
    spc_id tinyint unsigned not null auto_increment,
    per_id smallint unsigned not null,
    spc_type varchar(45) not null,
    spc_notes varchar(255) null,

    primary key (spc_id),

    index idx_per_id (per_id asc),

    constraint fk_specialty_attorney
    foreign key (per_id)
    references attorney (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- assignment
-- -----------------------------------------------------------------------------
drop table if exists assignment;
create table if not exists assignment
(
    asn_id smallint unsigned not null auto_increment,
    per_cid smallint unsigned not null,
    per_aid smallint unsigned not null,
    cse_id smallint unsigned not null,
    asn_notes varchar(255) null,

    primary key (asn_id),

    index idx_per_cid (per_cid asc),
    index idx_per_aid (per_aid asc),
    index idx_cse_id (cse_id asc),

    unique index ux_per_cid_per_aid_cse_id (per_cid asc, per_aid asc, cse_id asc),

    constraint fk_assign_case
    foreign key (cse_id)
    references `case` (cse_id)
    on delete no action
    on update cascade,

    constraint fk_assign_client
    foreign key (per_cid)
    references client (per_id)
    on delete no action
    on update cascade,

    constraint fk_assign_attorney
    foreign key (per_aid)
    references attorney (per_id)
    on delete no action
    on update cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- phone
-- -----------------------------------------------------------------------------
drop table if exists phone;
create table if not exists phone
(
    phn_id smallint unsigned not null auto_increment,
    per_id smallint unsigned not null,
    phn_num bigint unsigned not null,
    phn_type enum('c','h','w','f') comment 'cell, home, work, fax',
    phn_notes varchar(255) null,
    primary key (phn_id),

    constraint fk_phone_person
    foreign key (per_id)
    references person (per_id)
    on update cascade
    on delete cascade
)
engine = innodb
default character set = utf8mb4
collate = utf8mb4_0900_ai_ci;

show warnings;

-- -----------------------------------------------------------------------------
-- Person Data
-- -----------------------------------------------------------------------------
start transaction;

insert into person
(per_id, per_ssn, per_salt, per_fname, per_lname, per_street, per_city, per_state, per_zip, per_email, per_dob, per_type, per_notes)
values
(NULL, NULL, NULL, 'Steve', 'Rodgers', '437 Southern Drive', 'Rochester', 'NY', '324402222', 'srodgers@comcast.net', '1923-10-03', 'c', NULL),
(NULL, NULL, NULL, 'Bruce', 'Wayne', '1007 Mountain Drive', 'Gotham', 'NY', '003208440', 'bwayne@knology.net', '1968-03-20', 'c', NULL),
(NULL, NULL, NULL, 'Peter', 'Parker', '20 Ingram Street', 'Ney York', 'NY', '102826234', 'pparker@msn.com', '1988-09-12', 'c', NULL),
(NULL, NULL, NULL, 'Jane', 'Thompson', '13563 Ocean View Drive', 'Seattle', 'WA', '032084409', 'jthompson@gmail.com', '1978-05-08', 'c', NULL),
(NULL, NULL, NULL, 'Debra', 'Steele', '534 Oak Lane', 'Milwaukee', 'WI', '286234178', 'dsteele@verizon.net', '1994-07-19', 'c', NULL),
(NULL, NULL, NULL, 'Tony', 'Stark', '332 Palm Avenue', 'Malibu', 'CA', '902638332', 'tstark@yahoo.com', '1972-05-04', 'a', NULL),
(NULL, NULL, NULL, 'Hank', 'Pym', '2355 Brown Street', 'Cleveland', 'OH', '022348890', 'hpym@aol.com', '1908-08-28', 'a', NULL),
(NULL, NULL, NULL, 'Bob', 'Best', '4902 Avendale Avenue', 'Scottsdale', 'AZ', '872638332', 'bbest@yahoo.com', '1992-02-10', 'a', NULL),
(NULL, NULL, NULL, 'Sandra', 'Dole', '87912 Lawrence Avenue', 'Atlanta', 'GA', '002348890', 'sdole@gmail.com', '1990-01-26', 'a', NULL),
(NULL, NULL, NULL, 'Ben', 'Avery', '6432 Thunderbird Lane', 'Sioux Falls', 'SD', '562638332', 'bavery@hotmaill.com', '1983-12-24', 'a', NULL),
(NULL, NULL, NULL, 'Arthur', 'Curry', '3304 Euclid Avenue', 'miami', 'FL', '000219932', 'acurry@gmail.com', '1975-12-15', 'j', NULL),
(NULL, NULL, NULL, 'Diana', 'Price', '944 Green Street', 'Las Vegas', 'NV', '332048823', 'dprice@sympatico.com', '1980-08-22', 'j', NULL),
(NULL, NULL, NULL, 'Adam', 'Jurris', '98435 Valencia Drive', 'Gulf Shores', 'AL', '870329932', 'ajurris@gmx.com', '1995-01-31', 'j', NULL),
(NULL, NULL, NULL, 'Judy', 'Sleen', '56343 Rover Court', 'Billings', 'MT', '672048823', 'jsleen@sympatico.com', '1970-03-22', 'j', NULL),
(NULL, NULL, NULL, 'Bill', 'Neiderheim', '43567 Netherlands Blvd', 'South Bend', 'IN', '320219932', 'bneiderheim@comcast.net', '1982-03-13', 'j', NULL);

commit;
-- -----------------------------------------------------------------------------
-- Phone Data
-- -----------------------------------------------------------------------------
start transaction;

insert into phone
(phn_id, per_id, phn_num, phn_type, phn_notes)
values
(NULL, 1, 8032288827, 'c', NULL),
(NULL, 2, 2052338293, 'h', NULL),
(NULL, 4, 1034325598, 'w', 'has 2 office numbers'),
(NULL, 5, 6402338494, 'w', NULL),
(NULL, 6, 5508329842, 'f', 'fax number ont currently working'),
(NULL, 7, 8202052203, 'c', 'prefers home calls'),
(NULL, 8, 4008338294, 'h', NULL),
(NULL, 9, 7654328912, 'w', NULL),
(NULL, 10, 5463721984, 'f', 'work fax number'),
(NULL, 11, 4537821902, 'h', 'prefers cell phone calls'),
(NULL, 12, 7867821902, 'w', 'best number to reach'),
(NULL, 13, 4537821654, 'w', 'call during lunch'),
(NULL, 14, 3721821902, 'c', NULL),
(NULL, 15, 9217821945, 'f', 'use for faxing legal docs');

commit;

-- -----------------------------------------------------------------------------
--  Client Data
-- -----------------------------------------------------------------------------
start transaction;

insert into client
(per_id, cli_notes)
values
(1, NULL),
(2, NULL),
(3, NULL),
(4, NULL),
(5, NULL);

commit;

-- -----------------------------------------------------------------------------
-- Attorney Data
-- -----------------------------------------------------------------------------
start transaction;

insert into attorney
(per_id, aty_start_date, aty_end_date, aty_hourly_rate, aty_years_in_practice, aty_notes)
values
(6, '2006-06-12', NULL, 85, 5, NULL),
(7, '2003-08-20', NULL, 130, 28, NULL),
(8, '2009-12-12', NULL, 70, 17, NULL),
(9, '2008-06-08', NULL, 78, 13, NULL),
(10, '2011-09-12', NULL, 60, 24, NULL);

commit;

-- -----------------------------------------------------------------------------
-- Bar Data
-- -----------------------------------------------------------------------------
start transaction;

insert into bar
(bar_id, per_id, bar_name, bar_notes)
values
(NULL, 6, 'Florida Bar', NULL),
(NULL, 7, 'Alabama Bar', NULL),
(NULL, 8, 'Georgia Bar', NULL),
(NULL, 9, 'Michigan Bar', NULL),
(NULL, 10, 'South Carolina Bar', NULL),
(NULL, 6, 'Montana Bar', NULL),
(NULL, 7, 'Arizona Bar', NULL),
(NULL, 8, 'Nevada Bar', NULL),
(NULL, 9, 'New York Bar', NULL),
(NULL, 10, 'New York Bar', NULL),
(NULL, 6, 'Mississippi Bar', NULL),
(NULL, 7, 'California Bar', NULL),
(NULL, 8, 'Illinois Bar', NULL),
(NULL, 9, 'Indiana Bar', NULL),
(NULL, 10, 'Illinios Bar', NULL),
(NULL, 6, 'Tallahassee Bar', NULL),
(NULL, 7, 'Ocala Bar', NULL),
(NULL, 8, 'Bay County Bar', NULL),
(NULL, 9, 'Cincinatti Bar', NULL);

commit;

-- -----------------------------------------------------------------------------
-- Specialty Data
-- -----------------------------------------------------------------------------
start transaction;

insert into specialty
(spc_id, per_id, spc_type, spc_notes)
values
(NULL, 6, 'business', NULL),
(NULL, 7, 'traffic', NULL),
(NULL, 8, 'bankruptcy', NULL),
(NULL, 9, 'insurance', NULL),
(NULL, 10, 'judicial', NULL),
(NULL, 6, 'environmental', NULL),
(NULL, 7, 'criminal', NULL),
(NULL, 8, 'real estate', NULL),
(NULL, 9, 'malpractice', NULL);

commit;

-- -----------------------------------------------------------------------------
-- Court Data
-- -----------------------------------------------------------------------------
start transaction;

insert into court
(crt_id, crt_name, crt_street, crt_city, crt_state, crt_zip, crt_phone, crt_email, crt_url, crt_notes)
values
(NULL, 'leon county circuit court', '301 south monroe street', 'tallahassee', 'FL', '323035292', '8506065504', 'lccc@us.fl.gov', 'http://www.leoncountycircuitcourt.gov/', NULL),
(NULL, 'leon county traffic court', '1921 thomasville road', 'tallahassee', 'FL', '323035292', '8505774100', 'lctc@us.fl.gov', 'http://www.leoncountytrafficcourt.gov/', NULL),
(NULL, 'florida supreme court', '500 south duval street', 'tallahassee', 'FL', '323035292', '8504880125', 'fsc@us.fl.gov', 'http://www.floridasupremecourt.org/', NULL),
(NULL, 'orange county courthouse', '424 north orange avenue', 'orlando', 'FL', '328012248', '4078362000', 'ooc@us.fl.gov', 'http://www.ninthcircuit.org/', NULL),
(NULL, 'fifth district court of appeal', '300 south beach street', 'daytona beach', 'FL', '321158763', '3862258600', '5dca@us.fl.gov', 'http://www.5dca.org/', NULL);

commit;

-- -----------------------------------------------------------------------------
-- Judge Data
-- -----------------------------------------------------------------------------
start transaction;

insert into judge
(per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
values
(11, 5, 150000, 10, NULL),
(12, 4, 185000, 3, NULL),
(13, 4, 135000, 2, NULL),
(14, 3, 170000, 6, NULL),
(15, 1, 120000, 1, NULL);

commit;

-- -----------------------------------------------------------------------------
-- Judge History Data
-- -----------------------------------------------------------------------------
start transaction;

insert into judge_hist
(jhs_id, per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
values
(NULL, 11, 3, '2009-01-16', 'i', 130000, NULL),
(NULL, 12, 2, '2010-05-27', 'i', 140000, NULL),
(NULL, 13, 5, '2000-01-02', 'i', 115000, NULL),
(NULL, 13, 4, '2005-07-05', 'i', 135000, NULL),
(NULL, 14, 4, '2008-12-09', 'i', 155000, NULL),
(NULL, 15, 1, '2001-03-17', 'i', 120000, 'freshman justice'),
(NULL, 11, 5, '2010-07-05', 'i', 150000, 'assigned to another court'),
(NULL, 12, 4, '2012-10-08', 'i', 165000, NULL),
(NULL, 14, 3, '2009-04-19', 'i', 170000, 'became cheif justice');


commit;

-- -----------------------------------------------------------------------------
-- Case Data
-- -----------------------------------------------------------------------------
start transaction;

insert into `case`
(cse_id, per_id, cse_type, cse_description, cse_start_date, cse_end_date, cse_notes)
values
(NULL, 13, 'civil', 'client says that his logo is being used without his consent to promote a rival business', '2010-09-09', NULL, 'copyright infringement'),
(NULL, 12, 'criminal', 'client is charged with assaulting her husband during an argument', '2009-11-18', NULL, 'assault'),
(NULL, 14, 'civil', 'client broke an ankle while shopping at a local grocery store. no wet floor sign was posted althoug the floor had just been mopped', '2008-05-06', '2008-07-23', 'slip and fall'),
(NULL, 11, 'criminal', 'client was charged with stealing several televisions from his former place of employment. client has a solid alibi', '2011-05-20', NULL, 'grand theft'),
(NULL, 13, 'criminal', 'client charged with posession of 10 grams of cocaine, allgegedly found in his glove box by state police', '2001-06-05', NULL, 'possesion of narcotics'),
(NULL, 14, 'civil', 'client alleges newspaper printed false information about his personal activities while he ran a large laundry business in a small nearby town.', '2007-01-19', '2007-05-20', 'defamation'),
(NULL, 12, 'criminal', 'client charged with the murder of his co-worker over a lovers fued. client has no alibi', '2010-03-20', NULL, 'murder'),
(NULL, 15, 'civil', 'client made the horrible mistake of selecting a degree other than IT and had to declare bankruptcy.', '2012-01-26', '2013-02-28', 'bankruptcy');

commit;

-- -----------------------------------------------------------------------------
-- Assignment Data
-- -----------------------------------------------------------------------------
start transaction;

insert into assignment
(asn_id, per_cid, per_aid, cse_id, asn_notes)
values
(NULL, 1, 6, 7, NULL),
(NULL, 2, 6, 6, NULL),
(NULL, 3, 7, 2, NULL),
(NULL, 4, 8, 2, NULL),
(NULL, 5, 9, 5, NULL),
(NULL, 1, 10, 1, NULL),
(NULL, 2, 6, 3, NULL),
(NULL, 3, 7, 8, NULL),
(NULL, 4, 8, 8, NULL),
(NULL, 5, 9, 8, NULL),
(NULL, 4, 10, 4, NULL);

commit;


-- -----------------------------------------------------------------------------
-- SSNs
-- -----------------------------------------------------------------------------
drop procedure if exists CreatePersonSSN;

delimiter //
create procedure CreatePersonSSN()
begin
    declare x, y INT;
    set x = 1;

    select count(*) into y from person;

    while x <= y do

    -- each person gets unique random salt for hashed and salted random SSN.
        set @salt = RANDOM_BYTES(64);
        set @ran_num = floor(rand()*(999999999 - 111111111 + 1)) + 111111111; -- random 9-digit SSN from 111111111 - 999999999,
        set @ssn = unhex(sha2(concat(@salt, @ran_num), 512)); -- every SSN is unique in value and salt (hopefully...!?)

        update person
        set per_ssn = @ssn, per_salt = @salt
        where per_id = x;

        set x = x + 1;

    end while;

end//
delimiter ;

call CreatePersonSSN();

show warnings;

select 'show populated per_ssn fields after calling stored proc' as '';
select per_id, length(per_ssn) from person order by per_id;
do sleep(5);

drop procedure if exists CreatePersonSSN;

-- -----------------------------------------------------------------------------
-- display data
-- -----------------------------------------------------------------------------
select 'person table' as '';
select * from person;
do sleep(5);

select 'phone table' as '';
select * from phone;
do sleep(5);

select 'client table' as '';
select * from `client`;
do sleep(5);

select 'attorney table' as '';
select * from attorney;
do sleep(5);

select 'specialty table' as '';
select * from specialty;
do sleep(5);

select 'bar table' as '';
select * from bar;
do sleep(5);

select 'court table' as '';
select * from court;
do sleep(5);

select 'judge table' as '';
select * from judge;
do sleep(5);

select 'judge_hist table' as '';
select * from judge_hist;
do sleep(5);

select 'case table' as '';
select * from `case`;
do sleep(5);

select 'assignment table' as '';
select * from assignment;
do sleep(5);

-- ----------------- for debugging purposes ----------------------
-- select 'can use exit for debugging' as '';
-- exit

-- -----------------------------------------------------------------------------
-- ###################### Reports ##############################################
-- -----------------------------------------------------------------------------
/*
1. Create a view that displays attorneys’ *full* names, *full* addresses, ages,
hourly rates, the bar names that they’ve passed, as well as their specialties,
sort by attorneys’ last names.
*/
-- -----------------------------------------------------------------------------
drop view if exists v_attorney_info;

create view v_attorney_info as
    select concat(per_lname, ", ", per_fname) as name,
    concat(per_street, ", ", per_city, ", ", per_state, " ", per_zip) as address,
    timestampdiff(year, per_dob, now()) as age,
    concat('$', format(aty_hourly_rate, 2)) as hourly_rate,
    bar_name, spc_type
    from person
    natural join attorney
    natural join bar
    natural join specialty
    order by per_lname;

select 'display view v_attorney_info' as '';
select * from v_attorney_info;
 do sleep(5);

-- -----------------------------------------------------------------------------
/*
2. Create a stored procedure that displays how many judges were born in each
month of the year, sorted by month.
*/
-- -----------------------------------------------------------------------------
drop procedure if exists sp_num_judges_born_by_month;
delimiter //
create procedure sp_num_judges_born_by_month()
begin
    select month(per_dob) as month, monthname(per_dob) as month_name, count(*) as count
    from person
    natural join judge
    group by month_name
    order by month;
END //
DELIMITER ;

select 'calling sp_num_judges_born_by_month()' as '';

call sp_num_judges_born_by_month();
do sleep(5);

-- -----------------------------------------------------------------------------
/*
3. Create a stored procedure that displays *all* case types and descriptions,
as well as judges’ *full*names, *full* addresses, phone numbers, years in
practice, for cases that they presided over, withtheir start and end dates,
sort by judges’ last names.
*/
-- -----------------------------------------------------------------------------
drop procedure if exists sp_cases_and_judges;

delimiter //
create procedure sp_cases_and_judges()
begin
    select per_id, cse_id, cse_type, cse_description,
    concat(per_fname," ", per_lname) as name,
    concat('(',substring(phn_num, 1, 3),')', substring(phn_num, 4,3),'-',substring(phn_num,7,4)) as judge_office_num,
    phn_type, jud_years_in_practice, cse_start_date, cse_end_date
    from person natural join judge natural join `case` natural join phone
    where per_type = 'j'
    order by per_lname;
end //
delimiter ;

select 'calling sp_cases_and_judges()' as '';
call sp_cases_and_judges();
do sleep(5);

-- -----------------------------------------------------------------------------
/*
4. Create a trigger that automatically adds a record to the judge history
table for every record addedto the judge table.
*/
-- -----------------------------------------------------------------------------
select 'show person data before adding person' as '';
select per_id, per_fname, per_lname from person;
do sleep(5);

insert into person
(per_id, per_ssn, per_fname, per_lname, per_street, per_city, per_state, per_zip, per_email, per_dob, per_type, per_notes)
values
(NULL, unhex(sha2(000000000, 512)), 'Bobby', 'Sue', '123 Main St', 'Panama City Beach', 'FL', 324530221, 'bsue@fl.gov', '1962-05-16', 'j', 'new district judge');

select 'show person data after adding person' as '';
select per_id, per_fname, per_lname from person;
do sleep(5);

select 'show judge and judge_hist before trg_judge_history_after_insert fires' as '';
select * from judge;
select * from judge_hist;
do sleep(5);

drop trigger if exists trg_judge_history_after_insert;

delimiter //
create trigger trg_judge_history_after_insert after insert on judge
for each row
begin
    insert into judge_hist
    (per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
    values
    (NEW.per_id, NEW.crt_id, current_timestamp(), 'i', NEW.jud_salary, concat("modifying user: ", user(), " Notes:", NEW.jud_notes));
end //
delimiter ;

select 'fire trigger by inserting into judge table' as '';
do sleep(5);

insert into judge
(per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
values
(16, 3,175000,31, 'transferred from neighboring jurisdiction');

select 'show judge and judge_hist after trg_judge_history_after_insert fires' as '';
select * from judge;
select * from judge_hist;
do sleep(5);

-- -----------------------------------------------------------------------------
/*
5. Create a trigger that automatically adds a record to the judge history
table for every recordmodified in the judge table.
*/
-- -----------------------------------------------------------------------------
select 'show judge and judge_hist before trg_judge_history_after_update fires' as '';
select * from judge;
select * from judge_hist;
do sleep(5);

drop trigger if exists trg_judge_history_after_update;

delimiter //
create trigger trg_judge_history_after_update after insert on judge
for each row
begin
    insert into judge_hist
    (per_id, jhs_crt_id, jhs_date, jhs_type, jhs_salary, jhs_notes)
    values
    (NEW.per_id, NEW.crt_id, current_timestamp(), 'u', NEW.jud_salary, concat("modifying user: ", user(), " Notes:", NEW.jud_notes));
end //
delimiter ;

select 'fire trigger by updating judge entry' as '';
do sleep(5);

update judge
set jud_salary = 190000, jud_notes = 'senior justice'
where per_id = 16;

select 'show judge and judge_hist after trg_judge_history_after_update fires' as '';
select * from judge;
select * from judge_hist;
do sleep(5);

-- -----------------------------------------------------------------------------
/*
6. Create a one-time event that executes one hour following its creation, the
event should add ajudge record (one more than the required five records),
have the event call a stored procedure thatadds the record
(name it one_time_add_judge).
*/
-- -----------------------------------------------------------------------------
drop procedure if exists sp_add_judge_record;

delimiter //
create procedure sp_add_judge_record()
begin
    insert into judge
    (per_id, crt_id, jud_salary, jud_years_in_practice, jud_notes)
    values
    (6, 1, 110000,0, concat("New judge was former attorney. Modifying event creator: ", current_user()));
end //
delimiter ;

select '1) check event_scheduler' as '';
show variables LIKE 'event_scheduler';
do sleep(5);

select '2) if not on, turn it on ' as '';
SET GLOBAL event_scheduler = ON;

select '3) recheck event_scheduler' as '';
show variables LIKE 'event_scheduler';
do sleep(5);

select 'Demo: use sp to add judge record after 5 seconds.' as '';
do sleep(5);

select 'show judge/judge_hist before one_time_add_judge fires' as '';
select * from judge;
select * from judge_hist;
do sleep(5);

drop event if exists one_time_add_judge;

delimiter //
create event one_time_add_judge
on schedule
    at now() + interval 5 second
comment 'adds a judge record only 1 time'
do
begin
call sp_add_judge_record();
end//
delimiter ;

select 'show events from jep18d;' as '';
show events from jep18d;
do sleep(5);

select 'show state of event scheduler:' as '';
show processlist;
do sleep(5);

select 'show judge/judge_hist data after one_time_add_judge fires' as '';
select * from judge;
select * from judge_hist;
do sleep(5);

-- -----------------------------------------------------------------------------
/*
XC. Create a scheduled event that will run every two months, beginning in three weeks,
 and runs for thenext four years, starting from the creation date. The event should not
  allow more than the first 100judge histories to be stored, thereby removing all
   others (name it remove_judge_history).
*/
-- -----------------------------------------------------------------------------
drop event if exists remove_judge_history;

delimiter //
create event remove_judge_history
on schedule
    every 2 month
starts now() + interval 3 week
ends now() + interval 4 year
comment 'keeps only the first 100 judge records'
do
begin
    delete from judge_hist where jhs_id > 100;
end//
delimiter ;
