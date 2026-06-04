/*
===============================================================================
Database Exploration (Year-over-Year Product Performance)
===============================================================================
Purpose:
    - To track annual product revenue streams.
    - To benchmark current annual sales against a product's overall baseline average.
    - To measure Year-over-Year (YoY) variance by comparing revenue to the previous year.
    - To classify performance shifts into directional growth categories.

Tables Used:
    - gold.fact_sales
    - gold.dim_products
===============================================================================
*/

WITH yearly_product_sales AS (
    SELECT 
        YEAR(s.order_date)  AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY 
        YEAR(s.order_date),
        p.product_name
)
SELECT 
    order_year,
    product_name,
    current_sales,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)              AS previous_sales,
    AVG(current_sales) OVER (PARTITION BY product_name)                                  AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name)                  AS diff_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS diff_change,

    -- Year-over-year analysis
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS diff_change_py
FROM yearly_product_sales
ORDER BY 
    product_name,
    order_year;
