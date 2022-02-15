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
SELECT t3.rep_name, t3.region_name, t3.Somme
FROM
	(SELECT region_name, MAX(Somme) as Maximum
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
		) t1
	GROUP BY 1)t2
JOIN (SELECT r.name region_name, s.name rep_name, SUM(o.total_amt_usd) as Somme
		FROM region as r 
		JOIN sales_reps as s
		ON s.region_id = r.id
		JOIN accounts as a 
		ON s.id = a.sales_rep_id
		JOIN orders as o
		ON a.id = o.account_id
		GROUP BY 1, 2
        ORDER BY 3 DESC)t3
ON t3.region_name = t2.region_name AND t3.Somme = t2.Maximum;


/* For the region with the largest (sum) 
of sales total_amt_usd, how many total (count)
 orders were placed? */
SELECT COUNT(o.total) as Total_Orders, r.name
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(Somme)
	  FROM (SELECT r.name region_name, SUM(o.total_amt_usd) as Somme 
		FROM region as r 
		JOIN sales_reps as s
		ON s.region_id = r.id
		JOIN accounts as a 
		ON s.id = a.sales_rep_id
		JOIN orders as o
		ON a.id = o.account_id
		GROUP BY r.name
		)sub);
/*What is the lifetime average amount spent in terms
 of total_amt_usd for the top 10 total spending accounts */

SELECT a.id, a.name, SUM(o.total_amt_usd) as total_spent
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3
LIMIT 10;

SELECT AVG(total_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) as total_spent
FROM accounts as a 
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10) temp;

/* What is the lifetime average amount spent in terms of total_amt_usd, 
including only the companies that spent more per order, on average, 
than the average of all orders. */

-- pull the average of all accounts in terms of total_amt_usd:
SELECT AVG(o.total_amt_usd) as avg_all
from orders as o;

/* Then, we want to only pull the accounts with more than this average amount.*/
SELECT o.account_id, AVG(o.total_amt_usd) as avg_amt
FROM orders as o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) as avg_all
								from orders as o);

-- Finally, we just want the average of these values.
SELECT AVG(avg_amt)
FROM(SELECT o.account_id, AVG(o.total_amt_usd) as avg_amt
FROM orders as o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) as avg_all
								from orders as o))temp_table;

/* Provide the name of the sales_rep in each region
 with the largest amount of total_amt_usd sales.*/
WITH t1 AS(
SELECT r.name region, s.name sales_reps, 
			SUM(o.total_amt_usd) as total_amt
from region as r
JOIN sales_reps as s 
ON r.id = s.region_id
JOIN accounts as a
ON a.sales_rep_id = s.id
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC),
t2 as (
	SELECT r.name region, MAX(total_amt) as total_amt
    FROM t1
    GROUP BY 1)
SELECT t1.r.name, t1.s.name, t1.total_amt
FROM t1
JOIN t2
ON t1.r.name = t2.r.name AND t1.total_amt = t2.total_amt;
    
    


