SELECT COUNT(poster_qty)
From orders;

SELECT COUNT(standard_qty)
FROM orders;


SELECT SUM(total_amt_usd)
FROM orders;

select (standard_amt_usd + gloss_amt_usd) as total_standard_gloss
FROM orders;
		
Select SUM(standard_amt_usd) / SUM(standard_qty) as standard_price_per_unit
FROM orders;

-- MIN, MAX, & AVERAGE
-- When was the earliest order ever placed? You only need to return the date
Select MIN(occurred_at)
FROM orders;

-- Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at
FROM orders
order by occurred_at
LIMIT 1;

-- When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at) 
FROM web_events;

-- Try to perform the result of the previous query without using an aggregation function.
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, 
           AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, 
           AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd
FROM orders;

-- MEDIAN total_usd spent on all orders 
SELECT *
FROM (SELECT total_amt_usd
		FROM orders
        order by total_amt_usd
        limit 3457) AS Median1
Order by total_amt_usd DESC
Limit 1;

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

SELECT a.name, MIN(o.occurred_at)
from accounts as a
join orders as o
on o.account_id = a.id
GROUP BY a.name
ORDER BY a.name
limit 1;

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.

SELECT a.name, SUM(o.total_amt_usd)
from accounts as a
join orders as o
on o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;

/* Via what channel did the most recent (latest) web_event occur, 
which account was associated with this web_event? 
Your query should return only three values - the date, channel, and account name.*/

SELECT w.occurred_at, w.channel, a.name
from accounts as a
join web_events as w
on w.account_id = a.id
ORDER BY w.occurred_at DESC
limit 1;

-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used

SELECT w.channel, COUNT(w.channel)
from web_events as w
GROUP BY w.channel
ORDER BY w.channel;


-- Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc, w.occurred_at
FROM web_events as w
join accounts as a
on w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd) as Smallest_order
FROM accounts as a
JOIN orders as o
on o.account_id = a.id
GROUP BY a.name
order by Smallest_order;

-- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name, COUNT(s.name) as NumberOfSalesReps
FROM region as r
JOIN sales_reps as s
on s.region_id = r.id
GROUP BY r.name
ORDER BY NumberOfSalesReps;

/* For each account, determine the average amount of each
 type of paper they purchased across their orders. Your result 
 should have four columns - one for the account name and one for the 
 average quantity purchased for each of the paper types for each account.
  */
  
  SELECT a.name, AVG(o.poster_qty) as Poster_Average, AVG(o.standard_qty) as Average_Standard,
			AVG(o.gloss_qty) as Average_Gloss
  from accounts as a
  JOIN orders as o
  on o.account_id = a. id
  GROUP BY a.name
  ORDER BY a.name;
  
  /* For each account, determine the average amount spent per order 
  on each paper type. Your result should have four columns - one for 
  the account name and one for the average amount spent on each paper type. */
  
  SELECT a.name, AVG(o.standard_amt_usd) AS Average_Standard_Spent, 
		AVG(o.gloss_amt_usd) as Average_gloss_spent, AVG(o.poster_amt_usd) as Average_Poster_Spent
  FROM accounts as a
  JOIN orders as o
  ON o.account_id = a.id
  GROUP BY a.name
  order by a.name;
  
  /* Determine the number of times a particular channel 
    was used in the web_events table for each sales rep. 
    Your final table should have three columns - the name of the sales rep,
    the channel, and the number of occurrences. Order your table with the highest 
    number of occurrences first.*/
    
    SELECT s.name, w.channel, COUNT(w.channel) as Number_of_occurrences
    FROM sales_reps as s
    join accounts as a 
    ON a.sales_rep_id = s.id
    JOIN web_events as w 
    ON w.account_id = a.id
    GROUP BY s.name, w.channel
    ORDER BY Number_of_occurrences DESC;
    
/* Determine the number of times a particular channel was 
used in the web_events table for each region. Your final table should have 
three columns - the region name, the channel, and the number of occurrences. 
Order your table with the highest number of occurrences first. */

SELECT r.name, w.channel, COUNT(w.channel) as Number_of_occurrences
FROM region as r
JOIN sales_reps as s
ON s.region_id = r.id
JOIN accounts as a 
ON a.sales_rep_id = s.id
JOIN web_events as w
on w.account_id = a.id
GROUP BY r.name, w.channel
ORDER BY Number_of_occurrences DESC;

