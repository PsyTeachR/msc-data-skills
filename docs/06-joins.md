# Data Relations {#joins}

<img src="images/memes/joins.png" class="meme right"
     alt="3-panel meme. 1: dog looks at a baby in a chair, text reads 'An SQL query goes into a bar, walks up to two tables and asks...'; 2: baby looks at dog, text reads 'Can I join you?'; 3: dog and baby look at camera, no text">

## Learning Objectives {#ilo6}

1. Be able to use the 4 mutating join verbs: [(video)](https://youtu.be/WV0yg6f3DNM){class="video"}
    + [`left_join()`](#left_join)
    + [`right_join()`](#right_join)
    + [`inner_join()`](#inner_join)
    + [`full_join()`](#full_join)
2. Be able to use the 2 filtering join verbs: [(video)](https://youtu.be/ijoCEKifefQ){class="video"}
    + [`semi_join()`](#semi_join)
    + [`anti_join()`](#anti_join)
3. Be able to use the 2 binding join verbs: [(video)](https://youtu.be/8RWdNhbVZ4I){class="video"}
    + [`bind_rows()`](#bind_rows)
    + [`bind_cols()`](#bind_cols)
4. Be able to use the 3 set operations: [(video)](https://youtu.be/c3V33ElWUYI){class="video"}
    + [`intersect()`](#intersect)
    + [`union()`](#union)
    + [`setdiff()`](#setdiff)

## Resources {#resources6}

* [Chapter 13: Relational Data](http://r4ds.had.co.nz/relational-data.html) in *R for Data Science*
* [Cheatsheet for dplyr join functions](http://stat545.com/bit001_dplyr-cheatsheet.html)
* [Lecture slides on dplyr two-table verbs](slides/05_joins_slides.pdf)

## Setup {#setup6}


```r
# libraries needed
library(tidyverse)
```

## Data

First, we'll create two small data tables. 

`subject` has id, gender and age for subjects 1-5. Age and gender are missing for subject 3.


```r
subject <- tibble(
  id = 1:5,
  gender = c("m", "m", NA, "nb", "f"),
  age = c(19, 22, NA, 19, 18)
)
```



| id|gender | age|
|--:|:------|---:|
|  1|m      |  19|
|  2|m      |  22|
|  3|NA     |  NA|
|  4|nb     |  19|
|  5|f      |  18|



`exp` has subject id and the score from an experiment. Some subjects are missing, some completed twice, and some are not in the subject table.


```r
exp <- tibble(
  id = c(2, 3, 4, 4, 5, 5, 6, 6, 7),
  score = c(10, 18, 21, 23, 9, 11, 11, 12, 3)
)
```



| id| score|
|--:|-----:|
|  2|    10|
|  3|    18|
|  4|    21|
|  4|    23|
|  5|     9|
|  5|    11|
|  6|    11|
|  6|    12|
|  7|     3|




## Mutating Joins

<a class='glossary' target='_blank' title='Joins that act like the dplyr::mutate() function in that they add new columns to one table based on values in another table.' href='https://psyteachr.github.io/glossary/m#mutating-joins'>Mutating joins</a> act like the `mutate()` function in that they add new columns to one table based on values in another table.  

All the mutating joins have this basic syntax:

`****_join(x, y, by = NULL, suffix = c(".x", ".y")`

* `x` = the first (left) table
* `y` = the second (right) table
* `by` = what columns to match on. If you leave this blank, it will match on all columns with the same names in the two tables.
* `suffix` = if columns have the same name in the two tables, but you aren't joining by them, they get a suffix to make them unambiguous. This defaults to ".x" and ".y", but you can change it to something more meaningful.

<div class="info">
<p>You can leave out the <code>by</code> argument if you’re matching on all of the columns with the same name, but it’s good practice to always specify it so your code is robust to changes in the loaded data.</p>
</div>

### left_join() {#left_join}

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/left_join.png" alt="Left Join" width="100%" />
<p class="caption">(\#fig:img-left-join)Left Join</p>
</div></div>

A `left_join` keeps all the data from the first (left) table and joins anything that matches from the second (right) table. If the right table has more than one match for a row in the right table, there will be more than one row in the joined table (see ids 4 and 5).


```r
left_join(subject, exp, by = "id")
```

```
## # A tibble: 7 x 4
##      id gender   age score
##   <dbl> <chr>  <dbl> <dbl>
## 1     1 m         19    NA
## 2     2 m         22    10
## 3     3 <NA>      NA    18
## 4     4 nb        19    21
## 5     4 nb        19    23
## 6     5 f         18     9
## 7     5 f         18    11
```

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/left_join_rev.png" alt="Left Join (reversed)" width="100%" />
<p class="caption">(\#fig:img-left-join-rev)Left Join (reversed)</p>
</div></div>

The order of tables is swapped here, so the result is all rows from the `exp` table joined to any matching rows from the `subject` table.


```r
left_join(exp, subject, by = "id")
```

```
## # A tibble: 9 x 4
##      id score gender   age
##   <dbl> <dbl> <chr>  <dbl>
## 1     2    10 m         22
## 2     3    18 <NA>      NA
## 3     4    21 nb        19
## 4     4    23 nb        19
## 5     5     9 f         18
## 6     5    11 f         18
## 7     6    11 <NA>      NA
## 8     6    12 <NA>      NA
## 9     7     3 <NA>      NA
```

### right_join() {#right_join}

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/right_join.png" alt="Right Join" width="100%" />
<p class="caption">(\#fig:img-right-join)Right Join</p>
</div></div>

A `right_join` keeps all the data from the second (right) table and joins anything that matches from the first (left) table. 


```r
right_join(subject, exp, by = "id")
```

```
## # A tibble: 9 x 4
##      id gender   age score
##   <dbl> <chr>  <dbl> <dbl>
## 1     2 m         22    10
## 2     3 <NA>      NA    18
## 3     4 nb        19    21
## 4     4 nb        19    23
## 5     5 f         18     9
## 6     5 f         18    11
## 7     6 <NA>      NA    11
## 8     6 <NA>      NA    12
## 9     7 <NA>      NA     3
```

<div class="info">
This table has the same information as `left_join(exp, subject, by = "id")`, but the columns are in a different order (left table, then right table).
</div>

### inner_join() {#inner_join}

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/inner_join.png" alt="Inner Join" width="100%" />
<p class="caption">(\#fig:img-inner-join)Inner Join</p>
</div></div>

An `inner_join` returns all the rows that have a match in the other table.


```r
inner_join(subject, exp, by = "id")
```

```
## # A tibble: 6 x 4
##      id gender   age score
##   <dbl> <chr>  <dbl> <dbl>
## 1     2 m         22    10
## 2     3 <NA>      NA    18
## 3     4 nb        19    21
## 4     4 nb        19    23
## 5     5 f         18     9
## 6     5 f         18    11
```


### full_join() {#full_join}

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/full_join.png" alt="Full Join" width="100%" />
<p class="caption">(\#fig:img-full-join)Full Join</p>
</div></div>

A `full_join` lets you join up rows in two tables while keeping all of the information from both tables. If a row doesn't have a match in the other table, the other table's column values are set to `NA`.


```r
full_join(subject, exp, by = "id")
```

```
## # A tibble: 10 x 4
##       id gender   age score
##    <dbl> <chr>  <dbl> <dbl>
##  1     1 m         19    NA
##  2     2 m         22    10
##  3     3 <NA>      NA    18
##  4     4 nb        19    21
##  5     4 nb        19    23
##  6     5 f         18     9
##  7     5 f         18    11
##  8     6 <NA>      NA    11
##  9     6 <NA>      NA    12
## 10     7 <NA>      NA     3
```


## Filtering Joins

<a class='glossary' target='_blank' title='Joins that act like the dplyr::filter() function in that they remove rows from the data in one table based on the values in another table. The result of a filtering join will only contain rows from the left table and have the same number or fewer rows than the left table.' href='https://psyteachr.github.io/glossary/f#filtering-joins'>Filtering joins</a> act like the `filter()` function in that they remove rows from the data in one table based on the values in another table. The result of a filtering join will only contain rows from the left table and have the same number or fewer rows than the left table. 

### semi_join() {#semi_join}

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/semi_join.png" alt="Semi Join" width="100%" />
<p class="caption">(\#fig:img-semi-join)Semi Join</p>
</div></div>

A `semi_join` returns all rows from the left table where there are matching values in the right table, keeping just columns from the left table.


```r
semi_join(subject, exp, by = "id")
```

```
## # A tibble: 4 x 3
##      id gender   age
##   <int> <chr>  <dbl>
## 1     2 m         22
## 2     3 <NA>      NA
## 3     4 nb        19
## 4     5 f         18
```

<div class="info">
<p>Unlike an inner join, a semi join will never duplicate the rows in the left table if there is more than one matching row in the right table.</p>
</div>

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/semi_join_rev.png" alt="Semi Join (Reversed)" width="100%" />
<p class="caption">(\#fig:img-semi-join-rev)Semi Join (Reversed)</p>
</div></div>

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

### anti_join() {#anti_join}

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/anti_join.png" alt="Anti Join" width="100%" />
<p class="caption">(\#fig:img-anti-join)Anti Join</p>
</div></div>

An `anti_join` return all rows from the left table where there are *not* matching values in the right table, keeping just columns from the left table.


```r
anti_join(subject, exp, by = "id")
```

```
## # A tibble: 1 x 3
##      id gender   age
##   <int> <chr>  <dbl>
## 1     1 m         19
```

<div class = 'join'><div class="figure" style="text-align: center">
<img src="images/joins/anti_join_rev.png" alt="Anti Join (Reversed)" width="100%" />
<p class="caption">(\#fig:img-anti-join-rev)Anti Join (Reversed)</p>
</div></div>

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

## Binding Joins

<a class='glossary' target='_blank' title='Joins that bind one table to another by adding their rows or columns together.' href='https://psyteachr.github.io/glossary/b#binding-joins'>Binding joins</a> bind one table to another by adding their rows or columns together.

### bind_rows() {#bind_rows}

You can combine the rows of two tables with `bind_rows`.

Here we'll add subject data for subjects 6-9 and bind that to the original subject table.


```r
new_subjects <- tibble(
  id = 6:9,
  gender = c("nb", "m", "f", "f"),
  age = c(19, 16, 20, 19)
)

bind_rows(subject, new_subjects)
```

```
## # A tibble: 9 x 3
##      id gender   age
##   <int> <chr>  <dbl>
## 1     1 m         19
## 2     2 m         22
## 3     3 <NA>      NA
## 4     4 nb        19
## 5     5 f         18
## 6     6 nb        19
## 7     7 m         16
## 8     8 f         20
## 9     9 f         19
```

The columns just have to have the same names, they don't have to be in the same order. Any columns that differ between the two tables will just have `NA` values for entries from the other table.

If a row is duplicated between the two tables (like id 5 below), the row will also be duplicated in the resulting table. If your tables have the exact same columns, you can use `union()` (see below) to avoid duplicates.


```r
new_subjects <- tibble(
  id = 5:9,
  age = c(18, 19, 16, 20, 19),
  gender = c("f", "nb", "m", "f", "f"),
  new = c(1,2,3,4,5)
)

bind_rows(subject, new_subjects)
```

```
## # A tibble: 10 x 4
##       id gender   age   new
##    <int> <chr>  <dbl> <dbl>
##  1     1 m         19    NA
##  2     2 m         22    NA
##  3     3 <NA>      NA    NA
##  4     4 nb        19    NA
##  5     5 f         18    NA
##  6     5 f         18     1
##  7     6 nb        19     2
##  8     7 m         16     3
##  9     8 f         20     4
## 10     9 f         19     5
```

### bind_cols() {#bind_cols}

You can merge two tables with the same number of rows using `bind_cols`. This is only useful if the two tables have their rows in the exact same order. The only advantage over a left join is when the tables don't have any IDs to join by and you have to rely solely on their order.


```r
new_info <- tibble(
  colour = c("red", "orange", "yellow", "green", "blue")
)

bind_cols(subject, new_info)
```

```
## # A tibble: 5 x 4
##      id gender   age colour
##   <int> <chr>  <dbl> <chr> 
## 1     1 m         19 red   
## 2     2 m         22 orange
## 3     3 <NA>      NA yellow
## 4     4 nb        19 green 
## 5     5 f         18 blue
```

## Set Operations

<a class='glossary' target='_blank' title='Functions that compare two tables and return rows that match (intersect), are in either table (union), or are in one table but not the other (setdiff).' href='https://psyteachr.github.io/glossary/s#set-operations'>Set operations</a> compare two tables and return rows that match (intersect), are in either table (union), or are in one table but not the other (setdiff).

### intersect() {#intersect}

`intersect()` returns all rows in two tables that match exactly. The columns don't have to be in the same order.


```r
new_subjects <- tibble(
  id = seq(4, 9),
  age = c(19, 18, 19, 16, 20, 19),
  gender = c("f", "f", "m", "m", "f", "f")
)

intersect(subject, new_subjects)
```

```
## # A tibble: 1 x 3
##      id gender   age
##   <int> <chr>  <dbl>
## 1     5 f         18
```

<div class="warning">

If you've forgotten to load dplyr or the tidyverse, <a class='glossary' target='_blank' title='The set of R functions that come with a basic installation of R, before you add external packages' href='https://psyteachr.github.io/glossary/b#base-r'>base R</a> also has an `intersect()` function. The error message can be confusing and looks something like this:


```r
base::intersect(subject, new_subjects)
```

```
## Error: Must subset rows with a valid subscript vector.
## [34mℹ[39m Logical subscripts must match the size of the indexed input.
## [31mx[39m Input has size 6 but subscript `!duplicated(x, fromLast = fromLast, ...)` has size 0.
```
</div>

### union() {#union}

`union()` returns all the rows from both tables, removing duplicate rows.


```r
union(subject, new_subjects)
```

```
## # A tibble: 10 x 3
##       id gender   age
##    <int> <chr>  <dbl>
##  1     1 m         19
##  2     2 m         22
##  3     3 <NA>      NA
##  4     4 nb        19
##  5     5 f         18
##  6     4 f         19
##  7     6 m         19
##  8     7 m         16
##  9     8 f         20
## 10     9 f         19
```


<div class="warning">
If you've forgotten to load dplyr or the tidyverse, <a class='glossary' target='_blank' title='The set of R functions that come with a basic installation of R, before you add external packages' href='https://psyteachr.github.io/glossary/b#base-r'>base R</a> also has a `union()` function. You usually won't get an error message, but the output won't be what you expect.


```r
base::union(subject, new_subjects)
```

```
## [[1]]
## [1] 1 2 3 4 5
## 
## [[2]]
## [1] "m"  "m"  NA   "nb" "f" 
## 
## [[3]]
## [1] 19 22 NA 19 18
## 
## [[4]]
## [1] 4 5 6 7 8 9
## 
## [[5]]
## [1] 19 18 19 16 20 19
## 
## [[6]]
## [1] "f" "f" "m" "m" "f" "f"
```
</div> 

### setdiff() {#setdiff}

`setdiff` returns rows that are in the first table, but not in the second table.


```r
setdiff(subject, new_subjects)
```

```
## # A tibble: 4 x 3
##      id gender   age
##   <int> <chr>  <dbl>
## 1     1 m         19
## 2     2 m         22
## 3     3 <NA>      NA
## 4     4 nb        19
```

Order matters for `setdiff`.


```r
setdiff(new_subjects, subject)
```

```
## # A tibble: 5 x 3
##      id   age gender
##   <int> <dbl> <chr> 
## 1     4    19 f     
## 2     6    19 m     
## 3     7    16 m     
## 4     8    20 f     
## 5     9    19 f
```

<div class="warning">
If you've forgotten to load dplyr or the tidyverse, <a class='glossary' target='_blank' title='The set of R functions that come with a basic installation of R, before you add external packages' href='https://psyteachr.github.io/glossary/b#base-r'>base R</a> also has a `setdiff()` function. You usually won't get an error message, but the output might not be what you expect because the base R `setdiff()` expects columns to be in the same order, so id 5 here registers as different between the two tables.


```r
base::setdiff(subject, new_subjects)
```

```
## # A tibble: 5 x 3
##      id gender   age
##   <int> <chr>  <dbl>
## 1     1 m         19
## 2     2 m         22
## 3     3 <NA>      NA
## 4     4 nb        19
## 5     5 f         18
```
</div>

## Glossary {#glossary6}



|term                                                                                                                  |definition                                                                                                                                                                                                                                                                       |
|:---------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/b#base.r'>base r</a>                   |The set of R functions that come with a basic installation of R, before you add external packages                                                                                                                                                                                |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/b#binding.joins'>binding joins</a>     |Joins that bind one table to another by adding their rows or columns together.                                                                                                                                                                                                   |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/f#filtering.joins'>filtering joins</a> |Joins that act like the dplyr::filter() function in that they remove rows from the data in one table based on the values in another table. The result of a filtering join will only contain rows from the left table and have the same number or fewer rows than the left table. |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/m#mutating.joins'>mutating joins</a>   |Joins that act like the dplyr::mutate() function in that they add new columns to one table based on values in another table.                                                                                                                                                     |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/s#set.operations'>set operations</a>   |Functions that compare two tables and return rows that match (intersect), are in either table (union), or are in one table but not the other (setdiff).                                                                                                                          |



## Exercises {#exercises6}

Download the [exercises](exercises/06_joins_exercise.Rmd). See the [answers](exercises/06_joins_answers.Rmd) only after you've attempted all the questions.


```r
# run this to access the exercise
dataskills::exercise(6)

# run this to access the answers
dataskills::exercise(6, answers = TRUE)
```
