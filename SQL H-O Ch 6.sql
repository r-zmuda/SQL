--Q1
CREATE SEQUENCE customers_customer#_seq
    INCREMENT BY 1
    START WITH 1021
    NOCACHE
    NOCYCLE;

--Q2
INSERT INTO customers (customer#, lastname, firstname, zip)
    VALUES (customers_customer#_seq.NEXTVAL, 'Shoulders', 'Frank', '23567');

--Q3
CREATE SEQUENCE my_first_seq
    INCREMENT BY -3
    START WITH 5
    MINVALUE 0
    MAXVALUE 5
    NOCYCLE;

--Q4
SELECT my_first_seq.NEXTVAL FROM DUAL; --Script output: NEXTVAL = 5
SELECT my_first_seq.NEXTVAL FROM DUAL; --Script output: NEXTVAL = 2
SELECT my_first_seq.NEXTVAL FROM DUAL; --Script output:
--ORA-08004: sequence my_first_seq.NEXTVAL goes below MINVALUE and cannot be
--instantiated. my_first_seq attempts to generate NEXTVAL = -1 (-3 increment) but
--this step produces this error because MINVALUE of my_first_seq is set to 0.

--Q5
ALTER SEQUENCE my_first_seq
    MINVALUE -1000;

--Q6
--In Oracle 12c, attempting to set the value of emailid to 25 will throw an
--error because identity columns can not have values inserted into them.
CREATE TABLE email_log (
    emailid NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    emaildate DATE,
    customer# NUMBER(4)
    );
INSERT INTO email_log (emaildate, customer#)
	VALUES (SYSDATE, 1007);
INSERT INTO email_log (emailid, emaildate, customer#)
	VALUES (DEFAULT, SYSDATE, 1008)
	VALUES (25, SYSDATE, 1009);
SELECT * FROM email_log WHERE customer# >= 1007;

--Q7
CREATE SYNONYM numgen FOR my_first_seq;

--Q8
SELECT numgen.CURRVAL FROM DUAL;
DROP SYNONYM numgen;
DROP SEQUENCE my_first_seq;

--Q9
CREATE BITMAP INDEX customers_state_idx
	ON customers (state);
SELECT table_name, index_name, index_type
    FROM user_indexes
    WHERE table_name = 'CUSTOMERS';
DROP BITMAP INDEX customers_state_idx;

--Q10
CREATE INDEX customers_lastname_idx
	ON customers (lastname);
SELECT table_name, index_name, column_name
	FROM user_ind_columns
	WHERE table_name = 'CUSTOMERS';
DROP INDEX customers_lastname_idx;

--Q11
CREATE INDEX orders_ordershipdate_idx
    ON orders (shipdate - orderdate);
