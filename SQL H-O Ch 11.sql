--Question 1
SELECT COUNT(*) "# of Cooking Books"
FROM books
WHERE category = 'COOKING';

--Question 2
SELECT COUNT(*) "# of Books Retail > $30.00"
FROM books
WHERE retail > 30.00;

--Question 3
SELECT title "Most Recently Published Book", LPAD(pubdate, 16, ' ') "Publication Date"
FROM books
WHERE pubdate = (SELECT MAX(pubdate) FROM books);

--Question 4
SELECT customer# "Customer#", SUM(quantity) "Quantity", SUM((paideach - cost) * quantity) "Profit"
FROM customers JOIN orders USING (customer#)
JOIN orderitems USING (order#)
JOIN books USING (isbn)
WHERE customer# = '1017'
GROUP BY customer#;

--Question 5
SELECT title "Lowest Retail Computer Book", TO_CHAR(retail, '$99.99') "Retail"
FROM books
WHERE retail = (SELECT MIN(retail) FROM books WHERE category = 'COMPUTER');

--Question 6 a.k.a. "The Phattest Nest Ever"
--Average includes sum of all values, accounting for each instance of null as 0, and formats the output.
SELECT LPAD(TO_CHAR(AVG(NVL(SUM((paideach - cost) * quantity), 0)), '$999.99'), 26, ' ') "Average Profit From Orders"
FROM books JOIN orderitems USING (isbn)
JOIN orders USING (order#)
GROUP BY order#;

--Question 7
SELECT customer# "Customer#", COUNT(order#) "Order Count"
FROM orders
GROUP BY customer#
ORDER BY customer#;

--Question 8
SELECT pubid "Publisher ID", name "Publisher Name", category "Category", LPAD(TO_CHAR(AVG(retail), '$999.99'), 14, ' ') "Average Retail"
FROM books JOIN publisher USING (pubid)
WHERE category IN ('COMPUTER', 'CHILDREN')
GROUP BY pubid, name, category
HAVING AVG(retail) > 50.00
ORDER BY pubid, AVG(retail);

--Question 9
SELECT customer# "Customer#", firstname || ' ' || lastname "Customer Name", state "State"
FROM customers JOIN orders USING (customer#)
JOIN orderitems USING (order#)
WHERE state IN ('GA', 'FL')
GROUP BY customer#, firstname || ' ' || lastname, state
HAVING SUM(paideach * quantity) > 80.00
ORDER BY customer#;

--Question 10
SELECT isbn, title "Title", lname || ', ' || fname "Author", retail "Retail"
FROM books JOIN bookauthor USING (isbn)
JOIN author USING (authorid)
WHERE retail = (SELECT MAX(retail)
                FROM books JOIN bookauthor USING (isbn)
                JOIN author USING (authorid)
                WHERE fname = 'LISA'
                AND lname = 'WHITE')
GROUP BY isbn, title, lname || ', ' || fname, retail;
