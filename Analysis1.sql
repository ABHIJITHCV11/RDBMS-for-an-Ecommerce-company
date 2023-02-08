SET SQL_SAFE_UPDATES = 0;

-- Analysis using DDL Statements
 
-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN

CREATE TABLE shipping_mode_dimen
(
Ship_Mode VARCHAR(25),
Vehicle_Company VARCHAR(25),
Toll_Required BOOLEAN
);

-- 2. Make 'Ship_Mode' as the primary key in the above table.

ALTER TABLE shipping_mode_dimen
ADD CONSTRAINT PRIMARY KEY (Ship_Mode);

-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false

INSERT INTO shipping_mode_dimen
VALUES
('DELIVERY TRUCK', 'Ashok Leyland', false),
('REGULAR AIR', 'Air India', false);

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.

UPDATE shipping_mode_dimen
SET Toll_Required = true
WHERE Ship_Mode = 'DELIVERY TRUCK';

-- 3. Delete the entry for Air India.

DELETE 
FROM shipping_mode_dimen
WHERE Ship_Mode = 'REGULAR AIR';

-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 

ALTER TABLE shipping_mode_dimen
ADD Vehicle_Number VARCHAR(20);

-- 2. Update its value to 'MH-05-R1234'.

UPDATE shipping_mode_dimen
SET Vehicle_Number = 'MH-05-R1234';

-- 3. Delete the created column.

ALTER TABLE shipping_mode_dimen
DROP COLUMN Vehicle_Number; 

-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.

ALTER TABLE shipping_mode_dimen
CHANGE Toll_Required Toll_Amount INT;

-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.

DROP TABLE shipping_mode_dimen;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.

SELECT * 
FROM cust_dimen;

-- 2. List the names of all the customers.

SELECT DISTINCT (Customer_Name)
FROM cust_dimen;

-- 3. Print the name of all customers along with their city and state.

SELECT customer_Name,city,state
FROM cust_dimen;

-- 4. Print the total number of customers.

select count(*) as Total_Customers
from cust_dimen;

-- 5. How many customers are from West Bengal?

SELECT count(Cust_id)
from cust_dimen
WHERE State = 'West Bengal';

-- 6. Print the names of all customers who belong to West Bengal.

SELECT customer_name
FROM cust_dimen
WHERE State = 'West Bengal';

-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.

SELECT customer_name
FROM cust_dimen
WHERE Customer_Segment='CORPORATE' OR City = 'Mumbai';

-- 2. Print the names of all corporate customers from Mumbai.

SELECT customer_name
FROm cust_dimen
WHERE Customer_Segment = 'CORPORATE' AND City = 'Mumbai';

-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.

SELECT *
FROM cust_dimen
WHERE State IN ('Tamil Nadu', 'Karnataka', 'Telangana','Kerala');

-- 4. Print the details of all non-small-business customers.

SELECT *
FROM cust_dimen
WHERE Customer_Segment != 'SMALL BUSINESS';

SELECT *
FROM cust_dimen
WHERE Customer_Segment NOT IN ('SMALL BUSINESS');

-- 5. List the order ids of all those orders which caused losses.

SELECT Ord_id
FROM market_fact_full
WHERE Profit < 0;

-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.

SELECT *
FROM market_fact_full
WHERE Ord_id LIKE '%_5%' AND Shipping_cost BETWEEN 10 AND 15 ;

-- Another Method 

SELECT *
FROM market_fact_full
WHERE Ord_id LIKE '%_5%' AND shipping_cost > 10 AND shipping_cost < 15;

-- Using nested query

SELECT *
FROM market_fact_full
WHERE Ord_id LIKE '%_5%' AND shipping_cost = (SELECT Shipping_Cost 
FROM market_fact_full
WHERE Shipping_Cost = 14.30);

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.

SELECT COUNT(Sales) AS 'Total sales'
FROM market_fact_full;

-- 2. What are the total numbers of customers from each city?

SELECT COUNT(cust_id) AS "Number of customer's",City
FROM cust_dimen
GROUP BY City;

-- 3. Find the number of orders which have been sold at a loss.

SELECT COUNT(Ord_id) AS 'sold at a loss'
FROM market_fact_full
WHERE profit < 0;

-- 4. Find the total number of customers from Bihar in each segment.

SELECT COUNT(Cust_id) 'Number of customers',Customer_Segment,Customer_Name
FROM cust_dimen
WHERE STATE = 'Bihar'
GROUP BY Customer_Segment;


