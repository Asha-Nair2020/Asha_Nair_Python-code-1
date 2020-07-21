USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
select year,Count(year) as movies_year from movie
group by year;
DESCRIBE movie;
DESCRIBE director_mapping;
DESCRIBE genre;
DESCRIBE names;
DESCRIBE ratings;
DESCRIBE role_mapping;

-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- Table 1. director_mapping --
SELECT COUNT(*)
FROM director_mapping;

-- Table 2. genre --
SELECT COUNT(*)
FROM genre;

-- Table 3. names --
SELECT COUNT(*)
FROM names;

-- Table 4. movie --
SELECT COUNT(*)
FROM movie;

-- Table 5. ratings --
SELECT COUNT(*)
FROM ratings;

-- Table 6. role_mapping --
SELECT COUNT(*)
FROM role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT * 
FROM   (SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'Id' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  id IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'title' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  title IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'year' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  year IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'date_published' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  date_published IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'duration' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  duration IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'country' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  country IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'worlwide_gross_income' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  worlwide_gross_income IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'languages' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  languages IS NULL 
        UNION 
        SELECT CASE 
                 WHEN Count(*) <> 0 THEN 'production_company' 
                 ELSE NULL 
               END AS columns 
        FROM   movie 
        WHERE  production_company IS NULL) AS a 
WHERE  a.columns IS NOT NULL; 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- the total number of movies released each year --
SELECT year,
		Count(Distinct id) AS number_of_movies
FROM movie
GROUP BY year; 

-- How does the trend look month wise? --

SELECT 
	MONTH(date_published) AS month_num,
	Count(DISTINCT id) AS number_of_movies
FROM movie
GROUP BY month_num
Order by month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(*) AS num_movies 
FROM   movie 
WHERE  ( country LIKE '%USA%' 
          OR country LIKE '%India%' ) 
       AND year = 2019; 
       
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT GENRE
FROM genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT GENRE,
		Count(id) as num_movies
FROM genre as g
INNER JOIN movie as m
ON g.movie_id =m.id
GROUP BY genre
ORDER BY num_movies DESC limit 1 ; 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(*) 
FROM (
	SELECT 
		movie_id,
		COUNT(g.genre)AS num_genre
	FROM 
		genre AS g
	GROUP BY 
		movie_id )AS a 
	WHERE num_genre=1;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- the average duration of movies in each genre --
SELECT genre,
	   ROUND(avg(duration),2) as avg_duration
