
SELECT order_detail.order_code
        ,SUM(product.price*order_detail.qty_ordered) AS 'Total_bill'
FROM product
 LEFT JOIN order_detail
ON product.product_code=order_detail.product_code
WHERE product.price*order_detail.qty_ordered >= 5000  
GROUP BY order_detail.order_code
ORDER BY order_detail.order_code ASC;

SELECT Country.country_code
		,branch.country_code
FROM country
JOIN branch
ON
Country.country_code=branch.country_code
WHERE Country.country_code NOT IN (branch.country_code)
GROUP BY Country.country_code;


SELECT salesrep_name
		,salesrep_doj
FROM salesrep
WHERE salesrep_doj>(SELECT salesrep_doj
							FROM salesrep
							GROUP BY mgr
                            LIMIT 1) 
GROUP BY salesrep_doj  
ORDER BY salesrep_doj ASC;




SELECT salesrep_id
	,salesrep_name
FROM salesrep
GROUP BY mgr
ORDER BY mgr;


SELECT salesrep_id
	,salesrep_name
    ,salary
FROM salesrep
WHERE NOT salesrep_id IN (mgr)
GROUP BY salesrep_id 
ORDER BY salary DESC;



SELECT mgr
		,AVG (salary) AS 'avg_salary'
FROM salesrep
WHERE mgr > SALESREP_ID
GROUP BY salesrep_id 
ORDER BY salary DESC;


SELECT order_master.salesrep_id
	,salesrep.salesrep_name
    ,order_master.order_date
    ,salesrep.salesrep_doj
FROM salesrep
LEFT JOIN order_master
ON salesrep.salesrep_id = order_master.salesrep_id;


SELECT salesrep.salesrep_id
		,salesrep.salesrep_name
FROM salesrep
RIGHT OUTER JOIN order_master
ON salesrep.salesrep_id = order_master.salesrep_id 
WHERE salesrep.salesrep_id=salesrep.salesrep_id NOT IN (order_master.salesrep_id)
GROUP BY order_master.salesrep_id
HAVING COUNT(salesrep.salesrep_id) < 2;
                
                


SELECT salesrep.salesrep_id
	,salesrep.salesrep_name
    ,salesrep.salary
    ,SUM(product.price*order_detail.qty_ordered) AS 'Total_orde_value'
    ,5/100*(SUM(product.price*order_detail.qty_ordered)) AS 'Comission_5%'
FROM salesrep
LEFT JOIN order_master
ON order_master.salesrep_id = salesrep.salesrep_id
LEFT JOIN order_detail
ON order_detail.order_code = order_master.order_code
LEFT JOIN product
ON product.product_code = order_detail.product_code
GROUP BY salesrep.salesrep_id;


SELECT salesrep.salesrep_name
	,order_detail.order_code
    ,SUM(product.price*order_detail.qty_ordered) AS 'Bill_value'
FROM salesrep
LEFT JOIN order_master
ON order_master.salesrep_id = salesrep.salesrep_id
LEFT JOIN order_detail
ON order_detail.order_code = order_master.order_code
LEFT JOIN product
ON product.product_code = order_detail.product_code
GROUP BY salesrep.salesrep_name;



SELECT salesrep.salesrep_name
	,order_detail.order_code
    ,SUM(order_detail.qty_ordered) AS 'No_of_products'
FROM salesrep
LEFT JOIN order_master
ON order_master.salesrep_id = salesrep.salesrep_id
LEFT JOIN order_detail
ON order_detail.order_code = order_master.order_code
GROUP BY salesrep.salesrep_name;




SELECT salesrep.salesrep_name
	,order_detail.order_code
    ,SUM(product.price*order_detail.qty_ordered) AS 'Bill_value'
    ,SUM(order_detail.qty_ordered) AS 'No_of_products'
FROM salesrep
LEFT JOIN order_master
ON order_master.salesrep_id = salesrep.salesrep_id
LEFT JOIN order_detail
ON order_detail.order_code = order_master.order_code
LEFT JOIN product
ON product.product_code = order_detail.product_code
GROUP BY salesrep.salesrep_name;


SELECT order_master.order_date
        ,COUNT(order_detail.order_code) AS 'no_of_orders'
FROM order_detail
LEFT JOIN order_master
ON order_detail.order_code = order_master.order_code 
WHERE order_master.order_date BETWEEN '2009-12-31' AND '2011-01-01'
GROUP BY order_master.order_date;

SELECT salesrep.salesrep_name AS 'In_active_rep'
        ,branch.branch_name
FROM salesrep
RIGHT OUTER JOIN order_master
ON salesrep.salesrep_id = order_master.salesrep_id 
LEFT JOIN branch
ON branch.branch_code = salesrep.branch_code
WHERE salesrep.salesrep_id=salesrep.salesrep_id NOT IN (order_master.salesrep_id)
GROUP BY order_master.salesrep_id
HAVING COUNT(salesrep.salesrep_id) < 2;


SELECT order_master.salesrep_id
    ,salesrep.salesrep_doj
    ,branch.branch_name
FROM salesrep
LEFT JOIN order_master
ON salesrep.salesrep_id = order_master.salesrep_id
RIGHT JOIN branch
ON branch.branch_code = salesrep.branch_code
GROUP BY branch.branch_name
ORDER BY salesrep.salesrep_doj DESC
LIMIT 1;



