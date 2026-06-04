/*
===============================================================================
Database Exploration (Dimensions)
===============================================================================
Purpose:
    - To explore distinct geographic data from customer records.
    - To inspect unique product categories, subcategories, and product names.

Tables Used:
    - gold.dim_customers
    - gold.dim_products
===============================================================================
*/

-- Explore all countries our customers come from 
SELECT DISTINCT
    country
FROM gold.dim_customers;


-- Explore all categories from our table Products
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products;
