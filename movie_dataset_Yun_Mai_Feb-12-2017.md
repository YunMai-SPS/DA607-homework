Movies Rating
================
Yun Mai
February 12, 2017

SQL and R
---------

Assignment:

Choose six recent popular movies. Ask at least five people that you know (friends, family, classmates, imaginary friends) to rate each of these movie that they have seen on a scale of 1 to 5. Take the results (observations) and store them in a SQL database. Load the information into an R dataframe.

Your deliverables should include your SQL scripts and your R Markdown code, posted to GitHub.

This is by design a very open ended assignment. A variety of reasonable approaches are acceptable. You can (and should) blank out your SQL password if your solution requires it; otherwise, full credit requires that your code is "reproducible," with the assumption that I have the same database server and R software.

You may work in a small group on this assignment. If you work in a group, each group member should indicate who they worked with, and all group members should individually submit their week 2 assignment.

Please start early, and do work that you would want to include in a "presentations portfolio" that you might share in a job interview with a potential employer! You are encouraged to share thoughts, ask, and answer clarifying questions in the "Week 2: R and SQL" forum.

Inspirational reading?: <http://www.cnet.com/news/top-10-movie-recommendation-engines/>

Load the packages.

``` r
install.packages(c("stringr", "XML", "maps", "RCurl","RMySQL"))
install.packages('knitr',dependencies=TRUE,repos="http://cran.rstudio.com/")
```

``` r
# load pacakages need to be used
library(stringr)
```

    ## Warning: package 'stringr' was built under R version 3.3.3

``` r
library(XML)
```

    ## Warning: package 'XML' was built under R version 3.3.3

``` r
library(maps)
```

    ## Warning: package 'maps' was built under R version 3.3.3

``` r
library(RCurl)
```

    ## Warning: package 'RCurl' was built under R version 3.3.3

    ## Loading required package: bitops

``` r
library(RMySQL)
```

    ## Warning: package 'RMySQL' was built under R version 3.3.3

    ## Loading required package: DBI

``` r
library(knitr)
```

get movie data from IMDb website
================================

``` r
movie <- htmlParse("http://www.imdb.com/chart/moviemeter/?ref_=nv_mv_mpm_7",encoding = "UTF-8")
tables <- readHTMLTable(movie, stringsAsFactors = FALSE)

# what type of structure it is? 
class(tables)
```

    ## [1] "list"

``` r
length(tables)
```

    ## [1] 2

``` r
# use str(tables)to check the structure and contents of tables. tables[1] is 'NULL', tables[2] is `amazon-affiliates`, the data I want is contained in tables[1].

# cleaning the data
tables[2] <- NULL  # remove tables[2], which is table$`amazon-affiliates`

# renamed tables[[1]]
movie_df <- tables[[1]]

# rearrange the data
colnames(movie_df)[1] <- "YearRelease"
colnames(movie_df)[2] <- "Title"
colnames(movie_df)[4] <- "MovieID"
movie_df[5] <- NULL

movie_df[,1] <- str_extract (movie_df[,2], "[[:digit:]]{4}")
movie_df[,2] <- str_extract (movie_df[,2], "[[:alpha:] [:punct:]]{2,}")


# get top 6 movies  
movie_top6 <- movie_df[1:6,]
movie_top6[,4] <- c(1, 2, 3, 4, 5, 6)
```

**Create friends table**

``` r
# create friends table
x <- 1:5
y <- c('Ming', 'Hao', 'Alison', 'Eran', 'Orshi')
FriendsTable <- data.frame(FriendsID=x,FriendsName=y)
kable(FriendsTable)
```

|  FriendsID| FriendsName |
|----------:|:------------|
|          1| Ming        |
|          2| Hao         |
|          3| Alison      |
|          4| Eran        |
|          5| Orshi       |

**Create pretended rating table**

Because not all my friends haven seen the those top 6 movies, they could not help me to rate the movies. SO what I have to do is to create a pretended rating table.

``` r
# generate a series of pretended rating from my friends
a <- c(0, 0.5, -0.5)
set.seed(1)
b<- sample(rep(a,10))

set.seed(2)
c <- sample (1.5:4.5, replace=T, 30)

rating <- b+c

# friend ID
e <- nrow(movie_top6)
fr.ID <- c(rep(1, e),rep(2,e),rep(3,e),rep(4,e),rep(5,e))

# moive ID
mo.ID <- rep(1:6,5)

# friend name
fr.Name <- c(rep('Ming',6),rep('Hao',6),rep('Alison',6),rep('Eran',6),rep('Orshi',6))

# movie name
mo.name<- rep(movie_top6$Title,5)

MainTable <- data.frame(MovieID=mo.ID, MovieName=mo.name, FriendID=fr.ID, FriendName=fr.Name, FriendRating=rating)
kable(MainTable)
```

