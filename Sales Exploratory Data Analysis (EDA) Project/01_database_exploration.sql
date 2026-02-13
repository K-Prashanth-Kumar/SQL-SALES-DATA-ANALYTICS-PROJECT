/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - Explore the database structure, including available tables and their schemas.
    - Inspect columns, data types, nullability, and metadata for key tables.

Tables Used:
    - INFORMATION_SCHEMA.TABLES     -- To list tables in the schema
    - INFORMATION_SCHEMA.COLUMNS    -- To get column details for specific tables
===============================================================================
*/

-- 1. Show the list of available tables
SELECT * 
FROM INFORMATION_SCHEMA.TABLES 
WHERE table_schema = 'gold';


-- 2. Show the column details (Names, types, and if they can be empty)
-- Consolidating individual table checks into one for better performance
SELECT 
    table_name, 
    column_name, 
    data_type, 
    is_nullable, 
    character_maximum_length
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_schema = 'gold'
  AND table_name IN ('customers', 'products', 'sales')
ORDER BY table_name;


-- 3. Count the rows in each table to see the data size
SELECT 'customers' AS table_name, COUNT(*) AS  total_rows FROM gold.customers
UNION ALL
SELECT 'products',  COUNT(*) FROM gold.products
UNION ALL
SELECT 'sales',     COUNT(*) FROM gold.sales;


-- 4.See the first 10 rows from each table 
SELECT TOP 10 'customers' AS table_name, * FROM gold.customers;
SELECT TOP 10 'products'  AS table_name, * FROM gold.products;
SELECT TOP 10 'sales'     AS table_name, * FROM gold.sales;