-- module 09 challenge

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" VARCHAR   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "sex" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);


-- previous form, DO NOT RUN!!
CREATE TABLE titles (
	title_id VARCHAR NOT NULL,
	title VARCHAR NOT NULL,
	PRIMARY KEY (title_id)
);

-- NOT NULL not needed in every row, tried it to see if constraint error worked (it did not) and also too lazy to delete. also being used for future reference
CREATE TABLE employees (
	emp_no INT NOT NULL,
	emp_title_id VARCHAR,
	birth_date VARCHAR,
	first_name VARCHAR,
	last_name VARCHAR ,
	sex VARCHAR,
	hire_date VARCHAR,
	PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_title_id) REFERENCES titles (title_id)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	PRIMARY KEY (emp_no)
);

-- dept_no made into PK in order for table connection to occur
CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	PRIMARY KEY (emp_no, dept_no)
);

-- UNIQUE constraint used because NOT NULL was not working
CREATE TABLE departments (
	dept_no VARCHAR,
	dept_name VARCHAR,
	PRIMARY KEY (dept_no)
);

DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS titles;

SELECT * FROM departments 
SELECT * FROM dept_emp 
SELECT * FROM dept_manager 
SELECT * FROM employees 
SELECT * FROM salaries 
SELECT * FROM titles 

-- data_01: list the employee number, last name, first name, sex, and salary of each employee (2 points)
-- GOOD TO GO!!

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries
ON employees.emp_no = salaries.emp_no
ORDER BY last_name

-- data_02: list the first name, last name, and hire date for the employees who were hired in 1986 (2 points)
-- WORKS, BUT HOW TO DO WITH ATTRIBUTE 'DATE'? OTHERWISE, GOOD TO GO!!

SELECT employees.first_name, employees.last_name, employees.hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY last_name

-- data_03: list the manager of each department along with their department number, department name, employee number, last name, and first name (2 points)
-- GOOD TO GO!!

SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
INNER JOIN departments
ON dept_manager.dept_no = departments.dept_no
INNER JOIN employees
ON dept_manager.emp_no = employees.emp_no
ORDER BY last_name

-- data_04: list the department number for each employee along with that employee’s employee number, last name, first name, and department name (2 points)
-- GOOD TO GO!!

SELECT departments.dept_no, departments.dept_name, dept_emp.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN dept_emp
ON departments.dept_no = dept_emp.dept_no
JOIN employees
ON dept_emp.emp_no = employees.emp_no
ORDER BY last_name

-- data_05: list first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B (2 points)
-- GOOD TO GO!!

SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY last_name

-- data_06: list each employee in the Sales department, including their employee number, last name, and first name (2 points)
-- SECOND INNER JOIN DOES NOT REQUIRE WE ADD TABLE IN FIRST LINE (SELECT) OR WRITTEN IN ORDER IN THE CODE
-- GOOD TO GO!!

SELECT dept_emp.emp_no, employees.last_name, employees.first_name 
FROM dept_emp
INNER JOIN employees
ON dept_emp.emp_no = employees.emp_no
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_no = 'd007'
ORDER BY last_name

-- data_07: list each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)
-- GOOD TO GO!!

SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
INNER JOIN employees
ON dept_emp.emp_no = employees.emp_no
--GROUP BY departments.dept_name ('Sales')
--WHERE departments.dept_no = 'd007' AND departments.dept_no = 'd005' **DOES NOT WORK!!
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name IN ('Sales', 'Development')
-- WHERE departments.dept_no IN ('d007', 'd005') works too!
-- WHERE departments.dept_no = 'd007' OR departments.dept_no = 'd005' **CANT USE AND IN THIS SITUATION, NEEDS TO BE OR!!
ORDER BY last_name

-- data_08: list the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) (4 points)
-- GOOD TO GO!!

SELECT employees.last_name, COUNT(*) FROM employees
GROUP BY employees.last_name 
ORDER BY COUNT(*) DESC
