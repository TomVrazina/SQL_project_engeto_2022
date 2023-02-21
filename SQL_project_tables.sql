CREATE OR REPLACE TABLE cz_payroll_select_gen AS ( 
	SELECT
		AVG(value) AS revenue,
		industry_branch_code, 
		payroll_year,
		payroll_quarter 
	FROM czechia_payroll
	WHERE value IS NOT NULL 
		AND value_type_code = 5958
		AND unit_code = 200
		AND calculation_code = 100
		AND industry_branch_code IS NOT NULL 
	GROUP BY payroll_year, industry_branch_code, payroll_quarter 
	ORDER BY industry_branch_code, payroll_year);

CREATE OR REPLACE TABLE cz_price_select_gen AS (
	SELECT AVG(value) AS value_price, category_code, date_from ,YEAR(date_from) AS date_price
	FROM czechia_price
	WHERE region_code IS NOT NULL
	GROUP BY date_from, category_code, date_price);

CREATE OR REPLACE TABLE join_price_name AS(
	SELECT value_price, name AS category_code , date_from, date_price
	FROM cz_price_select_gen
	JOIN czechia_price_category cpc  
		ON cz_price_select_gen.category_code = cpc.code); 

CREATE OR REPLACE TABLE join_payroll_name AS
	SELECT revenue, payroll_year, payroll_quarter, name 
	FROM cz_payroll_select_gen 
	JOIN czechia_payroll_industry_branch AS cpib 
		ON cz_payroll_select_gen.industry_branch_code = cpib.code; 

	
-- from countries population a from economy HDP, GINI 	
	
CREATE OR REPLACE TABLE eucountry (
	SELECT country 
	FROM countries c 
	WHERE continent = 'Europe'
	INTERSECT 
	SELECT country
	FROM economies e);


-- Final Tables

CREATE OR REPLACE TABLE t_tomas_vrazina_project_SQL_primary_final AS ( 
	SELECT *
	FROM join_payroll_name
	LEFT JOIN join_price_name
		ON join_payroll_name.payroll_year = join_price_name.date_price);

CREATE OR REPLACE TABLE t_tomas_vrazina_project_SQL_secondary_final
WITH cz AS (	
	SELECT country, GDP, gini, `year` 
	FROM economies e 
	WHERE `year` >= 2000 
		AND GDP IS NOT NULL
		AND country IN (
		SELECT country 
		FROM eucountry)
)
SELECT cz.country AS eucountry,`year`, cs.population, GDP, gini 
FROM cz
INNER JOIN countries cs
	ON cz.country = cs.country;
