CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(30)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(30),
    price NUMERIC(8,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
);

INSERT INTO customers VALUES
(1,'Ali','Karachi'),(2,'Sara','Lahore'),(3,'Bilal','Karachi'),
(4,'Hina','Islamabad'),(5,'Usman','Lahore');

INSERT INTO products VALUES
(101,'Wireless Mouse','Electronics',15.00),
(102,'Mechanical Keyboard','Electronics',45.00),
(103,'Notebook','Stationery',3.00),
(104,'Desk Lamp','Home',20.00),
(105,'Water Bottle','Home',8.00);

INSERT INTO orders VALUES
(1001,1,'2023-05-01'),(1002,2,'2023-05-03'),(1003,1,'2023-05-10'),
(1004,3,'2023-05-12'),(1005,4,'2023-05-15'),(1006,2,'2023-05-20'),
(1007,5,'2023-05-22'),(1008,1,'2023-05-28');

INSERT INTO order_items VALUES
(1,1001,101,2),(2,1001,103,5),
(3,1002,102,1),
(4,1003,104,1),(5,1003,105,3),
(6,1004,101,1),
(7,1005,102,2),(8,1005,103,10),
(9,1006,105,4),
(10,1007,104,2),
(11,1008,101,1),(12,1008,102,1);

-- 1. Multi-table join: For every order, show the customer's name, the order date, 
-- and the product names included in that order.
SELECT
	o.order_id,
	c.name AS customer_name,
	o.order_date,
	p.name AS product_name
FROM orders o
JOIN customers c
ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id;

-- 2. Aggregation across joins: For each customer, calculate their total amount spent. 
-- Order highest spender first.
SELECT
    c.customer_id,
    c.name,
    SUM(oi.quantity * p.price) AS total_amount_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_amount_spent DESC;

-- 3. HAVING: Which customers have spent more than $50 in total?
SELECT
    c.customer_id,
    c.name,	
    SUM(oi.quantity * p.price) AS total_amount_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
GROUP BY c.customer_id, c.name
HAVING SUM(oi.quantity * p.price) > 50;

-- 4. Subquery: List all products that have never been ordered 
-- (i.e., don't appear in order_items at all).
SELECT * 
FROM products
WHERE product_id NOT IN(
	SELECT product_id
	FROM order_items
);

-- 5. CTE: Find customers who spent more 
-- than the average total spend across all customers.
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.name
)
SELECT *
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals);

-- 6. Ranking window function: Rank customers by total spend using RANK() or DENSE_RANK(), 
-- showing customer name, total spend, and rank.
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.name
)
SELECT
    name,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM customer_totals;

-- 7. GROUP BY on a joined column: Which product category generated the most total revenue?
SELECT
    p.category,
    SUM(oi.quantity * p.price) AS category_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;