-- CREATING SELECTION OF PRICE TABLE
CREATE OR REPLACE TABLE sel_cz_price AS(
	SELECT value_price AS value, category_code, date_from
	FROM t_tomas_vrazina_project_sql_primary_final
	WHERE value_price IS NOT NULL
	GROUP BY value, category_code, date_from
);

-- CREATING OF SELECTION TABLE PAYROLL
CREATE OR REPLACE TABLE sel_cz_payroll AS(
	SELECT revenue, name, payroll_year, payroll_quarter
	FROM t_tomas_vrazina_project_SQL_primary_final
	GROUP BY revenue, name, payroll_year,payroll_quarter
);

-- Payroll table
CREATE OR REPLACE TABLE revenue_table AS (
	WITH growth_estimation AS (
		WITH averaging AS (
			WITH baseline AS (
				SELECT 
					revenue,
					name, 
					payroll_year,
					payroll_quarter 
				FROM sel_cz_payroll 	 
				GROUP BY payroll_year, name , payroll_quarter 
			)
			SELECT ROUND(AVG(revenue),0) AS avg_rev, payroll_year, payroll_quarter 
			FROM baseline
			WHERE payroll_year 
			GROUP BY payroll_year, payroll_quarter 
		)
		SELECT 
			AVG(avg_rev) AS average,
			payroll_year
		FROM averaging
		GROUP BY payroll_year
)
SELECT 
	ROUND(average / LAG(average) OVER (ORDER BY payroll_year ASC),5)*100 - 100 AS price_growth, 
	payroll_year
FROM growth_estimation
WHERE payroll_year BETWEEN 2005 AND 2018 
);

-- products
CREATE OR REPLACE TABLE wine AS (
	WITH year_average AS (
		WITH regavg AS (
			SELECT ROUND(AVG(value),3) AS value_avg, date_from, category_code 
			FROM sel_cz_price
			GROUP BY date_from, category_code
		)
		SELECT ROUND(AVG(value_avg),3) val_avg, YEAR(date_from) AS year_payroll, category_code 
		FROM regavg
		GROUP BY  year_payroll, category_code  
	)
	SELECT 
		val_avg,
		year_payroll,
		category_code
	FROM year_average
	WHERE year_payroll != 2005
	ORDER BY category_code, year_payroll);

--  CLEANING table wine 
CREATE OR REPLACE TABLE clean_table_products AS (
	WITH products AS (
		SELECT AVG(val_avg) AS average, year_payroll
		FROM wine
		WHERE year_payroll != 2015
			OR category_code != 'Jakostní víno bílé'
		GROUP BY year_payroll	
	)
	SELECT 
		 average,
		 ROUND(average / LAG(average) OVER (ORDER BY year_payroll ASC),5)*100 - 100 AS price_growth,
		 year_payroll
	FROM products
	ORDER BY year_payroll);


-- putting it together
	-- year where difference would be 10 % do not exist

WITH difference AS (
	SELECT mz1.price_growth AS price, ps1.price_growth AS products, ps1.year_payroll
	FROM revenue_table AS mz1
	LEFT JOIN clean_table_products AS ps1 
		ON mz1.payroll_year = ps1.year_payroll 
	WHERE ps1.price_growth IS NOT NULL
)
SELECT 
	products,
	price,
	products - price AS differ,
	year_payroll
FROM difference;

