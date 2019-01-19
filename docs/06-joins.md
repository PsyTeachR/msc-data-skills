# Data Relations {#joins}

## Learning Objectives {.tabset}

1. Be able to use the 4 mutating join verbs:
    + [`left_join()`](#left_join)
    + [`right_join()`](#right_join)
    + [`inner_join()`](#inner_join)
    + [`full_join()`](#full_join)
    
2. Be able to use the 2 binding join verbs:
    + [`bind_rows()`](#bind_rows)
    + [`bind_cols()`](#bind_cols)

3. Be able to use the 2 filtering join verbs:
    + [`semi_join()`](#semi_join)
    + [`anti_join()`](#anti_join)

4. Be able to use the 3 set operations:
    + [`intersect()`](#intersect)
    + [`union()`](#union)
    + [`setdiff()`](#setdiff)
    

## Prep

* Read [Chapter 13: Relational Data](http://r4ds.had.co.nz/relational-data.html) in *R for Data Science*


## Resources

* [Cheatsheet for dplyr join functions](http://stat545.com/bit001_dplyr-cheatsheet.html)

## Formative exercises

Download the [formative exercises](formative_exercises/06_joins_stub.Rmd). See the [answers](formative_exercises/06_joins_answers.Rmd) only after you've attempted all the questions.

## Class Notes

* [Lecture slides on dplyr two-table verbs](slides/05_joins_slides.pdf)

### Setup


```r
# libraries needed for these examples
library(tidyverse)
```

All the joins have this basic syntax:

`****_join(x, y, by = NULL, suffix = c(".x", ".y")`

* `x` = the first (left) table
* `y` = the second (right) table
* `by` = what columns to match on. If you leave this blank, it will match on all columns with the same names in the two tables.
* `suffix` = if columns have the same name in the two tables, but you aren't joining by them, they get a suffix to make them unambiguous. This defaults to ".x" and ".y", but you can change it to something more meaningful.

### Data

First, we'll create two small data tables. 

`subject` has id, sex and age for subjects 1-5. Age and sex are missing for subject 3.


```r
subject <- tibble(
  id = seq(1,5),
  sex = c("m", "m", NA, "f", "f"),
  age = c(19, 22, NA, 19, 18)
)

subject
```

```
## # A tibble: 5 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     1 m        19
## 2     2 m        22
## 3     3 <NA>     NA
## 4     4 f        19
## 5     5 f        18
```

`exp` has subject id and the score from an experiment. Some subjects are missing, 
some completed twice, and some are not in the subject table.


```r
exp <- tibble(
  id = c(2, 3, 4, 4, 5, 5, 6, 6, 7),
  score = c(10, 18, 21, 23, 9, 11, 11, 12, 3)
)

exp
```

```
## # A tibble: 9 x 2
##      id score
##   <dbl> <dbl>
## 1     2    10
## 2     3    18
## 3     4    21
## 4     4    23
## 5     5     9
## 6     5    11
## 7     6    11
## 8     6    12
## 9     7     3
```


### left_join()
<a name="left_join"></a>

<img src='images/joins/left_join.png' class='join'>
A `left_join` keeps all the data from the first (left) table and joins anything 
that matches from the second (right) table. If the right table has more than one match for 
a row in the right table, there will be more than one row in the joined table 
(see ids 4 and 5).


```r
left_join(subject, exp, by = "id")
```

```
## # A tibble: 7 x 4
##      id sex     age score
##   <dbl> <chr> <dbl> <dbl>
## 1     1 m        19    NA
## 2     2 m        22    10
## 3     3 <NA>     NA    18
## 4     4 f        19    21
## 5     4 f        19    23
## 6     5 f        18     9
## 7     5 f        18    11
```

You can leave out the `by` argument if you're matching on all of the columns with 
the same name, but it's good practice to always specify it so your code is robust 
to changes in the loaded data.

<img src='images/joins/left_join_rev.png' class='join'>
The order of tables is swapped here, so the result is all rows from the `exp` 
table joined to any matching rows from the `subject` table.


```r
left_join(exp, subject, by = "id")
```

```
## # A tibble: 9 x 4
##      id score sex     age
##   <dbl> <dbl> <chr> <dbl>
## 1     2    10 m        22
## 2     3    18 <NA>     NA
## 3     4    21 f        19
## 4     4    23 f        19
## 5     5     9 f        18
## 6     5    11 f        18
## 7     6    11 <NA>     NA
## 8     6    12 <NA>     NA
## 9     7     3 <NA>     NA
```

### right_join()
<a name="right_join"></a>

<img src='images/joins/right_join.png' class='join'>
A `right_join` keeps all the data from the second (right) table and joins anything 
that matches from the first (left) table. 


```r
right_join(subject, exp, by = "id")
```

```
## # A tibble: 9 x 4
##      id sex     age score
##   <dbl> <chr> <dbl> <dbl>
## 1     2 m        22    10
## 2     3 <NA>     NA    18
## 3     4 f        19    21
## 4     4 f        19    23
## 5     5 f        18     9
## 6     5 f        18    11
## 7     6 <NA>     NA    11
## 8     6 <NA>     NA    12
## 9     7 <NA>     NA     3
```

<p class="alert alert-info">This table has the same information as 
`left_join(exp, subject, by = "id")`, but the columns are in a different order 
(left table, then right table).</p>

### inner_join()
<a name="inner_join"></a>

<img src='images/joins/inner_join.png' class='join'>
An `inner_join` returns all the rows that have a match in the other table.


```r
inner_join(subject, exp, by = "id")
```

```
## # A tibble: 6 x 4
##      id sex     age score
##   <dbl> <chr> <dbl> <dbl>
## 1     2 m        22    10
## 2     3 <NA>     NA    18
## 3     4 f        19    21
## 4     4 f        19    23
## 5     5 f        18     9
## 6     5 f        18    11
```


### full_join()
<a name="full_join"></a>

<img src='images/joins/full_join.png' class='join'>
A `full_join` lets you join up rows in two tables while keeping all of the 
information from both tables. If a row doesn't have a match in the other table, 
the other table's column values are set to `NA`.


```r
full_join(subject, exp, by = "id")
```

```
## # A tibble: 10 x 4
##       id sex     age score
##    <dbl> <chr> <dbl> <dbl>
##  1     1 m        19    NA
##  2     2 m        22    10
##  3     3 <NA>     NA    18
##  4     4 f        19    21
##  5     4 f        19    23
##  6     5 f        18     9
##  7     5 f        18    11
##  8     6 <NA>     NA    11
##  9     6 <NA>     NA    12
## 10     7 <NA>     NA     3
```

### semi_join()
<a name="semi_join"></a>

<img src='images/joins/semi_join.png' class='join'>
A `semi_join` returns all rows from the left table where there are matching values 
in the right table, keeping just columns from the left table.


```r
semi_join(subject, exp, by = "id")
```

```
## # A tibble: 4 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     2 m        22
## 2     3 <NA>     NA
## 3     4 f        19
## 4     5 f        18
```

<p class="alert alert-info">Unlike an inner join, a semi join will never duplicate 
the rows in the left table if there is more than one maching row in the right table.</p>

<img src='images/joins/semi_join_rev.png' class='join'>
Order matters in a semi join.


```r
semi_join(exp, subject, by = "id")
```

```
## # A tibble: 6 x 2
##      id score
##   <dbl> <dbl>
## 1     2    10
## 2     3    18
## 3     4    21
## 4     4    23
## 5     5     9
## 6     5    11
```

### anti_join()
<a name="anti_join"></a>

<img src='images/joins/anti_join.png' class='join'>
A `anti_join` return all rows from the left table where there are *not* matching 
values in the right table, keeping just columns from the left table.


```r
anti_join(subject, exp, by = "id")
```

```
## # A tibble: 1 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     1 m        19
```

<img src='images/joins/anti_join_rev.png' class='join'>
Order matters in an anti join.


```r
anti_join(exp, subject, by = "id")
```

```
## # A tibble: 3 x 2
##      id score
##   <dbl> <dbl>
## 1     6    11
## 2     6    12
## 3     7     3
```

### bind_rows()
<a name="bind_rows"></a>

You can combine the rows of two tables with `bind_rows`.

Here we'll add subject data for subjects 6-9 and bind that to the original subject table.


```r
new_subjects <- tibble(
  id = seq(6, 9),
  sex = c("m", "m", "f", "f"),
  age = c(19, 16, 20, 19)
)

bind_rows(subject, new_subjects)
```

```
## # A tibble: 9 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     1 m        19
## 2     2 m        22
## 3     3 <NA>     NA
## 4     4 f        19
## 5     5 f        18
## 6     6 m        19
## 7     7 m        16
## 8     8 f        20
## 9     9 f        19
```

The columns just have to have the same names, they don't have to be in the same order. 
Any columns that differ between the two tables will just have `NA` values for entries 
from the other table.

If a row is duplicated between the two tables (like id 5 below), the row will also
be duplicated in the resulting table. If your tables have the exact same columns, 
you can use `union()` (see below) to avoid duplicates.


```r
new_subjects <- tibble(
  id = seq(5, 9),
  age = c(18, 19, 16, 20, 19),
  sex = c("f", "m", "m", "f", "f"),
  new = c(1,2,3,4,5)
)

bind_rows(subject, new_subjects)
```

```
## # A tibble: 10 x 4
##       id sex     age   new
##    <int> <chr> <dbl> <dbl>
##  1     1 m        19    NA
##  2     2 m        22    NA
##  3     3 <NA>     NA    NA
##  4     4 f        19    NA
##  5     5 f        18    NA
##  6     5 f        18     1
##  7     6 m        19     2
##  8     7 m        16     3
##  9     8 f        20     4
## 10     9 f        19     5
```

### bind_cols()
<a name="bind_cols"></a>

You can merge two tables with the same number of rows using `bind_cols`. This is 
only useful if the two tables have their rows in the exact same order. The only 
advantage over a left join is when the tables don't have any IDs to join by and 
you have to rely solely on their order.


```r
new_info <- tibble(
  colour = c("red", "orange", "yellow", "green", "blue")
)

bind_cols(subject, new_info)
```

```
## # A tibble: 5 x 4
##      id sex     age colour
##   <int> <chr> <dbl> <chr> 
## 1     1 m        19 red   
## 2     2 m        22 orange
## 3     3 <NA>     NA yellow
## 4     4 f        19 green 
## 5     5 f        18 blue
```

### intersect()
<a name="intersect"></a>

`intersect()` returns all rows in two tables that match exactly. The columns 
don't have to be in the same order.


```r
new_subjects <- tibble(
  id = seq(4, 9),
  age = c(19, 18, 19, 16, 20, 19),
  sex = c("f", "f", "m", "m", "f", "f")
)

dplyr::intersect(subject, new_subjects)
```

```
## # A tibble: 2 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     4 f        19
## 2     5 f        18
```


### union()
<a name="union"></a>

`union()` returns all the rows from both tables, removing duplicate rows.


```r
dplyr::union(subject, new_subjects)
```

```
## # A tibble: 9 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     9 f        19
## 2     8 f        20
## 3     7 m        16
## 4     6 m        19
## 5     5 f        18
## 6     4 f        19
## 7     3 <NA>     NA
## 8     2 m        22
## 9     1 m        19
```

### setdiff()
<a name="setdiff"></a>

`setdiff` returns rows that are in the first table, but not in the second table.


```r
setdiff(subject, new_subjects)
```

```
## # A tibble: 3 x 3
##      id   age sex  
##   <int> <dbl> <chr>
## 1     1    19 m    
## 2     2    22 m    
## 3     3    NA <NA>
```

Order matters for `setdiff`.


```r
setdiff(new_subjects, subject)
```

```
## # A tibble: 4 x 3
##      id sex     age
##   <int> <chr> <dbl>
## 1     6 m        19
## 2     7 m        16
## 3     8 f        20
## 4     9 f        19
```


<!--
## Example

### Load and process data

These data and cleaning code are from [Data cleaning](03_tidyr.html)


```r
# load country data from a CSV file on the web
library(readxl)
ccodes <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   `alpha-2` = col_character(),
##   `alpha-3` = col_character(),
##   `country-code` = col_character(),
##   `iso_3166-2` = col_character(),
##   region = col_character(),
##   `sub-region` = col_character(),
##   `intermediate-region` = col_character(),
##   `region-code` = col_character(),
##   `sub-region-code` = col_character(),
##   `intermediate-region-code` = col_character()
## )
```

```r
infmort <- read_csv("data/infmort.csv") %>%  # load infant mortality data from a CSV file
  separate(                                  # separate the stats column into its 3 parts
    3, 
    c("rate", "ci_low", "ci_hi"), 
    extra = "drop", 
    sep = "(\\[|-|])", 
    convert = TRUE
  )
```

```
## Parsed with column specification:
## cols(
##   Country = col_character(),
##   Year = col_double(),
##   `Infant mortality rate (probability of dying between birth and age 1 per 1000 live births)` = col_character()
## )
```

```r
matmort <- read_xls("data/matmort.xls") %>%   # load maternal mortality data from an excel file
  gather("Year", "stats", `1990`:`2015`) %>%  # convert to long format
  mutate(stats = gsub(" ", "", stats)) %>%    # get rid of spaces in stats column
  separate(                                   # separate the stats column into its 3 parts
    stats, 
    c("rate", "ci_low", "ci_hi"), 
    extra = "drop", 
    convert = TRUE
  )
```

```
## readxl works best with a newer version of the tibble package.
## You currently have tibble v1.4.2.
## Falling back to column name repair from tibble <= v1.4.2.
## Message displays once per session.
```

### inner_join()

`inner_join(x, y, by = NULL, suffix = c(".x", ".y")`


```r
infmatmort <- inner_join(matmort, infmort, by = c("Country", "Year"))
```

<pre><code>Error in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y, check_na_matches(na_matches)) : 
  Can't join on 'Year' x 'Year' because of incompatible types (character / integer)</code></pre>

#### Incompatible tpyes

Oops. `Year` is an integer type in `infmort` and a character type in `matmort`. 
We can fix that by adding `convert = TRUE` to the `gather` function.


```r
matmort <- read_xls("data/matmort.xls") %>%   
  gather("Year", "stats", `1990`:`2015`, convert = TRUE) %>%
  mutate(stats = gsub(" ", "", stats)) %>%
  separate(
    stats, 
    c("rate", "ci_low", "ci_hi"), 
    extra = "drop", 
    convert = TRUE
  )

infmatmort <- inner_join(matmort, infmort, by = c("Country", "Year"))

head(infmatmort)
```

```
## # A tibble: 6 x 8
##   Country      Year rate.x ci_low.x ci_hi.x rate.y ci_low.y ci_hi.y
##   <chr>       <dbl>  <int>    <int>   <int>  <dbl>    <dbl>   <dbl>
## 1 Afghanistan  1990   1340      878    1950  122.     112.    136. 
## 2 Albania      1990     71       58      88   35.1     31.3    39.2
## 3 Algeria      1990    216      141     327   39.7     37.1    42.3
## 4 Angola       1990   1160      627    2020  134.     120.    151  
## 5 Argentina    1990     72       64      80   24.4     24      24.9
## 6 Armenia      1990     58       51      65   42.5     39      46.4
```

#### Disambiguate duplicate column names with `suffix`

Maybe we shouldn't have given the rates and CIs the same names in the infant and 
maternal mortality tables if we were going to join them. We could fix that by 
changing the names in the `separate` functions to be unique. Here, we'll add the 
suffixes "_mat" and "_inf" to distinguish them.


```r
infmatmort <- inner_join(
  matmort, 
  infmort, 
  by = c("Country", "Year"),
  suffix = c("_mat", "_inf")
)

head(infmatmort)
```

```
## # A tibble: 6 x 8
##   Country  Year rate_mat ci_low_mat ci_hi_mat rate_inf ci_low_inf ci_hi_inf
##   <chr>   <dbl>    <int>      <int>     <int>    <dbl>      <dbl>     <dbl>
## 1 Afghan…  1990     1340        878      1950    122.       112.      136. 
## 2 Albania  1990       71         58        88     35.1       31.3      39.2
## 3 Algeria  1990      216        141       327     39.7       37.1      42.3
## 4 Angola   1990     1160        627      2020    134.       120.      151  
## 5 Argent…  1990       72         64        80     24.4       24        24.9
## 6 Armenia  1990       58         51        65     42.5       39        46.4
```

### full_join()

`full_join(x, y, by = NULL, suffix = c(".x", ".y")`

A full join lets you join up rows in two tables while keeping all of the 
information from both tables. If a row doesn't have a match in the other table, 
the other table's column values are set to `NA`.


```r
infmatmort <- full_join(
  matmort, 
  infmort, 
  by = c("Country", "Year"),
  suffix = c("_mat", "_inf")
)

infmatmort %>% filter(Country == "Djibouti", Year < 1993)
```

```
## # A tibble: 3 x 8
##   Country  Year rate_mat ci_low_mat ci_hi_mat rate_inf ci_low_inf ci_hi_inf
##   <chr>   <dbl>    <int>      <int>     <int>    <dbl>      <dbl>     <dbl>
## 1 Djibou…  1990      517        291       907     92.7       81.2      106.
## 2 Djibou…  1992       NA         NA        NA     89.6       79        102.
## 3 Djibou…  1991       NA         NA        NA     91         80        104.
```

### left_join()

`left_join(x, y, by = NULL, suffix = c(".x", ".y")`

Use a `left_join()` if you want to keep all the data in the main (x, left) table 
and join data from another (y, right) table if it exists.

<p class="alert alert-warning">Notice that the `by` argument now needs to specify both the left 
and right tables' columns (`by = c("Country" = "name")`) because we're joining 
on columns that have different names.</p>



```r
infmatmort_region <- infmatmort %>%
  left_join(ccodes, by = c("Country" = "name"))

head(infmatmort_region)
```

```
## # A tibble: 6 x 18
##   Country  Year rate_mat ci_low_mat ci_hi_mat rate_inf ci_low_inf ci_hi_inf
##   <chr>   <dbl>    <int>      <int>     <int>    <dbl>      <dbl>     <dbl>
## 1 Afghan…  1990     1340        878      1950    122.       112.      136. 
## 2 Albania  1990       71         58        88     35.1       31.3      39.2
## 3 Algeria  1990      216        141       327     39.7       37.1      42.3
## 4 Angola   1990     1160        627      2020    134.       120.      151  
## 5 Argent…  1990       72         64        80     24.4       24        24.9
## 6 Armenia  1990       58         51        65     42.5       39        46.4
## # ... with 10 more variables: `alpha-2` <chr>, `alpha-3` <chr>,
## #   `country-code` <chr>, `iso_3166-2` <chr>, region <chr>,
## #   `sub-region` <chr>, `intermediate-region` <chr>, `region-code` <chr>,
## #   `sub-region-code` <chr>, `intermediate-region-code` <chr>
```

### right_join()

`right_join(x, y, by = NULL, suffix = c(".x", ".y")`

We really just wanted the region, not all the extra data from the country codes. 
We can just select the columns we want when we load the country codes data. 

If we start with the `ccodes` table, we can `right_join()` the `infmatmort` table, 
which is just the opposite of a left join (keeps all the data from the "right" 
joined table and any data from the "left" table that matches). 

<p class="alert alert-warning">Remember to switch 
the order of the `by` columns if they have different names in the main and 
optional data tables.</p>


```r
infmatmort_region <- ccodes %>%
  select(name, region) %>%
  right_join(infmatmort, by = c("name" = "Country"))

head(infmatmort_region)
```

```
## # A tibble: 6 x 9
##   name  region  Year rate_mat ci_low_mat ci_hi_mat rate_inf ci_low_inf
##   <chr> <chr>  <dbl>    <int>      <int>     <int>    <dbl>      <dbl>
## 1 Afgh… Asia    1990     1340        878      1950    122.       112. 
## 2 Alba… Europe  1990       71         58        88     35.1       31.3
## 3 Alge… Africa  1990      216        141       327     39.7       37.1
## 4 Ango… Africa  1990     1160        627      2020    134.       120. 
## 5 Arge… Ameri…  1990       72         64        80     24.4       24  
## 6 Arme… Asia    1990       58         51        65     42.5       39  
## # ... with 1 more variable: ci_hi_inf <dbl>
```


### Plot maternal vs infant mortality by region

So let's make a graph that we couldn't have easily made with 3 separate data tables


```r
infmatmort_region %>%
  filter(Year == 1990) %>%
  group_by(name, region) %>%
  summarise(
    matmort = mean(rate_mat),
    infmort = mean(rate_inf)
  ) %>%
  ggplot(aes(infmort, matmort, colour = region)) +
  geom_smooth(method = "lm") +
  geom_point() +
  facet_grid(.~region)
```

```
## Warning: Removed 13 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 13 rows containing missing values (geom_point).
```

<img src="06-joins_files/figure-html/unnamed-chunk-9-1.png" width="672" />
-->

## Exercises

### Mutating joins

Load data from [disgust_scores.csv](data/disgust_scores.csv), 
[personality_scores.csv](data/personality_scores.csv) and [users.csv](data/users.csv). 
Each participant is identified by a unique `user_id`.

1. Add participant data to the disgust table.

    <div class="solution"><button>Solution</button>
    
    ```r
    disgust <- read_csv("data/disgust_scores.csv")
    ocean <- read_csv("data/personality_scores.csv")
    user <- read_csv("data/users.csv")
    
    study1 <- left_join(disgust, user, by = "user_id")
    
    head(study1)
    ```
    
    ```
    ## # A tibble: 6 x 8
    ##      id user_id date       moral pathogen sexual sex    birthday  
    ##   <dbl>   <dbl> <date>     <dbl>    <dbl>  <dbl> <chr>  <date>    
    ## 1     1       1 2008-07-10  1.43     2.71  1.71  female 1976-11-18
    ## 2     3  155324 2008-07-11  3        2.57  1.86  female 1984-09-30
    ## 3     4  155366 2008-07-12  5.57     4     0.429 male   1982-04-09
    ## 4     5  155370 2008-07-12  5.71     4.86  4.71  female 1968-04-04
    ## 5     6  155386 2008-07-12  1.43     3.86  3.71  male   1983-04-22
    ## 6     7  155409 2008-07-12  4.14     4.14  1.57  male   1983-03-31
    ```
    </div>
    
    *Intermediate*: Calculate the age of each participant on the date they did the disgust questionnaire. Round to the nearest tenth of a year.
    
    <div class="solution"><button>Solution</button>
    
    ```r
    library(lubridate)
    
    study1_ages <- study1 %>%
      mutate(
        age = date - birthday,
        age_days = as.integer(age),
        age_years = round(age_days/365.25, 1)
      )
    
    study1_ages %>%
      select(date, birthday:age_years) %>%
      head()
    ```
    
    ```
    ## # A tibble: 6 x 5
    ##   date       birthday   age        age_days age_years
    ##   <date>     <date>     <time>        <int>     <dbl>
    ## 1 2008-07-10 1976-11-18 11557 days    11557      31.6
    ## 2 2008-07-11 1984-09-30  8685 days     8685      23.8
    ## 3 2008-07-12 1982-04-09  9591 days     9591      26.3
    ## 4 2008-07-12 1968-04-04 14709 days    14709      40.3
    ## 5 2008-07-12 1983-04-22  9213 days     9213      25.2
    ## 6 2008-07-12 1983-03-31  9235 days     9235      25.3
    ```
    </div>

2. Add the participant data to the disgust data, but have the columns from the participant table first.

    <div class="solution"><button>Solution</button>
    
    ```r
    study2 <- right_join(user, disgust, by = "user_id")
    head(study2)
    ```
    
    ```
    ## # A tibble: 6 x 8
    ##   user_id sex    birthday      id date       moral pathogen sexual
    ##     <dbl> <chr>  <date>     <dbl> <date>     <dbl>    <dbl>  <dbl>
    ## 1       1 female 1976-11-18     1 2008-07-10  1.43     2.71  1.71 
    ## 2  155324 female 1984-09-30     3 2008-07-11  3        2.57  1.86 
    ## 3  155366 male   1982-04-09     4 2008-07-12  5.57     4     0.429
    ## 4  155370 female 1968-04-04     5 2008-07-12  5.71     4.86  4.71 
    ## 5  155386 male   1983-04-22     6 2008-07-12  1.43     3.86  3.71 
    ## 6  155409 male   1983-03-31     7 2008-07-12  4.14     4.14  1.57
    ```
    </div>
    
    *Intermediate*: How many times was the disgust questionnaire completed by each sex?
    
    <div class="solution"><button>Solution</button>
    
    ```r
    study2 %>%
      group_by(sex) %>%
      summarise(n = n())
    ```
    
    ```
    ## # A tibble: 4 x 2
    ##   sex          n
    ##   <chr>    <int>
    ## 1 female   13886
    ## 2 intersex     3
    ## 3 male      6012
    ## 4 <NA>        99
    ```
    </div>
    
    *Advanced*: Make a graph of how many people completed the questionnaire each year.
    
    <div class="solution"><button>Solution</button>
    
    ```r
    study2 %>%
      mutate(year = substr(date, 1, 4)) %>%
      group_by(year) %>%
      summarise(times_completed = n()) %>%
      ggplot() +
      geom_col(aes(year, times_completed, fill = year)) +
      labs(
        x = "Year",
        y = "Times Completed"
      ) +
      guides(fill = FALSE)
    ```
    
    <img src="06-joins_files/figure-html/ex-2-a-1.png" width="672" />
    </div>

3. Create a table with only disgust and personality data from the same `user_id` collected on the same `date`.

    <div class="solution"><button>Solution</button>
    
    ```r
    study3 <- inner_join(disgust, ocean, by = c("user_id", "date"))
    head(study3)
    ```
    
    ```
    ## # A tibble: 6 x 11
    ##      id user_id date       moral pathogen sexual    Ag    Co    Ex    Ne
    ##   <dbl>   <dbl> <date>     <dbl>    <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1     3  155324 2008-07-11  3        2.57  1.86   4      3.3  4.89  2.38
    ## 2     6  155386 2008-07-12  1.43     3.86  3.71   3.14   2.6  4     0.25
    ## 3    17  155567 2008-07-14  5.57     4.71  2.57   5.29   5.7  3.89  1.12
    ## 4    18  155571 2008-07-14  2.71     6     4.43   3.71   3.8  4.56  2.25
    ## 5    21  155665 2008-07-15  4.14     4.14  3.43   2.86   1.8  4.67  3.12
    ## 6    22  155682 2008-07-15  2.71     3     0.714  3.43   3    3.56  1.38
    ## # ... with 1 more variable: Op <dbl>
    ```
    </div> 
    
    *Intermediate*: Join data from the same `user_id`, regardless of `date`. Does this give you the same data table as above?
    
    <div class="solution"><button>Solution</button>
    
    ```r
    study3_nodate <- inner_join(disgust, ocean, by = c("user_id"))
    head(study3_nodate)
    ```
    
    ```
    ## # A tibble: 6 x 12
    ##      id user_id date.x     moral pathogen sexual date.y        Ag    Co
    ##   <dbl>   <dbl> <date>     <dbl>    <dbl>  <dbl> <date>     <dbl> <dbl>
    ## 1     1       1 2008-07-10  1.43     2.71   1.71 2006-02-08  2.57   3  
    ## 2     3  155324 2008-07-11  3        2.57   1.86 2008-07-11  4      3.3
    ## 3     6  155386 2008-07-12  1.43     3.86   3.71 2008-07-12  3.14   2.6
    ## 4    17  155567 2008-07-14  5.57     4.71   2.57 2008-07-14  5.29   5.7
    ## 5    18  155571 2008-07-14  2.71     6      4.43 2008-07-14  3.71   3.8
    ## 6    20  124756 2008-07-14  5.43     5.14   2.71 2008-01-23  4.86   3.8
    ## # ... with 3 more variables: Ex <dbl>, Ne <dbl>, Op <dbl>
    ```
    </div> 
    

4. Create a table of the disgust and personality data with each `user_id:date` on a single row, containing _all_ of the data from both tables.

    <div class="solution"><button>Solution</button>
    
    ```r
    study4 <- full_join(disgust, ocean, by = c("user_id", "date"))
    head(study4)
    ```
    
    ```
    ## # A tibble: 6 x 11
    ##      id user_id date       moral pathogen sexual    Ag    Co    Ex    Ne
    ##   <dbl>   <dbl> <date>     <dbl>    <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1     1       1 2008-07-10  1.43     2.71  1.71  NA     NA   NA    NA   
    ## 2     3  155324 2008-07-11  3        2.57  1.86   4      3.3  4.89  2.38
    ## 3     4  155366 2008-07-12  5.57     4     0.429 NA     NA   NA    NA   
    ## 4     5  155370 2008-07-12  5.71     4.86  4.71  NA     NA   NA    NA   
    ## 5     6  155386 2008-07-12  1.43     3.86  3.71   3.14   2.6  4     0.25
    ## 6     7  155409 2008-07-12  4.14     4.14  1.57  NA     NA   NA    NA   
    ## # ... with 1 more variable: Op <dbl>
    ```
    </div>

### Filtering joins

5. Create a table of just the data from the disgust table for users who completed the personality questionnaire that same day.

    <div class="solution"><button>Solution</button>
    
    ```r
    study5 <- semi_join(disgust, ocean, by = c("user_id", "date"))
    head(study5)
    ```
    
    ```
    ## # A tibble: 6 x 6
    ##      id user_id date       moral pathogen sexual
    ##   <dbl>   <dbl> <date>     <dbl>    <dbl>  <dbl>
    ## 1     3  155324 2008-07-11  3        2.57  1.86 
    ## 2     6  155386 2008-07-12  1.43     3.86  3.71 
    ## 3    17  155567 2008-07-14  5.57     4.71  2.57 
    ## 4    18  155571 2008-07-14  2.71     6     4.43 
    ## 5    21  155665 2008-07-15  4.14     4.14  3.43 
    ## 6    22  155682 2008-07-15  2.71     3     0.714
    ```
    </div>
    
6. Create a table of data from users who did not complete either the personality questionnaire or the disgust questionnaire. (_Hint: this will require two steps; use pipes._)

    <div class="solution"><button>Solution</button>
    
    ```r
    study6 <- user %>%
      anti_join(ocean, by = "user_id") %>%
      anti_join(disgust, by = "user_id")
    head(study6)
    ```
    
    ```
    ## # A tibble: 6 x 3
    ##   user_id sex    birthday  
    ##     <dbl> <chr>  <date>    
    ## 1       9 male   1972-01-19
    ## 2      10 female 1978-06-20
    ## 3      17 female 1981-11-21
    ## 4      19 female 1980-08-08
    ## 5      20 male   1964-08-27
    ## 6      21 male   1945-06-13
    ```
    </div>

### Binding and sets

7. Load new user data from [users2.csv](data/users2.csv). Bind them into a single table.

    <div class="solution"><button>Solution</button>
    
    ```r
    user2 <- read_csv("data/users2.csv")
    users_all <- bind_rows(user, user2)
    head(users_all)
    ```
    
    ```
    ## # A tibble: 6 x 3
    ##   user_id sex    birthday  
    ##     <dbl> <chr>  <date>    
    ## 1       0 <NA>   NA        
    ## 2       1 female 1976-11-18
    ## 3       2 male   1985-10-09
    ## 4       5 male   1980-06-26
    ## 5       8 male   1968-06-21
    ## 6       9 male   1972-01-19
    ```
    </div>

8. How many users are in both the first and second user table?

    <div class="solution"><button>Solution</button>
    
    ```r
    dplyr::intersect(user, user2) %>% nrow()
    ```
    
    ```
    ## [1] 11602
    ```
    </div>

9. How many unique users are there in total across the first and second user tables?

    <div class="solution"><button>Solution</button>
    
    ```r
    dplyr::union(user, user2) %>% nrow()
    ```
    
    ```
    ## [1] 100441
    ```
    </div>

10. How many users are in the first, but not the second, user table?

    <div class="solution"><button>Solution</button>
    
    ```r
    dplyr::setdiff(user, user2) %>% nrow()
    ```
    
    ```
    ## [1] 40441
    ```
    </div>

11. How many users are in the second, but not the first, user table?

    <div class="solution"><button>Solution</button>
    
    ```r
    dplyr::setdiff(user2, user) %>% nrow()
    ```
    
    ```
    ## [1] 48398
    ```
    </div>
