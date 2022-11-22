use sai;

SELECT A.order_code
FROM
(SELECT order_code
		,COUNT(product_code)
        ,RANK() OVER(ORDER BY COUNT(product_code) DESC) AS rk
FROM order_detail
GROUP BY order_code) A
WHERE rk = 1;




SELECT A.product_code
		,A.price
FROM
(SELECT product_code
		,price
        ,RANK() OVER(ORDER BY price DESC) AS rk
FROM product) A
WHERE rk=1;



SELECT A.category_code
FROM
(SELECT category_code
        ,SUM(qty_on_hand) AS 'total_products_of_Category'
        ,RANK() OVER(ORDER BY SUM(qty_on_hand) DESC) AS rk
FROM product
GROUP BY category_code) A
WHERE rk=1;


SELECT A.product_code
FROM
(SELECT product_code
		,COUNT(order_code) AS 'Frequently_order'
        ,RANK() OVER(ORDER BY COUNT(order_code) DESC) AS rk
FROM order_detail
GROUP BY product_code) A
WHERE rk = 1;



SELECT A.product_code
FROM
(SELECT product_code
		,COUNT(order_code) AS 'Frequently_order'
        ,RANK() OVER(ORDER BY COUNT(order_code) ASC) AS rk
FROM order_detail
GROUP BY product_code) A
WHERE rk = 1;


SELECT product.product_code
FROM order_detail
JOIN product
ON product.product_code = order_detail.product_code
WHERE product.product_code NOT IN (SELECT product_code
					FROM order_detail);



WITH temp AS
(SELECT order_detail.order_code
        ,SUM(product.price*order_detail.qty_ordered) AS 'Cost_of_order'
        ,RANK() OVER(ORDER BY SUM(product.price*order_detail.qty_ordered) DESC) AS rk
FROM product
JOIN order_detail
ON product.product_code=order_detail.product_code
GROUP BY order_detail.order_code)
SELECT temp.order_code
FROM temp
WHERE rk = 1;

WITH temp AS
(SELECT order_detail.order_code
        ,SUM(product.price*order_detail.qty_ordered) AS 'Costliest_order'
        ,order_master.order_date
        ,RANK() OVER(ORDER BY SUM(product.price*order_detail.qty_ordered) DESC) AS rk
FROM product
 LEFT JOIN order_detail
ON product.product_code=order_detail.product_code
LEFT JOIN order_master
ON order_detail.order_code = order_master.order_code
GROUP BY order_detail.order_code)
SELECT temp.order_date
FROM temp 
WHERE rk = 1;


WITH temp AS
(SELECT order_detail.order_code
        ,SUM(product.price*order_detail.qty_ordered) AS 'Costliest_order'
        ,customer.customer_code
        ,RANK() OVER(ORDER BY SUM(product.price*order_detail.qty_ordered) DESC) AS RK
FROM product
 LEFT JOIN order_detail
ON product.product_code=order_detail.product_code
LEFT JOIN order_master
ON order_detail.order_code = order_master.order_code
LEFT JOIN customer
ON customer.customer_code = order_master.customer_code
GROUP BY order_detail.order_code)
SELECT temp.customer_code
FROM temp
WHERE rk=1;



SELECT A.country_code
		,A.no_of_branches
FROM
(SELECT country_code
	,COUNT(branch_code) AS 'NO_of_branches'
    ,RANK() OVER(ORDER BY COUNT(branch_code) DESC) AS rk
FROM branch
GROUP BY country_code) A
WHERE rk = 1;



SELECT A.country_code
		,A.no_of_branches
FROM
(SELECT country_code
	,COUNT(branch_code) AS 'NO_of_branches'
    ,RANK() OVER(ORDER BY COUNT(branch_code) ASC) AS rk
FROM branch
GROUP BY country_code) A
WHERE rk = 1
;



SELECT country_code
FROM country
WHERE country_code NOT IN (SELECT country_code
					FROM branch)
GROUP BY country_code;



SELECT A.branch_code
		,A.no_of_salesrep
FROM
(SELECT branch_code
		,COUNT(salesrep_id) AS 'no_of_salesrep'
        ,RANK() OVER(ORDER BY COUNT(salesrep_id) DESC) AS rk
FROM salesrep
GROUP BY branch_code) A
WHERE rk = 1;



WITH temp AS (SELECT salesrep_id
		,COUNT(salesrep_id) AS 'No_of_orders_placed'
        ,RANK() OVER(ORDER BY COUNT(salesrep_id) DESC) AS rk
FROM order_master
GROUP BY salesrep_id)
SELECT temp.salesrep_id
	,temp.No_of_orders_placed
