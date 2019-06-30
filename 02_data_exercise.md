---
title: 'Formative Exercise 02: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



## Vectors

### Question 1

The built-in vector `letters` contains the letters of the English alphabet.  Use an indexing vector of integers to extract the letters that spell 'cat'.


```r
cat <- NULL
```


### Question 2

The function `colors()` returns all of the color names that R is aware of. What is the length of the vector returned by this function? (Use code to find the answer.)


```r
col_length <- NULL
```

### Question 3

The function call `runif(1000, 0, 1)` will draw 1000 numbers from a uniform distribution from 0 to 1, which simulates the p-values that you would get from 1000 experiments where the null hypothesis is true. Store the result of this call in `pvals`. Create a logical vector called `is_sig` that is `TRUE` if the corresponding element of `pvals` is less than .05, `FALSE` otherwise (hint: vectorized operations from the last lession), then use this logical vector to pull out those p-values. Finally, calculate the proportion of those p-values that were significant.


```r
pvals <- runif(1000, 0, 1)

is_sig <- NULL

prop_sig <- NULL
```


## Tabular Data 

### Question 4

Create a tibble with the columns `name`, `age`, and `country` of origin for 3 people you know.


```r
people <- NULL
```


### Question 5

Convert the built-in base R `iris` dataset to a tibble, and store it in the variable `iris2`.


```r
iris2 <- NULL
```


### Question 6

Create a tibble that has the structure of the table below, using the minimum typing possible. (Hint: `rep()`).  Store it in the variable `my_tbl`.

ID |  A | B   | C
--|-----|-----|---
1	| A1	| B1	| C1	
2	| A1	| B2	| C1	
3	| A1	| B1	| C1	
4	| A1	| B2	| C1	
5	| A2	| B1	| C1	
6	| A2	| B2	| C1	
7	| A2	| B1	| C1	
8	| A2	| B2	| C1


```r
my_tbl <- NULL  
```


## Data Import

### Question 7

Download the dataset [disgust_scores.csv](https://psyteachr.github.io/msc-data-skills/data/disgust_scores.csv) and read it into a table.


```r
disgust <- NULL
```


### Question 8

Override the default column specifications to skip the `id` column.


```r
disgust_skip <- NULL
```

### Question 9
  
How many rows and columns are in the dataset from question 7?


```r
disgust_rows <- NULL
disgust_cols <- NULL
```


## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                             |Answer    |
|:------------------------------------|:---------|
|<a href='#question-1'>Question 1</a> |incorrect |
|<a href='#question-2'>Question 2</a> |incorrect |
|<a href='#question-3'>Question 3</a> |incorrect |
|<a href='#question-4'>Question 4</a> |incorrect |
|<a href='#question-5'>Question 5</a> |incorrect |
|<a href='#question-6'>Question 6</a> |incorrect |
|<a href='#question-7'>Question 7</a> |incorrect |
|<a href='#question-8'>Question 8</a> |incorrect |
|<a href='#question-9'>Question 9</a> |incorrect |
