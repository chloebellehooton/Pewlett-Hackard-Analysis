-- Employees in retirement age range
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Employees born in 1952
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility
SELECT count(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create retirement eligibility table
-- SELECT first_name, last_name
-- INTO retirement_info
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT first_name, last_name, title
FROM employees as e
LEFT JOIN titles as t ON e.emp_no = t.emp_no

-- drop retirement table so can redo 
DROP TABLE retirement_info; 

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
	retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Nickname version of query above
-- These aliases only exist within this query and aren't committed to that database
SELECT ri.emp_no,
    ri.first_name,
	ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de	
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Going back and redoing dept & dept_manager query with nicknames
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Left Join for retirement_info and dept_emp
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de_emp.to_date = ('1999-01-01');

-- Check table
select * from retirement_info

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number (ordered) into table
SELECT COUNT(ce.emp_no), de.dept_no
INTO count_current_emp
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Check Table
select * from count_current_emp


-- BOSS REQUEST: EMPLOYEE INFORMATIOIN
-- Make new table with: emp #, last name, first name, gender, to_date, salary

-- check salary table, need more info
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Pull employment dates from dept_emp, make new table
-- SELECT emp_no, 
-- 	first_name, 
-- 	last_name,
-- 	gender
-- INTO emp_info
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- drop table emp_info

-- Join emp_info with salary table to add to_date and salary
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
on e.emp_no = s.emp_no
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
     AND (de.to_date = '1999-01-01');
	 
-- BOSS REQUEST: MANAGEMENT
-- Make new table with: manager's employee number, first name, last name, from_date, to_date
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- BOSS REQUEST: DEPARTMENT RETIREES
-- Add departments to the current_emp table
-- emp_no, first_name, last_name, dept_name
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);


-- SALES REQUEST
-- Create table with columns for sales: emp_no, first_name, last_name, dept_name
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	de.dept_no,
	d.dept_name
--INTO sales_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
		on (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
WHERE (d.dept_name = 'Sales');

-- SALES & DEVELOPMENT REQUEST
-- Create table with columns for sales & dev: emp_no, first_name, last_name, dept_name
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	de.dept_no,
	d.dept_name
--INTO sales_dev_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
		on (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');
