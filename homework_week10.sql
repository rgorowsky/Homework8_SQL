USE sakila;

SELECT first_name, last_name  							        				# 1a. Display the first and last names of all actors from the table
FROM actor;																		# actor.table actor.

SELECT CONCAT(UPPER(first_name), " ", UPPER(last_name)) AS "Actor Name"  		# 1b. Display the first and last name of each actor in a single column
FROM actor; 																	# in upper case letters. Name the column Actor Name. 

SELECT * 																		# 2a. You need to find the ID number, first name, and last name of an
FROM actor																		# actor, of whom you know only the first name, "Joe." What is one
WHERE first_name = "Joe";														# query would you use to obtain this information?

SELECT *																		# 2b. Find all actors whose last name contain the letters GEN:
FROM actor
WHERE last_name LIKE "%GEN%";

SELECT *																		# 2c. Find all actors whose last names contain the letters LI. This 
FROM actor																		# time, order the rows by last name and first name, in that order:
WHERE last_name LIKE "%LI%"
ORDER BY last_name ASC, first_name ASC;

SELECT *																		# 2d. Using IN, display the country_id and country columns of the
FROM country																	# following countries: Afghanistan, Bangladesh, and China:
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE	country																# 3a. You want to keep a description of each actor. You don't think
ADD COLUMN description BLOB AFTER country;										# you will be performing queries on a description, so create a column 
																				# in the table actor named description and use the data type BLOB 
                                                                                # (Make sure to research the type BLOB, as the difference between it 
                                                                                # and VARCHAR are significant).
                                                                                
ALTER TABLE	country																# 3b. Very quickly you realize that entering descriptions for each
DROP COLUMN description;														# actor is too much effort. Delete the description column.

SELECT first_name, last_name, COUNT(last_name)									# 4a. List the last names of actors, as well as how many actors
FROM actor																		# have that last name.
GROUP BY first_name, last_name
HAVING COUNT(last_name) > 0
ORDER BY COUNT(last_name) DESC;

SELECT first_name, last_name, COUNT(last_name)									# 4b. List last names of actors and the number of actors who have
FROM actor																		# that last name, but only for names that are shared by at least 
GROUP BY first_name, last_name													# two actors
HAVING COUNT(last_name) > 1;

UPDATE actor 																	# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor 
SET first_name = "HARPO" 														# table as GROUCHO WILLIAMS. Write a query to fix the record.
WHERE first_name = "GROUCHO" 
AND last_name = "WILLIAMS";

UPDATE actor 																	# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It
SET first_name = "GROUCHO" 														# turns out that GROUCHO was the correct name after all! In a single
WHERE first_name = "HARPO" 														# query, if the first name of the actor is currently HARPO, change .
AND last_name = "WILLIAMS";														# it to GROUCHO.

CREATE TABLE address_remade														# 5a. You cannot locate the schema of the address table. Which query
LIKE address;																	# would you use to re-create it?

SELECT * 																		# 6a. Use JOIN to display the first and last names, as well as the 
FROM staff s																	# address, of each staff member. Use the tables staff and address:
INNER JOIN address a 
ON s.address_id = a.address_id;

SELECT first_name, last_name, s.staff_id, SUM(amount) AS pay_sum				# 6b. Use JOIN to display the total amount rung up by each staff
FROM staff s																	# member in August of 2005. Use tables staff and payment.
INNER JOIN payment p 
ON s.staff_id = p.staff_id
WHERE p.payment_date < '2005-09-01%'
AND p.payment_date >= '2005-08-01%'
GROUP BY first_name, last_name, s.staff_id;

SELECT f.film_id, f.title, COUNT(actor_id) AS actors_in_film					# 6c. List each film and the number of actors who are listed for that
FROM film f  																	# film. Use tables film_actor and film. Use inner join.
INNER JOIN film_actor a
ON f.film_id = a.film_id
GROUP BY f.film_id;

SELECT COUNT(i.inventory_id) AS number_of_copies								# 6d. How many copies of the film Hunchback Impossible exist in the
FROM inventory i 																# inventory system?
INNER JOIN film f 
ON i.film_id = f.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE';

SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS customer_total	# 6e. Using the tables payment and customer and the JOIN command,
FROM payment p 																		# list the total paid by each customer. List the customers 
INNER JOIN customer c 																# alphabetically by last name:
ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name ASC;

SELECT *																		# 7a. The music of Queen and Kris Kristofferson have seen an unlikely
FROM film f 																	# resurgence. As an unintended consequence, films starting with the
INNER JOIN language l 															# letters K and Q have also soared in popularity. Use subqueries to
ON f.language_id = l.language_id 												# display the titles of movies starting with the letters K and Q 
WHERE l.name = 'English'														# whose language is English.
AND (f.title LIKE 'K%' OR f.title LIKE 'Q%');

SELECT CONCAT(a.first_name, " ", a.last_name) AS "Actors of Alone Trip" 		# 7b. Use subqueries to display all actors who appear in the film 
FROM film f 																	# Alone Trip.
INNER JOIN film_actor fa 
ON f.film_id = fa.film_id
INNER JOIN actor a 
ON fa.actor_id = a.actor_id
WHERE f.title = 'ALONE TRIP';

SELECT first_name, last_name, email												# 7c. You want to run an email marketing campaign in Canada, for 
FROM customer cu																# which you will need the names and email addresses of all Canadian
INNER JOIN address ad															# customers. Use joins to retrieve this information.
ON cu.address_id = ad.address_id
INNER JOIN city ci
ON ci.city_id = ad.city_id
INNER JOIN country co
ON co.country_id = ci.country_id
WHERE co.country = "Canada";

SELECT*																			# 7d. Sales have been lagging among young families, and you wish to 
FROM film f																		# target all family movies for a promotion. Identify all movies 
INNER JOIN film_category fc														# categorized as family films.
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = "Family";

SELECT f.title, COUNT(r.rental_id) AS "Most Popular Movies"						# 7e. Display the most frequently rented movies in descending order.
FROM film f 
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.rental_id
GROUP BY f.film_id
ORDER BY COUNT(r.rental_id) DESC;

SELECT st.store_id, SUM(p.amount) AS "Store Total"								# 7f. Write a query to display how much business, in dollars, each store
FROM payment p 																	# brought in.
INNER JOIN staff s
ON p.staff_id = s.staff_id
INNER JOIN store st
ON s.store_id = st.store_id
GROUP BY st.store_id;

SELECT s.store_id, c.city, cu.country											# 7g. Write a query to display for each store its store ID, city, and
FROM store s INNER JOIN address a ON s.address_id = a.address_id				# country.
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country cu ON c.country_id = cu.country_id;


SELECT c.name AS title, sum(p.amount) AS "Gross Revenue"						# 7h. List the top five genres in gross revenue in descending order. 
FROM category c																	# (Hint: you may need to use the following tables: category, 
INNER JOIN film_category fc ON c.category_id = fc.category_id					# film_category, inventory, payment, and rental.)
INNER JOIN inventory i ON fc.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON (p.rental_id = r.rental_id AND p.customer_id = r.customer_id)
group by c.name
order by "Gross Revenue" DESC
Limit 5;

CREATE VIEW HOMEWORK_VIEW 
AS (SELECT c.name AS title, sum(p.amount) AS "Gross Revenue"					# 8a. In your new role as an executive, you would like to have an  
FROM category c																	# easy way of viewing the Top five genres by gross revenue. Use the 
INNER JOIN film_category fc ON c.category_id = fc.category_id					# solution from the problem above to create a view. If you haven't
INNER JOIN inventory i ON fc.film_id = i.film_id								# solved 7h, you can substitute another query to create a view.
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON (p.rental_id = r.rental_id AND p.customer_id = r.customer_id)
group by c.name
order by "Gross Revenue" DESC
Limit 5); 

																				# 8b How would you display the view that you created in 8a?
																				# ?????????????????????????????????????????????????????????
                                                                                
DROP VIEW HOMEWORK_VIEW;														# 8c. You find that you no longer need the view top_five_genres
																				# Write a query to delete it.
