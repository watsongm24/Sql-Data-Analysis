/* find the number of events that occur for each day
 for each channel*/
 

SELECT DATE_TRUNC('day', occurred_at) as Days, channel,
					COUNT(*) as events_count
FROM web_events
GROUP BY 1, 2
ORDER BY Days;

/* Create a subquery thatt simply provide all of the 
 data from the first query */
 
SELECT channel, AVG(events_count)  AS Aver_events_counts
FROM  (SELECT DATE_TRUNC('day', occurred_at) as Days, channel,
		COUNT(*) as events_count
		FROM web_events
		GROUP BY 1, 2) sub
GROUP BY 1
Order by 2 DESC;


SELECT DATE_TRUNC('month', occurred_at) AS Monthly
FROM orders
ORDER BY Monthly
LIMIT 1;

/* Then to pull the average for each,
 we could do this all in one query, 
 but for readability, I provided two
 queries below to perform each separately.  */

SELECT *
       FROM orders
       WHERE DATE_TRUNC('month', occurred_at) =
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS Monthly
FROM orders)
ORDER BY occurred_at;


SELECT AVG(standard_qty) AS Average_Standard, 
	   AVG(poster_qty) AS Average_Poster, 
       AVG(gloss_qty) as Average_gloss
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
		(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS Monthly
		FROM orders);
        
SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
      
/* Provide the name of the sales_rep 
in each region with the largest amount 
of total_amt_usd sales. */ 

SELECT region_name, MAX(Somme) as Maximum
FROM
	(SELECT r.name region_name, s.name rep_name, SUM(o.total_amt_usd) as Somme
	FROM region as r 
	JOIN sales_reps as s
	ON s.region_id = r.id
	JOIN accounts as a 
	ON s.id = a.sales_rep_id
	JOIN orders as o
	ON a.id = o.account_id
	GROUP BY 1, 2
	) sub
GROUP BY 1;



