--1. Write a script that creates and calls a stored procedure named spInsertCategory. First, code a statement that creates a procedure that adds a new row to the Categories table. To do that, this procedure should have one parameter for the category name.
--Code at least two EXEC statements that test this procedure. (Note that this table doesn’t allow duplicate category names.)
USE MyGuitarShop
GO
CREATE PROC spInsertCategory
	@NewCategory varchar(50)
AS
INSERT INTO Categories(CategoryName)
VALUES (@NewCategory)
------------------------------------------------------------------------------------
EXEC spInsertCategory 'Electric'
EXEC spInsertCategory 'Acoustic'

--2. Write a script that creates and calls a function named fnDiscountPrice that calculates the discount price of an item in the OrderItems table (discount amount subtracted from item price). To do that, this function should accept one parameter for the item ID, and it should return the value of the discount price for that item.
USE MyGuitarShop
GO
CREATE PROC fnDiscountPrice
	@item_id int
AS
DECLARE @discount_price decimal(19, 2)
SET @discount_price = (SELECT ItemPrice - DiscountAmount
FROM OrderItems
WHERE ItemID = @item_id)
RETURN @discount_price

--3. Write a script that creates and calls a function named fnItemTotal that calculates the total amount of an item in the OrderItems table (discount price multiplied by quantity). To do that, this function should accept one parameter for the item ID, it should use the DiscountPrice function that you created in exercise 2, and it should return the value of the total for that item.
USE MyGuitarShop
GO
CREATE PROC fnItemTotal
	@item_id int
AS
DECLARE @item_price decimal(19, 2)
DECLARE @total decimal(19, 2)
EXEC @item_price = fnDiscountPrice @item_id
SET @total = (SELECT Quantity * @item_price
FROM OrderItems
WHERE ItemID = @item_id)
RETURN @total

--4. Write a script that creates and calls a stored procedure named spInsertProduct that inserts a row into the Products table. This stored procedure should accept five parameters. One parameter for each of these columns: CategoryID, ProductCode, ProductName, ListPrice, and DiscountPercent.
--This stored procedure should set the Description column to an empty string, and it should set the DateAdded column to the current date.
--If the value for the ListPrice column is a negative number, the stored procedure should raise an error that indicates that this column doesn’t accept negative numbers. Similarly, the procedure should raise an error if the value for the DiscountPercent column is a negative number.
--Code at least two EXEC statements that test this procedure.
USE MyGuitarShop
GO
CREATE PROC spInsertProduct
	@category_val int,
	@code_val varchar(30),
	@name_val varchar(50),
	@listprice_val decimal(19, 2),
	@discountpt_val decimal(19, 2)
AS
IF @listprice_val < 0
	PRINT 'ERROR: ListPrice can not be negative.'
ELSE IF @discountpt_val < 0
	PRINT 'ERROR: DiscountPercent can not be negative.'
ELSE
	INSERT INTO Products(CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, Description, DateAdded)
	VALUES (@category_val, @code_val, @name_val, @listprice_val, @discountpt_val, '', GetDate())
------------------------------------------------------------------------------------
EXEC spInsertProduct 3, 'phenom', 'Phenom', 999.99, 20.00
EXEC spInsertProduct 2, 'bolse', 'Bolse', 599.99, 25.00

--5. Write a script that creates and calls a stored procedure named spUpdateProductDiscount that updates the DiscountPercent column in the Products table. This procedure should have one parameter for the product ID and another for the discount percent.
--If the value for the DiscountPercent column is a negative number, the stored procedure should raise an error that indicates that the value for this column must be a positive number.
--Code at least two EXEC statements that test this procedure.
USE MyGuitarShop
GO
CREATE PROC spUpdateProductDiscount
	@productid int,
	@newdiscount decimal(19, 2)
AS
IF @newdiscount < 0
	PRINT 'ERROR: DiscountPercent can not be negative.'
ELSE
	BEGIN
	UPDATE Products
	SET DiscountPercent = @newdiscount
	WHERE ProductID = @productid
	END
------------------------------------------------------------------------------------
EXEC spUpdateProductDiscount 10, 20.00
EXEC spUpdateProductDiscount 9, 35.00
 
--6. Create a trigger named Products_UPDATE that checks the new value for the DiscountPercent column of the Products table. This trigger should raise an appropriate error if the discount percent is greater than 100 or less than 0.
--If the new discount percent is between 0 and 1, this trigger should modify the new discount percent by multiplying it by 100. That way, a discount percent of .2 becomes 20.
--Test this trigger with an appropriate UPDATE statement.
CREATE TRIGGER Products_UPDATE
	ON Products
	AFTER UPDATE
