use amazon;
SELECT * FROM `amazon capstone`;
alter table `amazon capstone`
modify `Invoice ID` VARCHAR(30),
modify `Branch` VARCHAR(5),
modify `city` VARCHAR(30),
modify `Customer type` VARCHAR(30),
modify `Gender` VARCHAR(10),
modify `Product line` VARCHAR(100),
modify `Unit price` DECIMAL(10,2),
modify `Quantity` INT,
modify `Tax 5%` FLOAT,
modify `Total` DECIMAL(10,2),
modify `Date` date,
modify `Time` TIME,
modify `Payment` varchar(20),
modify `cogs` DECIMAL(10,2),
modify `gross margin percentage` FLOAT,
modify `gross income` DECIMAL(10,2),
modify `Rating` FLOAT;


SELECT * 
FROM `amazon capstone`
WHERE `Branch` IS NULL;

ALTER TABLE `amazon capstone`
ADD COLUMN timeofday VARCHAR(20);
SET SQL_SAFE_UPDATES = 0;
-- Step 2: Update the 'timeofday' column based on the 'time' column
UPDATE `amazon capstone`
SET timeofday = 
    CASE
        WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(time) BETWEEN 12 AND 16 THEN 'Afternoon'
        ELSE 'Evening'
    END

-- Step 3: Verify the changes
SELECT `Invoice ID`, time, timeofday
FROM `amazon capstone`
LIMIT 10;

-- Step 1: Add the 'dayname' column to the table
ALTER TABLE 
ADD COLUMN dayname VARCHAR(20);

-- Step 2: Update the 'dayname' column based on the 'date' column
UPDATE `amazon capstone`
SET dayname = DAYNAME(date);

-- Step 3: Verify the changes
SELECT `Invoice ID`, date, dayname
FROM `amazon capstone`
LIMIT 10;

SELECT *
FROM `amazon capstone`
WHERE dayname IS NULL;

ALTER TABLE `amazon capstone`
ADD COLUMN monthname VARCHAR(20);

-- Step 2: Update the 'monthname' column based on the 'date' column
UPDATE `amazon capstone`
SET monthname = MONTHNAME(date);

-- Step 3: Verify the changes
SELECT `Invoice ID`, date, monthname
FROM `amazon capstone`
LIMIT 10;

-- EDA
SELECT branch, SUM(total) AS total_sales
FROM `amazon capstone`
GROUP BY branch
ORDER BY total_sales DESC;

SELECT `Product line`, SUM(total) AS total_sales
FROM `amazon capstone`
GROUP BY `Product line`
ORDER BY total_sales DESC;

SELECT `Customer type`, COUNT(*) AS purchase_frequency
FROM `amazon capstone`
GROUP BY `Customer type`
ORDER BY purchase_frequency DESC;

SELECT Payment, COUNT(*) AS payment_count
FROM `amazon capstone`
GROUP BY Payment
ORDER BY payment_count DESC;

-- Sales by time of day
SELECT timeofday, SUM(total) AS total_sales
FROM `amazon capstone`
GROUP BY timeofday
ORDER BY total_sales DESC;

-- Sales by day of the week
SELECT dayname, SUM(total) AS total_sales
FROM `amazon capstone`
GROUP BY dayname
ORDER BY total_sales DESC;

-- Sales by month
SELECT monthname, SUM(total) AS total_sales
FROM `amazon capstone`
GROUP BY monthname
ORDER BY total_sales DESC;

SELECT `Product line`, SUM(total) AS total_sales
FROM `amazon capstone`
GROUP BY `Product line`
ORDER BY total_sales DESC;

-- 1.What is the count of distinct cities in the dataset?
select  count(distinct city) from `amazon capstone`;

-- 2.For each branch, what is the corresponding city?
select city,branch from `amazon capstone`
group by branch;

-- 3.What is the count of distinct product lines in the dataset?
select count(distinct `Product line`) from `amazon capstone`;

-- 4.Which payment method occurs most frequently?
select payment,count(*) from `amazon capstone`
group by payment;

-- 5.Which product line has the highest sales?
select `Product line`,sum(total) as total_sales from `amazon capstone`
group by `Product line`
order by total_sales desc;

-- 6.How much revenue is generated each month?
select monthname,sum(total) as total_sales from `amazon capstone`
group by monthname;

-- 7.In which month did the cost of goods sold reach its peak?
select monthname, sum(cogs) as sum_cogs from `amazon capstone`
group by monthname;

