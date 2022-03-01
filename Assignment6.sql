--Ryan Zmuda
--DATA 102
--Assignment 6

--SQL Ch 5 Guitar Shop Assignment
USE MyGuitarShop

--1. Write a SELECT statement that returns these columns:
--The count of the number of orders in the Orders table
--The sum of the TaxAmount columns in the Orders table
SELECT NumOrders = COUNT(O.OrderID), TotalTax = SUM(O.TaxAmount)
FROM Orders AS O

--2. Write a SELECT statement that returns one row for each category that has products with these
--columns:
--The CategoryName column from the Categories table
--The count of the products in the Products table
--The list price of the most expensive product in the Products table
--Sort the result set so the category with the most products appears first.
SELECT C.CategoryName, NumProducts = COUNT(P.ProductID), MaxListPrice = MAX(P.ListPrice)
FROM Categories AS C
JOIN Products AS P
ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName
ORDER BY NumProducts DESC

--3. Write a SELECT statement that returns one row for each customer that has orders with these
--columns:
--The EmailAddress column from the Customers table
--The sum of the item price in the OrderItems table multiplied by the quantiy in the
--OrderItems table
--The sum of the discount amount column in the OrderItems table multiplied by the quantiy
--in the OrderItems table
--Sort the result set in descending sequence by the item price total for each customer.
SELECT C.EmailAddress, PriceTotal = SUM(OI.ItemPrice * OI.Quantity), DiscountTotal = SUM(OI.DiscountAmount * OI.Quantity)
FROM Customers AS C
JOIN Orders AS O
ON C.CustomerID = O.CustomerID
JOIN OrderItems AS OI
ON O.OrderID = OI.OrderID
GROUP BY C.EmailAddress
ORDER BY PriceTotal DESC

--4. Write a SELECT statement that returns one row for each customer that has orders with these
--columns:
--The EmailAddress column from the Customers table
--A count of the number of orders
--The total amount for those orders (Hint: First, subtract the discount amount from the
--price. Then, multiply by the quantity.)
--Return only those rows where the customer has more than than 1 order.
--Sort the result set in descending sequence by the sum of the line item amounts.
SELECT A.EmailAddress, A.NumOrders, A.Total
FROM (SELECT C.EmailAddress, NumOrders = COUNT(OI.OrderID), Total = SUM((OI.ItemPrice - OI.DiscountAmount) * OI.Quantity)
FROM Customers AS C
JOIN Orders AS O
ON C.CustomerID = O.OrderID
JOIN OrderItems AS OI
ON O.OrderID = OI.OrderID
GROUP BY C.EmailAddress) AS A
WHERE A.NumOrders > 1
GROUP BY A.EmailAddress, A.NumOrders, A.Total
ORDER BY Total DESC

--5. Modify the solution to exercise 4 so it only counts and totals line items that have an ItemPrice value
--that’s greater than 400.
SELECT A.EmailAddress, A.NumOrders, A.Total
FROM (SELECT C.EmailAddress, NumOrders = COUNT(OI.OrderID), Total = SUM((OI.ItemPrice - OI.DiscountAmount) * OI.Quantity)
FROM Customers AS C
JOIN Orders AS O
ON C.CustomerID = O.OrderID
JOIN OrderItems AS OI
ON O.OrderID = OI.OrderID
WHERE OI.ItemPrice > 400
GROUP BY C.EmailAddress) AS A
WHERE A.NumOrders > 1
GROUP BY A.EmailAddress, A.NumOrders, A.Total
ORDER BY Total DESC

--6. Write a SELECT statement that answers this question: What is the total amount ordered for each
--product? Return these columns:
--The product name from the Products table
--The total amount for each product in the OrderItems table (Hint: You can calculate the
--total amount by subtracting the discount amount from the item price and then multiplying
--it by the quantity)
--Use the WITH ROLLUP operator to include a row that gives the grand total.
SELECT P.ProductName, Total = ((OI.ItemPrice - OI.DiscountAmount) * OI.Quantity),
SumAmount = SUM((OI.ItemPrice - OI.DiscountAmount) * OI.Quantity)
FROM Products AS P
JOIN OrderItems AS OI
ON P.ProductID = OI.ProductID
GROUP BY P.ProductName, OI.ItemPrice, OI.DiscountAmount, OI.Quantity WITH ROLLUP

--7. Write a SELECT statement that answers this question: Which customers have ordered more than one
--product? Return these columns:
--The email address from the Customers table
--The count of distinct products from the customer’s orders
SELECT C.EmailAddress, DistinctProducts = COUNT(DISTINCT OI.ProductID)
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN OrderItems AS OI ON O.OrderID = OI.OrderID
GROUP BY C.EmailAddress

--Chapter 6 Exercises Page 212-213, 1-9
USE AP

