//SQL Hands-On Chapter 2
//Ryan Zmuda

//Q1
SELECT * FROM books;

//Q2
SELECT title FROM books;

//Q3
SELECT pubid "Publication Date" FROM books;

//Q4
SELECT customer#, city, state, FROM customers;

//Q5
SELECT name, contact "Contact Person", phone FROM publisher;

//Q6
SELECT DISTINCT category FROM books;

//Q7
SELECT DISTINCT customer# FROM orders;

//Q8
SELECT category, title FROM books;

//Q9
SELECT lname || ', ' || fname FROM author;

//Q10
SELECT order#, item#, isbn, quantity, paideach, quantity*paideach "Item Total" FROM orderitems;
