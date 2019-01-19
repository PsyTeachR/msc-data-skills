# Introduction 2 {#intro2}

## Learning Objectives

1. [Organizing a project](#project_org): directory structure and working directory 
2. Appropriately [structure an R script or RMarkdown file](#script_struct)
3. Understand the use the [basic data types](#data_types) (integer, double, character, factor)
4. Understand and use the [basic container types](#containers) (list, vector)
5. Create a simple [data table](#tables)
6. [Import data](#import_data) from a CSV and Excel files
7. Combining analysis steps using the `magrittr` [pipe `%>%`](#pipes)
 

## Resources

* [Chapter 11: Data Import](http://r4ds.had.co.nz/data-import.html) in *R for Data Science*
* [RStudio Data Import Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/source/pdfs/data-import-cheatsheet.pdf)
* [Scottish Babynames](https://www.nrscotland.gov.uk/files//statistics/babies-first-names-full-list/summary-records/babies-names16-all-names-years.csv)
* [Developing an analysis in R/RStudio: Scottish babynames (1/2)](https://www.youtube.com/watch?v=lAaVPMcMs1w)
* [Developing an analysis in R/RStudio: Scottish babynames (2/2)](https://www.youtube.com/watch?v=lzdTHCcClqo)


## Organizing a project {#project_org}

### Working Directory

Where should I put all my files?

When developing an analysis, you usually want to have all of your scripts and data files in one subtree of your computer's directory structure.  Usually there is a single *working directory* where your data and scripts are stored.   For the purpose of this class, to minimize problems, please store your files on your network drive (usually something like the M: drive or U: drive on a Windows machine.)

Your script should only reference files in three locations, using the appropriate format.

| Where                                      |  Example |
|--------------------------------------------|-----------------------|
| on the web  | "https://github.com/gupsych/data_skills/blob/master/02_intro.Rmd" |
| in the working directory  | "my_file2.csv"  |
| in a subdirectory | "subdir/my_file2.csv" |

<div class="warning">
<p>Never set or change your working directory in a script; always store your main script file in the top-level directory and manually set your working directory to that location. This means you'll have to reset the working directory each time you open RStudio, but this is a small price to pay for reproducibility (alternatively, learn about <a href="https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects">R Projects</a>).</p>
</div>

For instance, if on a Windows machine your data and scripts live in the directory `C:\Carla's_files\thesis2\my_thesis\new_analysis`, you will set your working directory to `new_analysis` in one of two ways: (1) by going to the `Session` pull down menu in RStudio and choosing `Set Working Directory`, or (2) by typing `setwd("C:\Carla's_files\thesis2\my_thesis\new_analysis")` in the console window.  If you 'knit' an RMarkdown file, your working directory is automatically set to the same directory where the Rmd file is located during the knitting process. But if you're planning on running the code chunks individually, you'll need to manually set the directory.

<div class="warning">
<p>It's tempting to make your life simple by putting the <code>setwd()</code> command in your script. Don't do this! Others will not have the same directory tree as you (and when your laptop dies and you get a new one, neither will you). <em>When manually setting the working directory, always do so by using the <code>Session | Set Working Directory</code> pull-down option or by typing <code>setwd()</code> in the console.</em></p>
</div>

If your script needs a file in a subdirectory of `new_analysis`, say, `analysis2/dat.rds`, load it in using a relative path:


```r
dat <- readRDS("analysis2/dat.rds")  # right way
```

Do not load it in using an absolute path:


```r
dat <- readRDS("C:/Carla's_files/thesis22/my_thesis/new_analysis/analysis2/dat.rds")   # wrong
```

<div class="info">
<p>Also note the convention of using forward slashes, unlike the Windows specific convention of using backward slashes. This is to make references to files platform independent.</p>
</div>

## Structuring your script {#script_struct}

If you structure your R script or RMarkdown file in a predictable way, it will make your life much easier.  All scripts should have the following structure:

1. Load any add-on packages you will need
2. Define any custom functions
3. Import data
4. Perform the analysis

Consider, for instance, the script that we created in the last session:


```r
# Load the add-on packages
library("tidyverse")
library("ukbabynames")

# If we had created any functions (we didn't) we would put them here. We will
# learn about creating functions later in the course.

# Import the data
nam0 <- read_csv("PSYCH5077 Grades-20180921_0719-comma_separated.csv") %>%
  select(name = `First name`) # rename the column

# The rest of the script performs the analysis
nam1 <- tibble(name = c("Dale", "Lisa", "Rebecca"))

nam_uk <- bind_rows(nam0, nam1) %>%
  inner_join(ukbabynames, "name") 

ggplot(nam_uk, aes(x = year, y= n,
                   colour = sex)) +
  geom_line() +
  facet_wrap(~name, scales = "free_y")
```

Often when you are working on a script, you will realize that you need to load another add-on package. Don't bury the call to `library(package_I_need)` way down in the script. Put it in the top, so the user has an overview of what packages are needed.

When structuring an RMarkdown file, it is generally a good idea to have a single code chunk for each output that is produced in the report; for instance, the above code could all be in a single chunk since the only output we care about is the graph at the end. It is also a good idea to suppress any warnings or messages in the report so that they don't confuse the reader. You can suppress messages or warnings by using the code chunk options `message=FALSE` and `warning=FALSE`.

## Basic data types {#data_types}

There are four main basic data types in R (there are more, but these are the critical ones you need to know about).

|type         | examples                         |
|-------------|----------------------------------|
| `character` | "hello", "ABCDE1", "12 45", "123.45"|
| `integer`   | 10L, 50L, 1L, -20L                  |
| `double` aka `numeric`    | 10, 3.1415, -99.7, 0.001, -3.5e6    |
| `logical`   | `TRUE`, `FALSE`                   |

There is also a specific data type called a `factor` which will probably give you a headache sooner or later, but we can get by for now without them.

Character strings can include basically anything, including quotes, but if you want a quote to be included you have to 'escape' it using a backslash:


```r
my_string <- "The instructor said, \"R is cool,\" and the class agreed."
my_string
```

```
## [1] "The instructor said, \"R is cool,\" and the class agreed."
```

Note that if you just type a plain number such as `10` it is stored as a double, even if it doesn't have a decimal point. If you want it to be an exact integer, use the `L` suffix (10L).

If you ever want to know the data type of something, use the class function.  There is also the `mode` function which is specifically for vectors.


```r
class(10) # numeric
```

```
## [1] "numeric"
```

```r
class(10L) # integer
```

```
## [1] "integer"
```

```r
class("10") # string
```

```
## [1] "character"
```

```r
class(10L == 11L) # logical
```

```
## [1] "logical"
```

```r
mode(TRUE)
```

```
## [1] "logical"
```

## Basic container types {#containers}

### Vectors

OK, here's a question. When you type a single number in the console, it spits it back out to you, like this:


```r
3L
```

```
## [1] 3
```

Why is there a `[1]` there? i.e., what does the `[1]` in the `[1] 3` refer to?

We'll eventually get to the answer, but let's see if you can discover it yourself through experiment. There is an operator `:` that, when placed between two integers `x` and `y` like so: `x:y` will yield the sequence of integers from x to y inclusive. Let's make a big long vector of numbers and print it out.


```r
vec <- 200:400
vec
```

```
##   [1] 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216
##  [18] 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233
##  [35] 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250
##  [52] 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267
##  [69] 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284
##  [86] 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301
## [103] 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318
## [120] 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335
## [137] 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352
## [154] 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369
## [171] 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386
## [188] 387 388 389 390 391 392 393 394 395 396 397 398 399 400
```

Note the number in square brackets on the left hand side of the output. Note that `vec` is a vector: an ordered container of 200 elements, in this case, the integers from 200 to 400. The bracked number on the left hand side tells you the numeric index (i.e., element number) corresponding to the first value in that row. So the first value is 200, the 19th value is 218, the 37th value is 236, etc.

Recall from the last class that another way to create a vector is to use the `c()` operator. (This is the easiest way, but you can also use the `vector()` function.) If we wanted to pick specific values out of the vector by position, we can make a vector of numbers like so:


```r
c(1L, 19L, 37L, 55L)
```

```
## [1]  1 19 37 55
```

And then pull them out using the `[]` operator, which is the *extraction* operator, on the variable `vec`.


```r
vec[c(1L, 19L, 37L, 55L)]
```

```
## [1] 200 218 236 254
```

```r
## note also:
index <- c(1L, 19L, 37L, 55L)
vec[index]
```

```
## [1] 200 218 236 254
```

```r
vec[c(1L, 1L, 19L, 19L, 19L, 19L)]
```

```
## [1] 200 200 218 218 218 218
```

OK let's return to our original question: why did we get `[1] 3` when we just typed `3L`?  The answer should now be clear: when we entered a single number, R created a vector with a single element.

You can also create 'named' vectors, where each elements has a name. For example:


```r
vec2 <- c(first = 77.9, second = -13.2, third = 100.1)
vec2
```

```
##  first second  third 
##   77.9  -13.2  100.1
```

We can then access elements by name using a character vector within the square brackets. We can put them in any order we want, and we can repeat elements:


```r
vec2[c("third", "second", "second")]
```

```
##  third second second 
##  100.1  -13.2  -13.2
```

We can get the vector of names using the `names()` function, and we can set or change them using something like `names(vec2) <- c("n1", "n2", "n3")`.

Another way to access elements is by using a logical vector within the square brackets. This will pull out the elements of the vector for which the corresponding element of the logical vector is `TRUE`. The logical vector must have the same length as the original. You can find out how long a vector is using the `length()` function.


```r
length(vec2)
```

```
## [1] 3
```

```r
vec2[c(TRUE, FALSE, TRUE)]
```

```
## first third 
##  77.9 100.1
```

Here are some useful tricks to save typing when creating vectors. Recall that in the command `x:y` the `:` operator would give you the sequence of integers from `x:y`. 

What if you want to repeat a vector many times? You could either type it out (painful) or use the `rep()` function, which can repeat vectors in different ways.


```r
# ten zeroes
rep(0, 10)
```

```
##  [1] 0 0 0 0 0 0 0 0 0 0
```

```r
# alternating 1 and 3, 7 times
rep(c(1L, 3L), 7)
```

```
##  [1] 1 3 1 3 1 3 1 3 1 3 1 3 1 3
```

```r
rep(c(TRUE, FALSE), 2)
```

```
## [1]  TRUE FALSE  TRUE FALSE
```

What if you want to create a sequence but with something other than integer steps? You can use the `seq()` function. You can learn about this in the exercises below.


```r
# Repeat a vector
# See the ?rep function
rep(c(TRUE, FALSE), 3)
```

```
## [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE
```

```r
# Get every other (odd) element of vec
vec[rep(c(TRUE, FALSE), 100)]
```

```
##   [1] 200 202 204 206 208 210 212 214 216 218 220 222 224 226 228 230 232
##  [18] 234 236 238 240 242 244 246 248 250 252 254 256 258 260 262 264 266
##  [35] 268 270 272 274 276 278 280 282 284 286 288 290 292 294 296 298 300
##  [52] 302 304 306 308 310 312 314 316 318 320 322 324 326 328 330 332 334
##  [69] 336 338 340 342 344 346 348 350 352 354 356 358 360 362 364 366 368
##  [86] 370 372 374 376 378 380 382 384 386 388 390 392 394 396 398 400
```

```r
# We can also store the logical vector in a variable and use that
evens <- rep(c(FALSE, TRUE), 100)
```

<div class="warning">
<p>You can't mix data types in a vector; all elements of the vector must be the same data type. If you mix them, R will coerce them so that they are all the same.</p>
</div>

### Exercises {#ex_vector}

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

## Tabular data {#tables}

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

### Viewing your tibble

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
## # ... with 77 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
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
## $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", ...
## $ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188...
## $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 8...
## $ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "b...
## $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "l...
## $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue",...
## $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0...
## $ gender     <chr> "male", NA, NA, "male", "female", "male", "female",...
## $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alder...
## $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human...
## $ films      <list> [<"Revenge of the Sith", "Return of the Jedi", "Th...
## $ vehicles   <list> [<"Snowspeeder", "Imperial Speeder Bike">, <>, <>,...
## $ starships  <list> [<"X-wing", "Imperial shuttle">, <>, <>, "TIE Adva...
```

The other way to look at the table is a more graphical spreadsheet-like version given by `View()` (capital 'V').  It can be useful in the console, but don't ever put this one in a script because it will create an annoying pop-up window when the user goes to run it.

Note that `data.frame` objects are printed out in different ways from `tibble` objects. If you print a `data.frame` object with thousands or millions of rows, you won't just get a preview... you will spam your console with row upon row of data.  If you want to make a data.frame into a tibble so that it prints out nicely, just use the `as_tibble()` function.


```r
mtcars # prints out way too many rows; TMI

as_tibble(mtcars) # much cleaner
mtcars2 <- as_tibble(mtcars) # store it
```

### Accessing rows and columns

There are various base R ways of accessing specific columns or rows from a table that are useful to know about, but you'll be learning easier (and more readable) ways when we get to the lecture on [data wrangling](04_wrangling.Rmd).  Examples of these base R accessing functions are provided here for reference.


```r
months[1, ] # first row

months[, 2] # second column (position)

months[1:3, ] # first 3 months

months[, c("Month")] # access column by name

months$month  # by column name
```

You'll learn about data frame operations in the [tidyr](#tidyr) and [dplyr](#dplyr) lessons.

### Exercises {#ex_tibble}

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

![](images/01_walkthrough/my_data.png)

If you click on the View icon (![](images/01_walkthrough/table_icon.png)), it will bring up a table view of the data you loaded in the top left pane of RStudio.

![](images/01_walkthrough/View.png)

This allows you to check that the data have been loaded in properly.  You can close the tab when you&rsquo;re done looking at it&#x2014;it won't remove the object.

### Writing Data

If you have data that you want to save your data to a CSV file, use `readr::write_csv()`, as follows.


```r
write_csv(dat, "my_data_file2.csv")
```

This will save the data in CSV format to your working directory.

### Exercises {#ex_import}

1. Download the dataset [disgust_scores.csv](data/disgust_scores.csv) and read it into a table.

2. Override the default column specifications to skip the `id` column.
  
3. How many rows and columns are in the dataset from question 3?


## Pipes

Pipes (`%>%`) are very useful for stringing together a sequence of commands in R. They might be a bit confusing at first but they are worth learning because they will make your code more readable and efficient.
Because pipes are a recent innovation, they are not part of base R. That means you need to load an add-on package to use them. Although the "home" package of the pipe operator is a package called magrittr, more commonly you will gain access to them by loading the tidyverse package (`library("tidyverse")`). If you get either of the following errors in your script:

`Error: unexpected SPECIAL in "%>%"`  
or  
`Error: could not find function "%>%"`

you tried to use `%>%` before doing `library("tidyverse")`.

It is easiest to understand how to use pipes through an example. Let's say that we want to sample 5 random integers between 1 and 10 (with replacement), figure out which unique numbers were sampled, and then sort them in descending order. We will need to call three functions in a sequence: `sample()` to generate the integers, `unique()` to figure out which unique integers were sampled (because the same integer may have been sampled multiple times), and then `sort()` with `decreasing = TRUE` to put them in descending order. So we might write code like this:


```r
x <- sample(1:10, 5, replace = TRUE)
y <- unique(x)
sort(y, TRUE) # set second argument to 'TRUE' so that sort order is descending
```

```
## [1] 10  9  8  7
```

While there is nothing wrong with this code, it required us to define variables x and y which we won't ever need again, and which clutter up our environment. To avoid this you could rewrite this code using nested function calls like so:


```r
sort(
  unique(
    sample(1:10, 5, replace = TRUE)
    )
  , TRUE)
```

```
## [1] 9 6 1
```

(If the above call looks confusing, it should!) The call to `sample()` is embedded within a call to `unique()` which in turn is embedded within a call to `sort()`. The functions are executed from most embedded (the "bottom") to least embedded (the "top"), starting with the function `sample()`, whose result is then passed in as the first argument to `unique()`, whose result in turn is passed in as the first argument to `sort()`; notice the second argument of sort (`TRUE`) is all the way at the end of the statement, making it hard to figure out which of the three functions it belongs to. We read from left to right; however, understanding this code requires us to work our way from right to left, and therefore unnatural. Moreover it is simply an ugly line of code.

This is where pipes come in. You can re-write the original code using pipes like so:

```r
sample(1:10, 5, replace = TRUE) %>% 
  unique() %>% 
  sort(TRUE)
```

```
## [1] 7 6 4 2 1
```

R will calculate the result of `sample(1:10, 5, replace = TRUE)` and then pass this result as the first argument of `unique()`; then, the result of `unique()` will in turn be passed along as the first argument of `sort()` with the second argument set to `TRUE`. The thing to note here is that for any function call on the right hand side of a pipe, you should omit the first argument and start with the second, because the pipe automatically places the result of the call on the left as the first argument of the next function call.

#### Exercises {#ex_pipes}

1. Re-write the following sequence of commands into a single 'pipeline'.

    
    ```r
    x <- 1:20 # integers from 1:20
    y <- rep(x, 2) # then repeat them twice
    z <- sum(y) # and then take the sum
    ```


2. Deconstruct the pipeline below back into separate commands.

    
    ```r
    LETTERS[c(18, 5, 7, 1, 12)] %>%
      rev() %>%
      paste(collapse = "")
    ```
    
    ```
    ## [1] "LAGER"
    ```

<a href="formative_exercises/02_intro_stub.Rmd">Download the formative exercises.</a>