-- Use DISTINCT to test if there are any accounts associated with more than one region.

SELECT a.id as Account_ID, r.id as Region_id, a.name as Account_name,
            r.name as Region_name
from accounts as a 
JOIN sales_reps as s
ON a.sales_rep_id = s.id
JOIN region as r
ON s.region_id = r.id;

-- Have any sales reps worked on more than one account?
SELECT DISTINCT s.id as Sales_rep, s.name, COUNT(a.id) as Account_total
from accounts as a 
JOIN sales_reps as s 
ON a.sales_rep_id = s.id
GROUP BY Sales_rep, s.name
ORDER BY Account_total;

-- HAVING  How many of the sales reps have more than 5 accounts that they manage?
SELECT s.name, COUNT(a.name) as Account_Number
from sales_reps as s
JOIN accounts as a 
ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.name) > 5
ORDER BY Account_Number;

-- How many accounts have more than 20 orders?
SELECT a.id, a.name, count(*) As Number_orders
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
GROUP BY a.id, a.name
HAVING count(*) > 20
ORDER BY Number_orders;


-- Which account has the most orders?
SELECT a.id, a.name, COUNT(*) as Most_Order
FROM orders as o
JOIN accounts as a
ON o.account_id = a.id
GROUP BY a.id, a.name
ORDER BY Most_Order DESC
LIMIT 1;

-- Which accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) as Money_Spent
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY  a.id, a.name
HAVING SUM(o.total_amt_usd) < 100
Order BY Money_Spent;

-- Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) as Spent
FROM accounts as a 
JOIN orders as o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY Spent;

-- Which account has spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) as Spent
FROM accounts as a 
JOIN orders as o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY Spent DESC
LIMIT 1;

-- Which account has spent the least with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) as Spent
FROM accounts as a
JOIN orders as o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY Spent
LIMIT 1;

-- Which accounts used facebook as a channel to contact customers more than 6 times
SELECT a.id, w.channel, COUNT(*) as Counts 
FROM accounts as a 
JOIN web_events as w
ON a.id = w.account_id
GROUP BY a.id, w.channel
HAVING COUNT(*) > 6  And w.channel LIKE 'facebook'
ORDER BY Counts;

-- Which account used facebook most as a channel?
SELECT a.id, w.channel, COUNT(*) as Counts
FROM accounts as a 
JOIN web_events as w
ON a.id = w.account_id
GROUP BY a.id, w.channel
HAVING w.channel LIKE 'facebook' 
ORDER BY Counts DESC
LIMIT 1;

-- Which channel was most frequently used by most accounts?
SELECT a.id, w.channel, COUNT(*) Most_used
FROM accounts as a
JOIN web_events as w
ON w.account_id = a.id
GROUP BY a.id, w.channel
ORDER BY Most_used DESC
LIMIT 1;


-- Working With DATEs
/* Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals?*/

SELECT DATE_PART('year', occurred_at ) as Each_year, SUM(total_amt_usd) AS Total_Dollars
FROM orders
GROUP BY DATE_PART('year', occurred_at)
ORDER BY Total_Dollars DESC;

/* Which month did Parch & Posey have the greatest sales in terms of total dollars? 
Are all months evenly represented by the dataset?*/

SELECT DATE_PART('year', occurred_at) as Year_sale, SUM(total_amt_usd) as Total_Dollars
FROM orders 
where occurred_at BETWEEN '2013-01-01' AND '2017-01-01'
GROUP BY DATE_PART('year', occurred_at)
ORDER BY Total_Dollars DESC;

/* Which month did Parch & Posey have the greatest sales in
 terms of total number of orders? Are all months evenly represented
 by the dataset?*/
 
SELECT DATE_PART('month', occurred_at) as Month_sale, SUM(total_amt_usd) as Total_Dollars
FROM orders 
where occurred_at BETWEEN '2013-01-01' AND '2017-01-01'
GROUP BY DATE_PART('month', occurred_at)
ORDER BY Total_Dollars DESC;

/* Which year did Parch & Posey have the greatest 
sales in terms of total number of orders? Are all years evenly 
represented by the dataset?*/
 
SELECT DATE_PART('year', occurred_at) as Year_sale, SUM(total_amt_usd) as Total_Dollars
FROM orders 
where occurred_at BETWEEN '2013-01-01' AND '2017-01-01'
GROUP BY DATE_PART('year', occurred_at)
ORDER BY Total_Dollars DESC
LIMIT 1;

