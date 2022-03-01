--Chapter 10 Hands-On
--Ryan Zmuda

--Question 1
SELECT INITCAP(lastname) || ', ' || INITCAP(firstname) "Customer Names"
FROM customers
ORDER BY "Customer Names";

--Question 2
SELECT customer# "Customer#",
NVL2(referred, 'REFERRED', 'NOT REFERRED') "Referred"
FROM customers;

--Question 3
SELECT oi.order# "Order#",
TO_CHAR(((oi.paideach - b.cost) * oi.quantity), '$999.99') "Profit"
FROM orderitems oi, books b
WHERE oi.isbn = b.isbn
AND order# = '1002';

--Question 4
SELECT INITCAP(title) "Title",
LPAD(CONCAT(ROUND((((retail - cost) / cost) * 100), 2), '%'), 7, ' ') "Markup"
FROM books;

--Question 5
SELECT TO_CHAR(current_timestamp, INITCAP('HH24:MM:SS A.M. DAY, MONTH DD, YYYY')) "System Time"
FROM dual;

--Question 6
SELECT title "Title", LPAD(cost, 12, '*') "Cost"
FROM books;

--Question 7
SELECT DISTINCT LENGTH(isbn) "ISBN Length"
FROM books;

--Question 8
SELECT title "Title", pubdate "Published", sysdate "Current",
LPAD(CONCAT(TRUNC((MONTHS_BETWEEN(sysdate, pubdate)), 0), ' months'), 11, ' ') "Book Age"
FROM books;

--Question 9
SELECT RPAD(sysdate, 12, ' ') "Current Date",
LPAD(CONCAT((NEXT_DAY(current_timestamp, 'WEDNESDAY') - sysdate), ' days'), 17, ' ') "Next Wednesday in"
FROM dual;

--Question 10
SELECT customer# "Customer#",
LPAD(SUBSTR(zip, 3, 2), 10, ' ') "3rd4th Zip",
LPAD(INSTR(customer#, '3'), 10, ' ') "Customer#3"
FROM customers;
