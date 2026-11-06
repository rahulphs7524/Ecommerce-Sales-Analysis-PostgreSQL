-- =====================================================================
-- PROJECT: E-Commerce Sales Data Analysis
-- PLATFORM: PostgreSQL 12+
-- DATABASE: ecommerce_sales
--
-- HOW TO RUN:
--   1) In pgAdmin, create a database named ecommerce_sales.
--   2) Connect to ecommerce_sales and open Query Tool.
--   3) Open this file and execute the setup/data section.
--   4) Run the analysis queries individually to inspect each result set.
--
-- SAFETY / RE-RUN BEHAVIOUR:
--   * This script does NOT drop databases or tables.
--   * Tables are created only when they do not already exist.
--   * Sample rows are inserted with ON CONFLICT DO NOTHING.
--   * Re-running the script will not duplicate rows with existing primary keys.
--   * If you previously created incompatible tables, use a fresh database.
--
-- REVENUE RULE:
--   Revenue = quantity * sale_price, for Delivered orders only.
--   Cancelled, Shipped and Returned orders are excluded from revenue.
-- =====================================================================

-- =====================================================================
-- 1. TABLE CREATION
-- =====================================================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(60),
    state         VARCHAR(60),
    signup_date   DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id     INTEGER PRIMARY KEY,
    product_name   VARCHAR(120) NOT NULL,
    category       VARCHAR(60),
    unit_price     NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER NOT NULL,
    order_date   DATE NOT NULL,
    order_status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER NOT NULL,
    product_id    INTEGER NOT NULL,
    quantity      INTEGER NOT NULL CHECK (quantity > 0),
    sale_price    NUMERIC(10,2) NOT NULL CHECK (sale_price >= 0),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =====================================================================
-- 2. INDEXES
-- Primary keys already create indexes automatically.
-- These additional indexes support joins and common filters/grouping.
-- =====================================================================

CREATE INDEX IF NOT EXISTS idx_orders_customer_id
    ON orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_status_date
    ON orders(order_status, order_date);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items(product_id);

-- 2. SAMPLE DATA
INSERT INTO customers
(customer_id, customer_name, city, state, signup_date) VALUES
(1, 'Aarav Sharma', 'Lucknow', 'Uttar Pradesh', '2025-01-10'),
(2, 'Diya Verma', 'Kanpur', 'Uttar Pradesh', '2025-01-18'),
(3, 'Rohan Mehta', 'Jaipur', 'Rajasthan', '2025-02-02'),
(4, 'Ananya Singh', 'Delhi', 'Delhi', '2025-02-15'),
(5, 'Kabir Khan', 'Mumbai', 'Maharashtra', '2025-03-01'),
(6, 'Isha Patel', 'Ahmedabad', 'Gujarat', '2025-03-12'),
(7, 'Vivaan Gupta', 'Lucknow', 'Uttar Pradesh', '2025-03-20'),
(8, 'Meera Joshi', 'Pune', 'Maharashtra', '2025-04-05'),
(9, 'Aditya Rao', 'Hyderabad', 'Telangana', '2025-04-19'),
(10, 'Sara Das', 'Kolkata', 'West Bengal', '2025-05-02'),
(11, 'Arjun Nair', 'Kochi', 'Kerala', '2025-05-16'),
(12, 'Tara Roy', 'Delhi', 'Delhi', '2025-06-01')
ON CONFLICT DO NOTHING;

INSERT INTO products
(product_id, product_name, category, unit_price, stock_quantity) VALUES
(101, 'Wireless Mouse', 'Electronics', 599.00, 120),
(102, 'Mechanical Keyboard', 'Electronics', 2499.00, 45),
(103, 'USB-C Hub', 'Electronics', 1799.00, 60),
(104, 'Notebook Set', 'Stationery', 249.00, 200),
(105, 'Office Chair', 'Furniture', 5499.00, 18),
(106, 'Desk Lamp', 'Furniture', 1299.00, 35),
(107, 'Water Bottle', 'Lifestyle', 399.00, 150),
(108, 'Backpack', 'Lifestyle', 1599.00, 70),
(109, 'Monitor Stand', 'Furniture', 999.00, 40),
(110, 'Webcam', 'Electronics', 2199.00, 25),
(111, 'Gel Pen Pack', 'Stationery', 149.00, 300)
ON CONFLICT DO NOTHING;

INSERT INTO orders
(order_id, customer_id, order_date, order_status) VALUES
(1001, 1, '2025-01-15', 'Delivered'),
(1002, 2, '2025-01-22', 'Delivered'),
(1003, 3, '2025-02-05', 'Delivered'),
(1004, 1, '2025-02-18', 'Delivered'),
(1005, 4, '2025-02-25', 'Cancelled'),
(1006, 5, '2025-03-04', 'Delivered'),
(1007, 6, '2025-03-15', 'Delivered'),
(1008, 7, '2025-03-22', 'Shipped'),
(1009, 8, '2025-04-08', 'Delivered'),
(1010, 9, '2025-04-21', 'Delivered'),
(1011, 2, '2025-04-25', 'Delivered'),
(1012, 10, '2025-05-05', 'Cancelled'),
(1013, 11, '2025-05-18', 'Delivered'),
(1014, 12, '2025-05-24', 'Shipped'),
(1015, 3, '2025-06-03', 'Delivered'),
(1016, 4, '2025-06-12', 'Delivered'),
(1017, 5, '2025-06-20', 'Delivered'),
(1018, 6, '2025-07-02', 'Delivered'),
(1019, 7, '2025-07-11', 'Returned'),
(1020, 8, '2025-07-19', 'Delivered'),
(1021, 9, '2025-08-01', 'Delivered'),
(1022, 10, '2025-08-09', 'Delivered'),
(1023, 1, '2025-08-15', 'Delivered'),
(1024, 11, '2025-08-22', 'Shipped')
ON CONFLICT DO NOTHING;

