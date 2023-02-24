CREATE OR REPLACE TABLE sel_cz_price AS(
	SELECT value_price AS value, category_code, date_from
	FROM t_tomas_vrazina_project_sql_primary_final
	WHERE value_price IS NOT NULL
	GROUP BY value, category_code, date_from);

-- Task 3 


WITH task_result AS (
	WITH growth_val_assesment AS (
		WITH averaging_per_year AS (
			WITH baseline AS (
				SELECT value AS value_avg, date_from, category_code 
				FROM sel_cz_price
				GROUP BY date_from, category_code
			)
			SELECT ROUND(AVG(value_avg),3) val_avg, YEAR(date_from) AS year_payroll, category_code 
			FROM baseline
			GROUP BY  year_payroll, category_code 
		)
		SELECT 
			val_avg,
			ROUND(val_avg / LAG(val_avg) OVER (
				PARTITION BY category_code
				ORDER BY category_code ,year_payroll ASC),5)*100 - 100 AS value_growth,
			year_payroll,
			category_code
		FROM averaging_per_year
		)
	SELECT 
		value_growth,
		year_payroll,
		category_code
	FROM growth_val_assesment
	WHERE value_growth IS NOT NULL
		AND value_growth > 0
)
SELECT 
	value_growth,
	year_payroll,
	category_code
FROM task_result 
ORDER BY value_growth ASC
LIMIT 1
 

