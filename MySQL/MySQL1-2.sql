SELECT category_code
FROM(SELECT category_code
	,RANK() OVER( ORDER BY category_code DESC) AS rn
FROM product
GROUP BY category_code) A
WHERE rn=1;


SELECT category_code
FROM(SELECT category_code
	,RANK() OVER( ORDER BY category_code ASC) AS rn
FROM product
GROUP BY category_code) A
WHERE rn=1;


