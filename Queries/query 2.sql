-- import result1 to database 
-- retrive  total visit and  total user/customers 
select distinct Total_visits,
count( user_id) As Customer 
from result1  group by Total_visits order by Total_visits;
 
 -- alternative
 --  create table for insert on call of sp_droprate1
 create table drop_rate(
 total_visit int,
 customer int);

-- procedure to get total customer and  
DELIMITER $$
CREATE PROCEDURE sp_droprate1()
BEGIN
	DECLARE a  INT;
	SET a = 1;
	
	loop_label:  LOOP
		IF  a > 9 THEN 
			LEAVE  loop_label;
		END  IF;
         
        insert into drop_rate
        ((select Total_Visits,count(user_id) from result1 where Total_Visits = a)); 
		SET  a = a + 1;
	END LOOP;
    insert into drop_rate
        ((select 10 ,count(user_id) from result1 where Total_Visits > 9));
END$$

DELIMITER ;

-- check table 
select * from drop_rate;

-- call procedure
CALL sp_droprate1;

-- check after procedure call
select * from drop_rate;

-- retrive  total visit and customers and cumulative using drop_rate table
select distinct Total_visit ,
customer, sum(customer) over (order by Total_Visit desc) as cumulative
from drop_rate group by total_visit order by total_visit ;


-- retrive data as per required output and export to csv  
select 'Total_visits','Customer','Cumulative'
union all 
(select distinct Total_visit ,
customer, sum(customer) over (order by Total_Visit desc)
from drop_rate group by total_visit order by total_visit ) 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result2a.csv'   
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n';

-- drop procedure 
Drop Procedure sp_droprate1;

-- drop table 
Drop table drop_rate;
