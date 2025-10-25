# 🛒 SQL Retail Sales Performance Analysis

## 👤 Author
**Dhanesh Gaikwad**  
🎓 Master’s in Data Science | RMIT University  
📍 Melbourne, Australia  
💼 Data Analyst | SQL • Python • Power BI  

---

## 🎯 Objective
Analyze retail sales data to uncover **sales trends, customer behavior, and category performance** using **pure SQL**.  
The goal is to transform raw transactional data into **actionable business insights** that can guide decision-making, marketing strategy, and operational efficiency.

---

## 📖 Overview
This project performs a complete **Exploratory Data Analysis (EDA)** using SQL only.  
It involves database creation, data cleaning, data exploration, and detailed business analysis through structured queries.

Key questions addressed include:
- Which **product categories** generate the highest revenue and sales volume?  
- Who are the **top customers** by spending?  
- Which **months** and **times of day** achieve peak sales?  
- How do **age** and **gender** influence buying patterns?  
- What are the **seasonal trends** and **high-value customer segments**?

---

## 🧰 Tech Stack
| Component | Tool |
|------------|------|
| **Language** | SQL |
| **Database** | PostgreSQL |
| **Environment** | pgAdmin 4 / VS Code |
| **Version Control** | Git & GitHub |
| **Dataset** | Simulated Retail Sales Data (1,997 records) |

---

## 🏗️ Step 1: Database & Table Setup
```sql
CREATE DATABASE SQL_Project;

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
```
✅ **Result:** Database and table successfully created.

---

## 🧹 Step 2: Data Cleaning
Check for missing values and remove invalid records.

```sql
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
🧾 **Result:** 0 rows returned → dataset is clean.  
✅ No missing or null values found across any field.

---

## 📊 Step 3: Data Exploration

### Total Transactions
```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
```
**Result:** 1,997 transactions

### Unique Customers
```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;
```
**Result:** 149 (Clothing), 141 (Beauty), 144 (Electronics)

### Product Categories
```sql
SELECT DISTINCT category FROM retail_sales;
```
**Result:** `Clothing`, `Beauty`, `Electronics`

✅ Dataset is well-structured and balanced across product categories.

---

## 💼 Step 4: Business Questions & Analysis

## Q1. 🧾 Sales on 2022-11-05
```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```
**Result:** 11 transactions  
**Insight:**  
Sales were recorded across all categories and genders — normal day-to-day activity, showing steady customer engagement.

---

## Q2. 👕 Bulk Clothing Purchases in November 2022
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;
```
**Result:** 17 transactions  
**Insight:**  
Bulk clothing sales spiked in November — possibly due to **festive or seasonal demand**.  
Customers aged **19–61** show strong interest in clothing during this period.

---

## Q3. 💰 Total Revenue & Orders per Category
```sql
SELECT category,
       SUM(total_sale) AS total_revenue,
       COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```
| Category | Total Revenue | Total Orders |
|-----------|---------------|--------------|
| Electronics | 313,810 | 684 |
| Clothing | 311,070 | 701 |
| Beauty | 286,840 | 612 |

**Insight:**  
- *Electronics* yields the **highest revenue**.  
- *Clothing* leads in **number of transactions**.  
- *Beauty* performs consistently but slightly lower.

---

