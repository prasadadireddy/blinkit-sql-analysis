create database blinkit;

use blinkit;

select name from sys.tables;

select * from blinkit;

exec  sp_rename 'blinkit.item_outlet_Sales','sales','column';


-- Check for inconsistent fat content labels
SELECT DISTINCT Item_Fat_Content FROM blinkit;


-- Standardise: 'LF' and 'low fat' → 'Low Fat', 'reg' → 'Regular'
UPDATE blinkit SET Item_Fat_Content = 'Low Fat'
WHERE Item_Fat_Content IN ('LF', 'low fat');

UPDATE blinkit SET Item_Fat_Content = 'Regular'
WHERE Item_Fat_Content = 'reg';


update blinkit set outlet_size = 'regular'
where outlet_size is null; 


-- KPI 1: Total Sales Revenue
SELECT ROUND(SUM(sales), 2) AS total_sales
FROM blinkit;

-- KPI 2: Average Sales per item
select ROUND(avg(sales),2) as avg_sales
from blinkit;


-- KPI 3: Total number of items
select count(*)  as total_items
from blinkit;


-- Q1: Sales by Fat Content — do customers prefer Low Fat?
SELECT Item_Fat_Content,
       ROUND(SUM(Sales), 2) AS total_sales,
       COUNT(*) AS item_count
FROM blinkit
GROUP BY Item_Fat_Content;


-- Q2: Which item types generate the most revenue?
select item_type,
round(sum(sales),2) as total_sales,
count(*) as item_count
from blinkit
group by item_type
order by total_sales desc;

-- Q3: Sales performance by outlet size
select outlet_size,
round(sum(sales),2) as total_sales,
count(*) as outlet_count,
ROUND(AVG(Sales), 2) AS avg_sales_per_item
from blinkit
group by outlet_size
order by total_sales desc;


-- Q4: Which location tier performs best?
select Outlet_Location_Type,
round(sum(sales),2) as total_sales,
count(*) as outlet_location_count
from blinkit
group by Outlet_Location_Type
order by total_sales desc;


-- Q5: Sales by outlet type
select outlet_type,
ROUND(sum(sales),2) as total_sales,
count(*) as outlet_count,
round(avg(sales),2) as avg_sales
from blinkit
group by outlet_type
order by total_sales desc;

-- Q6: Best performing outlet type + location combo
SELECT top 10  Outlet_Type, Outlet_Location_Type,
ROUND(SUM(Sales), 2) AS total_sales
FROM blinkit
GROUP BY Outlet_Type, Outlet_Location_Type
ORDER BY total_sales DESC;







