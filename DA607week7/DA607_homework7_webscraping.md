DA607\_homework7\_web\_scrapping
================
Yun Mai
March 18, 2017

Working with XML and JSON in R
------------------------------

Pick three of your favorite books on one of your favorite subjects. At least one of the books should have more than one author. For each book, include the title, authors, and two or three other attributes that you find interesting. Take the information that you've selected about these three books, and separately create three files which store the book's information in HTML (using an html table), XML, and JSON formats (e.g. "books.html", "books.xml", and "books.json").

To help you better understand the different file structures, I'd prefer that you create each of these files "by hand" unless you're already very comfortable with the file formats. Write R code, using your packages of choice, to load the information from each of the three sources into separate R data frames. Are the three data frames identical? Your deliverable is the three source files and the R code. If you can, package your assignment solution up into an .Rmd file and publish to rpubs.com. \[This will also require finding a way to make your three text files accessible from the web\].

**Load packages**

``` r
library(RCurl)
```

    ## Loading required package: bitops

``` r
library(XML)
library(jsonlite)
library(knitr)
library(plyr)
```

HTML format
===========

A table containing three books info in HTML format is created. The url is loaded to R. The HTML file is shown after the code.

``` r
html_url <- "https://raw.githubusercontent.com/YunMai-SPS/DA607-homework/master/DA607week7/week7hw_book_info_as_html.html"
fetch_html <- getURL(html_url)
parsed.book.html <- htmlParse(fetch_html)
print(parsed.book.html)
```

    ## <!DOCTYPE html>
    ## <html><body>
    ## <p>&gt;
    ##  
    ##    </p>
    ##     <title>Three Immunology Books</title>
    ## <table>
    ## <tr>
    ## <th>book id</th> <th>name</th> <th>authors</th> <th>eidtion</th> <th>pulisher</th> <th>language</th> <th>year published</th> <th>ISBN-13</th> <th>paperback</th> <th>Amazon Best Sellers Rank</th> </tr>
    ## <tr>
    ## <th>1</th> <th>KUBY Immunology</th> <th>Richard A. Goldsby, Thomas J. Kindt and Barbara A. Osborne</th> <th>7th</th> <th>W. H. Freeman</th> <th>English</th> <th>2013</th> <th>978-1464119910</th> <th>670 pages</th> <th>#8</th> </tr>
    ## <tr>
    ## <th>2</th> <th>Cellular and Molecular Immunology</th> <th>Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD</th> <th>8th</th> <th>Saunders</th> <th>English</th> <th>2014</th> <th>978-0323222754</th> <th>544 pages</th> <th>#59</th> </tr>
    ## <tr>
    ## <th>3</th> <th>How the Immune System Works</th> <th>Lauren M. Sompayrac</th> <th>5th</th> <th>Wiley-Blackwell</th> <th>English</th> <th>2015</th> <th>978-1118997772</th> <th>160 pages</th> <th>#17</th> </tr>
    ## </table>
    ## </body></html>
    ## 

Then read the data from html file as table. The readHTMLTable function maps the html data structure into a list.

``` r
book_html <- readHTMLTable(fetch_html)
class(book_html)
```

    ## [1] "list"

View the structure of the list. As shown after the code, it contains only one element which is a data frame.

``` r
str(book_html)
```

    ## List of 1
    ##  $ NULL:'data.frame':    3 obs. of  10 variables:
    ##   ..$ book id                 : Factor w/ 3 levels "1","2","3": 1 2 3
    ##   ..$ name                    : Factor w/ 3 levels "Cellular and Molecular Immunology",..: 3 1 2
    ##   ..$ authors                 : Factor w/ 3 levels "Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD",..: 3 1 2
    ##   ..$ eidtion                 : Factor w/ 3 levels "5th","7th","8th": 2 3 1
    ##   ..$ pulisher                : Factor w/ 3 levels "Saunders","W. H. Freeman",..: 2 1 3
    ##   ..$ language                : Factor w/ 1 level "English": 1 1 1
    ##   ..$ year published          : Factor w/ 3 levels "2013","2014",..: 1 2 3
    ##   ..$ ISBN-13                 : Factor w/ 3 levels "978-0323222754",..: 3 1 2
    ##   ..$ paperback               : Factor w/ 3 levels "160 pages","544 pages",..: 3 2 1
    ##   ..$ Amazon Best Sellers Rank: Factor w/ 3 levels "#17","#59","#8": 3 2 1

``` r
kable(book_html)
```

<table class="kable_wrapper">
<tbody>
<tr>
<td>
| book id | name                              | authors                                                                | eidtion | pulisher        | language | year published | ISBN-13        | paperback | Amazon Best Sellers Rank |
|:--------|:----------------------------------|:-----------------------------------------------------------------------|:--------|:----------------|:---------|:---------------|:---------------|:----------|:-------------------------|
| 1       | KUBY Immunology                   | Richard A. Goldsby, Thomas J. Kindt and Barbara A. Osborne             | 7th     | W. H. Freeman   | English  | 2013           | 978-1464119910 | 670 pages | \#8                      |
| 2       | Cellular and Molecular Immunology | Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD | 8th     | Saunders        | English  | 2014           | 978-0323222754 | 544 pages | \#59                     |
| 3       | How the Immune System Works       | Lauren M. Sompayrac                                                    | 5th     | Wiley-Blackwell | English  | 2015           | 978-1118997772 | 160 pages | \#17                     |

