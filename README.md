# E-Commerce Sales Analysis (PostgreSQL)

A beginner-to-intermediate SQL portfolio project for exploring e-commerce orders, products, customers, and sales performance using PostgreSQL.

## Project overview

This project creates a sample e-commerce database and answers 15 business questions using SQL.

### Database tables

| Table | Description |
|---|---|
| `customers` | Customer details and signup dates |
| `products` | Product names, categories, prices, and stock |
| `orders` | Customer orders, dates, and order statuses |
| `order_items` | Products, quantities, and sale prices for each order |

### SQL concepts demonstrated

- Database schema design, primary keys, and foreign keys
- `CHECK` constraints and indexes
- `INSERT ... ON CONFLICT DO NOTHING`
- Filtering, sorting, aggregation, and `GROUP BY`
- `INNER JOIN` and `LEFT JOIN`
- Subqueries and Common Table Expressions (CTEs)
- Window functions: `DENSE_RANK()` and cumulative `SUM() OVER (...)`
- Monthly revenue analysis with `TO_CHAR()`

## Requirements

- PostgreSQL 12 or later
- pgAdmin 4 (or `psql`)

## How to run with pgAdmin 4

1. Open pgAdmin 4 and connect to your PostgreSQL server.
2. Right-click **Databases** → **Create** → **Database**.
3. Name the database `ecommerce_sales` and save.
4. Select the new database and open **Query Tool**.
5. Open `sql/Ecommerce_Sales_Analysis_PostgreSQL_Optimized.sql`.
6. Execute the script. For easier review, run the setup/data section first, then execute analysis queries individually.
7. Check the validation query output. Expected sample row counts are 12 customers, 11 products, 24 orders, and 45 order items.

> If you already have tables created from an incompatible earlier version, use a fresh empty database. The script uses `CREATE TABLE IF NOT EXISTS`; it does not alter or drop existing tables.

## Business questions

The SQL script contains 15 queries covering:

1. View all customers
2. Products ordered by price
3. Orders from the first half of 2025
4. Order counts by status
5. Total delivered revenue
6. Monthly delivered revenue
7. Top five products by delivered revenue
8. Revenue by product category
9. Top five customers by delivered spending
10. Average delivered order value
11. Customers who have never ordered
12. Products that have never been ordered
13. Orders above average delivered order value
14. Product revenue ranking within each category
15. Running monthly revenue total

## Revenue definition

Revenue is calculated as `quantity * sale_price` for **Delivered** orders only. Cancelled, Shipped, and Returned orders are excluded from revenue calculations.

## Dataset

The included data is synthetic sample data created for learning and demonstration. It is not real customer or company data.


