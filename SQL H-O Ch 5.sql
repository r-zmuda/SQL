--SQL Hands-On Chapter 5
--Ryan Zmuda

--Q1
INSERT INTO orders (order#, customer#, orderdate)
	VALUES (1021,1009,TO_DATE('20-JUL-09','DD-MON-YY'));

--Q2
UPDATE orders
	SET shipzip = 33222
	WHERE order# = '1017';

--Q3
COMMIT;

--Q4
INSERT INTO orders (order#, customer#, orderdate)
	VALUES(1022,2000,TO_DATE('06-AUG-09','DD-MON-YY'));
--ORA-02291: integrity constraint (HR.ORDERS_CUSTOMER#_FK) violated.
--customer# has a foreign key constraint on the ORDERS table
--referencing the primary key customer# from the CUSTOMERS table.
--We received this error because customer# value '2000' does not
--exist on the CUSTOMERS table.

--Q5
INSERT INTO orders (order#, customer#)
	VALUES(1023,1009));
--ORA-01400: cannot insert NULL into ("HR"."ORDERS"."ORDERDATE")
--The ORDERDATE column on the ORDERS table has a NOT NULL constraint.
--When we attempted to insert this row, the missing columns will be
--assigned NULL values. This is in violation of the constraint, so
--we received this error.

--Q6
UPDATE books
	SET cost = '&cost'
	WHERE isbn = '&isbn';

--Q7
UPDATE books
	SET cost = '&cost'
	WHERE isbn = '&isbn';
--Enter Substitution Variable: isbn = 1059831198
--Enter Substitution Variable: cost = 20.00

--Q8
ROLLBACK;

--Q9
DELETE FROM orderitems
    WHERE order# = '1005';
DELETE FROM orders
    WHERE order# = '1005';

--Q10
ROLLBACK;
