/*
===============================================================================
Ranking Analysis
Purpose:
Identify top and bottom performers across Products, Customers, Country, Year
===============================================================================
*/

---------------------------------------------------
-- 1. Products — Revenue
---------------------------------------------------

-- Top 5 by Revenue
WITH cte_product AS
(
    SELECT
        p.product_key,
        COALESCE(p.product_name, 'Unknown') AS product_name,
        SUM(s.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_position
    FROM gold.products p
    INNER JOIN gold.sales s
        ON p.product_key = s.product_key
    GROUP BY p.product_key, p.product_name
)
SELECT *
FROM cte_product
WHERE rank_position <= 5;



-- Bottom 5 by Revenue
WITH cte_product AS
(
    SELECT
        p.product_key,
        COALESCE(p.product_name, 'Unknown') AS product_name,
        SUM(s.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(s.sales_amount) ASC) AS rank_position
    FROM gold.products p
    INNER JOIN gold.sales s
        ON p.product_key = s.product_key
    GROUP BY p.product_key, p.product_name
)
SELECT *
FROM cte_product
WHERE rank_position <= 5;



---------------------------------------------------
-- 2. Products — Quantity Sold
---------------------------------------------------

-- Top 5 by Quantity
WITH cte_product AS
(
    SELECT
        p.product_key,
        COALESCE(p.product_name, 'Unknown') AS product_name,
        SUM(s.quantity) AS total_quantity,
        RANK() OVER (ORDER BY SUM(s.quantity) DESC) AS rank_position
    FROM gold.products p
    INNER JOIN gold.sales s
        ON p.product_key = s.product_key
    GROUP BY p.product_key, p.product_name
)
SELECT *
FROM cte_product
WHERE rank_position <= 5;



-- Bottom 5 by Quantity
WITH cte_product AS
(
    SELECT
        p.product_key,
        COALESCE(p.product_name, 'Unknown') AS product_name,
        SUM(s.quantity) AS total_quantity,
        RANK() OVER (ORDER BY SUM(s.quantity) ASC) AS rank_position
    FROM gold.products p
    INNER JOIN gold.sales s
        ON p.product_key = s.product_key
    GROUP BY p.product_key, p.product_name
)
SELECT *
FROM cte_product
WHERE rank_position <= 5;



---------------------------------------------------
-- 3. Customers — Revenue
---------------------------------------------------

-- Top 10 by Revenue
WITH cte_customer AS
(
    SELECT
        c.customer_key,
        CONCAT(COALESCE(c.first_name,''),' ',COALESCE(c.last_name,'')) AS full_name,
        SUM(s.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_position
    FROM gold.customers c
    INNER JOIN gold.sales s
        ON c.customer_key = s.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
)
SELECT *
FROM cte_customer
WHERE rank_position <= 10;



-- Bottom 10 by Revenue
WITH cte_customer AS
(
    SELECT
        c.customer_key,
        CONCAT(COALESCE(c.first_name,''),' ',COALESCE(c.last_name,'')) AS full_name,
        SUM(s.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(s.sales_amount) ASC) AS rank_position
    FROM gold.customers c
    INNER JOIN gold.sales s
        ON c.customer_key = s.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
)
SELECT *
FROM cte_customer
WHERE rank_position <= 10;



---------------------------------------------------
-- 4. Customers — Number of Orders
---------------------------------------------------

-- Top 5 by Orders
WITH cte_customer AS
(
    SELECT
        c.customer_key,
        CONCAT(COALESCE(c.first_name,''),' ',COALESCE(c.last_name,'')) AS full_name,
        COUNT(DISTINCT s.order_number) AS total_orders,
        RANK() OVER (ORDER BY COUNT(DISTINCT s.order_number) DESC) AS rank_position
    FROM gold.customers c
    INNER JOIN gold.sales s
        ON c.customer_key = s.customer_key
    GROUP BY c.customer_key, c.first_name, c.last_name
)
SELECT *
FROM cte_customer
WHERE rank_position <= 5;



---------------------------------------------------
-- 5. Country Performance
---------------------------------------------------

WITH cte_country AS
(
    SELECT
        COALESCE(c.country,'Unknown') AS country,
        SUM(s.sales_amount) AS total_revenue,
        COUNT(DISTINCT s.order_number) AS total_orders,
        SUM(s.quantity) AS total_quantity,
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_revenue,
        RANK() OVER (ORDER BY COUNT(DISTINCT s.order_number) DESC) AS rank_orders,
        RANK() OVER (ORDER BY SUM(s.quantity) DESC) AS rank_quantity
    FROM gold.customers c
    INNER JOIN gold.sales s
        ON c.customer_key = s.customer_key
    GROUP BY c.country
)
SELECT *
FROM cte_country
ORDER BY rank_revenue;



---------------------------------------------------
-- 6. Year Performance
---------------------------------------------------

WITH cte_year AS
(
    SELECT
        YEAR(s.order_date) AS year,
        SUM(s.sales_amount) AS total_revenue,
        COUNT(DISTINCT s.order_number) AS total_orders,
        SUM(s.quantity) AS total_quantity,
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_revenue,
        RANK() OVER (ORDER BY COUNT(DISTINCT s.order_number) DESC) AS rank_orders
    FROM gold.sales s
    WHERE s.order_date IS NOT NULL
    GROUP BY YEAR(s.order_date)
)
SELECT *
FROM cte_year
ORDER BY rank_revenue;



---------------------------------------------------
-- 7. Highest Revenue Month per Year
---------------------------------------------------

WITH cte_year_month AS
(
    SELECT
        YEAR(s.order_date) AS year,
        DATENAME(MONTH, s.order_date) AS month,
        SUM(s.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER ( PARTITION BY YEAR(s.order_date) ORDER BY SUM(s.sales_amount) DESC ) AS rank_position
    FROM gold.sales s
    WHERE s.order_date IS NOT NULL
    GROUP BY
        YEAR(s.order_date),
        DATENAME(MONTH, s.order_date)
)
SELECT year,
month AS highest_revenue_month,
total_revenue
FROM cte_year_month
WHERE rank_position = 1
ORDER BY year;
