---
title: 'Formative Exercise 07: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



### Question 1

Set the vector `v1` equal to the following: 11, 13, 15, 17, 19, ..., 99, 101 (use a function; don't just type all the numbers).


```r
v1 <- NULL
```

### Question 2

Set the vector `v2` equal to the following: "A" "A" "B" "B" "C" "C" "D" "D" "E" "E" (note the letters are all uppercase).


```r
v2 <- NULL
```

### Question 3

Set the vector `v3` equal to the following: "a" "b" "c" "d" "e" "a" "b" "c" "d" "e" (note the letters are all lowercase)


```r
v3 <- NULL
```

### Question 4

Set the vector `v4` equal to the words "dog" 10 times, "cat" 9 times, "fish" 6 times, and "ferret" 1 time. 


```r
v4 <- NULL
```

### Question 5

Write a function called `my_add` that adds two numbers (`x` and `y`) together and returns the results.


```r
my_add <- NULL
```

### Question 6

Copy the function `my_add` above and add an error message that returns "x and y must be numbers" if `x` or `y` are not both numbers.


```r
my_add <- NULL
```

### Question 7

Create a tibble called `dat` that contains 20 rows and three columns: `id` (integers 101 through 120), `pre` and `post` (both 20-item vectors of random numbers from a normal distribution with mean = 0 and sd = 1).


```r
dat <- NULL
```

### Question 8

Run a two-tailed, *paired-samples* t-test comparing `pre` and `post`. (check the help for `t.test`)


```r
t <- NULL

t # prints results of t-test
```

```
## NULL
```

### Question 9

Use `broom::tidy` to save the results of the t-test in question 8 in a table called `stats`.


```r
stats <- NULL

knitr::kable(stats) # display the table
```

```
## Warning in kable_markdown(x = structure(character(0), .Dim = c(0L,
## 0L), .Dimnames = list(: The table should have a header (column names)
```



||
||
||
||

### Question 10

Create a function called `report_t` that takes a data table as an argument and returns the result of a two-tailed, paired-samples t-test between the columns `pre` and `post` in the following format: "The mean increase from pre-test to post-test was #.###: t(#) = #.###, p = 0.###, 95% CI = [#.###, #.###]." Hint: look at the function `paste0` (simpler) or `sprintf` (complicated but more powerful).

NB: Make sure all numbers are reported to three decimal places (except degrees of freedom).


```r
report_t <- function(x) {}
```



## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                               |Answer    |
|:--------------------------------------|:---------|
|<a href='#question-1'>Question 1</a>   |incorrect |
|<a href='#question-2'>Question 2</a>   |incorrect |
|<a href='#question-3'>Question 3</a>   |incorrect |
|<a href='#question-4'>Question 4</a>   |incorrect |
|<a href='#question-5'>Question 5</a>   |incorrect |
|<a href='#question-6'>Question 6</a>   |incorrect |
|<a href='#question-7'>Question 7</a>   |incorrect |
|<a href='#question-8'>Question 8</a>   |incorrect |
|<a href='#question-9'>Question 9</a>   |incorrect |
|<a href='#question-10'>Question 10</a> |incorrect |

