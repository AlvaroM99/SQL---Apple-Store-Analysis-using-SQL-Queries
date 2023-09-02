# SQL- AppleStore Analysis using SQL Queries
</br>

## Index

- [Overview](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis#overview)
- [Dataset](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis#dataset)
- [Guiding Questions](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis#guiding-questions)
- [Exploratory Analysis](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis#exploratory-analysis)
- [Data Analysis](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis#data-analysis)
- [Conclusions](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis#conclusions)
</br>

## Overview:
With the iPhone's increasing market share, many app developers see the App Store as a growing and profitable opportunity. According to Statista, nearly 5 million apps are available in the Apple App Store as of July 2022. Even though mobile applications can be a great source of income and a showcase for companies and their services, this is still a very competitive field. For this reason, an exploratory analysis of the data can provide useful insights for these developers and their companies, thus knowing what makes an app successful.

For this analysis, I will be using the Kaggle dataset named App Statistics (Apple iOS app store). Data source: [click here](https://www.kaggle.com/datasets/ramamet4/app-store-apple-data-set-10k-apps). To showcase different SQL skills this querying exploratory analysis will be done entirely using the [sqlonline](https://sqliteonline.com/) tool which provides a wide range of engines and an in-engine visualization tool. This time I have chosen SQLite engine instead of MySQL due to its better performance and lightweight.

</br>

## Dataset
This dataset contains detailed data from more than 7000 mobile applications within the Apple Store. The dataset was extracted from the iTunes Search API in July 2017. In the raw data folder, there are two CSV files; the crucial one is named appleStore.csv and it includes the main characteristics and details of each application, and the other one is called appleStore_description_combined.csv which includes the description of each application. 

The contents of appStore.csv are listed as the following:
  - id: App ID
  - track_name: App Name
  - size_bytes: Size (in Bytes)
  - currency: Currency Type
  - price: Price amount
  - rating_count_tot: User Rating counts (for all versions)
  - rating_count_ver: User Rating counts (for the current version)
  - user_rating: Average User Rating value (for all versions)
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

</br>

## Guiding Questions
To figure out what apps in the Apple App Store have the potential to be successful, the following guiding questions were proposed.

  1. What are the app statistics for different groups?
  2. Are paid apps better than free apps?
  3. What are some possible factors that contribute to higher user ratings?
</br>

## Exploratory Analysis
To begin with, I checked the number of unique apps in both tables looking for a match. I retrieved 7197 unique app IDs for both tables.  
```
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined
```


</br></br>Then I searched for missing values in any key field in both tables. None was discovered.
```
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null OR user_rating IS null OR prime_genre IS null

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is null
```


</br></br>The first approach to the analysis was looking for the number of unique apps per genre. Then I plotted a bar chart by changing the command SELECT to BAR-SELECT. 
```
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC
```

From the bar chart, I found out that Games, Entertainment, Education, Photos & Videos, and Utilities are the top 5 largest categories. However, the category of Games outshines the rest as it surpasses the second-largest category (Entertainment) by almost 7 times.

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/98602544-999a-4cdb-85db-1ce303b92ba7)

Digging deeper, I also plotted a pie chart that shows the distribution of each relevant category by changing SELECT with PIE-SELECT and adding an ending limiting clause to only plot the 5 most important categories. The purpose is to visualize the huge proportion that games take up in the app market when compared to other application categories. As intended, the chart perfectly depicts how the Games category accounts for most of the AppleStore market share and thus the gaming industry is shown to be the mainstay of the AppleStore service.

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/88ecd76a-e937-46d6-8d17-7cba78cee908)


</br></br>Following the exploratory analysis, I then looked for the apps' ratings so that we have an overview of this key variable for the upcoming data analysis. I searched for the minimum and maximum to check if there was any meaningless value and the average of all the apps.
```
SELECT
	min(user_rating) AS MinRating,
	max(user_rating) AS MaxRating,
	avg(user_rating) AS AvgRating
FROM AppleStore
```
The outcome of this query was the foreseeable, 0 for the minimum, 5 for the maximum, and roughly 3.5 for the average.

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/7cd08ce6-dd5a-4b0a-8a9c-42bb98439dc9)


</br></br>To finish the exploratory analysis I overviewed the price parameter, its minimum, its maximum, and average. Then I got the distribution of app prices.
```
SELECT
	min(price) AS MinPrice,
	max(price) AS MaxPrice,
	avg(price) AS AvgPrice
FROM AppleStore
```
This was the snippet's outcome:

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/94e7e699-a6cc-4946-80bc-85cc741c5ee6)

For the price distribution, the query starts to become increasingly complicated. As each app has a different price I had to categorize each app into increasing ranges by defining the start of the interval as PriceBinStart and the end of it as PriceBinEnd. Sadly, SQLite 3 doesn't support columns with interval values, thus merging the two generated columns into a range column was not an option. 
```
SELECT
	(price/2)*2 AS PriceBinStart,
	((price/2)*2)+2 AS PriceBinEnd,
	COUNT (*) AS NumApps
FROM AppleStore
GROUP BY PriceBinStart
ORDER BY PriceBinStart
```
However, this snippet of code as fast and lightweight as it is, was useless when trying to visualize it with the limited in-engine visualization tool embedded in sqlonline. It needed two columns acting as x and y, and merging the prices columns was impossible. Hence, I had to wrap my mind around and come out with a solution that is far less elegant but works when it comes to visualizing the results.
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
Most of the apps are free, that's why the [0 to 5$ range accounts for almost all the apps. As the price interval increases the number of apps starts to shrink, up to the point where ranges above 25 dollars account for very few apps.
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/9fc0b45b-f93c-4552-8fce-8bdde412a5a0)
</br></br>


## Data Analysis

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
The output unveiled a significant difference of 0.35 in the rating, which suggests that paid apps have better quality than free ones. It may not be seen as a huge difference but it is, regarding the short 0 to 5 scale of the user rating variable and the measures being averages of the users' ratings. This could be due to the fact that users who pay for an app may be predisposed to have a higher engagement and perceive the product they purchased as more valuable.

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/41583b4e-5180-42b5-9b71-86cd34ba6e4b)


</br></br>Then I tried to determine whether apps that support more languages have higher ratings.
```
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
```
As the plot reveals there is no linear relationship between the number of languages supported by the app and the user rating when the number of languages surpasses 15. Implementing more than 15 languages won't get the app better ratings, however, when there are too few languages supported the user rating will strongly decrease. The explanation beneath this behavior might be that implementing the most spoken languages will ensure a better rating as more people can use the app, but implementing less spread languages won't as their population is not that relevant in relationship to the population of most talked languages.  

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/217eeec9-c372-4971-8810-043cb05174ad)



