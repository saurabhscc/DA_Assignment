-- procedure to get total customer and visits using temporary table with loop inside query

DELIMITER $$
CREATE PROCEDURE sp_droprate3()
BEGIN
	DECLARE x  INT;
	SET x = 1;
CREATE TEMPORARY TABLE  temp_drop_rate(
Total_visits varchar(30), 
Customer int
);	
	loop_label:  LOOP
		IF  x > 9 THEN 
			LEAVE  loop_label;
		END  IF;
         
        insert into temp_drop_rate
        ((select x,(select count(SUBQUERY.user_id)
from
(select distinct user_id,sum(visit_rank) as Total_visits    
FROM transaction_log_loyalty_
GROUP BY user_id)as SUBQUERY
where total_visits = x
))); 
		SET  x = x + 1;
	END LOOP;

insert into  temp_drop_rate
((select '9+' ,(select count(SUBQUERY.user_id)
from
(select distinct user_id,sum(visit_rank) as Total_visits
FROM transaction_log_loyalty_
GROUP BY user_id)as SUBQUERY
where total_visits > 9
)));
select 'Total_visits','Customer'
union all
select * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/2c.csv' 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n'
from tempdroprate;
END$$

DELIMITER ;

-- call procedure
call sp_droprate3;

-- check table 
select * from temp_drop_rate;

-- drop temporary table
Drop Temporary Table temp_drop_rate;

-- drop procedure 
Drop procedure sp_droprate3;