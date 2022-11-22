nnnnnnnnnnn

use sai;
SELECT emp.project_name
FROM(SELECT t_project.project_name
		,COUNT(employee.EMP_ID) AS 'No_of_emp'
        ,DENSE_RANK() OVER( ORDER BY COUNT(employee.EMP_ID) DESC ) AS 'max_emp' 
FROM allocation
LEFT JOIN t_project
ON t_project.project_id = allocation.project_id
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
GROUP BY t_project.PROJECT_id
ORDER BY no_of_emp DESC) emp
WHERE  max_emp= 1;



SELECT employee.emp_id
		,employee.emp_name
FROM allocation
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
WHERE employee.emp_id NOT IN (SELECT allocation.emp_id
								FROM allocation)
GROUP BY employee.emp_id;



SELECT a.emp_id
		,a.role_title
FROM(SELECT employee.emp_id
		,role.role_title
        ,RANK()OVER(ORDER BY role_title DESC) AS rk
FROM allocation
LEFT JOIN role
ON role.role_id = allocation.role_id
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
WHERE employee.emp_id = 'E02') a
WHERE rk = 1;

SELECT project_id
	,amount_per_day AS 'cost_of_project'
    ,COUNT(emp_id) AS 'no_of_emp'
FROM allocation
GROUP BY amount_per_day
ORDER BY cost_of_project DESC
LIMIT 1;


SELECT project_id
		,YEAR(deadline) AS 'yr'
FROM t_project
WHERE YEAR(deadline)=2013
ORDER BY deadline ASC;



SELECT t_project.project_id
		,employee.emp_name
        ,employee.salary
FROM allocation
LEFT JOIN t_project
ON t_project.project_id = allocation.project_id
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
WHERE t_project.project_id = 'P07';

SELECT a.emp_name
		,a.hire_date
		,No_of_projects
FROM(SELECT employee.emp_name
		,employee.hire_date
		,COUNT(allocation.project_id) AS 'No_of_projects'
		,RANK() OVER( ORDER BY hire_date ASC) AS rk 
	FROM employee
	LEFT JOIN allocation
	ON employee.emp_id = allocation.emp_id
	GROUP BY employee.emp_id
	ORDER BY hire_date ASC) A
WHERE rk = 1;



SELECT employee.emp_id 
    ,(((2021-YEAR(employee.hire_date))*12-MONTH(employee.hire_date))+MONTH(NOW()) ) *salary AS 'Amount_spent'
FROM employee
LEFT JOIN allocation
ON  employee.emp_id =allocation.emp_id 
WHERE employee.emp_id NOT IN (SELECT emp_id
								FROM allocation)
GROUP BY employee.emp_id;



SELECT a.completed_projects
FROM(SELECT 
	CASE 
			WHEN to_date < NOW() THEN COUNT(project_id)
			END AS 'completed_projects'
	,RANK() OVER(ORDER BY project_id ASC) AS 'rk'
	FROM allocation
	GROUP BY project_id) a
WHERE rk=1;



SELECT MAX(rk) AS 'emp_lessthan_10projects'
FROM
(SELECT emp_id
	,count(emp_id) AS 'no_of_projects_worked'
    ,RANK() OVER( ORDER BY emp_id DESC) AS rk
FROM allocation 
GROUP BY emp_id
HAVING COUNT(emp_id)<10) a;



SELECT  COUNT(emp_id) AS 'employees'
FROM allocation 
WHERE project_id='P04'AND role_id ='R02';





SELECT em.emp_name  AS 'employee'
		,'works for' AS ' '
		, mgr.emp_name AS 'Manager'
FROM employee em
JOIN employee mgr
ON mgr.emp_id = em.mgr_id;



SELECT em.emp_name  AS 'employee'
		,em.salary
		, mgr.emp_name AS 'Manager'
        ,mgr.salary
FROM employee em
JOIN employee mgr
ON mgr.emp_id = em.mgr_id
WHERE em.salary > mgr.salary;

SELECT em.emp_name  AS 'employee'
FROM employee em
JOIN employee mgr
ON mgr.emp_id = em.mgr_id
WHERE em.salary > mgr.salary;


