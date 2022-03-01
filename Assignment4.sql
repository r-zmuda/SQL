USE MyGuitarShop

--1.	Write a SELECT statement that joins the Categories table to the Products table and returns these columns: CategoryName, ProductName, ListPrice.
--Sort the result set by CategoryName and then by ProductName in ascending order.
SELECT C.CategoryName, P.ProductName, P.ListPrice
FROM Categories AS C
JOIN Products AS P
ON C.CategoryID = P.CategoryID
ORDER BY C.CategoryName, P.ProductName

--2.	Write a SELECT statement that joins the Customers table to the Addresses table and returns these columns: FirstName, LastName, Line1, City, State, ZipCode.
--Return one row for each address for the customer with an email address of allan.sherwood@yahoo.com.
SELECT C.FirstName, C.LastName, A.Line1, A.City, A.State, A.ZipCode
FROM Customers AS C
JOIN Addresses AS A
ON C.CustomerID = A.CustomerID
WHERE C.EmailAddress = 'allan.sherwood@yahoo.com'

--3.	Write a SELECT statement that joins the Customers table to the Addresses table and returns these columns: FirstName, LastName, Line1, City, State, ZipCode.
--Return one row for each customer, but only return addresses that are the shipping address for a customer.
SELECT C.FirstName, C.LastName, A.Line1, A.City, A.State, A.ZipCode
FROM Customers AS C
JOIN Addresses AS A
ON C.CustomerID = A.CustomerID
WHERE C.ShippingAddressID = C.BillingAddressID

--4.	Write a SELECT statement that joins the Customers, Orders, OrderItems, and Products tables. This statement should return these columns: LastName, FirstName, --OrderDate, ProductName, ItemPrice, DiscountAmount, and Quantity.
--Use aliases for the tables.
--Sort the final result set by LastName, OrderDate, and ProductName.
SELECT C.LastName, C.FirstName, O.OrderDate, P.ProductName, OI.ItemPrice, OI.DiscountAmount, OI.Quantity
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderItems AS OI ON O.OrderID = OI.OrderID
JOIN Products AS P ON OI.ProductID = P.ProductID
ORDER BY C.LastName, O.OrderDate, P.ProductName

--5.	Write a SELECT statement that returns the ProductName and ListPrice columns from the Products table.
--Return one row for each product that has the same list price as another product. (Hint: Use a self-join to check that the ProductID columns aren’t equal but the ListPrice column is equal.)
--Sort the result set by ProductName.
SELECT P1.ProductName, P1.ListPrice
FROM Products AS P1
JOIN Products AS P2
ON P1.ProductID != P2.ProductID
	AND P1.ListPrice = P2.ListPrice
ORDER BY ProductName

--6.	Write a SELECT statement that returns these two columns: 
--CategoryName	The CategoryName column from the Categories table
--ProductID	The ProductID column from the Products table
--Return one row for each category that has never been used. (Hint: Use an outer join and only return rows where the ProductID column contains a null value.)
SELECT C.CategoryName, P.ProductID
FROM Categories AS C
LEFT OUTER JOIN Products AS P
ON C.CategoryID = P.CategoryID
WHERE NOT EXISTS (SELECT *
	FROM Products AS P2
	WHERE P2.CategoryID = C.CategoryID)

--7.	Use the UNION operator to generate a result set consisting of three columns from the Orders table: 
--ShipStatus	A calculated column that contains a value of SHIPPED or NOT SHIPPED
--OrderID	The OrderID column
--OrderDate	The OrderDate column
--If the order has a value in the ShipDate column, the ShipStatus column should contain a value of SHIPPED. Otherwise, it should contain a value of NOT SHIPPED.
--Sort the final result set by OrderDate.
SELECT ShipStatus = 'SHIPPED', OrderID, OrderDate
FROM Orders
WHERE ShipDate IS NOT NULL
UNION
SELECT ShipStatus = 'NOT SHIPPED', OrderID, OrderDate
FROM Orders
WHERE ShipDate IS NULL
ORDER BY OrderDate
