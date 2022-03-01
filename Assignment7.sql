--Ryan Zmuda
--DATA 102
--Assignment 7

USE MyGuitarShop

--1.	Write a SELECT statement that returns the same result set as this SELECT statement, but don’t use a join. Instead, use a subquery in a WHERE clause that uses the --IN keyword.
--SELECT DISTINCT CategoryName
--FROM Categories c JOIN Products p
--ON c.CategoryID = p.CategoryID
--ORDER BY CategoryName
SELECT DISTINCT CategoryName
FROM Categories
WHERE CategoryID IN (SELECT CategoryID FROM Products)
ORDER BY CategoryName

--2.	Write a SELECT statement that answers this question: Which products have a list price that’s greater than the average list price for all products?
--Return the ProductName and ListPrice columns for each product.
--Sort the results by the ListPrice column in descending sequence.
SELECT ProductName, ListPrice
FROM Products
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Products)
ORDER BY ListPrice DESC

--3.	Write a SELECT statement that returns the CategoryName column from the Categories table.
--Return one row for each category that has never been assigned to any product in the Products table. To do that, use a subquery introduced with the NOT EXISTS operator.
SELECT CategoryName
FROM Categories C
WHERE NOT EXISTS (SELECT * FROM Products P WHERE C.CategoryID = P.CategoryID)

--4.	Write a SELECT statement that returns three columns: EmailAddress, OrderID, and the order total for each customer. To do this, you can group the result set by the --EmailAddress and OrderID columns. In addition, you must calculate the order total from the columns in the OrderItems table.
--Write a second SELECT statement that uses the first SELECT statement in its FROM clause. The main query should return two columns: the customer’s email address and --the largest order for that customer. To do this, you can group the result set by the EmailAddress column.
SELECT A.EmailAddress, MaxOrder = MAX(A.OrderTotal)
FROM (SELECT C.EmailAddress, O.OrderID, OrderTotal = SUM(OI.ItemPrice - OI.DiscountAmount) * OI.Quantity
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID
GROUP BY C.EmailAddress, O.OrderID, OI.ItemPrice, OI.Quantity, OI.DiscountAmount) A
GROUP BY A.EmailAddress
ORDER BY A.EmailAddress

--5.	Write a SELECT statement that returns the name and discount percent of each product that has a unique discount percent. In other words, don’t include products that --have the same discount percent as another product.
--Sort the results by the ProductName column.
SELECT P.ProductName, A.DiscountPercent
FROM (SELECT DISTINCT DiscountPercent, NumProducts = COUNT(ProductName)
FROM Products
GROUP BY DiscountPercent) A
JOIN Products P ON A.DiscountPercent = P.DiscountPercent
WHERE A.NumProducts = 1
ORDER BY P.ProductName

--6.	Use a correlated subquery to return one row per customer, representing the customer’s oldest order (the one with the earliest date). Each row should include these three --columns: EmailAddress, OrderID, and OrderDate.
SELECT A.EmailAddress, O2.OrderID, A.MinDate
FROM (SELECT C.EmailAddress, MinDate = MIN(O1.OrderDate)
FROM Customers C
JOIN Orders O1 ON C.CustomerID = O1.CustomerID
GROUP BY C.EmailAddress) A
JOIN Orders O2 ON O2.OrderDate = A.MinDate
ORDER BY A.EmailAddress
