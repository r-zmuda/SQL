--Ryan Zmuda
--DATA 102
--Assignment 3

USE AP

--1. Write a SELECT statement that returns all columns from the
--Venders table inner-joined with the Invoices table.
SELECT *
FROM Vendors AS V
JOIN Invoices AS I ON V.VendorID = I.VendorID;

--2. Write a SELECT statement that returns four columns:
--VendorName: From the Vendors table
--InvoiceNumber: From the Invoices table
--InvoiceDate: From the Invoices table
--Balance: InvoiceTotal minus the sum of PaymentTotal and CreditTotal
--The result set should have one row for each invoice with a non-zero
--balance. Sort the result set by VendorName in ascending order.
SELECT V.VendorName, I.InvoiceNumber, I.InvoiceDate,
Balance = (I.InvoiceTotal - I.PaymentTotal - I.CreditTotal)
FROM Vendors AS V
JOIN Invoices AS I ON V.VendorID = I.VendorID
WHERE (I.InvoiceTotal - I.PaymentTotal - I.CreditTotal) > 0
ORDER BY V.VendorName;

--3. Write a SELECT statement that returns three columns:
--VendorName: From the Vendors table
--DefaultAccountNo: From the Vendors table
--AccountDescription: From the GLAccounts table
--The result set should have one row for each vendor, with the account
--number and account description for that vendor's default account number.
--Sort the result set by AccountDescription, then by VendorName.
SELECT V.VendorName, V.DefaultAccountNo, G.AccountDescription
FROM Vendors AS V
JOIN GLAccounts AS G ON V.DefaultAccountNo = G.AccountNo
ORDER BY G.AccountDescription, V.VendorName;

--4. Generate the same result set described in Exercise 2, but use the
--implicit join syntax.
SELECT V.VendorName, I.InvoiceNumber, I.InvoiceDate,
Balance = (I.InvoiceTotal - I.PaymentTotal - I.CreditTotal)
FROM Vendors AS V, Invoices AS I
WHERE V.VendorID = I.VendorID AND (InvoiceTotal - PaymentTotal - CreditTotal) > 0
ORDER BY V.VendorName;

--5. Write a SELECT statement that returns five columns from three tables,
--all using column aliases:
--Vendor: VendorName column
--Date: InvoiceDate column
--Number: InvoiceNumber column
--#: InvoiceSequence column
--LineItem: InvoiceLineItemAmount column
--Assign the following correlation names to the tables:
--v Vendors table
--i Invoices table
--li InvoiceLineItems table
--Sort the final result set by Vendor, Date, Number, and #.
SELECT Vendor = V.VendorName,
Date = InvoiceDate,
Number = InvoiceNumber,
[#] = InvoiceSequence,
LineItem = InvoiceLineItemAmount
FROM Vendors AS V
JOIN Invoices AS I ON V.VendorID = I.VendorID
JOIN InvoiceLineItems AS LI ON I.InvoiceID = LI.InvoiceID
ORDER BY Vendor, Date, Number, [#];

--6. Write a SELECT statement that returns three columns:
--VendorID: From the Vendors table
--VendorName: From the Vendors table
--Name: A concatenation of VendorContactFName and
--VendorContactLName, with a space in between
--The result set should have one row for each vendor whose contact has the
--same first name as another vendor's contract. Sort the final result set by Name.
--Hint: Use a self-join.
SELECT DISTINCT V1.VendorID, V1.VendorName,
Name = V1.VendorContactFName + ' ' + V1.VendorContactLName
FROM Vendors AS V1
JOIN Vendors AS V2 ON (V1.VendorID <> V2.VendorID)
AND (V1.VendorContactFName = V2.VendorContactFName)
ORDER BY Name;

--7. Write a SELECT statement that returns two columns from the GLAccounts
--table: AccountNo and AccountDescription. The result set should have one row
--for each account number that has never been used. Sort the final result set
--by AccountNo.
--Hint: Use an outer join to the InvoiceLineItems table.
SELECT G.AccountNo, G.AccountDescription
FROM GLAccounts AS G
LEFT JOIN InvoiceLineItems AS LI ON G.AccountNo = LI.AccountNo
WHERE LI.AccountNo IS NULL
ORDER BY G.AccountNo;

--8. Use the UNION operator to generate a result set consisting of two columns
--from the Vendors table: VendorName and VendorState. If the vendor is in
--California, the VendorState value should be "CA"; otherwise, the VendorState
--value should be "Outside CA". Sort the final result set by VendorName.
SELECT V.VendorName, V.VendorState
FROM Vendors AS V
WHERE V.VendorState = 'CA'
UNION
SELECT V.VendorName, 'Outside CA'
FROM Vendors AS V
WHERE V.VendorState <> 'CA'
ORDER BY V.VendorName;