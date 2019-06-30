
# Data Wrangling {#dplyr}

## Learning Objectives

### Basic

1. Be able to use the 6 main dplyr one-table verbs:
    + [`select()`](#select)
    + [`filter()`](#filter)
    + [`arrange()`](#arrange)
    + [`mutate()`](#mutate)
    + [`summarise()`](#summarise)
    + [`group_by()`](#group_by)

### Intermediate

2. Also know these additional one-table verbs:
    + [`rename()`](#rename)
    + [`distinct()`](#distinct)
    + [`count()`](#count)
    + [`slice()`](#slice)
    + [`pull()`](#pull)
    
### Advanced

3. Fine control of [`select()` operations](#select_helpers)
4. Perform 'windowed' operations
    + windowed `mutate()`
    + windowed `slice()`

## Resources

* [Chapter 5: Data Transformation](http://r4ds.had.co.nz/transform.html) in *R for Data Science*
* [Data transformation cheat sheet](https://github.com/rstudio/cheatsheets/raw/master/source/pdfs/data-transformation-cheatsheet.pdf)
* [Lecture slides on dplyr one-table verbs](slides/04_dplyr_slides.pdf)
* [Chapter 16: Date and times](http://r4ds.had.co.nz/dates-and-times.html) in *R for Data Science*

## Setup

You'll need the following packages. 


```r
# libraries needed for these examples
library(lubridate)
library(tidyverse)
library(ukbabynames)
```


## The `disgust` dataset

These examples will use data from [disgust.csv](/data/disgust.csv), which contains data from the [Three Domain Disgust Scale](http://digitalrepository.unm.edu/cgi/viewcontent.cgi?article=1139&context=psy_etds). Each participant is identified by a unique `user_id` and each questionnaire completion has a unique `id`.


```r
disgust <- read_csv("https://psyteachr.github.io/msc-data-skills/data/disgust.csv")
```

*Questionnaire Instructions*: The following items describe a variety of concepts. Please rate how disgusting you find the concepts described in the items, where 0 means that you do not find the concept disgusting at all, and 6 means that you find the concept extremely disgusting.

| colname   | question                                                                          |
|----------:|:----------------------------------------------------------------------------------|
| moral1 	  | Shoplifting a candy bar from a convenience store                                  |
| moral2	  | Stealing from a neighbor                                                          |
| moral3	  | A student cheating to get good grades                                             |
| moral4	  | Deceiving a friend                                                                |
| moral5	  | Forging someone's signature on a legal document                                   |
| moral6	  | Cutting to the front of a line to purchase the last few tickets to a show         |
| moral7	  | Intentionally lying during a business transaction                                 |
| sexual1	  | Hearing two strangers having sex                                                  |
| sexual2	  | Performing oral sex                                                               |
| sexual3	  | Watching a pornographic video                                                     |
| sexual4	  | Finding out that someone you don't like has sexual fantasies about you            |
| sexual5	  | Bringing someone you just met back to your room to have sex                       |
| sexual6	  | A stranger of the opposite sex intentionally rubbing your thigh in an elevator    |
| sexual7	  | Having anal sex with someone of the opposite sex                                  |
| pathogen1	| Stepping on dog poop                                                              |
| pathogen2	| Sitting next to someone who has red sores on their arm                            |
| pathogen3	| Shaking hands with a stranger who has sweaty palms                                |
| pathogen4	| Seeing some mold on old leftovers in your refrigerator                            |
| pathogen5	| Standing close to a person who has body odor                                      |
| pathogen6	| Seeing a cockroach run across the floor                                           |
| pathogen7	| Accidentally touching a person's bloody cut                                       |
## Six main dplyr verbs

Most of the data wrangling you'll want to do with psychological data will involve the `tidyr` verbs you learned in [Chapter 3](#tidyr) and the six main `dplyr` verbs: `select`, `filter`, `arrange`, `mutate`, `summarise`, and `group_by`.

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

You can select columns based on criteria about the column names.{#select_helpers}

#### `starts_with()` {#starts_with}

Select columns that start with a character string.


```r
u <- disgust %>% select(starts_with("u"))
names(u)
```

```
## [1] "user_id"
```

#### `ends_with()` {#ends_with}

Select columns that end with a character string.


```r
firstq <- disgust %>% select(ends_with("1"))
names(firstq)
```

```
## [1] "moral1"    "sexual1"   "pathogen1"
```

#### `contains()` {#contains}

Select columns that contain a character string.


```r
pathogen <- disgust %>% select(contains("pathogen"))
names(pathogen)
```

```
## [1] "pathogen1" "pathogen2" "pathogen3" "pathogen4" "pathogen5" "pathogen6"
## [7] "pathogen7"
```

#### `num_range()` {#num_range}

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

Sometimes you need to exclude some participant IDs for reasons that can't be described in code. the `%in%` operator is useful here for testing if a column value is in a list. Surround the equation with parentheses and put `!` in front to test that a value is not in the list.


```r
no_researchers <- disgust %>%
  filter(!(user_id %in% c(1,2)))
```

#### Dates {#dates}

You can use the `lubridate` package to work with dates. For example, you can use the `year()` function to return just the year from the `date` column and then select only data collected in 2010.


```r
disgust2010 <- disgust  %>%
  filter(year(date) == 2010)
```

Or select data from at least 5 years ago. You can use the `range` function to check the minimum and maxiumum dates in the resulting dataset.


```r
disgust_5ago <- disgust %>%
  filter(date < today() - dyears(5))

range(disgust_5ago$date)
```

```
## [1] "2008-07-10" "2014-06-23"
```


### arrange() {#arrange}

Sort your dataset using `arrange()`.


```r
disgust_order <- disgust %>%
  arrange(id)

head(disgust_order)
```

```
## # A tibble: 6 x 24
##      id user_id date       moral1 moral2 moral3 moral4 moral5 moral6 moral7
##   <dbl>   <dbl> <date>      <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
## 1     1       1 2008-07-10      2      2      1      2      1      1      1
## 2     3  155324 2008-07-11      2      4      3      5      2      1      4
## 3     4  155366 2008-07-12      6      6      6      3      6      6      6
## 4     5  155370 2008-07-12      6      6      4      6      6      6      6
## 5     6  155386 2008-07-12      2      4      0      4      0      0      0
## 6     7  155409 2008-07-12      4      5      5      4      5      1      5
## # … with 14 more variables: sexual1 <dbl>, sexual2 <dbl>, sexual3 <dbl>,
## #   sexual4 <dbl>, sexual5 <dbl>, sexual6 <dbl>, sexual7 <dbl>,
## #   pathogen1 <dbl>, pathogen2 <dbl>, pathogen3 <dbl>, pathogen4 <dbl>,
## #   pathogen5 <dbl>, pathogen6 <dbl>, pathogen7 <dbl>
```

Reverse the order using `desc()`


```r
disgust_order <- disgust %>%
  arrange(desc(id))

head(disgust_order)
```

```
## # A tibble: 6 x 24
##      id user_id date       moral1 moral2 moral3 moral4 moral5 moral6 moral7
##   <dbl>   <dbl> <date>      <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
## 1 39456  356866 2017-08-21      1      1      1      1      1      1      1
## 2 39447  128727 2017-08-13      2      4      1      2      2      5      3
## 3 39371  152955 2017-06-13      6      6      3      6      6      6      6
## 4 39342   48303 2017-05-22      4      5      4      4      6      4      5
## 5 39159  151633 2017-04-04      4      5      6      5      3      6      2
## 6 38942  370464 2017-02-01      1      5      0      6      5      5      5
## # … with 14 more variables: sexual1 <dbl>, sexual2 <dbl>, sexual3 <dbl>,
## #   sexual4 <dbl>, sexual5 <dbl>, sexual6 <dbl>, sexual7 <dbl>,
## #   pathogen1 <dbl>, pathogen2 <dbl>, pathogen3 <dbl>, pathogen4 <dbl>,
## #   pathogen5 <dbl>, pathogen6 <dbl>, pathogen7 <dbl>
```


### mutate() {#mutate}

Add new columns. This is one of the most useful functions in the tidyverse.

Refer to other columns by their names (unquoted). You can add more than one column, just separate the columns with a comma. Once you make a new column, you can use it in further column definitions e.g., `total` below).


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

<div class="warning">
<p>You can overwrite a column by giving a new column the same name as the old column. Make sure that you mean to do this and that you aren’t trying to use the old column value after you redefine it.</p>
</div>

### summarise() {#summarise}

Create summary statistics for the dataset. Check the [Data Wrangling Cheat Sheet](https://www.rstudio.org/links/data_wrangling_cheat_sheet) or the [Data Transformation Cheat Sheet](https://github.com/rstudio/cheatsheets/raw/master/source/pdfs/data-transformation-cheatsheet.pdf) for various summary functions. Some common ones are: `mean()`, `sd()`, `n()`, `sum()`, and `quantile()`.


```r
disgust_total %>%
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

```
## # A tibble: 1 x 8
##       n   q25   q50   q75 avg_total sd_total min_total max_total
##   <int> <dbl> <dbl> <dbl>     <dbl>    <dbl>     <dbl>     <dbl>
## 1 20000    59    71    83      70.7     18.2         0       126
```


### group_by() {#group_by}

Create subsets of the data. You can use this to create summaries, 
like the mean value for all of your experimental groups.

Here, we'll use `mutate` to create a new column called `year`, group by `year`, and calculate the average scores.


```r
disgust_total %>%
  mutate(year = year(date)) %>%
  group_by(year) %>%
  summarise(
    n = n(),
    avg_total = mean(total, na.rm = TRUE),
    sd_total  = sd(total, na.rm = TRUE),
    min_total = min(total, na.rm = TRUE),
    max_total = max(total, na.rm = TRUE)
  )
```

```
## # A tibble: 10 x 6
##     year     n avg_total sd_total min_total max_total
##    <dbl> <int>     <dbl>    <dbl>     <dbl>     <dbl>
##  1  2008  2578      70.3     18.5         0       126
##  2  2009  2580      69.7     18.6         3       126
##  3  2010  1514      70.6     18.9         6       126
##  4  2011  6046      71.3     17.8         0       126
##  5  2012  5938      70.4     18.4         0       126
##  6  2013  1251      71.6     17.6         0       126
##  7  2014    58      70.5     17.2        19       113
##  8  2015    21      74.3     16.9        43       107
##  9  2016     8      67.9     32.6         0       110
## 10  2017     6      57.2     27.9        21        90
```

You can use `filter` after `group_by`. The following example returns the lowest total score from each year.


```r
disgust_total %>%
  mutate(year = year(date)) %>%
  select(user_id, year, total) %>%
  group_by(year) %>%
  filter(rank(total) == 1) %>%
  arrange(year)
```

```
## # A tibble: 7 x 3
## # Groups:   year [7]
##   user_id  year total
##   <chr>   <dbl> <dbl>
## 1 U236585  2009     3
## 2 U292359  2010     6
## 3 U245384  2013     0
## 4 U206293  2014    19
## 5 U407089  2015    43
## 6 U453237  2016     0
## 7 U356866  2017    21
```

You can also use `mutate` after `group_by`. The following example calculates subject-mean-centered scores by grouping the scores by `user_id` and then subtracting the group-specific mean from each score. <span class="text-warning">Note the use of `gather` to tidy the data into a long format first.</span>


```r
disgust_smc <- disgust %>%
  gather("question", "score", moral1:pathogen7) %>%
  group_by(user_id) %>%
  mutate(score_smc = score - mean(score, na.rm = TRUE))
```


### All Together

A lot of what we did above would be easier if the data were tidy, so let's do that first. Then we can use `group_by` to calculate the domain scores.

<div class="warning">
<p>It is good practice to use <code>ungroup()</code> after using <code>group_by</code> and <code>summarise</code>. Forgetting to ungroup the dataset won’t affect some further processing, but can really mess up other things.</p>
</div>

Then we can spread out the 3 domains, calculate the total score, remove any rows with a missing (`NA`) total, and calculate mean values by year.


```r
disgust_tidy <- read_csv("data/disgust.csv") %>%
  gather("question", "score", moral1:pathogen7) %>%
  separate(question, c("domain","q_num"), sep = -1) %>%
  group_by(id, user_id, date, domain) %>%
  summarise(score = mean(score)) %>%
  ungroup() 
```

```
## Parsed with column specification:
## cols(
##   .default = col_double(),
##   date = col_date(format = "")
## )
```

```
## See spec(...) for full column specifications.
```

```r
disgust_tidy2 <- disgust_tidy %>%
  spread(domain, score) %>%
  mutate(
    total = moral + sexual + pathogen,
    year = year(date)
  ) %>%
  filter(!is.na(total)) %>%
  arrange(user_id) 

disgust_tidy3 <- disgust_tidy2 %>%
  group_by(year) %>%
  summarise(
    n = n(),
    avg_pathogen = mean(pathogen),
    avg_moral = mean(moral),
    avg_sexual = mean(sexual),
    first_user = first(user_id),
    last_user = last(user_id)
  )

disgust_tidy3
```

```
## # A tibble: 10 x 7
##     year     n avg_pathogen avg_moral avg_sexual first_user last_user
##    <dbl> <int>        <dbl>     <dbl>      <dbl>      <dbl>     <dbl>
##  1  2008  2392         3.70      3.81       2.54          0    188708
##  2  2009  2410         3.67      3.76       2.53       6093    251959
##  3  2010  1418         3.73      3.84       2.51       5469    319641
##  4  2011  5586         3.76      3.81       2.63       4458    406569
##  5  2012  5375         3.74      3.77       2.55       2118    458194
##  6  2013  1222         3.77      3.91       2.55       7646    462428
##  7  2014    54         3.76      4          2.31      11090    461307
##  8  2015    19         3.78      4.45       2.38     102699    460283
##  9  2016     8         3.70      3.62       2.38       4976    453237
## 10  2017     6         3.07      3.69       1.40      48303    370464
```

## Additional dplyr one-table verbs

### rename() {#rename}

### distinct() {#distinct}

### count() {#count}

### slice() {#slide}

### pull() {#pull}

## Exercises

Download the [exercises](exercises/05_dplyr_exercise.Rmd). See the [answers](exercises/05_dplyr_answers.Rmd) only after you've attempted all the questions.
