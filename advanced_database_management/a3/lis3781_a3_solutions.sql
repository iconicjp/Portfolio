set define off

drop sequence seq_cus_id;
create sequence seq_cus_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table customer cascade constraints purge;
create table customer
(
    cus_id number(3,0) not null,
    cus_fname varchar2(15) not null,
    cus_lname varchar2(30) not null,
    cus_street varchar2(30) not null,
    cus_city varchar2(30) not null,
    cus_state char(2) not null,
    cus_zip number(9) not null,
    cus_phone number(10) not null,
    cus_email varchar2(100),
    cus_balance number(7,2),
    cus_notes varchar2(255),
    constraint pk_customer primary key(cus_id)
);

drop sequence seq_com_id;
create sequence seq_com_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table commodity cascade constraints purge;
create table commodity
(
    com_id number not null,
    com_name varchar2(20),
    com_price number(8,2) not null,
    com_notes varchar2(255),
    constraint pk_commodity primary key (com_id),
    constraint uk_com_name unique(com_name)
);

-- select * from user_cons_columns where table_name = tn;
-- select * from user_constraints

drop sequence seq_ord_id;
create sequence seq_ord_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table "order" cascade constraints purge;
create table "order"
(
    ord_id number(4,0) not null,
    cus_id number,
    com_id number,
    ord_num_units number(5,0) not null,
    ord_total_cost number(8,2) not null,
    ord_notes varchar2(255),
    constraint pk_order primary key (ord_id),
    constraint fk_order_customer
    foreign key (cus_id)
    references customer(cus_id),
    constraint fk_order_commodity
    foreign key (com_id)
    references commodity(com_id),
    constraint ck_unit check(ord_num_units > 0),
    constraint ck_total check(ord_total_cost > 0)
);

insert into customer values(seq_cus_id.nextval, 'Beverly', 'Davis', '123 Main St.', 'Detroit', 'MI', 48252, 3135551212, 'bdavis@aol.com', 11500.99, 'recently moved');
insert into customer values(seq_cus_id.nextval, 'Stephen', 'Taylor', '456 Elm St', 'St. Louis', 'MO', 57252, 4185551212, 'staylor@comcast.net', 25.01, null);
insert into customer values(seq_cus_id.nextval, 'Donna', 'Carter', '789 Peach Ave.', 'Los Angeles', 'CA', 48252, 3135551212, 'dcarter@wow.com', 300.99, 'returning customer');
insert into customer values(seq_cus_id.nextval, 'Robert', 'Silverman', '857 Wilbur Rd.', 'Phoenix', 'AZ', 25278, 4805551212, 'rsilverman@aol.com', null, null);
insert into customer values(seq_cus_id.nextval, 'Sally', 'Victors', '534 Holler Way', 'Charleston', 'WV', 78345, 9045551212, 'svictors@wow.com', 500.76, 'new customer');

insert into commodity values(seq_com_id.nextval, 'DVD & Player', 109.00, null);
insert into commodity values(seq_com_id.nextval, 'Cereal', 3.00, 'sugarfree');
insert into commodity values(seq_com_id.nextval, 'Scrabble', 29.00, 'original');
insert into commodity values(seq_com_id.nextval, 'Licorice', 1.89, null);
insert into commodity values(seq_com_id.nextval, 'Tums', 2.45, 'antacid');

commit;

insert into "order" values(seq_ord_id.nextval, 1,2,50,200,null);
insert into "order" values(seq_ord_id.nextval, 2,3,30,100,null);
insert into "order" values(seq_ord_id.nextval, 3,1,6,654,null);
insert into "order" values(seq_ord_id.nextval, 5,4,24,972,null);
insert into "order" values(seq_ord_id.nextval, 3,5,7,300,null);
insert into "order" values(seq_ord_id.nextval, 1,2,5,15,null);
insert into "order" values(seq_ord_id.nextval, 2,3,40,57,null);
insert into "order" values(seq_ord_id.nextval, 3,1,4,300,null);
insert into "order" values(seq_ord_id.nextval, 5,4,14,770,null);
insert into "order" values(seq_ord_id.nextval, 3,5,15,883,null);

commit;

select * from customer;
select * from commodity;
select * from "order";

-- ----------------------------------------------------------------------------------------------------------------------------------------
--  1. Display Oracle version (one method).
-- ---------------------------------------------------------------------------
select * from product_component_version;

-- ---------------------------------------------------------------------------
--  2. Display Oracle version (another method).
-- ---------------------------------------------------------------------------
select * from v$version;

-- ---------------------------------------------------------------------------
--  3. Display current user.
-- ---------------------------------------------------------------------------
SELECT user from dual;

-- ---------------------------------------------------------------------------
--  4. Display current day/time (formatted, and displaying AM/PM).
-- ---------------------------------------------------------------------------
select to_char(sysdate, 'MM-DD-YYYY HH12:MI:SS AM') "NOW" from dual;

-- ---------------------------------------------------------------------------
--  5. Display your privileges.
-- ---------------------------------------------------------------------------
select * from user_sys_privs;

-- ---------------------------------------------------------------------------
--  6. Display all user tables.
-- ---------------------------------------------------------------------------
select object_name from user_objects where object_type = 'TABLE';

-- ---------------------------------------------------------------------------
--  7. Display structure for each table.
-- ---------------------------------------------------------------------------
describe customer;
describe commodity;
describe "order";

-- ---------------------------------------------------------------------------
--  8. List the customer number, last name, first name, and e-mail of every customer.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, cus_email from customer;

