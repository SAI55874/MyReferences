SELECT book_category
		,COUNT(book_id)
FROM books
GROUP BY book_category;


SELECT COUNT(book_id)
		,book_category
FROM books
GROUP BY title
HAVING book_category = 'RDBMS';


SELECT A.book_category
		,A.title
        ,edition
FROM
	(SELECT book_category
		,title
        ,edition
        ,RANK()OVER( PARTITION BY book_category ORDER BY ye_of_pub DESC) AS rk
	FROM books) A
WHERE rk = 1;



SELECT A.book_id
		,A.title
FROM
	(SELECT book_id
		,title
        ,COUNT(publisher_id)
        ,RANK() OVER(ORDER BY COUNT(publisher_id) DESC) AS rk
	FROM books
    GROUP BY publisher_id) A
WHERE rk =1;



SELECT bk.title
		,mm.member_name
        ,bt.due_date
        ,DATEDIFF(bt.return_date,bt.due_date) AS 'Delay'
FROM books bk
JOIN book_transaction bt
ON bt.book_id = bk.book_id
JOIN members mm
ON mm.member_id = bt.member_id
WHERE DATEDIFF(bt.return_date,bt.due_date) >0
ORDER BY delay DESC;



SELECT bk.book_category
FROM books bk
JOIN publishers pb
ON pb.publisher_id = bk.publisher_id
WHERE publisher_name = 'willey';





SELECT A.book_category
FROM(SELECT bk.book_category
		,RANK() OVER(ORDER BY COUNT(bk.book_category) ASC) AS rk
	FROM books bk
	JOIN book_transaction bt
	ON bt.book_id = bk.book_id
	GROUP BY bk.book_category) A
WHERE rk=1;




SELECT A.book_category
FROM(SELECT bk.book_category
		,RANK() OVER(ORDER BY COUNT(bk.book_category) DESC) AS rk
	FROM books bk
	JOIN book_transaction bt
	ON bt.book_id = bk.book_id
	GROUP BY bk.book_category) A
WHERE rk=1;



SELECT 
	CASE
            WHEN YEAR(bt.issue_date)!=2003 THEN
            CASE
				WHEN MONTH(bt.issue_date)  != 10 AND MONTH(bt.issue_date)  !=11 AND MONTH(bt.issue_date)  !=12 THEN bk.book_id
			END
	END AS 'no_lent_books'
    ,bk.book_id
FROM book_transaction bt
RIGHT OUTER JOIN books bk
ON  bk.book_id = bt.book_id 
