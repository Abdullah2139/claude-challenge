CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(30),
    salary NUMERIC(10,2),
    manager_id INT
);

INSERT INTO employees VALUES
(1,'Ahmed','Engineering',90000,NULL),
(2,'Sara','Engineering',85000,1),
(3,'Bilal','Engineering',85000,1),   -- same salary as Sara
(4,'Hina','Engineering',70000,2),
(5,'Usman','Sales',95000,NULL),
(6,'Zara','Sales',60000,5),
(7,'Imran','Sales',60000,5),         -- same salary as Zara
(8,'Noor','HR',55000,NULL),
(9,'Faisal','HR',55000,8),           -- same salary as Noor
(10,'Mehak','Engineering',90000,1);  -- same salary as Ahmed (the boss)

-- 1. The classic: Find the second highest salary in the entire company
SELECT 
	DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;

-- 2. Nth highest, general version: Write a query to find the 3rd highest distinct salary — 
-- then think about how you'd make it work for any N without rewriting the query
SELECT salary
FROM (
	SELECT DISTINCT salary,
		DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
	FROM employees
) ranked
WHERE salary_rank = 3;

-- 3. Per-group version: Find the highest-paid employee in each department.
SELECT
	department,
	emp_id,
	name,
	salary
FROM (
	SELECT department, emp_id, name, salary,
		RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dept_rank
	FROM employees
	) ranked
WHERE dept_rank = 1;

-- 4. The employee who earns more than their manager.
SELECT
    e.name AS employee_name,
    e.salary AS employee_salary,
    m.name AS manager_name,
    m.salary AS manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;

-- 5. Duplicate-handling trap: Find all employees who share their salary with at least one other employee
SELECT 
	emp_id,
	name,
	salary
FROM employees
WHERE salary IN (
	SELECT 
	salary
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1
)
ORDER BY salary DESC;