
# Working with Data {#data}

<img src="images/memes/read_csv.png" class="meme right">

## Learning Objectives

1. Understand the use the [basic data types](#data_types)
2. Understand and use the [basic container types](#containers) (list, vector)
3. [Create vectors](#vectors) and store them as [variables](#vars)
4. Understand [vectorized operations](#vectorized_ops)
5. Create a [data table](#tables)
6. [Import data](#import_data) from CSV and Excel files

 

## Resources

* [Chapter 11: Data Import](http://r4ds.had.co.nz/data-import.html) in *R for Data Science*
* [RStudio Data Import Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/source/pdfs/data-import-cheatsheet.pdf)
* [Scottish Babynames](https://www.nrscotland.gov.uk/files//statistics/babies-first-names-full-list/summary-records/babies-names16-all-names-years.csv)
* [Developing an analysis in R/RStudio: Scottish babynames (1/2)](https://www.youtube.com/watch?v=lAaVPMcMs1w)
* [Developing an analysis in R/RStudio: Scottish babynames (2/2)](https://www.youtube.com/watch?v=lzdTHCcClqo)


## Basic data types {#data_types}

There are five main basic data types in R (there are more, but these are the critical ones you need to know about).

| type      | description                | example                  |
|:----------|:---------------------------|:-------------------------|
| double    | floating point value       | `.333337`                |
| integer   | integer                    | `-1`, `0`, `1`           |
| numeric   | any real number (int,dbl)  | `1`, `.5`, `-.222`       |
| boolean   | assertion of truth/falsity | `TRUE`, `FALSE`          |
| character | text string                | `"hello world"`, `'howdy'` |


There is also a specific data type called a `factor` which will probably give you a headache sooner or later, but we can get by for now without them.

Character strings can include basically anything, including quotes, but if you want a quote to be included you have to 'escape' it using a backslash:


```r
my_string <- "The instructor said, \"R is cool,\" and the class agreed."
cat(my_string) # cat() prints the arguments
```

```
## The instructor said, "R is cool," and the class agreed.
```

Note that if you just type a plain number such as `10` it is stored as a double, even if it doesn't have a decimal point. If you want it to be an exact integer, use the `L` suffix (10L).

If you ever want to know the data type of something, use the `class` function.


```r
class(10) # numeric
class(10L) # integer
class("10") # string
class(10L == 11L) # logical
```

```
## [1] "numeric"
## [1] "integer"
## [1] "character"
## [1] "logical"
```

## Basic container types {#containers}

### Vectors {#vectors}

Vectors are one of the key data structures in R.  A vector in R is like a vector in math: a set of ordered elements.  All of the elements in a vector must be of the same *data type* (numeric, character, factor).  You can create a vector by enclosing the elements in `c(...)`, as shown below.


```r
## put information into a vector using c(...)
c(1, 2, 3, 4)
c("this", "is", "cool")
1:6 # shortcut to make a vector of all integers x:y
```

```
## [1] 1 2 3 4
## [1] "this" "is"   "cool"
## [1] 1 2 3 4 5 6
```

<div class="try">
What happens when you mix types? What class is the variable `mixed`?

```r
mixed <- c(2, "good", 2L, "b", TRUE)
```
</div>

<div class="warning">
<p>You can't mix data types in a vector; all elements of the vector must be the same data type. If you mix them, R will coerce them so that they are all the same.</p>
</div>

#### Selecting values from a vector

Recall from the last class that another way to create a vector is to use the `c()` operator. (This is the easiest way, but you can also use the `vector()` function.) If we wanted to pick specific values out of a vector by position, we can make a vector of numbers like so:


```r
word <- c(18, 19, 20, 21, 4, 9, 15)
```

And then pull them out using the `[]` operator, which is the *extraction* operator, on the built-in vector `LETTERS`.


```r
LETTERS[word]
```

```
## [1] "R" "S" "T" "U" "D" "I" "O"
```

<div class="try">
Can you decode the secret message?

```r
secret <- c(14, 5, 22, 5, 18, 7, 15, 14, 14, 1, 7, 9, 22, 5, 25, 15, 21, 21, 16)
```

</div>

You can also create 'named' vectors, where each elements has a name. For example:


```r
vec <- c(first = 77.9, second = -13.2, third = 100.1)
vec
```

```
##  first second  third 
##   77.9  -13.2  100.1
```

We can then access elements by name using a character vector within the square brackets. We can put them in any order we want, and we can repeat elements:


```r
vec[c("third", "second", "second")]
```

```
##  third second second 
##  100.1  -13.2  -13.2
```

We can get the vector of names using the `names()` function, and we can set or change them using something like `names(vec2) <- c("n1", "n2", "n3")`.

Another way to access elements is by using a logical vector within the square brackets. This will pull out the elements of the vector for which the corresponding element of the logical vector is `TRUE`. If the logical vector doesn't have the same length as the original, it will repeat. You can find out how long a vector is using the `length()` function.


```r
length(LETTERS)
LETTERS[c(TRUE, FALSE)]
```

```
## [1] 26
##  [1] "A" "C" "E" "G" "I" "K" "M" "O" "Q" "S" "U" "W" "Y"
```

#### Repeating Sequences

Here are some useful tricks to save typing when creating vectors. Recall that in the command `x:y` the `:` operator would give you the sequence of integers from `x:y`. 

What if you want to repeat a vector many times? You could either type it out (painful) or use the `rep()` function, which can repeat vectors in different ways.


```r
rep(0, 10)                      # ten zeroes
rep(c(1L, 3L), times = 7)       # alternating 1 and 3, 7 times
rep(c("A", "B", "C"), each = 2) # A to C, 2 times each
```

```
##  [1] 0 0 0 0 0 0 0 0 0 0
##  [1] 1 3 1 3 1 3 1 3 1 3 1 3 1 3
## [1] "A" "A" "B" "B" "C" "C"
```

The `rep()` function is useful to create a vector of logical values (`TRUE`/`FALSE` or `1`/`0`) to select values from another vector.


```r
# Get subject IDs in the pattern Y Y N N ...
subject_ids <- 1:40
yynn <- rep(c(TRUE, FALSE), each = 2, 
            length.out = length(subject_ids))
subject_ids[yynn]
```

```
##  [1]  1  2  5  6  9 10 13 14 17 18 21 22 25 26 29 30 33 34 37 38
```

What if you want to create a sequence but with something other than integer steps? You can use the `seq()` function. Look at the examples below and work out what the arguments do.


```r
seq(from = -1, to = 1, by = 0.2)
seq(0, 100, length.out = 11)
seq(0, 10, along.with = LETTERS)
```

```
##  [1] -1.0 -0.8 -0.6 -0.4 -0.2  0.0  0.2  0.4  0.6  0.8  1.0
##  [1]   0  10  20  30  40  50  60  70  80  90 100
##  [1]  0.0  0.4  0.8  1.2  1.6  2.0  2.4  2.8  3.2  3.6  4.0  4.4  4.8  5.2  5.6
## [16]  6.0  6.4  6.8  7.2  7.6  8.0  8.4  8.8  9.2  9.6 10.0
```

#### Vectorized Operations {#vectorized_ops}

R performs calculations on vectors in a special way.  Let's look at an example using $z$-scores.  A $z$-score is a *deviation score* (a score minus a mean) divided by a standard deviation.  Let's say we have a set of four IQ scores.


```r
## example IQ scores: mu = 100, sigma = 15
iq <- c(86, 101, 127, 99)
```

If we want to subtract the mean from these four scores, we just use the following code:


```r
iq - 100
```

```
## [1] -14   1  27  -1
```

This subtracts 100 from each element of the vector.  R automatically assumes that this is what you wanted to do; it is called a *vectorized operation* and it makes it possible to express operations more efficiently.

To calculate $z$-scores we use the formula:

$z = \frac{X - \mu}{\sigma}$

where X are the scores, $\mu$ is the mean, and $\sigma$ is the standard deviation.  We can expression this formula in R as follows:


```r
## z-scores
(iq - 100) / 15
```

```
## [1] -0.93333333  0.06666667  1.80000000 -0.06666667
```

You can see that it computed all four $z$-scores with a single line of code.  Very efficient!


#### Exercises {#ex_vector}

1. The built-in vector `letters` contains the letters of the English alphabet.  Use an indexing vector of integers to extract the letters that spell 'cat'.
    
2. The function `colors()` returns all of the color names that R is aware of. What is the length of the vector returned by this function? (Use code to find the answer.)

3. The function call `runif(1000, 0, 1)` will draw 1000 numbers from a uniform distribution from 0 to 1, which simulates the p-values that you would get from 1000 experiments where the null hypothesis is true. Store the result of this call in `pvals`. Create a logical vector called `is_sig` that is `TRUE` if the corresponding element of `pvals` is less than .05, `FALSE` otherwise (hint: vectorized operations from the last lession), then use this logical vector to pull out those p-values. Finally, calculate the proportion of those p-values that were significant.

### Lists

Recall that vectors can contain data of only one type. What if you want to store a collection of data of different data types? For that purpose you would use a `list`. Define a list using the `list()` function.


```r
albums <- 
  list(
    Michael_Jackson = c(
      "Off the Wall",
      "Thriller",
      "Bad",
      "Dangerous"
    ),
    Nirvana = c(
      "Bleach",
      "Nevermind",
      "In Utero"
    )
  )  

names(albums)
length(albums)
```

You can refer to elements of a list by 

<div class="info">
<p>Fun fact: tabular data, stored in <code>data.frame</code> or <code>tibble</code> objects, which you will learn about in the next section, are a special type of list. That means you can access the columns of one of these object using <code>tablename$column</code> syntax, which is sometimes useful.</p>
</div>

### Tabular data {#tables}

Most of what you will be working with in this course is *tabular data*, data arranged in the form of a table.

Tabular data structures, like lists, allow for a collection of data of different types (characters, integers, logical, etc.) but subject to the constraint that each "column" of the table (element of the list) must have the same number of elements.  The base R version of a table is called a `data.frame` while the 'tidyverse' version is called a `tibble`.  Tibbles are far easier to work with, so we'll be using those. To learn more about differences between these two data structures, see `vignette("tibble")`.

Tabular data becomes especially important for when we talk about *tidy data* in [lesson 4](04_wrangling.Rmd), which consists of a set of simple principles for structuring data.

If we are creating a tibble from scratch, we can use the `tibble()` function, and type the data right in.  Note that if we want a value to repeat multiple times, we only have to specify a one-element vector; R will expand out the vector to fill out the table.  All columns in the tibble must have the same lengths or be of length 1.

If we want to use the `tibble()` function, we either need to load the tibble package or the tidyverse package (which will itself load tibble in addition to other packages).  Let's do the latter.


```r
library("tidyverse")
```

We can get information about the table dimensions using the functions `ncol()` (number of columns), `nrow()` (number of rows), or `dim()` (a vector with the number of rows and number of columns).


```r
months <- tibble(ID = 1:12,
                 name = c("Jan", "Feb", "Mar", "Apr",
                          "May", "Jun", "Jul", "Aug",
                          "Sep", "Oct", "Nov", "Dec"))

# print it
months

# how many rows?
nrow(months)

# how many columns?
ncol(months)
```

#### Viewing your tibble

Always, always, always, look at your data once you've created the table and load it in. Also look at it after each step that transforms your tibble.

There are three ways to look at your tibble: `View()` [*NB: capital 'V'], `print()`, and `glimpse()`.  Note that it is also rare that you want to print your data in a script; that is something you usually are doing for a sanity check, and you should just do it in the console.

The `print()` method can be run explicitly, but is more commonly called by just typing the variable name on the blank line. Usually we only call `print()` if we want fine control of how the information is displayed. 

Note that the default is not to print the entire table, but just the first 10 rows. Let's look at the `starwars` table that is built into the tidyverse.


```r
starwars
```

```
## # A tibble: 87 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Luke…    172    77 blond      fair       blue            19   male  
##  2 C-3PO    167    75 <NA>       gold       yellow         112   <NA>  
##  3 R2-D2     96    32 <NA>       white, bl… red             33   <NA>  
##  4 Dart…    202   136 none       white      yellow          41.9 male  
##  5 Leia…    150    49 brown      light      brown           19   female
##  6 Owen…    178   120 brown, gr… light      blue            52   male  
##  7 Beru…    165    75 brown      light      blue            47   female
##  8 R5-D4     97    32 <NA>       white, red red             NA   <NA>  
##  9 Bigg…    183    84 black      light      brown           24   male  
## 10 Obi-…    182    77 auburn, w… fair       blue-gray       57   male  
## # … with 77 more rows, and 5 more variables: homeworld <chr>, species <chr>,
## #   films <list>, vehicles <list>, starships <list>
```

You can see that this is a 87 rows by 13 column table, and we can only see the first 10 rows and first 8 columns.

If I want to see all 87 rows for some reason, I would use an explicit call to `print()`, and set the argument `n` to the number of rows I want to see. If I want all of them, just use `+Inf`, the symbol for 'infinite' rows.


```r
print(starwars, n = +Inf) # try this in the console
```

But we still can't see all the columns. If this is important to us, we can use `glimpse()`, which gives a sideways version of the tibble.


```r
glimpse(starwars)
```

```
## Observations: 87
## Variables: 13
## $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia O…
## $ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188, 180, …
## $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.0, 77…
## $ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "brown", …
## $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "light", …
## $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue", "blue"…
## $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, 57.0,…
## $ gender     <chr> "male", NA, NA, "male", "female", "male", "female", NA, "m…
## $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaan", "…
## $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human", "Hum…
## $ films      <list> [<"Revenge of the Sith", "Return of the Jedi", "The Empir…
## $ vehicles   <list> [<"Snowspeeder", "Imperial Speeder Bike">, <>, <>, <>, "I…
## $ starships  <list> [<"X-wing", "Imperial shuttle">, <>, <>, "TIE Advanced x1…
```

The other way to look at the table is a more graphical spreadsheet-like version given by `View()` (capital 'V').  It can be useful in the console, but don't ever put this one in a script because it will create an annoying pop-up window when the user goes to run it.

Note that `data.frame` objects are printed out in different ways from `tibble` objects. If you print a `data.frame` object with thousands or millions of rows, you won't just get a preview... you will spam your console with row upon row of data.  If you want to make a data.frame into a tibble so that it prints out nicely, just use the `as_tibble()` function.


```r
mtcars # prints out way too many rows; TMI

as_tibble(mtcars) # much cleaner
mtcars2 <- as_tibble(mtcars) # store it
```

#### Accessing rows and columns

There are various base R ways of accessing specific columns or rows from a table that are useful to know about, but you'll be learning easier (and more readable) ways when we get to the lecture on [data wrangling](04_wrangling.Rmd).  Examples of these base R accessing functions are provided here for reference.


```r
months[1, ] # first row

months[, 2] # second column (position)

months[1:3, ] # first 3 months

months[, c("Month")] # access column by name

months$month  # by column name
```

You'll learn about data frame operations in the [tidyr](#tidyr) and [dplyr](#dplyr) lessons.

#### Exercises {#ex_tibble}

1. Create a tibble with the name, age, and sex of 3-5 people whose names, ages, and sex you know.

2. Convert the built-in base R `iris` dataset to a tibble, and store it in the variable `iris2`.


3. Create a tibble that has the structure of the table below, using the minimum typing possible. (Hint: `rep()`).  Store it in the variable `my_tbl`.

    
    ```
    ## # A tibble: 8 x 4
    ##      ID A     B     C    
    ##   <int> <chr> <chr> <chr>
    ## 1     1 A1    B1    C1   
    ## 2     2 A1    B2    C1   
    ## 3     3 A1    B1    C1   
    ## 4     4 A1    B2    C1   
    ## 5     5 A2    B1    C1   
    ## 6     6 A2    B2    C1   
    ## 7     7 A2    B1    C1   
    ## 8     8 A2    B2    C1
    ```


## Importing data {#import_data}

There are many different types of files that you might work with when doing data analysis.  These different file types are usually distinguished by the three letter *extension* following a period at the end of the file name.  Here are some examples of different types of files and the functions you would use to read them in or write them out.

| Extension   | File Type              | Reading                 | Writing |
|-------------|------------------------|-------------------------|---------|
| .csv        | Comma-separated values | `readr::read_csv()`    | `readr::write_csv()` |
| .xls, .xlsx | Excel workbook         | `readxl::read_excel()` | N/A |
| .rds        | R binary file          | `readRDS()`             | `saveRDS()` |
| .RData      | R binary file          | `load()`                | `save()` |

Note: following the conventions introduced above in the section about add-on packages, `readr::read_csv()` refers to the `read_csv()` function in the `readr` package, and `readxl::read_excel()` refers to the function `read_excel()` in the package `readxl`.

Probably the most common file type you will encounter is `.csv` (comma-separated values).  As the name suggests, a CSV file distinguishes which values go with which variable by separating them with commas, and text values are sometimes enclosed in double quotes.  The first line of a file usually provides the names of the variables.  For example, here are the first few lines of a CSV containing Scottish baby names (see [the page at National Records Scotland](http://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/vital-events/names/babies-first-names/babies-first-names-summary-records-comma-separated-value-csv-format)):

    yr,sex,FirstForename,number,rank,position
    1974,B,David,1794,1,1
    1974,B,John,1528,2,2
    1974,B,Paul,1260,3,3
    1974,B,Mark,1234,4,4
    1974,B,James,1202,5,5
    1974,B,Andrew,1067,6,6
    1974,B,Scott,1060,7,7
    1974,B,Steven,1020,8,8
    1974,B,Robert,885,9,9
    1974,B,Stephen,866,10,10

There are six variables in this dataset, and their names are given in the first line of the file: `yr`, `sex`, `FirstForename`, `number`, `rank`, and `position`.  You can see that the values for each of these variables are given in order, separated by commas, on each subsequent line of the file.

When you read in CSV files, it is best practice to use the `readr::read_csv()` function. The `readr` package is automatically loaaded as part of the `tidyverse` package, which we will be using in almost every script. Note that you would normally want to store the result of the `read_csv()` function to a variable, as so:


```r
library(tidyverse)
```


```r
dat <- read_csv("my_data_file.csv")
```

Once loaded, you can view your data using the data viewer.  In the upper right hand window of RStudio, under the Environment tab, you will see the object `dat` listed.

![](images/01/my_data.png)

If you click on the View icon (![](images/01/table_icon.png)), it will bring up a table view of the data you loaded in the top left pane of RStudio.

![](images/01/View.png)

This allows you to check that the data have been loaded in properly.  You can close the tab when you're done looking at it&#x2014;it won't remove the object.

### Writing Data

If you have data that you want to save your data to a CSV file, use `readr::write_csv()`, as follows.


```r
write_csv(dat, "my_data_file2.csv")
```

This will save the data in CSV format to your working directory.

## Exercises

Download the [exercises](exercises/02_data_exercise.Rmd). See the [answers](exercises/02_data_answers.Rmd) only after you've attempted all the questions.
