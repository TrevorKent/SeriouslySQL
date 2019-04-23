use sakila;
set sql_safe_updates=0;

-- Questions 1A-1B
-- 1a. & 1b Display names and combine into new column
select actor_id, first_name, last_name, last_update, concat(first_name, " ", last_name) as "Actor Name"
from actor;

-- Questions 2A-2D
-- 2a. Find "Joe": --
select actor_id, first_name, last_name, last_update, concat(first_name, " ", last_name) as "Actor Name"
from actor where first_name in ("Joe");

-- 2b. Find actors with "Gen": --
select actor_id, first_name, last_name, last_update, concat(first_name, " ", last_name) as "Actor Name"
from actor where last_name like ('%gen%');

-- 2c. Find actors with "li":--
select actor_id, first_name, last_name, last_update, concat(first_name, " ", last_name) as "Actor Name"
from actor where last_name like ('%li%') order by last_name, first_name;

-- 2d. Find countries: --
select country_id, country
from country where country in ("Afghanistan", "Bangladesh", "China");

-- Questions 3A-3B
alter table actor 
add column description blob not null;

alter table actor
drop column description;

-- Questions 4A-4D
select last_name, count(last_name) as "Count of Actors"
from actor
group by last_name;

select last_name, count(last_name) as "Count of Actors"
from actor
group by last_name
having count(last_name) > 1;

update actor
set first_name = "Harpo"
where actor_id = 172;
select * from actor order by last_name;

update actor
set first_name = "GROUCHO"
where actor_id = 172;
select * from actor order by last_name;

-- Questions 5A
describe address;

create table address_new (
	address_id int(5) auto_increment not null,
    address varchar(50) not null,
    address2 varchar (50),
    district varchar (20) not null,
    city_id int(5) not null,
    postal_code varchar(10),
    phone varchar (20) not null,
    location varchar (20) not null,
    last_update timestamp
);

-- Questions 6A-6E --
Select first_name from staff;

-- 6a. Staff members info:--
select staff.first_name, staff.last_name, address.address
from staff
left join address
on (staff.address_id = address.address_id);

-- 6b. Staff results August: --
select s.first_name, s.last_name, sum(p.amount) as "Total Amount for May-05"
from staff s
join payment p 
on (s.staff_id = p.staff_id)
where p.payment_date like '2005-05%'
group by s.staff_id;

-- 6c. Number of actors by film: --
select f.title as "Movie\nName", count(fa.film_id) as "Count of Actors"
from film f
inner join film_actor fa
on (f.film_id = fa.film_id)
group by f.title;

-- 6d. Number copies of Hunchback Impossible --
select f.title as "Movie\nName", count(i.inventory_id) as "Count of Films"
from film f
join inventory i
on (f.film_id = i.film_id)
where f.title = "Hunchback Impossible"
group by f.title;

-- 6e. Total paid each customer -- 
select c.first_name, c.last_name, sum(p.amount) as "Total Paid"
from customer c
join payment p
on (c.customer_id = p.customer_id)
group by c.customer_id
order by c.last_name, c.first_name;

-- Questions 7A-7H
select * from language;

-- 7a. Movies starting with the letter K or Q: --
select f.title as "Movie Names"
from film f
where f.title like 'K%' or f.title like 'Q%' 
and f.language_id in (
	select l.language_id
    from language l 
    where l.name = 'English');
    
-- 7b. Actors in 'Alone Trip' movie:
select actor.first_name, actor.last_name
from actor
where actor.actor_id 
in (
	select film_actor.actor_id
    from film_actor 
    where film_actor.film_id 
    in (
		select film.film_id 
        from film
        where film.title = "ALONE TRIP"
        )
	);

-- 7c. Canada email cmapaign: --
select c.first_name, c.last_name, a.address, city.city, country.country
from customer c
join address a 
on (c.address_id = a.address_id)
join city
on(a.city_id = city.city_id)
join country
on(city.country_id = country.country_id)
where country.country = "Canada";

-- 7d. Identify all family movies: --
select film.title, category.name
from film
join film_category
on (film.film_id = film_category.film_id)
join category
on (film_category.category_id = category.category_id)
where category.name = "Family";

-- 7e. Most frequently rented movies: --
select f.title, count(p.rental_id) as "Rentals"
from film f
join inventory i 
on (f.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join customer c
on (r.customer_id = c.customer_id)
join payment p
on (c.customer_id = p.customer_id)
group by f.title order by count(p.rental_id) desc;
 
-- 7g. Display store information: --
select s.store_id, city.city, c. country
from store s
join address a
on (s.address_id = a.address_id)
join city
on (a.city_id = city.city_id)
join country c 
on (city.country_id = c.country_id);

-- 7h. Top 5 genres based on gross revenue: --
select c.name as "Genres", sum(p.amount) as "Gross Revenue"
from category c
join film_category fc
on (c.category_id = fc.category_id)
join inventory i
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p
on (r.customer_id = p.customer_id)
group by c.name order by sum(p.amount) desc;

-- Questions 8A-8C
-- 8a. Create View
create view top_five_genres as
select c.name as "Genres", sum(p.amount) as "Gross Revenue"
from category c
join film_category fc
on (c.category_id = fc.category_id)
join inventory i
on (fc.film_id = i.film_id)
join rental r
on (i.inventory_id = r.inventory_id)
join payment p
on (r.customer_id = p.customer_id)
group by c.name order by sum(p.amount) desc;

-- 8b. Display view:--
Select * from top_five_genres;

-- 8c. Drop view:--
drop view top_five_genres;

-- End --



