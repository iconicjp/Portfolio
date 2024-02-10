mysql> drop database if exists  jep18d;
Query OK, 2 rows affected (0.03 sec)

mysql> create database if not exists jep18d;
Query OK, 1 row affected (0.00 sec)

mysql> use jep18d;
Database changed
mysql> -- -----------------------------------------------------------------------------------------
mysql> -- company Table
mysql> -- -----------------------------------------------------------------------------------------
mysql> drop table if exists company;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> create table if not exists company
    -> (
    -> cmp_id int unsigned not null auto_increment,
    -> cmp_type enum('c-corp', 's-corp', 'non-profit-corp', 'llc', 'partnership'),
    -> cmp_street varchar(30) not null,
    -> cmp_city varchar(30) not null,
    -> cmp_state char(2) not null,
    -> cmp_zip char(9) not null,
    -> cmp_phone bigint unsigned not null,
    -> cmp_ytd_sales decimal(10,2) not null comment '12,345,678.90',
    -> cmp_email varchar(100) null,
    -> cmp_url varchar(100) null,
    -> cmp_notes varchar(255) null,
    -> primary key (cmp_id)
    -> )
    -> engine = InnoDB character set utf8mb4 collate utf8mb4_0900_ai_ci;
Query OK, 0 rows affected (0.02 sec)

mysql> show warnings;
Empty set (0.00 sec)

mysql>
mysql> insert into company
    -> values
    -> (null,'c-corp', '507 20th Ave.', 'Seattle', 'WA', '081226749', '2065559857', '12345678.00', null, 'http://nytimes.com', 'company note1'),
    -> (null,'s-corp', '908 W. Capital Way', 'Tacoma', 'WA', '004011298', '2065559482', '34567890.12', null, 'https://guardian.co.uk', 'company note2'),
    -> (null,'non-profit-corp', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '000337845', '2065553412', '56789012.34', null, 'http://twitter.com', 'company note3'),
    -> (null,'llc', '4110 Old Redmond Rd.', 'redmond', 'WA', '000029021', '2065558122', '78901234.56', null, 'http://walmart.com', 'company note4'),
    -> (null,'partnership', '4726 - 11th Ave.', 'Seattle', 'WA', '001051082', '2065551189', '90123456.78', null, 'http://pinterest.com', 'company note5');
