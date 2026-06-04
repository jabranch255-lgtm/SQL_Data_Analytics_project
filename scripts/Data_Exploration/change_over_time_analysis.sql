/*
===============================================================================
Database Exploration (Sales Performance Over Time)
===============================================================================
Purpose:
    - To analyze chronological sales trends on a daily basis.
    - To aggregate annual customer reach, product quantity, and revenue.
    - To isolate seasonal variations by analyzing metrics across calendar months.
    - To construct a detailed year-over-year monthly performance matrix.

Table Used:
    - gold.fact_sales
===============================================================================
*/

-- Analyze the sales performance over time 
SELECT 
    order_date,
    SUM(sales_amount) AS sales_by_day
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date ASC;


-- Sales by Year 
SELECT 
    YEAR(order_date)             AS order_year,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity,
    SUM(sales_amount)            AS sales_by_year
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year ASC;


-- Sales by Month
SELECT 
    MONTH(order_date)            AS order_month,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity,
    SUM(sales_amount)            AS sales_by_month
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_month ASC;


-- Sales By Month Each Year
SELECT 
    YEAR(order_date)             AS order_year,
    MONTH(order_date)            AS order_month,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity)                AS total_quantity,
    SUM(sales_amount)            AS sales_by_month
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year ASC, order_month ASC;
