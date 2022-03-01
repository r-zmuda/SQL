--Ryan Zmuda
--DATA 102
--Assignment 3

USE Northwind

--1. Write a query that returns all orders placed on the last day of activity that can be found in the Orders table.
SELECT OrderID, OrderDate, CustomerID, EmployeeID
FROM Orders
WHERE OrderDate = (SELECT MAX(OrderDate)
	FROM Orders)

--2. Write a query that returns all orders placed by the customer(s) who placed the highest number of orders.
SELECT CustomerID, OrderID, OrderDate, EmployeeID
FROM Orders
WHERE CustomerID = (SELECT TOP (1) CustomerID
	FROM Orders
	GROUP BY CustomerID
	ORDER BY COUNT(*) DESC)

--3. Write a query that returns employees who did not place orders on or after May 1, 2008.
SELECT EmployeeID, FirstName, LastName, Title
FROM Employees
WHERE EmployeeID IN (SELECT EmployeeID
	FROM Orders
	WHERE OrderDate < '2008-05-01')
ORDER BY EmployeeID

--4. Write a query that returns countries where there are customers but not employees.
SELECT ShipCountry
FROM Orders
WHERE ShipCountry NOT IN (SELECT Country
	FROM Employees
	GROUP BY Country)
GROUP BY ShipCountry

--5. Write a query that returns for each customer all orders placed on the customer’s last day of activity.
SELECT CustomerID, OrderID, OrderDate, EmployeeID
FROM Orders AS Orders1
WHERE OrderDate =(SELECT MAX(Orders2.OrderDate)
FROM Orders AS Orders2
WHERE Orders2.CustomerID = Orders1.CustomerID)
ORDER BY CustomerID

--6. Write a query that returns customers who placed orders in 2007 but not in 2008.
SELECT CustomerID, CompanyName
FROM Customers AS C
WHERE EXISTS
	(SELECT *
	FROM Orders as O
	WHERE C.CustomerID = O.CustomerID AND
	O.OrderDate >= '2007-01-01' AND
	O.OrderDate <= '2008-01-01')
AND NOT EXISTS
	(SELECT *
	FROM Orders AS O
	WHERE C.CustomerID = O.CustomerID AND
	O.OrderDate >= '2008-01-01' AND
	O.OrderDate <= '2009-01-01')

--7. Write a query that returns customers who ordered product 12.
SELECT CustomerID, CompanyName
FROM Customers AS C
WHERE EXISTS (SELECT *
	FROM Orders AS O
	WHERE C.CustomerID = O.CustomerID
	AND EXISTS (SELECT * 
		FROM OrderDetails AS OD
		WHERE O.OrderID = OD.OrderID
		AND OD.ProductID = 12))

--8. Write a query that calculates a running-total quantity for each customer and month.
SELECT O.CustomerID, O.OrderID, O.OrderDate, OD.Quantity, SUM(OD.Quantity)
	OVER (PARTITION BY O.OrderID ORDER BY OD.OrderID, O.OrderDate ROWS UNBOUNDED PRECEDING) AS RunQty
FROM Orders AS O
	JOIN OrderDetails AS OD
	ON O.OrderID = OD.OrderID
ORDER BY OD.OrderID, O.OrderDate