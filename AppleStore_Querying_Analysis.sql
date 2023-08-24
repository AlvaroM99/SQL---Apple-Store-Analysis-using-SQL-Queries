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

-- 2.1. Check the number of unique apps in both AppleStore tables

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
SELECT min(price) AS MinPrice,
	   max(price) AS MaxPrice,
       avg(price) AS AvgPrice
FROM AppleStore

SELECT CASE
			WHEN price = 0 THEN '0'
            WHEN price BETWEEN 0.0001 AND 5 THEN '0-5$'
            WHEN price BETWEEN 5.0001 AND 10 THEN '5-10$'
            WHEN price BETWEEN 10.0001 AND 25 THEN '10-25$'
            WHEN price BETWEEN 25.0001 AND 50 THEN '25-50$'
            WHEN price BETWEEN 50.0001 AND 100 THEN '50-100$'
            WHEN price BETWEEN 100.0001 AND 200 THEN '100-200$'
            WHEN price BETWEEN 200.0001 AND 300 THEN '200-300$'
       END AS price_bucket,
       COUNT(*) AS NumApps
FROM AppleStore
GROUP BY price_bucket
ORDER BY NumApps DESC


-- 3.**DATA ANALYSIS**

-- 3.1. Determine if paid apps have higher ratings than free apps

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       avg(user_rating) As AvgRating
FROM AppleStore
GROUP BY App_Type

-- 3.2. Determine whether apps which support more languages have higher ratings

SELECT CASE
			WHEN lang_num < 5 THEN '<5 languages'
            WHEN lang_num BETWEEN 5 AND 10 THEN '5-10 languages'
            WHEN lang_num BETWEEN 10 AND 15 THEN '10-15 languages'
            WHEN lang_num BETWEEN 15 AND 20 THEN '15-20 languages'
            WHEN lang_num BETWEEn 20 and 30 then '20-30 languages'
            ELSE '>30 languages'
       END AS language_bucket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY lang_num ASC

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
ORDER BY average_rating ASC
           
-- 3.6. Test the number of screenshots against the user rating aiming to find a correlation

SELECT
       ipadsc_urls_num,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY ipadsc_urls_num
ORDER BY Avg_Rating ASC

-- 3.7. Check the top-rated apps by genre           
           
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