INSERT INTO order_items
(order_item_id, order_id, product_id, quantity, sale_price) VALUES
(1,1001,101,2,579.00),(2,1001,104,3,239.00),
(3,1002,102,1,2399.00),(4,1002,111,2,139.00),
(5,1003,108,1,1499.00),(6,1003,107,2,379.00),
(7,1004,103,1,1749.00),(8,1004,101,1,579.00),
(9,1005,105,1,5299.00),
(10,1006,110,1,2099.00),(11,1006,104,5,229.00),
(12,1007,106,2,1249.00),(13,1007,107,1,379.00),
(14,1008,102,1,2399.00),(15,1008,109,1,949.00),
(16,1009,105,1,5299.00),(17,1009,101,2,579.00),
(18,1010,103,2,1749.00),(19,1010,111,3,139.00),
(20,1011,108,1,1499.00),(21,1011,104,4,229.00),
(22,1012,110,1,2099.00),
(23,1013,102,1,2399.00),(24,1013,107,2,379.00),
(25,1014,106,1,1249.00),(26,1014,111,4,139.00),
(27,1015,101,3,579.00),(28,1015,103,1,1749.00),
(29,1016,109,2,949.00),(30,1016,104,6,229.00),
(31,1017,105,1,5299.00),(32,1017,108,1,1499.00),
(33,1018,110,2,2099.00),(34,1018,101,1,579.00),
(35,1019,102,1,2399.00),
(36,1020,107,3,379.00),(37,1020,111,5,139.00),
(38,1021,103,1,1749.00),(39,1021,106,1,1249.00),
(40,1022,108,2,1499.00),(41,1022,104,3,229.00),
(42,1023,101,2,579.00),(43,1023,110,1,2099.00),
(44,1024,109,1,949.00),(45,1024,107,2,379.00)
ON CONFLICT DO NOTHING;


-- Refresh planner statistics after loading the sample dataset.
ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;

-- =====================================================================
-- 3. DATA VALIDATION
-- =====================================================================

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
ORDER BY table_name;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- ============================================================
-- 4. DATA EXPLORATION
-- ============================================================

-- Q1. View all customers.
SELECT * FROM customers;

-- Q2. View all products, from highest to lowest price.
SELECT product_name, category, unit_price
FROM products
ORDER BY unit_price DESC;

-- Q3. Find orders placed in the first half of 2025.
SELECT *
FROM orders
WHERE order_date BETWEEN '2025-01-01' AND '2025-06-30';

-- ============================================================
-- 5. BUSINESS ANALYSIS
-- Revenue below is calculated from delivered orders only.
-- Revenue = quantity * sale_price.
-- ============================================================

-- Q4. Total number of orders by status.
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Q5. Total delivered revenue.
SELECT ROUND(SUM(oi.quantity * oi.sale_price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered';

-- Q6. Monthly delivered revenue.
SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS sales_month,
       ROUND(SUM(oi.quantity * oi.sale_price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY sales_month;

-- Q7. Top 5 products by delivered revenue.
SELECT p.product_name,
       SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.quantity * oi.sale_price), 2) AS product_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC
LIMIT 5;

-- Q8. Revenue by product category.
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.sale_price), 2) AS category_revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Q9. Top 5 customers by delivered spending.
SELECT c.customer_id, c.customer_name,
       ROUND(SUM(oi.quantity * oi.sale_price), 2) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;

-- Q10. Average delivered order value.
SELECT ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT o.order_id,
           SUM(oi.quantity * oi.sale_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) AS delivered_order_totals;

-- Q11. Customers who have never placed an order.
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q12. Products that have never been ordered.
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Q13. Orders with a value greater than the average delivered order value.
WITH order_totals AS (
    SELECT o.order_id, o.order_date, o.order_status,
           SUM(oi.quantity * oi.sale_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id, o.order_date, o.order_status
)
SELECT order_id, order_date, ROUND(order_total, 2) AS order_total
FROM order_totals
WHERE order_total > (SELECT AVG(order_total) FROM order_totals)
ORDER BY order_total DESC;

-- Q14. Rank products by revenue within each category.
WITH product_revenue AS (
    SELECT p.product_id, p.product_name, p.category,
           SUM(oi.quantity * oi.sale_price) AS revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name, p.category
)
SELECT product_name, category,
       ROUND(revenue, 2) AS revenue,
       DENSE_RANK() OVER (
           PARTITION BY category ORDER BY revenue DESC
       ) AS category_rank
FROM product_revenue
ORDER BY category, category_rank;

-- Q15. Running monthly revenue total.
WITH monthly_sales AS (
    SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS sales_month,
           SUM(oi.quantity * oi.sale_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
)
SELECT sales_month,
       ROUND(monthly_revenue, 2) AS monthly_revenue,
       ROUND(
           SUM(monthly_revenue) OVER (ORDER BY sales_month),
           2
       ) AS running_revenue
FROM monthly_sales
ORDER BY sales_month;

SELECT
    (SELECT COUNT(*) FROM customers) AS customers,
    (SELECT COUNT(*) FROM products) AS products,
    (SELECT COUNT(*) FROM orders) AS orders,
    (SELECT COUNT(*) FROM order_items) AS order_items;

-- ============================================================
-- 6. PROJECT NOTES
-- - This is a synthetic practice dataset, not real customer data.
-- - Revenue excludes Cancelled, Shipped, and Returned orders.
-- - Run each analysis query separately to inspect its result.
-- ============================================================
