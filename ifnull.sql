USE employees;
SELECT 
	dept_name,
	IFNULL(dept_no, 'N/A') as dept_no
FROM 
	departments_dup;
    
    
SELECT
	dept_no,
    IFNULL(dept_name, 'Department name not provided') as dept_name
FROM
	departments_dup;
    
USE employees;    
INSERT INTO departments_dup (dept_name) VALUES ('Product Management');
SELECT * FROM departments_dup;

DESCRIBE departments_dup;
DESC departments_dup;