Query OK, 5 rows affected (0.00 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql>
mysql> show warnings;
Empty set (0.00 sec)

mysql>
mysql> -- -----------------------------------------------------------------------------------------
mysql> -- customer Table
mysql> -- -----------------------------------------------------------------------------------------
mysql> drop table if exists customer;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> create table if not exists customer
    -> (
    -> cus_id int unsigned not null auto_increment,
    -> cmp_id int unsigned not null,
    -> cus_ssn binary(64) not null,
    -> cus_salt binary(64) not null comment '*ONLY* demo purpose- *DO NOT* use salt in name!',
    -> cus_type enum('loyal', 'discount','impulse', 'need-based', 'wandering'),
    -> cus_first varchar(15) not null,
    -> cus_last varchar(30) not null,
    -> cus_street varchar(30) null,
    -> cus_city varchar(30) null,
    -> cus_state char(2) null,
    -> cus_zip char(9) null,
    -> cus_phone bigint unsigned not null,
    -> cus_email varchar(100) null,
    -> cus_balance decimal (7,2) null comment '12,345.67',
    -> cus_tot_sales decimal (7,2) null,
    -> cus_notes varchar(255) null,
    -> primary key (cus_id),
    ->
    -> unique index uk_cus_ssn (cus_ssn asc),
    -> index ndx_cmp_id (cmp_id asc),
    ->
    -> constraint fk_customer_company
    -> foreign key (cmp_id)
    -> references company (cmp_id)
    -> on update cascade
    -> on delete restrict
    -> )
    ->
    -> engine = InnoDB character set utf8mb4 collate utf8mb4_0900_ai_ci;
Query OK, 0 rows affected (0.04 sec)

mysql> show warnings;
Empty set (0.00 sec)

mysql>
mysql> set @salt = random_bytes(64);
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> insert into customer
    -> values
    -> (null, 2, unhex(sha2(concat(@salt, 000456789),512)), @salt, 'discount', 'wilbur', 'denaway', '23 Billings Gate', 'El Paso', 'TX', '085703412', '2145559857', 'test1@mymail.com', '8391.87', '37642.00', 'customer notes1'),
    -> (null, 3, unhex(sha2(concat(@salt, 001456789),512)), @salt, 'loyal', 'bradford', 'casis', '891 Drift Dr.', 'Stanton', 'TX', '005819045', '2145559482', 'test2@mymail.com', '657.57', '87341.00', 'customer notes2'),
    -> (null, 5, unhex(sha2(concat(@salt, 002456789),512)), @salt, 'impulse', 'valerie', 'lieblong', '421 Calamari Vista', 'Odessa', 'TX', '00621134', '2145553412', 'test3@mymail.com', '8730.23', '92678.00', 'customer notes3'),
    -> (null, 4, unhex(sha2(concat(@salt, 003456789),512)), @salt, 'need-based', 'kathy', 'jeffries', '915 Drive Past', 'Penwell', 'TX', '009135674', '2145558122', 'tes4@mymail.com', '2651.19', '78345.00', 'customer notes4'),
    -> (null, 1, unhex(sha2(concat(@salt, 004456789),512)), @salt, 'wandering', 'steve', 'rogers', '329 Volume Ave.', 'Tarzan', 'TX', '000054426', '2145551189', 'test5@mymail.com', '782.73', '23471.00', 'customer notes5');
Query OK, 5 rows affected (0.00 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql>
mysql> show warnings;
Empty set (0.00 sec)

mysql>
mysql> select * from company;
+--------+-----------------+----------------------+----------+-----------+-----------+------------+---------------+-----------+------------------------+---------------+
| cmp_id | cmp_type        | cmp_street           | cmp_city | cmp_state | cmp_zip   | cmp_phone  | cmp_ytd_sales | cmp_email | cmp_url                | cmp_notes     |
+--------+-----------------+----------------------+----------+-----------+-----------+------------+---------------+-----------+------------------------+---------------+
|      1 | c-corp          | 507 20th Ave.        | Seattle  | WA        | 081226749 | 2065559857 |   12345678.00 | NULL      | http://nytimes.com     | company note1 |
|      2 | s-corp          | 908 W. Capital Way   | Tacoma   | WA        | 004011298 | 2065559482 |   34567890.12 | NULL      | https://guardian.co.uk | company note2 |
|      3 | non-profit-corp | 722 Moss Bay Blvd.   | Kirkland | WA        | 000337845 | 2065553412 |   56789012.34 | NULL      | http://twitter.com     | company note3 |
|      4 | llc             | 4110 Old Redmond Rd. | redmond  | WA        | 000029021 | 2065558122 |   78901234.56 | NULL      | http://walmart.com     | company note4 |
|      5 | partnership     | 4726 - 11th Ave.     | Seattle  | WA        | 001051082 | 2065551189 |   90123456.78 | NULL      | http://pinterest.com   | company note5 |
+--------+-----------------+----------------------+----------+-----------+-----------+------------+---------------+-----------+------------------------+---------------+
5 rows in set (0.00 sec)

mysql> select * from customer;
+--------+--------+------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+------------+-----------+----------+--------------------+----------+-----------+-----------+------------+------------------+-------------+---------------+-----------------+
| cus_id | cmp_id | cus_ssn                                                                                                                            | cus_salt
                                                                           | cus_type   | cus_first | cus_last | cus_street         | cus_city | cus_state | cus_zip   | cus_phone  | cus_email        | cus_balance | cus_tot_sales | cus_notes       |
+--------+--------+------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+------------+-----------+----------+--------------------+----------+-----------+-----------+------------+------------------+-------------+---------------+-----------------+
|      1 |      2 | 0xFC05650A8B4C4D0D59C732E3EF6958BB007BA6451488A945CDF34F7192D5CB2CF8C74AAAF7DDB967248B1B78137D28935482EF72A9CAEB299788CEB8AE161B41 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | discount   | wilbur    | denaway  | 23 Billings Gate   | El Paso  | TX        | 085703412 | 2145559857 | test1@mymail.com |     8391.87 |      37642.00 | customer notes1 |
|      2 |      3 | 0xA9ABD1CFFA64662C1939D03E2FA485B2F5177D6F58E91A4173EEF7E25C93A56E40E9F0BC2E072CD20B1DEA3C17385049112F7618A595B58E82699624A841ADE6 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | loyal      | bradford  | casis    | 891 Drift Dr.      | Stanton  | TX        | 005819045 | 2145559482 | test2@mymail.com |      657.57 |      87341.00 | customer notes2 |
|      3 |      5 | 0x11A237776DB085D466D684D28509B89CA6EFE18AC373849A75582FF8C1263254693BC2C415C4487BE416D4711F660E3072B2E4DCDD7BC9D7FDF7AB7BFE253C63 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | impulse    | valerie   | lieblong | 421 Calamari Vista | Odessa   | TX        | 00621134  | 2145553412 | test3@mymail.com |     8730.23 |      92678.00 | customer notes3 |
|      4 |      4 | 0xEDBB8E6829C1E3BA4B1FA8216F4AEB5158FC950503651016DCA2EE183FC7EFB2CDFA547A417C378035997849663826CE6B057BAC7602C14E0B45EACB99D6D213 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | need-based | kathy     | jeffries | 915 Drive Past     | Penwell  | TX        | 009135674 | 2145558122 | tes4@mymail.com  |     2651.19 |      78345.00 | customer notes4 |
|      5 |      1 | 0x2D28B779EB8ACC5941220AFC8727C57F6F90947A94D5DF8B0CC5034E0370994C4018CEB2E3DB0F6541528EEAD56D6B3AD26F5B3C516017C2B44226FE17F3A3EA | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | wandering  | steve     | rogers   | 329 Volume Ave.    | Tarzan   | TX        | 000054426 | 2145551189 | test5@mymail.com |      782.73 |      23471.00 | customer notes5 |
+--------+--------+------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+------------+-----------+----------+--------------------+----------+-----------+-----------+------------+------------------+-------------+---------------+-----------------+
5 rows in set (0.00 sec)

mysql> -- -----------------------------------------------------------------------------------------
mysql> -- DB Prep
mysql> -- -----------------------------------------------------------------------------------------
mysql> describe mysql.user;
+--------------------------+-----------------------------------+------+-----+-----------------------+-------+
| Field                    | Type                              | Null | Key | Default               | Extra |
+--------------------------+-----------------------------------+------+-----+-----------------------+-------+
| Host                     | char(255)                         | NO   | PRI |                       |       |
| User                     | char(32)                          | NO   | PRI |                       |       |
| Select_priv              | enum('N','Y')                     | NO   |     | N                     |       |
| Insert_priv              | enum('N','Y')                     | NO   |     | N                     |       |
| Update_priv              | enum('N','Y')                     | NO   |     | N                     |       |
| Delete_priv              | enum('N','Y')                     | NO   |     | N                     |       |
| Create_priv              | enum('N','Y')                     | NO   |     | N                     |       |
| Drop_priv                | enum('N','Y')                     | NO   |     | N                     |       |
| Reload_priv              | enum('N','Y')                     | NO   |     | N                     |       |
| Shutdown_priv            | enum('N','Y')                     | NO   |     | N                     |       |
| Process_priv             | enum('N','Y')                     | NO   |     | N                     |       |
| File_priv                | enum('N','Y')                     | NO   |     | N                     |       |
| Grant_priv               | enum('N','Y')                     | NO   |     | N                     |       |
| References_priv          | enum('N','Y')                     | NO   |     | N                     |       |
| Index_priv               | enum('N','Y')                     | NO   |     | N                     |       |
| Alter_priv               | enum('N','Y')                     | NO   |     | N                     |       |
| Show_db_priv             | enum('N','Y')                     | NO   |     | N                     |       |
| Super_priv               | enum('N','Y')                     | NO   |     | N                     |       |
| Create_tmp_table_priv    | enum('N','Y')                     | NO   |     | N                     |       |
| Lock_tables_priv         | enum('N','Y')                     | NO   |     | N                     |       |
| Execute_priv             | enum('N','Y')                     | NO   |     | N                     |       |
| Repl_slave_priv          | enum('N','Y')                     | NO   |     | N                     |       |
| Repl_client_priv         | enum('N','Y')                     | NO   |     | N                     |       |
| Create_view_priv         | enum('N','Y')                     | NO   |     | N                     |       |
| Show_view_priv           | enum('N','Y')                     | NO   |     | N                     |       |
| Create_routine_priv      | enum('N','Y')                     | NO   |     | N                     |       |
| Alter_routine_priv       | enum('N','Y')                     | NO   |     | N                     |       |
| Create_user_priv         | enum('N','Y')                     | NO   |     | N                     |       |
| Event_priv               | enum('N','Y')                     | NO   |     | N                     |       |
| Trigger_priv             | enum('N','Y')                     | NO   |     | N                     |       |
| Create_tablespace_priv   | enum('N','Y')                     | NO   |     | N                     |       |
| ssl_type                 | enum('','ANY','X509','SPECIFIED') | NO   |     |                       |       |
| ssl_cipher               | blob                              | NO   |     | NULL                  |       |
| x509_issuer              | blob                              | NO   |     | NULL                  |       |
| x509_subject             | blob                              | NO   |     | NULL                  |       |
| max_questions            | int unsigned                      | NO   |     | 0                     |       |
| max_updates              | int unsigned                      | NO   |     | 0                     |       |
| max_connections          | int unsigned                      | NO   |     | 0                     |       |
| max_user_connections     | int unsigned                      | NO   |     | 0                     |       |
| plugin                   | char(64)                          | NO   |     | caching_sha2_password |       |
| authentication_string    | text                              | YES  |     | NULL                  |       |
| password_expired         | enum('N','Y')                     | NO   |     | N                     |       |
| password_last_changed    | timestamp                         | YES  |     | NULL                  |       |
| password_lifetime        | smallint unsigned                 | YES  |     | NULL                  |       |
| account_locked           | enum('N','Y')                     | NO   |     | N                     |       |
| Create_role_priv         | enum('N','Y')                     | NO   |     | N                     |       |
| Drop_role_priv           | enum('N','Y')                     | NO   |     | N                     |       |
| Password_reuse_history   | smallint unsigned                 | YES  |     | NULL                  |       |
| Password_reuse_time      | smallint unsigned                 | YES  |     | NULL                  |       |
| Password_require_current | enum('N','Y')                     | YES  |     | NULL                  |       |
| User_attributes          | json                              | YES  |     | NULL                  |       |
+--------------------------+-----------------------------------+------+-----+-----------------------+-------+
51 rows in set (0.00 sec)

mysql> describe mysql.db;
+-----------------------+---------------+------+-----+---------+-------+
| Field                 | Type          | Null | Key | Default | Extra |
+-----------------------+---------------+------+-----+---------+-------+
| Host                  | char(255)     | NO   | PRI |         |       |
| Db                    | char(64)      | NO   | PRI |         |       |
| User                  | char(32)      | NO   | PRI |         |       |
| Select_priv           | enum('N','Y') | NO   |     | N       |       |
| Insert_priv           | enum('N','Y') | NO   |     | N       |       |
| Update_priv           | enum('N','Y') | NO   |     | N       |       |
| Delete_priv           | enum('N','Y') | NO   |     | N       |       |
| Create_priv           | enum('N','Y') | NO   |     | N       |       |
| Drop_priv             | enum('N','Y') | NO   |     | N       |       |
| Grant_priv            | enum('N','Y') | NO   |     | N       |       |
| References_priv       | enum('N','Y') | NO   |     | N       |       |
| Index_priv            | enum('N','Y') | NO   |     | N       |       |
| Alter_priv            | enum('N','Y') | NO   |     | N       |       |
| Create_tmp_table_priv | enum('N','Y') | NO   |     | N       |       |
| Lock_tables_priv      | enum('N','Y') | NO   |     | N       |       |
| Create_view_priv      | enum('N','Y') | NO   |     | N       |       |
| Show_view_priv        | enum('N','Y') | NO   |     | N       |       |
| Create_routine_priv   | enum('N','Y') | NO   |     | N       |       |
| Alter_routine_priv    | enum('N','Y') | NO   |     | N       |       |
| Execute_priv          | enum('N','Y') | NO   |     | N       |       |
| Event_priv            | enum('N','Y') | NO   |     | N       |       |
| Trigger_priv          | enum('N','Y') | NO   |     | N       |       |
+-----------------------+---------------+------+-----+---------+-------+
22 rows in set (0.00 sec)

mysql> describe mysql.tables_priv;
+-------------+-----------------------------------------------------------------------------------------------------------------------------------+------+-----+-------------------+-----------------------------------------------+
| Field       | Type                                                                                                                              | Null | Key | Default           | Extra
                  |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------+------+-----+-------------------+-----------------------------------------------+
| Host        | char(255)                                                                                                                         | NO   | PRI |                   |
                  |
| Db          | char(64)                                                                                                                          | NO   | PRI |                   |
                  |
| User        | char(32)                                                                                                                          | NO   | PRI |                   |                                               |
| Table_name  | char(64)                                                                                                                          | NO   | PRI |                   |
                  |
| Grantor     | varchar(288)                                                                                                                      | NO   | MUL |                   |
                  |
| Timestamp   | timestamp                                                                                                                         | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| Table_priv  | set('Select','Insert','Update','Delete','Create','Drop','Grant','References','Index','Alter','Create View','Show view','Trigger') | NO   |     |                   |
                  |
| Column_priv | set('Select','Insert','Update','References')                                                                                      | NO   |     |                   |
                  |
+-------------+-----------------------------------------------------------------------------------------------------------------------------------+------+-----+-------------------+-----------------------------------------------+
8 rows in set (0.00 sec)

mysql> describe mysql.columns_priv;
+-------------+----------------------------------------------+------+-----+-------------------+-----------------------------------------------+
| Field       | Type                                         | Null | Key | Default           | Extra                                         |
+-------------+----------------------------------------------+------+-----+-------------------+-----------------------------------------------+
| Host        | char(255)                                    | NO   | PRI |                   |                                               |
| Db          | char(64)                                     | NO   | PRI |                   |                                               |
| User        | char(32)                                     | NO   | PRI |                   |                                               |
| Table_name  | char(64)                                     | NO   | PRI |                   |                                               |
| Column_name | char(64)                                     | NO   | PRI |                   |                                               |
| Timestamp   | timestamp                                    | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED on update CURRENT_TIMESTAMP |
| Column_priv | set('Select','Insert','Update','References') | NO   |     |                   |                                               |
+-------------+----------------------------------------------+------+-----+-------------------+-----------------------------------------------+
7 rows in set (0.00 sec)

mysql>
mysql> select * from mysql.user;
+-----------+------------------+-------------+-------------+-------------+-------------+-------------+-----------+-------------+---------------+--------------+-----------+------------+-----------------+------------+------------+--------------+------------+-----------------------+------------------+--------------+-----------------+------------------+------------------+----------------+---------------------+--------------------+------------------+------------+--------------+------------------------+----------+------------------------+--------------------------+----------------------------+---------------+-------------+-----------------+----------------------+-----------------------+------------------------------------------------------------------------+------------------+-----------------------+-------------------+----------------+------------------+----------------+------------------------+---------------------+--------------------------+-----------------+
| Host      | User             | Select_priv | Insert_priv | Update_priv | Delete_priv | Create_priv | Drop_priv | Reload_priv | Shutdown_priv | Process_priv | File_priv | Grant_priv | References_priv | Index_priv | Alter_priv | Show_db_priv | Super_priv | Create_tmp_table_priv | Lock_tables_priv | Execute_priv | Repl_slave_priv | Repl_client_priv | Create_view_priv | Show_view_priv | Create_routine_priv | Alter_routine_priv | Create_user_priv | Event_priv | Trigger_priv | Create_tablespace_priv | ssl_type | ssl_cipher             | x509_issuer              | x509_subject               | max_questions | max_updates | max_connections | max_user_connections | plugin                | authentication_string                                                  | password_expired | password_last_changed | password_lifetime | account_locked | Create_role_priv | Drop_role_priv | Password_reuse_history | Password_reuse_time | Password_require_current | User_attributes |
+-----------+------------------+-------------+-------------+-------------+-------------+-------------+-----------+-------------+---------------+--------------+-----------+------------+-----------------+------------+------------+--------------+------------+-----------------------+------------------+--------------+-----------------+------------------+------------------+----------------+---------------------+--------------------+------------------+------------+--------------+------------------------+----------+------------------------+--------------------------+----------------------------+---------------+-------------+-----------------+----------------------+-----------------------+------------------------------------------------------------------------+------------------+-----------------------+-------------------+----------------+------------------+----------------+------------------------+---------------------+--------------------------+-----------------+
| localhost | mysql.infoschema | Y           | N           | N           | N           | N           | N         | N           | N             | N            | N         | N          | N               | N          | N          | N            | N          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED | N                | 2022-07-27 00:10:29   |              NULL | Y
     | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | mysql.session    | N           | N           | N           | N           | N           | N         | N           | Y             | N            | N         | N          | N               | N          | N          | N            | Y          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED | N                | 2022-07-27 00:10:29   |              NULL | Y
     | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | mysql.sys        | N           | N           | N           | N           | N           | N         | N           | N             | N            | N         | N          | N               | N          | N          | N            | N          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | caching_sha2_password | $A$005$THISISACOMBINATIONOFINVALIDSALTANDPASSWORDTHATMUSTNEVERBRBEUSED | N                | 2022-07-27 00:10:29   |              NULL | Y
     | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | root             | Y           | Y           | Y           | Y           | Y           | Y         | Y           | Y             | Y            | Y         | Y          | Y               | Y          | Y          | Y            | Y          | Y                     | Y                | Y            | Y               | Y                | Y                | Y              | Y                   | Y                  | Y                | Y          | Y            | Y                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | mysql_native_password | *E74858DB86EBA20BC33D0AECAE8A8108C56B17FA                              | N                | 2022-07-27 00:10:34   |              NULL | N
     | Y                | Y              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | user1            | N           | N           | N           | N           | N           | N         | N           | N             | N            | N         | N          | N               | N          | N          | N            | N          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | mysql_native_password | *668425423DB5193AF921380129F465A6425216D0                              | N                | 2024-02-07 17:06:16   |              NULL | N              | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
| localhost | user2            | N           | N           | N           | N           | N           | N         | N           | N             | N            | N         | N          | N               | N          | N          | N            | N          | N                     | N                | N            | N               | N                | N                | N              | N                   | N                  | N                | N          | N            | N                      |          | 0x                     | 0x                       | 0x                         |             0 |           0 |               0 |                    0 | mysql_native_password | *DC52755F3C09F5923046BD42AFA76BD1D80DF2E9                              | N                | 2024-02-07 17:07:10   |              NULL | N
     | N                | N              |                   NULL |                NULL | NULL                     | NULL            |
+-----------+------------------+-------------+-------------+-------------+-------------+-------------+-----------+-------------+---------------+--------------+-----------+------------+-----------------+------------+------------+--------------+------------+-----------------------+------------------+--------------+-----------------+------------------+------------------+----------------+---------------------+--------------------+------------------+------------+--------------+------------------------+----------+------------------------+--------------------------+----------------------------+---------------+-------------+-----------------+----------------------+-----------------------+------------------------------------------------------------------------+------------------+-----------------------+-------------------+----------------+------------------+----------------+------------------------+---------------------+--------------------------+-----------------+
6 rows in set (0.00 sec)

mysql> select * from mysql.db;
+-----------+--------------------+---------------+-------------+-------------+-------------+-------------+-------------+-----------+------------+-----------------+------------+------------+-----------------------+------------------+------------------+----------------+---------------------+--------------------+--------------+------------+--------------+
| Host      | Db                 | User          | Select_priv | Insert_priv | Update_priv | Delete_priv | Create_priv | Drop_priv | Grant_priv | References_priv | Index_priv | Alter_priv | Create_tmp_table_priv | Lock_tables_priv | Create_view_priv | Show_view_priv | Create_routine_priv | Alter_routine_priv | Execute_priv | Event_priv | Trigger_priv |
+-----------+--------------------+---------------+-------------+-------------+-------------+-------------+-------------+-----------+------------+-----------------+------------+------------+-----------------------+------------------+------------------+----------------+---------------------+--------------------+--------------+------------+--------------+
| localhost | performance_schema | mysql.session | Y           | N           | N           | N           | N           | N         | N          | N               | N          | N          | N
   | N                | N                | N              | N                   | N                  | N            | N          | N            |
| localhost | sys                | mysql.sys     | N           | N           | N           | N           | N           | N         | N          | N               | N          | N          | N
   | N                | N                | N              | N                   | N                  | N            | N          | Y            |
+-----------+--------------------+---------------+-------------+-------------+-------------+-------------+-------------+-----------+------------+-----------------+------------+------------+-----------------------+------------------+------------------+----------------+---------------------+--------------------+--------------+------------+--------------+
2 rows in set (0.00 sec)

mysql> select * from mysql.tables_priv;
+-----------+--------+---------------+------------+----------------+---------------------+-----------------------------+-------------+
| Host      | Db     | User          | Table_name | Grantor        | Timestamp           | Table_priv                  | Column_priv |
+-----------+--------+---------------+------------+----------------+---------------------+-----------------------------+-------------+
| localhost | mysql  | mysql.session | user       | boot@          | 2022-07-27 00:10:29 | Select                      |             |
| localhost | sys    | mysql.sys     | sys_config | root@localhost | 2022-07-27 00:10:29 | Select                      |             |
| localhost | jep18d | user1         | company    | root@localhost | 2024-02-07 20:33:49 | Select,Update,Delete        |             |
| localhost | jep18d | user1         | customer   | root@localhost | 2024-02-07 20:33:49 | Select,Insert,Update,Delete |             |
| localhost | jep18d | user2         | customer   | root@localhost | 2024-02-07 20:33:49 | Select,Insert               |             |
+-----------+--------+---------------+------------+----------------+---------------------+-----------------------------+-------------+
5 rows in set (0.00 sec)

mysql> select * from mysql.columns_priv;
Empty set (0.00 sec)

mysql>
mysql> -- -----------------------------------------------------------------------------------------
mysql> -- Creating users
mysql> -- -----------------------------------------------------------------------------------------
mysql> drop user if exists user1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> create user if not exists 'user1'@'localhost' identified by 'password1';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> drop user if exists user2;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> create user if not exists 'user2'@'localhost' identified by 'password2';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> -- -----------------------------------------------------------------------------------------
mysql> -- 1. Limit user1 to select, update, and delete privileges on company and customer tables
mysql> -- -----------------------------------------------------------------------------------------
mysql> grant select, update, delete
    -> on jep18d.company
    -> to 'user1'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> grant select, update, delete
    -> on jep18d.customer
    -> to 'user1'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> -- -----------------------------------------------------------------------------------------
mysql> -- 2. Limit user2 to select, and insert privileges on customer table
mysql> -- -----------------------------------------------------------------------------------------
mysql>
mysql> grant select, insert
    -> on jep18d.customer
    -> to 'user2'@'localhost';
Query OK, 0 rows affected (0.00 sec)

mysql>
mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec)

-- -----------------------------------------------------------------------------------------
/*
3. Verify database/table permissions, show grants:
    a. yours/admin
    b. user1 (logged in as user1)
    c. user2 (logged in as admin)
*/
-- -----------------------------------------------------------------------------------------
mysql> show grants;
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Grants for root@localhost


                                                                                                                        |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO `root`@`localhost` WITH GRANT OPTION

                                                                                                                        |
| GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,XA_RECOVER_ADMIN ON *.* TO `root`@`localhost` WITH GRANT OPTION |
| GRANT PROXY ON ``@`` TO `root`@`localhost` WITH GRANT OPTION


                                                                                                                        |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
3 rows in set (0.00 sec)

mysql> show grants;
+----------------------------------------------------------------------------+
| Grants for user1@localhost                                                 |
+----------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `user1`@`localhost`                                  |
| GRANT SELECT, UPDATE, DELETE ON `jep18d`.`company` TO `user1`@`localhost`  |
| GRANT SELECT, UPDATE, DELETE ON `jep18d`.`customer` TO `user1`@`localhost` |
+----------------------------------------------------------------------------

mysql> show grants for 'user2'@'localhost';
+--------------------------------------------------------------------+
| Grants for user2@localhost                                         |
+--------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `user2`@`localhost`                          |
| GRANT SELECT, INSERT ON `jep18d`.`customer` TO `user2`@`localhost` |
+--------------------------------------------------------------------+
2 rows in set (0.00 sec)

-- -----------------------------------------------------------------------------------------
-- 4. Display current user2 (logged in as user2) and MySQL version
-- -----------------------------------------------------------------------------------------
mysql> select user(), version();
+-----------------+-----------+
| user()          | version() |
+-----------------+-----------+
| user2@localhost | 8.0.31    |
+-----------------+-----------+
1 row in set (0.00 sec)

-- -----------------------------------------------------------------------------------------
-- 5. List tables (as admin)
-- -----------------------------------------------------------------------------------------
mysql> show tables;
+------------------+
| Tables_in_jep18d |
+------------------+
| company          |
| customer         |
+------------------+
2 rows in set (0.00 sec)

-- -----------------------------------------------------------------------------------------
-- 6. Display structures for both tables (as admin)
-- -----------------------------------------------------------------------------------------
mysql> describe company;
+---------------+---------------------------------------------------------------+------+-----+---------+----------------+
| Field         | Type                                                          | Null | Key | Default | Extra          |
+---------------+---------------------------------------------------------------+------+-----+---------+----------------+
| cmp_id        | int unsigned                                                  | NO   | PRI | NULL    | auto_increment |
| cmp_type      | enum('c-corp','s-corp','non-profit-corp','llc','partnership') | YES  |     | NULL    |                |
| cmp_street    | varchar(30)                                                   | NO   |     | NULL    |                |
| cmp_city      | varchar(30)                                                   | NO   |     | NULL    |                |
| cmp_state     | char(2)                                                       | NO   |     | NULL    |                |
| cmp_zip       | char(9)                                                       | NO   |     | NULL    |                |
| cmp_phone     | bigint unsigned                                               | NO   |     | NULL    |                |
| cmp_ytd_sales | decimal(10,2)                                                 | NO   |     | NULL    |                |
| cmp_email     | varchar(100)                                                  | YES  |     | NULL    |                |
| cmp_url       | varchar(100)                                                  | YES  |     | NULL    |                |
| cmp_notes     | varchar(255)                                                  | YES  |     | NULL    |                |
+---------------+---------------------------------------------------------------+------+-----+---------+----------------+
11 rows in set (0.00 sec)

mysql> describe customer;
+---------------+-------------------------------------------------------------+------+-----+---------+----------------+
| Field         | Type                                                        | Null | Key | Default | Extra          |
+---------------+-------------------------------------------------------------+------+-----+---------+----------------+
| cus_id        | int unsigned                                                | NO   | PRI | NULL    | auto_increment |
| cmp_id        | int unsigned                                                | NO   | MUL | NULL    |                |
| cus_ssn       | binary(64)                                                  | NO   | UNI | NULL    |                |
| cus_salt      | binary(64)                                                  | NO   |     | NULL    |                |
| cus_type      | enum('loyal','discount','impulse','need-based','wandering') | YES  |     | NULL    |                |
| cus_first     | varchar(15)                                                 | NO   |     | NULL    |                |
| cus_last      | varchar(30)                                                 | NO   |     | NULL    |                |
| cus_street    | varchar(30)                                                 | YES  |     | NULL    |                |
| cus_city      | varchar(30)                                                 | YES  |     | NULL    |                |
| cus_state     | char(2)                                                     | YES  |     | NULL    |                |
| cus_zip       | char(9)                                                     | YES  |     | NULL    |                |
| cus_phone     | bigint unsigned                                             | NO   |     | NULL    |                |
| cus_email     | varchar(100)                                                | YES  |     | NULL    |                |
| cus_balance   | decimal(7,2)                                                | YES  |     | NULL    |                |
| cus_tot_sales | decimal(7,2)                                                | YES  |     | NULL    |                |
| cus_notes     | varchar(255)                                                | YES  |     | NULL    |                |
+---------------+-------------------------------------------------------------+------+-----+---------+----------------+
16 rows in set (0.00 sec)

-- -----------------------------------------------------------------------------------------
/*7. Display data for both tables:
    a. company (as user2)
    b. customer (as user1)*/
-- -----------------------------------------------------------------------------------------
mysql> select * from company;
ERROR 1142 (42000): SELECT command denied to user 'user2'@'localhost' for table 'company'

mysql> select * from customer;
+--------+--------+------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+------------+-----------+----------+--------------------+----------+-----------+-----------+------------+------------------+-------------+---------------+-----------------+
| cus_id | cmp_id | cus_ssn                                                                                                                            | cus_salt                                                                                                                           | cus_type   | cus_first | cus_last | cus_street         | cus_city | cus_state | cus_zip   | cus_phone  | cus_email        | cus_balance | cus_tot_sales | cus_notes       |
+--------+--------+------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+------------+-----------+----------+--------------------+----------+-----------+-----------+------------+------------------+-------------+---------------+-----------------+
|      1 |      2 | 0xFC05650A8B4C4D0D59C732E3EF6958BB007BA6451488A945CDF34F7192D5CB2CF8C74AAAF7DDB967248B1B78137D28935482EF72A9CAEB299788CEB8AE161B41 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | discount   | wilbur    | denaway  | 23 Billings Gate   | El Paso  | TX        | 085703412 | 2145559857 | test1@mymail.com |     8391.87 |      37642.00 | customer notes1 |
|      2 |      3 | 0xA9ABD1CFFA64662C1939D03E2FA485B2F5177D6F58E91A4173EEF7E25C93A56E40E9F0BC2E072CD20B1DEA3C17385049112F7618A595B58E82699624A841ADE6 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | loyal      | bradford  | casis    | 891 Drift Dr.      | Stanton  | TX        | 005819045 | 2145559482 | test2@mymail.com |      657.57 |      87341.00 | customer notes2 |
|      3 |      5 | 0x11A237776DB085D466D684D28509B89CA6EFE18AC373849A75582FF8C1263254693BC2C415C4487BE416D4711F660E3072B2E4DCDD7BC9D7FDF7AB7BFE253C63 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | impulse    | valerie   | lieblong | 421 Calamari Vista | Odessa   | TX        | 00621134  | 2145553412 | test3@mymail.com |     8730.23 |      92678.00 | customer notes3 |
|      4 |      4 | 0xEDBB8E6829C1E3BA4B1FA8216F4AEB5158FC950503651016DCA2EE183FC7EFB2CDFA547A417C378035997849663826CE6B057BAC7602C14E0B45EACB99D6D213 | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | need-based | kathy     | jeffries | 915 Drive Past     | Penwell  | TX        | 009135674 | 2145558122 | tes4@mymail.com  |     2651.19 |      78345.00 | customer notes4 |
|      5 |      1 | 0x2D28B779EB8ACC5941220AFC8727C57F6F90947A94D5DF8B0CC5034E0370994C4018CEB2E3DB0F6541528EEAD56D6B3AD26F5B3C516017C2B44226FE17F3A3EA | 0x093EC21B20EEB2E0B822DD61E29B74B918CDB44D2AA6AFD3F6685EA5CBF7CF1D41EB143A69D3122607DC0A9B7D06C14077B4EB4DF21CE4C09E07C82AA89D999F | wandering  | steve     | rogers   | 329 Volume Ave.    | Tarzan   | TX        | 000054426 | 2145551189 | test5@mymail.com |      782.73 |      23471.00 | customer notes5 |
+--------+--------+------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------+------------+-----------+----------+--------------------+----------+-----------+-----------+------------+------------------+-------------+---------------+-----------------+
5 rows in set (0.00 sec)

-- -----------------------------------------------------------------------------------------
/*8. Log in as user1:
    a. show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the company table
    b. show the SQL INSERT statement, and corresponding query result set that prevented user1 from inserting data in the customer table*/
-- -----------------------------------------------------------------------------------------
mysql> insert into company
    -> values
    -> (null,'c-corp', '507 20th Ave.', 'Seattle', 'WA', '081226749', '2065559857', '12345678.00', null, 'http://nytimes.com', 'company note6');
ERROR 1142 (42000): INSERT command denied to user 'user1'@'localhost' for table 'company'

mysql> insert into customer
    -> values
    -> (null, 2, unhex(sha2(concat(@salt, 001456789),512)), @salt, 'discount', 'wilbur', 'denaway', '23 Billings Gate', 'El Paso', 'TX', '085703412', '2145559857', 'test6@mymail.com', '8391.87', '37642.00', 'customer notes6');
ERROR 1142 (42000): INSERT command denied to user 'user1'@'localhost' for table 'customer'

-- -----------------------------------------------------------------------------------------
/*9. Log in as user2:
    a. show the SQL statement, and corresponding query result set that prevented user2 from “seeing” company table:
    b. same as above, though, prevented from being able to delete from the customer table:*/
-- -----------------------------------------------------------------------------------------
mysql> select * from company;
ERROR 1142 (42000): SELECT command denied to user 'user2'@'localhost' for table 'company'

mysql> delete from customer;
ERROR 1142 (42000): DELETE command denied to user 'user2'@'localhost' for table 'customer'
-- -----------------------------------------------------------------------------------------
-- 10. Log in as admin: remove both tables (structure and data), and show commands:
-- -----------------------------------------------------------------------------------------
mysql> drop table customer;
Query OK, 0 rows affected (0.02 sec)

mysql> drop table company;
Query OK, 0 rows affected (0.01 sec)

mysql> show tables;
Empty set (0.00 sec)