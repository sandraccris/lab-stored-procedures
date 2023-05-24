-- Write queries, stored procedures to answer the following questions:

-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. 
-- Convert the query into a simple stored procedure. 
USE SAKILA;

DELIMITER //
create procedure custom_details_action()
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end //
DELIMITER ;

call custom_details_action();

-- 2. Now keep working on the previous stored procedure to make it more dynamic. 
-- Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. For eg., it could be action, animation, children, classics, etc.

DELIMITER //
create procedure custom_details_categories_proc(in param1 varchar(20))
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = param1
  group by first_name, last_name, email;
end //
DELIMITER ;

call custom_details_categories_proc("Animation");
call custom_details_categories_proc("Children");
call custom_details_categories_proc("Classics");
call custom_details_categories_proc("Comedy");


-- 3.  Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

SELECT 
    COUNT(f.film_id) AS films_per_category, cat.name
FROM
    film f
        JOIN
    film_category fc USING (film_id)
        JOIN
    category cat USING (category_id)
GROUP BY cat.name
ORDER BY films_per_category DESC;


DELIMITER //
CREATE PROCEDURE categ_above_65(IN categ_filter int)
BEGIN
    select count(f.film_id) as films_per_category, cat.name
from film f
join film_category fc using (film_id)
join category cat using (category_id)
group by cat.name
having films_per_category > categ_filter
ORDER BY films_per_category DESC;
end //
DELIMITER ;

call categ_above_65(65)

-- only 5 categories has total movies above 65.