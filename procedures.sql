USE employees;
DROP PROCEDURE IF EXISTS average_salaries;

DELIMITER $$
CREATE PROCEDURE average_salaries()
BEGIN 
SELECT
AVG(salary)
FROM salaries;
END$$

DELIMITER ;
