--SQL Hands-On Chapter 12
--Ryan Zmuda

--Q1: List the book title and retail price for all books with a retail price lower than the average retail price of all books sold by JustLee Books.
SELECT title "Titles < Average Retail", TO_CHAR(retail,'$999.99') "Retail"
FROM books
WHERE retail < (SELECT AVG(retail) FROM books);

--Q2: Determine which books cost less than the average cost of other books in the same category.
SELECT title "Title", retail "Retail", category "Category", catavg "Category Average"
FROM books JOIN (SELECT category, AVG(retail) catavg FROM books GROUP BY category) USING (category)
WHERE retail <= catavg;

--Q3: Determine which orders were shipped to the same state as order 1014.
SELECT * FROM orders
WHERE shipstate = (SELECT shipstate FROM orders WHERE order# = '1014');

--Q4: Determine which orders have a higher total amount due than order 1008.
SELECT order# "Order#", TO_CHAR((paideach * quantity),'$999.99') "Subtotal"
FROM orders JOIN orderitems USING (order#)
WHERE (paideach * quantity) > (SELECT (paideach * quantity) FROM orderitems WHERE order# = '1008');

--Q5: Determine which author or authors wrote the books most frequently purchased by customers of JustLee Books.
--Displays names of authors in order of most copies sold overall above the average author.
SELECT DISTINCT fname || ' ' || lname "Most Popular Authors"
FROM author JOIN bookauthor USING (authorid) JOIN
    (SELECT DISTINCT isbn, isbn_sold FROM orderitems JOIN
        (SELECT isbn, SUM(quantity) isbn_sold FROM orderitems GROUP BY isbn) USING (isbn)
     WHERE isbn_sold > (SELECT AVG(SUM(quantity)) FROM orderitems GROUP BY isbn)) USING (isbn);

--Q6: List the title of all books in the same category as books previously purchased by customer 1007. Don't include books this customer has already purchased.
SELECT DISTINCT title, category
FROM books JOIN orderitems USING (isbn)
JOIN orders USING (order#)
WHERE category IN
(SELECT DISTINCT category FROM books JOIN orderitems USING (isbn) JOIN orders USING (order#) WHERE customer# = '1007')
AND title NOT IN
(SELECT title FROM books JOIN orderitems USING (isbn) JOIN orders USING (order#) WHERE customer# = '1007');

--Q7: List the shipping city and state for the order that had the longest shipping delay.
SELECT shipcity, shipstate, orderdate, shipdate, RPAD(CONCAT((shipdate - orderdate), ' days'), 8, ' ') "DELAY"
FROM orders
WHERE (shipdate - orderdate) IN (SELECT MAX(shipdate - orderdate) FROM orders);

--Q8: Determine which customers placed orders for the least expensive book (in terms of regular retail price) carried by JustLee Books.
SELECT customer#, order#, firstname || ' ' || lastname "Customer Name"
FROM books JOIN orderitems USING (isbn)
JOIN orders USING (order#)
JOIN customers USING (customer#)
WHERE retail = (SELECT MIN(retail) FROM books);

--Q9: Determine the number of different customers who have placed an order for books written or cowritten by James Austin.
SELECT COUNT(DISTINCT customer#)
FROM orders JOIN orderitems USING (order#)
JOIN bookauthor USING (isbn)
WHERE authorid IN
(SELECT authorid FROM author WHERE fname = 'JAMES' AND lname = 'AUSTIN');

--Q10: Determine which books were published by the publisher of The Wok Way to Cook.
SELECT *
FROM books
WHERE pubid IN
(SELECT pubid FROM publisher JOIN books USING (pubid) WHERE title = 'THE WOK WAY TO COOK');