-- 8.Which product line generated the highest revenue?
select `Product line`,sum(total) as total_sales from `amazon capstone`
group by `Product line`
order by total_sales desc;
 
 -- 9.In which city was the highest revenue recorded?
 select city,sum(total) as total_sales from `amazon capstone`
 group by city
 order by total_sales desc;
 
 -- 10.Which product line incurred the highest Value Added Tax?
 select `Product line`,sum(`Tax 5%`) as VAT_total from `amazon capstone`
 group by `Product line`
 order by VAT_total desc;
 
 -- 11.For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT `Product line`,SUM(total) AS total_sales,
CASE
WHEN SUM(total) > (SELECT AVG(total_sales) 
		FROM (SELECT SUM(total) AS total_sales 
				FROM `amazon capstone` 
GROUP BY `Product line`) AS avg_sales) 
        THEN 'Good'
        ELSE 'Bad'
    END AS sales_performance
FROM `amazon capstone`
GROUP BY `Product line`
ORDER BY total_sales DESC;
 
 -- 12.Identify the branch that exceeded the average number of products sold.
 select branch, sum(Quantity),avg(Quantity) from `amazon capstone`
 group by branch
 having avg(Quantity) >(select avg(Quantity) from `amazon capstone`);
 
 -- 13.Which product line is most frequently associated with each gender?
 select Gender, `Product line`, count(*) as count_productline from `amazon capstone`
 group by Gender
 order by Gender,count_productline desc;
 
 -- 14.Calculate the average rating for each product line.
select `product line`, avg(rating) as avg_rating from `amazon capstone`
group by `product line`;

-- 15.Count the sales occurrences for each time of day on every weekday.
select dayname,timeofday, count(*) as sales_occurance from `amazon capstone`
group by dayname,timeofday 
order by dayname,sales_occurance desc;

-- 16.Identify the customer type contributing the highest revenue.
select `customer type`,sum(total) as revenue from `amazon capstone`
group by `customer type`; 

-- 17.Determine the city with the highest VAT percentage.
select city, avg(`tax 5%`) as avg_VAT from `amazon capstone`
group by city
order by avg_VAT desc;

-- 18.Identify the customer type with the highest VAT payments.
select `customer type`, sum(`tax 5%`) as sum_VAT from `amazon capstone`
group by `customer type`
order by sum_VAT desc;
 
 -- 19.What is the count of distinct customer types in the dataset?
 select count(distinct `customer type`) as distinct_customertype from `amazon capstone`;
 
 -- 20.What is the count of distinct payment methods in the dataset?
 select count(distinct payment) as distinct_payment_method from `amazon capstone`;
 
 -- 21.Which customer type occurs most frequently?
 select `customer type`,count(*) as frequent_customertype from `amazon capstone`
 group by `customer type`;
 
 -- 22.Identify the customer type with the highest purchase frequency.
select `customer type`,count(*) from `amazon capstone`
 group by `customer type`;
 
 -- 23.Determine the predominant gender among customers.
 select Gender,`product line`, count(*) as predominant_gender from `amazon capstone`
 group by Gender,`product line`
 order by predominant_gender desc;
 
 -- 24.Examine the distribution of genders within each branch.
 select gender,branch ,count(*) as gender_count from `amazon capstone`
 group by branch,gender
 order by branch,gender_count desc ;
 
 -- 25.Identify the time of day when customers provide the most ratings.
 select timeofday,count(rating) as rating_count from `amazon capstone`
 group by timeofday
 order by rating_count desc;
 
 -- 26.Determine the time of day with the highest customer ratings for each branch
SELECT branch, timeofday, AVG(rating) AS avg_rating
FROM `amazon capstone`
GROUP BY branch
ORDER BY avg_rating DESC;

-- 27.Identify the day of the week with the highest average ratings.
select dayname, rating from `amazon capstone`
group by  dayname 
order by rating desc;
 
-- 28.Determine the day of the week with the highest average ratings for each branch.
SELECT branch, dayname, AVG(rating) AS avg_rating
FROM `amazon capstone`
GROUP BY branch
ORDER BY avg_rating desc;

SELECT `product line`, SUM(`gross income`) AS total_profit
FROM `amazon capstone`
GROUP BY `product line`
ORDER BY total_profit DESC;

select branch,cogs,`gross income` from `amazon capstone`
group by branch
order by cogs desc 