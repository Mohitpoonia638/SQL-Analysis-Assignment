-- =====================================
-- SQL Based Data Analysis Assignment
-- Celebal Technologies
-- =====================================


-- =====================================
-- Section A
-- SQL Basics
-- =====================================

-- Q1
-- Display all columns and rows from the customers table

SELECT * FROM customers;

-- Q2
-- Retrieve only the first_name, last_name, and city of all customers

SELECT first_name, last_name, city
FROM customers;

-- Q3
-- List all unique categories available in the products table

SELECT DISTINCT category
FROM products;

-- Q4
-- Identify the Primary Key of each table in the schema.
-- Explain why a Primary Key must be unique and NOT NULL.

-- Primary Keys:
-- customers    -> customer_id
-- products     -> product_id
-- orders       -> order_id
-- order_items  -> item_id

-- Explanation:
-- A Primary Key uniquely identifies each row in a table.
-- It must contain unique values so that duplicate records are not created.
-- A Primary Key cannot contain NULL values because every record must have a valid identifier.

-- Example:
-- customer_id = 101 uniquely identifies Aarav Sharma in the customers table.

-- Q5
-- What constraints are applied to the email column in the customers table?
-- What would happen if you tried to insert a duplicate email?

-- Constraints applied on email column:
-- 1. UNIQUE
-- 2. NOT NULL

-- UNIQUE constraint ensures that duplicate email addresses cannot exist.
-- NOT NULL ensures that every customer must have an email address.

-- If a duplicate email is inserted, MySQL will generate an error
-- because UNIQUE constraint will be violated.

-- Example:

INSERT INTO customers
VALUES
(109,'Rahul','Verma','aarav.s@email.com',
 'Delhi','Delhi','2024-09-01',TRUE);

-- Expected Result:
-- ERROR: Duplicate entry for UNIQUE key 'email'

-- Q6
-- Try inserting a product with unit_price = -50.
-- Explain the error and constraint.

-- The CHECK constraint on unit_price prevents negative values.

INSERT INTO products
VALUES
(209,'Test Product','Electronics','ABC',-50,10);

-- Expected Result:
-- MySQL will generate an error because unit_price cannot be less than or equal to 0.

-- Constraint Responsible:
-- CHECK (unit_price > 0)

-- Explanation:
-- CHECK constraint ensures data validity by restricting invalid values.
-- Since -50 violates the condition unit_price > 0,
-- the insertion fails.

-- =====================================
-- Section B
-- Filtering & Optimization
-- =====================================

-- Q7
-- Retrieve all orders with status = 'Delivered'

SELECT *
FROM orders
WHERE status = 'Delivered';

-- Q8
-- Find all products in the 'Electronics' category
-- with a unit_price greater than ₹2000

SELECT *
FROM products
WHERE category = 'Electronics'
AND unit_price > 2000;

-- Q9
-- List all customers who joined in the year 2024
-- and belong to the state 'Maharashtra'

SELECT *
FROM customers
WHERE YEAR(join_date) = 2024
AND state = 'Maharashtra';

-- Q10
-- Find all orders placed between '2024-08-10' and '2024-08-25'
-- that are NOT cancelled

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
AND status != 'Cancelled';

-- Q11
-- Explain the purpose of idx_orders_date index
-- and how it improves query performance.

-- idx_orders_date is an index created on the order_date column
-- in the orders table.

-- Purpose of the index:
-- It helps MySQL find rows faster when filtering,
-- sorting, or searching using order_date.

-- Without an index:
-- MySQL performs a full table scan,
-- checking every row one by one.

-- With an index:
-- MySQL can directly locate matching rows,
-- reducing search time and improving performance.

-- This is especially useful for large datasets.

-- Example query that benefits from this index:

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31';

-- Q12
-- Would the index be used with YEAR(join_date)?
-- Rewrite the query in an index-friendly (SARGable) way.

-- Query:
-- SELECT * FROM customers
-- WHERE YEAR(join_date) = 2024;

-- Explanation:
-- The index on join_date may NOT be used efficiently
-- because the YEAR() function is applied on the indexed column.

-- Applying functions on indexed columns can force MySQL
-- to perform a full table scan instead of using the index.

-- This type of query is considered non-SARGable.

-- SARGable means:
-- Search ARGument Able
-- i.e., a query that can efficiently use indexes.

-- Index-friendly (SARGable) version:

SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
AND join_date < '2025-01-01';

-- =====================================
-- Section C
-- Aggregation
-- =====================================

-- Q13
-- Count the total number of orders in the orders table

SELECT COUNT(*) AS total_orders
FROM orders;

-- Q14
-- Find total revenue from all Delivered orders

SELECT SUM(total_amount) AS total_delivered_revenue
FROM orders
WHERE status = 'Delivered';

-- Q15
-- Calculate the average unit_price of products in each category

SELECT category,
AVG(unit_price) AS average_price
FROM products
GROUP BY category;

-- Q16
-- For each order status, find the count of orders
-- and total revenue. Sort by total revenue descending.

SELECT status,
COUNT(*) AS total_orders,
SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;

-- Q17
-- Find the most expensive and cheapest product in each category

