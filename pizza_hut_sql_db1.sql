-------pizzahut project-------------

--- create order_details table 

create table order_details
(
order_details_id int ,
order_id int ,
pizza_id varchar(300),
quantity int
);

----retrive all column from order_details table

select * from order_details


--- create orders table 

create table orders
(
order_id int,	
date date,
time time
);

----retrive all column from orders table 

select * from orders

--- create pizza_type table 

create table pizza_types
(
pizza_type_id	varchar(200),
name varchar(200),
category varchar(200),	
ingredients varchar (500)
);

----retrive all column from pizza_type table 
select * from pizza_types


--- create pizzas table 

create table pizzas
(
pizza_id varchar(100),
pizza_type_id varchar(100),
size varchar(100),
price decimal
);

----retrive all column from pizzas table 

select * from pizzas

--------------------------------------------------------------------------------------------------------------------------------------
---------------------------------Data analysis & business key problem & answer----------------------------------------------------

--My analysis & findings 


1-----Retrive the total number of order placed .

select count(order_id) as total_orders from orders

2----Calculate the total revenue generated from pizza sales 

select round(sum(order_details.quantity * pizzas.price),2) as total_revenue from order_details
join pizzas on pizzas.pizza_id= order_details.pizza_id 

3----indentify the highest-priced pizza.

select pizza_types.name,pizzas.price from pizzas
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by  pizzas.price desc 
limit 1

4----Identify the most common pizza size ordered.

select pizzas.size,count(order_details.order_details_id) as order_count from pizzas
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.size
order by order_count desc
limit 1

5---list the top  most pizza types along with thier quantities .

select pizza_types.name,sum(order_details.quantity) as total_quantity from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_quantity desc
limit 5

6---Find the total quanity of each pizza category ordered.

select pizza_types.category,sum(order_details.quantity) as quantity
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity desc 


7---Determine the distribution of orders by hour of the day 

select extract(hour from time) as hour ,count(order_id) from orders
group by hour 

8--Find the category-wise distribution os pizzas.

select category , count(name) from pizza_types
group by category 

9---group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg( quantity),2)
from 
(select orders.date , sum(order_details.quantity) as quantity from order_details
join orders on order_details.order_id = orders.order_id
group by orders.date 
) as order_quantity 

10--Determine the top 3 ordered pizza types based on revenue.

select pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue 
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc
limit 3

11---caculate the percentage contribution of each pizza type to total revenue.


select pizza_types.category, (sum(order_details.quantity * pizzas.price)/ 
(select round(sum(order_details.quantity * pizzas.price),2) as total_revenue from order_details
join pizzas on pizzas.pizza_id= order_details.pizza_id ))*100 as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc 

12---Analyze the cumulative revenue generated over time.

select date,
sum(revenue) over (order by date) as cum_revenue
from 
(select orders.date,
sum(order_details.quantity * pizzas.price) as revenue 
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id 
join  orders  on order_details.order_id = orders.order_id
group by orders.date) as sales



13--determine the top 3 most pizza type based on revenue for each pizza category.

select name, revenue
from 
(select category,name, revenue,
rank() over(partition by category order by revenue desc)
from
(select pizza_types.category,pizza_types.name,sum(order_details.quantity * pizzas.price) as revenue 
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category, pizza_types.name) as a ) as b 
where rank <= 3 
limit 3

-----------------------------------------------End of Project-------------------------------------------------