</td>
</tr>
</tbody>
</table>
The table is shown after the code.

``` r
kable(book_html[[1]])
```

| book id | name                              | authors                                                                | eidtion | pulisher        | language | year published | ISBN-13        | paperback | Amazon Best Sellers Rank |
|:--------|:----------------------------------|:-----------------------------------------------------------------------|:--------|:----------------|:---------|:---------------|:---------------|:----------|:-------------------------|
| 1       | KUBY Immunology                   | Richard A. Goldsby, Thomas J. Kindt and Barbara A. Osborne             | 7th     | W. H. Freeman   | English  | 2013           | 978-1464119910 | 670 pages | \#8                      |
| 2       | Cellular and Molecular Immunology | Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD | 8th     | Saunders        | English  | 2014           | 978-0323222754 | 544 pages | \#59                     |
| 3       | How the Immune System Works       | Lauren M. Sompayrac                                                    | 5th     | Wiley-Blackwell | English  | 2015           | 978-1118997772 | 160 pages | \#17                     |

XML format
==========

An XML file contained the books info is created. It will be shown after the code.

``` r
xml_url <- "https://raw.githubusercontent.com/YunMai-SPS/DA607-homework/master/DA607week7/week7hw_book_info_as_xml.xml"
fetch_xml <- getURL(xml_url)
parsed.book.xml <- xmlParse(fetch_xml)
parsed.book.xml
```

    ## <?xml version="1.0" encoding="ISO-8859-1"?>
    ## <immunology_books>
    ##   <book>
    ##     <bookid>1</bookid>
    ##     <name>KUBY Immunology</name>
    ##     <authors> Richard A. Goldsby, Thomas J. Kindt, Barbara A. Osborne</authors>
    ##     <eidtion>7th</eidtion>
    ##     <pulisher>W. H. Freeman</pulisher>
    ##     <Language>English</Language>
    ##     <yearpublished>2013</yearpublished>
    ##     <ISBN-13>978-1464119910</ISBN-13>
    ##     <paperback>670 pages</paperback>
    ##     <AmazonBestSellersRank>#8</AmazonBestSellersRank>
    ##   </book>
    ##   <book>
    ##     <bookid>2</bookid>
    ##     <name>Cellular and Molecular Immunology</name>
    ##     <authors> Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD</authors>
    ##     <eidtion>8th</eidtion>
    ##     <pulisher>Saunders</pulisher>
    ##     <Language>English</Language>
    ##     <yearpublished>2014</yearpublished>
    ##     <ISBN-13>978-0323222754</ISBN-13>
    ##     <paperback>544 pages</paperback>
    ##     <AmazonBestSellersRank>#59</AmazonBestSellersRank>
    ##   </book>
    ##   <book>
    ##     <bookid>3</bookid>
    ##     <name>How the Immune System Works</name>
    ##     <authors> Lauren M. Sompayrac</authors>
    ##     <eidtion>5th</eidtion>
    ##     <pulisher>Wiley-Blackwell</pulisher>
    ##     <Language>English</Language>
    ##     <yearpublished>2015</yearpublished>
    ##     <ISBN-13>978-1118997772</ISBN-13>
    ##     <paperback>160 pages</paperback>
    ##     <AmazonBestSellersRank>#17</AmazonBestSellersRank>
    ##   </book>
    ## </immunology_books>
    ## 

Then the top-level node of XML file is extracted with the xmlRoot() function and transformed into data frame with xmlToDataFrame() function. The xmlToDataFrame function maps the xml data structure into a data frame.

``` r
root <- xmlRoot(parsed.book.xml)
book_xml <- xmlToDataFrame(root)
class(book_xml)
```

    ## [1] "data.frame"

View the first few rows of the data frame.

``` r
kable(book_xml)
```

| bookid | name                              | authors                                                                | eidtion | pulisher        | Language | yearpublished | ISBN-13        | paperback | AmazonBestSellersRank |
|:-------|:----------------------------------|:-----------------------------------------------------------------------|:--------|:----------------|:---------|:--------------|:---------------|:----------|:----------------------|
| 1      | KUBY Immunology                   | Richard A. Goldsby, Thomas J. Kindt, Barbara A. Osborne                | 7th     | W. H. Freeman   | English  | 2013          | 978-1464119910 | 670 pages | \#8                   |
| 2      | Cellular and Molecular Immunology | Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD | 8th     | Saunders        | English  | 2014          | 978-0323222754 | 544 pages | \#59                  |
| 3      | How the Immune System Works       | Lauren M. Sompayrac                                                    | 5th     | Wiley-Blackwell | English  | 2015          | 978-1118997772 | 160 pages | \#17                  |