## Q4. 💄 Average Age of Beauty Buyers
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```
**Result:** `40.42 years`  
**Insight:**  
The average Beauty buyer is **around 40 years old**, suggesting that middle-aged customers are the main audience for self-care and cosmetics products.

---

## Q5. 💎 High-Value Transactions (Total Sale > 1000)
```sql
SELECT * FROM retail_sales WHERE total_sale > 1000;
```
**Result:** 306 transactions  
**Insight:**  
About **15% of all transactions** are high-value, primarily from Clothing and Beauty.  
These premium purchases are perfect for **loyalty or VIP marketing programs**.

---

## Q6. 👩‍🦰 Gender-wise Transactions by Category
```sql
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```
| Category | Female | Male |
|-----------|---------|------|
| Beauty | 330 | 282 |
| Clothing | 347 | 354 |
| Electronics | 340 | 344 |

**Insight:**  
- *Beauty* is female-dominated.  
- *Clothing* and *Electronics* show **balanced participation** across genders.  
📈 Campaigns can be personalized by category demographics.

---

## Q7. 📅 Best-Selling Month Each Year
```sql
SELECT year, month, avg_sale
FROM (
  SELECT EXTRACT(YEAR FROM sale_date) AS year,
         EXTRACT(MONTH FROM sale_date) AS month,
         AVG(total_sale) AS avg_sale,
         RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)
                      ORDER BY AVG(total_sale) DESC) AS rank
  FROM retail_sales
  GROUP BY 1, 2
) ranked_sales
WHERE rank = 1;
```
| Year | Month | Avg Sale |
|------|--------|-----------|
| 2022 | July (7) | 541.34 |
| 2023 | February (2) | 535.53 |

**Insight:**  
Peak sales occur in **July and February**, likely due to **mid-year and early-year discount seasons**.

---

## Q8. 🏆 Top 5 Customers by Total Spending
```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
| Customer ID | Total Sales |
|--------------|-------------|
| 3 | 38,440 |
| 1 | 30,750 |
| 5 | 30,405 |
| 2 | 25,295 |
| 4 | 23,580 |

**Insight:**  
Top 5 customers generate a significant portion of total revenue — key targets for **retention and VIP loyalty programs**.

---

## Q9. 👥 Unique Customers per Category
```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```
| Category | Unique Customers |
|-----------|------------------|
| Beauty | 141 |
| Clothing | 149 |
| Electronics | 144 |

**Insight:**  
Customer distribution across categories is well-balanced — showing healthy interest across all retail segments.

---

## Q10. ⏰ Orders by Time of Day
```sql
WITH hourly_sales AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
```
| Shift | Total Orders |
|--------|---------------|
| Evening | 1,062 |
| Morning | 558 |
| Afternoon | 377 |

**Insight:**  
🌆 **Evening sales dominate**, making up over half of all transactions.  
Promotions and staffing can be optimized for peak evening hours.

---

## 📈 Key Business Insights

| # | Finding | Business Impact |
|---|----------|-----------------|
| 1 | Electronics leads in revenue | Maintain high stock & margin strategy |
| 2 | Clothing leads in transaction volume | Prioritize promotions and offers |
| 3 | Beauty buyers average ~40 years | Target middle-aged audience |
| 4 | Evening sales dominate | Align operations & offers accordingly |
| 5 | July & February are peak months | Schedule major marketing events |
| 6 | Top 5 customers are high-value spenders | Create VIP engagement programs |

---

## 🧠 Skills Demonstrated
- SQL Data Cleaning & EDA  
- Aggregation Functions (`SUM`, `AVG`, `COUNT`)  
- Ranking & Window Functions (`RANK()`, `PARTITION BY`)  
- Common Table Expressions (CTEs)  
- Business Intelligence & Insight Generation  
- Markdown Documentation for Analytics Projects  

---

## 🚀 How to Run This Project
1. Clone the repository:
   ```bash
   git clone https://github.com/dhanesh456/Retail-Sales-Insights-SQL.git
   ```
2. Open **pgAdmin** or **VS Code SQL extension**.  
3. Execute the SQL script (`Query.sql`) step-by-step.  
4. Review each section (Cleaning → Exploration → Analysis).  
5. View query results and interpret using insights provided in this README.

---

## ⭐ Summary
This project transforms raw retail sales data into actionable insights through **SQL-based analysis**.  
It identifies **top-performing categories**, **customer demographics**, **sales patterns**, and **seasonal trends** that can guide **data-driven business decisions**.

If you found this project useful, please ⭐ star the repository and connect with me on [LinkedIn](https://www.linkedin.com/in/dhanesh456)! 🙌


---

## 🧰 Tech Stack
| Component | Tool |
|------------|------|
| **Language** | SQL |
| **Database** | PostgreSQL |
| **Environment** | pgAdmin 4 / VS Code |
| **Version Control** | Git & GitHub |
| **Dataset** | Simulated Retail Sales Data (1,997 records) |
