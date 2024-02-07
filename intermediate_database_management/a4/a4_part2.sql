drop view if exists v_user_info;
create view v_user_info as
    select usr_id, usr_fname, usr_lname,
    concat('(', substring(usr_phone,1,3), ')', substring(usr_phone,4,3), '-', substring(usr_phone,7,4)) as usr_phone,
    usr_email
    from user
    order by usr_lname;

select * from v_user_info

----------------------------------------------------

drop view if exists v_institution_info;
create view v_institution_info as
    select ins_name,
    CONCAT(ins_street, ", ", ins_city,", ", ins_state," ", substring(ins_zip,1,5),'-', substring(ins_zip,6,4)) as address,
    CONCAT('(', substring(ins_phone,1,3),')',substring(ins_phone,4,3), '-', substring(ins_phone,7,4)) as ins_phone,
    ins_email, ins_url
    from institution
    order by ins_name asc;

select * from v_institution_info;

-------------------------------------------------------


drop view if exists v_category_types;
create view v_category_types as
    select distinct cat_type
    from transaction
        natural join category;

select * from v_category_types;

-------------------------------------------------------


DROP PROCEDURE IF EXISTS UserInstitutionAccountInfo;
DELIMITER //
CREATE PROCEDURE UserInstitutionAccountInfo(IN usrid INT)
BEGIN
    select usr_fname, usr_lname, ins_name, act_type
    from user u
        join source s on u.usr_id=s.usr_id
        join institution i on s.ins_id=i.ins_id
        join account a on s.act_id=a.act_id
    where u.usr_id = usrid
    order by act_type desc;
END //
DELIMITER ;

-- call procedure (see below)

SET @uid=2;
CALL UserInstitutionAccountInfo(@uid);

------------------------------------------------------------


DROP PROCEDURE IF EXISTS UserAccountTransactionInfo;
DELIMITER //
CREATE PROCEDURE UserAccountTransactionInfo()
BEGIN
    select usr_fname, usr_lname, act_type, trn_type, trn_method,
    CONCAT('$', FORMAT(trn_amt, 2)) as trn_amount,
    DATE_FORMAT(trn_date, '%c%/%e%/%y %r') trn_timestamp,
    trn_notes
    from user
        natural join source
        natural join transaction
        natural join account
    order by usr_lname desc, trn_amt; 
END //
DELIMITER ;

CALL UserAccountTransactionInfo();

------------------------------------------------------------

drop view if exists v_user_debits_info;
create view v_user_debits_info as
    select usr_fname, usr_lname, trn_type, concat('$',format(sum(trn_amt),2)) as debit_amt
    from user
        natural join source
        natural join transaction
    where trn_type='debit'
    group by usr_id
    order by sum(trn_amt) desc;

select * from v_user_debits_info;

------------------------------------------------------------

START TRANSACTION;
    SELECT * FROM transaction; -- visible during transaction

    INSERT INTO transaction
    (trn_id, src_id, cat_id, trn_type, trn_method, trn_amt, trn_date, trn_notes)
    VALUES
    (NULL, 2, 1, 'credit', 'auto', 2235.09, '2002-01-07 11:59:59', NULL);

    SELECT * FROM transaction; -- visible during transaction

    select @tid := max(trn_id) from transaction;

    update transaction
    set trn_notes = 'transaction has been updated'
    where trn_id = @tid;

    SELECT * FROM transaction; -- visible during transaction

    delete from transaction
    where trn_id = @tid;

    SELECT * FROM transaction; -- visible during transaction

Commit;