-- 5. Find the customers who incurred a shipping cost of more than 50.

SELECT Customer_Name
FROM cust_dimen
WHERE Cust_id = (
	SELECT Cust_id
	FROM market_fact_full
	WHERE Shipping_Cost > 50
);

-- using join
 
SELECT c.Customer_Name,m.Cust_id
FROM cust_dimen c 	
INNER JOIN market_fact_full m
ON c.Cust_id = m.Cust_id
WHERE Shipping_Cost > 50;

-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.

SELECT Customer_Name
FROM cust_dimen
ORDER BY Customer_Name ; -- acending by default

-- 2. Print the three most ordered products@.

SELECT *
FROM market_fact_full;

SELECT prod_id,sum(Order_Quantity)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY sum(Order_quantity) DESC
LIMIT 3;

-- 3. Print the three least ordered products.

SELECT prod_id,sum(Order_Quantity)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY sum(Order_quantity) ASC
LIMIT 3;

-- 4. Find the sales made by the five most profitable products.

SELECT Prod_id,SUM(Sales)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY SUM(Sales) DESC
LIMIT 5;

-- 5. Arrange the order ids in the order of their recency.


SELECT Ord_id
FROM market_fact_full
ORDER BY Market_fact_id ASC;

-- 6. Arrange all consumers from Coimbatore in alphabetical order.

SELECT customer_Name
FROM cust_dimen
ORDER BY customer_Name ASC;

-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions

-- 1. Print the customer names in proper case.

-- Extrating first_letter of the first_name and converting it to uppercase
SELECT UPPER(LEFT((SUBSTRING_INDEX(customer_Name,' ',-1)),1))
FROM cust_dimen;

-- Extracting the rest of the letters of the first_name and converting them to lowercase
SELECT LOWER(SUBSTRING(SUBSTRING_INDEX(customer_Name,' ',-1),2,LENGTH(SUBSTRING_INDEX(customer_Name,' ',-1))))
FROM cust_dimen;

-- First name in proper case 
SELECT CONCAT(UPPER(SUBSTRING(LOWER(SUBSTRING_INDEX(customer_Name,' ',1)),1,1)),SUBSTRING(LOWER(SUBSTRING_INDEX(customer_Name,' ',1)),2,LENGTH(SUBSTRING_INDEX(customer_Name,' ',1))))
FROM cust_dimen;

-- Last name in proper case 
SELECT CONCAT(UPPER(LEFT((SUBSTRING_INDEX(customer_Name,' ',-1)),1)),LOWER(SUBSTRING(SUBSTRING_INDEX(customer_Name,' ',-1),2,LENGTH(SUBSTRING_INDEX(customer_Name,' ',-1)))))
FROM cust_dimen;

-- customer names in proper case.
SELECT CONCAT(CONCAT(UPPER(SUBSTRING(LOWER(SUBSTRING_INDEX(customer_Name,' ',1)),1,1)),SUBSTRING(LOWER(SUBSTRING_INDEX(customer_Name,' ',1)),2,LENGTH(SUBSTRING_INDEX(customer_Name,' ',1))))
		,' ',
		CONCAT(UPPER(LEFT((SUBSTRING_INDEX(customer_Name,' ',-1)),1)),LOWER(SUBSTRING(SUBSTRING_INDEX(customer_Name,' ',-1),2,LENGTH(SUBSTRING_INDEX(customer_Name,' ',-1)))))) AS Name
FROM cust_dimen;

-- 2. Print the product names in the following format: Category_Subcategory.

SELECT CONCAT(Product_Category,'_',Product_Sub_Category) AS Category_Subcategory
FROM prod_dimen;

-- 3. In which month were the most orders shipped?

SELECT COUNT(Order_ID),MONTH(Ship_Date)
FROM shipping_dimen
GROUP BY MONTH(Ship_Date)
ORDER BY COUNT(Order_ID) DESC
LIMIT 1;


SELECT COUNT(Order_ID),MONTHNAME(Ship_Date) AS Month
FROM shipping_dimen
GROUP BY MONTH(Ship_Date)
ORDER BY COUNT(Order_ID) DESC
LIMIT 1;

-- 4. Which month saw the most number of critical orders?


