/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataAnalyticsProject' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataAnalyticsProject' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataAnalyticsProject' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataAnalyticsProject')
BEGIN
    ALTER DATABASE DataAnalyticsProject SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataAnalyticsProject;
END;
GO

-- Create the 'DataAnalyticsProject' database
CREATE DATABASE DataAnalyticsProject;
GO

USE DataAnalyticsProject;
GO

-- Create Schema
CREATE SCHEMA gold;
GO

-- Customers Table
CREATE TABLE gold.customers(
	customer_key int NOT NULL,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date,
	CONSTRAINT PK_customers PRIMARY KEY (customer_key)
);
GO

-- Products Table
CREATE TABLE gold.products(
	product_key int NOT NULL,
	product_id int,
	product_number nvarchar(50),
	product_name nvarchar(50),
	category_id nvarchar(50),
	category nvarchar(50),
	subcategory nvarchar(50),
	maintenance nvarchar(50),
	cost int,
	product_line nvarchar(50),
	start_date date,
	CONSTRAINT PK_products PRIMARY KEY (product_key)
);
GO

-- Sales Table
CREATE TABLE gold.sales(
	order_number nvarchar(50) NOT NULL,
	product_key int NOT NULL,
	customer_key int NOT NULL,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int,
	CONSTRAINT PK_sales PRIMARY KEY (order_number, product_key)
);
GO

TRUNCATE TABLE gold.customers;
GO

BULK INSERT gold.customers
FROM 'C:\SQL\sql-data-analytics-project\datasets\flat-files\customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.products;
GO

BULK INSERT gold.products
FROM 'C:\SQL\sql-data-analytics-project\datasets\flat-files\products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.sales;
GO

BULK INSERT gold.sales
FROM 'C:\SQL\sql-data-analytics-project\datasets\flat-files\sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