SELECT category,
MAX(unit_price) AS most_expensive_product,
MIN(unit_price) AS cheapest_product
FROM products
GROUP BY category;

-- Q18
-- List all product categories where the average unit_price
-- is greater than ₹2000

SELECT category,
AVG(unit_price) AS average_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

-- =====================================
-- Section D
-- Joins & Relationships
-- =====================================

-- Q19
-- Display each order along with customer details

SELECT
o.order_id,
o.order_date,
c.first_name,
c.last_name,
o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- Q20
-- List all customers and their orders using LEFT JOIN

SELECT
c.customer_id,
c.first_name,
c.last_name,
o.order_id,
o.order_date,
o.total_amount
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- Q21
-- Display order details using orders, order_items,
-- and products tables

SELECT
o.order_id,
p.product_name,
oi.quantity,
oi.unit_price,
oi.discount_pct
FROM orders o
INNER JOIN order_items oi
ON o.order_id = oi.order_id
INNER JOIN products p
ON oi.product_id = p.product_id;

-- Q22
-- Difference between LEFT JOIN, RIGHT JOIN and FULL OUTER JOIN

-- LEFT JOIN:
-- Returns all rows from the left table and matching rows
-- from the right table. If no match exists, NULL values are returned.

-- Example:
SELECT
c.customer_id,
c.first_name,
o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- RIGHT JOIN:
-- Returns all rows from the right table and matching rows
-- from the left table. If no match exists, NULL values are returned.

-- Example:
SELECT
c.customer_id,
c.first_name,
o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

-- FULL OUTER JOIN:
-- Returns all rows from both tables.
-- Matching rows are combined.
-- Non-matching rows from either table are also included with NULL values.

-- Use Case:
-- When we want to see every customer and every order,
-- including customers without orders and orders without customers.

-- Note:
-- MySQL does not directly support FULL OUTER JOIN.
-- It can be simulated using UNION of LEFT JOIN and RIGHT JOIN.

-- Q23
-- Identify all Foreign Key relationships in the schema.
-- Explain what happens if customer_id = 999 is inserted.

-- Foreign Key Relationships:

-- 1.
-- orders.customer_id
-- references customers.customer_id

-- 2.
-- order_items.order_id
-- references orders.order_id

-- 3.
-- order_items.product_id
-- references products.product_id

-- Purpose of Foreign Keys:
-- Foreign Keys maintain referential integrity between tables.
-- They ensure that related records exist before insertion.

-- Example:

INSERT INTO orders
VALUES
(1011, 999, '2024-09-01', 'Pending', 1000.00);

-- Expected Result:
-- MySQL will generate a Foreign Key constraint error.

-- Reason:
-- customer_id = 999 does not exist in customers table.
-- Therefore the order cannot be linked to a valid customer.

-- This prevents orphan records and maintains data consistency.

-- =====================================
-- Section E
-- Advanced Concepts
-- =====================================

-- Q24
-- Classify products into price tiers using CASE

SELECT
product_name,
unit_price,
CASE
    WHEN unit_price < 1000 THEN 'Budget'
    WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
    ELSE 'Premium'
END AS price_tier
FROM products;

-- Q25
-- Count Delivered vs Not Delivered orders using CASE

SELECT
SUM(
    CASE
        WHEN status = 'Delivered' THEN 1
        ELSE 0
    END
) AS delivered_orders,

SUM(
    CASE
        WHEN status <> 'Delivered' THEN 1
        ELSE 0
    END
) AS not_delivered_orders
FROM orders;

-- Q26
-- Explain ACID properties with a bank transfer example.

-- ACID Properties:

-- A - Atomicity
-- Atomicity means a transaction is treated as a single unit.
-- Either all operations succeed or all fail.
-- Example:
-- If ₹1000 is transferred from Account A to Account B,
-- both debit and credit operations must succeed together.
-- If one fails, the entire transaction is rolled back.

-- C - Consistency
-- Consistency ensures that data remains valid before and after a transaction.
-- Example:
-- If total money in the banking system was ₹50,000 before the transfer,
-- it should remain ₹50,000 after the transfer.

-- I - Isolation
-- Isolation ensures that multiple transactions do not interfere with each other.
-- Example:
-- If two users transfer money at the same time,
-- each transaction should execute independently without affecting the other.

-- D - Durability
-- Durability ensures that once a transaction is committed,
-- the changes are permanently saved.
-- Example:
-- After a successful bank transfer,
-- the updated account balances remain saved even if the system crashes.

-- Q27
-- Transaction to insert an order, insert order items,
-- update stock quantities, and commit/rollback as required.

START TRANSACTION;

-- Step 1: Insert new order
INSERT INTO orders
(order_id, customer_id, order_date, status, total_amount)
VALUES
(1011, 102, CURDATE(), 'Pending', 1598.00);

-- Step 2: Insert order items
INSERT INTO order_items
(item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES
(5016, 1011, 206, 1, 1299.00, 0);

INSERT INTO order_items
(item_id, order_id, product_id, quantity, unit_price, discount_pct)
VALUES
(5017, 1011, 208, 1, 299.00, 0);

-- Step 3: Update stock quantities

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 206;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 208;

-- Step 4:
-- If all statements execute successfully

COMMIT;

-- If any statement fails

-- ROLLBACK;