/* In which month of which year
 did Walmart spend the most on gloss paper in terms of dollars? */
 
SELECT DATE_TRUNC('year', o.occurred_at) AS Yearly_SPent, a.name, SUM(o.gloss_amt_usd) as Total_spent
from orders as o
JOIN accounts as a
On a.id = o.account_id
GROUP BY DATE_TRUNC('year', o.occurred_at), a.name
HAVING a.name like 'Walmart'
ORDER BY Total_spent DESC
LIMIT 1;

-- CASE
/* Write a query to display for each order, the account ID,
 total amount of the order, and the level of the order 
 - ???Large??? or ???Small??? - depending on if the order is $3000 or more, 
 or smaller than $3000. */
 
 SELECT account_id,total_amt_usd,
		CASE WHEN total_amt_usd >= 3000 THEN 'Large'
		ELSE 'Small' END AS Order_level
FROM Orders;


/* Write a query to display the number of 
orders in each of three categories, based on the 
total number of items in each order. The three categories are: 
'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.*/

SELECT   CASE WHEN total >= 2000 THEN 'At Least 2000'
		WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
		ELSE 'Less than 1000' END AS Order_Categories,
COUNT(*) AS Order_Count
FROM orders
GROUP BY 1
ORDER BY Order_Count;

/* We would like to understand 3 different levels of customers 
based on the amount associated with their purchases. The top level 
includes anyone with a Lifetime Value (total sales of all orders) 
greater than 200,000 usd. The second level is between 200,000 and 
100,000 usd. The lowest level is anyone under 100,000 usd. Provide 
a table that includes the level associated with each account. You 
should provide the account name, the total sales of all orders for 
the customer, and the level. Order with the top spending customers 
listed first. */

SELECT a.name, SUM(total_amt_usd) as Total_amount, 
			CASE WHEN SUM(total_amt_usd) > 200000 THEN 'Top level'
			WHEN SUM(total_amt_usd) BETWEEN 200000 AND 100000 THEN 'Second level'
			ELSE 'Lowest Level' END AS Lifetime_Value
FROM orders as o
JOIN accounts as a
ON a.id = o.account_id
GROUP BY a.name
Order BY 2 DESC;

/* We would now like to perform a similar 
calculation to the first, but we want to obtain the total
amount spent by customers only in 2016 and 2017. Keep the same 
levels as in the previous question. Order with the top spending 
customers listed first.
*/
SELECT a.name, SUM(total_amt_usd) as Total_amount,
				CASE WHEN  SUM(total_amt_usd) > 200000 THEN 'Top'
					WHEN SUM(total_amt_usd) > 100000 THEN 'Second'
                    ELSE 'Low' END AS Lifetime_value
FROM orders as o
JOIN accounts as a 
ON a.id = o.account_id 
Where o.occurred_at > '2016-01-01' 
GROUP BY 1
ORDER BY 2 DESC;


/* We would like to identify top performing sales reps,
 which are sales reps associated with more than 200 orders.
 Create a table with the sales rep name, the total number of 
 orders, and a column with top or not depending on if they have
 more than 200 orders. Place the top sales people first in your final table. */
 
 SELECT s.name, COUNT(*) as num_orders,
        CASE WHEN COUNT(*) > 200 THEN 'Top performing'
            ELSE 'Not depending' END as Performance
FROM sales_reps as s
JOIN accounts as a 
ON s.id = a.sales_rep_id
JOIN orders as o 
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


/* The previous didn't account for the middle, nor the dollar amount
 associated with the sales. Management decides they want to see these
 characteristics represented as well. We would like to identify 
 top performing sales reps, which are sales reps associated with 
 more than 200 orders or more than 750000 in total sales. The middle
 group has any rep with more than 150 orders or 500000 in sales. 
 Create a table with the sales rep name, the total number of orders,
 total sales across all orders, and a column with top, middle, 
 or low depending on this criteria. Place the top sales people 
 based on dollar amount of sales first in your final table. 
 You might see a few upset sales people by this criteria! */
 
 SELECT s.name, COUNT(*) as num_Orders, SUM(o.total_amt_usd) as Num_sales,
			CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'Top'
                WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'Middle'
                ELSE 'Low' END as Performance
FROM sales_reps as s
JOIN accounts as a 
ON s.id = a.sales_rep_id
JOIN orders as o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;
 