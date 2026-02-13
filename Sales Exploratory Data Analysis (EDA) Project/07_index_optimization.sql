/*
===============================================================================
Indexing Script
Project : DataAnalyticsProject
Schema  : gold

Purpose:
    - Improve JOIN performance
    - Improve GROUP BY performance
    - Support date-based analysis
    - Keep indexing simple and professional (Fresher Level)
===============================================================================
*/


USE DataAnalyticsProject;
GO



/*==============================================================================
1. SALES TABLE INDEXES
==============================================================================*/

-- Improve joins with products
CREATE NONCLUSTERED INDEX IX_sales_product
ON gold.sales (product_key);

-- Improve joins with customers
CREATE NONCLUSTERED INDEX IX_sales_customer
ON gold.sales (customer_key);


-- Improve date-based analysis (Year / Month grouping)
CREATE NONCLUSTERED INDEX IX_sales_orderdate
ON gold.sales (order_date);



/*==============================================================================
2. PRODUCTS TABLE INDEX
==============================================================================*/

-- Improve category-based grouping
CREATE NONCLUSTERED INDEX IX_products_category
ON gold.products (category);


/*==============================================================================
3. CUSTOMERS TABLE INDEX
==============================================================================*/

-- Improve country-based grouping
CREATE NONCLUSTERED INDEX IX_customers_country
ON gold.customers (country);
GO


