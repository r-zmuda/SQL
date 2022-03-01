--Q1
SELECT lastname, firstname, state
FROM customers
WHERE state = 'NJ';

--Q2
SELECT order#, shipdate
FROM orders
WHERE shipdate > '01-APR-09';

--Q3
SELECT title, category
FROM books
WHERE category != 'FITNESS';

--Q4
--Method a (OR)
SELECT customer#, lastname, state
FROM customers
WHERE state = 'GA' OR state = 'NJ'
ORDER BY lastname ASC;
--Method b (IN)
SELECT customer#, lastname, state
FROM customers
WHERE state IN ('GA','NJ')
ORDER BY lastname ASC;

--Q5
--Method a (<= operator)
SELECT order#, orderdate
FROM orders
WHERE orderdate <= '01-APR-09';
--Method b (IN and OR operator)
SELECT order#, orderdate
FROM orders
WHERE orderdate IN '01-APR-09'
OR orderdate < '01-APR-09';

--Q6
SELECT lname, fname
FROM author
WHERE lname LIKE '%IN%'
ORDER BY lname, fname;

--Q7
SELECT lastname, referred
FROM customers
WHERE referred IS NOT NULL;

--Q8
--Method a (search pattern operation)
SELECT title, category
FROM books
WHERE category LIKE 'COO%'
OR category LIKE 'CHI%';
--Method b (logical operator)
SELECT title, category
FROM books
WHERE category = 'COOKING'
OR category = 'CHILDREN';
--Method c (comparison operator)
SELECT title, category
FROM books
WHERE category IN ('COOKING','CHILDREN');

--Q9
SELECT isbn, title
FROM books
WHERE title LIKE '_A_N%'
ORDER BY title DESC;

--Q10
--Method a (range operator)
SELECT title, pubdate
FROM books
WHERE category = 'COMPUTER'
AND pubdate BETWEEN '01-JAN-05' AND '31-DEC-05';
--Method b (logical operator)
SELECT title, pubdate
FROM books
WHERE category = 'COMPUTER'
AND pubdate >= '01-JAN-05'
AND pubdate <= '31-DEC-05';
--Method c (search pattern operation)
SELECT title, pubdate
FROM books
WHERE category LIKE 'COMPUTER'
AND pubdate LIKE '%05';
