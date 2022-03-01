--Q1
CREATE USER rzmuda
IDENTIFIED BY asdf;

--Q2
--Error ORA-01045: user lacks CREATE SESSION privilege; logon denied. We must grant our
--new user the CREATE SESSION privilege to allow them to log on to the server.

--Q3
GRANT CREATE SESSION, CREATE ANY TABLE, ALTER ANY TABLE
TO rzmuda;

--Q4
CREATE ROLE customerrep;
GRANT INSERT, DELETE
ON hr.orders
TO customerrep;
GRANT INSERT, DELETE
ON hr.orderitems
TO customerrep;

--Q5
GRANT customerrep
TO rzmuda;

--Q6
--As user rzmuda, run:
SELECT * FROM user_sys_privs;
SELECT * FROM user_role_privs;

--Q7
REVOKE DELETE
ON hr.orders
FROM customerrep;
REVOKE DELETE
ON hr.orderitems
FROM customerrep;

--Q8
REVOKE customerrep
FROM rzmuda;

--Q9
DROP ROLE customerrep;

--Q10
DROP USER rzmuda;
