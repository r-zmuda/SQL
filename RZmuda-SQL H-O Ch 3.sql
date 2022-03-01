//SQL Hands-On Chapter 3
//Ryan Zmuda

//Q1
CREATE TABLE category (
	catcode CHAR(2),
	catdesc VARCHAR2(10));

//Q2
CREATE TABLE employees (
	emp# NUMBER(5),
	lastname VARCHAR2(12),
	firstname VARCHAR2(12),
	job_class VARCHAR2(4));

//Q3
ALTER TABLE employees ADD (
	empdate date DEFAULT SYSDATE,
	enddate date);

//Q4
ALTER TABLE employees MODIFY (
	job_class CHAR(2));

//Q5
ALTER TABLE employees
	DROP COLUMN enddate;

//Q6
RENAME employees TO jl_emps;

//Q7
CREATE TABLE book_pricing (id, cost, retail, category)
	AS (SELECT isbn, cost, retail, category FROM books);

//Q8
ALTER TABLE book_pricing
    SET unused (category);
SELECT * FROM book_pricing;

//Q9
TRUNCATE TABLE book_pricing;

//Q10
DROP TABLE book_pricing purge;
DROP TABLE jl_emps;
FLASHBACK TABLE jl_emps TO BEFORE DROP;