--1. Write a SELECT statement that returns the same result set as this SELECT statement.
--Substitute a subquery in a WHERE clause for the inner join.
--SELECT DISTINCT VendorName
--FROM Vendors JOIN Invoices
--ON Vendors.VendorID = Invoices.VendorID
--ORDER BY VendorName;
SELECT VendorName
FROM Vendors
WHERE VendorID IN (SELECT VendorID FROM Invoices)
ORDER BY VendorName;

--2. Write a SELECT statement that answers this question: Which invoices have a PaymentTotal
--that's greater than the average PaymentTotal for all paid invoices? Return the InvoiceNumber
--and InvoiceTotal for each invoice.
SELECT InvoiceNumber, InvoiceTotal
FROM Invoices
WHERE PaymentTotal > (SELECT AVG(PaymentTotal) FROM Invoices);

--3. Write a SELECT statement that answers this question: Which invoices have a PaymentTotal
--that's greater than the median PaymentTotal for all paid invoices? Return the InvoiceNumber
--and InvoiceTotal for each invoice.
--Hint: Begin with the solution for Exercise 2, then use the ALL keyword in the WHERE clause
--and code "TOP 50 PERCENT PaymentTotal" in the subquery.
SELECT InvoiceNumber, InvoiceTotal
FROM Invoices
WHERE PaymentTotal > ALL (SELECT TOP 50 PERCENT PaymentTotal FROM Invoices ORDER BY PaymentTotal);

--4. Write a SELECT statement that returns two columns from the GLAccounts table:
--AccountNo and AccountDescription. The result set should have one row for each account
--number that has never been used. Use a correlated subquery introduced with the NOT EXISTS
--operator. Sort the final result set by AccountNo.
SELECT AccountNo, AccountDescription
FROM GLAccounts AS G
WHERE NOT EXISTS
(SELECT * FROM InvoiceLineItems AS LI WHERE LI.AccountNo = G.AccountNo)
ORDER BY AccountNo;

--5. Write a SELECT statement that returns four columns:
--VendorName, InvoiceID, InvoiceSequence, and InvoiceLineItemAmount for each invoice
--that has more than one line item in the InvoiceLineItems table.
--Hint: Use a subquery that tests for InvoiceSequence > 1.
SELECT V.VendorName, I.InvoiceID, LI.InvoiceSequence, LI.InvoiceLineItemAmount
FROM Vendors AS V
JOIN Invoices AS I ON V.VendorID = I.VendorID
JOIN InvoiceLineItems AS LI ON I.InvoiceID = LI.InvoiceID
WHERE I.InvoiceID IN
(SELECT InvoiceID FROM InvoiceLineItems WHERE InvoiceSequence > 1)
ORDER BY V.VendorName, I.InvoiceID, LI.InvoiceSequence;

--6. Write a SELECT statement that returns a single value that represents the sum of the largest
--unpaid invoices submitted by each vendor. Use a derived table that returns MAX(InvoiceTotal)
--grouped by VendorID, filtering for invoices with a balance due.
SELECT SumOfMax = SUM(A.InvoiceMax)
FROM (SELECT I.VendorID, InvoiceMax = MAX(I.InvoiceTotal) FROM Invoices AS I
WHERE I.InvoiceTotal - I.CreditTotal - I.PaymentTotal > 0
GROUP BY VendorID) AS A;

--7. Write a SELECT statement that returns the name, city, and state of each vendor that's
--located in a unique city and state. In other words, don't include vendors that have a 
--city and state in common with another vendor.
SELECT VendorName, VendorCity, VendorState
FROM Vendors
WHERE VendorState + VendorCity NOT IN 
(SELECT VendorState + VendorCity FROM Vendors GROUP BY VendorState + VendorCity HAVING COUNT(*) > 1)
ORDER BY VendorState, VendorCity;

--8. Write a SELECT statement that returns four columns:
--VendorName, InvoiceNumber, InvoiceDate, and InvoiceTotal.
--Return one row per vendor, representing the vendor's invoice with the earliest date.
SELECT V.VendorName, FirstInvoice = I.InvoiceNumber, A.InvoiceDate, I.InvoiceTotal
FROM Invoices AS I
JOIN (SELECT VendorID, MIN(InvoiceDate) AS InvoiceDate FROM Invoices GROUP BY VendorID) AS A
ON (I.VendorID = A.VendorID AND I.InvoiceDate = A.InvoiceDate)
JOIN Vendors AS V ON I.VendorID = V.VendorID
ORDER BY V.VendorName;

--9. Rewrite Exercise 6 so it uses a common table expression (CTE) instead of a derived table.
WITH A AS
(
    SELECT I.VendorID, InvoiceMax = MAX(I.InvoiceTotal)
    FROM Invoices AS I
    WHERE I.InvoiceTotal - I.CreditTotal - I.PaymentTotal > 0
    GROUP BY I.VendorID
)
SELECT SumOfMax = SUM(A.InvoiceMax) FROM A;