SELECT  mgr.emp_name AS 'Manager'
FROM employee em
JOIN employee mgr
ON mgr.emp_id = em.mgr_id
WHERE mgr.hire_date>em.hire_date
GROUP BY mgr.emp_id;

SELECT 
CASE 
		WHEN mgr.hire_date>em.hire_date THEN mgr.emp_name 
        END AS 'mgr_joined_after_emp'
FROM employee em
JOIN employee mgr
ON mgr.emp_id = em.mgr_id
GROUP BY mgr.emp_id;


WITH temp AS
(SELECT  emp_name
		,salary
FROM employee 
)
SELECT 
	CASE
        WHEN salary > (SELECT AVG(salary) FROM employee) THEN emp_name
        END AS 'salary > avgsalary'
FROM temp;



SELECT 
CASE
	WHEN A.roles_changed>1 THEN A.emp_id
    END AS 'Emp_changed_role_twice'
FROM(SELECT emp_id
		,COUNT(role_id) AS 'roles_changed'
	FROM allocation
	GROUP BY emp_id) A;
    
    
    
    
SELECT dp.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
WHERE dp.dept_id IN (SELECT dept_id
						FROM employee);
                        
                        
 SELECT A.client_name
		,A.no_of_projects
FROM (SELECT  client_name
				,COUNT(project_id) AS 'No_of_projects'
				,RANK() OVER(ORDER BY COUNT(project_id) DESC)  AS rk
		FROM t_project
		GROUP BY client_name) A
WHERE rk =1;


SELECT 
CASE
	WHEN YEAR(from_date) != 2010 AND year(to_date) != 2010 THEN emp_id
	END AS 'emp_not_allocated_in_2010'
FROM allocation
GROUP BY emp_id;


SELECT emp_id
	,project_id
    ,DATEDIFF(to_date,from_date)
FROM allocation
WHERE project_id = 'P02' AND emp_id = 'E04';


SELECT pr.project_id
FROM t_project pr
JOIN allocation al
ON al.project_id = pr.project_id
WHERE pr.deadline IN (SELECT to_date
						FROM allocation)
GROUP BY project_id;





SELECT pr.project_id
	,pr.deadline
	,COUNT(al.emp_id)
FROM t_project pr
JOIN allocation al
ON al.project_id = pr.project_id
GROUP BY pr.project_id
HAVING pr.deadline <ALL ( SELECT to_date
						FROM allocation
						GROUP BY project_id
						ORDER BY to_date DESC);


 SELECT to_date
		,project_id
		FROM allocation
		GROUP BY project_id
		ORDER BY to_date DESC;
        
SELECT A.project_id
		,A.emp_count
FROM (SELECT pr.project_id
	,pr.deadline
	,COUNT(al.emp_id) AS 'emp_count'
FROM t_project pr
JOIN allocation al
ON al.project_id = pr.project_id
GROUP BY pr.project_id
HAVING pr.deadline <ALL ( SELECT to_date
						FROM allocation
						GROUP BY project_id)) A ;
                        
                        
                        
SELECT pr.project_id
		,pr.deadline
FROM t_project pr
JOIN allocation al
ON al.project_id = pr.project_id
WHERE pr.deadline <ALL (SELECT to_date
						FROM allocation)
GROUP BY project_id;



SELECT A.project_id
		,A.total_days
FROM
(SELECT project_id
        ,DATEDIFF(to_date,from_date) AS 'total_days'
        ,RANK()OVER(ORDER BY DATEDIFF(to_date,from_date) DESC ) AS rk
FROM allocation) A
WHERE rk = 1;


SELECT al.emp_id
		,DATEDIFF(al.from_date,em.hire_date)-DATEDIFF(al.to_date,al.from_date)
FROM allocation al
JOIN employee em
ON em.emp_id=al.emp_id
;

SELECT pr.project_name
		,count(al.emp_id) AS 'No_of_employee'
FROM t_project pr
LEFT JOIN allocation al
ON al.project_id = pr.project_id
GROUP BY al.project_id;

SELECT rl.role_title
		,count(al.emp_id) AS 'NO_of_employees'
