USE Northwind

--1. High-value customers
--We want to send all of our high-value customers a special VIP gift. We're
--defining high-value customers as those who've made at least 1 order with a
--total value (not including the discount) equal to $10,000 or more. We only
--want to consider orders made in the year 2016.
SELECT *
FROM (SELECT C.CustomerID, C.CompanyName, O.OrderID, TotalAmount = SUM(OD.Quantity * OD.UnitPrice)
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
GROUP BY C.CustomerID, C.CompanyName, O.OrderID) AS A
WHERE A.TotalAmount > 10000
ORDER BY A.TotalAmount DESC

--2. High-value customers - total orders
--The manager has changed his mind. Instead of requiring that customers have at
--least one individual orders totaling $10,000 or more, he wants to define
--high-value customers as those who have orders totaling
--$15,000 or more in 2016. How would you change the answer to the problem above?
SELECT *
FROM (SELECT C.CustomerID, C.CompanyName, TotalAmount = SUM(OD.Quantity * OD.UnitPrice)
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
GROUP BY C.CustomerID, C.CompanyName) AS A
WHERE A.TotalAmount > 15000
ORDER BY A.TotalAmount DESC

--3. High-value customers - with discount
--Change the above query to use the discount when calculating high-value
--customers. Order by the total amount which includes the discount.
SELECT *
FROM (SELECT C.CustomerID, C.CompanyName, TotalAmount = SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount))
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
WHERE OrderDate >= '20160101' AND OrderDate < '20170101'
GROUP BY C.CustomerID, C.CompanyName) AS A
WHERE A.TotalAmount > 10000
ORDER BY A.TotalAmount DESC

--4. Month-end orders
--At the end of the month, salespeople are likely to try much harder to get
--orders, to meet their month-end quotas. Show all orders made on the last
--day of the month. Order by EmployeeID and OrderID.
SELECT O.OrderID, E.EmployeeID, O.OrderDate
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE O.OrderDate = EOMONTH(O.OrderDate)
ORDER BY E.EmployeeID, O.OrderID

--5. Orders with many line items
--The Northwind mobile app developers are testing an app that customers will
--use to show orders. In order to make sure that even the largest orders will
--show up correctly on the app, they'd like some samples of orders that have
--lots of individual line items. Show the 10 orders with the most line items,
--in order of total line items.
SELECT TOP (10) O.CustomerID, O.OrderID, ItemCount = COUNT(O.OrderID)
FROM Orders AS O
JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
GROUP BY O.CustomerID, O.OrderID
ORDER BY ItemCount DESC

--6. Orders - random assortment
--The Northwind mobile app developers would now like to just get a random
--assortment of orders for beta testing on their app. Show a random set of
--2% of all orders.
DECLARE @NumOrders int
SET @NumOrders = (SELECT COUNT(OrderID) FROM Orders)
SELECT TOP ((@NumOrders / 100) * 2) *
FROM Orders
ORDER BY NEWID()

--7. Orders - accidental double-entry
--Janet Leverling, one of the salespeople, has come to you with a request. She
--thinks that she accidentally double-entered a line item on an order, with a
--different ProductID, but the same quantity. She remembers that the quantity
--was 60 or more. Show all the OrderIDs with line items that match this, in
--order of OrderID.
SELECT *
FROM (SELECT OrderID, Quantity, NumItems = COUNT(OrderID)
FROM OrderDetails
GROUP BY OrderID, Quantity) AS A
WHERE A.NumItems > 1 AND A.Quantity >= 60

--8. Orders - accidental double-entry details
--Based on the previous question, we now want to show details of the order,
--for orders that match the above criteria.
SELECT *
FROM OrderDetails
WHERE OrderID IN (SELECT OrderID
FROM (SELECT OrderID, Quantity, NumItems = COUNT(OrderID)
FROM OrderDetails
GROUP BY OrderID, Quantity) AS A
WHERE A.NumItems > 1 AND A.Quantity >= 60)

--9. Orders - accidental double-entry details, derived table
--Here's another way of getting the same results as in the previous problem,
--using a derived table instead of a CTE. However, there's a bug in this SQL.
--It returns 20 rows instead of 16. Correct the SQL.
SELECT DISTINCT OD.OrderID, ProductID, UnitPrice, Quantity, Discount
FROM OrderDetails AS OD
JOIN (SELECT OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(*) > 1) AS PPO
ON PPO.OrderID = OD.OrderID
ORDER BY OD.OrderID, OD.ProductID

--10. Late orders
--Some customers are complaining about their orders arriving late. Which orders
--are late?
SELECT OrderID, ShippedDate, RequiredDate
FROM Orders
WHERE ShippedDate >= RequiredDate

--11. Late orders - which employees?
--Some salespeople have more orders arriving late than others. Maybe they're not
--following up on the order process, and need more training. Which salespeople
--have the most orders arriving late?
SELECT A.EmployeeID, LateOrders = COUNT(A.EmployeeID)
FROM (SELECT OrderID, EmployeeID, ShippedDate, RequiredDate
FROM Orders
WHERE ShippedDate >= RequiredDate) AS A
GROUP BY A.EmployeeID
ORDER BY LateOrders DESC