SELECT MONTHNAME(Order_Date) AS Month,COUNT(ord_id) AS 'number of critical orders'
FROM orders_dimen
WHERE Order_Priority =  'CRITICAL'
GROUP BY Month
ORDER BY 'number of critical orders'
LIMIT 1;


-- 5. Which month and year combination saw the most number of critical orders?

SELECT MONTHNAME(Order_Date) Month, YEAR(Order_Date) AS YEAR, COUNT(ord_id) AS 'number of critical orders'
FROM orders_dimen
WHERE Order_Priority =  'CRITICAL'
GROUP BY Month,YEAR
ORDER BY 'number of critical orders'
LIMIT 1;


-- 6. Find the most commonly used mode of shipment in 2011.

SELECT Ship_Mode
FROM shipping_dimen
WHERE YEAR(Ship_Date) = '2011'
GROUP BY Ship_Mode
ORDER BY COUNT(Ship_id) DESC
LIMIT 1;

SELECT Ship_Mode, COUNT(Ship_id)
FROM shipping_dimen
WHERE YEAR(Ship_Date) = '2011'
GROUP BY Ship_Mode
ORDER BY COUNT(Ship_id) DESC;

-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.

SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Name LIKE '%car%';


-- 2. Print customer names starting with A, B, C or D and ending with 'er'.

SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Name regexp '^[ABCD].*er';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.

SELECT Order_Number
FROM orders_dimen
WHERE Ord_id = (
	SELECT Ord_id
	FROM market_fact_full
	ORDER BY sales DESC
	LIMIT 1
);

-- using join.

SELECT o.Order_Number
FROM orders_dimen o INNER JOIN market_fact_full m
	ON o.Ord_id = m.Ord_id
ORDER BY Sales DESC
LIMIT 1;    
    

-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.


SELECT Product_Category,Product_Sub_Category
FROM prod_dimen
WHERE Prod_id NOT IN (
	SELECT Ord_id
    FROM Market_fact_full
    WHERE Product_Base_Margin IS NOT NULL
);

-- 3. Print the name of the most frequent customer.

SELECT Customer_Name
FROM cust_dimen
WHERE cust_id = (
	SELECT cust_id
    FROM market_fact_full
    GROUP BY (cust_id)
    ORDER BY count(cust_id) DESC
    LIMIT 1
);

-- 4. Print the three most common product_id.

SELECT prod_id
FROM market_fact_full
GROUP BY prod_id
ORDER BY count(Prod_id) DESC
LIMIT 3;

-- 5. Most ordered product category

SELECT Product_Category
FROM prod_dimen
WHERE Prod_id = (
	SELECT prod_id
	FROM market_fact_full
	GROUP BY prod_id
	ORDER BY count(Prod_id) DESC
	LIMIT 1
	);
    
-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?

WITH least_losses AS (
	SELECT *
	FROM market_fact_full
	WHERE Profit < 0
	ORDER BY Profit DESC
	LIMIT 5
)
SELECT * 
FROM least_losses
WHERE Product_Base_Margin = (
	SELECT max(Product_Base_Margin)
    FROM least_losses
);

-- Another Approach    

WITH least_losses AS (
	SELECT *
	FROM market_fact_full
	WHERE Profit < 0
	ORDER BY Profit DESC
	LIMIT 5
)
SELECT * 
FROM least_losses
ORDER BY Product_Base_Margin DESC
LIMIT 1;

-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?

-- naive approach

SELECT *
FROM orders_dimen
WHERE month(Order_Date) = 4 AND month(Order_Date) BETWEEN 1 AND 15;

-- CTE approach

WITH low_priority_orders_in_april  AS( 
	SELECT *
	FROM orders_dimen
	WHERE month(Order_Date) = 4
    )
    SELECT *
    FROM low_priority_orders_in_april
    WHERE month(Order_Date) BETWEEN 1 AND 15;


-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.

CREATE VIEW order_info AS
SELECT Sales, Order_Quantity, Profit, Shipping_Cost
FROM market_fact_full;

SELECT *
FROM order_info
WHERE Profit > 1000;

-- 2. Which year generated the highest profit?

CREATE VIEW order_info_and_year
AS SELECT *
FROM Market_fact_full INNER JOIN orders_dimen 
using (Ord_id);


SELECT SUM(profit),year(Order_Date)
FROM order_info_and_year
GROUP BY year(Order_Date);
-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.

SELECT m.Ord_id, p.Product_Category,p.Product_Sub_Category, m.profit
FROM market_fact_full m INNER JOIN prod_dimen p
ON m.Prod_id = p.Prod_id;

