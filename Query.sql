/********************************************************************************************
* Project Title: SQL Retail Sales Analysis (P1)
* Author: Dhanesh Gaikwad
* Description:
* This project demonstrates SQL skills through data cleaning, exploration, and analysis 
* using a simulated retail sales dataset. The objective is to extract valuable business 
* insights, identify key trends, and answer analytical questions from transactional data.
********************************************************************************************/

-- STEP 1: CREATE DATABASE
CREATE DATABASE sql_project_p2;

-- STEP 2: CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- STEP 3: VIEW SAMPLE DATA
SELECT * 
FROM retail_sales
LIMIT 10;

-- STEP 4: RECORD COUNT
SELECT COUNT(*) AS total_records 
FROM retail_sales;


--------------------------------------------------------------------------------------------
-- SECTION 1: DATA CLEANING
--------------------------------------------------------------------------------------------

-- Checking for missing or null values in key columns
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Deleting records with missing values
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


--------------------------------------------------------------------------------------------
-- SECTION 2: DATA EXPLORATION
--------------------------------------------------------------------------------------------

-- Total number of sales records
SELECT COUNT(*) AS total_sales 
FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers 
FROM retail_sales;

-- Distinct product categories
SELECT DISTINCT category 
FROM retail_sales;


--------------------------------------------------------------------------------------------
-- SECTION 3: BUSINESS QUESTIONS & ANALYSIS
--------------------------------------------------------------------------------------------

/*
Q1. Retrieve all sales made on '2022-11-05'.
Q2. Retrieve all transactions where category = 'Clothing' 
    and quantity sold > 4 during November 2022.
Q3. Calculate total sales and order count per category.
Q4. Find the average age of customers who purchased from 'Beauty'.
Q5. Retrieve all transactions where total_sale > 1000.
Q6. Find total transactions by gender for each category.
Q7. Calculate the average monthly sales and identify the best-selling month each year.
Q8. Find the top 5 customers based on highest total sales.
Q9. Find the number of unique customers per category.
Q10. Categorize sales by shift (Morning, Afternoon, Evening) based on sale_time.
*/


-- Q1: Retrieve all sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q2: Clothing category transactions with quantity > 4 in November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;


-- Q3: Total sales and order count per category
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


-- Q4: Average age of customers purchasing from 'Beauty'
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q5: Transactions with total sale > 1000
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;


-- Q6: Total transactions by gender in each category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


-- Q7: Best-selling month each year based on average monthly sales
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
                     ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) ranked_sales
WHERE rank = 1;


-- Q8: Top 5 customers based on total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q9: Unique customers per product category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;


-- Q10: Orders by time-of-day (shift classification)
WITH hourly_sales AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY total_orders DESC;
