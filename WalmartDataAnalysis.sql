SELECT * FROM salesdatawalmart.sales;

-- Checking for Duplicates in dataset 
SELECT product_line, unit_price, date,time ,COUNT(*)
FROM sales
GROUP BY product_line, unit_price, date,time 
HAVING COUNT(*) > 1

-- Dataset is clean 


-- ------------------------------------------------ feature enginering -------------------------------------------
-- Time of the day 
-- Add day_name column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- add a new colun name of the day  ,to check perfomance on weekdays


-- Month date 
select 
date , 
monthname(date)

from sales 

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
set  Month_Name =MONTHNAME(date);


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales
ORDER BY 2;

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line,branch
FROM sales
ORDER BY 2

-- What is the most common payment method?
SELECT payment, COUNT(payment) AS cnt
FROM sales 
GROUP BY payment
ORDER BY cnt DESC
LIMIT 1;




--- samme thing with subquery 
SELECT payment, cnt
FROM (
    SELECT payment, COUNT(*) AS cnt
    FROM sales
    GROUP BY payment
) AS payment_counts
ORDER BY cnt DESC
LIMIT 1;


-- Total revenue month 

SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;

-- Largest cogs 
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs desc;


-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC; 	
-- which city has the largeast rev

select City,sum(total) as TotalRevenue,branch
from sales
group by city,branch
order by TotalRevenue desc

-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
select product_line,round(avg(quantity),2)
from sales 
group by product_line

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.49 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


  -- Which branch sold more products than average product sold?
  SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity)/5000 FROM sales);

-- ---------------------------------------------------Sales--------------------------------------------------------------------------
-- Number of sales made in each time of the day 
select time_of_day,count(*)AS NUM_SALES
from sales 
WHERE day_name="friday"
Group by time_of_day
Order By NUM_SALES desc;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as Rev
from sales 
group by customer_type
Order by Rev desc


-- -----------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------Customers ---------------------------------------------------------------------------------
-- which customer type bhys the most 
select customer_type,sum(total) as Rich_Customer
from sales 
Group by customer_type
Order by Rich_Customer desc

-- another method of same thing 
select customer_type,
count(*) as cstm_cnt
from sales 
Group by customer_type
Order by cstm_cnt

-- what is the Gender Distribution of Per branch 
select gender,
count(*) as gender_cnt 
from sales 
Where branch = "B"
group by gender
Order by gender_cnt ;


-- same without manual changes 
SELECT branch, gender, COUNT(*) AS gender_cnt
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_cnt;

-- Which day of the week has the best average ratings 
select day_name,round(avg(rating),2) as AvgRate
from sales 
where branch= "C"
group by day_name
Order by AvgRate desc -- Monday has the Best average rating 


