
--1. Which shippers do we have?
SELECT *
FROM [dbo].[Shippers]

--2. Certain fields from Categories
SELECT [CategoryName], [Description]
FROM [dbo].[Categories]

--3. Sales Representatives
SELECT [FirstName], [LastName], [HireDate]
FROM [dbo].[Employees]
WHERE [Title] = 'Sales Representative'

--4. Sales Representatives in the United States
SELECT [FirstName], [LastName], [HireDate]
FROM [dbo].[Employees]
WHERE [Title] = 'Sales Representative' AND [Country] = 'USA'

--5. Orders placed by specific EmployeeID
SELECT *
FROM [dbo].[Orders]
WHERE [EmployeeID] = 5

--6. Suppliers and ContactTitles
SELECT *
FROM [dbo].[Suppliers]
WHERE NOT [ContactTitle] = 'Marketing Manager'

--7. Products with "queso" in ProductName
SELECT *
FROM [dbo].[Products]
WHERE [ProductName] LIKE '%queso%'

--8. Orders shipping to France or Belgium
SELECT [OrderID], [CustomerID], [ShipCountry]
FROM [dbo].[Orders]
WHERE [ShipCountry] = 'France' OR [ShipCountry] = 'Belgium'

--9. Orders shipping to any country in Latin America
SELECT [OrderID], [CustomerID], [ShipCountry]
FROM [dbo].[Orders]
WHERE [ShipCountry] IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

--10. Employees, in order of age
SELECT [FirstName], [LastName], [Title], [BirthDate]
FROM [dbo].[Employees]
ORDER BY [BirthDate]
