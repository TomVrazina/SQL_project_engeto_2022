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

-- CREATING OF SELECTION TABLE Czech republic
CREATE OR REPLACE TABLE sel_cz_HDP AS(
	WITH Define_country AS (
		SELECT eucountry, `year`, GDP, gini 
		FROM t_tomas_vrazina_project_SQL_secondary_final
		GROUP BY `year`, GDP, gini 
	)
	SELECT eucountry AS country, `year`, GDP, gini 
	FROM Define_country
	WHERE eucountry = 'Czech republic');


-- GDP Task 5 growth of GDP 
CREATE OR REPLACE TABLE GDP AS (
		WITH GDP_growth_est AS (
		SELECT 
			`year`,
			ROUND((GDP/lAG(GDP) OVER (ORDER BY `year` ASC)), 4)*100 - 100 AS GDP_growth,
			GDP ,
			country 
		FROM sel_cz_HDP 
	)
	SELECT 
		`year`,
		GDP_growth,
		GDP
	FROM GDP_growth_est
	WHERE GDP_growth IS NOT NULL );
	-- AND `year` BETWEEN 2006 AND 2018 )


-- products
CREATE OR REPLACE TABLE wine AS (
	WITH year_averaging AS (
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
	FROM year_averaging
	WHERE year_payroll != 2005
	ORDER BY category_code, year_payroll);

-- END PRICE --- PRODUCTS 
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


CREATE OR REPLACE TABLE revenue_table AS (
	WITH growth_estimation AS (
		WITH averaging AS ( 
			SELECT ROUND(AVG(revenue),0) AS avg_rev, payroll_year, payroll_quarter 
			FROM sel_cz_payroll
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
	ROUND(average / LAG(average) OVER (ORDER BY payroll_year ASC),5)*100 - 100 AS payroll_growth, 
	payroll_year
FROM growth_estimation
-- WHERE payroll_year BETWEEN 2005 AND 2018 
);


WITH final_table AS (
	WITH payroll_product_join AS (
		SELECT 
			mz1.payroll_growth AS payroll, 
			ps1.price_growth AS products,
			h.GDP_growth,
			mz1.payroll_year
		FROM revenue_table AS mz1
		LEFT JOIN clean_table_products AS ps1 
			ON mz1.payroll_year = ps1.year_payroll
		LEFT JOIN GDP AS h 
			ON mz1.payroll_year = h.`year` 
	)
	SELECT 
		products,
		payroll,
		LEAD(payroll) OVER (ORDER BY payroll_year) AS LEAD_payroll,
		LEAD(products) OVER (ORDER BY payroll_year) AS LEAD_products,
		GDP_growth,
		payroll_year 
	FROM payroll_product_join
)
SELECT 
	products,
	LEAD_products,
	payroll,
	LEAD_payroll,
	GDP_growth,
	payroll_year 
FROM final_table
WHERE products IS NOT NULL
ORDER BY GDP_growth DESC, payroll_year DESC 