-- 2. Find the shipment date, mode and profit made for every single order.
SELECT s.Ship_Date, s.Ship_Mode, m.Profit
FROM shipping_dimen s INNER JOIN market_fact_full m
ON s.Ship_id = m.Ship_id;

-- 3. Print the shipment mode, profit made and product category for each product.
-- We have to a three way join to solve this

SELECT s.Ship_Mode, m.Profit, p.Product_Category
FROM shipping_dimen s INNER JOIN market_fact_full m
ON s.Ship_id = m.Ship_id
INNER JOIN prod_dimen p
ON m.Prod_id = p.Prod_id;

 -- 4. Which customer ordered the most number of products?
-- Join the necessery tables and use group operation

SELECT m.Cust_id,c.Customer_Name, count(m.Cust_id)
FROM market_fact_full m INNER JOIN cust_dimen c
ON m.Cust_id = c.Cust_id
GROUP BY m.Cust_id
ORDER by count(m.Cust_id) DESC;

-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?

SELECT *
FROM cust_dimen
GROUP BY City;

SELECT c.City, sum(m.Profit) ,p.Product_Category 
FROM market_fact_full m
	INNER JOIN prod_dimen p
	ON m.Prod_id = p.Prod_id
		INNER JOIN cust_dimen c
        ON m.Cust_id = c.Cust_id
WHERE p.Product_Category = 'OFFICE SUPPLIES'  
GROUP BY c.City
ORDER BY sum(m.Profit) DESC;


-- 6. Print the name of the customer with the maximum number of orders.

SELECT Customer_Name,m.Cust_id, sum(Order_Quantity)
FROM cust_dimen c
INNER JOIN market_fact_full m
USING (Cust_id)
GROUP BY Cust_id
ORDER BY sum(Order_Quantity) DESC
LIMIT 1;

-- 7. Print the three most common products.

SELECT m.prod_id, sum(Order_Quantity)
FROM market_fact_full m
INNER JOIN prod_dimen p
ON m.prod_id = p.prod_id
GROUP BY prod_id
ORDER BY Order_Quantity DESC ;


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.

-- Using inner join

SELECT m.Manu_Id, Manu_Name, Product_Category, Product_Sub_Category
FROM manu m INNER JOIN prod_dimen p 
ON m.Manu_Id = p.Manu_Id;

-- Using LEFT/RIGHT joins (as MySQL does not support FULL JOIN)

SELECT m.Manu_Id, Manu_Name, Product_Category, Product_Sub_Category
FROM manu m  LEFT JOIN prod_dimen p 
ON m.Manu_Id = p.Manu_Id;

SELECT m.Manu_Id, Manu_Name, Product_Category, Product_Sub_Category
FROM manu m  RIGHT JOIN prod_dimen p 
ON m.Manu_Id = p.Manu_Id;


-- 3. Display the number of products sold by each manufacturer.

SELECT m.Manu_Id, count(Prod_id)
FROM manu m LEFT JOIN prod_dimen p 
ON m.Manu_Id = p.Manu_Id
GROUP BY m.Manu_Id;

-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.

CREATE VIEW Cust_info_view
AS SELECT Ord_id,Customer_Name,Customer_segment,Sales,Product_Category,Product_Sub_Category,Order_Quantity
FROM cust_dimen c INNER JOIN market_fact_full m
ON c.Cust_id = m.Cust_id
INNER JOIN prod_dimen p 
ON m.Prod_id = p.Prod_id; 

SELECT Customer_Name,Customer_segment,Product_Sub_Category,Order_Quantity
FROM Cust_info_view
WHERE Product_Sub_Category = 'PENS & ART SUPPLIES' AND Order_Quantity > 20;


-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.

-- 3. Find the shipment details of products with no information on the product base margin.

-- 4. What are the two most and the two least profitable products?


-- -----------------------------------------------------------------------------------------------------------------
-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.

-- 3. Rank the customers in the decreasing order of the number of orders placed.

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 


-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.


-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.


-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table


-- Execute the below queries before solving the next question.
create table manu(
    Manu_Id int primary key,
    Manu_name varchar(30),
    Manu_city varchar(30),
);

insert into manu values
(1,'Navneet','Ahemdabad'),
(2,'Wipro','Hyderabad'),
(3,'Furlanco','Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins


-- 3. Display the number of products sold by each manufacturer