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

-- BREAD
CREATE OR REPLACE VIEW eval2 AS
	WITH eval AS (
		SELECT 
			ROUND(AVG(value),3) AS value_avg, date_from, category_code,
			CASE 
				WHEN MONTH(date_from) IN (1, 2, 3) THEN 'Q1'
				WHEN MONTH(date_from) IN (4, 5, 6) THEN 'Q2'
				WHEN MONTH(date_from) IN (7, 8, 9) THEN 'Q3'
				WHEN MONTH(date_from) IN (10, 11, 12) THEN 'Q4'
				ELSE NULL
			END AS quartile
		FROM sel_cz_price 
		WHERE category_code = 'Chléb konzumní kmínový'
		GROUP BY date_from, category_code
	)
	SELECT ROUND(AVG(value_avg),3) value_av, YEAR(date_from) AS year_eval, quartile
	FROM eval
	GROUP BY year_eval, quartile
	ORDER BY year_eval DESC;

CREATE OR REPLACE VIEW Bread AS 
	WITH id_add AS (
		SELECT value_av AS bread_price
		FROM eval2
		WHERE year_eval = 2006
			AND quartile = 'Q1'
		UNION
		SELECT value_av
		FROM eval2
		WHERE year_eval = 2018
			AND quartile = 'Q4'
	)
	SELECT bread_price, ROW_NUMBER()  OVER (ORDER BY bread_price)  AS id
	FROM id_add;


-- MILK
CREATE OR REPLACE VIEW eval1 AS
	WITH eval AS (
		SELECT 
			ROUND(AVG(value),2) AS value_avg, date_from, category_code,
			CASE 
				WHEN MONTH(date_from) IN (1, 2, 3) THEN 'Q1'
				WHEN MONTH(date_from) IN (4, 5, 6) THEN 'Q2'
				WHEN MONTH(date_from) IN (7, 8, 9) THEN 'Q3'
				WHEN MONTH(date_from) IN (10, 11, 12) THEN 'Q4'
				ELSE NULL
			END AS quartile
		FROM sel_cz_price 
		WHERE category_code = 'Mléko polotučné pasterované'
		GROUP BY date_from, category_code
	)
	SELECT ROUND(AVG(value_avg),2) value_av, YEAR(date_from) AS year_eval, quartile
	FROM eval
	GROUP BY year_eval, quartile
	ORDER BY year_eval DESC;

CREATE OR REPLACE VIEW Milk AS 
	WITH id_add AS (
		SELECT value_av AS milk_price
		FROM eval1
		WHERE year_eval = 2006
			AND quartile = 'Q1'
		UNION
		SELECT value_av
		FROM eval1
		WHERE year_eval = 2018
			AND quartile = 'Q4'
	)
	SELECT milk_price, ROW_NUMBER()  OVER (ORDER BY milk_price)  AS id
	FROM id_add;
		
-- czechia price selection
CREATE OR REPLACE VIEW payroll_maxmin AS (
	SELECT ROUND(AVG(revenue),2) AS avg_revenue, payroll_year, payroll_quarter 
	FROM sel_cz_payroll
	WHERE payroll_year 
	GROUP BY payroll_year, payroll_quarter 
);
	
CREATE OR REPLACE VIEW payrolls AS 
	WITH id_add AS (
		SELECT avg_revenue AS payroll_minmax
		FROM payroll_maxmin
		WHERE payroll_year = 2006 AND payroll_quarter = 1
		UNION	
		SELECT avg_revenue
		FROM payroll_maxmin
		WHERE payroll_year = 2018 AND payroll_quarter = 4
	)
	SELECT payroll_minmax, ROW_NUMBER()  OVER (ORDER BY payroll_minmax)  AS id
	FROM id_add;

-- TABLE OF Payroll, milk and bread
CREATE OR REPLACE TABLE PMB (
	SELECT  p.id, p.payroll_minmax, m.milk_price, b.bread_price 
	FROM payrolls p 
	JOIN milk m 
		ON p.id = m.id 
	JOIN bread b
		ON p.id = b.id );
	
SELECT 
	FLOOR(payroll_minmax / milk_price) AS num_of_milks,
	FLOOR(payroll_minmax / bread_price) AS num_of_breads,
	payroll_minmax, 
	milk_price, 
	bread_price 
FROM pmb p;