/*QUERY 1 : this is the query for 1st Question 

We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children,
Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in,
and the number of times it has been rented out.
Check Your Solution
For this query, you will need 5 tables: Category, Film_Category, Inventory,
Rental and Film. Your solution should have three columns: Film title, Category
name and Count of Rentals.
The following table header provides a preview of what the resulting table should
look like if you order by category name followed by the film title:
- film_title,
- category_name
- rental_count
HINT: One way to solve this is to create a count of movies using aggregations,
subqueries and Window functions.

*/

WITH film_cat AS (SELECT f.title film_title, c.name category_name, r.rental_date
					FROM category c
					JOIN film_category fc
					ON c.category_id = fc.category_id
					JOIN film f
					ON f.film_id = fc.film_id
					JOIN inventory i
					ON f.film_id = i.film_id
					JOIN rental r
					ON i.inventory_id = r.inventory_id)


SELECT film_title, category_name, count(*) rental_count
	FROM film_cat
	WHERE category_name IN ('AnimatiON', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
	GROUP BY 1,2
	ORDER BY category_name,film_title
	
------------------------------------------------------------------------------------------------------------------------	
	
/*QUERY 2 : this is the query for 2nd Question

Now we need to know how the length of rental duration of these family-friendly
movies compares to the duration that all movies are rented for. Can you provide
a table with the movie titles and divide them into 4 levels (first_quarter,
second_quarter, third_quarter, and final_quarter) based on the quartiles (25%,
50%, 75%) of the rental duration for movies across all categories? Make sure to
also indicate the category that these family-friendly movies fall into.
Check Your Solution
The data are not very spread out to create a very fun looking solution, but you
should see something like the following if you correctly split your data. You
should only need the
- category
- film_category
- film
tables to answer this and the next questions.
HINT: One way to solve it requires the use of percentiles, Window functions,
subqueries or temporary tables.

 */

WITH t1 AS (SELECT c.name film_category,f.title film_name, f.rental_duration
			FROM category c
			JOIN film_category fc
			ON c.category_id = fc.category_id
			JOIN film f
			ON fc.film_id = f.film_id)

SELECT *,
	NTILE(4) OVER (ORDER BY rental_duratiON) AS quartile
FROM t1

-------------------------------------------------------------------------------------------------------------------------

/*QUERY 3 : this is the query for 3rd Question

Finally, provide a table with the family-friendly film category, each of the
quartiles, and the corresponding count of movies within each combination of film
category for each corresponding rental duration category. The resulting table
should have three columns:
- Category
- Rental length category
- Count
Check Your Solution
The following table header provides a preview of what your table should look like.
The Count column should be sorted first by Category and then by Rental Duration
category.
HINT: One way to solve this question requires the use of Percentiles, Window
functions and Case statements.

 */

SELECT  category_name, quartiles,
        COUNT(category_name) movie_counts
FROM (SELECT c.name category_name,
		     NTILE(4) OVER (ORDER BY f.rental_duration) AS quartiles
		     FROM film f
		     JOIN film_category fc
		     ON f.film_id = fc.film_id
		     JOIN category c
		     ON c.category_id = fc.category_id
		     WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) t1
GROUP BY 1, 2
ORDER BY 1, 2


--------------------------------------------------------------------------------------------------------------------------

/*QUERY 4 : this is the query for 4th Question 

We want to find out how the two stores compare in their count of rental orders
during every month for all the years we have data for. Write a query that returns
the store ID for the store, the year and month and the number of rental orders each
store has fulfilled for that month. Your table should include a column for each
of the following: year, month, store ID and count of rental orders fulfilled during that month.
Check Your Solution
The following table header provides a preview of what your table should look like.
The count of rental orders is sorted in descending order.
HINT: One way to solve this query is the use of aggregations.

*/

SELECT DATE_PART('month', r1.rental_date) AS rental_month, 
       DATE_PART('year', r1.rental_date) AS rental_year,
       s1.store_id AS store,
       COUNT(*) count_rentals
FROM store AS s1
	JOIN staff AS s2
	ON s1.store_id = s2.store_id
		
	JOIN rental r1
	ON s2.staff_id = r1.staff_id
GROUP BY 1, 2, 3
ORDER BY 4 desc