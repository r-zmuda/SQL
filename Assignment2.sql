--1. Employees full name
SELECT FirstName, LastName, FullName = concat(FirstName, ' ', LastName)
FROM Employees

--2. OrderDetails amount per line item
SELECT OrderID, ProductID, UnitPrice, Quantity, TotalPrice = UnitPrice * Quantity
FROM OrderDetails
ORDER BY OrderID, ProductID

--3. How many customers?
SELECT TotalCustomers = count(*)
FROM Customers

--4. When was the first order?
SELECT FirstOrder = min(convert(date, OrderDate))
FROM Orders

--5. Countries where there are customers
SELECT Country
FROM Customers
GROUP BY Country

--6. Contact titles for customers
SELECT ContactTitle, TotalContactTitle = count(*)
FROM Customers
GROUP BY ContactTitle
ORDER BY count(*) DESC

--7. Products with associated supplier names
SELECT Suppliers = ProductID, ProductName, CompanyName
FROM Products JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID
ORDER BY ProductID

--8. Orders with a Shipper that was used
SELECT OrderID, OrderDate = convert(date, OrderDate), Shipper = CompanyName
FROM Orders JOIN Shippers
ON Shippers.ShipperID = Orders.ShipVia
WHERE OrderID < 10300
ORDER BY OrderID
