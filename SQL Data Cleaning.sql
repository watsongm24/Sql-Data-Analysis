SELECT COUNT(*)  
FROM(SELECT name, count(name),
CASE
	WHEN name like '[0-9]%' THEN 'Company starts with a number'
ELSE 'Company starts with a letter'
END AS text_number
FROM accounts
group by name
order by name)t1
group by name
HAVING name like '[0-9]%';


SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts)t1;

/* Use the accounts table to create first and last name columns
 that hold the first and last names for the primary_poc.*/
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1) as first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) as last_name
FROM accounts;



SELECT left(primary_poc, STRPOS(primary_poc, ' ')) as First_name,
right(primary_poc, length(primary_poc) - STRPOS(primary_poc, ' ')) as last_name
from accounts;


/* Now see if you can do the same thing for every 
rep name in the sales_reps table. Again provide 
first and last name columns. */

SELECT name, left(name, STRPOS(name, ' ')) as first_name,
right(name, length(name) - STRPOS(name, ' ')) as last_name
from sales_reps;


/*1.Each company in the accounts table wants 
to create an email address for each primary_poc.
 The email address should be the first name
 of the primary_poc . last name primary_poc @ company name .com. */
 
SELECT  First_name, Last_name,
		CONCAT(First_name, '.', Last_name, '@', name, '.com') as email
FROM(SELECT name, left(primary_poc, STRPOS(primary_poc, ' ')) as First_name,
		right(primary_poc, length(primary_poc) - STRPOS(primary_poc, ' ')) as Last_name
from accounts)t1;

/* You may have noticed that in the previous solution
 some of the company names include spaces, which will
 certainly not work in an email address. See if you can
 create an email address that will work by removing all of 
 the spaces in the account name, but otherwise your solution
 should be just as in question 1. */

SELECT First_name, Last_name,
CONCAT(First_name, '.', Last_name, '@', name, '.com') as Email  
FROM(SELECT name, LEFT(primary_poc, STRPOS(primary_poc, ' ')-1) as First_name,
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')-1) as Last_name
FROM accounts)t1; 


/* We would also like to create an initial password, which they will change
 after their first log in. The first password will be the first letter
 of the primary_poc's first name (lowercase), then the last letter
 of their first name (lowercase), the first letter of their last name
 (lowercase), the last letter of their last name (lowercase), the number
 of letters in their first name, the number of letters in their last name, and
 then the name of the company they are working with, all capitalized with no spaces. */ 
 
SELECT name, First_name, Last_name, replace(First_Password, ' ', '') as Passwords
FROM(SELECT name, First_name, Last_name, 
	 CONCAT(FirstLetter, LastLetter, LNameFirstLetter,
     LNameLastLetter, length(First_name), length(Last_name), 
     upper(trim(name))) as First_Password
From (Select name, First_name, Last_name, FirstLetter, 
		LastLetter, length(First_name) as FLetterNum,
	length(Last_name) as LletterNum, 
	Lower(left(Last_name, STRPOS(Last_name, ''))) as LNameFirstLetter,
    lower(right(Last_name, STRPOS(Last_name, ''))) LNameLastLetter
from(SELECT name, Lower(left(primary_poc, STRPOS(primary_poc, ' '))) First_name,
		lower(right(primary_poc, length(primary_poc) - STRPOS(primary_poc, ' '))) Last_name,
		Lower(left(primary_poc, STRPOS(primary_poc, ''))) as FirstLetter,
		right(primary_poc, STRPOS(primary_poc, '')) as LastLetter
FROM accounts)t1)t2)t3




