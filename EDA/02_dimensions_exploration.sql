/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - Understand structure and distribution of dimension attributes
    - Validate categorical segmentation
===============================================================================
*/

---------------------------------------
-- Customer Dimensions
---------------------------------------

-- Country distribution
SELECT 
    country,
    COUNT(*) AS total_customers
FROM gold.customers
GROUP BY country
ORDER BY total_customers DESC;

-- Gender distribution
SELECT 
    gender,
    COUNT(*) AS total_customers
FROM gold.customers
GROUP BY gender
ORDER BY total_customers DESC;


---------------------------------------
-- Product Dimensions
---------------------------------------

-- Category distribution
SELECT 
    category,
    COUNT(*) AS total_products
FROM gold.products
GROUP BY category
ORDER BY total_products DESC;

-- Subcategory distribution within each category
SELECT 
    category,
    subcategory,
    COUNT(*) AS total_products
FROM gold.products
GROUP BY category, subcategory
ORDER BY category, total_products DESC;

-- Total number of products
SELECT 
    COUNT(*) AS total_products
FROM gold.products;



