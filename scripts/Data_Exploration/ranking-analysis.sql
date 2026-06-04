/*
===============================================================================
Database Exploration (Top and Bottom Performers)
===============================================================================
Purpose:
    - To identify the top 5 best-performing products by total revenue.
    - To identify the top 5 worst-performing products by total revenue.
    - To rank products using window functions to isolate the top 5.
    - To identify the top 10 customers generating the highest revenue.
    - To identify the top 3 customers with the lowest number of completed orders.

Tables Used:
    - gold.dim_products
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- 5 best-performing products
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS revenue_by_product
FROM gold.dim_products p
INNER JOIN gold.fact_sales s
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY revenue_by_product DESC;


-- 5 worst-performing products
SELECT TOP 5
    p.product_name,
    SUM(s.sales_amount) AS revenue_by_product
FROM gold.dim_products p
INNER JOIN gold.fact_sales s
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY revenue_by_product ASC;


-- Rank data by best performing
SELECT 
    product_name,
    revenue_by_product,
    rank_products
FROM (
    SELECT 
        p.product_name,
        SUM(s.sales_amount) AS revenue_by_product,
        ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
    FROM gold.dim_products p
    INNER JOIN gold.fact_sales s
        ON p.product_key = s.product_key
    GROUP BY p.product_name
) t
WHERE rank_products <= 5;


-- Top 10 customers with the most revenue
SELECT TOP 10
    c.customer_key,
    c.first_name + ' ' + c.last_name AS customer_name,
    SUM(s.sales_amount)              AS total_sales_by_customer
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name + ' ' + c.last_name
ORDER BY total_sales_by_customer DESC;


-- Customers with fewest orders 
SELECT TOP 3
    c.customer_key,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(DISTINCT s.order_number)   AS total_orders_by_customer
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name + ' ' + c.last_name
ORDER BY total_orders_by_customer ASC;
