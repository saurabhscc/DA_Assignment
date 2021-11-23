-- brand_lapsation table stored procedure 

DELIMITER $$
CREATE PROCEDURE sp_brand_lapsation()
BEGIN
	DECLARE inc, days INT;
	SET inc = 1;
	SET days = 0;
    
    create temporary table temp_brand_lapsation(
	days_since_last_visit varchar(10),
	no_of_bills int,
	bill_percentage float default 0.0
	);
	loop_label :  LOOP
		IF  inc > 12 THEN 
			LEAVE  loop_label;
		END  IF;
        
        insert into temp_brand_lapsation (days_since_last_visit,no_of_bills,bill_percentage)
        (select CONCAT('<',days+30), count( distinct bill_number),
        (count( distinct bill_number)*100/(select count( distinct bill_number) from transaction_log_loyalty_ ))
        from transaction_log_loyalty_ 
        where days_since_last_visit BETWEEN 0 AND (days + 30)); 
        
		SET  inc = inc + 1;
        set days= days + 30;
        
	    END LOOP;
    select * from temp_brand_lapsation;
END$$

DELIMITER ;

-- check table 
select * from temp_brand_lapsation;

-- call procedure
call sp_brand_lapsation();

-- Export output to csv 
select 'Days_Since_Last_Visit',	'No_of_Bills','%ofBills'
union all
select * from temp_brand_lapsation
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result3.csv' 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n';

-- drop temporary table
Drop Temporary Table temp_brand_lapsation;

-- drop procedure 
Drop procedure sp_brand_lapsation;