FROM role rl
LEFT JOIN allocation al
ON al.role_id = rl.role_id
GROUP BY al.role_id;


SELECT em.emp_name
		,count(al.project_id) AS 'no_of_projects'
FROM employee em
LEFT JOIN allocation al
ON al.emp_id = em.emp_id
GROUP BY al.emp_id;

SELECT em.emp_name
		,count(al.role_id) AS 'no_roles'
FROM employee em
LEFT JOIN allocation al
ON al.emp_id = em.emp_id
GROUP BY al.emp_id;


SELECT rl.role_title
		,COUNT(al.emp_id) AS 'no_of_emps'
FROM role rl
LEFT JOIN allocation al
ON al.role_id = rl.role_id
GROUP BY al.role_id;

SELECT em.emp_name
		,rl.role_title
        ,COUNT(al.project_id) AS 'no_of_projects'
FROM allocation al
LEFT JOIN role rl
ON rl.role_id = al.role_id
LEFT JOIN employee em
ON em.emp_id = al.emp_id
GROUP BY al.project_id;



SELECT pr.project_name
		,rl.role_title
        ,COUNT(al.emp_id) AS 'no_of_emps'
FROM allocation al
LEFT JOIN role rl
ON rl.role_id = al.role_id
LEFT JOIN employee em
ON em.emp_id = al.emp_id
LEFT JOIN t_project pr
ON pr.project_id = al.project_id
GROUP BY al.project_id;


SELECT rl.role_title
		,em.emp_name
        ,COUNT(al.project_id) AS 'no_of_projects'
FROM allocation al
LEFT JOIN role rl
ON rl.role_id = al.role_id
LEFT JOIN employee em
ON em.emp_id = al.emp_id
GROUP BY al.project_id;



SELECT dept_id
		,COUNT(emp_id) AS 'no_of_emps'
FROM employee
GROUP BY dept_id;

SELECT mgr_id
		,COUNT(emp_id) AS 'no_of_emps'
FROM employee
GROUP BY dept_id;


SELECT em.emp_name
		,rl.role_title
        ,pr.project_name
FROM allocation al
LEFT JOIN role rl
ON rl.role_id = al.role_id
LEFT JOIN employee em
ON em.emp_id = al.emp_id
LEFT JOIN t_project pr
ON pr.project_id = al.project_id;


SELECT project_id,
		emp_id,
        (DATEDIFF(to_date,from_date) * Amount_per_day) AS 'Amount_collected'
FROM allocation
ORDER BY amount_collected DESC;


SELECT emp_id,
        role_id,
        project_id,
        (DATEDIFF(to_date,from_date) * Amount_per_day) AS 'Amount_collected'
FROM allocation
ORDER BY amount_collected DESC;


SELECT emp_id
        ,mgr_id
        ,CASE
			WHEN mgr_id = NULL THEN 'No manager'
        	WHEN mgr_id != NULL THEN 'Has manager'
        END AS 'Comments'
FROM employee;


SELECT dp.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
WHERE dp.dept_id NOT IN (SELECT dept_id
				FROM employee);
                
SELECT dp.dept_id
		,em.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
WHERE em.dept_id IS NULL;

SELECT dp.dept_id
		,em.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
GROUP BY dp.dept_id
HAVING dp.dept_id =ALL ( SELECT dept_id
						FROM employee);


SELECT dp.dept_id
FROM department dp
LEFT JOIN employee em
ON em.dept_id = dp.dept_id
UNION
SELECT em.dept_id
FROM employee em
RIGHT JOIN department dp
ON dp.dept_id = em.dept_id;


SELECT dp.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
WHERE dp.dept_id IN (SELECT dept_id
				FROM employee);
                
SELECT dp.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
WHERE dp.dept_id IS NOT NULL;

SELECT dp.dept_id
FROM employee em
LEFT JOIN department dp
ON  dp.dept_id=em.dept_id
GROUP BY dp.dept_id
HAVING dp.dept_id IN ( SELECT dept_id
						FROM employee);
                        
