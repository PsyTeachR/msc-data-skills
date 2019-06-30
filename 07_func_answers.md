---
title: 'Formative Exercise 07: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



### Question 1

Set the vector `v1` equal to the following: 11, 13, 15, 17, 19, ..., 99, 101 (use a function; don't just type all the numbers).


```r
v1 <- seq(11, 101, by = 2)
```

### Question 2

Set the vector `v2` equal to the following: "A" "A" "B" "B" "C" "C" "D" "D" "E" "E" (note the letters are all uppercase).


```r
v2 <- rep(LETTERS[1:5], each = 2)
```

### Question 3

Set the vector `v3` equal to the following: "a" "b" "c" "d" "e" "a" "b" "c" "d" "e" (note the letters are all lowercase)


```r
v3 <- rep(letters[1:5], 2)
```

### Question 4

Set the vector `v4` equal to the words "dog" 10 times, "cat" 9 times, "fish" 6 times, and "ferret" 1 time. 


```r
pets <- c("dog", "cat", "fish", "ferret")
pet_n <- c(10, 9, 6, 1)
v4 <- rep(pets, times = pet_n)
```

### Question 5

Write a function called `my_add` that adds two numbers (`x` and `y`) together and returns the results.


```r
my_add <- function(x, y) {
  x+y
}
```

### Question 6

Copy the function `my_add` above and add an error message that returns "x and y must be numbers" if `x` or `y` are not both numbers.


```r
my_add <- function(x, y) {
  if (!is.numeric(x) | !is.numeric(y)) stop("x and y must be numbers")
  x+y
}
```

### Question 7

Create a tibble called `dat` that contains 20 rows and three columns: `id` (integers 101 through 120), `pre` and `post` (both 20-item vectors of random numbers from a normal distribution with mean = 0 and sd = 1).


```r
dat <- tibble(
  id = 101:120,
  pre = rnorm(20),
  post = rnorm(20)
)
```

### Question 8

Run a two-tailed, *paired-samples* t-test comparing `pre` and `post`. (check the help for `t.test`)


```r
t <- t.test(dat$post, dat$pre, paired = TRUE)

t # prints results of t-test
```

```
## 
## 	Paired t-test
## 
## data:  dat$post and dat$pre
## t = 1.3139, df = 19, p-value = 0.2045
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.246168  1.076479
## sample estimates:
## mean of the differences 
##               0.4151557
```

### Question 9

Use `broom::tidy` to save the results of the t-test in question 8 in a table called `stats`.


```r
stats <- t.test(dat$post, dat$pre, paired = TRUE) %>%
  broom::tidy()

knitr::kable(stats) # display the table
```



|  estimate| statistic|   p.value| parameter|  conf.low| conf.high|method        |alternative |
|---------:|---------:|---------:|---------:|---------:|---------:|:-------------|:-----------|
| 0.4151557|  1.313927| 0.2045149|        19| -0.246168|  1.076479|Paired t-test |two.sided   |

### Question 10

Create a function called `report_t` that takes a data table as an argument and returns the result of a two-tailed, paired-samples t-test between the columns `pre` and `post` in the following format: "The mean increase from pre-test to post-test was #.###: t(#) = #.###, p = 0.###, 95% CI = [#.###, #.###]." Hint: look at the function `paste0` (simpler) or `sprintf` (complicated but more powerful).

NB: Make sure all numbers are reported to three decimal places (except degrees of freedom).


```r
report_t <- function(data) {
  stats <- t.test(data$post, data$pre, paired = TRUE) %>%
    broom::tidy()
  
  diff <- pull(stats, estimate) %>% round(3) 
  t <- pull(stats, statistic) %>% round(3)
  p <- pull(stats, p.value) %>% round(3)
  df <- pull(stats, parameter)
  ci1 <- pull(stats, conf.low) %>% round(3)
  ci2 <- pull(stats, conf.high) %>% round(3)
  
  paste0("The mean increase from pre-test to post-test was ", diff, 
         ": t(", df, ") = ", t, 
         ", p = ", p, 
         ", 95% CI = [", ci1, ", ", ci2, "].")
}
```


```r
# sprintf() is a complicated function, but can be easier to use in long text strings with a lot of things to replace

report_t <- function(data) {
  stats <- t.test(data$post, data$pre, paired = TRUE) %>%
    broom::tidy()

  sprintf("The mean increase from pre-test to post-test was %.3f: t(%.0f) = %.3f, p = %.3f, 95%% CI = [%.3f, %.3f].",
          pull(stats, estimate), 
          pull(stats, parameter),
          pull(stats, statistic),
          pull(stats, p.value),
          pull(stats, conf.low),
          pull(stats, conf.high)
  )
}
```


The mean increase from pre-test to post-test was 0.415: t(19) = 1.314, p = 0.205, 95% CI = [-0.246, 1.076].

## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                               |Answer  |
|:--------------------------------------|:-------|
|<a href='#question-1'>Question 1</a>   |correct |
|<a href='#question-2'>Question 2</a>   |correct |
|<a href='#question-3'>Question 3</a>   |correct |
|<a href='#question-4'>Question 4</a>   |correct |
|<a href='#question-5'>Question 5</a>   |correct |
|<a href='#question-6'>Question 6</a>   |correct |
|<a href='#question-7'>Question 7</a>   |correct |
|<a href='#question-8'>Question 8</a>   |correct |
|<a href='#question-9'>Question 9</a>   |correct |
|<a href='#question-10'>Question 10</a> |correct |

