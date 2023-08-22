# SQL- AppleStore Querying Analysis

## Overview:
With the increasing market share of the iPhone many app developers see the App Store as a growing and profitable opportunity. According to Statista, there are nearly 5 million apps available in the Apple App Store as of July 2022. Even though mobile applications can be a great source of income and a showcase for the developer company and its services, this is still a very competitive field. For this reason, an exploratory analysis of the data can provide useful insights for these developers and the company and thus know what makes an app successful.

For this analysis, I will be using the Kaggle dataset named App Statistics (Apple iOS app store). Data source: [click here](https://www.kaggle.com/datasets/ramamet4/app-store-apple-data-set-10k-apps). To showcase different SQL skills this querying exploratory analysis will be done entirely using the [sqlonline](https://sqliteonline.com/) tool which provides a wide range of engines and an in-engine visualization tool. This time I have chosen SQLite engine instead of MySQL due to its better performance and lightweight.

## Dataset
This dataset contains detailed data from more than 7000 mobile applications within the Apple Store. The dataset was extracted from the iTunes Search API in July 2017. In the raw data folder, there are two CSV files; the crucial one is named appleStore.csv and it includes the main characteristics and details of each application, and the other one is called appleStore_description_combined.csv which includes the description of each application. 

The sqlonline webpage has a little downside, its free version doesn't support files as big as appleStore_description_combined.csv. That's why the original appleStore_description.csv file was partitioned into 4 pieces and later merged using the CREATE TABLE and UNION ALL commands. That's the reason behind the second file being called "_combined.csv". 

The contents of appStore.csv are listed as the following:
  - id: App ID
  - track_name: App Name
  - size_bytes: Size (in Bytes)
  - currency: Currency Type
  - price: Price amount
  - rating_count_tot: User Rating counts (for all version)
  - rating_count_ver: User Rating counts (for current version)
  - user_rating: Average User Rating value (for all version)
  - user_rating_ver: Average User Rating value (for current version)
  - ver: Latest version code
  - cont_rating: Content Rating
  - prime_genre: Primary Genre
  - sup_devices.num: Number of supported devices
  - ipadSc_urls.num: Number of screenshots shown for display
  - lang.num: Number of supported languages
  - vpp_lic: Vpp Device Based Licensing Enabled

The contents of appleStore_description.csv are listed as the following:
  - id: App ID
  - track_name: Application name
  - size_bytes: Memory size (in Bytes)
  - app_desc: Application description

The sqlonline webpage has a little downside, its free version doesn't support files as big as appleStore_description.csv. That's why this file was partitioned into 4 pieces and later merged using the CREATE TABLE and UNION ALL commands. 

## Guiding Questions
To figure out what apps in the Apple App Store have the potential to be successful, the following guiding questions were proposed.

  1. What are the app statistics for different groups?
  2. Are paid apps better than free apps?
  3. What are some possible factors that contribute to higher user ratings?

## Exploratory Data Analysis
To begin with, I check the number of unique apps in both tables looking for a match. We retrieved 7197 unique app IDs for both tables.  
```
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined
```


</br></br>Then I search for missing values in any key field in both tables. None was discovered.
```
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null OR user_rating IS null OR prime_genre IS null

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is null
```


</br></br>A first approach to start the analysis was looking for the number of unique apps per genre. Then I plotted a bar chart changing the command SELECT by BAR-SELECT. 
```
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC
```

From the bar chart, I found out that Games, Entertainment, Education, Photos & Videos, and Utilities are the top 5 largest categories. However, the category of Games outshines the rest as it surpasses the second-largest category (Entertainment) by almost 7 times.

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/98602544-999a-4cdb-85db-1ce303b92ba7)

Digging deeper, I also plotted a pie chart that shows the distribution of each relevant category by changing SELECT with PIE-SELECT and adding an ending limiting clause to only plot the 5 most important categories. The purpose is to visualize the huge proportion that games take up in the app market when compared to other application categories. As intended, the chart perfectly depicts how the Games category accounts for most of the AppleStore market share and thus the gaming industry is shown to be the mainstay of the AppleStore service
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/88ecd76a-e937-46d6-8d17-7cba78cee908)


</br></br>Following with the exploratory analysis, I then looked for the apps' ratings so that we have an overview of this key variable for the upcoming data analysis. I searched for the minimun and the maximun to check if there was any wrong value and the average of all the apps.
```
SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore
```
The outcome of this statement was the foreseeable, 0 for the minimun, 5 for the maximun and roughly 3.5 for the average.
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/7cd08ce6-dd5a-4b0a-8a9c-42bb98439dc9)


</br></br>To finish the exploratory analysis I overviewed the price parameter, its minimun, its maximun and average. Then I got the distribution of app prices.
```
SELECT min(price) AS MinPrice,
	   max(price) AS MaxPrice,
       avg(price) AS AvgPrice
FROM AppleStore
```
This was the statement's outcome:
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/94e7e699-a6cc-4946-80bc-85cc741c5ee6)

For the distribution the statement was increasingly complicated. As each app has a different price I had to categorize each app into increasing ranges by defining the start of the interval as PriceBinStart and the end of it as PriceBinEnd. Sadly, SQLite 3 doesn't support columns with interval values, thus merging the two generated columns into an interval column was not an option. 
```
SELECT
	(price/2)*2 AS PriceBinStart,
    ((price/2)*2)+2 AS PriceBinEnd,
    COUNT (*) AS NumApps
FROM AppleStore
GROUP BY PriceBinStart
ORDER BY PriceBinStart
```
```
SELECT CASE
			WHEN price = 0 THEN '0'
            WHEN price BETWEEN 0.0001 AND 5 THEN '0.001-5$'
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
```
Most of the apps are free, that's why the 0-2 range accounts for more than half of the apps. As the price interval increases the number of apps start to shrink, up the point where ranges above 16 dollars account for one to five apps. The chart output was the following:

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/5d4aafeb-5eb3-4c65-be09-c9df4eb0c436)


![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/6dd19f56-9450-472d-8bee-08f39811debd)



##Data Analysis
First of all, I determined if paid apps have higher ratings than free apps.
```
SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       avg(user_rating) As AvgRating
FROM AppleStore
GROUP BY App_Type
```
This was the outcome:
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/41583b4e-5180-42b5-9b71-86cd34ba6e4b)


</br></br>Then I tried to determine whether apps that support more languages have higher ratings.
```
SELECT CASE
			WHEN lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
       END AS language_bucket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC
```

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/731ef5ab-8291-4cbd-a628-603e2a8f7199)


</br></br>Following the pursue of the factors that makes app ratings higher I checked the genres with higher average ratings. It's interesting how Gaming might be the most popular genre but it is far behing other categories when it comes to the quality of these apps. A possible explanation might be the vast presence of shovel-ware and the fact that only by dowloading the app the developer earns some money, as it is, the developer only have to make you download the app but there's no further reward in workinng on the retention in the app.
```
BAR-SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating DESC
```

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/b88e84f2-d0aa-4796-bc9c-c4fab2b18e56)



</br></br>Another interesting insight is the correlation between the length of the app description and its rating. To check if there's an existing correlation I applied the followig statement. There is. Longer descriptions have better ratings.
```
LINE-SELECT CASE
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
```

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/614259a6-af78-43a4-a5df-26bcac74215d)


</br></br>Finally I loof for the best rated app for each genre.
```
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
```
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/8793b85b-ede2-421f-b92e-9e1a4916c0fa)

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/affe6528-5a99-491f-8268-c0f6387f8795)
