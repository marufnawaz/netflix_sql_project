-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems


-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and TV shows

WITH CountRating AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM CountRating
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

SELECT *
FROM
(
    SELECT TOP 5 
        value AS country, 
        COUNT(*) AS total_content
    FROM netflix
    CROSS APPLY STRING_SPLIT(country, ',')
    WHERE value IS NOT NULL -- ensuring nulls are filtered
    GROUP BY value
) AS t1
ORDER BY total_content DESC;



-- 5. Identify the longest movie

SELECT TOP 1 *
FROM netflix
WHERE type = 'Movie'
ORDER BY 
    CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) DESC;



-- 6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE 
    CONVERT(DATE, date_added, 101) >= DATEADD(YEAR, -5, GETDATE());



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM
(
    SELECT 
        netflix.*, -- Select all columns from netflix
        SplitDirectors.value AS director_name -- Alias the split value as director_name
    FROM netflix
    CROSS APPLY STRING_SPLIT(director, ',') AS SplitDirectors
) AS t
WHERE director_name = 'Rajiv Chilaka';



-- 8. List all TV shows with more than 5 seasons

SELECT *
FROM netflix
WHERE 
    TYPE = 'TV Show'
    AND 
    CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5;



-- 9. Count the number of content items in each genre
SELECT 
    SplitGenres.value AS genre, 
    COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',') AS SplitGenres
GROUP BY SplitGenres.value;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT TOP 5
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        CAST(COUNT(show_id) AS NUMERIC) /
        CAST((SELECT COUNT(show_id) FROM netflix WHERE country = 'India') AS NUMERIC) * 100, 
        2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC;



-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'



-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT *
FROM netflix
WHERE 
    cast LIKE '%Salman Khan%'
    AND 
    release_year > YEAR(GETDATE()) - 10;



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.



SELECT TOP 10
    SplitActors.value AS actor,
    COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(cast, ',') AS SplitActors
WHERE country = 'India'
GROUP BY SplitActors.value
ORDER BY total_content DESC;


/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
    type,
    COUNT(*) AS content_count
FROM (
    SELECT 
        type,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good' 
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category, type
ORDER BY type;





-- End of reports