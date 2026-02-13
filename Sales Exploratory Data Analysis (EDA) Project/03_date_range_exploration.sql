/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - Identify temporal coverage of sales and customer data
    - Validate historical completeness
===============================================================================
*/

---------------------------------------
-- Sales Date Coverage
---------------------------------------
SELECT 
    MIN(order_date)                                     AS first_order_date,
    MAX(order_date)                                     AS last_order_date,
    DATEDIFF(DAY,   MIN(order_date), MAX(order_date))   AS order_range_days,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date))   AS order_range_months,
    DATEDIFF(YEAR,  MIN(order_date), MAX(order_date))   AS order_range_years
FROM gold.sales;

---------------------------------------
-- Shipping & Due Date Coverage
---------------------------------------
SELECT 
    MIN(shipping_date) AS first_shipping_date,
    MAX(shipping_date) AS last_shipping_date,
    MIN(due_date)      AS first_due_date,
    MAX(due_date)      AS last_due_date
FROM gold.sales;

---------------------------------------
-- Shipping Delay Analysis
---------------------------------------
SELECT 
    MIN(DATEDIFF(DAY, order_date, shipping_date)) AS min_shipping_days,
    MAX(DATEDIFF(DAY, order_date, shipping_date)) AS max_shipping_days,
    AVG(DATEDIFF(DAY, order_date, shipping_date)) AS avg_shipping_days
FROM gold.sales;

---------------------------------------
-- Customer Lifecycle Timeline
---------------------------------------
SELECT 
    MIN(birthdate)   AS oldest_customer_birthdate,
    MAX(birthdate)   AS youngest_customer_birthdate,
    MIN(create_date) AS first_customer_created,
    MAX(create_date) AS last_customer_created
FROM gold.customers;

---------------------------------------
-- Product Launch Coverage
---------------------------------------
SELECT 
    MIN(start_date) AS first_product_launch,
    MAX(start_date) AS last_product_launch
FROM gold.products;
