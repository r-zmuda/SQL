USE MyGuitarShop

--1. Write an INSERT statement that adds this row to the Categories table:
--CategoryName: Brass
--Code the INSERT statement so SQL Server automatically generates the value
--for the CategoryID column.

INSERT INTO Categories VALUES ('Brass')

--2. Write an UPDATE statement that modifies the row you just added to the Categories table.
--This statement should change the CategoryName column to “Woodwinds”, and it should use the
--CategoryID column to identify the row.

UPDATE Categories
SET CategoryName = 'Woodwinds'
WHERE CategoryID = 5

--3. Write a DELETE statement that deletes the row you added to the Categories table in exercise 1.
--This statement should use the CategoryID column to identify the row.
DELETE Categories
WHERE CategoryID = 5

--4. Write an INSERT statement that adds a new row to the Products table.
--Note: Automatically assigned ProductID = 11.
INSERT INTO Products
(CategoryID, ProductCode, ProductName, Description, ListPrice, DiscountPercent, DateAdded)
VALUES
(4, 'dgx_640', 'Yamaha DGX 640 88-Key Digital Piano', 'Long description to come.', 799.99, 0, GETDATE())

--5. Write an UPDATE statement that modifies the product you added in exercise 4. This statement
--should change the DiscountPercent column from 0% to 35%.
UPDATE Products
SET DiscountPercent = 35
WHERE ProductID = 11

--6. Write a DELETE statement that deletes the row in the Categories table that has an ID of 4. When you
--execute this statement, it will produce an error since the category has related rows in the Products
--table. To fix that, precede the DELETE statement with another DELETE statement that deletes all
--products in this category.
DELETE Products
WHERE ProductID = 11
DELETE Categories
WHERE CategoryID = 4

--7. Write an INSERT statement that adds a new row to the Customers table.
INSERT Customers
(EmailAddress, Password, FirstName, LastName)
VALUES
('rick@raven.com', '', 'Rick', 'Raven')

--8. Write an UPDATE statement that modifies the Customers table. Change the password column to
--“secret” for the customer with an email address of rick@raven.com.
UPDATE Customers
SET Password = 'secret'
WHERE EmailAddress = 'rick@raven.com'

--9. Write an UPDATE statement that modifies the Customers table. Change the password column to
--“reset” for every customer in the table.
UPDATE Customers
SET Password = 'reset'

--10. Open the script named CreateMyGuitarShop.sql that’s in the Exercise Starts directory. Then, run this
--script. That should restore the data that’s in the database.
Done.

--11. Write a SELECT statement that returns these columns from the Products table:
--The ListPrice column
--A column that uses the CAST function to return the ListPrice column with 1 digit to the
--right of the decimal point
--A column that uses the CONVERT function to return the ListPrice column as an integer
--A column that uses the CAST function to return the ListPrice column as an integer

SELECT ListPrice,
CastDigit = CAST (ListPrice AS decimal(38, 1)),
ConvertInt = CONVERT (int, ListPrice),
CastInt = CAST (ListPrice AS int)
FROM Products

--12. Write a SELECT statement that returns these columns from the Products table:
--The DateAdded column
--A column that uses the CAST function to return the DateAdded column with its date only
--(year, month, and day)
--A column that uses the CAST function to return the DateAdded column with its full time
--only (hour, minutes, seconds, and milliseconds)
--A column that uses the CAST function to return the DateAdded column with just the
--month and day

SELECT DateAdded,
DateOnly = CAST (DateAdded AS Date),
TimeOnly = CAST (DateAdded AS Time),
MonthDay = CAST (DateAdded AS varchar(6))
FROM Products

--13. Write a SELECT statement that returns these colums from the Orders table:
--A column that uses the CONVERT function to return the OrderDate column in this
--format: MM/DD/YYYY. In other words, use 2-digit months and days and a 4-digit year,
--and separate each date component with slashes.
--A column that uses the CONVERT function to return the OrderDate column with the
--date, and the hours and minutes on a 12-hour clock with an am/pm indicator.
--A column that uses the CONVERT function to return the OrderDate column with 2-digit
--hours, minutes, and seconds on a 24-hour clock. Use leading zeros for all date/time
--components.

SELECT MMDDYYYY = CONVERT (varchar, OrderDate, 1),
D12H = LTRIM(RIGHT(CONVERT (varchar, OrderDate, 22), 11)),
D24H = CONVERT (varchar, OrderDate, 8)
FROM Orders