SELECT dp.dept_id
FROM department dp
LEFT JOIN employee em
ON em.dept_id = dp.dept_id
UNION
SELECT em.dept_id
FROM employee em
RIGHT JOIN department dp
ON dp.dept_id = em.dept_id;



SELECT project_id
		,role_id
        ,COUNT(emp_id) AS 'no_of_employees'
FROM allocation
GROUP BY emp_id,role_id WITH ROLLUP;

SELECT emp_id
		,project_id
        ,SUM(TIMESTAMPDIFF(DAY,from_date,to_date)*Amount_per_day) AS 'total_salary'
FROM allocation
GROUP BY emp_id,project_id WITH ROLLUP;

SELECT ems.emp_id,
		(CASE
			WHEN COUNT(ems.skill_id)>5 THEN 'Major_resource'
            WHEN COUNT(ems.skill_id)>3 THEN 'useful_resource'
            WHEN COUNT(ems.skill_id)>1 THEN 'resource'
		END) AS 'desc'
FROM employeeskill ems
JOIN skill sk
ON sk.skill_id = ems.skill_id
GROUP BY ems.emp_id;



SELECT emp_id,
		SUM(casual_leave+sick_leave) AS 'No_of_leaves' ,
        (CASE
			WHEN SUM(casual_leave+sick_leave)>6 THEN 'Loss in pay'
            WHEN SUM(casual_leave+sick_leave)<=6 THEN 'No loss in pay'
            WHEN SUM(casual_leave+sick_leave)=0 THEN 'Bonus'
		END) AS 'desc'
FROM employee
GROUP BY emp_id;


WITH temp AS(SELECT emp_id
		,salary
		,RANK()OVER(ORDER BY salary DESC) AS rk
FROM employee)
SELECT temp.emp_id
		,temp.salary
FROM temp
WHERE rk <6;


WITH tem AS(SELECT dept_id
		,COUNT(emp_id) AS 'no_of_emps'
        ,RANK()OVER(ORDER BY COUNT(emp_id) DESC) AS rk
FROM employee
GROUP BY dept_id)
SELECT tem.dept_id
		,tem.no_of_emps
FROM tem
WHERE rk <4;


SELECT A.dept_id
FROM
(SELECT dept_id
		,RANK() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS rk
FROM employee) A
WHERE rk <= 2;


SELECT em.emp_name
		,COUNT(sk.skill_id)
FROM employee em
JOIN employeeskill ems
ON ems.emp_id = em.emp_id
JOIN skill sk
ON sk.skill_id = ems.skill_id
GROUP BY em.emp_id;


SELECT em.emp_name
		,COUNT(rc.mobile_no) AS 'NO_of_recharges' 
FROM employee em
JOIN mobilerecharge rc
ON rc.mobile_no = em.mobile_no
GROUP BY rc.mobile_no;




SELECT A.project_id
		,A.cost_of_projects 
FROM
(SELECT SUM(DATEDIFF(to_date,from_date)*amount_per_day) AS 'Cost_of_projects'
		,project_id
		,RANK()OVER( ORDER BY SUM(DATEDIFF(to_date,from_date)*amount_per_day) DESC) AS rk
FROM allocation
GROUP BY project_id) A
WHERE rk = 1;

SELECT A.project_id
		,A.cost_of_projects
		,A.no_of_emps
FROM
(SELECT SUM(DATEDIFF(to_date,from_date)*amount_per_day) AS 'Cost_of_projects'
		,COUNT(emp_id) AS 'no_of_emps'
        ,project_id
		,RANK()OVER( ORDER BY SUM(DATEDIFF(to_date,from_date)*amount_per_day) DESC) AS rk
FROM allocation
GROUP BY project_id) A
WHERE rk = 1;


SELECT project_id
	,cost_of_projects 
FROM
(SELECT SUM(DATEDIFF(to_date,from_date)*amount_per_day) AS 'Cost_of_projects'
		,project_id
		,RANK()OVER( ORDER BY SUM(DATEDIFF(to_date,from_date)*amount_per_day) ASC) AS rk
FROM allocation
WHERE YEAR(from_date) = 2012 OR YEAR(to_date) = 2012
GROUP BY project_id) A
WHERE rk = 1;


