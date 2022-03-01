--Ryan Zmuda
--DATA 102
--Assignment 5

USE Northwind

--1. Categories, and the total products in each category
SELECT C.CategoryID, C.CategoryName, COUNT(*) AS NumProducts
FROM Products AS P
JOIN Categories AS C
ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, C.CategoryName

--2. Total customers per country/city
SELECT Country, City, COUNT(*) AS TotalCustomer
FROM Customers
GROUP BY Country, City
ORDER BY TotalCustomer DESC

--3. Products that need reordering
SELECT ProductName, UnitsInStock, ReorderLevel
FROM Products
WHERE UnitsInStock < ReorderLevel
ORDER BY ProductID

--4. Products that need reordering, continued
SELECT ProductName, UnitsInStock, ReorderLevel, Discontinued
FROM Products
WHERE UnitsInStock + UnitsOnOrder <= ReorderLevel
	AND Discontinued = 0
ORDER BY ProductID

--5. High freight charges
SELECT TOP (3) ShipCountry, AverageFreight = AVG(Freight)
FROM Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

--6. High freight charges - 2015
SELECT TOP (3) ShipCountry, AverageFreight = AVG(Freight)
FROM Orders
WHERE OrderDate > '2015-01-01'
AND OrderDate < '2016-01-01'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC

--7. High freight charges with between
--The Between statement is inclusive. Why isn’t it showing the orders made on December 31, 2015?
--It is not accounting for orders placed after 2015-12-31 00:00:00.000.
--Using 2016-01-01 instead of 2015-12-31 will work.
SELECT OrderID, OrderDate, ShipCountry, Freight
FROM Orders
WHERE OrderID = 10806
ORDER BY OrderDate

--8. Inventory list
SELECT E.EmployeeID, E.LastName, O.OrderID, P.ProductName, OD.Quantity
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
JOIN Products AS P ON P.ProductID = OD.ProductID
ORDER BY O.OrderID, P.ProductID

--9. Customers with no orders
SELECT *
FROM (SELECT C.CustomerID, COUNT(O.CustomerID) AS NumOrders
	FROM Customers AS C
	LEFT JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
	GROUP BY C.CustomerID) AS A
WHERE A.NumOrders = 0

--10. Customers with no orders for EmployeeID 4
SELECT C2.CustomerID
FROM Customers AS C2
WHERE C2.CustomerID NOT IN (
	SELECT DISTINCT C.CustomerID
	FROM Customers AS C
	LEFT JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
	WHERE O.EmployeeID = 4)
