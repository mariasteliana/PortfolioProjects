CREATE OR REPLACE VIEW v_average_salary_managers AS
SELECT
ROUND(AVG(salary),2)
FROM 
	salaries s
JOIN
	dept_manager m ON s.emp_no=m.emp_no;