-- ---------------------------------------------------------------------------
--  9. Same query as above, include street, city, state, and sort by state in descending order, and last name in ascending order.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, cus_street, cus_city, cus_state, cus_email
from customer order by cus_state desc, cus_lname;

-- ---------------------------------------------------------------------------
--  10. What is the full name of customer number 3? Display last name first.
-- ---------------------------------------------------------------------------
select cus_lname, cus_fname from customer where cus_id = 3;

-- ---------------------------------------------------------------------------
--  11. Find the customer number, last name, first name, and current balance for every customer whose balance exceeds $1,000, sorted by largest to smallest balances.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, cus_balance from customer where cus_balance > 1000 order by cus_balance desc;

-- ---------------------------------------------------------------------------
--  12.  List the name of every commodity, and its price (formatted to two decimal places, displaying $ sign), sorted by smallest to largest price.

-- ---------------------------------------------------------------------------
select com_name, to_char(com_price, 'L99,999.00') as price_formatted
from commmodity order by com_price;

-- ---------------------------------------------------------------------------
--  13. Display all customers’ first and last names, streets, cities, states, and zip codes as follows (ordered by zip code descending).
-- ---------------------------------------------------------------------------
select (cus_lname || ', ' || cus_fname) as name,
(cus_street || ', ' || cus_city || ', ' || cus_state || ' ' || cus_zip) as address
from customer order by cus_zip desc;

-- ---------------------------------------------------------------------------
--  14. List all orders not including cereal--use subquery to find commodity id for cereal.
-- ---------------------------------------------------------------------------
select * from "order"
where com_id not in (select com_id from commodity where lower(com_name) = 'cereal');

-- ---------------------------------------------------------------------------
--  15. List the customer number, last name, first name, and balance for every customer whose balance is between $500 and $1,000, (format currency to two decimal places, displaying $ sign).
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, to_char(cus_balance, 'L99,999.99') as balance_formatted
from customer
where cus_balance between 500 and 1000;

-- ---------------------------------------------------------------------------
--  16. List the customer number, last name, first name, and balance for every customer whose balance is greater than the average balance, (format currency to two decimal places, displaying $ sign).
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, to_char(cus_balance, 'L99,999.99') as balance_formatted
from customer
where cus_balance > (select avg(cus_balance) from customer);

-- ---------------------------------------------------------------------------
--  17. List the customer number, name, and *total* order amount for each customer sorted in descending *total* order amount, (format currency to two decimal places, displaying $ sign), and include an alias “total orders” for the derived attribute.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer natural join "order"
grorup by cus_id, cus_lname, cus_fname
order by sum(ord_total_cost) desc;

-- ---------------------------------------------------------------------------
--  18.  List the customer number, last name, first name, and complete address of every customer who lives on a street with "Peach" anywhere in the street name.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, cus_street, cus_city, cus_state, cus_zip
from customer where cus_street like '%Peach%';

-- ---------------------------------------------------------------------------
--  19.  List the customer number, name, and *total* order amount for each customer whose *total* order amount is greater than $1500, for each customer sorted in descending *total* order amount, (format currency to two decimal places, displaying $ sign), and include an alias “total orders” for the derived attribute.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer natural join "order"
group by cus_id, cus_lname, cus_fname
having sum(ord_total_cost) > 1500
order by sum(ord_total_cost) desc;

-- ---------------------------------------------------------------------------
--  20. List the customer number, name, and number of units ordered for orders with 30, 40, or 50 units ordered.
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, ord_num_units
from customer natural join "order"
where ord_num_units in (30, 40, 50);

-- ---------------------------------------------------------------------------
--  21. Using EXISTS operator: List customer number, name, number of orders, minimum, maximum, and sum of their order total cost, only if there are 5 or more customers in the customer table, (format currency to two decimal places, displaying $ sign).
-- ---------------------------------------------------------------------------
select cus_id, cus_lname, cus_fname, count(*) as "number of orders",
ord_num_units, to_char(min(ord_total_cost), 'L99,999.99') as "minimum order cost",
to_char(max(ord_total_cost), 'L99,999.99') as "maximum order cost",
to_char(sum(ord_total_cost), 'L99,999.99') as "Total orders"
from customer natural join "order"
where exists
(select count(*) from customer having count(*) >= 5)
group by cus_id, cus_lname, cus_fname;

-- ---------------------------------------------------------------------------
--  22. Find aggregate values for customers: (Note, difference between count(*) and count(cus_balance), one customer does not have a balance.)
-- ---------------------------------------------------------------------------
select count(*), count(cus_balance), sum(cus_balance), avg(cus_balance), max(cus_balance), min(cus_balance)
from customer

-- ---------------------------------------------------------------------------
--  23. Find "how many" *unique* customers have orders.
-- ---------------------------------------------------------------------------
select cus_id from "order";

select distinct cus_id from "order";

select count(distinct cus_id) from "order";

-- ---------------------------------------------------------------------------
--  24. List the customer number, name, commodity name, order number, and order amount for each customer order, sorted in descending order amount, (format currency to two decimal places, displaying $ sign), and include an alias “order amount” for the derived attribute.
-- ---------------------------------------------------------------------------
select cu.cus_id, cus_lname, cus_fname, com_name, ord_id, to_char(ord_total_cost, 'L99,999.99') as "order amount"
from customer cu join "order" o on cu.cus_id = o.cus_id
join commodity co on o.com_id = co.com_id
order by ord_total_cost desc;

-- ---------------------------------------------------------------------------
--  25. Modify prices for DVD players to $99.
-- ---------------------------------------------------------------------------
set define off

select * from commodity;

update commodity set com_price = 99
where com_name = 'DVD & Player';

select * from commodity;