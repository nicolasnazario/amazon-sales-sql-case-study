-- =========================================================
-- MERCEDES SALES SQL CASE STUDY
-- Analyst: Nicolas Nazario
-- Tool: PostgreSQL
-- Dataset: 1.8 Million Mercedees Sales Transactions
-- Objective: Analyze revenue drivers and compare car models
              
              
-- =========================================================

-- =========================================================
-- SECTION 1: Total Revenue By Model
-- =========================================================

Select model,
		SUM(base_price * sales_volume) AS total_revenue
FROM mercedes_sales
GROUP BY model
ORDER BY total_revenue DESC;

-- =========================================================
-- SECTION 2: Total Global Revenue 
-- =========================================================

Select region,
			SUM(base_price * sales_volume) AS revenue
FROM mercedes_sales
GROUP BY region
ORDER BY revenue DESC; 

-- =========================================================
-- SECTION 3: Average Price per Model
-- =========================================================

Select model,
		AVG(base_price) AS avg_price 
FROM mercedes_sales
GROUP BY model
ORDER BY avg_price DESC;

-- =========================================================
-- SECTION 4: Sales Trend By Year
-- =========================================================

SELECT year,
		SUM(sales_volume) AS total_sales
FROM mercedes_sales
GROUP BY year
ORDER BY year; 


-- =========================================================
-- SECTION 5: Turbo vs. Non-Turbo Performance 
-- =========================================================

Select turbo,
		AVG(horsepower) AS avg_hp,
		SUM(sales_volume) AS total_sales
FROM mercedes_sales
GROUP BY turbo; 

-- =========================================================
-- SECTION 6: Horsepower vs. Price Relationship
-- =========================================================

Select horsepower,
		AVG(base_price) AS avg_price
FROM mercedes_sales
GROUP BY horsepower 
ORDER BY horsepower;

-- =========================================================
-- SECTION 7: Top Models by Sales Volume 
-- =========================================================

SELECT model,
		SUM(sales_volume) AS total_units
FROM mercedes_sales
GROUP BY model
ORDER BY total_units DESC
Limit 10;

-- =========================================================
-- SECTION 8: Fuel Type Demand
-- =========================================================

SELECT fuel_type,
			SUM(sales_volume) AS total_sales
FROM mercedes_sales
GROUP BY fuel_type
ORDER BY total_sales DESC; 

-- =========================================================
-- SECTION 9: Price Category 
-- =========================================================

SELECT 
	CASE 
		WHEN base_price < 80000 THEN 'Entry Level'
		WHEN base_price BETWEEN 80000 AND 150000 THEN 'Mid Range'
		ELSE 'Luxury'
	END AS price_category,
	SUM(sales_volume) AS total_sales
FROM mercedes_sales
GROUP BY price_category;