AS
IF EXISTS (SELECT * FROM Deleted JOIN Products ON Deleted.ProductID = Products.ProductID
	WHERE Deleted.DiscountPercent <> Products.DiscountPercent)
		BEGIN
		DECLARE @newdiscount decimal(19, 2)
		DECLARE @olddiscount decimal(19, 2)
		SET @newdiscount = (SELECT Products.DiscountPercent FROM Deleted JOIN Products
			ON Deleted.ProductID = Products.ProductID
			WHERE Deleted.DiscountPercent <> Products.DiscountPercent)
		SET @olddiscount = (SELECT Deleted.DiscountPercent FROM Deleted JOIN Products
			ON Deleted.ProductID = Products.ProductID
			WHERE Deleted.DiscountPercent <> Products.DiscountPercent)
		IF @newdiscount < 0
			BEGIN
				PRINT 'ERROR: DiscountPercent can not be negative.'
				UPDATE Products
				SET DiscountPercent = @olddiscount
				WHERE ProductID IN (SELECT ProductID FROM Deleted)
			END
		ELSE IF (@newdiscount > 0 AND @newdiscount <= 1)
			BEGIN
				UPDATE Products
				SET DiscountPercent = @newdiscount * 100
				WHERE ProductID IN (SELECT ProductID FROM Inserted)
				PRINT 'NOTICE: DiscountPercent converted and updated.'
			END
		ELSE
			PRINT 'NOTICE: DiscountPercent updated.'
		END
------------------------------------------------------------------------------------
UPDATE Products
SET DiscountPercent = 0.5
WHERE ProductID = 10

--7. Create a trigger named Products_INSERT that inserts the current date for the DateAdded column of the Products table if the value for that column is null.
--Test this trigger with an appropriate INSERT statement.
CREATE TRIGGER Products_INSERT
	ON Products
	AFTER INSERT
AS
	DECLARE @testdate date
	SET @testdate = (SELECT Inserted.DateAdded FROM Inserted JOIN Products ON Inserted.ProductID = Products.ProductID
		WHERE Inserted.ProductID <> Products.ProductID)
	IF @testdate IS NULL
		BEGIN
			UPDATE Products
			SET DateAdded = GetDate()
			WHERE ProductID IN (SELECT ProductID FROM Inserted)
			PRINT 'NOTICE: DateAdded can not be null. DateAdded set to GetDate().'
		END
	ELSE
		PRINT 'NOTICE: Row inserted successfully.'
------------------------------------------------------------------------------------
INSERT INTO Products(CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, Description, DateAdded)
VALUES (4, 'macbeth', 'Macbeth', 999.99, 30.00, '', null)

--8. Create a table named ProductsAudit. This table should have all columns of the Products table, except the Description column. Also, it should have an AuditID column for its primary key, and the DateAdded column should be changed to DateUpdated.
--Create a trigger named Products_UPDATE. This trigger should insert the old data about the product into the ProductsAudit table after the row is updated. Then, test this trigger with an appropriate UPDATE statement.
SELECT ProductID, CategoryID, ProductCode, ProductName, ListPrice, DiscountPercent, DateAdded
INTO ProductsAudit
FROM Products
------------------------------------------------------------------------------------
EXEC sp_RENAME 'dbo.ProductsAudit.ProductID', 'AuditID', 'COLUMN'
EXEC sp_RENAME 'dbo.ProductsAudit.DateAdded', 'DateUpdated', 'COLUMN'
------------------------------------------------------------------------------------
CREATE TRIGGER Products_UPDATE
	ON Products
	AFTER UPDATE
AS
	DECLARE @old_productid int
	DECLARE @old_categoryid int
	DECLARE @old_productcode varchar(50)
	DECLARE @old_productname varchar(100)
	DECLARE @old_listprice decimal(19, 2)
	DECLARE @old_discountpt decimal(19, 2)
	DECLARE @old_date datetime
	SET @old_productid = (SELECT Deleted.ProductID FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID)
	SET @old_categoryid = (SELECT Deleted.CategoryID FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID
		WHERE Deleted.CategoryID <> Products.CategoryID)
	SET @old_productcode = (SELECT Deleted.ProductCode FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID
		WHERE Deleted.ProductCode <> Products.ProductCode)
	SET @old_productname = (SELECT Deleted.ProductName FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID
		WHERE Deleted.ProductName <> Products.ProductName)
	SET @old_listprice = (SELECT Deleted.ListPrice FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID
		WHERE Deleted.ListPrice <> Products.ListPrice)
	SET @old_discountpt = (SELECT Deleted.DiscountPercent FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID
		WHERE Deleted.DiscountPercent <> Products.DiscountPercent)
	SET @old_date = (SELECT Deleted.DateAdded FROM Deleted JOIN Products
		ON Deleted.ProductID = Products.ProductID
		WHERE Deleted.DateAdded <> Products.DateAdded)
	PRINT @old_productid
	PRINT @old_categoryid
	PRINT @old_productcode
	PRINT @old_productname
	PRINT @old_listprice
	PRINT @old_discountpt
	PRINT @old_date
	UPDATE ProductsAudit
	SET CategoryID = @old_categoryid,
		ProductCode = @old_productcode,
		ProductName = @old_productname,
		ListPrice = @old_listprice,
		DiscountPercent = @old_discountpt,
		DateUpdated = @old_date
	WHERE AuditID = @old_productid
------------------------------------------------------------------------------------
UPDATE Products
SET CategoryID = 2,
	ProductCode = 'stevens_dx',
	ProductName = 'Stevens DX',
	Description = '',
	ListPrice = 499.99,
	DiscountPercent = 15.00,
	DateAdded = GetDate()
WHERE ProductID = 9
