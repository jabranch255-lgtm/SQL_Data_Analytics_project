/*
===============================================================================
Database Exploration (Key Business Metrics)
===============================================================================
Purpose:
    - To calculate high-level performance indicators for sales volume, items, and pricing.
    - To determine entity counts for orders, products, and customer engagement.
    - To generate a consolidated summary report of all key metrics using UNION ALL.

Tables Used:
    - gold.fact_sales
    - gold.dim_products
    - gold.dim_customers
===============================================================================
*/

-- Find total sales
SELECT 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


-- Find how many items are sold 
SELECT 
    SUM(quantity) AS total_items 
FROM gold.fact_sales;


-- Find the average selling price 
SELECT 
    AVG(price) AS avg_price
FROM gold.fact_sales;


-- Find the total number of orders 
SELECT 
    COUNT(*)                      AS total_orders,
    COUNT(DISTINCT order_number) AS total_orders_unique
FROM gold.fact_sales;


-- Find the total products
SELECT 
    COUNT(product_key)          AS total_products,
    COUNT(DISTINCT product_key) AS total_products_unique
FROM gold.dim_products;


-- Find total number of customers 
SELECT 
    COUNT(customer_key)          AS total_customers,
    COUNT(DISTINCT customer_key) AS total_customers_unique
FROM gold.dim_customers;


-- Find the customers that have placed the order 
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers_ordered,
    COUNT(customer_key)          AS total_customer_rows
FROM gold.fact_sales;


-- Generate a report on all key metrics in business logic 
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'AVG Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total NO OF Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total NO OF Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total NO OF Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'Total NO OF Customer with Order', COUNT(DISTINCT customer_key) FROM gold.fact_sales;
