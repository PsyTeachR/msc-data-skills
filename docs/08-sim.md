# Probability & Simulation {#sim}

## Learning Objectives {.tabset}

### Basic

1. Understand what types of data are best modeled by different distributions
    + uniform
    + binomial
    + normal
    + poisson
2. Generate and plot data randomly sampled from the above distributions
3. Test sampled distributions against a null hypothesis
    + exact binomial test
    + t-test (1-sample, independent samples, paired samples)
    + correlation (pearson, kendall and spearman)
4. Define the following statistical terms:
    + p-value
    + alpha
    + power
    + false positive (type I error)
    + false negative (type II error)
    + confidence interval

### Intermediate

5. Create a function to generate a sample with specific properties and run an inferential test
6. Calculate power using `replicate` and a sampling function
7. Calculate the minimum sample size for a specific power level and design

### Advanced

8. Generate 3+ variables from a multivariate normal distribution and plot them

## Prep

* [Chapter 21: Iteration](http://r4ds.had.co.nz/iteration.html)  of *R for Data Science* 


## Resources

* [Improving your statistical inferences](https://www.coursera.org/learn/statistical-inferences/) on Coursera (week 1)

## Formative exercises

Download the [formative exercises](formative_exercises/08_simulations_stub.Rmd). See the [answers](formative_exercises/08_simulations_answers.Rmd) only after you've attempted all the questions.


## Class Notes

Simulating data is a very powerful way to test your understanding of statistical 
concepts. We are going to use simulations to learn the basics of probability.


```r
# libraries needed for these examples
library(tidyverse)
library(MASS)
```

### Uniform Distribution

The uniform distribution is the simplest distribution. All numbers in the range 
have an equal probability of being sampled. 

#### Sample continuous distribution

`runif(n, min=0, max=1)` 

Use `runif()` to sample from a continuous uniform distribution.


```r
runif(10, min = 0, max = 1)
```

```
##  [1] 0.4385462 0.6849549 0.5008744 0.9106998 0.5040163 0.1870981 0.9105662
##  [8] 0.2693800 0.2505661 0.3942486
```

#### Sample discrete distribution

`sample(x, size, replace = FALSE, prob = NULL)`

Use `sample()` to sample from a discrete distribution.

Simulate a single roll of a 6-sided die.

```r
sample(6, 1)
```

```
## [1] 3
```

Simulate 10 rolls of a 6-sided die. Set `replace` to `TRUE` so each roll is 
independent. See what happens if you set `replace` to `FALSE`.

```r
sample(6, 10, replace = TRUE)
```

```
##  [1] 6 1 5 6 4 1 6 3 1 6
```

You can also use sample to sample from a list of named outcomes.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
sample(pet_types, 10, replace = TRUE)
```

```
##  [1] "fish"   "ferret" "fish"   "bird"   "bird"   "ferret" "ferret"
##  [8] "bird"   "fish"   "cat"
```

Ferrets are a much less common pet than cats and dogs, so our sample isn't very 
realistic. You can set the probabilities of each item in the list with the `prob` 
argument.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
pet_prob <- c(0.3, 0.4, 0.1, 0.1, 0.1)
sample(pet_types, 10, replace = TRUE, prob = pet_prob)
```

```
##  [1] "cat"  "dog"  "cat"  "dog"  "bird" "dog"  "dog"  "dog"  "dog"  "dog"
```

### Binomial Distribution

The binomial distribution is useful for modeling binary data, where each 
observation can have one of two outcomes, like success/failure, yes/no or 
head/tails. 

#### Sample distribution

`rbinom(n, size, prob)`

The `rbinom` function will generate a random binomial distribution.

* `n` = number of observations
* `size` = number of trials
* `prob` = probability of success on each trial

Coin flips are a typical example of a binomial distribution, where we can assign 
head to 1 and tails to 0.

20 individual coin flips of a fair coin

```r
rbinom(20, 1, 0.5)
```

```
##  [1] 0 1 0 1 0 1 0 1 0 1 0 0 1 1 1 1 0 0 1 0
```

20 individual coin flips of a baised (0.75) coin

```r
rbinom(20, 1, 0.75)
```

```
##  [1] 1 1 1 1 1 0 0 1 1 1 0 1 1 1 0 0 1 1 1 1
```

You can generate the total number of heads in 1 set of 20 coin flips by setting 
`size` to 20 and `n` to 1.

```r
rbinom(1, 20, 0.75)
```

```
## [1] 14
```

You can generate more sets of 20 coin flips by increasing the `n`.

```r
rbinom(10, 20, 0.5)
```

```
##  [1] 12 17 11 10 13 10 11 10  6  8
```

You should always check your randomly generated data to check that it makes sense. 
For large samples, it's easiest to do that graphically. A histogram is usually 
the best choice for plotting binomial data.


```r
flips <- rbinom(1000, 20, 0.5)

ggplot() +
  geom_histogram(
    aes(flips), 
    binwidth = 1, 
    fill = "white", 
    color = "black"
  )
```

<img src="08-sim_files/figure-html/sim_flips-1.png" width="672" />

<p class="alert alert-info">Run the simulation above several times, noting how 
the histogram changes. Try changing the values of `n`, `size`, and `prob`.</p>

#### Exact binomial test

`binom.test(x, n, p)`

You can test a binomial distribution against a specific probability using the 
exact binomial test.

* `x` = the number of successes
* `n` = the number of trials
* `p` = hypothesised probability of success

Here we can test a series of 10 coin flips from a fair coin and a biased coin 
against the hypothesised probability of 0.5 (even odds).


```r
n <- 10
fair_coin <- rbinom(1, n, 0.5)
biased_coin <- rbinom(1, n, 0.6)

binom.test(fair_coin, n, p = 0.5)
```

```
## 
## 	Exact binomial test
## 
## data:  fair_coin and n
## number of successes = 6, number of trials = 10, p-value = 0.7539
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.2623781 0.8784477
## sample estimates:
## probability of success 
##                    0.6
```

```r
binom.test(biased_coin, n, p = 0.5)
```

```
## 
## 	Exact binomial test
## 
## data:  biased_coin and n
## number of successes = 7, number of trials = 10, p-value = 0.3438
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.3475471 0.9332605
## sample estimates:
## probability of success 
##                    0.7
```

<div class="alert alert-info">
Run the code above several times, noting the p-values for the fair and biased coins. 
Alternatively, you can [simulate coin flips](https://debruine.shinyapps.io/coinsim/) 
online and build up a graph of results and p-values. 

* How does the p-value vary for the fair and biased coins?
* What happens to the confidence intervals if you increase n from 10 to 100?
* What criterion would you use to tell if the observed data indicate the coin is fair or biased?
* How often do you conclude the fair coin is biased (false positives)? 
* How often do you conclude the biased coin is fair (false negatives)?
</div>

#### False positives & negatives

The probability that a test concludes the fair coin is biased is called the 
*false positive rate* (or _Type I Error Rate_). The *alpha* is the false positive 
rate we accept for a test. This is traditionally set at 0.05, but there are good 
arguments for setting a different criterion in some circumstances.

The probability that a test concludes the biased coin is fair is called the 
*false negative rate* (of _Type II Error Rate_). The *power* of a test is 1 
minus its false negative rate (i.e., the *true positive rate*). Power depends 
on how biased the coin is and how many samples we take. 

#### Sampling function

To estimate these rates, we need to repeat the sampling above many times. 
A function is ideal for repeating the exact same procedure over and over. Set 
the arguments of the function to variables that you might want to change. Here, 
we will want to estimate power for:

* different sample sizes (`n`)
* different coin biases (`bias`)
* different hypothesised probabilities (`p`, defaults to 0.5)


```r
sim_binom_test <- function(n, bias, p = 0.5) {
  coin <- rbinom(1, n, bias)
  btest <- binom.test(coin, n, p)
  
  btest$p.value
}
```

Once you've created your function, test it a few times, changing the values.


```r
sim_binom_test(100, 0.6)
```

```
## [1] 0.1933479
```

#### Calculate power

Then you can use the `replicate()` function to run it many times and save all 
the output values. You can calculate the *power* of your analysis by checking the 
proportion of your simulated analyses that have a p-value less than your _alpha_ 
(the probability of rejecting the null hypothesis when the null hypothesis is true).


```r
my_reps <- replicate(1e4, sim_binom_test(100, 0.6))

mean(my_reps < 0.05)
```

```
## [1] 0.4628
```

<p class="alert alert-info">`1e4` is just scientific notation for a 1 followed 
by 4 zeros (`10000`). When youre running simulations, you usually want to run a 
lot of them and it's a pain to keep track of whether you've typed 5 or 6 zeros 
(100000 vs 1000000) and this will change your running time by an order of 
magnitude.</p>

### Normal Distribution

#### Sample distribution

`rnorm(n, mean, sd)`

We can simulate a normal distribution of size `n` if we know the `mean` and 
standard deviation (`sd`). A density plot is usually the best way to visualise 
this type of data if your `n` is large.


```r
dv <- rnorm(1e5, 10, 2)

ggplot() +
  geom_density(aes(dv), fill = "white") +
  geom_vline(xintercept = mean(dv), color = "red") +
  geom_vline(xintercept = quantile(dv, .5 - (.6827/2)), color = "darkgreen") +
  geom_vline(xintercept = quantile(dv, .5 + (.6827/2)), color = "darkgreen") +
  geom_vline(xintercept = quantile(dv, .5 - (.9545/2)), color = "blue") +
  geom_vline(xintercept = quantile(dv, .5 + (.9545/2)), color = "blue") +
  geom_vline(xintercept = quantile(dv, .5 - (.9973/2)), color = "purple") +
  geom_vline(xintercept = quantile(dv, .5 + (.9973/2)), color = "purple") +
  scale_x_continuous(
    limits = c(0,20), 
    breaks = seq(0,20)
  )
```

<img src="08-sim_files/figure-html/rnorm-1.png" width="672" />

<p class="alert alert-info">Run the simulation above several times, noting how 
the density plot changes. What do the vertical lines represent? Try changing the 
values of `n`, `mean`, and `sd`.</p>

#### T-test

`t.test(x, y, alternative, mu, paired)`

Use a t-test to compare the mean of one distribution to a null hypothesis 
(one-sample t-test), compare the means of two samples (independent-samples t-test), 
or compare pairs of values (paired-samples t-test).

You can run a one-sample t-test comparing the mean of your data to `mu`. Here is 
a simulated distribution with a mean of 0.5 and an SD of 1, creating an effect 
size of 0.5 SD when tested against a `mu` of 0. Run the simulation a few times to 
see how often the t-test returns a significant p-value (or run it in the [shiny app](http://shiny.psy.gla.ac.uk/debruine/normsim/)).


```r
sim_norm <- rnorm(100, 0.5, 1)
t.test(sim_norm, mu = 0)
```

```
## 
## 	One Sample t-test
## 
## data:  sim_norm
## t = 4.6516, df = 99, p-value = 1.021e-05
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  0.2835165 0.7053189
## sample estimates:
## mean of x 
## 0.4944177
```

Run an independent-samples t-test by comparing two lists of values.


```r
a <- rnorm(100, 0.5, 1)
b <- rnorm(100, 0.7, 1)
t_ind <- t.test(a, b, paired = FALSE)
t_ind
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  a and b
## t = -0.026993, df = 197.98, p-value = 0.9785
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.2991671  0.2910878
## sample estimates:
## mean of x mean of y 
## 0.7097529 0.7137925
```

<p class="alert alert-warning">The `paired` argument defaults to `FALSE`, but 
it's good practice to always explicitly set it so you are never confused about 
what type of test you are performing.</p>

#### Sampling function

We can use the `names()` function to find out the names of all the t.test parameters 
and use this to just get one type of data, like the test statistic (e.g., t-value).

```r
names(t_ind)
```

```
## [1] "statistic"   "parameter"   "p.value"     "conf.int"    "estimate"   
## [6] "null.value"  "alternative" "method"      "data.name"
```

```r
t_ind$statistic
```

```
##           t 
## -0.02699261
```

Alternatively, use `broom::tidy()` to convert the output into a tidy table.


```r
broom::tidy(t_ind)
```

```
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic p.value parameter conf.low
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>
## 1 -0.00404     0.710     0.714   -0.0270   0.978      198.   -0.299
## # ... with 3 more variables: conf.high <dbl>, method <chr>,
## #   alternative <chr>
```


If you want to run the simulation many times and record information each time, 
first you need to turn your simulation into a function.


```r
sim_t_ind <- function(n, m1, sd1, m2, sd2) {
  v1 <- rnorm(n, m1, sd1)
  v2 <- rnorm(n, m2, sd2)
  t_ind <- t.test(v1, v2, paired = FALSE)
  
  return(t_ind$p.value)
}
```

Run it a few times to check that it gives you sensible values.


```r
sim_t_ind(100, 0.7, 1, 0.5, 1)
```

```
## [1] 0.8309888
```

Now replicate the simulation 1000 times.


```r
my_reps <- replicate(1e4, sim_t_ind(100, 0.7, 1, 0.5, 1))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.2924
```

<p class="alert alert-info">Run the code above several times. How much does the 
power value fluctuate? How many replications do you need to run to get a reliable 
estimate of power?</p>

Compare your power estimate from simluation to a power calculation using `power.t.test()`. 
Here, `delta` is the difference between `m1` and `m2` above.


```r
power.t.test(n = 100, delta = 0.2, sd = 1, sig.level = alpha, type = "two.sample")
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


You can plot the distribution of p-values.


```r
ggplot() + 
  geom_histogram(
    aes(my_reps), 
    binwidth = 0.05, 
    boundary = 0,
    fill = "white", 
    color = "black"
  )
```

<img src="08-sim_files/figure-html/plot-reps-1.png" width="672" />

<p class="alert alert-info">What do you think the distribution of p-values is 
when there is no effect (i.e., the means are identical)? Check this yourself.</p>

<p class="alert alert-warning">Make sure the `boundary` argument is set to `0` 
for p-value histograms. See what happens with a null effect if `boundary` is not set.</p>

#### Bivariate Normal

##### Correlation 

You can test if two continuous variables are related to each other using the `cor()` function.

Below is a quick and dirty way to generate two correlated variables. `x` is drawn 
from a normal distribution, while `y` is the sum of `x` and another value drawn 
from a random normal distribution. We'll learn later how to generate specific 
correlations in simulated data.


```r
n <- 100 # number of random samples

x <- rnorm(n, 0, 1)
y <- x + rnorm(n, 0, 1)

cor(x, y)
```

```
## [1] 0.7542513
```

`cor()` defaults to Pearson's correlations. Set the `method` argument to use 
Kendall or Spearman correlations.


```r
cor(x, y, method = "spearman")
```

```
## [1] 0.7541674
```

##### Sample distribution
<a name="bvn"></a>

What if we want to sample from a population with specific relationships between 
variables? We can sample from a _bivariate normal distribution_ using the `MASS` package,


```r
n <- 1000 # number of random samples
rho <- 0.5 # population correlation between the two variables

mu <- c(10, 20) # the means of the samples
stdevs <- c(5, 6) # the SDs of the samples

# correlation matrix
cor_mat <- matrix(c(  1, rho, 
                    rho,   1), 2) 

# create the covariance matrix
sigma <- (stdevs %*% t(stdevs)) * cor_mat

# sample from bivariate normal distribution
bvn <- mvrnorm(n, mu, sigma) 

cor(bvn) # check correlation matrix
```

```
##           [,1]      [,2]
## [1,] 1.0000000 0.5311651
## [2,] 0.5311651 1.0000000
```

Plot your sampled variables to check everything worked like you expect. You need 
to convert the output of `mvnorm` into a tibble in order to use it in ggplot.


```r
bvn %>%
  as_tibble() %>%
  ggplot(aes(V1, V2)) +
    geom_point(alpha = 0.5) + 
    geom_smooth(method = "lm") +
    geom_density2d()
```

<img src="08-sim_files/figure-html/graph-bvn-1.png" width="672" />

### Multivariate Normal

##### Sample distribution


```r
n <- 200 # number of random samples
rho1_2 <- 0.5 # correlation betwen v1 and v2
rho1_3 <- 0 # correlation betwen v1 and v3
rho2_3 <- 0.7 # correlation betwen v2 and v3

mu <- c(10, 20, 30) # the means of the samples
stdevs <- c(8, 9, 10) # the SDs of the samples

# correlation matrix
cor_mat <- matrix(c(     1, rho1_2, rho1_3, 
                    rho1_2,      1, rho2_3,
                    rho1_3, rho2_3,      1), 3) 

sigma <- (stdevs %*% t(stdevs)) * cor_mat
bvn3 <- mvrnorm(n, mu, sigma)

cor(bvn3) # check correlation matrix
```

```
##           [,1]      [,2]      [,3]
## [1,] 1.0000000 0.4184293 0.0168486
## [2,] 0.4184293 1.0000000 0.7413358
## [3,] 0.0168486 0.7413358 1.0000000
```

##### 3D Plots

You can use the `plotly` library to make a 3D graph.


```r
library(plotly)
```

```
## 
## Attaching package: 'plotly'
```

```
## The following object is masked from 'package:MASS':
## 
##     select
```

```
## The following object is masked from 'package:ggplot2':
## 
##     last_plot
```

```
## The following object is masked from 'package:stats':
## 
##     filter
```

```
## The following object is masked from 'package:graphics':
## 
##     layout
```

```r
marker_style = list(
    color = "#ff0000", 
    line = list(
      color = "#444", 
      width = 1
    ), 
    opacity = 0.5,
    size = 5
  )

bvn3 %>%
  as_tibble() %>%
  plot_ly(x = ~V1, y = ~V2, z = ~V3, marker = marker_style) %>%
  add_markers()
```

<!--html_preserve--><div id="htmlwidget-f547d52d06ec9416b6a8" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-f547d52d06ec9416b6a8">{"x":{"visdat":{"e0be580c41ba":["function () ","plotlyVisDat"]},"cur_data":"e0be580c41ba","attrs":{"e0be580c41ba":{"x":{},"y":{},"z":{},"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d","mode":"markers","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"V1"},"yaxis":{"title":"V2"},"zaxis":{"title":"V3"}},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"cloud":false},"data":[{"x":[5.00076211603537,7.20064076166339,6.47362167274357,4.99048743791299,24.7316219748225,3.15883589031348,-2.77993950343192,-0.786118935516946,14.3345276723665,12.1326172832469,13.7977950318387,17.8614272741298,19.1491433707039,22.3547620361537,3.86680459739623,24.6380309088524,-6.13744651571298,12.0955374797854,0.738634172497669,25.5808712099266,18.851142359092,9.02436327563387,23.0966975642454,7.03210449540801,14.2510279218501,21.0787395901134,-2.58076692004827,-3.53402974920319,7.82742190613815,15.5758536946358,13.9581212598011,16.2562868539494,-7.93974270126226,12.5283164436027,11.6009530648422,7.52924373044172,14.1951316506543,-3.68367511320349,6.12239446802594,10.7763526344687,5.0530982462755,12.2473511587444,25.0965558542914,11.0924018820233,11.9879195650755,3.66093892325723,1.58571131689677,14.1453351967886,13.1098805557062,7.09598864149387,2.96858617079733,16.3996346284947,4.29300628172021,12.8364024092245,5.53481110647371,10.8647528369752,13.4690421843728,-1.98434345381542,10.7413871537736,12.437085064515,4.6358204903519,3.72826261094187,0.986016910513893,5.09740719883887,14.003780381299,20.9409730626406,24.2897314282817,8.3111139098494,-3.17538622714588,20.4941390896886,17.2182023747083,2.52612024972474,7.3329167400201,6.97688795913247,1.21781433651798,-0.6766399301207,14.9079568495018,7.38206806888076,12.5613695339354,13.5758982794891,4.37659899132879,-8.23917975064787,13.1700974721053,17.1467747066029,15.626174387972,16.3734331092483,12.0540092906017,26.3115229222188,5.24507640415901,11.3076094953739,24.5491495608357,13.1134325848207,21.9727055027801,-0.057769412826369,-0.600537862347888,2.91584059027155,-5.32720819150939,23.7064965631815,5.67781222694912,3.53185722474407,12.5230169060898,4.9709268117433,7.87665367861479,8.50546076758392,8.56417068597692,18.9575238015099,15.2435092921275,18.0452020806081,18.4810888939815,20.7854619375519,11.1008362509945,8.11120541783291,6.8554321230525,26.0914346823448,-2.12983650358383,8.19097787946071,3.1912011712079,15.5827798870727,13.4047177767898,4.95444702438415,9.35722585587269,15.8595997607139,-2.47307087742426,6.25409833339526,16.3668706647265,14.6297195278561,17.3392398668391,3.97593090854122,24.9336329024428,17.3968173446452,12.2494963710463,4.33973145115899,-1.29197056192964,9.91857325896796,12.1627161618377,12.6784412603864,18.6655703662205,16.8705733964458,11.104598853106,15.5246451628474,8.51304041790304,17.5929241163865,15.4718449966184,9.65360257368717,3.61958563999646,19.440998366518,18.1824417780725,6.43801473295843,-1.99076861664901,16.1725739519904,9.73691286867712,14.5905759603068,6.09004133301524,5.020039385588,3.93621111483275,18.716244952074,23.7093674163652,-4.67935722270787,18.0592201207559,-3.9968760599583,13.0612215372685,19.0089174762907,8.26722145062695,4.68945024252863,16.4427649763447,14.1697679237991,13.2452938754899,23.1310208591622,10.4737353090053,19.0778619317117,0.601390571468047,28.4394479481964,8.16810542768638,7.13033834387736,18.5866793640984,1.61796685984737,10.3310220708182,15.8171280262403,18.6045767963861,-3.95637355887041,-15.172734697299,11.3520023764737,2.10217294738925,11.2804685108907,6.89933049859398,10.8221869754759,10.3471295837892,18.0184691168672,19.2530394868936,16.092280368674,8.51476193147081,5.09718578512487,6.46535198230878,11.4013365031648,7.84179234889369,24.7325903285764,25.1320081586792,21.4734282032462,0.00513416666267119,13.9680462448312],"y":[15.4131444545794,18.0502134310569,7.07278834166049,20.2438066230035,31.5877248132485,21.8905525247018,8.29951272007666,12.4155994683679,22.4925950894989,20.7377876432595,26.5842446400175,30.086894902797,24.3219075807377,19.0572552242091,7.3634402493257,29.2366779136182,4.09152444537481,23.8818393226023,16.8797522426997,17.4242010311191,22.6886949230424,29.8562039111329,31.4029489242808,28.4338955246465,5.16515179256894,35.0190549681233,14.5508751995054,9.68065504521645,28.1512222061975,25.8185926042788,15.3644616634482,12.0470897278009,18.2821886923673,33.3921637387797,28.3723286652303,28.3368788169025,17.7510065645926,21.7337995018629,22.6481688188531,14.9593406479355,29.985218314255,6.20911225514752,38.9287312971241,31.6462968876851,28.0175169690213,25.6921920691019,9.9784258984705,13.2371352558412,19.8819624234814,10.8218738358807,20.5400990828453,35.4063410049098,14.7630870465748,12.3531750463229,11.4204489775683,25.7688014758573,25.2848095466791,19.8466414791031,27.2446578211225,15.6658179485107,31.2145615214164,26.0309357206095,18.3531335555989,5.53173881491786,26.7099642587123,32.1297961255859,50.5877708247391,22.3331874118332,24.6445358171915,16.9837090443197,29.9901760372896,24.035722550205,6.48016619132499,17.7408421807563,16.6903391732535,20.991259800291,24.4628219468557,0.949577882069427,7.42710155245084,13.1425911541043,18.849370269093,19.7217217020261,11.6686036721854,32.5879478351211,32.8135219006999,26.4579608529975,23.9314196617008,30.3320948884173,17.1029432488587,15.0159279538,34.574544406286,37.6013263140581,20.587140679858,23.2275976006843,9.54676191483948,14.2185970608549,33.464596558887,32.7165667050628,12.5597521458136,25.555519437727,18.8622669934913,4.42190556952258,19.1954755683028,22.792905881795,14.6253730798447,37.4973789607283,8.64817548417546,26.3274218684032,14.7147712011475,27.6633056654755,26.7284188465829,20.0556656161739,4.27805082254167,30.3891735459593,9.52815781428468,10.2697814867675,15.8791200248908,32.2328941313816,14.0322046778867,31.7168253460469,24.5555687992296,22.0091412557377,5.24768997868045,33.6552251672577,21.8228466332547,18.2251670545341,29.6016511362992,16.5333688367736,24.9523045709651,21.3881483820436,14.8682600944231,21.3240766922498,21.1613912191595,28.4650066514913,8.74758191968992,27.3018488705255,23.8870572527935,30.512420042728,25.7294238903111,15.143543044844,11.6183133478949,26.8804363709917,18.0119692664883,14.9777147560336,22.3503308394063,20.4730140286131,15.4797785346443,21.8823068197293,14.1157187685239,16.5579984287402,8.79733472156036,34.3630721783964,23.8886365467068,27.16503949665,9.98487327359175,4.96196323530172,19.753755076973,14.7411332269436,27.1366370853054,23.3671395956876,19.6460493829354,22.7108801540489,28.1586255563915,11.2179694305095,37.404826688439,3.29919856917017,18.5379688220735,21.7695141265046,32.2944036822616,25.5869224316634,1.39592698388046,43.6082794540437,25.4999534403967,9.81441725147783,22.4304495885342,19.4460930428526,17.7627125566865,32.5203946964441,33.9260566635548,11.4816008805645,14.9846057650071,11.4667705527918,23.8251715237754,6.50100528087349,10.3519133346742,20.9172344578867,17.1109288309188,12.1230173727175,29.9651067803766,29.5636965939394,22.6428030215867,15.5808218043705,16.3573684354163,27.1414489651095,22.9270349910428,20.5427002161559,25.1960886151137,33.9406061063619,10.4635987509677,27.0900438490319],"z":[42.1264816870491,31.1652698466431,15.0306953798882,33.9876411612134,46.127301523343,36.9383289254886,31.594713450297,24.0916600367778,36.5451647759862,29.4049867706396,33.7119920176264,39.6304086489867,29.6577819692853,22.9729051970772,24.417965154479,30.4561003554758,16.4059017428798,33.4782560373449,32.5636877970933,11.7669534543509,33.659547921214,33.7555697473094,39.5851826737598,34.5764782051835,-0.111116286292695,35.323959992121,26.9337121982729,17.1702697758639,33.4756596926731,20.3514210814273,19.011613230706,19.9248562047201,30.8282138092129,35.5935883702075,30.2701928359634,48.2217848421396,19.0695488670961,44.017373022498,39.5449697486977,25.3639022201906,31.2676642031706,21.2389242937925,27.9915402582974,55.8921057020379,41.5568954517885,37.5695299463488,24.0611940978141,27.2576099465567,25.0299631311863,20.9854424775204,36.128465625899,45.3468051268308,23.6321504636683,25.5150929490991,15.957782136054,39.641013475289,23.0758331440104,34.2168292682745,41.9621300013124,14.7994275862343,44.1636466592456,38.5160720757049,28.0480693420541,19.4786565482138,38.5334013681225,45.76158084197,58.5887160239249,26.103783458289,27.6447427613628,9.30675426705285,37.3714094617342,28.8551764128113,14.0496885777514,36.5977821375902,27.0674036370511,41.1546365475647,35.1827208933675,13.3434560693062,13.637031626336,23.7802750804773,24.5410619867819,41.2945612514465,17.7562686700989,42.4610116782346,48.8753389817246,42.251318012325,32.135047098243,35.1363217978603,20.7504220413889,35.2232092610589,26.8296305700894,42.7814073016454,22.1091865262318,41.5656767183139,26.9960059733028,26.607758685866,51.9117345623164,32.6831590385993,25.0035309298205,35.1752622718473,23.7748197339336,19.9826943882287,27.4011775576111,39.4151016663837,21.4153389610542,42.7799949919324,13.5208469923866,43.1702324845549,29.3851192157973,23.0457412833941,35.0115712931588,41.1011452181076,17.3523639788602,36.7132552238023,24.4302962722696,11.2939061575891,30.6732234270883,43.56924624777,24.4874412476533,52.3151085901067,49.8155288884023,23.2494512267696,19.1771152842386,45.7062532183351,34.2279831825332,37.2762070699609,29.9187066945188,28.5337368778139,22.2953051889021,26.4330080036048,25.8260819394722,36.8955689241427,47.2073016119156,48.3862054937957,14.8589812350203,34.0982647768105,19.7331805765612,29.8348505399773,39.4134480158548,27.3945627034121,23.9067724866787,27.2313519442676,24.5689766517263,23.2694748629166,33.628402440954,31.8491904092718,13.4909620896902,25.5514291238316,25.705259935595,22.7757659041978,14.9412652130399,39.7511600650523,38.1264086802467,38.560373764104,17.5711808787522,5.15151985815405,35.0219854797983,30.7110611330189,37.3934381990372,41.4250335949852,31.9062775138791,25.9924950360609,35.3686095015579,25.3670305929344,45.1928318226798,7.581990005095,25.8149076553077,26.9175770197875,52.9798597677683,34.7649506484599,8.40909114797994,47.9089418345242,29.8036165979172,11.1064557596691,33.1853997642527,24.6415810650472,35.2490740876196,44.4906641847249,38.6807352577221,29.6451596994467,36.5873121138872,6.2600938723507,30.9607171096693,26.2359693422248,34.4916923522622,12.584782361585,18.5868494838053,16.104369939705,35.5639260788764,41.7930869105443,33.4603628935481,31.0621617190986,21.8295629488846,41.8993572584011,22.5305225019592,29.6624176550592,24.9218448720583,33.117911062561,19.0406575320997,28.5216409981021],"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"type":"scatter3d","mode":"markers","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script><!--/html_preserve-->

## Example

This example uses the [Growth Chart Data Tables](https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv) 
from the [US CDC](https://www.cdc.gov/growthcharts/zscore.htm). 

### Load & wrangle

We have to do a little data wrangling first. Have a look at the data after you 
import it and relabel `Sex` to `male` and `female` instead of `1` and `2`. Also 
convert `Agemos` (age in months) to years. Relabel the column `0` as `mean` and 
calculate a new column named `sd` as the difference between columns `1` and `0`. 


```r
height_age <- read_csv("https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv") %>%
  filter(Sex %in% c(1,2)) %>%
  mutate(
    sex = recode(Sex, "1" = "male", "2" = "female"),
    age = as.numeric(Agemos)/12,
    sd = `1` - `0`
  ) %>%
  dplyr::select(sex, age, mean = `0`, sd)
```

```
## Parsed with column specification:
## cols(
##   Sex = col_character(),
##   Agemos = col_character(),
##   `-2` = col_double(),
##   `-1.5` = col_double(),
##   `-1` = col_double(),
##   `-0.5` = col_double(),
##   `0` = col_double(),
##   `0.5` = col_double(),
##   `1` = col_double(),
##   `1.5` = col_double(),
##   `2` = col_double()
## )
```

<p class="alert alert-warning">If you run the code above without putting `dplyr::` 
before the `select()` function, you will get an error message. This is because 
the `MASS` package also has a function called `select()` and, since we loaded 
`MASS` after `tidyverse`, the `MASS` function is the default. When you loaded 
`MASS`, you should have seen a warning like "The following object is masked from 
‘package:dplyr’: select". You can use functions with the same name from different 
packages by specifying the package before the function name, separated by two colons.</p>

### Plot

Plot your new data frame to see how mean height changes with age for boys and girls.


```r
ggplot(height_age, aes(age, mean, color = sex)) +
  geom_smooth(aes(ymin = mean - sd, ymax = mean + sd), stat="identity")
```

<img src="08-sim_files/figure-html/plot-height-means-1.png" width="672" />

### Get means and SDs

Create new variables for the means and SDs for 20-year-old men and women.


```r
height_sub <- height_age %>% filter(age == 20)

m_mean <- height_sub %>% filter(sex == "male") %>% pull(mean)
m_sd   <- height_sub %>% filter(sex == "male") %>% pull(sd)
f_mean <- height_sub %>% filter(sex == "female") %>% pull(mean)
f_sd   <- height_sub %>% filter(sex == "female") %>% pull(sd)

height_sub
```

```
## # A tibble: 2 x 4
##   sex      age  mean    sd
##   <chr>  <dbl> <dbl> <dbl>
## 1 male      20  177.  7.12
## 2 female    20  163.  6.46
```

### Simulate a population

Simulate 50 random male heights and 50 radom female heights using the `rnorm()` 
function and the means and SDs above. Plot the data.


```r
sim_height <- tibble(
  male = rnorm(50, m_mean, m_sd),
  female = rnorm(50, f_mean, f_sd)
) %>%
  gather("sex", "height", male:female)

ggplot(sim_height) +
  geom_density(aes(height, fill = sex), alpha = 0.5) +
  xlim(125, 225)
```

<img src="08-sim_files/figure-html/sim-height-20-1.png" width="672" />

<p class="alert alert-info">Run the simulation above several times, noting how 
the density plot changes. Try changing the age you're simulating.</p>

### Analyse simulated data

Use the `sim_t_ind(n, m1, sd1, m2, sd2)` function we created above to generate 
one simulation with a sample size of 50 in each group using the means and SDs 
of male and female 14-year-olds.


```r
height_sub <- height_age %>% filter(age == 14)
m_mean <- height_sub %>% filter(sex == "male") %>% pull(mean)
m_sd   <- height_sub %>% filter(sex == "male") %>% pull(sd)
f_mean <- height_sub %>% filter(sex == "female") %>% pull(mean)
f_sd   <- height_sub %>% filter(sex == "female") %>% pull(sd)

sim_t_ind(50, m_mean, m_sd, f_mean, f_sd)
```

```
## [1] 0.00789244
```

### Replicate simulation

Now replicate this 1e4 times using the `replicate()` function. This function 
will save the returned p-values in a list (`my_reps`). We can then check what 
proportion of those p-values are less than our alpha value. This is the power of 
our test.


```r
my_reps <- replicate(1e4, sim_t_ind(50, m_mean, m_sd, f_mean, f_sd))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.6507
```

### One-tailed prediction

This design has about 65% power to detect the sex difference in height (with a 
2-tailed test). Modify the `sim_t_ind` function for a 1-tailed prediction.

You could just set `alternative` equal to "greater" in the function, but it might be 
better to add the `alternative` argument to your function (giving it the same default 
value as `t.test`) and change the value of `alternative` in the function to `alternative`.


```r
sim_t_ind <- function(n, m1, sd1, m2, sd2, alternative = "two.sided") {
  v1 <- rnorm(n, m1, sd1)
  v2 <- rnorm(n, m2, sd2)
  t_ind <- t.test(v1, v2, paired = FALSE, alternative = alternative)
  
  return(t_ind$p.value)
}

my_reps <- replicate(1e4, sim_t_ind(50, m_mean, m_sd, f_mean, f_sd, "greater"))
mean(my_reps < alpha)
```

```
## [1] 0.7606
```

### Range of sample sizes

What if we want to find out what sample size will give us 80% power? We can try 
trial and error. We know the number should be slightly larger than 50. But you 
can search more systematically by repeating your power calculation for a range 
of sample sizes. 

<p class="alert alert-info">This might seem like overkill for a t-test, where 
you can easily look up sample size calculators online, but it is a valuable 
skill to learn for when your analyses become more complicated.</p>

Start with a relatively low number of replications and/or more spread-out samples 
to estimate where you should be looking more specifically. Then you can repeat 
with a narrower/denser range of sample sizes and more iterations.


```r
alpha <- 0.05
power_table <- tibble(
  n = seq(20, 100, by = 5)
) %>%
  mutate(power = map_dbl(n, function(n) {
    ps <- replicate(1e3, sim_t_ind(n, m_mean, m_sd, f_mean, f_sd, "greater"))
    mean(ps < alpha)
  }))

ggplot(power_table, aes(n, power)) +
  geom_smooth() +
  geom_point() +
  geom_hline(yintercept = 0.8)
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

<img src="08-sim_files/figure-html/range-sample-sizes-1.png" width="672" />

Now we can narrow down our search to values around 55 (plus or minus 5) and 
increase the number of replications from 1e3 to 1e4.


```r
power_table <- tibble(
  n = seq(50, 60)
) %>%
  mutate(power = map_dbl(n, function(n) {
    ps <- replicate(1e3, sim_t_ind(n, m_mean, m_sd, f_mean, f_sd, "greater"))
    mean(ps < alpha)
  }))

##ggplot(power_table, aes(n, power)) +
##  geom_smooth() +
##  geom_point() +
##  geom_hline(yintercept = 0.8) +
##  scale_x_continuous(breaks = sample_size)
```

