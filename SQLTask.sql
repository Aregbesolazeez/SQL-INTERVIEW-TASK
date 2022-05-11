DROP TABLE employees
CREATE TABLE employees (
    department_name varchar(255),
    employee_id integer,
    employee_name varchar(255)
)

INSERT INTO employees (department_name, employee_id, employee_name)
VALUES ('Sales', 123, 'John Doe')

INSERT INTO employees (department_name, employee_id, employee_name)
VALUES ('Sales', 211, 'Jane Smith');

INSERT INTO employees (department_name, employee_id, employee_name)
VALUES ('HR', 556, 'Billy Bob');

INSERT INTO employees (department_name, employee_id, employee_name)
VALUES ('Sales', 711, 'Robert Hayek');

INSERT INTO employees (department_name, employee_id, employee_name)
VALUES ('Marketing', 235, 'Edward Jorgson');

INSERT INTO employees (department_name, employee_id, employee_name)
VALUES ('Marketing', 236, 'Christine Packard');


DROP TABLE salaries
CREATE TABLE salaries (
    salary integer,
    employee_id integer,
    employee_name varchar(255)
);

INSERT INTO salaries (salary, employee_id, employee_name)
VALUES (500, 123, 'John Doe');

INSERT INTO salaries (salary, employee_id, employee_name)
VALUES (600, 211, 'Jane Smith');

INSERT INTO salaries (salary, employee_id, employee_name)
VALUES (1000, 556, 'Billy Bob');

INSERT INTO salaries (salary, employee_id, employee_name)
VALUES (400, 711, 'Robert Hayek');

INSERT INTO salaries (salary, employee_id, employee_name)
VALUES (1200, 235, 'Edward Jorgson');

INSERT INTO salaries (salary, employee_id, employee_name)
VALUES (1200, 236, 'Christine Packard');



/* The query below was written using MS SQL Server */



SELECT t1.department_name, t3.average_salary, t1.employee_max_salary, t2.employee_min_salary
FROM((
SELECT a1.department_name, a1.employee_max_salary
FROM (
SELECT employees.department_name,  CONCAT(employees.employee_name, ' - ', salaries.salary) AS employee_max_salary, salaries.salary
FROM employees
LEFT JOIN salaries ON employees.employee_id = salaries.employee_id) a1
RIGHT JOIN (
SELECT employees.department_name AS department_name, MAX(salaries.salary) AS max_salary
FROM employees
LEFT JOIN salaries ON employees.employee_id = salaries.employee_id
GROUP BY employees.department_name) a2
ON a1.department_name = a2.department_name AND a1.salary = a2.max_salary) t1
LEFT JOIN (
SELECT b1.department_name, b1.employee_min_salary
FROM (
SELECT employees.department_name,  CONCAT(employees.employee_name, ' - ', salaries.salary) AS employee_min_salary, salaries.salary
FROM employees
LEFT JOIN salaries ON employees.employee_id = salaries.employee_id) b1
RIGHT JOIN (
SELECT employees.department_name AS department_name, MIN(salaries.salary) AS min_salary
FROM employees
LEFT JOIN salaries ON employees.employee_id = salaries.employee_id
GROUP BY employees.department_name) b2
ON b1.department_name = b2.department_name AND b1.salary = b2.min_salary
) t2
ON t1.department_name = t2.department_name)
RIGHT JOIN (
SELECT employees.department_name AS department_name,  AVG(salaries.salary) AS average_salary
FROM employees
LEFT JOIN salaries ON employees.employee_id = salaries.employee_id
GROUP BY employees.department_name) t3
ON t1.department_name = t3.department_name
WHERE average_salary BETWEEN 1000 AND 3000


/* Since Edward Jorgson and Christine Packard in the Marketing department earn the same salary, 
Marketing department result produced 4 rows because there were 2 ways to choose the employee with the highest salary, 
and then another 2 ways to choose the employee with the lowest salary, 
resulting in (2x2) four combinations of producing a marketing result. 
One benefit of SQL over Excel is that such circumstances can be readily accounted for.*/