</br></br>Following the pursuit of the factors that make app ratings higher I checked the genres with higher average ratings. 
```
SELECT
       prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating DESC
```
It's interesting how Gaming is the most popular genre but is far behind other categories when it comes to the quality of these apps. A possible explanation might be the vast presence of shovelware in the Gaming category and the fact that only by downloading the app the developer earn money. 

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/b88e84f2-d0aa-4796-bc9c-c4fab2b18e56)



</br></br>Another interesting insight is the relationship between the length of the app description and its rating. To check if there's an existing correlation I applied the following query. 
```
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
```
There is a linear relationship. Longer descriptions have better ratings.

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/614259a6-af78-43a4-a5df-26bcac74215d)


</br></br>It might also be interesting to test if other factors such as the number of screenshots, the number of devices supported or the size of the app are influential over the user rating. When the number of devices supported and the size of the application were tested versus the user rating, no relationship was unveiled.

However, when the number of screenshots in the application description ("ipadsc_urls_num") was tested against the user rating, the outcome suggested a strong relationship. As the number of screenshots increases, so does the average user rating.
```
SELECT
       ipadsc_urls_num,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY ipadsc_urls_num
ORDER BY Avg_Rating ASC
```

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/099a1df9-43c7-4336-ae70-421507097d8b)



</br></br>Finally, I look for the best-rated app for each genre.
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
	FROM AppleStore
	) AS a
 WHERE
 a.rank = 1
```
![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/8793b85b-ede2-421f-b92e-9e1a4916c0fa)

![image](https://github.com/AlvaroM99/SQL---Apple-Store-Querying-Analysis/assets/129555669/affe6528-5a99-491f-8268-c0f6387f8795)

</br>

## Conclusions
To summarize the insights unveiled during the querying data analysis I will list them below:
1. Paid apps generally achieve higher ratings than their free counterparts
2. Apps supporting a moderate amount of the most spoken languages have higher ratings, so it is not about implementing a lot of languages but focusing on the right ones.
3. Finance and Books apps have very low ratings but there's a market gap that companies could profit from by developing apps with more features that engage these apps' consumers and potentially occupy their market.
4. Apps with longer descriptions and more screenshots can set click expectation and eventually lead to a download. Moreover, well-crafted and clearly depicted descriptions showing the app's features and capabilities are appreciated by users.
5. Games and Entertainment categories have a remarkably high volume of apps, suggesting that these markets may be saturated and entering them might be too challenging. However, this also reveals a higher user demand for these categories.  


















 
