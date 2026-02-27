

--> revenue, rentals and active customers
select sum(m.renting_price) as total_Revenue, 
count(*) as Total_Rentals,
count(distinct(m.movie_id)) as Number_of_Movies ,
count(distinct(r.customer_id)) as Active_Customers 
from renting r 
inner join movies m
on r.movie_id = m.movie_id


--->New_Customers_Count per year
select year(c.date_account_start) as Joining_year,
count(c.customer_id) as New_customers_count
from customers c
group by year(c.date_account_start)
order by Joining_year

--->KPIs per country
select c.country , count(*) as number_of_rental,
avg(r.rating) as avg_rating,
sum(m.renting_price) as revenue
from renting r
join customers c
on c.customer_id = r.customer_id
join movies m
on m.movie_id = r.movie_id
group by c.country
order by revenue desc

-->Income from movies (top movies)
select rm.title , sum(rm.renting_price)
as total_income from 
	(select m.title , m.renting_price
		from movies m
		inner join renting r
		on r.movie_id = m.movie_id) as rm 
group by rm.title
order by total_income desc


----> avg for each genre
select  m.genre , avg(m.renting_price) as Avg_Price ,
count(r.renting_id) as Total_Rentals , 
sum(m.renting_price) as Total_Revenue 
from movies m
join renting r
on r.movie_id = m.movie_id
group by m.genre
order by total_revenue desc


---> Identify favorite movies for a group of customers
select m.title , count(*) as number_of_rental ,
avg(r.rating) as avg_rating 
from renting r
join customers c
on c.customer_id = r.customer_id 
join movies m
on r.movie_id = m.movie_id
group by m.title
having avg(r.rating) is not null
order by avg_rating desc


--->Runtime Impact
select case when m.runtime <= 90 then 'Short Movies (<90 min)'
            when m.runtime between 91 and 120 then 'Medium Movies (90:120 Min)'
            else 'Long Movies (>120 Min)'
            end as Movie_Duration_Category,
    count(r.renting_id) as total_rentals,
    avg(r.rating) as avg_rating
from movies m
join renting r
on r.movie_id = m.movie_id
group by case when m.runtime <= 90 then 'Short Movies (<90 min)'
            when m.runtime between 91 and 120 then 'Medium Movies (90:120 Min)'
            else 'Long Movies (>120 Min)'
            end 
order by total_rentals desc

-->top 10 customer
select top 10 r.customer_id, c.name, c.country , 
avg(rating) as avg_rating , 
count(movie_id) as number_renting , 
count(rating) as number_rating 
from renting r inner join customers c
on r.customer_id = c.customer_id 
group by r.customer_id , c.name , c.country
having avg(rating) is not null
order by number_renting desc

--->Most Popular Actors
select a.name as actor_name,
count(r.renting_id) as number_of_rentals,
avg(r.rating) as Avg_actor_rating
from actors a
join actsin ai
on ai.actor_id = a.actor_id
join renting r
on ai.movie_id = r.movie_id 
group by a.name
order by number_of_rentals desc


-->Conduct an analysis to see when the first customer accounts were created for each country.
select c.country , min(c.date_account_start) as first_account,
DATEDIFF(MONTH, min(c.date_account_start), max(r.date_renting)) AS number_of_month 
from customers c
join renting r
on r.customer_id = c.customer_id
group by country
order by first_account asc


-->Count the number of customers in countries .
select country , count(country) as number_of_customers from customers
group by country
order by count(country) desc


--->Monthly Revenue
select year(r.date_renting)as year ,
format(r.date_renting, 'MMMM')as Month ,
count (r.renting_id) as number_of_rentals,
sum(m.renting_price) as Monthly_Revenue
from renting r join movies m
on m.movie_id = r.movie_id
group by year(r.date_renting) , format(r.date_renting, 'MMMM')
order by year desc , Monthly_Revenue DESC


































