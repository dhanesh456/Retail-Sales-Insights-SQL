🛒 Retail Sales Performance Analysis using SQL
🎯 Objective

Analyze retail sales data to uncover sales trends, customer behavior, and category performance using SQL.
This project demonstrates how structured query analysis can transform transactional data into actionable business insights for decision-making and strategy optimization.

📖 Overview

This project performs an in-depth Exploratory Data Analysis (EDA) of retail sales data using pure SQL.
It covers database creation, data cleaning, and analytical queries that answer key business questions such as:

Which product categories drive the most sales and revenue?

Who are the top customers by total spending?

What are the peak sales months and hours?

How does customer age and gender influence sales patterns?

Which time of day (Morning, Afternoon, Evening) performs best?

By the end, this analysis provides a complete view of the company’s sales dynamics — enabling data-driven marketing, inventory, and operational strategies.

🧰 Tech Stack

Language: SQL
Database: PostgreSQL / MySQL
Tools: VS Code, DBeaver, pgAdmin
Version Control: Git & GitHub

🗂️ Database Schema
📋 Table: retail_sales
Column	Type	Description
transaction_id	INT	Unique transaction ID (Primary Key)
sale_date	DATE	Date of the transaction
sale_time	TIME	Time of the transaction
customer_id	INT	Unique customer ID
gender	VARCHAR(15)	Gender of the customer
age	INT	Age of the customer
category	VARCHAR(15)	Product category (Clothing, Beauty, Electronics, etc.)
quantity	INT	Quantity purchased
price_per_unit	FLOAT	Price per item
cogs	FLOAT	Cost of goods sold
total_sale	FLOAT	Total sales value per transaction
🧹 Data Cleaning

Before analysis, all missing or invalid data was removed to ensure consistency and accuracy.

DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


✅ Result: A clean dataset ready for analysis.

🔍 Data Exploration
-- Total number of records
SELECT COUNT(*) AS total_transactions FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Product categories
SELECT DISTINCT category FROM retail_sales;

📊 Business Analysis & Insights
🧾 1. Daily Sales Performance
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';


📈 Insight: Tracks sales on specific dates for validation or reporting.

👕 2. Clothing Sales in November 2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;


💡 Insight: Identifies bulk purchases and high-performing months.

💰 3. Total Revenue by Category
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;


📊 Insight: Determines which categories contribute most to total revenue.

💄 4. Average Age of Customers in Beauty Category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';


🧍 Insight: Identifies age demographics for targeted marketing.

💎 5. High-Value Transactions (> 1000)
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;


💰 Insight: Detects premium purchases for loyalty segmentation.

👩‍🦰 6. Gender-wise Transactions per Category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;


📈 Insight: Understands gender-based buying patterns.

📅 7. Best-Selling Month Each Year
SELECT 
    year, month, avg_sale
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


🗓️ Insight: Highlights seasonal trends for inventory planning.

🏆 8. Top 5 Customers by Total Sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


🎯 Insight: Identifies top-spending customers for loyalty programs.

👥 9. Unique Customers per Product Category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;


🧩 Insight: Evaluates category popularity among different buyers.

⏰ 10. Orders by Time of Day
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
GROUP BY shift;


🌞 Insight: Afternoon and Evening are peak periods — helpful for staffing decisions.

📈 Key Findings
#	Finding	Business Impact
1	Clothing & Beauty categories generate highest revenue	Focus marketing on these verticals
2	Afternoon & Evening sales dominate	Optimize staffing and offers for these hours
3	Average buyer age differs by category	Enables precise customer segmentation
4	November & July show highest sales	Align promotions and stock with peak months
5	Top 5 customers contribute large revenue share	Build customer loyalty or VIP programs
🧠 Skills Demonstrated

SQL Data Cleaning & EDA

Aggregation Functions (SUM, AVG, COUNT)

Ranking & Window Functions (RANK(), PARTITION BY)

Common Table Expressions (CTEs)

Business Insight Generation

Markdown Documentation

🚀 How to Run This Project

Clone this repository

git clone https://github.com/dhanesh456/Retail-Sales-Insights-SQL.git


Open your SQL environment (VS Code / DBeaver / pgAdmin)

Create and load the database using the provided SQL script

Run queries section-wise to reproduce all insights

👨‍💻 Author

Dhanesh Gaikwad
📍 Melbourne, Australia
🎓 Master’s in Data Science | RMIT University
💼 Data Analyst | SQL • Python • Power BI

🔗 LinkedIn

💻 GitHub

⭐ Summary

This project is part of my Data Analyst Portfolio, demonstrating my ability to apply SQL for data cleaning, EDA, and business-driven analytics.
It transforms raw retail data into strategic insights that can optimize marketing, staffing, and inventory operations.

If you found this project useful, please ⭐ star the repo or connect with me on LinkedIn
! 😊
