/*
===============================================================================
Database Exploration (Category Contribution and Product Segmentation)
===============================================================================
Purpose:
    - To determine the sales performance and percentage contribution of each product category.
    - To segment products into distinct cost brackets and evaluate the distribution density.

Tables Used:
    - gold.fact_sales
    - gold.dim_products
===============================================================================
*/

-- 1. Identify which category contributes the most to overall sales 
WITH category_sales AS (
    SELECT 
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.category
)
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND(CAST(total_sales AS FLOAT) * 100 / SUM(total_sales) OVER (), 2), '%') AS percentage_of_sales
FROM category_sales
ORDER BY total_sales DESC;


-- 2. Segment products into cost ranges and verify distribution 
WITH product_segment AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;
