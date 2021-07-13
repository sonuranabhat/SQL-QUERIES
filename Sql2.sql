--Display product name, customer name and discount amount where discount has been provided (discount_amt > 0) using
--Subquery
select product_name, user_name, discount_amt
from sales s, product p, customer c
where discount_amt > 0
and product_name in (
select product_name from product
where p.product_id=s.product_id
)
and user_name in (
select user_name from customer
where c.customer_id=s.customer_id
);


--JOIN
select product_name, user_name, discount_amt
from sales s
inner join product p
on p.product_id = s.product_id
inner join customer c
on c.customer_id = s.customer_id
where discount_amt > 0;

--Display product wise sum of sales amount ordered with highest sales amount on top.
select product_name,  sum(s.net_bill_amt) sales_amount from sales s
inner join product p
on s.product_id = p.product_id
group by product_name
order by sales_amount desc;

--Display brand wise sum of sales amount ordered with highest sales amount on top.
select brand, sum(s.net_bill_amt) sales_amount from sales s
inner join product p
on s.product_id = p.product_id
group by brand
order by sales_amount desc;

--Display category, brand and product wise sum of sales amount ordered with category, brand and product in ascending order.
select max(category) category, max(brand) brand, product_name, sum(s.net_bill_amt) sales_amount from sales s
inner join product p
on s.product_id = p.product_id
group by product_name
order by sales_amount asc;

--Display product_id and product name from the list of products which have not been billed yet using
--Subquery
/*JOIN
EXCEPT along with
WHERE ___ IN
JOIN*/
select product.product_id, product_name
from product
left join sales
on sales.product_id = product.product_id
except
select product.product_id, product_name
from product
right join sales
on sales.product_id=product.product_id;

--Display list of brands whose products have not been billed yet.
select distinct brand 'Brands whose products have not been billed yet'
from product
where product_id not in
(select product_id from sales);

--Display all the products’ sales quantity sorting by sales quantity. If it has no sales, show it as null.
select product.product_id, product_name, sum(qty) quantity from sales
full outer join product
on sales.product_id=product.product_id
group by product_name, product.product_id order by quantity desc;

--Display product name and customer name from the list of products which have been purchased by a single customer only.
select product.product_id, product_name, sum(qty) quantity from sales
full outer join product
on sales.product_id=product.product_id
group by product_name, product.product_id order by quantity desc;

--Display customer name and the total amount spent of the highest spending customer/s using a combination of JOIN and subquery.
select top 1 first_name, last_name, sum(net_bill_amt) total_amount_spent from sales s
join customer c
on c.customer_id=s.customer_id
group by first_name, last_name
order by sum(net_bill_amt) desc;

--Display customer name, product name whose maximum quantity is sold and that maximum quantity of each bill.
Select s.bill_no, first_name, last_name, product_name, max_quantity
From sales s
inner join customer c
on c.customer_id=s.customer_id
inner join product p
on p.product_id=s.product_id
inner join (select bill_no, max(qty) as max_quantity
From sales
Group by bill_no) b
On b.bill_no = s.bill_no
Where s.qty=b.max_quantity
order by bill_no asc;