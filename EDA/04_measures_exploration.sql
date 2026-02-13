/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - Provide high-level quantitative summary of business performance
    - Evaluate sales magnitude and operational efficiency
===============================================================================
*/

-- =====================================================
-- 1. Core Sales & Efficiency Metrics
-- =====================================================

WITH sales_summary AS
(
    SELECT
        SUM(sales_amount)            AS total_sales,
        SUM(quantity)                AS total_quantity_sold,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS active_customers,
        COUNT(DISTINCT product_key)  AS sold_products
    FROM gold.sales
)

SELECT
    ss.total_sales,
    ss.total_quantity_sold,
    ss.total_orders,
    ss.active_customers,
    ss.sold_products,

    -- Derived efficiency metrics
    CAST(ss.total_sales * 1.0 / NULLIF(ss.total_orders, 0) AS decimal(10,2))        AS avg_order_value,
    CAST(ss.total_quantity_sold * 1.0 / NULLIF(ss.total_orders, 0) AS decimal(10,2)) AS avg_items_per_order,
    CAST(ss.total_sales * 1.0 / NULLIF(ss.active_customers, 0) AS decimal(10,2))     AS avg_revenue_per_customer,
    CAST(ss.total_orders * 1.0 / NULLIF(ss.active_customers, 0) AS decimal(10,2))    AS avg_orders_per_customer
FROM sales_summary ss;



-- =====================================================
-- 2. Product Catalog Utilization
-- =====================================================

WITH product_stats AS
(
    SELECT
        COUNT(*) AS total_products
    FROM gold.products
),
sales_stats AS
(
    SELECT
        COUNT(DISTINCT product_key) AS products_sold
    FROM gold.sales
)

SELECT
    s.products_sold,
    p.total_products,
    CAST(s.products_sold * 100.0 / NULLIF(p.total_products, 0) AS decimal(10,2))
        AS product_utilization_percentage
FROM sales_stats s
CROSS JOIN product_stats p;



-- =====================================================
-- 3. Entity Totals (Reference Counts)
-- =====================================================

SELECT
    c.total_customers,
    p.total_products
FROM
    (SELECT COUNT(*) AS total_customers FROM gold.customers) c
CROSS JOIN
    (SELECT COUNT(*) AS total_products FROM gold.products) p;
