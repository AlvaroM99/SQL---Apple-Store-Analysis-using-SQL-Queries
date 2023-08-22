-- 1.**MERGING THE DATA**

-- 1.1. Merging the appleStore_description tables into a single one

CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4


-- 2.**EXPLORATORY DATA ANALYSIS**

-- 2.1. Check the number of unique apps in both AppleStore tablesAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

-- 2.2. Check for missing values in any key field

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null OR user_rating IS null OR prime_genre IS null

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is null 

-- 2.3. Find the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- 2.4. Overview of the apps' ratings 

SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore

-- 2.5. Get the distribution of app prices 

SELECT
	(price/2)*2 AS PriceBinStart,
    ((price/2)*2)+2 AS PriceBinEnd,
    COUNT (*) AS NumApps
FROM AppleStore
GROUP BY PriceBinStart
ORDER BY PriceBinStart


-- 3.**DATA ANALYSIS**

-- 3.1. Determine if paid apps hasve higher ratings than free apps

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       avg(user_rating) As AvgRating
FROM AppleStore
GROUP BY App_Type

-- 3.2. Determine whether apps which support more languages have higher ratings

SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
       END AS language_bucket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

-- 3.3. Check which genres have lower ratings

SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10

-- 3.4. Check genres with higher ratings

SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating DESC
LIMIT 10

-- 3.5. Check if there is correlation between the length of the app description and the user ratingAppleStore

SELECT CASE
		   WHEN length(b.app_desc) < 500 THEN 'Short'
           WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
           ELSE 'Long'
      END AS description_length_bucket,
      avg(a.user_rating) AS average_rating

FROM 
	AppleStore AS a 
JOIN
	appleStore_description_combined AS b 
ON
	a.id = b.id

GROUP BY description_length_bucket
ORDER BY average_rating DESC
           
-- 3.6. Check the top-rated apps by genre           
           
SELECT
	prime_genre,
    track_name,
    user_rating
FROM(
  	SELECT
    	prime_genre,
    	track_name,
  		user_rating,
  		RANK() OVER(PARTITION by prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  		FROM
  		AppleStore
  		) AS a
 WHERE
 a.rank = 1