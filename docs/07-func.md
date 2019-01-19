# Iteration & Functions {#func}

## Learning Objectives {.tabset}

You will learn about functions and iteration by using simulation to calculate a power analysis for ANOVA on a simple two-group design.

### Basic

* work with iteration functions `rep`, `seq`, and `replicate`
* use arguments by order or name
* write your own custom functions with `function()`
* set default values for the arguments in your functions

### Intermediate

* understand scope
* use error handling and warnings in a function

### Advanced

The topics below are not covered in these materials, but they are directions for independent learning.

* repeat commands and handle result using `purrr::rerun()`, `purrr::map_*()`, `purrr::walk()`
* repeat commands having multiple arguments using `purrr::map2_*()` and `purrr::pmap_*()`
* create *nested data frames* using `dplyr::group_by()` and `tidyr::nest()`
* work with *nested data frames* in `dplyr`
* capture and deal with errors using 'adverb' functions `purrr::safely()` and `purrr::possibly()`

## Prep

* Read Chapters 19 and 21 of [R for Data Science](http://r4ds.had.co.nz)

## Resources

* [RStudio Apply Functions Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/purrr.pdf)

## Formative exercises

Download the [formative exercises](formative_exercises/07_functions_stub.Rmd). See the [answers](formative_exercises/07_functions_answers.Rmd) only after you've attempted all the questions.

## Class Notes

In the next two lectures, we are going to learn more about *iteration* (doing the same commands over and over) and *custom functions* through a data simulation exercise, which will also lead us into more traditional statistical topics. Along the way you will also learn more about how to create vectors and tables in R.


```r
# libraries needed for these examples
library(tidyverse)  ## contains purrr, tidyr, dplyr
```

```
## ── Attaching packages ──────────────────────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.8
## ✔ tidyr   0.8.2     ✔ stringr 1.3.1
## ✔ readr   1.3.0     ✔ forcats 0.3.0
```

```
## ── Conflicts ─────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

### Iteration functions

#### `rep()`

The function `rep()` lefts you repeat the first argument a number of times.

Use `rep()` to create a vector of alternating `"A"` and `"B"` values of length 24.


```r
rep(c("A", "B"), 12)
```

```
##  [1] "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A"
## [18] "B" "A" "B" "A" "B" "A" "B"
```

Use `rep()` to create a vector of 12 `"A"` values followed by 12 `"B"` values


```r
rep(c("A", "B"), each = 12)
```

```
##  [1] "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "B" "B" "B" "B" "B"
## [18] "B" "B" "B" "B" "B" "B" "B"
```

Use `rep()` to create a vector of 11 `"A"` values followed by 3 `"B"` values


```r
rep(c("A", "B"), c(11, 3))
```

```
##  [1] "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "B" "B" "B"
```

#### `seq()`

The function `seq()` is useful for generating a sequence of numbers with some pattern.

Use `seq()` to create a vector of the numbers 0 to 100 by 10s.


```r
seq(0, 100, by = 10)
```

```
##  [1]   0  10  20  30  40  50  60  70  80  90 100
```

The argument `length.out` is useful if you know how many steps you want to divide something into Use `seq()` to create a vector that starts with 0, ends with 100, and has 12 equally spaced steps (hint: how many numbers would be in a vector with 2 *steps*?).


```r
seq(0, 100, length.out = 13)
```

```
##  [1]   0.000000   8.333333  16.666667  25.000000  33.333333  41.666667
##  [7]  50.000000  58.333333  66.666667  75.000000  83.333333  91.666667
## [13] 100.000000
```


<!--
Use `tibble::tibble()` to create a table including the vector `err` created in question 4 as a column.  Your table should mimic the structure of the table below (your values for `err` will differ), with the constraint that `Y = mu + eff + err`.  Store this table in `dat`.


```r
dat <- tibble(
  mu = 100,
  eff = rep(c(-3, 3), each = 5),
  A = rep(c("A1", "A2"), each = 5),
  err = rnorm(10),
  Y = mu + eff + err
) %>%
select(Y, mu:err)
```

### `aov()`, `summary()`, and `broom::tidy()`

The table you created above is what is known as a *decomposition matrix* for a linear model where `Y` is the dependent variable and `A` is the independent variable with two levels.  The main effects of `A` are `-3` for `A1` and `3` for `A2`; a 6 unit difference.  `mu` ( $\mu$ ) is the grand mean and `err` is the residual.  Run a one-factor ANOVA on the above data using the `aov()` function.  Run `summary()` on the result.


```r
mod <- aov(Y ~ A, dat)

summary(mod)
```

```
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## A            1 116.53  116.53   125.9 3.57e-06 ***
## Residuals    8   7.41    0.93                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Now tidy the results into a table using `broom::tidy()`, pull out the $p$-value and store it in `pval`.


```r
pval <- mod %>%
  broom::tidy() %>% 
  pull(p.value) %>% 
  pluck(1)
pval
```

```
## [1] 3.574812e-06
```
-->

### Custom functions

<!--
Now we are going to wrap up the code we created above into two custom functions: `sim_data()`, which will generate a `tibble()` with randomly generated two group data; and `run_anova()` which will run an anova on a data table.  But let's first get some practice creating functions.
-->

In addition to the built-n functions and functions you can access from packages, you can also write your own functions (and eventually even packages!).

#### Structuring a function

The general structure of a function is as follows:


```r
function_name <- function(my_args) {
  # process the arguments
  # return some value
}
```

Here is a very simple function. Can you guess what it does?


```r
add1 <- function(my_number) {
  my_number + 1
}

add1(10)
```

```
## [1] 11
```

Let's make a function that reports p-values in APA format (with "p = rounded value" when p >= .001 and "p < .001" when p < .001).

First, we have to name the function. You can name it anything, but try not to duplicate existing functions or you will overwrite them. For example, if you call your function `rep`, then you will need to use `base::rep()` to access the normal `rep` function. Let's call our p-value function `report_p` and set up the framework of the function.


```r
report_p <- function() {
}
```

#### Arguments

We need to add one *argument*, the p-value you want to report. The names you choose for the arguments are private to that argument, so it is not a problem if they conflict with other variables in your script. You put the arguments in the parentheses after `function` in the order you want them to default (just like the built-in functions you've used before). 


```r
report_p <- function(p) {
}
```

#### Argument defaults

You can add a default value to any argument. If that argument is skipped, then the function uses the default argument. It probably doesn't make sense to run this function without specifying the p-value, but we can add a second argument called `digits` that defaults to 3, so we can round p-values to 3 digits.


```r
report_p <- function(p, digits = 3) {
}
```

Now we need to write some code inside the function to process the input arguments and turn them into a *return*ed output. Put the output as the last item in function.


```r
report_p <- function(p, digits = 3) {
  if (p < .001) {
    reported = "p < .001"
  } else {
    roundp <- round(p, digits)
    reported = paste("p =", roundp)
  }
  
  reported
}
```

You might also see the returned output inside of the `return()` function. This does the same thing.


```r
report_p <- function(p, digits = 3) {
  if (p < .001) {
    reported = "p < .001"
  } else {
    roundp <- round(p, digits)
    reported = paste("p =", roundp)
  }
  
  return(reported)
}
```

When you run the code defining your function, it doesn't output anything, but makes a new object in the Environment tab under "Functions". Now you can run the function.


```r
report_p(0.04869)
```

```
## [1] "p = 0.049"
```

```r
report_p(0.0000023)
```

```
## [1] "p < .001"
```

#### Scope

What happens in a function stays in a function. You can change the value of a variable passed to a function, but that won't change the value of the variable outside of the function, even if that variable has the same name as the one in the function.


```r
half <- function(x) {
  x <- x/2
  return(x)
}

x <- 10
list(
  "half(x)" = half(x),
  "x" = x
)
```

```
## $`half(x)`
## [1] 5
## 
## $x
## [1] 10
```


#### Warnings and errors

<p class="alert alert-info">What happens when you omit the argument for `p`? Or if you set `p` to 1.5 or "a"?</p>

You might want to add a more specific warning and stop running the function code if someone enters a value that isn't a number. You can do this with the `stop()` function.

If someone enters a number that isn't possible for a p-value (0-1), you might want to warn them that this is probably not what they intended, but still continue with the function. You can do this with `warning()`.


```r
report_p <- function(p, digits = 3) {
  if (!is.numeric(p)) stop("p must be a number")
  if (p <= 0) warning("p-values are normally greater than 0")
  if (p >= 1) warning("p-values are normally less than 1")
  
  if (p < .001) {
    reported = "p < .001"
  } else {
    roundp <- round(p, digits)
    reported = paste("p =", roundp)
  }
  
  reported
}
```


```r
report_p()
```

```
## Error in report_p(): argument "p" is missing, with no default
```

```r
report_p("a")
```

```
## Error in report_p("a"): p must be a number
```

```r
report_p(-2)
```

```
## Warning in report_p(-2): p-values are normally greater than 0
```

```
## [1] "p < .001"
```

```r
report_p(2)
```

```
## Warning in report_p(2): p-values are normally less than 1
```

```
## [1] "p = 2"
```

### Iterating your own functions

First, let's build up the code that we want to iterate.

#### `rnorm()`

Create a vector of 20 random numbers drawn from a normal distribution with a mean of 5 and standard deviation of 1 using the `rnorm()` function and store them in the variable `A`.


```r
A <- rnorm(20, mean = 5, sd = 1)
```

#### `tibble::tibble()`

A `tibble` is a type of table or `data.frame`. The function `tibble::tibble()` creates a tibble with a column for each argument. Each argument takes the form `column_name = data_vector`.

Create a table called `dat` including two vectors: `A` that is a vector of 20 random normally distributed numbers with a mean of 5 and SD of 1, and `B` that is a vector of 20 random normally distributed numbers with a mean of 5.5 and SD of 1.


```r
dat <- tibble(
  A = rnorm(20, 5, 1),
  B = rnorm(20, 5.5, 1)
)
```

#### `t.test`

You can run a Welch two-sample t-test by including the two samples you made as the first two arguments to the function `t.test`. You can reference one column of a table by its names using the format `table_name$column_name`


```r
t.test(dat$A, dat$B)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  dat$A and dat$B
## t = -2.0448, df = 37.784, p-value = 0.04789
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.308466638 -0.006424632
## sample estimates:
## mean of x mean of y 
##  5.261487  5.918932
```

You can also convert the table to long format using the `gather` function and specify the t-test using the format `number_column~grouping_column`.


```r
longdat <- gather(dat, group, score, A:B)

t.test(score~group, data = longdat) 
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  score by group
## t = -2.0448, df = 37.784, p-value = 0.04789
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.308466638 -0.006424632
## sample estimates:
## mean in group A mean in group B 
##        5.261487        5.918932
```

#### `broom::tidy()`

You can use the function `broom::tidy()` to extract the data from a statistical test in a table format. The example below pipes everything together.


```r
tibble(
  A = rnorm(20, 5, 1),
  B = rnorm(20, 5.5, 1)
) %>%
  gather(group, score, A:B) %>%
  t.test(score~group, data = .) %>%
  broom::tidy()
```

```
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic p.value parameter conf.low
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>
## 1   -0.603      5.00      5.60     -1.83  0.0750      36.9    -1.27
## # ... with 3 more variables: conf.high <dbl>, method <chr>,
## #   alternative <chr>
```

Finally, we can extract a single value from this results table using `pull()`.


```r
tibble(
  A = rnorm(20, 5, 1),
  B = rnorm(20, 5.5, 1)
) %>%
  gather(group, score, A:B) %>%
  t.test(score~group, data = .) %>%
  broom::tidy() %>%
  pull(p.value)
```

```
## [1] 0.9353767
```

#### Turn into a function

First, name your function `t_sim` and wrap the code above in a function with no arguments. 


```r
t_sim <- function() {
  tibble(
    A = rnorm(20, 5, 1),
    B = rnorm(20, 5.5, 1)
  ) %>%
    gather(group, score, A:B) %>%
    t.test(score~group, data = .) %>%
    broom::tidy() %>%
    pull(p.value) 
}
```

Run it a few times to see what happens.


```r
t_sim()
```

```
## [1] 0.219669
```

#### `replicate()`

You can use the `replicate` function to run your function any number of times. Let's run the `t_sim` function 1000 times, assign the resulting p-values to a vector called `reps`, and check what proportion of p-values are lower than alpha (e.g., .05). This number is the power for this analysis.


```r
reps <- replicate(1000, t_sim())
alpha <- .05
power <- mean(reps < alpha)
power
```

```
## [1] 0.356
```

#### Add arguments

You can just edit your function each time you want to cacluate power for a different sample n, but it is more efficent to build this into your fuction as an arguments. Redefine `t_sim`, setting arguments for the mean and SD of group A, the mean and SD of group B, and the number of subjects per group. Give them all default values.


```r
t_sim <- function(n = 10, m1=0, sd1=1, m2=0, sd2=1) {
  tibble(
    A = rnorm(n, m1, sd1),
    B = rnorm(n, m2, sd2)
  ) %>%
    gather(group, score, A:B) %>%
    t.test(score~group, data = .) %>%
    broom::tidy() %>%
    pull(p.value) 
}
```

Test your function with some different values to see if the results make sense.


```r
t_sim(100)
```

```
## [1] 0.4012639
```

```r
t_sim(100, 0, 1, 0.5, 1)
```

```
## [1] 3.092877e-06
```

Use `replicate` to calculate power for 100 subjects/group with an effect size of 0.2 (e.g., A: m = 0, SD = 1; B: m = 0.2, SD = 1). Use 1000 replications.


```r
reps <- replicate(1000, t_sim(100, 0, 1, 0.2, 1))
power <- mean(reps < .05)
power
```

```
## [1] 0.302
```

Compare this to power calculated from the `power.t.test` function.


```r
power.t.test(n = 100, delta = 0.2, sd = 1, type="two.sample")
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 100
##           delta = 0.2
##              sd = 1
##       sig.level = 0.05
##           power = 0.2902664
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

Calculate power via simulation and `power.t.test` for the following tests:

* 20 subjects/group, A: m = 0, SD = 1; B: m = 0.2, SD = 1
* 40 subjects/group, A: m = 0, SD = 1; B: m = 0.2, SD = 1
* 20 subjects/group, A: m = 10, SD = 1; B: m = 12, SD = 1.5

<!--
### Custom functions: `sim_data`

Put the code you used to create `dat` above as the body of a new function `sim_data()` with no arguments.  Call the function twice to make sure it works and that it gives you different data each time.


```r
sim_data <- function() {
  tibble(
    mu = 100,
    eff = rep(c(-3, 3), each = 5),
    A = rep(c("A1", "A2"), each = 5),
    err = rnorm(10),
    Y = mu + eff + err) %>%
  select(Y, mu:err)
}
```

Now re-write `sim_data()` to allow the user to change the values of `mu`, `eff`, and the standard deviation of `err`.  The use the values you used before as defaults.


```r
sim_data <- function(mu = 100, eff = 3, sd = 1) {
  tibble(
    mu = mu,
    eff = rep(c(-eff, eff), each = 5),
    A = rep(c("A1", "A2"), each = 5),
    err = rnorm(10, sd = sd),
    Y = mu + eff + err) %>%
  select(Y, mu:err)
}

sim_data()
```

```
## # A tibble: 10 x 5
##        Y    mu   eff A         err
##    <dbl> <dbl> <dbl> <chr>   <dbl>
##  1  97.4   100    -3 A1     0.389 
##  2  96.2   100    -3 A1    -0.802 
##  3  97.1   100    -3 A1     0.0935
##  4  97.3   100    -3 A1     0.338 
##  5  97.9   100    -3 A1     0.890 
##  6 103.    100     3 A2    -0.339 
##  7 102.    100     3 A2    -0.509 
##  8 104.    100     3 A2     0.893 
##  9 103.    100     3 A2    -0.136 
## 10 104.    100     3 A2     0.969
```

<p class="alert alert-info">What happens when you call the function with different values?</p>

Next, re-write it *again* to allow the user to change the number of observations per group through an argument `n_per_group`, which defaults to 5. Run it a few times with varying arguments to check.


```r
sim_data <- function(mu = 100, eff = 3, sd = 1, n_per_group = 5) {
  tibble(mu = mu,
     eff = rep(c(-eff, eff), each = n_per_group),
     A = factor(rep(c("A1", "A2"), each = n_per_group)),
     err = rnorm(2 * n_per_group, sd = sd),
     Y = mu + eff + err) %>%
  select(Y, mu:err)
}

sim_data(n_per_group = 2)
```

```
## # A tibble: 4 x 5
##       Y    mu   eff A        err
##   <dbl> <dbl> <dbl> <fct>  <dbl>
## 1  96.6   100    -3 A1    -0.376
## 2  96.0   100    -3 A1    -0.951
## 3 104.    100     3 A2     1.01 
## 4 103.    100     3 A2    -0.468
```

```r
sim_data(0, 10, 40, 20)
```

```
## # A tibble: 40 x 5
##          Y    mu   eff A        err
##      <dbl> <dbl> <dbl> <fct>  <dbl>
##  1  24.8       0   -10 A1     34.8 
##  2  53.1       0   -10 A1     63.1 
##  3  40.3       0   -10 A1     50.3 
##  4 -34.6       0   -10 A1    -24.6 
##  5   7.48      0   -10 A1     17.5 
##  6  -0.912     0   -10 A1      9.09
##  7 -18.7       0   -10 A1     -8.75
##  8 -27.7       0   -10 A1    -17.7 
##  9 -26.1       0   -10 A1    -16.1 
## 10 -40.8       0   -10 A1    -30.8 
## # ... with 30 more rows
```

OK now let's wrap the code you created to run an ANOVA and get the p-value in the function `run_anova()`.  It should have one argument, `x`, which is the data on which the anova is to be performed, and it should return a single value: the $p$-value.  Call it a few times with `x` as a simulated dataset to make sure it works as you intended, and that the p-values are changing.


```r
run_anova <- function(x) {
  mod <- aov(Y ~ A, x)
  broom::tidy(mod) %>% pull(p.value) %>% pluck(1)
}

run_anova(sim_data())
```

```
## [1] 0.0001247597
```

Modify `run_anova()` so that it accepts an additional argument `all_stats` (default `FALSE`) which determines whether the whole table from `broom::tidy()` is returned (when `TRUE`), or just the $p$-value (when `FALSE`).


```r
run_anova <- function(x, all_stats = FALSE) {
  mod <- aov(Y ~ A, x)
  stats_tbl <- broom::tidy(mod)
  if (all_stats) {
    stats_tbl
  } else {
    stats_tbl %>% pull(p.value) %>% pluck(1)
  }
}

run_anova(sim_data())
```

```
## [1] 2.217877e-06
```

```r
run_anova(sim_data(), TRUE)
```

```
## # A tibble: 2 x 6
##   term         df sumsq meansq statistic     p.value
##   <chr>     <dbl> <dbl>  <dbl>     <dbl>       <dbl>
## 1 A             1 90.2  90.2        115.  0.00000497
## 2 Residuals     8  6.26  0.782       NA  NA
```

## Iterating

Now we're going to pull together what we've done so far and attempt to perform a power analysis through simulation!

Power is *the probability of rejecting a false null hypothesis*, usually denoted as $1 - \beta$ where $\beta$ is the probability of a Type II error (retaining $H_0$ when it is false).  It relates to the sensitivity of an analysis.

For simple designs, like our two-group situation, power can be calculated analytically.  However, for more complicated designs, it is often necessary to run simulations to estimate power.  So although the approach here is overkill (for a two-group design you could use the function `pow.t.test()`) it more generalizable.

Our simulation-based power estimate will involve three main steps:

1. Generate `nmc` number of datasets, where `nmc` is a large number (typically >1000);
2. Run the analysis on the datasets and store the results
3. Analyze the results from step 2

First let's learn about some of the functions used for iteration.  These functions live in the `purrr` package which is part of the tidyverse.

The `purrr::map*` functions are probably the most important.  `purrr::map()` takes a list as its first object and iterates through the elements of the list, passing each element to the function name specified as the second argument and storing the results.  You can choose one of the various `map()` functions depending on how you want the return values stored.  `map_chr()` returns a vector of character strings; `map_dbl()` returns a vector of real numbers; `map_int()` returns a vector of integers.

`map()` is appropriate when you have varying input and want to do something to each element of the input and keep the result.  Sometimes you don't have any input, but just want to do the same thing $X$ times and keep the result.  In this situation, use `purrr::rerun()`.  Other times, you might have varying input, but want to call a function not for the result it will return, but for its side effect (e.g., save a file, or print a message to the user).  In this situation, use `purrr::walk()`.  Take a moment to familiarize yourself with the help pages for these functions.

1. Create a list `dsets` containing 5 datasets using `purrr::rerun()` on your `sim_data()` function.


```r
dsets <- rerun(5, sim_data())
```

2. Now use `map()` on `dsets` to call `run_anova()` on each of the 5 datasets.


```r
map(dsets, run_anova)
```

```
## [[1]]
## [1] 1.555793e-06
## 
## [[2]]
## [1] 4.302451e-05
## 
## [[3]]
## [1] 9.423794e-07
## 
## [[4]]
## [1] 2.13971e-05
## 
## [[5]]
## [1] 4.397582e-06
```

3. Re-write the `map()` command above so that it returns a vector of type `double` instead of a list.  At the same time, re-write it so that it performs steps 1 and 2 in a single line.


```r
map_dbl(rerun(5, sim_data()), run_anova)
```

```
## [1] 2.016016e-05 2.098302e-05 1.853666e-05 2.279787e-05 3.642853e-05
```

4. Write code to count the proportion of runs for which the $p$-value is less than .05.  This is your estimate of power, given the effect size.


```r
n_runs <- 5L
pvals <- map_dbl(rerun(n_runs, sim_data()), run_anova)
psig <- sum(pvals < .05) / n_runs
```

5. Now put all of the code you have created in this section into a new function `sim_power()` which gives the user control over all parameters (`mu`, `eff`, `n_per_group`, `sd`, `n_runs`).  If you need to debug your function, put `browser()` as the first line of the function body and then call it from the console.


```r
sim_power <- function(eff = 0, sd = 6, mu = 0, n_per_group = 10, n_runs = 1000L) {
  pvals <- map_dbl(rerun(n_runs, sim_data(mu, eff, sd, n_per_group)), 
                   run_anova)
  sum(pvals < .05) / n_runs
}
```

6. Check your function by running scenarios where the effect takes on various values, including zero.  Compare your results to `power.t.test()`.


```r
my_eff <- 1
my_sd <- 3

power.t.test(n = 20, delta = my_eff, sd = my_sd)
```

```
## 
##      Two-sample t test power calculation 
## 
##               n = 20
##           delta = 1
##              sd = 3
##       sig.level = 0.05
##           power = 0.1755768
##     alternative = two.sided
## 
## NOTE: n is number in *each* group
```

```r
sim_power(eff = my_eff, sd = my_sd, mu = 0, n_per_group = 20)
```

```
## [1] 0.529
```

-->
