/*
===============================================================================
Database Exploration (Customer Segmentation Analysis)
===============================================================================
Purpose:
    - To group customers into three behavioral segments:
        * VIP: Customer with a lifespan of 12+ months and spending > $5000.
        * Regular: Customer with a lifespan of 12+ months and spending <= $5000.
        * New: Customer with a lifespan of less than 12 months.
    - To calculate the aggregate number of customers within each defined segment.

Tables Used:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

WITH customer_spending AS (
    SELECT 
        c.customer_key,
        SUM(s.sales_amount)                               AS total_spending,
        MIN(s.order_date)                                 AS first_order,
        MAX(s.order_date)                                 AS last_order,
        DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS life_span
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN life_span >= 12 AND total_spending > 5000  THEN 'VIP'
            WHEN life_span >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'NEW'
        END AS customer_segment
    FROM customer_spending
) t
GROUP BY customer_segment
ORDER BY total_customers DESC;