FROM genre as g
INNER JOIN movie as m
ON g.movie_id =m.id
GROUP BY genre;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH cte AS
	( SELECT g.genre,
		COUNT(m.id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
	FROM genre AS g
	INNER JOIN movie AS m
	ON g.movie_id =m.id
	GROUP BY genre)
SELECT * 
FROM cte 
WHERE GENRE='Thriller';

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/
-- Segment 2:
-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- Min and Max values of the columns in the table 'rating' --
SELECT MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
        MAX(median_rating) AS max_median_rating
FROM ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- Solution: the top 10 movies based on average rating --
WITH rating_summary AS 
(SELECT m.title,
		r.avg_rating,
        ROW_NUMBER() OVER( ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id)

SELECT title,
		avg_rating,
		movie_rank
FROM rating_summary
WHERE movie_rank <=10;
        

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
		COUNT(movie_id) AS movie_count 
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.production_company,
		COUNT(m.title) AS movie_count,
		ROW_NUMBER() OVER(ORDER BY COUNT(title) DESC) AS prod_company_rank 
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE r.avg_rating>8 
AND production_company is not NULL
GROUP BY  m.production_company
LIMIT 1 ;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
		COUNT(r.movie_id) AS movie_count
FROM genre AS g
INNER JOIN ratings AS r
USING (movie_ID)
INNER JOIN movie AS m
ON r.movie_id=m.id
WHERE m.year =2017 
AND MONTH(m.date_published)=3
AND m.country LIKE '%USA%'
AND r.total_votes>1000
GROUP BY g.genre;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title,
		r.avg_rating,
        g.genre
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
INNER JOIN genre as g
ON r.movie_id=g.movie_id
WHERE m.title LIKE 'The%'
AND r.avg_rating>8;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT m.title AS Title,
		m.date_published AS Release_Date,
		r.median_rating AS Median_Rating
FROM 
movie AS m
INNER JOIN 
ratings as r
ON 
m.id=r.movie_id
WHERE 
m.date_published BETWEEN '2018-04-01' AND '2019-04-01' 
AND 
r.median_rating=8;

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
		m.country,
		sum(r.total_votes) AS Total_Votes
FROM movie AS m
INNER JOIN ratings AS r
ON 
m.id=r.movie_id
WHERE country = 'Germany'
OR country ='Italy'
GROUP BY m.country; 

-- Answer: The total votes to German movies is higher than Italian movies --
-- as the former gets 106710 votes while the latter gets 77965 votes only. --




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
SUM(CASE WHEN name IS NULL THEN 1 else 0 END) name_null,
SUM(CASE WHEN height IS NULL THEN 1 else 0 END) height_null,
SUM(CASE WHEN date_of_birth IS NULL THEN 1 else 0 END) date_of_birth_null,
SUM(CASE WHEN known_for_movies IS NULL THEN 1 else 0 END) known_for_movies_null
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genre AS 
(
SELECT g.genre,
		COUNT(g.movie_id) AS movie_count
FROM genre AS g
INNER JOIN ratings AS r
ON g.movie_id=r.movie_id
WHERE r.avg_rating>8
GROUP BY g.genre
ORDER BY movie_count DESC
LIMIT 3
)
SELECT n.name as director_name,count(dm.movie_id) as movie_count
FROM names AS n
INNER JOIN director_mapping AS dm
ON n.id=dm.name_id
INNER JOIN genre AS g
ON g.movie_id=dm.movie_id
INNER JOIN ratings AS r
ON r.movie_id=dm.movie_id
WHERE r.avg_rating>8
and g.genre in (select genre from top_genre)
GROUP BY n.name
order by movie_count desc
limit 3;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Top two actors --
SELECT 
		n.name AS Actor_name,
		COUNT(rm.movie_id) AS movie_count
FROM names as n
INNER JOIN role_mapping as rm
ON n.id=rm.name_id
INNER JOIN ratings AS r
USING(movie_id)
WHERE median_rating >=8 
GROUP BY n.id
ORDER BY movie_count DESC
LIMIT 2;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
		SUM(r.total_votes) AS vote_count,
        RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
GROUP BY m.production_company
LIMIT 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with top_actor as
(
SELECT 
    n.name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) AS actor_avg_rating
FROM
    NAMES n
        INNER JOIN
    role_mapping ro ON n.id = ro.name_id
        INNER JOIN
    movie m ON ro.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    ro.category = 'actor'
        AND m.country LIKE '%India%'
GROUP BY n.name
)
select*,
 dense_rank() over (order by actor_avg_rating desc,total_votes desc ) AS actor_rank
from top_actor
where movie_count >= 5
LIMIT 1;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with top_actress as
(
SELECT 
    n.name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),
            2) AS actress_avg_rating
FROM
    NAMES n
    
        INNER JOIN
    role_mapping ro ON n.id = ro.name_id
        INNER JOIN
    movie m ON ro.movie_id = m.id
        INNER JOIN
    ratings r ON r.movie_id = m.id
WHERE
    ro.category = 'actress'
        AND m.country LIKE '%India%'
        AND m.languages LIKE '%Hindi%'
GROUP BY n.name
)
select*,
 dense_rank() over (order by actress_avg_rating desc,total_votes desc ) AS actress_rank
from top_actress
where movie_count >= 3
LIMIT 5;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT m.id, 
       m.title, 
       r.avg_rating, 
       CASE 
         WHEN r.avg_rating > 8 THEN 'Superhit movies' 
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit Movies' 
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'ONE-TIME-WATCH MOVIES' 
         ELSE 'Flop movies' 
       END AS Movie_type 
FROM   genre AS g 
       INNER JOIN ratings AS r using (movie_id) 
       INNER JOIN movie AS m 
               ON m.id = g.movie_id 
WHERE  g.genre = 'Thriller';

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre, 
       Round(AVG(m.duration), 2)                         AS avg_duration, 
       Sum(Round(AVG(m.duration), 2)) 
         OVER (ROWS unbounded preceding)                 AS 
       running_total_duration, 
       AVG(Round(AVG(m.duration), 2))
         OVER (ROWS BETWEEN 1 preceding AND 1 following) AS moving_avg_duration 
FROM   movie m 
       INNER JOIN genre g 
               ON g.movie_id = m.id 
