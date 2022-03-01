USE MyGuitarShop

--Chapter 13 - How to work with views

--1. Create a view named CustomerAddresses that shows the shipping and billing addresses for each
--customer in the MyGuitarShop database.
--This view should return these columns from the Customers table: CustomerID, EmailAddress,
--LastName and FirstName.
--This view should return these columns from the Addresses table: BillLine1, BillLine2, BillCity,
--BillState, BillZip, ShipLine1, ShipLine2, ShipCity, ShipState, and ShipZip.
--Use the BillingAddressID and ShippingAddressID columns in the Customers table to determine
--which addresses are billing addresses and which are shipping addresses.
--Hint: You can use two JOIN clauses to join the Addresses table to Customers table twice (once for
--each type of address).
CREATE VIEW CustomerAddresses AS
(SELECT C.CustomerID, C.EmailAddress, C.LastName, C.FirstName,
BillLine1 = A1.Line1, BillLine2 = A1.Line2, BillCity = A1.City, BillState = A1.State, BillZip = A1.ZipCode,
ShipLine1 = A2.Line1, ShipLine2 = A2.Line2, ShipCity = A2.City, ShipState = A2.State, ShipZip = A2.ZipCode
FROM Customers AS C
JOIN Addresses AS A1 ON C.BillingAddressID = A1.AddressID
JOIN Addresses AS A2 ON C.ShippingAddressID = A2.AddressID)

--2. Write a SELECT statement that returns these columns from the CustomerAddresses view that you
--created in exercise 1: CustomerID, LastName, FirstName, BillLine1.
SELECT CustomerID, LastName, FirstName, BillLine1
FROM CustomerAddresses

--3. Write an UPDATE statement that updates the CustomerAddresses view you created in exercise 1 so it
--sets the first line of the shipping address to “1990 Westwood Blvd.” for the customer with an ID of 8.
UPDATE CustomerAddresses
SET ShipLine1 = '1990 Westwood Blvd.'
WHERE CustomerID = 8

--4. Create a view named OrderItemProducts that returns columns from the Orders, OrderItems, and
--Products tables.
--This view should return these columns from the Orders table: OrderID, OrderDate, TaxAmount, and
--ShipDate.
--This view should return these columns from the OrderItems table: ItemPrice, DiscountAmount,
--FinalPrice (the discount amount subtracted from the item price), Quantity, and ItemTotal (the
--calculated total for the item).
--This view should return the ProductName column from the Products table.
CREATE VIEW OrderItemProducts AS
(SELECT O.OrderID, O.OrderDate, O.TaxAmount, O.ShipDate,
OI.ItemPrice, OI. DiscountAmount, FinalPrice, OI.Quantity, ItemTotal = (FinalPrice * OI.Quantity),
P.ProductName
FROM Orders AS O
JOIN OrderItems AS OI ON O.OrderID = OI.OrderID
JOIN Products AS P ON P.ProductID = OI.ProductID
JOIN (SELECT OI2.OrderID, FinalPrice = (OI2.ItemPrice - OI2.DiscountAmount) FROM OrderItems AS OI2)
	AS A ON O.OrderID = A.OrderID)

--5. Create a view named ProductSummary that uses the view you created in exercise 4. This view should
--return some summary information about each product.
--Each row should include these columns: ProductName, OrderCount (the number of times the product
--has been ordered), and OrderTotal (the total sales for the product).
CREATE VIEW ProductSummary AS
(SELECT ProductName, OrderCount = COUNT(ProductName), OrderTotal = SUM(ItemTotal)
FROM OrderItemProducts
GROUP BY ProductName)

--6. Write a SELECT statement that uses the view that you created in exercise 5 to get total sales for the
--five best selling products.
SELECT TotalSalesOfTop5 = SUM(A.OrderTotal)
FROM (SELECT TOP (5) OrderTotal
FROM ProductSummary
ORDER BY OrderTotal DESC) AS A

--Chapter 14 - How to code scripts

--1. Write a script that declares a variable and sets it to the count of all products in the Products table. If
--the count is greater than or equal to 7, the script should display a message that says, “The number of
--products is greater than or equal to 7”. Otherwise, it should say, “The number of products is less than
--7”.
DECLARE @product_count int
SET @product_count = (SELECT COUNT(ProductID) FROM Products)
IF @product_count > 7 PRINT 'The number of products is greater than or equal to 7'
ELSE PRINT 'The number of products is less than 7'

--2. Write a script that uses two variables to store (1) the count of all of the products in the Products table
--and (2) the average list price for those products. If the product count is greater than or equal to 7, the
--script should print a message that displays the values of both variables. Otherwise, the script should
--print a message that says, “The number of products is less than 7”.
DECLARE @product_count int
DECLARE @average_list_price float
SET @product_count = (SELECT COUNT(ProductID) FROM Products)
SET @average_list_price = (SELECT AVG(ListPrice) FROM Products)
IF @product_count > 7
	BEGIN
	PRINT @product_count
	PRINT @average_list_price
	END
ELSE PRINT 'The number of products is less than 7'

--3. Write a script that calculates the common factors between 10 and 20. To find a common factor, you
--can use the modulo operator (%) to check whether a number can be evenly divided into both
--numbers. Then, this script should print lines that display the common factors like this:
--Common factors of 10 and 20
--1
--2
--5
DECLARE @n1 int
DECLARE @n2 int
DECLARE @counter int
SET @n1 = 10
SET @n2 = 20
SET @counter = 1
PRINT 'Common factors of ' + CAST(@n1 AS varchar) + ' and ' + CAST(@n2 AS varchar)
WHILE @counter <= @n2
	BEGIN
	IF (@n1 % @counter = 0) AND (@n2 % @counter = 0) PRINT @counter
	SET @counter = @counter + 1
	END

--4. Write a script that attempts to insert a new category named “Guitars” into the Categories table. If the
--insert is successful, the script should display this message:
--SUCCESS: Record was inserted.
--If the update is unsuccessful, the script should display a message something like this:
--FAILURE: Record was not inserted.
--Error 2627: Violation of UNIQUE KEY constraint
--'UQ__Categori__8517B2E0A87CE853'. Cannot insert duplicate key in object
--'dbo.Categories'. The duplicate key value is (Guitars).
DECLARE @check int
INSERT INTO Categories(CategoryName)
VALUES ('Guitars')
IF @@ROWCOUNT > 0
	SET @check = 1
IF @check = 1
	PRINT 'SUCCESS: Record was inserted.'
ELSE
	BEGIN
	PRINT 'FAILURE: Record was not inserted.'
	PRINT 'Error 2627: Violation of UNIQUE KEY constraint'
	PRINT 'UQ__Categori__8517B2E0A87CE853. Cannot insert duplicate key in object'
	PRINT 'dbo.Categories. The duplicate key value is (Guitars).'
	END