|  MovieID| MovieName                    |  FriendID| FriendName |  FriendRating|
|--------:|:-----------------------------|---------:|:-----------|-------------:|
|        1| The Fate of the Furious      |         1| Ming       |           2.0|
|        2| Star Wars: The Last Jedi     |         1| Ming       |           4.0|
|        3| Guardians of the Galaxy Vol. |         1| Ming       |           4.0|
|        4| Thor: Ragnarok               |         1| Ming       |           1.5|
|        5| Beauty and the Beast         |         1| Ming       |           4.0|
|        6| Logan                        |         1| Ming       |           5.0|
|        1| The Fate of the Furious      |         2| Hao        |           1.0|
|        2| Star Wars: The Last Jedi     |         2| Hao        |           4.5|
|        3| Guardians of the Galaxy Vol. |         2| Hao        |           3.0|
|        4| Thor: Ragnarok               |         2| Hao        |           4.0|
|        5| Beauty and the Beast         |         2| Hao        |           4.0|
|        6| Logan                        |         2| Hao        |           1.5|
|        1| The Fate of the Furious      |         3| Alison     |           4.5|
|        2| Star Wars: The Last Jedi     |         3| Alison     |           1.5|
|        3| Guardians of the Galaxy Vol. |         3| Alison     |           2.0|
|        4| Thor: Ragnarok               |         3| Alison     |           4.0|
|        5| Beauty and the Beast         |         3| Alison     |           5.0|
|        6| Logan                        |         3| Alison     |           1.0|
|        1| The Fate of the Furious      |         4| Eran       |           3.0|
|        2| Star Wars: The Last Jedi     |         4| Eran       |           1.0|
|        3| Guardians of the Galaxy Vol. |         4| Eran       |           3.5|
|        4| Thor: Ragnarok               |         4| Eran       |           2.0|
|        5| Beauty and the Beast         |         4| Eran       |           5.0|
|        6| Logan                        |         4| Eran       |           1.5|
|        1| The Fate of the Furious      |         5| Orshi      |           2.5|
|        2| Star Wars: The Last Jedi     |         5| Orshi      |           2.0|
|        3| Guardians of the Galaxy Vol. |         5| Orshi      |           1.5|
|        4| Thor: Ragnarok               |         5| Orshi      |           2.0|
|        5| Beauty and the Beast         |         5| Orshi      |           4.0|
|        6| Logan                        |         5| Orshi      |           1.5|

**Subset MainTable to generate top-6 movies table**

``` r
MovieTable <- data.frame(MovieID=movie_top6$MovieID, MovieName=movie_top6$Title)
kable(MovieTable)
```

|  MovieID| MovieName                    |
|--------:|:-----------------------------|
|        1| The Fate of the Furious      |
|        2| Star Wars: The Last Jedi     |
|        3| Guardians of the Galaxy Vol. |
|        4| Thor: Ragnarok               |
|        5| Beauty and the Beast         |
|        6| Logan                        |

Wirte tables to the database in MySQL
-------------------------------------

**Connect to MySQL local database and write the tables into the database.**

``` r
# connect to MySQL local database
movie_db <- dbConnect(MySQL(), user='root', password=mysql_pw, dbname='movie_rating', host='localhost')

# wirte table in the database
dbWriteTable(movie_db, name="Movie", value=MovieTable, overwrite=FALSE, append=TRUE)
```

    ## [1] TRUE

``` r
dbWriteTable(movie_db, name="Friends", value=FriendsTable, overwrite=FALSE, append=TRUE)
```

    ## [1] TRUE

``` r
dbWriteTable(movie_db, name="Rating", value=MainTable, overwrite=FALSE, append=TRUE)
```

    ## [1] TRUE

**check whether all tables have been imported into the database**

``` r
# list tables
dbListTables(movie_db)
```

    ## [1] "friends" "movie"   "rating"

``` r
dbListFields(movie_db, 'movie')
```

    ## [1] "row_names" "MovieID"   "MovieName"