GROUP  BY g.genre; 
-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genre AS 
( 
         SELECT   genre, 
                  Count(movie_id)                            AS movie_count, 
                  Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank 
         FROM     genre 
         GROUP BY genre limit 3 ), top_income AS 
( 
         SELECT   m.id, 
                  m.title, 
                  m.year, 
                  g.genre, 
                  CASE 
                           WHEN Locate('INR',m.worlwide_gross_income) THEN Cast(Trim( Substr(m.worlwide_gross_income, Locate(' ', m.worlwide_gross_income)) ) AS UNSIGNED)
                           ELSE Cast(Trim( Substr(m.worlwide_gross_income, Locate(' ', m.worlwide_gross_income)) )*70 AS UNSIGNED)
                  END AS income 
         FROM     movie m 
         JOIN     genre g 
         ON       g.movie_id = m.id 
         WHERE    g.genre IN 
                  ( 
                         SELECT genre 
                         FROM   top_genre ) 
         ORDER BY income DESC ), top_movies AS 
( 
         SELECT   *, 
                  Row_number() OVER(partition BY year ORDER BY income DESC) AS movie_rank 
         FROM     top_income 
         ORDER BY year) 
SELECT genre, 
       year, 
       title  AS movie_name, 
       income AS worldwide_gross_income, 
       movie_rank 
FROM   top_movies 
WHERE  movie_rank <= 5

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_prod_house 
     AS (SELECT m.production_company, 
                Count(m.id) 
                AS 
                   movie_count, 
                Round(Avg(r.median_rating), 2) 
                AS 
                   median_rtn, 
                Row_number() 
                  over( 
                    ORDER BY Count(m.id) DESC, Round(Avg(r.median_rating), 2) 
                  DESC) 
                AS 
                prod_comp_rank 
         FROM   movie m 
                join ratings r 
                  ON r.movie_id = m.id 
         WHERE  m.production_company IS NOT NULL 
                AND Position(',' IN languages) > 0 
                AND r.median_rating >= 8 
         GROUP  BY m.production_company) 
SELECT production_company, 
       movie_count, 
       prod_comp_rank 
FROM   top_prod_house 
WHERE  prod_comp_rank < 3; 



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_details AS 
( 
         SELECT   n.NAME, 
                  g.genre, 
                  Count(g.movie_id)                                                AS movie_count,
                  Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating,
                  Sum(r.total_votes)                                               AS total_votes
         FROM     names n 
         JOIN     role_mapping rm 
         ON       rm.name_id = n.id 
         JOIN     ratings r 
         ON       r.movie_id = rm.movie_id 
         JOIN     genre g 
         ON       g.movie_id = rm.movie_id 
         WHERE    g.genre = 'Drama' 
         AND      r.avg_rating > 8 
         AND      rm.category = 'actress' 
         GROUP BY n.NAME 
         ORDER BY Count(g.movie_id) DESC) 
SELECT   *, 
         Row_number() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank 
FROM     actress_details LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
-- SELECT * from director_mapping where name_id='nm1777967'

WITH cte AS 
( 
                SELECT DISTINCT m.id AS movie_id, 
                                n.name, 
                                n.id, 
                                date_published, 
                                Lead(date_published,1) OVER(partition BY n.NAME ORDER BY date_published) AS next_date
                FROM            director_mapping                                                         AS dm
                INNER JOIN      movie                                                                    AS m
                ON              dm.movie_id=m.id 
                INNER JOIN      names AS n 
                ON              n.id=dm.name_id) 
SELECT     dm.name_id                                                      AS director_id, 
           n.NAME                                                          AS director_name, 
           Count(DISTINCT c.movie_id)                                      AS number_of_movies,
           Round(Avg(Datediff(next_date,c.date_published)))                AS avg_inter_movie_days,
           Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes),2) AS avg_rating, 
           Sum(r.total_votes)                                              AS total_votes, 
           Min(r.avg_rating)                                               AS min_rating, 
           Max(r.avg_rating)                                               AS max_rating, 
           Sum(m.duration)                                                 AS total_duration 
FROM       director_mapping                                                AS dm 
INNER JOIN names                                                           AS n 
ON         n.id=dm.name_id 
INNER JOIN ratings AS r 
ON         dm.movie_id=r.movie_id 
INNER JOIN movie AS m 
ON         m.id=dm.movie_id 
INNER JOIN cte AS c 
ON         m.id=c.movie_id 
GROUP BY   director_name 
ORDER BY   number_of_movies DESC, 
           director_name limit 9;