FROM temp
WHERE rk =1;

SELECT salesrep_id
	,salesrep_name
FROM salesrep
GROUP BY mgr;

SELECT sl.salesrep_name
		,sl.salesrep_doj
FROM salesrep sl
JOIN salesrep mgr
ON mgr.salesrep_id = sl.salesrep_id 
GROUP BY sl.salesrep_doj
HAVING sl.salesrep_doj > (SELECT salesrep_doj
						FROM salesrep
						GROUP BY mgr
						LIMIT 1) ;




SELECT A.mgr
FROM (SELECT AVG (salary) AS 'avg_salary'
				, mgr
                ,salary
			FROM salesrep
            GROUP BY mgr) A
WHERE avg_salary>ANY(SELECT salary
					FROM salesrep
                    GROUP BY salesrep_id)
ORDER BY salary DESC;



SELECT branch.branch_name
		,salesrep.salesrep_name
		,salesrep.salary
FROM salesrep
LEFT JOIN branch
ON salesrep.branch_code = branch.branch_code
GROUP BY branch.branch_code;

SELECT emp.project_name
FROM(SELECT t_project.project_name
		,COUNT(employee.EMP_ID) AS 'No_of_emp'
        ,RANK() OVER( ORDER BY COUNT(employee.EMP_ID) DESC ) AS 'max_emp' 
FROM allocation
LEFT JOIN t_project
ON t_project.project_id = allocation.project_id
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
GROUP BY t_project.PROJECT_id
ORDER BY no_of_emp DESC) emp
WHERE  max_emp= 1;


SELECT sl.salesrep_name
		,'Works for' AS ''
        ,mgr.salesrep_name
FROM salesrep sl
JOIN salesrep mgr
ON mgr.salesrep_id =sl.mgr
ORDER BY mgr.salesrep_doj;



SELECT sl.salesrep_name
FROM salesrep sl
INNER JOIN salesrep isl
ON isl.salesrep_id = sl.mgr
WHERE sl.salary>isl.salary;


SELECT a.salesrep_name
FROM
(SELECT order_master.salesrep_id
	,salesrep.salesrep_name
    ,DATEDIFF(order_master.order_date,salesrep.salesrep_doj) AS 'datdif'
    ,RANK() OVER(ORDER BY DATEDIFF(order_master.order_date,salesrep.salesrep_doj) ASC) AS rk
FROM salesrep
JOIN order_master
ON order_master.salesrep_id = salesrep.salesrep_id 
WHERE DATEDIFF(order_master.order_date,salesrep.salesrep_doj) >0
GROUP BY salesrep_id) A
WHERE rk=1;


SELECT salesrep_id
		,salesrep_name
FROM salesrep
WHERE salesrep_id NOT IN (SELECT salesrep_id
									FROM order_master);



SELECT a.emp_id
	,a.role_title
FROM(SELECT employee.emp_id
		,role.role_title
		,COUNT(role.role_title) AS 'no_t'
        ,RANK()OVER(ORDER BY COUNT(role_title) DESC) AS rk
FROM allocation
LEFT JOIN role
ON role.role_id = allocation.role_id
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
WHERE employee.emp_id = 'E03') a
WHERE rk = 1;




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
					GROUP BY project_id)) A;
                    
                    
SELECT 
	CASE 
			WHEN to_date < NOW() THEN COUNT(project_id)
			END AS 'completed_projects'
	FROM allocation;



SELECT MAX(to_date)
FROM allocation
GROUP BY project_id
;

SELECT A.project_id
		,A.emp_count
FROM (SELECT pr.project_id
	,pr.deadline
	,COUNT(al.emp_id) AS 'emp_count'
FROM t_project pr
JOIN allocation al
ON al.project_id = pr.project_id
GROUP BY pr.project_id
HAVING pr.deadline <ALL (SELECT MAX(to_date)
							FROM allocation
							GROUP BY project_id)) A ;
                            
WITH temp AS(SELECT t_project.project_id
		,employee.emp_name
        ,employee.salary
        ,RANK() OVER(ORDER BY COUNT(allocation.role_id)DESC)
FROM allocation
LEFT JOIN t_project
ON t_project.project_id = allocation.project_id
RIGHT JOIN employee
ON employee.emp_id = allocation.emp_id
WHERE t_project.project_id = 'P07')
SELECT temp.project_id
	,emp_name
FROM temp;