JSON format
===========

A JSON file contained the books info is created, as shown after the code.

``` r
json_url <- "https://raw.githubusercontent.com/YunMai-SPS/DA607-homework/master/DA607week7/week7hw_book_info_as_json.json"
fetch_json <- getURL(json_url)
fetch_json
```

    ## [1] "{\"Immunology books\" :[\n    {\n    \"book id\": 1,\n    \"name\": \"KUBY Immunology\",\n    \"authors\": \"Richard A. Goldsby, Thomas J. Kindt, Barbara A. Osborne\",\n    \"eidtion\": \"7th\",\n    \"pulisher\": \"W. H. Freeman\",\n    \"language\": \"English\",\n    \"year_published\": 2013,\n    \"ISBN-13\": \"978-1464119910\",\n    \"paperback\": \"670 pages\",\n    \"Amazon Best Sellers Rank\": \"#8\"\n    },\n    {\n    \"book id\": 2,\n    \"name\": \"Cellular and Molecular Immunology\",\n    \"authors\": \"Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD\",\n    \"eidtion\": \"8th\",\n    \"pulisher\": \"Saunders\",\n    \"language\": \"English\",\n    \"year_published\": 2014,\n    \"ISBN-13\": \"978-0323222754\",\n    \"paperback\": \"544 pages\",\n    \"Amazon Best Sellers Rank\": \"#59\"\n    },\n    {\n    \"book id\": 3,\n    \"name\": \"How the Immune System Works\",\n    \"authors\": \"Lauren M. Sompayrac\",\n    \"eidtion\": \"5th\",\n    \"pulisher\": \"Wiley-Blackwell\",\n    \"language\": \"English\",\n    \"year_published\": 2015,\n    \"ISBN-13\": \"978-1118997772\",\n    \"paperback\": \"160 pages\",\n    \"Amazon Best Sellers Rank\": \"#17\"\n    }]\n}\n\n"

Parse the JSON data with the fromJSON function. Under the rule of jsonlite, fromJSON function should map JSOn data into a data frame. It turned out to be a list.

``` r
parsed.book.json <- fromJSON(fetch_json)
class(parsed.book.json)
```

    ## [1] "list"

View the the structure of the list and it contains one element that is a data frame.

``` r
str(parsed.book.json)
```

    ## List of 1
    ##  $ Immunology books:'data.frame':    3 obs. of  10 variables:
    ##   ..$ book id                 : int [1:3] 1 2 3
    ##   ..$ name                    : chr [1:3] "KUBY Immunology" "Cellular and Molecular Immunology" "How the Immune System Works"
    ##   ..$ authors                 : chr [1:3] "Richard A. Goldsby, Thomas J. Kindt, Barbara A. Osborne" "Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD" "Lauren M. Sompayrac"
    ##   ..$ eidtion                 : chr [1:3] "7th" "8th" "5th"
    ##   ..$ pulisher                : chr [1:3] "W. H. Freeman" "Saunders" "Wiley-Blackwell"
    ##   ..$ language                : chr [1:3] "English" "English" "English"
    ##   ..$ year_published          : int [1:3] 2013 2014 2015
    ##   ..$ ISBN-13                 : chr [1:3] "978-1464119910" "978-0323222754" "978-1118997772"
    ##   ..$ paperback               : chr [1:3] "670 pages" "544 pages" "160 pages"
    ##   ..$ Amazon Best Sellers Rank: chr [1:3] "#8" "#59" "#17"

``` r
kable(parsed.book.json[[1]])
```

|  book id| name                              | authors                                                                | eidtion | pulisher        | language |  year\_published| ISBN-13        | paperback | Amazon Best Sellers Rank |
|--------:|:----------------------------------|:-----------------------------------------------------------------------|:--------|:----------------|:---------|----------------:|:---------------|:----------|:-------------------------|
|        1| KUBY Immunology                   | Richard A. Goldsby, Thomas J. Kindt, Barbara A. Osborne                | 7th     | W. H. Freeman   | English  |             2013| 978-1464119910 | 670 pages | \#8                      |
|        2| Cellular and Molecular Immunology | Abul K. Abbas MBBS, Andrew H. H. Lichtman MD PhD, Shiv Pillai MBBS PhD | 8th     | Saunders        | English  |             2014| 978-0323222754 | 544 pages | \#59                     |
|        3| How the Immune System Works       | Lauren M. Sompayrac                                                    | 5th     | Wiley-Blackwell | English  |             2015| 978-1118997772 | 160 pages | \#17                     |

**Conclusion: tables written in HTML and JSON are read into R as list objects, while XML table is parsed into R as data.frame object. HTML and JSON table is mapped to a data frame with well defined variables and observations and the data frame is stored in a list. kable function from knitr pacakge can draw a decent table for a data.frame type object but it does not map a list type object to a reader-friendly table, which are shown in the HTML part.**
