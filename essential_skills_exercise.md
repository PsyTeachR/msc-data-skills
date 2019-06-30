---
title: Essential R Skills Self-Test
author: University of Glasgow, Department of Psychology
---

## Loading a Library

Almost every script you write will need to load a library. Do this at the top of the script. 
In the code chunk below, load the `tidyverse` and `readxl` libraries. You can check if you have a library under the Packages tab in the lower right RStudio pane. You might need to use `install.packages("tidyverse")` to install these libraries on your computer, but **never** put `install.packages()` in a script (just type that command directly into the console window).


```r
# TODO: your code for loading libraries goes here
```

## Assigning Variables and Data Types

The main data types you will use are *numeric* (*integer* or *double*), *character*, and *boolean*.

You assign data to variables with the *assignment operator* `<-`. Assign the following variables:


* set the variable `four` to the integer 4
* set the variable `one_plus_3` to the sum of the integer 1 and the integer 3
* set `double_four` to the number four as a *double*
* set the variable `lower` to your first name in all lowercase letters
* set the variable `UPPER` to your first name in all uppercase letters



```r
four <- NULL
one_plus_3 <- NULL
double_four <- NULL
lower <- NULL
UPPER <- NULL
```

## Comparison

The *comparison* operators, such as `==`, `>`, `<`, `>=`, and `<=` let you compare data and/or variables. Remember, `=` *sets* the left side of the equation equal to the right side, while `==` checks if the left and right sides are *equivalent*.

If you assign a variable to the outcome of a comparison, such as `is_equal <- 10 == 5 + 5`, the variable will be TRUE if the comparison is true and FALSE if the comparison is false. Assign the following variables to the outcome of the specified comparison:

* `comp_1_eq_2`: is the integer 1 equal to the integer 2?
* `comp_a_eq_A`: is the character "a" equal to the character "A"?
* `comp_10_lt_20`: is the number 10 less than the number 20?
* `comp_four_gte_one_plus_3` is the variable `four` greater than or equal to the variable `one_plus_3`


```r
comp_1_eq_2 <- NULL
comp_a_eq_A <- NULL
comp_10_lt_20 <- NULL
comp_four_gte_one_plus_3 <- NULL
```


## Forming a vector

A vector is a list of 1 or more items of the same data type. Create the following variables:

* `beatles`: a list of first names John, Paul, George, and Ringo
* `one_to_ten`: a list of the integers 1 through 10
* `evens`: a list of the even integers from 2 to 10
* `a_to_e`: the first 5 items in the built-in vector `letters`


```r
beatles <- NULL
one_to_ten <- NULL
evens <- NULL
a_to_e <- NULL
```

## Vectorised Operations

* `by_tens`: multiply each item in the vector `one_to_ten` by 10
* `squares`: make a 10-item vector with the square of the numbers 1 to 10 (multiply each number by itself)
* `a_to_e_1`: use the `paste0` function and the `a_to_e` variable you created above to create a vector that looks like `"a1", "b2", "c3", "d4", "e5"`.


```r
by_tens <- NULL
squares <- NULL
a_to_e_1 <- NULL
```

## Loading Data

You can load data straight from a website using the URL. Use tidyverse functions for reading CSV and Excel files to create the following variables:

* `infmort`: load data in the CSV file "https://psyteachr.github.io/msc-data-skills/data/infmort.csv" using the URL
* `matmort`: download the excel file [matmort.xls](https://psyteachr.github.io/msc-data-skills/data/matmort.xls) into a directory called `data` in the same directory as this file and load the local file using a function from the package `readxl`


```r
infmort <- NULL
matmort <- NULL
```

## Checks

The sections below let you check your work. There is no need to change anything. Knit this file to HTML. If you did everything right, all the answers should be appear as `correct` in the HTML report.



### Assigning Variables and Data Types

* `four`: **incorrect**
* `one_plus_3`: **incorrect**
* `double_four`: **incorrect**
* `lower`: **incorrect**
* `UPPER`: **incorrect**

### Comparison

* `comp_1_eq_2`: **incorrect**
* `comp_a_eq_A`: **incorrect**
* `comp_10_lt_20`: **incorrect**
* `comp_four_gte_one_plus_3`: **incorrect**

### Forming a vector

* `beatles`: **incorrect**
* `one_to_ten`: **incorrect**
* `evens`: **incorrect**
* `a_to_e`: **incorrect**

### Vectorised Operations

* `by_tens`: **incorrect**
* `squares`: **incorrect**
* `a_to_e_1`: **incorrect**

### Loading Data



