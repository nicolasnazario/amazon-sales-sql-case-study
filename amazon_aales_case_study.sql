-- =========================================================
-- AMAZON SALES SQL CASE STUDY
-- Analyst: Nicolas Nazario
-- Tool: PostgreSQL
-- Dataset: 50,000 Amazon Sales Transactions
-- Objective: Analyze revenue drivers, pricing impact,
-- product performance, and regional contribution.
-- =========================================================

-- =========================================================
-- SECTION 1: EXECUTIVE KPI SUMMARY
-- =========================================================

SELECT 
    SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity_sold) AS total_units_sold,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_order,
    ROUND(AVG(rating), 2) AS avg_customer_rating,
    ROUND(AVG(discount_percent), 2) AS avg_discount_percent
FROM amazon_sales;

-- =========================================================
-- SECTION 2: Rating Impact Analysis 
-- =========================================================

Select
	Round(rating) As rating_group,
	Count(Distinct order_id) AS order_volume,
	AVG(total_revenue) AS avg_revenue,
	SUM(total_revenue) AS total_revenue
FROM amazon_sales
GROUP BY rating_group
ORDER BY rating_group;

-- =========================================================
-- SECTION 3: Discount Effectiveness
-- =========================================================

SELECT
    CASE 
        WHEN discount_percent = 0 THEN 'No Discount'
        WHEN discount_percent <= 10 THEN 'Low Discount'
        WHEN discount_percent <= 20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_bucket,
    SUM(quantity_sold) AS total_quantity,
    AVG(total_revenue) AS avg_revenue,
    SUM(total_revenue) AS total_revenue
FROM amazon_sales
GROUP BY discount_bucket
ORDER BY total_revenue DESC;

-- =========================================================
-- SECTION 4: Category Performance Ranking 
-- =========================================================

WITH category_revenue AS (
    SELECT
        product_category,
        SUM(total_revenue) AS total_revenue
    FROM amazon_sales
    GROUP BY product_category
)

SELECT
    product_category,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM category_revenue;

-- =========================================================
-- SECTION 5: Monthly Revenue Trend 
-- =========================================================

SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(total_revenue) AS monthly_revenue
FROM amazon_sales
GROUP BY month
ORDER BY month;

-- =========================================================
-- SECTION 6: Revenue Share by Category
-- =========================================================

WITH category_revenue AS (
    SELECT 
        product_category,
        SUM(total_revenue) AS revenue
    FROM amazon_sales
    GROUP BY product_category
)

SELECT 
    product_category,
    revenue,
    ROUND(
        revenue * 100.0 / SUM(revenue) OVER (),
        2
    ) AS revenue_share_percent
FROM category_revenue
ORDER BY revenue DESC;

-- =========================================================
-- SECTION 7: Top 10 Products by Revenue 
-- =========================================================

SELECT 
    product_id,
    SUM(total_revenue) AS total_revenue
FROM amazon_sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- =========================================================
-- SECTION 8: Performance by Region
-- =========================================================

SELECT 
    customer_region,
    SUM(total_revenue) AS total_revenue,
    SUM(quantity_sold) AS total_units,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(rating), 2) AS avg_rating
FROM amazon_sales
GROUP BY customer_region
ORDER BY total_revenue DESC;

-- =========================================================
-- SECTION 9: Repeat Orders 
-- =========================================================

SELECT 
    product_id,
    COUNT(order_id) AS total_orders
FROM amazon_sales
GROUP BY product_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;