use sakila;

# 1a.
Select first_name, last_name
from actor
;

#1b.
Select upper(concat(first_name,' ',last_name)) as 'Actor Name'
from actor
;

#2a.
Select actor_id, first_name, last_name
from actor
where first_name = "Joe"
;

#2b.
Select first_name, last_name
from actor
where last_name like "%GEN%"
;

#2c.
Select last_name, first_name
from actor
where last_name like "%LI%"
;

#2d.
Select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China')
;

#3a.
Alter table actor
add column description blob
;

#3b.
Alter table actor
drop column description
;

#4a.
Select last_name, count(last_name)
from actor
group by last_name
;

#4b.
Select last_name, count(last_name)
from actor
group by last_name
having count(last_name) > 1
;

#4c.
Update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO'and last_name = 'Williams'
;

#4d.
SET SQL_SAFE_UPDATES = 0;

Update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO'
;

#5a.
SHOW CREATE TABLE address
;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8
;

#6a.
Select first_name, last_name, address
From staff
Join address on staff.address_id = address.address_id
;

#6b.
Select first_name, last_name, SUM(amount)
From payment
Join staff on payment.staff_id = staff.staff_id
Where payment_date like "2005-08%"
Group by payment.staff_id
;

#6c.
Select title, Count(actor_id) as "Number of Actors"
From film
Inner join film_actor on film.film_id = film_actor.film_id
Group by film.film_id
;

#6d.
Select title, Count(inventory_id) as "Number of Copies"
From film
Inner join inventory on film.film_id = inventory.film_id
Where title = 'Hunchback Impossible'
;

#6e.
Select first_name, last_name, SUM(amount) as "Total Amount Paid"
From customer
Join payment on customer.customer_id = payment.customer_id
Group by customer.customer_id
Order by last_name asc
;

#7a.
Select title
From film
where language_id in (
	Select language_id
	From language
    where name = "English"
    )
and title like "K%" or "Q%"
;

#7b.
Select first_name, last_name
From actor
Where actor_id in (
	Select actor_id
	From film_actor
    Where film_id in (
		Select film_id
        From film
        Where title = "Alone Trip"
        )
	)
;

#7c.
Select first_name, last_name, email
from customer
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
Where country = "Canada"
;

#7d.
Select title
From film
Where film_id in (
	Select film_id
    From film_category
    Where category_id in(
		Select category_id
        From category
        Where name = "Family"
        )
	)
;

#7e.
Select title, Count(rental_id) as "# of Times Rented"
From film
Join inventory on film.film_id = inventory.film_id
Join rental on inventory.inventory_id = rental.inventory_id
Group By film.film_id
Order by Count(rental_id) desc
;

#7f.
Select store.store_id, Sum(amount) as "Gross Sales"
From store
Join staff on store.store_id = staff.store_id
Join payment on staff.staff_id = payment.staff_id
Group by store.store_id
;

#7g.
Select store_id, city, country
From store
Join address on store.address_id = address.address_id
Join city on address.city_id = city.city_id
Join country  on city.country_id = country.country_id
Group By store.store_id
;

#7h.
Select name, Sum(amount) as "Gross Revenue"
From category
Join film_category on category.category_id = film_category.category_id
Join inventory on film_category.film_id = inventory.film_id
Join rental on inventory.inventory_id = rental.inventory_id
Join payment on rental.rental_id = payment.rental_id
Group by category.category_id
Order by Sum(amount) desc
Limit 5
;

#8a.
Create view top_five_genres as
Select name, Sum(amount) as "Gross Revenue"
From category
Join film_category on category.category_id = film_category.category_id
Join inventory on film_category.film_id = inventory.film_id
Join rental on inventory.inventory_id = rental.inventory_id
Join payment on rental.rental_id = payment.rental_id
Group by category.category_id
Order by Sum(amount) desc
Limit 5
;

#8b.
Select *
From top_five_genres
;

#8c.
Drop view top_five_genres
;
