/*
===============================================================================
Database Exploration (Monthly Sales Trends and Running Totals)
===============================================================================
Purpose:
    - To calculate total revenue and average price on a monthly baseline.
    - To compute a partition-based running total of sales resetting each year.
    - To track a moving/running average price change over chronological months.

Table Used:
    - gold.fact_sales
===============================================================================
*/

-- Total sales in a month and the running total of sales over the month 
SELECT 
    order_date,
    sales_per_month,
    avg_price,
    SUM(sales_per_month) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total,
    AVG(avg_price)       OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_avg
FROM (
    SELECT 
        DATETRUNC(MONTH, order_date) AS order_date,
        SUM(sales_amount)            AS sales_per_month,
        AVG(price)                   AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) t;
