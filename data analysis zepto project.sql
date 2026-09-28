drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(120),
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);
-- count of rows
select *
from zepto;
--sample data
select count(*)
from zepto;

--null value

select * from zepto
where name is null
or
category is null
or
discountpercent is null
or
discountedsellingprice is null
or
weightInGms is null
or
availablequantity is null
or
outOfStock is null
or
quantity is null;

--different product categories

select distinct category
from zepto
order by category;

-- product in stock vs out of stock
select outofstock, count(sku_id)
from zepto
group by outofstock;

--product names present multiple times
select name,  count(sku_id) as "Number of SkUs"
from zepto
group by name
having  count(sku_id) >1
order by count(sku_id) DESC;

-- data cleaning
-- products with price=0
select *
from zepto
where mrp=0 or discountedSellingPrice=0;

delete from zepto
where mrp=0;

-- convert paise to rupees
update zepto
set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice /100.0;

select mrp,discountedSellingPrice from zepto

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name,mrp,discountPercent
from zepto
order by discountPercent desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock

select distinct name,mrp
from zepto
where outofStock=TRUE and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category, sum(discountedsellingprice* availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;