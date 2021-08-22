# Iteration & Functions {#func}

<img src="images/memes/functions.jpg" class="meme right"
     alt="History channel aliens conspiracy guy. Top text: I've got function inside functions...; Bottom text: ... inside functions.">

## Learning Objectives {#ilo7}

You will learn about functions and iteration by using simulation to calculate a power analysis for an independent samples t-test.

### Basic

1. Work with basic [iteration functions](#iteration-functions) `rep`, `seq`, `replicate` [(video)](https://youtu.be/X3zFA71JzgE){class="video"}
2. Use [`map()` and `apply()` functions](#map-apply) [(video)](https://youtu.be/HcZxQZwJ8T4){class="video"}
3. Write your own [custom functions](#custom-functions) with `function()` [(video)](https://youtu.be/Qqjva0xgYC4){class="video"}
4. Set [default values](#defaults) for the arguments in your functions

### Intermediate

5. Understand [scope](#scope)
6. Use [error handling and warnings](#warnings-errors) in a function

### Advanced

<img src="images/memes/purrr.gif" class="meme right"
     alt="Jacobim Mugatu (Will Ferrell) and Katinka Ingabogovinanana (Mila Jojovich) from Zoolander, sitting in a theatre with a small dog; bottom text: purrr::map so hot right now">

The topics below are not (yet) covered in these materials, but they are directions for independent learning.

7. Repeat commands having multiple arguments using `purrr::map2_*()` and `purrr::pmap_*()`
8. Create **nested data frames** using `dplyr::group_by()` and `tidyr::nest()`
9. Work with **nested data frames** in `dplyr`
10. Capture and deal with errors using 'adverb' functions `purrr::safely()` and `purrr::possibly()`

## Resources {#resources7}

* Chapters 19 and 21 of [R for Data Science](http://r4ds.had.co.nz)
* [RStudio Apply Functions Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/purrr.pdf)

In the next two lectures, we are going to learn more about <a class='glossary' target='_blank' title='Repeating a process or function' href='https://psyteachr.github.io/glossary/i#iteration'>iteration</a> (doing the same commands over and over) and custom <a class='glossary' target='_blank' title='A named section of code that can be reused.' href='https://psyteachr.github.io/glossary/f#function'>functions</a> through a data simulation exercise, which will also lead us into more traditional statistical topics.

## Setup  {#setup7}


```r
# libraries needed for these examples
library(tidyverse)  ## contains purrr, tidyr, dplyr
library(broom) ## converts test output to tidy tables

set.seed(8675309) # makes sure random numbers are reproducible
```

## Iteration functions {#iteration-functions}

We first learned about the two basic iteration functions, `rep()` and `seq()` in the [Working with Data](#rep_seq) chapter.

### rep()

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


### seq()

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

### replicate() 

You can use the `replicate()` function to run a function `n` times.

For example, you can get 3 sets of 5 numbers from a random normal distribution by setting `n` to `3` and `expr` to `rnorm(5)`.


```r
replicate(n = 3, expr = rnorm(5))
```

```
##            [,1]       [,2]       [,3]
## [1,] -0.9965824 0.98721974 -1.5495524
## [2,]  0.7218241 0.02745393  1.0226378
## [3,] -0.6172088 0.67287232  0.1500832
## [4,]  2.0293916 0.57206650 -0.6599640
## [5,]  1.0654161 0.90367770 -0.9945890
```

By default, `replicate()` simplifies your result into a <a class='glossary' target='_blank' title='A container data type consisting of numbers arranged into a fixed number of rows and columns' href='https://psyteachr.github.io/glossary/m#matrix'>matrix</a> that is easy to convert into a table if your function returns vectors that are the same length. If you'd rather have a list of vectors, set `simplify = FALSE`.


```r
replicate(n = 3, expr = rnorm(5), simplify = FALSE)
```

```
## [[1]]
## [1]  1.9724587 -0.4418016 -0.9006372 -0.1505882 -0.8278942
## 
## [[2]]
## [1]  1.98582582  0.04400503 -0.40428231 -0.47299855 -0.41482324
## 
## [[3]]
## [1]  0.6832342  0.6902011  0.5334919 -0.1861048  0.3829458
```


### map() and apply() functions {#map-apply}

`purrr::map()` and `lapply()` return a list of the same length as a vector or list, each element of which is the result of applying a function to the corresponding element. They function much the same, but purrr functions have some optimisations for working with the tidyverse. We'll be working mostly with purrr functions in this course, but apply functions are very common in code that you might see in examples on the web.

Imagine you want to calculate the power for a two-sample t-test with a mean difference of 0.2 and SD of 1, for all the sample sizes 100 to 1000 (by 100s). You could run the `power.t.test()` function 20 times and extract the values for "power" from the resulting list and put it in a table.


```r
p100 <- power.t.test(n = 100, delta = 0.2, sd = 1, type="two.sample")
# 18 more lines
p1000 <- power.t.test(n = 500, delta = 0.2, sd = 1, type="two.sample")

tibble(
  n = c(100, "...", 1000),
  power = c(p100$power, "...", p1000$power)
)
```

<div class="kable-table">

|n    |power             |
|:----|:-----------------|
|100  |0.290266404572217 |
|...  |...               |
|1000 |0.884788352886661 |

</div>

However, the `apply()` and `map()` functions allow you to perform a function on each item in a vector or list. First make an object `n` that is the vector of the sample sizes you want to test, then use `lapply()` or `map()` to run the function `power.t.test()` on each item. You can set other arguments to `power.t.test()` after the function argument.


```r
n <- seq(100, 1000, 100)
pcalc <- lapply(n, power.t.test, 
                delta = 0.2, sd = 1, type="two.sample")
# or
pcalc <- purrr::map(n, power.t.test, 
                delta = 0.2, sd = 1, type="two.sample")
```

These functions return a list where each item is the result of `power.t.test()`, which returns a list of results that includes the named item "power". This is a special list that has a summary format if you just print it directly:


```r
pcalc[[1]]
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

But you can see the individual items using the `str()` function.


```r
pcalc[[1]] %>% str()
```

```
## List of 8
##  $ n          : num 100
##  $ delta      : num 0.2
##  $ sd         : num 1
##  $ sig.level  : num 0.05
##  $ power      : num 0.29
##  $ alternative: chr "two.sided"
##  $ note       : chr "n is number in *each* group"
##  $ method     : chr "Two-sample t test power calculation"
##  - attr(*, "class")= chr "power.htest"
```


`sapply()` is a version of `lapply()` that returns a vector or array instead of a list, where appropriate. The corresponding purrr functions are `map_dbl()`, `map_chr()`, `map_int()` and `map_lgl()`, which return vectors with the corresponding <a class='glossary' target='_blank' title='The kind of data represented by an object.' href='https://psyteachr.github.io/glossary/d#data-type'>data type</a>.

You can extract a value from a list with the function `[[`. You usually see this written as `pcalc[[1]]`, but if you put it inside backticks, you can use it in apply and map functions.


```r
sapply(pcalc, `[[`, "power")
```

```
##  [1] 0.2902664 0.5140434 0.6863712 0.8064964 0.8847884 0.9333687 0.9623901
##  [8] 0.9792066 0.9887083 0.9939638
```

We use `map_dbl()` here because the value for "power" is a <a class='glossary' target='_blank' title='A data type representing a real decimal number' href='https://psyteachr.github.io/glossary/d#double'>double</a>.


```r
purrr::map_dbl(pcalc, `[[`, "power")
```

```
##  [1] 0.2902664 0.5140434 0.6863712 0.8064964 0.8847884 0.9333687 0.9623901
##  [8] 0.9792066 0.9887083 0.9939638
```

We can use the `map()` functions inside a `mutate()` function to run the `power.t.test()` function on the value of `n` from each row of a table, then extract the value for "power", and delete the column with the power calculations.


```r
mypower <- tibble(
  n = seq(100, 1000, 100)) %>%
  mutate(pcalc = purrr::map(n, power.t.test, 
                            delta = 0.2, 
                            sd = 1, 
                            type="two.sample"),
         power = purrr::map_dbl(pcalc, `[[`, "power")) %>%
  select(-pcalc)
```


<div class="figure" style="text-align: center">
<img src="07-func_files/figure-html/purrr-plot-1.png" alt="Power for a two-sample t-test with d = 0.2" width="100%" />
<p class="caption">(\#fig:purrr-plot)Power for a two-sample t-test with d = 0.2</p>
</div>



## Custom functions {#custom-functions}

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

Let's make a function that reports p-values in APA format (with "p = [rounded value]" when p >= .001 and "p < .001" when p < .001).

First, we have to name the function. You can name it anything, but try not to duplicate existing functions or you will overwrite them. For example, if you call your function `rep`, then you will need to use `base::rep()` to access the normal `rep` function. Let's call our p-value function `report_p` and set up the framework of the function.


```r
report_p <- function() {
}
```

### Arguments {#arguments}

We need to add one <a class='glossary' target='_blank' title='A variable that provides input to a function.' href='https://psyteachr.github.io/glossary/a#argument'>argument</a>, the p-value you want to report. The names you choose for the arguments are private to that argument, so it is not a problem if they conflict with other variables in your script. You put the arguments in the parentheses of `function()` in the order you want them to default (just like the built-in functions you've used before). 


```r
report_p <- function(p) {
}
```

### Argument defaults {#defaults}

You can add a default value to any argument. If that argument is skipped, then the function uses the default argument. It probably doesn't make sense to run this function without specifying the p-value, but we can add a second argument called `digits` that defaults to 3, so we can round p-values to any number of digits.


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
reported <- "not changed"

# inside this function, reported == "p = 0.002"
report_p(0.0023) 

reported # still "not changed"
```

```
## [1] "p = 0.002"
## [1] "not changed"
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

### rnorm()

Create a vector of 20 random numbers drawn from a normal distribution with a mean of 5 and standard deviation of 1 using the `rnorm()` function and store them in the variable `A`.


```r
A <- rnorm(20, mean = 5, sd = 1)
```

### tibble::tibble()

A `tibble` is a type of table or `data.frame`. The function `tibble::tibble()` creates a tibble with a column for each argument. Each argument takes the form `column_name = data_vector`.

Create a table called `dat` including two vectors: `A` that is a vector of 20 random normally distributed numbers with a mean of 5 and SD of 1, and `B` that is a vector of 20 random normally distributed numbers with a mean of 5.5 and SD of 1.


```r
dat <- tibble(
  A = rnorm(20, 5, 1),
  B = rnorm(20, 5.5, 1)
)
```

### t.test()

You can run a Welch two-sample t-test by including the two samples you made as the first two arguments to the function `t.test`. You can reference one column of a table by its names using the format `table_name$column_name`


```r
t.test(dat$A, dat$B)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  dat$A and dat$B
## t = -1.7716, df = 36.244, p-value = 0.08487
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -1.2445818  0.0838683
## sample estimates:
## mean of x mean of y 
##  4.886096  5.466453
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
## t = -1.7716, df = 36.244, p-value = 0.08487
## alternative hypothesis: true difference in means between group A and group B is not equal to 0
## 95 percent confidence interval:
##  -1.2445818  0.0838683
## sample estimates:
## mean in group A mean in group B 
##        4.886096        5.466453
```

### broom::tidy()

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

<div class="kable-table">

|   estimate| estimate1| estimate2| statistic|   p.value| parameter|  conf.low|  conf.high|method                  |alternative |
|----------:|---------:|---------:|---------:|---------:|---------:|---------:|----------:|:-----------------------|:-----------|
| -0.6422108|  5.044009|   5.68622| -2.310591| 0.0264905|  37.27083| -1.205237| -0.0791844|Welch Two Sample t-test |two.sided   |

</div>

<div class="info">
<p>In the pipeline above, <code>t.test(score~group, data = .)</code> uses the <code>.</code> notation to change the location of the piped-in data table from it’s default position as the first argument to a different position.</p>
</div>

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
## [1] 0.7075268
```

### Custom function: t_sim()

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
## [1] 0.00997552
```

### Iterate t_sim()

Let's run the `t_sim` function 1000 times, assign the resulting p-values to a vector called `reps`, and check what proportion of p-values are lower than alpha (e.g., .05). This number is the power for this analysis.


```r
reps <- replicate(1000, t_sim())
alpha <- .05
power <- mean(reps < alpha)
power
```

```
## [1] 0.328
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



|term                                                                                                      |definition                                                                                   |
|:---------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/a#argument'>argument</a>   |A variable that provides input to a function.                                                |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/d#data.type'>data type</a> |The kind of data represented by an object.                                                   |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/d#double'>double</a>       |A data type representing a real decimal number                                               |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/f#function.'>function </a> |A named section of code that can be reused.                                                  |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/i#iteration'>iteration</a> |Repeating a process or function                                                              |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/m#matrix'>matrix</a>       |A container data type consisting of numbers arranged into a fixed number of rows and columns |



## Exercises {#exercises7}

Download the [exercises](exercises/07_func_exercise.Rmd). See the [answers](exercises/07_func_answers.Rmd) only after you've attempted all the questions.


```r
# run this to access the exercise
dataskills::exercise(7)

# run this to access the answers
dataskills::exercise(7, answers = TRUE)
```
