-- Retrieve Data as per output  Category Penetration
select distinct t1.category, count( t2.bill_number) ,count(distinct t2.user_id ) ,round(sum(t2.amount)),count(t3.qty)
from product_master t1 join transaction_log_loyalty_ t2 
on t1.id=t2.store_id
join transaction_log_loyalty_lineitem_ t3
on  t2.user_id=t3.user_id
group by category;

-- Retrieve Data required output and export output to csv 
select 'Category','Bills','Customers','Sales','Qty_Sold'
union all
(
select distinct t1.category, count( t2.bill_number) ,count(distinct t2.user_id ) ,sum(t2.amount),count(t3.qty)
from product_master t1 join transaction_log_loyalty_ t2 
on t1.id=t2.store_id
join transaction_log_loyalty_lineitem_ t3
on  t2.user_id=t3.user_id
group by category
)
into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result4.csv'
fields terminated by ','
enclosed by '"'
lines terminated by '\n';