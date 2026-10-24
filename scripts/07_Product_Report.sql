-- PRODUCT REPORT --

-- 1) Base Query (retrieving core columns from tables)
CREATE VIEW gold.report_products AS
WITH Base_query AS (
SELECT 
p.product_name,
p.category,
p.subcategory,
p.cost,
p.product_key,
f.customer_key,
f.order_number,
f.order_date,
f.sales_amount,
f.quantity
FROM gold.dim_products p
LEFT JOIN gold.fact_sales f
ON p.product_key = f.product_key
WHERE order_date IS NOT NULL
)
,product_aggregation AS (
-- 2) Product Aggregations (summarizing key metrics at the product level)
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_sale_date,
	DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM Base_query
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost
)
-- 3) Segmenting Products by Revenue
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	CASE	
		WHEN total_sales > 50000 THEN 'High Performer'
		WHEN total_sales >= 10000 THEN 'Mid Range'
		ELSE 'Low-Performer'
	END AS product_segment,
-- 4) Calculating Valuable KPIs
	DATEDIFF(month, last_sale_date, GETDATE()) AS recency_in_months,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	lifespan,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,
	-- Average Monthly Revenue
	CASE 
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregation

SELECT
*
FROM gold.report_products
