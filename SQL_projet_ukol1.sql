-- UKOL 1 SKRIPT

-- SHOWS BRANCHES IN WHICH REVENUE DECREASE

WITH cz_payroll2 AS (
	WITH cz_payroll1 AS (
		WITH cz_payroll AS (
				SELECT revenue, name, payroll_year, payroll_quarter
				FROM t_tomas_vrazina_project_SQL_primary_final
				GROUP BY revenue, name, payroll_year,payroll_quarter
			)
			SELECT AVG(revenue) AS revenue1, name, payroll_year
			FROM cz_payroll
			GROUP BY name, payroll_year
		)
	SELECT 
		revenue1,
		payroll_year,
		revenue1 - LAG(revenue1)  OVER (ORDER BY name ,payroll_year ASC) AS revenue_growth,
		ROUND (-100 + 100* revenue1 / LAG(revenue1) OVER (ORDER BY name ,payroll_year ASC),2) AS revenue_growth_proc,
		name
	FROM cz_payroll1
)
SELECT DISTINCT(name) 
FROM cz_payroll2
WHERE payroll_year != 2000
AND revenue_growth < 0
