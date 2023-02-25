-- TASK 1 SCRIPT

-- SHOWS BRANCHES IN WHICH REVENUE DECREASE

WITH for_final_eval AS (
	WITH for_revenue_growth AS (
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
		revenue1 - LAG(revenue1)  OVER (
			PARTITION BY name
			ORDER BY name ,payroll_year ASC) AS revenue_growth,
		ROUND (-100 + 100* revenue1 / LAG(revenue1) OVER (
			PARTITION BY name
			ORDER BY name ,payroll_year ASC),2) AS revenue_growth_proc,
		name
	FROM for_revenue_growth
)
SELECT DISTINCT(name) 
FROM for_final_eval
WHERE payroll_year != 2000
	AND revenue_growth IS NOT NULL
	AND revenue_growth < 0;
