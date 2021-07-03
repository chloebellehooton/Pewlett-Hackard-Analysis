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


-- DELIVERABLE 2: The Employees Eligible for the Mentorship Program
-- Create mentorship-elegibiliity table for current_emp born between January 1, 1965 and December 31, 1965
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibilty
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (de.to_date = ('1999-01-01'))
     AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

-- DELIVERABLE 3
-- Count of mentors by dept
SELECT COUNT(me.emp_no), 
	d.dept_name
INTO mentor_count
FROM mentorship_eligibilty as me
	INNER JOIN dept_emp as de
		ON (me.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
GROUP BY d.dept_name
ORDER BY count DESC;

select count(emp_no)
from mentorship_eligibilty;

-- Current employees by department
SELECT COUNT(ce.emp_no), 
	d.dept_name
FROM current_emp as ce
	INNER JOIN dept_emp as de
		on (ce.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (de.dept_no = d.dept_no)
GROUP BY d.dept_name
ORDER BY count DESC;

