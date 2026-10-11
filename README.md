# E-Commerce Sales Analysis Using SQL

## Project Overview

This project explores a sample e-commerce database using SQL to answer business questions about sales performance, customer purchasing behaviour, product demand, and order status.

The goal is to practise relational database querying and demonstrate how SQL can be used to extract useful business insights from transactional data.

## Database Structure

The database contains four related tables:

- **customers** — customer details and locations
- **products** — product names, categories, and prices
- **orders** — order dates, customers, and order statuses
- **order_items** — products purchased, quantities, and order-level item details

Primary keys and foreign keys connect the tables and support relational queries.

## Analysis Questions

The project uses SQL queries to investigate:

1. Total sales by product
2. Revenue by product category
3. Customer spending
4. Sales by city
5. Order status distribution
6. Average value of delivered orders
7. Top-selling products
8. Customer purchase activity
9. Order-level sales
10. Units sold by product
11. Additional sales and customer patterns

The SQL script also includes other related analytical queries.

## SQL Concepts Practised

- SELECT statements and filtering
- INNER JOIN and multi-table joins
- Aggregate functions such as SUM, COUNT, and AVG
- GROUP BY and ORDER BY
- Subqueries
- Sorting and limiting query results
- Relational database design using primary and foreign keys

## Tools Used

- MySQL
- MySQL Workbench
- GitHub

## Dataset

This project uses a small sample dataset created for SQL practice. It contains customer, product, order, and order-item records.

The dataset is intended for demonstrating SQL concepts and is not representative of a production-scale e-commerce business.

## How to Run the Project

1. Install MySQL and open MySQL Workbench.
2. Open `shop_analysis.sql`.
3. Execute the script to create and populate the tables and run the analysis queries.
4. Review the query outputs to explore the results.

## Project Status

Completed beginner SQL analytics project.

## Future Improvements

- Add documented business insights based on query results.
- Expand the sample dataset.
- Build an interactive dashboard using Power BI.