SELECT SUM(product.price*order_detail.qty_ordered) AS 'Total_bill'
		,COUNT(order_detail.order_code) AS 'No_of_orders'
FROM product
 LEFT JOIN order_detail
ON product.product_code=order_detail.product_code
WHERE product.price*order_detail.qty_ordered < 500 
GROUP BY order_detail.order_code
ORDER BY order_detail.order_code ASC;

SELECT order_master.customer_code
	,COUNT(order_master.customer_code) AS 'No_of_orders'
    ,product.prod_desc
FROM order_master
LEFT JOIN order_detail
ON order_detail.order_code = order_master.order_code
LEFT JOIN product
ON product.product_code = order_detail.product_code
GROUP BY order_master.customer_code
ORDER BY no_of_orders DESC
LIMIT 1;


SELECT order_master.customer_code
	,COUNT(order_detail.product_code)
	,product.product_code
FROM order_master
LEFT JOIN order_detail
ON order_master.order_code = order_detail.order_code
LEFT JOIN product
ON product.product_code = order_detail.product_code
WHERE product.product_code NOT IN (SELECT order_detail.product_code
									FROM order_detail)
GROUP BY order_detail.product_code;


SELECT customer.customer_name
	,order_detail.order_code
    ,order_detail.product_code
    ,product.prod_desc
    ,order_master.order_date
FROM salesrep
LEFT JOIN order_master
ON order_master.salesrep_id = salesrep.salesrep_id
LEFT JOIN customer
ON customer.customer_code = order_master.customer_code
LEFT JOIN order_detail
ON order_detail.order_code = order_master.order_code
LEFT JOIN product
ON product.product_code = order_detail.product_code;

SELECT branch.branch_name
		,salesrep.salesrep_name
		,salesrep.salary
FROM salesrep
LEFT JOIN branch
ON salesrep.branch_code = branch.branch_code
GROUP BY branch.branch_code
ORDER BY salary DESC
LIMIT 1;


SELECT A.customer_code
		,A.no_of_orders
FROM
	(SELECT customer.customer_code
			,COUNT(order_master.customer_code) AS 'No_of_orders'
			,RANK() OVER( ORDER BY COUNT(order_master.customer_code) DESC) AS rk
	FROM order_master
	LEFT JOIN customer
	ON order_master.customer_code = customer.customer_code
	GROUP BY customer.customer_code) A
	WHERE rk<11 ;

SELECT A.order_code
		,A.Total_bill
FROM
	(SELECT order_master.order_code
			,SUM(product.price*order_detail.qty_ordered) AS 'Total_bill'
			,RANK() OVER(ORDER BY SUM(product.price*order_detail.qty_ordered) DESC) AS 'rk'
	FROM order_master
	LEFT JOIN order_detail
	ON order_detail.order_code = order_master.order_code
	LEFT JOIN product
	ON product.product_code = order_detail.product_code
	GROUP BY order_master.order_code
	ORDER BY Total_bill DESC) A
    WHERE rk < 6;


SELECT category.category_desc
		,MAX(product.price) AS 'costliest_product'
FROM product
JOIN category 
ON product.category_code=category.CATEGORY_CODE
GROUP BY category.category_code
ORDER BY costliest_product DESC;


SELECT  product.PROD_DESC
		,COUNT(order_detail.product_code) AS 'ordered_product'
FROM product
JOIN order_detail 
ON product.product_code = order_detail.product_code
WHERE product.product_code NOT IN (order_detail.product_code)
GROUP BY product.PROD_DESC;


SELECT order_detail.order_code
        ,SUM(product.price*order_detail.qty_ordered) AS 'Costliest_order'
        ,(select now()) AS 'Today_date'
        ,customer.customer_code
        ,customer.customer_name
FROM product
 LEFT JOIN order_detail
ON product.product_code=order_detail.product_code
LEFT JOIN order_master
ON order_detail.order_code = order_master.order_code
LEFT JOIN customer
ON customer.customer_code = order_master.customer_code
WHERE order_master.order_date = (select now())
GROUP BY order_master.order_date
ORDER BY costliest_order DESC
LIMIT 1;




SELECT salesrep_id
		,COUNT(salesrep_id) AS 'active_salesrep'
FROM order_master
GROUP BY salesrep_id;



SELECT salesrep_id
	,salesrep_name
FROM salesrep
GROUP BY mgr
ORDER BY mgr;


SELECT salesrep_name
		,salesrep_doj
FROM salesrep
WHERE salesrep_doj>(SELECT salesrep_doj
			FROM salesrep
			GROUP BY mgr
			LIMIT 1)  
ORDER BY salesrep_doj ASC;

SELECT salesrep_id
FROM order_master
WHERE order_code = 'OR11' OR order_code = 'OR15';


SELECT A.branch_code
	,A.no_of_salesrep
FROM
	(SELECT branch_code
			,COUNT(salesrep_id) AS 'no_of_salesrep'
			,rank()over(ORDER BY COUNT(salesrep_id) ASC) AS 'rk'
	FROM salesrep
	GROUP BY branch_code
	ORDER BY no_of_salesrep ASC) A
WHERE rk = 1;



