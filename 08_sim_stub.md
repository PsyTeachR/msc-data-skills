---
title: 'Formative Exercise 08: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



## Generate Data

### Question 1

Generate 50 data points from a normal distribution with a mean of 0 and SD of 1.


```r
a <- NULL
```

### Question 2

Generate another variable (`b`) that is equal to the sum of `a` and another 50 data points from a normal distribution with a mean of 0.5 and SD of 1.


```r
b <- NULL
```

### Question 3

Run a two-tailed, paired-samples t-test comparing `a` and `b`.


```r
t <- NULL

t # prints results of t-test
```

```
## NULL
```

## Calculate Power

### Question 4

Calculate power for a two-tailed t-test with an alpha of .05 for detecting a difference between two independent samples of 50 with an effect size of 0.3.

Hint: You can use the `sim_t_ind` function from the [T-Test Class Notes](https://psyteachr.github.io/msc-data-skills/08_simulation.html#t-test).


```r
sim_t_ind <- function() {}

power.sim <- NULL

power.sim # prints the value
```

```
## NULL
```

### Question 5

Compare this to the result of `power.t.test` for the same design.


```r
power.analytic <- NULL

power.analytic  # prints the value
```

```
## NULL
```

### Question 6

Modify the `sim_t_ind` function to handle different sample sizes. Use it to calculate the power of the following design: 

* 20 observations from a normal distribution with mean of 10 and SD of 4 versus
* 30 observations from a normal distribution with a mean of 13 and SD of 4.5


```r
sim_t_ind <- function() {}

power6 <- NULL

power6 # prints the value
```

```
## NULL
```

### Question 7

Calculate power for a two-tailed t-test with an alpha of .005 for detecting a sex difference in height in a sample of 10 male and 10 female 20-year-olds? Get the data for the height of male and female 20-year-olds from the [US CDC Growth Chart Data Tables](https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv).


```r
power7 <- NULL

power7 # prints the value
```

```
## NULL
```

## Poisson Distribution

The [poisson distribution(https://en.wikipedia.org/wiki/Poisson_distribution) is good for modeling the rate of something, like the number of texts you receive per day. Then you can test hypotheses like you receive more texts on weekends than weekdays. The poisson distribution gets more like a normal distribution when the rate gets higher, so it's most useful for low-rate events.

### Question 8

Use `ggplot` to create a histogram of 1000 random numbers from a poisson distribution with a `lambda` of 4. 


```r
pois <- NULL # 1000 random poisson-distributed numbers

ggplot()
```

![plot of chunk Q8](figure/Q8-1.png)

## Intermediate: Binomial Distribution

### Question 9

Demonstrate to yourself that the binomial distribution looks like the normal distribution when the number of trials is greater than 10.

Hint: You can calculate the equivalent mean for the normal distribution as the number of trials times the probability of success (`binomial_mean <- trials * prob`) and the equivalent SD as the square root of the mean times one minus probability of success (`binomial_sd <- sqrt(binomial_mean * (1 - prob))`).


```r
n <- NULL  # use a large n to get good estimates of the distributions
trials <- NULL
prob <- NULL
binomial_mean <- trials * prob
binomial_sd <- sqrt(binomial_mean * (1 - prob))

# sample number from binomial and normal distributions
norm_bin_comp <- NULL

# plot the sampled numbers to compare
ggplot()
```

![plot of chunk Q9](figure/Q9-1.png)

## Advanced: Correlation power simulation

Remember, there are many, many ways to do things in R. The important thing is to create your functions step-by-step, checking the accuracy at each step.

### Question 10

Write a function to create a pair of variables of any size with any specified correlation. Have the function return a tibble with columns `x` and `y`. Make sure all of the arguments have a default value.

Hint: modify the code from the [Bivariate Normal](https://psyteachr.github.io/msc-data-skills/08_simulation.html#bvn) 
section from the class notes.


```r
bvn2 <- function() {}

bvn2() %>% knitr::kable() # prints the table for default arguments
```

```
## Warning in kable_markdown(x = structure(character(0), .Dim = c(0L,
## 0L), .Dimnames = list(: The table should have a header (column names)
```



||
||
||
||


### Question 11

Use `cor.test` to test the Pearson's product-moment correlation between two variables generated with your function having an `n` of 50 and a `rho` of 0.45.



### Question 12

Test your function from Question 10 by calculating the correlation between your two variables many times for a range of values and plotting the results. Hint: the `purrr::map()` functions might be useful here.


```r
# set up all values you want to test
sims <- NULL

ggplot()
```

![plot of chunk Q12](figure/Q12-1.png)

### Question 13

Make a new function that calculates power for `cor.test` through simulation.


```r
power.cor.test <- function(){}
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
