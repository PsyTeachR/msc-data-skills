# Iteration & Functions {#func}

<img src="images/memes/functions.jpg" class="meme right"
     alt="History channel aliens conspiracy guy. Top text: I've got function inside functions...; Bottom text: ... inside functions.">

## Learning Objectives

You will learn about functions and iteration by using simulation to calculate a power analysis for an independent samples t-test.

### Basic

1. Work with [iteration functions](#iteration-functions) `rep`, `seq`, and `replicate`
2. Use [arguments](#arguments) by order or name
3. Write your own [custom functions](#custom-functions) with `function()`
4. Set [default values](#defaults) for the arguments in your functions

### Intermediate

5. Understand [scope](#scope)
6. Use [error handling and warnings](#warnings-errors) in a function

### Advanced

<img src="images/memes/purrr.gif" class="meme right">

The topics below are not (yet) covered in these materials, but they are directions for independent learning.

7. Repeat commands and handle result using `purrr::rerun()`, `purrr::map_*()`, `purrr::walk()`
8. Repeat commands having multiple arguments using `purrr::map2_*()` and `purrr::pmap_*()`
9. Create **nested data frames** using `dplyr::group_by()` and `tidyr::nest()`
10. Work with **nested data frames** in `dplyr`
11. Capture and deal with errors using 'adverb' functions `purrr::safely()` and `purrr::possibly()`

## Resources

* Chapters 19 and 21 of [R for Data Science](http://r4ds.had.co.nz)
* [RStudio Apply Functions Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/purrr.pdf)
* [Stub for this lesson](stubs/7_func.Rmd)

In the next two lectures, we are going to learn more about <a class='glossary' target='_blank' title='NA' href='https://psyteachr.github.io/glossary/i#iteration'>iteration</a> (doing the same commands over and over) and <a class='glossary' target='_blank' title='NA' href='https://psyteachr.github.io/glossary/c#custom-functions'>custom functions</a> through a data simulation exercise, which will also lead us into more traditional statistical topics.


```r
# libraries needed for these examples
library(tidyverse)  ## contains purrr, tidyr, dplyr
library(broom) ## converts test output to tidy tables

set.seed(8675309) # makes sure random numbers are reproducible
```

## Iteration functions {#iteration-functions}

We first learned about the two basic iteration functions, `rep()` and `seq()` in the [Working with Data](#rep_seq) chapter.

### `rep()`

The function `rep()` lets you repeat the first argument a number of times.

Use `rep()` to create a vector of alternating `"A"` and `"B"` values of length 24.


```r
rep(c("A", "B"), 12)
```

```
##  [1] "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A"
## [20] "B" "A" "B" "A" "B"
```

If you don't specify what the second argument is, it defaults to `times`, repeating the vector in the first argument that many times. Make the same vector as above, setting the second argument explicitly.


```r
rep(c("A", "B"), times = 12)
```

```
##  [1] "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A" "B" "A"
## [20] "B" "A" "B" "A" "B"
```

If the second argument is a vector that is the same length as the first argument, each element in the first vector is repeated than many times. Use `rep()` to create a vector of 11 `"A"` values followed by 3 `"B"` values.


```r
rep(c("A", "B"), c(11, 3))
```

```
##  [1] "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "B" "B" "B"
```

You can repeat each element of the vector a sepcified number of times using the `each` argument, Use `rep()` to create a vector of 12 `"A"` values followed by 12 `"B"` values.


```r
rep(c("A", "B"), each = 12)
```

```
##  [1] "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "B" "B" "B" "B" "B" "B" "B"
## [20] "B" "B" "B" "B" "B"
```

What do you think will happen if you set both `times` to 3 and `each` to 2?


```r
rep(c("A", "B"), times = 3, each = 2)
```

```
##  [1] "A" "A" "B" "B" "A" "A" "B" "B" "A" "A" "B" "B"
```


### `seq()`

The function `seq()` is useful for generating a sequence of numbers with some pattern.

Use `seq()` to create a vector of the integers 0 to 10.


```r
seq(0, 10)
```

```
##  [1]  0  1  2  3  4  5  6  7  8  9 10
```

You can set the `by` argument to count by numbers other than 1 (the default). Use `seq()` to create a vector of the numbers 0 to 100 by 10s.


```r
seq(0, 100, by = 10)
```

```
##  [1]   0  10  20  30  40  50  60  70  80  90 100
```

The argument `length.out` is useful if you know how many steps you want to divide something into. Use `seq()` to create a vector that starts with 0, ends with 100, and has 12 equally spaced steps (hint: how many numbers would be in a vector with 2 *steps*?).


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
## A            1  95.85   95.85   113.6 5.26e-06 ***
## Residuals    8   6.75    0.84                     
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
## [1] 5.258951e-06
```
-->

## Custom functions {#custom-functions}

<!--
Now we are going to wrap up the code we created above into two custom functions: `sim_data()`, which will generate a `tibble()` with randomly generated two group data; and `run_anova()` which will run an anova on a data table.  But let's first get some practice creating functions.
-->

In addition to the built-in functions and functions you can access from packages, you can also write your own functions (and eventually even packages!).

### Structuring a function {#structure-function}

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

### Arguments {#arguments}

We need to add one *argument*, the p-value you want to report. The names you choose for the arguments are private to that argument, so it is not a problem if they conflict with other variables in your script. You put the arguments in the parentheses after `function` in the order you want them to default (just like the built-in functions you've used before). 


```r
report_p <- function(p) {
}
```

### Argument defaults {#defaults}

You can add a default value to any argument. If that argument is skipped, then the function uses the default argument. It probably doesn't make sense to run this function without specifying the p-value, but we can add a second argument called `digits` that defaults to 3, so we can round p-values to 3 digits.


```r
report_p <- function(p, digits = 3) {
}
```

Now we need to write some code inside the function to process the input arguments and turn them into a **return**ed output. Put the output as the last item in function.


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

When you run the code defining your function, it doesn't output anything, but makes a new object in the Environment tab under **`Functions`**. Now you can run the function.


```r
report_p(0.04869)
report_p(0.0000023)
```

```
## [1] "p = 0.049"
## [1] "p < .001"
```

### Scope {#scope}

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


### Warnings and errors {#warnings-errors}

<div class="try">
What happens when you omit the argument for <code>p</code>? Or if you set <code>p</code> to 1.5 or “a”?
</p>
</div>

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

```r
report_p(2)
```

```
## Warning in report_p(2): p-values are normally less than 1
```

```
## [1] "p < .001"
## [1] "p = 2"
```

## Iterating your own functions

First, let's build up the code that we want to iterate.

### `rnorm()`

Create a vector of 20 random numbers drawn from a normal distribution with a mean of 5 and standard deviation of 1 using the `rnorm()` function and store them in the variable `A`.


```r
A <- rnorm(20, mean = 5, sd = 1)
```

### `tibble::tibble()`

A `tibble` is a type of table or `data.frame`. The function `tibble::tibble()` creates a tibble with a column for each argument. Each argument takes the form `column_name = data_vector`.

Create a table called `dat` including two vectors: `A` that is a vector of 20 random normally distributed numbers with a mean of 5 and SD of 1, and `B` that is a vector of 20 random normally distributed numbers with a mean of 5.5 and SD of 1.


```r
dat <- tibble(
  A = rnorm(20, 5, 1),
  B = rnorm(20, 5.5, 1)
)
```

### `t.test`

You can run a Welch two-sample t-test by including the two samples you made as the first two arguments to the function `t.test`. You can reference one column of a table by its names using the format `table_name$column_name`


```r
t.test(dat$A, dat$B)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  dat$A and dat$B
## t = -1.5937, df = 36.528, p-value = 0.1196
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.9559243  0.1144139
## sample estimates:
## mean of x mean of y 
##  4.965341  5.386096
```

You can also convert the table to long format using the `gather` function and specify the t-test using the format `dv_column~grouping_column`.


```r
longdat <- gather(dat, group, score, A:B)

t.test(score~group, data = longdat) 
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  score by group
## t = -1.5937, df = 36.528, p-value = 0.1196
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.9559243  0.1144139
## sample estimates:
## mean in group A mean in group B 
##        4.965341        5.386096
```

### `broom::tidy()`

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
##   estimate estimate1 estimate2 statistic p.value parameter conf.low conf.high
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>     <dbl>
## 1   -0.578      4.97      5.54     -1.84  0.0747      34.3    -1.22    0.0606
## # … with 2 more variables: method <chr>, alternative <chr>
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
## [1] 0.256199
```

### Turn into a function

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
## [1] 0.0558203
```

### `replicate()`

You can use the `replicate` function to run a function any number of times.


```r
replicate(3, rnorm(5))
```

```
##            [,1]      [,2]        [,3]
## [1,]  0.2398579 1.0060960 -0.08836476
## [2,] -1.7685708 0.8362997  0.08114036
## [3,]  0.1457033 0.4557277  1.38814525
## [4,]  0.4462924 0.5616177 -0.02341062
## [5,]  0.5916637 1.4850093  0.98759269
```

Let's run the `t_sim` function 1000 times, assign the resulting p-values to a vector called `reps`, and check what proportion of p-values are lower than alpha (e.g., .05). This number is the power for this analysis.


```r
reps <- replicate(1000, t_sim())
alpha <- .05
power <- mean(reps < alpha)
power
```

```
## [1] 0.304
```

### Set seed {#seed}

You can use the `set.seed` function before you run a function that uses random numbers to make sure that you get the same random data back each time. You can use any integer you like as the seed.


```r
set.seed(90201)
```

<div class="warning">
<p>Make sure you don’t ever use <code>set.seed()</code> <strong>inside</strong> of a simulation function, or you will just simulate the exact same data over and over again.</p>
</div>

<div class="figure" style="text-align: center">
<img src="images/memes/seed_alignment.png" alt="&amp;commat;KellyBodwin" width="100%" />
<p class="caption">(\#fig:img-seed-alignment)&commat;KellyBodwin</p>
</div>

### Add arguments

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
t_sim(100, 0, 1, 0.5, 1)
```

```
## [1] 0.5065619
## [1] 0.001844064
```

Use `replicate` to calculate power for 100 subjects/group with an effect size of 0.2 (e.g., A: m = 0, SD = 1; B: m = 0.2, SD = 1). Use 1000 replications.


```r
reps <- replicate(1000, t_sim(100, 0, 1, 0.2, 1))
power <- mean(reps < .05)
power
```

```
## [1] 0.268
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

## Glossary {#glossary7}



|term                                                                                                                    |definition |
|:-----------------------------------------------------------------------------------------------------------------------|:----------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/c#custom.functions'>custom functions</a> |NA         |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/i#iteration'>iteration</a>               |NA         |



## Exercises

Download the [exercises](exercises/07_func_exercise.Rmd). See the [answers](exercises/07_func_answers.Rmd) only after you've attempted all the questions.


```r
# run this to access the exercise
dataskills::exercise(7)

# run this to access the answers
dataskills::exercise(7, answers = TRUE)
```
