-- create database 
create database da_project;
use da_project;

-- import table from csv using table data import wizard
-- add pk to table
ALTER TABLE product_master
ADD PRIMARY KEY(id);
-- add pk
ALTER TABLE stores
ADD PRIMARY KEY(id);
-- add pk
ALTER TABLE transaction_log_loyalty_
ADD PRIMARY KEY(id);
-- add pk
ALTER TABLE transaction_log_loyalty_lineitem_
ADD PRIMARY KEY(id);

-- retrive user_id 
select user_id FROM transaction_log_loyalty_ GROUP BY user_id ;

-- retrive user_id 
select user_id FROM transaction_log_loyalty_lineitem_ GROUP BY user_id ;

-- get total spend by user
select user_id,sum(amount - discount) AS Total_Spend FROM transaction_log_loyalty_  GROUP BY user_id

-- retrive total spend for user  
select user_id,sum(net_amount-discount)  FROM transaction_log_loyalty_lineitem_  GROUP BY user_id order by user_id;

-- calculate total amount, count bill no for user 
SELECT user_id ,sum(amount),count(bill_number)
FROM transaction_log_loyalty_
GROUP BY user_id;

-- count visit by user 
SELECT user_id,count(visit_rank)
FROM transaction_log_loyalty_
GROUP BY user_id;

-- first visit
select distinct user_id,store_name from transaction_log_loyalty_lineitem_
group by user_id 
having (select min(transaction_log_loyalty_lineitem_.bill_date) );

-- last visit
select distinct user_id,store_name from transaction_log_loyalty_lineitem_
group by user_id 
having (select max(transaction_log_loyalty_lineitem_.bill_date) );

-- bill dates
SELECT MIN(bill_date), MAX(bill_date), COUNT(*)
FROM transaction_log_loyalty_lineitem_
GROUP BY user_id ;

-- amount less than discount
select user_id ,amount,discount from transaction_log_loyalty_ where amount <= discount

-- retrive first and last transaction date
select user_id,min(txn_date),max(txn_date)
from transaction_log_loyalty_ group by user_id order by user_id;

-- retrive first and first transaction store 
select distinct user_id,store_name from transaction_log_loyalty_lineitem_
group by user_id 
having (select min(transaction_log_loyalty_lineitem_.bill_date));

-- retrive first and first transaction store 
select distinct user_id,store_name from transaction_log_loyalty_lineitem_
group by user_id 
having (select min(transaction_log_loyalty_lineitem_.bill_date));

/* retrive total quantity purchased by user */
select user_id,sum(qty)  FROM transaction_log_loyalty_lineitem_  GROUP BY user_id ;

-- retrive first and last date for userid with duplicates using common table expression
WITH CTE AS
(
	SELECT *
		, MIN(txn_date) OVER (PARTITION BY user_id) AS first_transaction_date
		, MAX(txn_date) OVER (PARTITION BY user_id) AS last_transaction_date
	FROM transaction_log_loyalty_
)
SELECT * 
FROM CTE

-- select query for given user_id
select  * from transaction_log_loyalty_lineitem_ where user_id ='0' order by bill_date asc

-- select query for given user_id using order by
select  id,user_id,store_id,bill_date from transaction_log_loyalty_lineitem_ where user_id ='837403' order by bill_date asc

-- retrive duplicate count user id
SELECT   user_id,
         COUNT( user_id) AS duplicate_cnt
FROM     transaction_log_loyalty_lineitem_
GROUP BY user_id
HAVING   COUNT(user_id) > 1
ORDER BY COUNT(user_id) DESC

-- Store wise Unique
select distinct store_id,user_id from transaction_log_loyalty_lineitem_
group by store_id,user_id 

-- retrive no of stores 
select distinct store_id from  transaction_log_loyalty_lineitem_ 

-- retrive user_id with store visits
select store_id,user_id,count(1) as visits 
from transaction_log_loyalty_lineitem_ 
group by user_id,store_id 
order by visits

-- retrive unique/distinct customers made purchases at each store.
select store_id,COUNT(distinct user_ID)
from transaction_log_loyalty_lineitem_ 
group by store_id

-- retrive user to diffn stores,bill dates and qty 
select user_id,store_id,bill_date,qty from transaction_log_loyalty_lineitem_
group by user_id
order by store_id

-- Complex query retrive data as per required output 
SELECT 
t1.user_id ,
sum(t1.amount - t1.discount ),
sum(t1.amount),
COUNT(t1.user_id),
min(t1.txn_date),
max(t1.txn_date),
(select t2.store_code order by bill_date asc limit 1),
(select t2.store_code order by bill_date desc limit 1),
(select sum(t2.qty)),
(select t2.store_name group by store_name order by count(store_name)desc) 
from transaction_log_loyalty_ as t1 
join
transaction_log_loyalty_lineitem_ as t2
on t1.user_id= t2.user_id
group by t1.user_id,t2.user_id
order by t1.user_id,t2.user_id;


-- export output result data to csv file
select 'user_id','Total_Spend','Total_Bills','Total_visits','First_transaction','Last_transaction','First_store','Last_store','total_Qty_purchase','favourite_store'
union all 
(SELECT 
t1.user_id ,
sum(t1.amount - t1.discount ),
sum(t1.amount),
COUNT(t1.user_id),
min(t1.txn_date),
max(t1.txn_date),
(select t2.store_code order by bill_date asc limit 1),
(select t2.store_code order by bill_date desc limit 1),
(select sum(t2.qty)),
(select t2.store_name group by store_name order by count(store_name)desc) 
from transaction_log_loyalty_ as t1 
join
transaction_log_loyalty_lineitem_ as t2
on t1.user_id= t2.user_id
group by t1.user_id,t2.user_id
order by t1.user_id,t2.user_id)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result1.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';
