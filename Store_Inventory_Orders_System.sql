-----------------------Name:Walid Jerjawi------------------------
-------------------------QAP2_DATABASE---Problem#2-----Check the PDF file for Data outputs-------------------
-------------------------2025-02-04 -  2025-02-06---------------


-- Problem 2 - Online Store Inventory and Orders System


-- Create Tables

-- Creating Products Table
CREATE TABLE products (
	product_id SERIAL PRIMARY KEY,
	product_name TEXT,
	price DECIMAL(10,2),
	stock_quantity INT
);

-- Creating Customers Table
CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name TEXT,
	last_name TEXT,
	email TEXT
);

-- Creating Orders Table
CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	order_date DATE
);

-- Creating Orders-items Table
CREATE TABLE order_items (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);

---------------------------------------------------------------------------

-- Insert Data

-- Inserting Products Data
INSERT INTO products (product_name, price, stock_quantity) VALUES
    ('T-Shirt', 19.99, 50),
    ('Jeans', 49.99, 30),
    ('Jacket', 89.99, 20),
    ('Sweater', 39.99, 25),
    ('Sneakers', 59.99, 40);


-- Inserting Customers Data
INSERT INTO customers (first_name, last_name, email) VALUES
    ('Mohamed', 'Salah', 'mosalah@example.com'),
    ('Roberto', 'Carlos', 'roberto.carl@example.com'),
    ('Antonio', 'Modest', 'anton_modest@example.com'),
    ('Amanda', 'Winfrey', 'amanda_win@example.com');


-- Inserting Orders Data
INSERT INTO orders (customer_id, order_date) VALUES
    (1, '2023-09-01'),
    (2, '2023-08-29'),
    ((SELECT customer_id FROM customers WHERE first_name = 'Antonio' AND last_name = 'Modest' ), '2023-09-05'),
    (4, '2023-09-04'),
    ((SELECT customer_id FROM customers WHERE first_name = 'Mohamed' AND last_name = 'Salah' ), '2023-08-23');


-- Inserting Order_Items Data

INSERT INTO order_items (order_id, product_id, quantity) VALUES

	(1, (SELECT product_id FROM products WHERE product_name = 'T-Shirt'), 2), -- Mohamed bought 2 T-Shirts

    (1, (SELECT product_id FROM products WHERE product_name = 'Jacket'), 1), -- Mohamed bought 1 Jacket
    ((SELECT order_id FROM orders WHERE customer_id = (SELECT customer_id FROM customers
	 WHERE first_name = 'Roberto')), (SELECT product_id FROM products WHERE product_name = 'Jeans'), 1), -- Roberto bought 1 Jeans


    ((SELECT order_id FROM orders WHERE customer_id = (SELECT customer_id FROM customers 
	WHERE first_name = 'Roberto')),  (SELECT product_id FROM products 
	WHERE product_name = 'Sneakers'), 1), -- Roberto bought 1 Sneakers

    (3, 4, 2), -- Antonio bought 2 Sweaters
    (3, (SELECT product_id FROM products WHERE product_name = 'T-Shirt'), 1), -- Antonio bought 1 T-Shirt
    (4, (SELECT product_id FROM products WHERE product_name = 'Jacket'), 1), -- Amanda bought 1 Jacket
    (4, (SELECT product_id FROM products WHERE product_name = 'Jeans'), 1), -- Amanda bought 1 Jeans
    (5, 5, 2), -- Mohamed bought 2 Sneakers
    (5, (SELECT product_id FROM products WHERE product_name = 'Sweater'), 1); -- Mohamed bought 1 Sweater


	-----------------------------------------------------------------------

--1) SQL Queries

--1.1) Retrieve the names and stock quantities of all products
SELECT product_name, stock_quantity FROM products;

-- 1.2) Retrieve the product names and quantites for one of the orders placed
SELECT product_name, quantity FROM products
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.order_id = 1; 

-- 1.3) Retrieve all orders placed by a specific customer (including ID's of what was ordered and quantities)
SELECT 
    orders.order_id, product_name, quantity,
    first_name || ' ' || last_name AS customer_full_name
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id
WHERE customers.first_name = 'Mohamed' AND customers.last_name = 'Salah';


------------------------------------------------------------------------

--2) Update Data
-- Perform an update to simulate the reducing of stock quantities of items after a customer places an order

UPDATE products
SET stock_quantity = stock_quantity - order_items.quantity
FROM order_items
WHERE products.product_id = order_items.product_id
AND order_items.order_id = 1;

-- Check Stock Before and after the Update Query:

SELECT product_id, product_name, stock_quantity 
FROM products
WHERE product_id IN (SELECT product_id FROM order_items WHERE order_id = 1);

----------------------------------------------------------------------------
--3) Delete Data
-- Remove one of the orders and all asscoiated order items from the system

DELETE FROM order_items WHERE order_id = 4;
DELETE FROM orders WHERE order_id = 4;

-- Check orders Before and after the Delete Query:
SELECT * FROM orders WHERE order_id = 4;
SELECT * FROM order_items WHERE order_id = 4;