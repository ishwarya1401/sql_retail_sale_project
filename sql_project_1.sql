create database sql_project;

create table retail_sales(
      transactions_id int primary key,
      sale_date date,	
      sale_time time,	
      customer_id int,
      gender varchar(10),	
      age int,
      category varchar(30),
      quantiy int,
      price_per_unit float,
      cogs float,	
      total_sale float
);

select * from retail_sales;

select * from retail_sales
where age is null;

--how many sales we have?

select count(*) from retail_sales;

--how many unique customers we have?

select count(distinct customer_id) from retail_sales;

--how many unique category we have?

select count (distinct category) from retail_sales;

--data analysis & key business problem & answers

--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'. 
--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022. 
--3.Write a SQL query to calculate the total sales (total_sale) for each category. 
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. 
--5.Write a SQL query to find all transactions where the total_sale is greater than 1,000. 
--6.Write a SQL query to find the total number of transactions (order_count) made by each gender in each category. 
--7.Write a SQL query to calculate the average sale for each month and find out the best-selling month in each year. 
--8.Write a SQL query to find the top 5 customers based on the highest total sales. 
--9.Write a SQL query to find the number of unique customers who purchased items from each category. 
--10.Write a SQL query to create each shift and the number of orders (e.g., Morning < 12, Afternoon between 12 and 17, Evening > 17).


--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'. 

select * 
from retail_sales
where sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022. 

SELECT 
 * 
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--3.Write a SQL query to calculate the total sales (total_sale) for each category. 

select  
   category,
   sum(total_sale) as total_sale,
   count (*) as total_orders
from retail_Sales
group by 1;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category. 

select 
round (avg(age),2) as avg_age from retail_sales
where trim(category) = 'Beauty';

--5.Write a SQL query to find all transactions where the total_sale is greater than 1,000. 

select * from retail_sales
where total_sale > 1000;

--6.Write a SQL query to find the total number of transactions (order_count) made by each gender in each category. 
	 
select category, gender, count(*) from retail_sales
group by category, gender
order by 1;

--7.Write a SQL query to calculate the average sale for each month and find out the best-selling month in each year. 

select 
   year,
   month,
   avg_sale
from
(
select
   extract (year from sale_date) as year,
   extract (month from sale_date) as month,
   avg(total_sale) as avg_sale,
   rank() over (partition  by extract (year from sale_date) order by  avg(total_sale) desc) as rank
from retail_sales
group by 1, 2
) as t1 
where rank = 1

--8.Write a SQL query to find the top 5 customers based on the highest total sales. 

SELECT 
    customer_id, 
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category. 

SELECT 
    category, 
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1;

--10.Write a SQL query to create each shift and the number of orders (e.g., Morning < 12, Afternoon between 12 and 17, Evening > 17).

with hourly_sale
as
(
select *,
    case
	   when extract (hour from sale_time) <12 then  'morning'
       when extract (hour from sale_time) between 12 and 17 then 'afternoon'
   	   else 'evening'
	end as shift 
from retail_sales
)
select 
   shift,
   count (*) as total_orders
from hourly_sale
group by shift;


