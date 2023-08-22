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

</br>Then I search for missing values in any key field in both tables. None was discovered.
```
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is null OR user_rating IS null OR prime_genre IS null

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc is null
```

</br>A first approach to start the analysis was looking for the number of unique apps per genre. Then I plotted a bar chart changing the command SELECT by BAR-SELECT. 
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

</br>
