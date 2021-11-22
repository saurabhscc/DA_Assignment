-- procedure to get total customer and visits using temporary table with loop inside query 
DELIMITER $$
CREATE PROCEDURE sp_droprate2()
BEGIN
	DECLARE a  INT;
	SET a = 1;
	drop table if exists tempdroprate;
	CREATE TEMPORARY TABLE tempdroprate (total_visits varchar(10),customer INT);	
	loop_label:  LOOP
		IF  a > 9 THEN 
			LEAVE  loop_label;
		END  IF;
        insert into tempdroprate
        ((select Total_Visits,count(user_id) from result1 where Total_Visits = a)); 
		SET  a = a + 1;
	    END LOOP;
		insert into tempdroprate
        ((select 10 ,count(user_id) from result1 where Total_Visits > 9));
        select 'Total_visits','Customer'
		union all
        select * INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result2b.csv' 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n'
from tempdroprate;
END$$

DELIMITER ;

-- call procedure
CALL sp_droprate2;

-- check table 
select * from tempdroprate;

-- drop temporary table
Drop Temporary Table tempdroprate;

-- drop procedure 
Drop procedure sp_droprate2;
