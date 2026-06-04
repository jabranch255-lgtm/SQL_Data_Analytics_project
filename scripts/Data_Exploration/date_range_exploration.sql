/*
===============================================================================
Database Exploration (Time Span and Customer Age)
===============================================================================
Purpose:
    - To explore order dates to determine the chronological scope of sales data.
    - To analyze customer birthdates to find the age range of the user base.

Tables Used:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- Explore the dates in the tables to find the time span 
-- Find the first and the last date of order 
-- Find the total years of the available data 
SELECT 
    FORMAT(MIN(order_date), 'dd/MMM/yyyy')          AS first_order_date,
    FORMAT(MAX(order_date), 'dd/MMM/yyyy')          AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date))  AS total_year_data,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS total_month_data
FROM gold.fact_sales;


-- Find the youngest and the oldest customers 
SELECT 
    MIN(birthdate)                       AS oldest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_customer_age, 
    MAX(birthdate)                       AS youngest_birthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;
