--Ryan Zmuda
--DATA 102
--Assignment 9

USE MyGuitarShop

--1.	Write a SELECT statement that returns these columns from the Products table:
--The ListPrice column
--The DiscountPercent column
--A column named DiscountAmount that uses the previous two columns to calculate the discount amount and uses the ROUND function to --round the result to 2 decimal places
SELECT ListPrice, DiscountPercent,
DiscountAmount = ROUND((ListPrice - (ListPrice * (DiscountPercent / 100))), 2)
FROM Products

--2.	Write a SELECT statement that returns these columns from the Orders table:
--The OrderDate column
--A column that returns the four-digit year that’s stored in the OrderDate column
--A column that returns only the day of the month that’s stored in the OrderDate column.
--A column that returns the result from adding thirty days to the OrderDate column.
SELECT OrderDate,
FourDigitYear = LTRIM(LEFT(CONVERT(Date, OrderDate, 1), 4)),
DayOfMonth = LTRIM(RIGHT(CONVERT(Date, OrderDate, 1), 2)),
Add30Days = CONVERT(Date, OrderDate + 30, 1)
FROM Orders

--3.	Write a SELECT statement that returns these columns from the Orders table:
--The CardNumber column
--The length of the CardNumber column
--The last four digits of the CardNumber column
--When you get that working right, add the column that follows to the result set.
--This is more difficult because the column requires the use of functions within functions.
--A column that displays the last four digits of the CardNumber column in this format: XXXX-XXXX-XXXX-1234. In other words, use Xs for --the first 12 digits of the card number and actual numbers for the last four digits of the number.
SELECT CardNumber,
DataLength = DATALENGTH(CardNumber),
Last4 = LTRIM(RIGHT(CardNumber, 4)),
Formatted = 'XXXX-XXXX-XXXX-' + LTRIM(RIGHT(CardNumber, 4))
FROM Orders

--4.	Write a SELECT statement that returns these columns from the Orders table:
--The OrderID column
--The OrderDate column
--A column named ApproxShipDate that’s calculated by adding 2 days to the OrderDate column
--The ShipDate column
--A column named DaysToShip that shows the number of days between the order date and the ship date
--When you have this working, add a WHERE clause that retrieves just the orders for March 2016.
SELECT OrderID, OrderDate,
ApproxShipDate = CONVERT(Date, OrderDate + 2), ShipDate,
DaysToShip = CONVERT(int, ShipDate - OrderDate)
FROM Orders
WHERE OrderDate > '2016-03-01'
AND OrderDate < '2016-04-01'