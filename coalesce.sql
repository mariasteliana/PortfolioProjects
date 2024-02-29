USE employees; 
COMMIT;

ALTER TABLE departments_dup
ADD dept_info VARCHAR(255);

SELECT
    dept_no,
    dept_name,
COALESCE(dept_no,dept_name) as dept_info
from departments_dup
ORDER BY dept_no ASC;

COMMIT;
