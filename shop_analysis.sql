
CREATE DATABASE shop_analysis;
USE shop_analysis;

-- 1. Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

-- 2. Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- 3. Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 4. Items in each order
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- Sample customers
INSERT INTO customers VALUES
(1, 'Aarav', 'Bengaluru'),
(2, 'Meera', 'Mysuru'),
(3, 'Kabir', 'Mumbai'),
(4, 'Diya', 'Chennai'),
(5, 'Ishaan', 'Bengaluru');

-- Sample products
INSERT INTO products VALUES
(101, 'Wireless Mouse', 'Electronics', 799.00),
(102, 'Water Bottle', 'Lifestyle', 399.00),
(103, 'Desk Lamp', 'Home', 1299.00),
(104, 'Notebook Set', 'Stationery', 249.00),
(105, 'Headphones', 'Electronics', 1499.00);

-- Sample orders
INSERT INTO orders VALUES
(1001, 1, '2026-09-01', 'Delivered'),
(1002, 2, '2026-09-02', 'Delivered'),
(1003, 3, '2026-09-03', 'Cancelled'),
(1004, 1, '2026-09-05', 'Delivered'),
(1005, 4, '2026-09-07', 'Shipped'),
(1006, 5, '2026-09-10', 'Delivered'),
(1007, 2, '2026-09-12', 'Delivered'),
(1008, 3, '2026-09-15', 'Shipped');

-- Products purchased in each order
INSERT INTO order_items VALUES
(1, 1001, 101, 2, 799.00),
(2, 1001, 104, 3, 249.00),
(3, 1002, 102, 2, 399.00),
(4, 1002, 104, 1, 249.00),
(5, 1003, 105, 1, 1499.00),
(6, 1004, 103, 1, 1299.00),
(7, 1004, 102, 1, 399.00),
(8, 1005, 105, 2, 1499.00),
(9, 1006, 101, 1, 799.00),
(10, 1006, 103, 2, 1299.00),
(11, 1007, 104, 4, 249.00),
(12, 1008, 102, 3, 399.00);


-- Verify the created tables and inspect sample customer records
SHOW TABLES;
SELECT * FROM customers;

-- BUSINESS ANALYSIS QUERIES
-- ANALYSIS 1: Product units sold (excluding cancelled orders)
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_name
ORDER BY total_units_sold DESC;


-- ANALYSIS 2: Revenue by product category (excluding cancelled orders)
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.category
ORDER BY revenue DESC;

-- ANALYSIS 3: Customer order count and total order value (excluding cancelled orders)
SELECT
    c.customer_name,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_order_value DESC;

-- ANALYSIS 4: Customer count and sales by city (excluding cancelled orders)
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.city
ORDER BY total_sales DESC;

-- ANALYSIS 5: Top three customers by spending on delivered orders
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 3;


-- ANALYSIS 6: Total revenue from delivered orders
SELECT SUM(oi.quantity * oi.unit_price) AS delivered_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Delivered';

-- ANALYSIS 7: Value of each delivered order
SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY o.order_id;

-- ANALYSIS 8: Average value of delivered orders
SELECT AVG(order_value) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.unit_price) AS order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY o.order_id
) AS delivered_orders;

-- ANALYSIS 9: Number of orders by status
SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- ANALYSIS 10: Top-selling products (excluding cancelled orders)
SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- ANALYSIS 11: Revenue by city from delivered orders
SELECT
    c.city,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.city
ORDER BY revenue DESC;

-- ANALYSIS 12: Revenue by product (excluding cancelled orders)
SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_name
ORDER BY revenue DESC;

-- ANALYSIS 13: Order-item value grouped by order status
SELECT
    o.status,
    SUM(oi.quantity * oi.unit_price) AS order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY order_value DESC;

-- ANALYSIS 14: Customer spending on delivered orders
SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;

-- ANALYSIS 15: Revenue by category (excluding cancelled orders)
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.category
ORDER BY revenue DESC;