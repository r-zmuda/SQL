
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

--DROP TRIGGER Products_UPDATE