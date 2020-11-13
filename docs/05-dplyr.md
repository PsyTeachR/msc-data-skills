# Data Wrangling {#dplyr}

<img src="images/memes/real_world_data.jpg" class="meme right" 
     alt="A cute golden retriever labelled 'iris & mtcars' and a scary werewolf labelled 'Real world data'">

## Learning Objectives {#ilo5}

### Basic

1. Be able to use the 6 main dplyr one-table verbs: [(video)](https://youtu.be/l12tNKClTR0){class="video"}
    + [`select()`](#select)
    + [`filter()`](#filter)
    + [`arrange()`](#arrange)
    + [`mutate()`](#mutate)
    + [`summarise()`](#summarise)
    + [`group_by()`](#group_by)
2. Be able to [wrangle data by chaining tidyr and dplyr functions](#all-together) [(video)](https://youtu.be/hzFFAkwrkqA){class="video"} 
3. Be able to use these additional one-table verbs: [(video)](https://youtu.be/GmfF162mq4g){class="video"}
    + [`rename()`](#rename)
    + [`distinct()`](#distinct)
    + [`count()`](#count)
    + [`slice()`](#slice)
    + [`pull()`](#pull)

### Intermediate

4. Fine control of [`select()` operations](#select_helpers) [(video)](https://youtu.be/R1bi1QwF9t0){class="video"}
5. Use [window functions](#window) [(video)](https://youtu.be/uo4b0W9mqPc){class="video"}

## Resources {#resources5}

* [Chapter 5: Data Transformation](http://r4ds.had.co.nz/transform.html) in *R for Data Science*
* [Data transformation cheat sheet](https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf)
* [Chapter 16: Date and times](http://r4ds.had.co.nz/dates-and-times.html) in *R for Data Science*

## Setup {#setup5}


```r
# libraries needed for these examples
library(tidyverse)
library(lubridate)
library(dataskills)
set.seed(8675309) # makes sure random numbers are reproducible
```


### The `disgust` dataset {#data-disgust}

These examples will use data from `dataskills::disgust`, which contains data from the [Three Domain Disgust Scale](http://digitalrepository.unm.edu/cgi/viewcontent.cgi?article=1139&context=psy_etds). Each participant is identified by a unique `user_id` and each questionnaire completion has a unique `id`. Look at the Help for this dataset to see the individual questions.


```r
data("disgust", package = "dataskills")

#disgust <- read_csv("https://psyteachr.github.io/msc-data-skills/data/disgust.csv")
```


## Six main dplyr verbs

Most of the <a class='glossary' target='_blank' title='The process of preparing data for visualisation and statistical analysis.' href='https://psyteachr.github.io/glossary/d#data-wrangling'>data wrangling</a> you'll want to do with psychological data will involve the `tidyr` functions you learned in [Chapter 4](#tidyr) and the six main `dplyr` verbs: `select`, `filter`, `arrange`, `mutate`, `summarise`, and `group_by`.

### select() {#select}

Select columns by name or number.

You can select each column individually, separated by commas (e.g., `col1, col2`). You can also select all columns between two columns by separating them with a colon (e.g., `start_col:end_col`).


```r
moral <- disgust %>% select(user_id, moral1:moral7)
names(moral)
```

```
## [1] "user_id" "moral1"  "moral2"  "moral3"  "moral4"  "moral5"  "moral6" 
## [8] "moral7"
```

You can select columns by number, which is useful when the column names are long or complicated.


```r
sexual <- disgust %>% select(2, 11:17)
names(sexual)
```

```
## [1] "user_id" "sexual1" "sexual2" "sexual3" "sexual4" "sexual5" "sexual6"
## [8] "sexual7"
```

You can use a minus symbol to unselect columns, leaving all of the other columns. If you want to exclude a span of columns, put parentheses around the span first (e.g., `-(moral1:moral7)`, not `-moral1:moral7`).


```r
pathogen <- disgust %>% select(-id, -date, -(moral1:sexual7))
names(pathogen)
```

```
## [1] "user_id"   "pathogen1" "pathogen2" "pathogen3" "pathogen4" "pathogen5"
## [7] "pathogen6" "pathogen7"
```

#### Select helpers {#select_helpers}

You can select columns based on criteria about the column names.

##### `starts_with()` {#starts_with}

Select columns that start with a character string.


```r
u <- disgust %>% select(starts_with("u"))
names(u)
```

```
## [1] "user_id"
```

##### `ends_with()` {#ends_with}

Select columns that end with a character string.


```r
firstq <- disgust %>% select(ends_with("1"))
names(firstq)
```

```
## [1] "moral1"    "sexual1"   "pathogen1"
```

##### `contains()` {#contains}

Select columns that contain a character string.


```r
pathogen <- disgust %>% select(contains("pathogen"))
names(pathogen)
```

```
## [1] "pathogen1" "pathogen2" "pathogen3" "pathogen4" "pathogen5" "pathogen6"
## [7] "pathogen7"
```

##### `num_range()` {#num_range}

Select columns with a name that matches the pattern `prefix`.


```r
moral2_4 <- disgust %>% select(num_range("moral", 2:4))
names(moral2_4)
```

```
## [1] "moral2" "moral3" "moral4"
```

<div class="info">
<p>Use <code>width</code> to set the number of digits with leading zeros. For example, <code>num_range('var_', 8:10, width=2)</code> selects columns <code>var_08</code>, <code>var_09</code>, and <code>var_10</code>.</p>
</div>

### filter() {#filter}

Select rows by matching column criteria.

Select all rows where the user_id is 1 (that's Lisa). 


```r
disgust %>% filter(user_id == 1)
```

```
## # A tibble: 1 x 24
##      id user_id date       moral1 moral2 moral3 moral4 moral5 moral6 moral7
##   <dbl>   <dbl> <date>      <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
## 1     1       1 2008-07-10      2      2      1      2      1      1      1
## # … with 14 more variables: sexual1 <dbl>, sexual2 <dbl>, sexual3 <dbl>,
## #   sexual4 <dbl>, sexual5 <dbl>, sexual6 <dbl>, sexual7 <dbl>,
## #   pathogen1 <dbl>, pathogen2 <dbl>, pathogen3 <dbl>, pathogen4 <dbl>,
## #   pathogen5 <dbl>, pathogen6 <dbl>, pathogen7 <dbl>
```

<div class="warning">
<p>Remember to use <code>==</code> and not <code>=</code> to check if two things are equivalent. A single <code>=</code> assigns the righthand value to the lefthand variable and (usually) evaluates to <code>TRUE</code>.</p>
</div>

You can select on multiple criteria by separating them with commas.


```r
amoral <- disgust %>% filter(
  moral1 == 0, 
  moral2 == 0,
  moral3 == 0, 
  moral4 == 0,
  moral5 == 0,
  moral6 == 0,
  moral7 == 0
)
```

You can use the symbols `&`, `|`, and `!` to mean "and", "or", and "not". You can also use other operators to make equations.


```r
# everyone who chose either 0 or 7 for question moral1
moral_extremes <- disgust %>% 
  filter(moral1 == 0 | moral1 == 7)

# everyone who chose the same answer for all moral questions
moral_consistent <- disgust %>% 
  filter(
    moral2 == moral1 & 
    moral3 == moral1 & 
    moral4 == moral1 &
    moral5 == moral1 &
    moral6 == moral1 &
    moral7 == moral1
  )

# everyone who did not answer 7 for all 7 moral questions
moral_no_ceiling <- disgust %>%
  filter(moral1+moral2+moral3+moral4+moral5+moral6+moral7 != 7*7)
```

#### Match operator (%in%) {#match-operator}

Sometimes you need to exclude some participant IDs for reasons that can't be described in code. The match operator (`%in%`) is useful here for testing if a column value is in a list. Surround the equation with parentheses and put `!` in front to test that a value is not in the list.


```r
no_researchers <- disgust %>%
  filter(!(user_id %in% c(1,2)))
```


#### Dates {#dates}

You can use the `lubridate` package to work with dates. For example, you can use the `year()` function to return just the year from the `date` column and then select only data collected in 2010.


```r
disgust2010 <- disgust %>%
  filter(year(date) == 2010)
```



Table: (\#tab:dates-year)Rows 1-6 from `disgust2010`

|   id| user_id|date       | moral1| moral2| moral3| moral4| moral5| moral6| moral7| sexual1| sexual2| sexual3| sexual4| sexual5| sexual6| sexual7| pathogen1| pathogen2| pathogen3| pathogen4| pathogen5| pathogen6| pathogen7|
|----:|-------:|:----------|------:|------:|------:|------:|------:|------:|------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|
| 6902|    5469|2010-12-06 |      0|      1|      3|      4|      1|      0|      1|       3|       5|       2|       4|       6|       6|       5|         5|         2|         4|         4|         2|         2|         6|
| 6158|    6066|2010-04-18 |      4|      5|      6|      5|      5|      4|      4|       3|       0|       1|       6|       3|       5|       3|         6|         5|         5|         5|         5|         5|         5|
| 6362|    7129|2010-06-09 |      4|      4|      4|      4|      3|      3|      2|       4|       2|       1|       3|       2|       3|       6|         5|         2|         0|         4|         5|         5|         4|
| 6302|   39318|2010-05-20 |      2|      4|      1|      4|      5|      6|      0|       1|       0|       0|       1|       0|       0|       1|         3|         2|         3|         2|         3|         2|         4|
| 5429|   43029|2010-01-02 |      1|      1|      1|      3|      6|      4|      2|       2|       0|       1|       4|       6|       6|       6|         4|         6|         6|         6|         6|         6|         4|
| 6732|   71955|2010-10-15 |      2|      5|      3|      6|      3|      2|      5|       4|       3|       3|       6|       6|       6|       5|         4|         2|         6|         5|         6|         6|         3|




Or select data from at least 5 years ago. You can use the `range` function to check the minimum and maximum dates in the resulting dataset.


```r
disgust_5ago <- disgust %>%
  filter(date < today() - dyears(5))

range(disgust_5ago$date)
```

```
## [1] "2008-07-10" "2015-11-13"
```


### arrange() {#arrange}

Sort your dataset using `arrange()`. You will find yourself needing to sort data in R much less than you do in Excel, since you don't need to have rows next to each other in order to, for example, calculate group means. But `arrange()` can be useful when preparing data from display in tables.


```r
disgust_order <- disgust %>%
  arrange(date, moral1)
```



Table: (\#tab:arrange)Rows 1-6 from `disgust_order`

| id| user_id|date       | moral1| moral2| moral3| moral4| moral5| moral6| moral7| sexual1| sexual2| sexual3| sexual4| sexual5| sexual6| sexual7| pathogen1| pathogen2| pathogen3| pathogen4| pathogen5| pathogen6| pathogen7|
|--:|-------:|:----------|------:|------:|------:|------:|------:|------:|------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|
|  1|       1|2008-07-10 |      2|      2|      1|      2|      1|      1|      1|       3|       1|       1|       2|       1|       2|       2|         3|         2|         3|         3|         2|         3|         3|
|  3|  155324|2008-07-11 |      2|      4|      3|      5|      2|      1|      4|       1|       0|       1|       2|       2|       6|       1|         4|         3|         1|         0|         4|         4|         2|
|  6|  155386|2008-07-12 |      2|      4|      0|      4|      0|      0|      0|       6|       0|       0|       6|       4|       4|       6|         4|         5|         5|         1|         6|         4|         2|
|  7|  155409|2008-07-12 |      4|      5|      5|      4|      5|      1|      5|       3|       0|       1|       5|       2|       0|       0|         5|         5|         3|         4|         4|         2|         6|
|  4|  155366|2008-07-12 |      6|      6|      6|      3|      6|      6|      6|       0|       0|       0|       0|       0|       0|       3|         4|         4|         5|         5|         4|         6|         0|
|  5|  155370|2008-07-12 |      6|      6|      4|      6|      6|      6|      6|       2|       6|       4|       3|       6|       6|       6|         6|         6|         6|         2|         4|         4|         6|



Reverse the order using `desc()`


```r
disgust_order_desc <- disgust %>%
  arrange(desc(date))
```



Table: (\#tab:arrange-desc)Rows 1-6 from `disgust_order_desc`

|    id| user_id|date       | moral1| moral2| moral3| moral4| moral5| moral6| moral7| sexual1| sexual2| sexual3| sexual4| sexual5| sexual6| sexual7| pathogen1| pathogen2| pathogen3| pathogen4| pathogen5| pathogen6| pathogen7|
|-----:|-------:|:----------|------:|------:|------:|------:|------:|------:|------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|
| 39456|  356866|2017-08-21 |      1|      1|      1|      1|      1|      1|      1|       1|       1|       1|       1|       1|       1|       1|         1|         1|         1|         1|         1|         1|         1|
| 39447|  128727|2017-08-13 |      2|      4|      1|      2|      2|      5|      3|       0|       0|       1|       0|       0|       2|       1|         2|         0|         2|         1|         1|         1|         1|
| 39371|  152955|2017-06-13 |      6|      6|      3|      6|      6|      6|      6|       1|       0|       0|       2|       1|       4|       4|         5|         0|         5|         4|         3|         6|         3|
| 39342|   48303|2017-05-22 |      4|      5|      4|      4|      6|      4|      5|       2|       1|       4|       1|       1|       3|       1|         5|         5|         4|         4|         4|         4|         5|
| 39159|  151633|2017-04-04 |      4|      5|      6|      5|      3|      6|      2|       6|       4|       0|       4|       0|       3|       6|         4|         4|         6|         6|         6|         6|         4|
| 38942|  370464|2017-02-01 |      1|      5|      0|      6|      5|      5|      5|       0|       0|       0|       0|       0|       0|       0|         5|         0|         3|         3|         1|         6|         3|




### mutate() {#mutate}

Add new columns. This is one of the most useful functions in the tidyverse.

Refer to other columns by their names (unquoted). You can add more than one column in the same mutate function, just separate the columns with a comma. Once you make a new column, you can use it in further column definitions e.g., `total` below).


```r
disgust_total <- disgust %>%
  mutate(
    pathogen = pathogen1 + pathogen2 + pathogen3 + pathogen4 + pathogen5 + pathogen6 + pathogen7,
    moral = moral1 + moral2 + moral3 + moral4 + moral5 + moral6 + moral7,
    sexual = sexual1 + sexual2 + sexual3 + sexual4 + sexual5 + sexual6 + sexual7,
    total = pathogen + moral + sexual,
    user_id = paste0("U", user_id)
  )
```



Table: (\#tab:mutate)Rows 1-6 from `disgust_total`

|    id|user_id |date       | moral1| moral2| moral3| moral4| moral5| moral6| moral7| sexual1| sexual2| sexual3| sexual4| sexual5| sexual6| sexual7| pathogen1| pathogen2| pathogen3| pathogen4| pathogen5| pathogen6| pathogen7| pathogen| moral| sexual| total|
|-----:|:-------|:----------|------:|------:|------:|------:|------:|------:|------:|-------:|-------:|-------:|-------:|-------:|-------:|-------:|---------:|---------:|---------:|---------:|---------:|---------:|---------:|--------:|-----:|------:|-----:|
|  1199|U0      |2008-10-07 |      5|      6|      4|      6|      5|      5|      6|       4|       0|       1|       0|       1|       4|       5|         6|         1|         6|         5|         4|         5|         6|       33|    37|     15|    85|
|     1|U1      |2008-07-10 |      2|      2|      1|      2|      1|      1|      1|       3|       1|       1|       2|       1|       2|       2|         3|         2|         3|         3|         2|         3|         3|       19|    10|     12|    41|
|  1599|U2      |2008-10-27 |      1|      1|      1|      1|     NA|     NA|      1|       1|      NA|       1|      NA|       1|      NA|      NA|        NA|        NA|         1|        NA|        NA|        NA|        NA|       NA|    NA|     NA|    NA|
| 13332|U2118   |2012-01-02 |      0|      1|      1|      1|      1|      2|      1|       4|       3|       0|       6|       0|       3|       5|         5|         6|         4|         6|         5|         5|         4|       35|     7|     21|    63|
|    23|U2311   |2008-07-15 |      4|      4|      4|      4|      4|      4|      4|       2|       1|       2|       1|       1|       1|       5|         5|         5|         4|         4|         5|         4|         3|       30|    28|     13|    71|
|  1160|U3630   |2008-10-06 |      1|      5|     NA|      5|      5|      5|      1|       0|       5|       0|       2|       0|       1|       0|         6|         3|         1|         1|         3|         1|         0|       15|    NA|      8|    NA|



<div class="warning">
<p>You can overwrite a column by giving a new column the same name as the old column (see <code>user_id</code>) above. Make sure that you mean to do this and that you aren’t trying to use the old column value after you redefine it.</p>
</div>


### summarise() {#summarise}

Create summary statistics for the dataset. Check the [Data Wrangling Cheat Sheet](https://www.rstudio.org/links/data_wrangling_cheat_sheet) or the [Data Transformation Cheat Sheet](https://github.com/rstudio/cheatsheets/raw/master/source/pdfs/data-transformation-cheatsheet.pdf) for various summary functions. Some common ones are: `mean()`, `sd()`, `n()`, `sum()`, and `quantile()`.


```r
disgust_summary<- disgust_total %>%
  summarise(
    n = n(),
    q25 = quantile(total, .25, na.rm = TRUE),
    q50 = quantile(total, .50, na.rm = TRUE),
    q75 = quantile(total, .75, na.rm = TRUE),
    avg_total = mean(total, na.rm = TRUE),
    sd_total  = sd(total, na.rm = TRUE),
    min_total = min(total, na.rm = TRUE),
    max_total = max(total, na.rm = TRUE)
  )
```



Table: (\#tab:summarise)All rows from `disgust_summary`

|     n| q25| q50| q75| avg_total| sd_total| min_total| max_total|
|-----:|---:|---:|---:|---------:|--------:|---------:|---------:|
| 20000|  59|  71|  83|   70.6868| 18.24253|         0|       126|




### group_by() {#group_by}

Create subsets of the data. You can use this to create summaries, 
like the mean value for all of your experimental groups.

Here, we'll use `mutate` to create a new column called `year`, group by `year`, and calculate the average scores.


```r
disgust_groups <- disgust_total %>%
  mutate(year = year(date)) %>%
  group_by(year) %>%
  summarise(
    n = n(),
    avg_total = mean(total, na.rm = TRUE),
    sd_total  = sd(total, na.rm = TRUE),
    min_total = min(total, na.rm = TRUE),
    max_total = max(total, na.rm = TRUE),
    .groups = "drop"
  )
```



Table: (\#tab:group-by)All rows from `disgust_groups`

| year|    n| avg_total| sd_total| min_total| max_total|
|----:|----:|---------:|--------:|---------:|---------:|
| 2008| 2578|  70.29975| 18.46251|         0|       126|
| 2009| 2580|  69.74481| 18.61959|         3|       126|
| 2010| 1514|  70.59238| 18.86846|         6|       126|
| 2011| 6046|  71.34425| 17.79446|         0|       126|
| 2012| 5938|  70.42530| 18.35782|         0|       126|
| 2013| 1251|  71.59574| 17.61375|         0|       126|
| 2014|   58|  70.46296| 17.23502|        19|       113|
| 2015|   21|  74.26316| 16.89787|        43|       107|
| 2016|    8|  67.87500| 32.62531|         0|       110|
| 2017|    6|  57.16667| 27.93862|        21|        90|



<div class="warning">
<p>If you don’t add <code>.groups = "drop"</code> at the end of the <code>summarise()</code> function, you will get the following message: “<code>summarise()</code> ungrouping output (override with <code>.groups</code> argument)”. This just reminds you that the groups are still in effect and any further functions will also be grouped.</p>
<p>Older versions of dplyr didn’t do this, so older code will generate this warning if you run it with newer version of dplyr. Older code might <code>ungroup()</code> after <code>summarise()</code> to indicate that groupings should be dropped. The default behaviour is usually correct, so you don’t need to worry, but it’s best to explicitly set <code>.groups</code> in a <code>summarise()</code> function after <code>group_by()</code> if you want to “keep” or “drop” the groupings.</p>
</div>

You can use `filter` after `group_by`. The following example returns the lowest total score from each year (i.e., the row where the `rank()` of the value in the column `total` is equivalent to `1`).


```r
disgust_lowest <- disgust_total %>%
  mutate(year = year(date)) %>%
  select(user_id, year, total) %>%
  group_by(year) %>%
  filter(rank(total) == 1) %>%
  arrange(year)
```



Table: (\#tab:group-by-filter)All rows from `disgust_lowest`

|user_id | year| total|
|:-------|----:|-----:|
|U236585 | 2009|     3|
|U292359 | 2010|     6|
|U245384 | 2013|     0|
|U206293 | 2014|    19|
|U407089 | 2015|    43|
|U453237 | 2016|     0|
|U356866 | 2017|    21|



You can also use `mutate` after `group_by`. The following example calculates subject-mean-centered scores by grouping the scores by `user_id` and then subtracting the group-specific mean from each score. <span class="text-warning">Note the use of `gather` to tidy the data into a long format first.</span>


```r
disgust_smc <- disgust %>%
  gather("question", "score", moral1:pathogen7) %>%
  group_by(user_id) %>%
  mutate(score_smc = score - mean(score, na.rm = TRUE)) %>% 
  ungroup()
```

<div class="warning">
<p>Use <code>ungroup()</code> as soon as you are done with grouped functions, otherwise the data table will still be grouped when you use it in the future.</p>
</div>



Table: (\#tab:unnamed-chunk-5)Rows 1-6 from `disgust_smc`

|    id| user_id|date       |question | score|  score_smc|
|-----:|-------:|:----------|:--------|-----:|----------:|
|  1199|       0|2008-10-07 |moral1   |     5|  0.9523810|
|     1|       1|2008-07-10 |moral1   |     2|  0.0476190|
|  1599|       2|2008-10-27 |moral1   |     1|  0.0000000|
| 13332|    2118|2012-01-02 |moral1   |     0| -3.0000000|
|    23|    2311|2008-07-15 |moral1   |     4|  0.6190476|
|  1160|    3630|2008-10-06 |moral1   |     1| -1.2500000|




### All Together {#all-together}

A lot of what we did above would be easier if the data were tidy, so let's do that first. Then we can use `group_by` to calculate the domain scores.

After that, we can spread out the 3 domains, calculate the total score, remove any rows with a missing (`NA`) total, and calculate mean values by year.


```r
disgust_tidy <- dataskills::disgust %>%
  gather("question", "score", moral1:pathogen7) %>%
  separate(question, c("domain","q_num"), sep = -1) %>%
  group_by(id, user_id, date, domain) %>%
  summarise(score = mean(score), .groups = "drop")
```



Table: (\#tab:all-tidy)Rows 1-6 from `disgust_tidy`

| id| user_id|date       |domain   |    score|
|--:|-------:|:----------|:--------|--------:|
|  1|       1|2008-07-10 |moral    | 1.428571|
|  1|       1|2008-07-10 |pathogen | 2.714286|
|  1|       1|2008-07-10 |sexual   | 1.714286|
|  3|  155324|2008-07-11 |moral    | 3.000000|
|  3|  155324|2008-07-11 |pathogen | 2.571429|
|  3|  155324|2008-07-11 |sexual   | 1.857143|




```r
disgust_scored <- disgust_tidy %>%
  spread(domain, score) %>%
  mutate(
    total = moral + sexual + pathogen,
    year = year(date)
  ) %>%
  filter(!is.na(total)) %>%
  arrange(user_id) 
```



Table: (\#tab:all-scored)Rows 1-6 from `disgust_scored`

|    id| user_id|date       |    moral| pathogen|   sexual|     total| year|
|-----:|-------:|:----------|--------:|--------:|--------:|---------:|----:|
|  1199|       0|2008-10-07 | 5.285714| 4.714286| 2.142857| 12.142857| 2008|
|     1|       1|2008-07-10 | 1.428571| 2.714286| 1.714286|  5.857143| 2008|
| 13332|    2118|2012-01-02 | 1.000000| 5.000000| 3.000000|  9.000000| 2012|
|    23|    2311|2008-07-15 | 4.000000| 4.285714| 1.857143| 10.142857| 2008|
|  7980|    4458|2011-09-05 | 3.428571| 3.571429| 3.000000| 10.000000| 2011|
|   552|    4651|2008-08-23 | 3.857143| 4.857143| 4.285714| 13.000000| 2008|




```r
disgust_summarised <- disgust_scored %>%
  group_by(year) %>%
  summarise(
    n = n(),
    avg_pathogen = mean(pathogen),
    avg_moral = mean(moral),
    avg_sexual = mean(sexual),
    first_user = first(user_id),
    last_user = last(user_id),
    .groups = "drop"
  )
```



Table: (\#tab:all-summarised)Rows 1-6 from `disgust_summarised`

| year|    n| avg_pathogen| avg_moral| avg_sexual| first_user| last_user|
|----:|----:|------------:|---------:|----------:|----------:|---------:|
| 2008| 2392|     3.697265|  3.806259|   2.539298|          0|    188708|
| 2009| 2410|     3.674333|  3.760937|   2.528275|       6093|    251959|
| 2010| 1418|     3.731412|  3.843139|   2.510075|       5469|    319641|
| 2011| 5586|     3.756918|  3.806506|   2.628612|       4458|    406569|
| 2012| 5375|     3.740465|  3.774591|   2.545701|       2118|    458194|
| 2013| 1222|     3.771920|  3.906944|   2.549100|       7646|    462428|
| 2014|   54|     3.759259|  4.000000|   2.306878|      11090|    461307|
| 2015|   19|     3.781955|  4.451128|   2.375940|     102699|    460283|
| 2016|    8|     3.696429|  3.625000|   2.375000|       4976|    453237|
| 2017|    6|     3.071429|  3.690476|   1.404762|      48303|    370464|



## Additional dplyr one-table verbs

Use the code examples below and the help pages to figure out what the following one-table verbs do. Most have pretty self-explanatory names.

### rename() {#rename}

You can rename columns with `rename()`. Set the argument name to the new name, and the value to the old name. You need to put a name in quotes or backticks if it doesn't follow the rules for a good variable name (contains only letter, numbers, underscores, and full stops; and doesn't start with a number).


```r
sw <- starwars %>%
  rename(Name = name,
         Height = height,
         Mass = mass,
         `Hair Colour` = hair_color,
         `Skin Colour` = skin_color,
         `Eye Colour` = eye_color,
         `Birth Year` = birth_year)

names(sw)
```

```
##  [1] "Name"        "Height"      "Mass"        "Hair Colour" "Skin Colour"
##  [6] "Eye Colour"  "Birth Year"  "sex"         "gender"      "homeworld"  
## [11] "species"     "films"       "vehicles"    "starships"
```


<div class="try">
<p>Almost everyone gets confused at some point with <code>rename()</code> and tries to put the original names on the left and the new names on the right. Try it and see what the error message looks like.</p>
</div>

### distinct() {#distinct}

Get rid of exactly duplicate rows with `distinct()`. This can be helpful if, for example, you are merging data from multiple computers and some of the data got copied from one computer to another, creating duplicate rows.


```r
# create a data table with duplicated values
dupes <- tibble(
  id = c( 1,   2,   1,   2,   1,   2),
  dv = c("A", "B", "C", "D", "A", "B")
)

distinct(dupes)
```

```
## # A tibble: 4 x 2
##      id dv   
##   <dbl> <chr>
## 1     1 A    
## 2     2 B    
## 3     1 C    
## 4     2 D
```

### count() {#count}

The function `count()` is a quick shortcut for the common combination of `group_by()` and `summarise()` used to count the number of rows per group.


```r
starwars %>%
  group_by(sex) %>%
  summarise(n = n(), .groups = "drop")
```

```
## # A tibble: 5 x 2
##   sex                n
##   <chr>          <int>
## 1 female            16
## 2 hermaphroditic     1
## 3 male              60
## 4 none               6
## 5 <NA>               4
```


```r
count(starwars, sex)
```

```
## # A tibble: 5 x 2
##   sex                n
##   <chr>          <int>
## 1 female            16
## 2 hermaphroditic     1
## 3 male              60
## 4 none               6
## 5 <NA>               4
```


### slice() {#slice}


```r
slice(starwars, 1:3, 10)
```

```
## # A tibble: 4 x 14
##   name  height  mass hair_color skin_color eye_color birth_year sex   gender
##   <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> <chr> 
## 1 Luke…    172    77 blond      fair       blue              19 male  mascu…
## 2 C-3PO    167    75 <NA>       gold       yellow           112 none  mascu…
## 3 R2-D2     96    32 <NA>       white, bl… red               33 none  mascu…
## 4 Obi-…    182    77 auburn, w… fair       blue-gray         57 male  mascu…
## # … with 5 more variables: homeworld <chr>, species <chr>, films <list>,
## #   vehicles <list>, starships <list>
```

### pull() {#pull}


```r
starwars %>%
  filter(species == "Droid") %>%
  pull(name)
```

```
## [1] "C-3PO"  "R2-D2"  "R5-D4"  "IG-88"  "R4-P17" "BB8"
```


## Window functions {#window}

Window functions use the order of rows to calculate values. You can use them to do things that require ranking or ordering, like choose the top scores in each class, or accessing the previous and next rows, like calculating cumulative sums or means.

The [dplyr window functions vignette](https://dplyr.tidyverse.org/articles/window-functions.html) has very good detailed explanations of these functions, but we've described a few of the most useful ones below. 

### Ranking functions


```r
grades <- tibble(
  id = 1:5,
  "Data Skills" = c(16, 17, 17, 19, 20), 
  "Statistics"  = c(14, 16, 18, 18, 19)
) %>%
  gather(class, grade, 2:3) %>%
  group_by(class) %>%
  mutate(row_number = row_number(),
         rank       = rank(grade),
         min_rank   = min_rank(grade),
         dense_rank = dense_rank(grade),
         quartile   = ntile(grade, 4),
         percentile = ntile(grade, 100))
```



Table: (\#tab:unnamed-chunk-7)All rows from `grades`

| id|class       | grade| row_number| rank| min_rank| dense_rank| quartile| percentile|
|--:|:-----------|-----:|----------:|----:|--------:|----------:|--------:|----------:|
|  1|Data Skills |    16|          1|  1.0|        1|          1|        1|          1|
|  2|Data Skills |    17|          2|  2.5|        2|          2|        1|          2|
|  3|Data Skills |    17|          3|  2.5|        2|          2|        2|          3|
|  4|Data Skills |    19|          4|  4.0|        4|          3|        3|          4|
|  5|Data Skills |    20|          5|  5.0|        5|          4|        4|          5|
|  1|Statistics  |    14|          1|  1.0|        1|          1|        1|          1|
|  2|Statistics  |    16|          2|  2.0|        2|          2|        1|          2|
|  3|Statistics  |    18|          3|  3.5|        3|          3|        2|          3|
|  4|Statistics  |    18|          4|  3.5|        3|          3|        3|          4|
|  5|Statistics  |    19|          5|  5.0|        5|          4|        4|          5|



<div class="try">
<ul>
<li>What are the differences among <code>row_number()</code>, <code>rank()</code>, <code>min_rank()</code>, <code>dense_rank()</code>, and <code>ntile()</code>?</li>
<li>Why doesn’t <code>row_number()</code> need an argument?</li>
<li>What would happen if you gave it the argument <code>grade</code> or <code>class</code>?</li>
<li>What do you think would happen if you removed the <code>group_by(class)</code> line above?</li>
<li>What if you added <code>id</code> to the grouping?</li>
<li>What happens if you change the order of the rows?</li>
<li>What does the second argument in <code>ntile()</code> do?</li>
</ul>
</div>

You can use window functions to group your data into quantiles.


```r
sw_mass <- starwars %>%
  group_by(tertile = ntile(mass, 3)) %>%
  summarise(min = min(mass),
            max = max(mass),
            mean = mean(mass),
            .groups = "drop")
```



Table: (\#tab:unnamed-chunk-9)All rows from `sw_mass`

| tertile| min|  max|     mean|
|-------:|---:|----:|--------:|
|       1|  15|   68|  45.6600|
|       2|  74|   82|  78.4100|
|       3|  83| 1358| 171.5789|
|      NA|  NA|   NA|       NA|



<div class="try">
<p>Why is there a row of <code>NA</code> values? How would you get rid of them?</p>
</div>


### Offset functions

The function `lag()` gives a previous row's value. It defaults to 1 row back, but you can change that with the `n` argument. The function `lead()` gives values ahead of the current row.


```r
lag_lead <- tibble(x = 1:6) %>%
  mutate(lag = lag(x),
         lag2 = lag(x, n = 2),
         lead = lead(x, default = 0))
```



Table: (\#tab:unnamed-chunk-11)All rows from `lag_lead`

|  x| lag| lag2| lead|
|--:|---:|----:|----:|
|  1|  NA|   NA|    2|
|  2|   1|   NA|    3|
|  3|   2|    1|    4|
|  4|   3|    2|    5|
|  5|   4|    3|    6|
|  6|   5|    4|    0|



You can use offset functions to calculate change between trials or where a value changes. Use the `order_by` argument to specify the order of the rows. Alternatively, you can use `arrange()` before the offset functions.


```r
trials <- tibble(
  trial = sample(1:10, 10),
  cond = sample(c("exp", "ctrl"), 10, T),
  score = rpois(10, 4)
) %>%
  mutate(
    score_change = score - lag(score, order_by = trial),
    change_cond = cond != lag(cond, order_by = trial, 
                              default = "no condition")
  ) %>%
  arrange(trial)
```



Table: (\#tab:offset-adv)All rows from `trials`

| trial|cond | score| score_change|change_cond |
|-----:|:----|-----:|------------:|:-----------|
|     1|ctrl |     8|           NA|TRUE        |
|     2|ctrl |     4|           -4|FALSE       |
|     3|exp  |     6|            2|TRUE        |
|     4|ctrl |     2|           -4|TRUE        |
|     5|ctrl |     3|            1|FALSE       |
|     6|ctrl |     6|            3|FALSE       |
|     7|ctrl |     2|           -4|FALSE       |
|     8|exp  |     4|            2|TRUE        |
|     9|ctrl |     4|            0|TRUE        |
|    10|exp  |     3|           -1|TRUE        |



<div class="try">
<p>Look at the help pages for <code>lag()</code> and <code>lead()</code>.</p>
<ul>
<li>What happens if you remove the <code>order_by</code> argument or change it to <code>cond</code>?</li>
<li>What does the <code>default</code> argument do?</li>
<li>Can you think of circumstances in your own data where you might need to use <code>lag()</code> or <code>lead()</code>?</li>
</ul>
</div>

### Cumulative aggregates

`cumsum()`, `cummin()`, and `cummax()` are base R functions for calculating cumulative means, minimums, and maximums. The dplyr package introduces `cumany()` and `cumall()`, which return `TRUE` if any or all of the previous values meet their criteria.


```r
cumulative <- tibble(
  time = 1:10,
  obs = c(2, 2, 1, 2, 4, 3, 1, 0, 3, 5)
) %>%
  mutate(
    cumsum = cumsum(obs),
    cummin = cummin(obs),
    cummax = cummax(obs),
    cumany = cumany(obs == 3),
    cumall = cumall(obs < 4)
  )
```



Table: (\#tab:unnamed-chunk-13)All rows from `cumulative`

| time| obs| cumsum| cummin| cummax|cumany |cumall |
|----:|---:|------:|------:|------:|:------|:------|
|    1|   2|      2|      2|      2|FALSE  |TRUE   |
|    2|   2|      4|      2|      2|FALSE  |TRUE   |
|    3|   1|      5|      1|      2|FALSE  |TRUE   |
|    4|   2|      7|      1|      2|FALSE  |TRUE   |
|    5|   4|     11|      1|      4|FALSE  |FALSE  |
|    6|   3|     14|      1|      4|TRUE   |FALSE  |
|    7|   1|     15|      1|      4|TRUE   |FALSE  |
|    8|   0|     15|      0|      4|TRUE   |FALSE  |
|    9|   3|     18|      0|      4|TRUE   |FALSE  |
|   10|   5|     23|      0|      5|TRUE   |FALSE  |



<div class="try">
<ul>
<li>What would happen if you change <code>cumany(obs == 3)</code> to <code>cumany(obs &gt; 2)</code>?</li>
<li>What would happen if you change <code>cumall(obs &lt; 4)</code> to <code>cumall(obs &lt; 2)</code>?</li>
<li>Can you think of circumstances in your own data where you might need to use <code>cumany()</code> or <code>cumall()</code>?</li>
</ul>
</div>

## Glossary {#glossary5}



|term                                                                                                                |definition                                                                |
|:-------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/d#data.wrangling'>data wrangling</a> |The process of preparing data for visualisation and statistical analysis. |



## Exercises {#exercises5}

Download the [exercises](exercises/05_dplyr_exercise.Rmd). See the [answers](exercises/05_dplyr_answers.Rmd) only after you've attempted all the questions.


```r
# run this to access the exercise
dataskills::exercise(5)

# run this to access the answers
dataskills::exercise(5, answers = TRUE)
```
