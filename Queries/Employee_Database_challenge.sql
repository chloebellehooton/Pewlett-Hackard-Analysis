-- DELIVERABLE 1: Retirement Titles
-- Birth dates: January 1, 1952 and December 31, 1955
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title,
	rt.from_date,
	rt.to_date
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no ASC, to_date DESC

-- # of employees by most recent job title, about to retire
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles 
GROUP BY title
ORDER BY count DESC;


