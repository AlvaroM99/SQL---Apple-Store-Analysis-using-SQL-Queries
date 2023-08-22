# SQL- AppleStore Querying Analysis

## Overview:
With the increasing market share of the iPhone many app developers see the App Store as a growing and profitable opportunity. According to Statista, there are nearly 5 million apps available in the Apple App Store as of July 2022. Even though mobile applications can be a great source of income and a showcase for the developer company and its services, this is still a very competitive field. For this reason, an exploratory analysis of the data can provide useful insights for these developers and the company and thus know what makes an app successful.

For this analysis, I will be using the Kaggle dataset named App Statistics (Apple iOS app store). Data source: [click here](https://www.kaggle.com/datasets/ramamet4/app-store-apple-data-set-10k-apps). To showcase different SQL skills this querying exploratory analysis will be done entirely using the [sqlonline](https://sqliteonline.com/) tool which provides a wide range of engines and an in-engine visualization tool. This time I have chosen SQLite engine instead of MySQL due to its better performance and lightweight.

## Dataset
This dataset contains detailed data from more than 7000 mobile applications within the Apple Store. The dataset was extracted from the iTunes Search API in July 2017. In the raw data folder, there are two CSV files; the crucial one is named appleStore.csv and it includes the main characteristics and details of each application, and the other one is called appleStore_description_combined.csv which includes the description of each application. 

The sqlonline webpage has a little downside, its free version doesn't support files as big as appleStore_description_combined.csv. That's why the original appleStore_description.csv file was partitioned into 4 pieces and later merged using the CREATE TABLE and UNION ALL commands. That's the reason behind the second file being called "_combined.csv". 

The contents of appStore.csv are listed as the following:

“id” : App ID

“track_name”: App Name

“size_bytes”: Size (in Bytes)

“currency”: Currency Type

“price”: Price amount

“rating_count_tot”: User Rating counts (for all version)

“rating_count_ver”: User Rating counts (for current version)

“user_rating” : Average User Rating value (for all version)

“user_rating_ver”: Average User Rating value (for current version)

“ver” : Latest version code

“cont_rating”: Content Rating

“prime_genre”: Primary Genre

“sup_devices.num”: Number of supported devices

“ipadSc_urls.num”: Number of screenshots shown for display

“lang.num”: Number of supported languages

“vpp_lic”: Vpp Device Based Licensing Enabled

The contents of appleStore_description.csv are listed as the following:

id : App ID

track_name: Application name

size_bytes: Memory size (in Bytes)

app_desc: Application description


The sqlonline webpage has a little downside, its free version doesn't support files as big as appleStore_description.csv. That's why this file was partitioned into 4 pieces and later merged using the CREATE TABLE and UNION ALL commands. 
