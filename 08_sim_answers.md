---
title: 'Formative Exercise 08: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



## Generate Data

### Question 1

Generate 50 data points from a normal distribution with a mean of 0 and SD of 1.


```r
a <- rnorm(50, 0, 1)
```

### Question 2

Generate another variable (`b`) that is equal to the sum of `a` and another 50 data points from a normal distribution with a mean of 0.5 and SD of 1.


```r
b <- a + rnorm(50, 0.5, 1)
```

### Question 3

Run a two-tailed, paired-samples t-test comparing `a` and `b`.


```r
t <- t.test(a, b, paired = TRUE)

t # prints results of t-test
```

```
## 
## 	Paired t-test
## 
## data:  a and b
## t = -3.4945, df = 49, p-value = 0.001018
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.9500592 -0.2563093
## sample estimates:
## mean of the differences 
##              -0.6031843
```

## Calculate Power

### Question 4

Calculate power for a two-tailed t-test with an alpha of .05 for detecting a difference between two independent samples of 50 with an effect size of 0.3.

Hint: You can use the `sim_t_ind` function from the [T-Test Class Notes](https://psyteachr.github.io/msc-data-skills/08_simulation.html#t-test).


```r
sim_t_ind <- function(n, m1, sd1, m2, sd2) {
  v1 <- rnorm(n, m1, sd1)
  v2 <- rnorm(n, m2, sd2)
  t_ind <- t.test(v1, v2, paired = FALSE)
  
  return(t_ind$p.value)
}

my_reps <- replicate(1e4, sim_t_ind(50, 0, 1, 0.3, 1))
power.sim <- mean(my_reps < 0.05)

power.sim # prints the value
```

```
## [1] 0.3253
```

### Question 5

Compare this to the result of `power.t.test` for the same design.


```r
power.analytic <- power.t.test(n = 50, delta = 0.3, type = "two.sample")$power

power.analytic  # prints the value
```

```
## [1] 0.3175171
```

### Question 6

Modify the `sim_t_ind` function to handle different sample sizes. Use it to calculate the power of the following design: 

* 20 observations from a normal distribution with mean of 10 and SD of 4 versus
* 30 observations from a normal distribution with a mean of 13 and SD of 4.5


```r
sim_t_ind <- function(n1, m1, sd1, n2, m2, sd2, 
                       alternative = "two.sided") {
  v1 <- rnorm(n1, m1, sd1)
  v2 <- rnorm(n2, m2, sd2)
  t_ind <- t.test(v1, v2, 
                  alternative = alternative, 
                  paired = FALSE)

  return(t_ind$p.value)
}

my_reps <- replicate(1e4, sim_t_ind(20, 10, 4, 30, 13, 4.5))
power6 <- mean(my_reps < 0.05)

power6 # prints the value
```

```
## [1] 0.6789
```

### Question 7

Calculate power for a two-tailed t-test with an alpha of .005 for detecting a sex difference in height in a sample of 10 male and 10 female 20-year-olds? Get the data for the height of male and female 20-year-olds from the [US CDC Growth Chart Data Tables](https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv).


```r
height_age <- read_csv("https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv") %>%
  filter(Sex %in% c(1,2)) %>%
  mutate(
    sex = recode(Sex, "1" = "male", "2" = "female"),
    age = as.numeric(Agemos)/12,
    sd = `1` - `0`
  ) %>%
  dplyr::select(sex, age, mean = `0`, sd)

height_sub <- height_age %>% filter(age == 20)
m_mean <- height_sub %>% filter(sex == "male") %>% pull(mean)
m_sd   <- height_sub %>% filter(sex == "male") %>% pull(sd)
f_mean <- height_sub %>% filter(sex == "female") %>% pull(mean)
f_sd   <- height_sub %>% filter(sex == "female") %>% pull(sd)

my_reps <- replicate(1e4, sim_t_ind(10, m_mean, m_sd, 10, f_mean, f_sd))
power7 <- mean(my_reps < 0.005)

power7 # prints the value
```

```
## [1] 0.862
```

## Poisson Distribution

The [poisson distribution(https://en.wikipedia.org/wiki/Poisson_distribution) is good for modeling the rate of something, like the number of texts you receive per day. Then you can test hypotheses like you receive more texts on weekends than weekdays. The poisson distribution gets more like a normal distribution when the rate gets higher, so it's most useful for low-rate events.

### Question 8

Use `ggplot` to create a histogram of 1000 random numbers from a poisson distribution with a `lambda` of 4. 


```r
lambda <- 4 # lambda sets the mean of the poisson distribution

pois <- rpois(1000, lambda)

ggplot() +
  geom_histogram(aes(pois), fill="white", color="black", binwidth = 1)
```

![plot of chunk Q8](figure/Q8-1.png)

## Intermediate: Binomial Distribution

### Question 9

Demonstrate to yourself that the binomial distribution looks like the normal distribution when the number of trials is greater than 10.

Hint: You can calculate the equivalent mean for the normal distribution as the number of trials times the probability of success (`binomial_mean <- trials * prob`) and the equivalent SD as the square root of the mean times one minus probability of success (`binomial_sd <- sqrt(binomial_mean * (1 - prob))`).


```r
n <- 1e5  # use a large n to get good estimates of the distributions
trials <- 50
prob <- 0.8
binomial_mean <- trials * prob
binomial_sd <- sqrt(binomial_mean * (1 - prob))

# sample numbers from binomial and normal distributions

norm_bin_comp <- tibble (
  normal = rnorm(n, binomial_mean, binomial_sd),
  binomial = rbinom(n, trials, prob)
) %>%
  gather("distribution", "value", normal:binomial)

# plot the sampled numbers to compare
ggplot(norm_bin_comp, aes(value, color=distribution)) +
  geom_freqpoly(binwidth = 1)
```

![plot of chunk Q9](figure/Q9-1.png)

## Advanced: Correlation power simulation

Remember, there are many, many ways to do things in R. The important thing is to create your functions step-by-step, checking the accuracy at each step.

### Question 10

Write a function to create a pair of variables of any size with any specified correlation. Have the function return a tibble with columns `x` and `y`. Make sure all of the arguments have a default value.

Hint: modify the code from the [Bivariate Normal](https://psyteachr.github.io/msc-data-skills/08_simulation.html#bvn) 
section from the class notes.


```r
bvn2 <- function(n = 10, rho = 0, m1 = 0, m2 = 0, sd1 = 1, sd2 = 1) {
  # n = number of random samples
  # rho = population correlation between the two variables
  
  mu <- c(m1, m2) # the means of the samples
  stdevs <- c(sd1, sd2) # the SDs of the samples
  
  # correlation matrix
  cor_mat <- matrix(c(  1, rho, 
                      rho,   1), 2) 
  
  # create the covariance matrix
  sigma <- (stdevs %*% t(stdevs)) * cor_mat
  
  # sample from bivariate normal distribution
  m <- mvrnorm(n, mu, sigma) 
  
  # convert to a tibble to make it easier to deal with in further steps
  colnames(m) <- c("x", "y")
  as_tibble(m) 
}

bvn2() %>% knitr::kable() # prints the table for default arguments
```



|          x|          y|
|----------:|----------:|
|  0.1246489| -0.1684355|
| -0.4190485| -3.6668076|
| -0.5766349|  3.2129378|
| -0.0449705|  1.7514863|
| -1.1789125| -0.0859236|
| -1.5349175| -0.0759845|
|  0.1550150| -0.5140488|
| -0.6272191|  1.2619787|
|  1.0055172|  0.7375401|
|  0.6615512|  0.2849045|


### Question 11

Use `cor.test` to test the Pearson's product-moment correlation between two variables generated with your function having an `n` of 50 and a `rho` of 0.45.


```r
my_vars <- bvn2(50, 0.45)

cor.test(my_vars$x, my_vars$y)
```

```
## 
## 	Pearson's product-moment correlation
## 
## data:  my_vars$x and my_vars$y
## t = 4.9181, df = 48, p-value = 1.065e-05
## alternative hypothesis: true correlation is not equal to 0
## 95 percent confidence interval:
##  0.3582157 0.7382480
## sample estimates:
##       cor 
## 0.5788474
```

### Question 12

Test your function from Question 10 by calculating the correlation between your two variables many times for a range of values and plotting the results. Hint: the `purrr::map()` functions might be useful here.


```r
# set up all values you want to test
sims <- crossing(
  rep = 1:1000, # how many replications per combination
  n = c(10, 100, 1000),
  rho = c(-0.5, 0, .5)
) %>%
  mutate(r = purrr::map2_dbl(n, rho, function(n, rho) {
                b <- bvn2(n = n, rho = rho)
                cor(b$x, b$y)
              }),
         n = as.factor(n), # factorise for plotting
         rho = as.factor(rho) # factorise for plotting
         )

ggplot(sims, aes(r, color=rho, linetype=n)) + 
  geom_density()
```

![plot of chunk Q12](figure/Q12-1.png)

### Question 13

Make a new function that calculates power for `cor.test` through simulation.


```r
power.cor.test <- function(reps = 1000, n = 50, rho = 0.5, alpha = 0.05, method = "pearson"){
  power <- tibble(
    data = rerun(reps, bvn2(n, rho))
  ) %>%
    mutate(power = map(data, function(data) {
      cor.test(data$x, data$y, method = method) %>%
        broom::tidy()
    })) %>%
    unnest(power) %>%
    mutate(sig = p.value < alpha)
  
  tibble(
    n = n,
    rho = rho,
    alpha = alpha,
    power = mean(power$sig),
    method = method,
    reps = reps
  )
}

power.cor.test(1000, 30, 0.5, method = "spearman") %>%
  knitr::kable()
```



|  n| rho| alpha| power|method   | reps|
|--:|---:|-----:|-----:|:--------|----:|
| 30| 0.5|  0.05| 0.746|spearman | 1000|

## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                             |Answer  |
|:------------------------------------|:-------|
|<a href='#question-1'>Question 1</a> |correct |
|<a href='#question-2'>Question 2</a> |correct |
|<a href='#question-3'>Question 3</a> |correct |
|<a href='#question-4'>Question 4</a> |correct |
|<a href='#question-5'>Question 5</a> |correct |
|<a href='#question-6'>Question 6</a> |correct |
|<a href='#question-7'>Question 7</a> |correct |
|<a href='#question-8'>Question 8</a> |correct |
