/*
===============================================================================
Magnitude Analysis 
===============================================================================
Purpose:
    - Analyze customers, products, and sales magnitude
    - Calculate revenue, totals, quantities, and averages
    - Understand overall business scale and distribution
===============================================================================
*/


---------------------------------------
-- 1. Customer Counts
---------------------------------------
-- By Country
SELECT 
    COALESCE(country,'Unknown') AS country,
    COUNT(*) AS total_customers
FROM gold.customers
GROUP BY COALESCE(country,'Unknown')
ORDER BY total_customers DESC;

-- By Gender
SELECT 
    COALESCE(gender,'Unknown') AS gender,
    COUNT(*) AS total_customers
FROM gold.customers
GROUP BY COALESCE(gender,'Unknown')
ORDER BY total_customers DESC;


---------------------------------------
-- 2. Product Counts
---------------------------------------
-- By Category
SELECT 
    COALESCE(category,'Unknown') AS category,
    COUNT(*) AS total_products_by_category
FROM gold.products
GROUP BY COALESCE(category,'Unknown')
ORDER BY total_products_by_category DESC;


---------------------------------------
-- 3. Revenue Metrics
---------------------------------------
-- Revenue by Category
SELECT
    COALESCE(p.category,'Unknown') AS category,
    SUM(s.sales_amount) AS total_revenue
FROM gold.products p
INNER JOIN gold.sales s
    ON p.product_key = s.product_key
GROUP BY COALESCE(p.category,'Unknown')
ORDER BY total_revenue DESC;

-- Revenue by Subcategory
SELECT
    COALESCE(p.subcategory,'Unknown') AS subcategory,
    SUM(s.sales_amount) AS total_revenue
FROM gold.products p
INNER JOIN gold.sales s
    ON p.product_key = s.product_key
GROUP BY COALESCE(p.subcategory,'Unknown')
ORDER BY total_revenue DESC;

-- Revenue by Category & Subcategory
SELECT
    COALESCE(p.category,'Unknown') AS category,
    COALESCE(p.subcategory,'Unknown') AS subcategory,
    SUM(s.sales_amount) AS total_revenue
FROM gold.products p
INNER JOIN gold.sales s
    ON p.product_key = s.product_key
GROUP BY 
    COALESCE(p.category,'Unknown'), 
    COALESCE(p.subcategory,'Unknown')
ORDER BY total_revenue DESC;

-- Revenue by Customer Country
SELECT 
    COALESCE(country,'Unknown') AS country,
    SUM(s.sales_amount) AS total_revenue
FROM gold.customers c
INNER JOIN gold.sales s
    ON c.customer_key = s.customer_key
GROUP BY COALESCE(country,'Unknown')
ORDER BY total_revenue DESC;

-- Total Items Sold by Customer Country
SELECT 
    COALESCE(c.country,'Unknown') AS country,
    SUM(s.quantity) AS total_items_sold
FROM gold.customers c
INNER JOIN gold.sales s
    ON c.customer_key = s.customer_key
GROUP BY COALESCE(c.country,'Unknown')
ORDER BY total_items_sold DESC;



---------------------------------------
-- 4. Average Metrics
---------------------------------------
-- Average Revenue per Order
SELECT AVG(tr.total_revenue) AS avg_order_value
FROM (
    SELECT
        order_number,
        SUM(sales_amount) AS total_revenue
    FROM gold.sales
    GROUP BY order_number
) tr;
