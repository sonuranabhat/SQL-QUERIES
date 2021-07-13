
--Select all products with brand “Cacti Plus”
select * from dbo.product where brand ='Cacti Plus'

--Count of total products with product category=”Skin Care”
select count(*) from dbo.product where category ='Skin Care'

-- Count of total products with MRP more than 100
select count(*) from dbo.product where mrp > 100

-- Count of total products with product category ="Skin Care" and MRP more than 100
select count(*) from dbo.product where category ='Skin Care' and  mrp > 100

-- Brandwise product count
SELECT product.brand,
Count (product.product_id)
FROM   dbo.product
GROUP  BY brand

--Brandwise as well as Active/Inactive Status wise product count
SELECT product.brand,
       Sum(CASE
             WHEN active = 'Y' THEN 1
             ELSE 0
           END) AS active,
       Sum(CASE
             WHEN active = 'N' THEN 1
             ELSE 0
           END) AS inactive,
       Count(*) AS totals
FROM   product
GROUP  BY brand

--Display all columns with Product category in Skin Care or Hair Care
SELECT *
FROM   product
WHERE  category = 'Skin Care'
        OR category = 'Hair Care'

--Display all columns with Product category in Skin Care or Hair Care, and MRP more than 100
SELECT *
FROM   product
WHERE  mrp > 100
       AND ( category = 'Skin Care'
        OR category = 'Hair Care' );

--Display   all   columns   with   Product   category   ="Skin   Care"   or Brand="Pondy", and MRP more than 100
SELECT *
FROM   product
WHERE  mrp > 100
       AND ( category = 'Skin Care'
              AND brand = 'Pondy' );

--Display   all   columns   with   Product   category   =”Skin   Care”   or Brand=”Pondy”, and more than 100
SELECT *
FROM   product
WHERE  mrp > 100
       AND ( category = 'Skin Care'
              OR brand = 'Pondy' );

--Display all product names only with names starting from letter P
SELECT *
FROM   product
WHERE  product_name LIKE 'P%'

--Display  all product  names only with names Having letters "Bar"  in Between
SELECT *
FROM   product
WHERE  product_name LIKE '%Bar%'

--Sales of those products which have been sold in more than two quantity in a bill
SELECT *
FROM   sales
WHERE  qty > 2

--Sales of those products which have been sold in more than two quantity throughout the bill
SELECT product_id,
       Sum(qty) quantity
FROM   dbo.sales
GROUP  BY product_id
HAVING Sum(qty) > 2

/*Create a new table with columns username and birthday, and dump data from dates file. Convert it to .csv format if required.
Research on Date Function Queries from the slide
After populating the data, find no of people sharing
Birth date
Birth month
Weekday
Find the current age of all people
*/

CREATE TABLE employee
  (
    username varchar(30),
    birthday date);
    
BULK INSERT dbo.employee
FROM 'dates.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  ROWTERMINATOR ='\n'
)

-- Research on Date Function Queries from the slide
-- After populating the data, find no of people sharing

--Birth date(full date)

select distinct *
from (
   select birthdate, count(*) over (partition by birthdate) as People
   from dates
) same
where same.People > 1;
--no of people sharing Birth month
select count(*) as Total, datename(month, birthdate) as MonthName
from dates
group by datename(month, birthdate);
--no of people sharing Weekday
select count(*) as Total, datename(weekday, datepart(weekday, birthdate)) as Weekday
from dates
group by datepart(weekday, birthdate);
--Find the current age of all people
select *, datediff(year, birthdate, getdate()) age from dates;
