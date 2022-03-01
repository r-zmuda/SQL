--Question 1 (WHERE method)
SELECT b.title, p.contact, p.phone
FROM publisher p, books b
WHERE p.pubid = b.pubid;

--Question 1 (JOIN method)
SELECT b.title, p.contact, p.phone
FROM publisher p JOIN books b
USING (pubid);

--Question 2 (WHERE method)
SELECT o.orderdate, o.order#, c.firstname, c.lastname
FROM customers c, orders o
WHERE c.customer# = o.customer#
AND o.shipdate IS null
ORDER BY o.orderdate;

--Question 2 (JOIN method)
SELECT o.orderdate, o.order#, c.firstname, c.lastname
FROM customers c JOIN orders o
USING (customer#)
WHERE o.shipdate IS null
ORDER BY o.orderdate;

--Question 3 (WHERE method)
SELECT DISTINCT c.customer#, c.lastname || ', ' || c.firstname "NAME"
FROM books b, customers c, orderitems oi, orders o
WHERE o.order# = oi.order#
AND c.customer# = o.customer#
AND oi.isbn = b.isbn
AND c.state = 'FL'
AND b.category = 'COMPUTER';

--Question 3 (JOIN method)
SELECT DISTINCT customer#, c.lastname || ', ' || c.firstname "NAME"
FROM books b
JOIN orderitems oi USING (isbn)
JOIN orders o USING (order#)
JOIN customers c USING (customer#)
WHERE c.state = 'FL' AND b.category = 'COMPUTER';

--Question 4 (WHERE method)
SELECT DISTINCT b.title
FROM customers c, orders o, orderitems oi, books b
WHERE c.customer# = o.customer#
AND o.order# = oi.order#
AND oi.isbn = b.isbn
AND c.firstname = 'JAKE'
AND c.lastname = 'LUCAS';

--Question 4 (JOIN method)
SELECT DISTINCT b.title
FROM customers.c
JOIN orders o USING (customer#)
JOIN orderitems oi USING (order#)
JOIN books b USING (isbn)
WHERE c.firstname = 'JAKE'
AND c.lastname = 'LUCAS';

--Question 5 (WHERE method)
SELECT b.title, oi.paideach - b.cost AS PROFIT
FROM customers c, orders o, orderitems oi, books b
WHERE o.customer# = c.customer#
AND oi.order# = o.order#
AND b.isbn = oi.isbn
AND c.firstname = 'JAKE'
AND c.lastname = 'LUCAS'
ORDER BY o.orderdate DESC;

--Question 5 (JOIN method)
SELECT b.title, oi.paideach - b.cost AS PROFIT
FROM customers c
JOIN orders o USING (customer#)
JOIN orderitems oi USING (order#)
JOIN books b USING (isbn)
WHERE c.firstname = 'JAKE'
AND c.lastname = 'LUCAS'
ORDER BY o.orderdate DESC;

--Question 6 (WHERE method)
SELECT b.title
FROM books b, bookauthor ba, author a
WHERE ba.authorid = a.authorid
AND ba.isbn = b.isbn
AND a.lname = 'ADAMS';

--Question 6 (JOIN method)
SELECT b.title
FROM books b
JOIN bookauthor ba USING (isbn)
JOIN author a USING (authorid)
WHERE a.lname = 'ADAMS';

--Question 7 (WHERE method)
SELECT p.gift
FROM books b, promotion p
WHERE b.retail BETWEEN p.minretail AND p.maxretail
AND b.title = 'SHORTEST POEMS';

--Question 7 (JOIN method)
SELECT p.gift
FROM books b JOIN promotion p
ON b.retail BETWEEN p.minretail AND p.maxretail
WHERE b.title = 'SHORTEST POEMS';

--Question 8 (WHERE method)
SELECT a.lname || ', ' || a.fname "AUTHOR"
FROM author a, bookauthor ba, customers c, orders o, orderitems oi
WHERE c.customer# = o.customer#
AND o.order# = oi.order#
AND oi.isbn = ba.isbn
AND ba.authorid = a.authorid
AND c.firstname = 'BECCA'
AND c.lastname = 'NELSON'
ORDER BY AUTHOR;

--Question 8 (JOIN method)
SELECT a.lname || ', ' || a.fname "AUTHOR"
FROM customers c
JOIN orders o USING (customer#)
JOIN orderitems oi USING (order#)
JOIN bookauthor ba USING (isbn)
JOIN author a USING (authorid)
WHERE c.firstname = 'BECCA'
AND c.lastname = 'NELSON'
ORDER BY AUTHOR;

--Question 9 (WHERE method)
SELECT b.title, o.order#, c.state
FROM books b, orders o, orderitems oi, customers c
WHERE c.customer#(+) = o.customer#
AND o.order#(+) = oi.order#
AND oi.isbn(+) = b.isbn
ORDER BY b.title;

--Question 9 (JOIN method)
SELECT b.title, order#, c.state
FROM books b LEFT OUTER JOIN orderitems i USING (isbn)
LEFT OUTER JOIN orders o USING (order#)
LEFT OUTER JOIN customers c USING (customer#);

--Question 10 (WHERE method)
SELECT e.fname || ' ' || e.lname AS "EMPLOYEE NAME", e.job, m.fname || ' ' || m.lname AS "MANAGER NAME"
FROM employees e, employees m
WHERE m.empno(+) = e.mgr;

--Question 10 (JOIN method)
SELECT e.fname || ' ' || e.lname AS "Employee Name", e.job, m.fname || ' ' || m.lname AS "Manager Name"
FROM employees e
LEFT OUTER JOIN employees m
ON e.mgr = m.empno;