``` r
dbListFields(movie_db, 'friends')
```

    ## [1] "row_names"   "FriendsID"   "FriendsName"

``` r
dbListFields(movie_db, 'rating')
```

    ## [1] "row_names"    "MovieID"      "MovieName"    "FriendID"    
    ## [5] "FriendName"   "FriendRating"

**Fetch table from MySQL the database**

``` r
#running queries 
rq.movie <- dbSendQuery(movie_db, "SELECT * FROM movie")

#retrieving data from MySQL
moive.data <- dbFetch(rq.movie, n=-1)
kable(moive.data)
```

| row\_names |  MovieID| MovieName                    |
|:-----------|--------:|:-----------------------------|
| 1          |        1| The Fate of the Furious      |
| 2          |        2| Star Wars: The Last Jedi     |
| 3          |        3| Guardians of the Galaxy Vol. |
| 4          |        4| Thor: Ragnarok               |
| 5          |        5| Beauty and the Beast         |
| 6          |        6| Logan                        |

``` r
#running queries 
rq.friend <- dbSendQuery(movie_db, "SELECT * FROM friends")

#retrieving data from MySQL
friend.data <- dbFetch(rq.friend, n=-1)
kable(friend.data)
```

| row\_names |  FriendsID| FriendsName |
|:-----------|----------:|:------------|
| 1          |          1| Ming        |
| 2          |          2| Hao         |
| 3          |          3| Alison      |
| 4          |          4| Eran        |
| 5          |          5| Orshi       |

``` r
#running queries 
rq.rating <- dbSendQuery(movie_db, "SELECT * FROM rating")

#retrieving data from MySQL
rating.data <- dbFetch(rq.rating, n=-1)
kable(rating.data)
```

| row\_names |  MovieID| MovieName                    |  FriendID| FriendName |  FriendRating|
|:-----------|--------:|:-----------------------------|---------:|:-----------|-------------:|
| 1          |        1| The Fate of the Furious      |         1| Ming       |           2.0|
| 2          |        2| Star Wars: The Last Jedi     |         1| Ming       |           4.0|
| 3          |        3| Guardians of the Galaxy Vol. |         1| Ming       |           4.0|
| 4          |        4| Thor: Ragnarok               |         1| Ming       |           1.5|
| 5          |        5| Beauty and the Beast         |         1| Ming       |           4.0|
| 6          |        6| Logan                        |         1| Ming       |           5.0|
| 7          |        1| The Fate of the Furious      |         2| Hao        |           1.0|
| 8          |        2| Star Wars: The Last Jedi     |         2| Hao        |           4.5|
| 9          |        3| Guardians of the Galaxy Vol. |         2| Hao        |           3.0|
| 10         |        4| Thor: Ragnarok               |         2| Hao        |           4.0|
| 11         |        5| Beauty and the Beast         |         2| Hao        |           4.0|
| 12         |        6| Logan                        |         2| Hao        |           1.5|
| 13         |        1| The Fate of the Furious      |         3| Alison     |           4.5|
| 14         |        2| Star Wars: The Last Jedi     |         3| Alison     |           1.5|
| 15         |        3| Guardians of the Galaxy Vol. |         3| Alison     |           2.0|
| 16         |        4| Thor: Ragnarok               |         3| Alison     |           4.0|
| 17         |        5| Beauty and the Beast         |         3| Alison     |           5.0|
| 18         |        6| Logan                        |         3| Alison     |           1.0|
| 19         |        1| The Fate of the Furious      |         4| Eran       |           3.0|
| 20         |        2| Star Wars: The Last Jedi     |         4| Eran       |           1.0|
| 21         |        3| Guardians of the Galaxy Vol. |         4| Eran       |           3.5|
| 22         |        4| Thor: Ragnarok               |         4| Eran       |           2.0|
| 23         |        5| Beauty and the Beast         |         4| Eran       |           5.0|
| 24         |        6| Logan                        |         4| Eran       |           1.5|
| 25         |        1| The Fate of the Furious      |         5| Orshi      |           2.5|
| 26         |        2| Star Wars: The Last Jedi     |         5| Orshi      |           2.0|
| 27         |        3| Guardians of the Galaxy Vol. |         5| Orshi      |           1.5|
| 28         |        4| Thor: Ragnarok               |         5| Orshi      |           2.0|
| 29         |        5| Beauty and the Beast         |         5| Orshi      |           4.0|
| 30         |        6| Logan                        |         5| Orshi      |           1.5|
