-- Changes-Over-Time (Trends) Analysis --

-- Analyze Sales Peformance Over Time
SELECT
YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_Sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_Sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date)

SELECT
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) AS total_Sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)

-- Number of New Customers Added Each Year
SELECT 
DATETRUNC(year, create_date) AS create_year,
COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY DATETRUNC(year, create_date)
ORDER BY DATETRUNC(year, create_date)
