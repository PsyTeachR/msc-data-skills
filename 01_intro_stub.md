---
title: 'Exercise 01: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



Edit the code chunks below and knit the document to check if the answers are correct. Make sure you don't change the names of the variables that are given to you, or the answer checks won't work.

## Question 1

Create a variable called `my_pals` containing the names of three of your friends. This should be a three-element vector of type `character`.


```r
my_pals <- NULL
```

## Question 2

The chunk below creates an integer vector `ages` with the ages of five people. (Note: defining a number with the sufficx `L`, e.g., `26L`, defines `26` as type integer rather than type double.)  Calculate how old they will be in ten years using a vectorized operation and store the result in the variable `ages_10`.


```r
ages <- c(26L, 13L, 47L, 62L, 18L)

ages_10 <- NULL
```

## Question 3

The code below has an error and won't run. Fix the code.


```r
my_fortune <- fortune()
```

```
## Error in fortune(): could not find function "fortune"
```

```r
my_fortune
```

```
## 
## Basically R is reluctant to let you shoot yourself in the foot unless you
## are really determined to do so.
##    -- Bill Venables (about the warning hist() issues when being called
##       with unequal interval widths and freq=TRUE)
##       R-help (May 2008)
```

## Question 4

Call the `rnorm()` function to generate 10 random values from a normal distribution with a mean of 800 and a standard deviation of 20, and store the result in the variable `random_vals`.


```r
random_vals <- NULL
```

## Question 5

Write code that creates a logical vector `is_sig` that represents whether each of the p values in the vector `pvals` is less than .05. (Hint: type `1:11 < 7` in the console and see what you get).


```r
pvals <- c(.2, .001, .78, .04, .06, 10e-9)

is_sig <- NULL
```

## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                             |Answer    |
|:------------------------------------|:---------|
|<a href='#question-1'>Question 1</a> |incorrect |
|<a href='#question-2'>Question 2</a> |incorrect |
|<a href='#question-3'>Question 3</a> |correct   |
|<a href='#question-4'>Question 4</a> |incorrect |
|<a href='#question-5'>Question 5</a> |incorrect |
