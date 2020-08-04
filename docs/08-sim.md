
# Probability & Simulation {#sim}

<img src="images/memes/sim.jpg" class="meme right">

## Learning Objectives

### Basic

1. Understand what types of data are best modeled by different distributions
    + [uniform](#uniform)
    + [binomial](#binomial)
    + [normal](#normal)
    + [poisson](#poisson)
2. Generate and plot data randomly sampled from the above distributions
3. Test sampled distributions against a null hypothesis
    + [exact binomial test](#exact-binom)
    + [t-test](#t-test) (1-sample, independent samples, paired samples)
    + [correlation](#correlation) (pearson, kendall and spearman)
4. Define the following [statistical terms](#stat-terms):
    + [p-value](#p-value)
    + [alpha](#alpha)
    + [power](#power)
    + smallest effect size of interest ([SESOI](#sesoi))
    + [false positive](#false-pos) (type I error)
    + [false negative](#false-neg) (type II error)
    + confidence interval ([CI](#conf-inf))
5. [Calculate power](#calc-power) using iteration and a sampling function

### Intermediate

6. Generate 3+ variables from a [multivariate normal](#mvnorm) distribution and plot them

### Advanced

7. Calculate the minimum sample size for a specific power level and design


## Resources

* [Stub for this lesson](stubs/8_sim.Rmd)
* [Distribution Shiny App](http://shiny.psy.gla.ac.uk/debruine/simulate/)
* [Simulation tutorials](https://debruine.github.io/tutorials/sim-data.html)
* [Chapter 21: Iteration](http://r4ds.had.co.nz/iteration.html)  of *R for Data Science*
* [Improving your statistical inferences](https://www.coursera.org/learn/statistical-inferences/) on Coursera (week 1)
* [Faux](https://debruine.github.io/faux/) package for data simulation
* [Simulation-Based Power-Analysis for Factorial ANOVA Designs](https://psyarxiv.com/baxsf) [@lakens_caldwell_2019]
* [Understanding mixed effects models through data simulation](https://psyarxiv.com/xp5cy/) [@debruine_barr_2019]


## Distributions

Simulating data is a very powerful way to test your understanding of statistical concepts. We are going to use simulations to learn the basics of probability.


```r
# libraries needed for these examples
library(tidyverse)
library(MASS)
set.seed(8675309) # makes sure random numbers are reproducible
```

### Uniform Distribution {#uniform}

The uniform distribution is the simplest distribution. All numbers in the range have an equal probability of being sampled.

<div class="try">
<p>Take a minute to think of things in your own research that are uniformly distributed.</p>
</div>

#### Sample continuous distribution

`runif(n, min=0, max=1)` 

Use `runif()` to sample from a continuous uniform distribution.


```r
u <- runif(100000, min = 0, max = 1)

# plot to visualise
ggplot() + 
  geom_histogram(aes(u), binwidth = 0.05, boundary = 0,
                 fill = "white", colour = "black")
```

<img src="08-sim_files/figure-html/runif-1.png" width="100%" style="display: block; margin: auto;" />

#### Sample discrete distribution

`sample(x, size, replace = FALSE, prob = NULL)`

Use `sample()` to sample from a discrete distribution.

You can use `sample()` to simulate events like rolling dice or choosing from a deck of cards. The code below simulates rolling a 6-sided die 10000 times. We set `replace` to `TRUE` so that each event is independent. See what happens if you set `replace` to `FALSE`.


```r
rolls <- sample(1:6, 10000, replace = TRUE)

# plot the results
ggplot() + 
  geom_histogram(aes(rolls), binwidth = 1, 
                 fill = "white", color = "black")
```

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/sample-replace-1.png" alt="Distribution of dice rolls." width="100%" />
<p class="caption">(\#fig:sample-replace)Distribution of dice rolls.</p>
</div>

You can also use sample to sample from a list of named outcomes.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
sample(pet_types, 10, replace = TRUE)
```

```
##  [1] "ferret" "bird"   "cat"    "dog"    "ferret" "cat"    "ferret" "ferret"
##  [9] "ferret" "fish"
```

Ferrets are a much less common pet than cats and dogs, so our sample isn't very realistic. You can set the probabilities of each item in the list with the `prob` argument.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
pet_prob <- c(0.3, 0.4, 0.1, 0.1, 0.1)
sample(pet_types, 10, replace = TRUE, prob = pet_prob)
```

```
##  [1] "ferret" "dog"    "ferret" "bird"   "dog"    "bird"   "cat"    "ferret"
##  [9] "dog"    "dog"
```


### Binomial Distribution {#binomial}

The binomial distribution is useful for modeling binary data, where each observation can have one of two outcomes, like success/failure, yes/no or head/tails. 

#### Sample distribution

`rbinom(n, size, prob)`

The `rbinom` function will generate a random binomial distribution.

* `n` = number of observations
* `size` = number of trials
* `prob` = probability of success on each trial

Coin flips are a typical example of a binomial distribution, where we can assign heads to 1 and tails to 0.


```r
# 20 individual coin flips of a fair coin
rbinom(20, 1, 0.5)
```

```
##  [1] 0 1 1 1 0 0 1 0 0 0 0 1 1 1 0 0 1 1 0 1
```



```r
# 20 individual coin flips of a baised (0.75) coin
rbinom(20, 1, 0.75)
```

```
##  [1] 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0 1 0 1 1
```

You can generate the total number of heads in 1 set of 20 coin flips by setting `size` to 20 and `n` to 1.


```r
rbinom(1, 20, 0.75)
```

```
## [1] 18
```

You can generate more sets of 20 coin flips by increasing the `n`.


```r
rbinom(10, 20, 0.5)
```

```
##  [1]  9  7 11  9  9  9 13 11 10 10
```

You should always check your randomly generated data to check that it makes sense. For large samples, it's easiest to do that graphically. A histogram is usually the best choice for plotting binomial data.


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

<img src="08-sim_files/figure-html/sim_flips-1.png" width="100%" style="display: block; margin: auto;" />

<div class="try">
<p>Run the simulation above several times, noting how the histogram changes. Try changing the values of <code>n</code>, <code>size</code>, and <code>prob</code>.</p>
</div>

#### Exact binomial test {#exact-binom}

`binom.test(x, n, p)`

You can test a binomial distribution against a specific probability using the exact binomial test.

* `x` = the number of successes
* `n` = the number of trials
* `p` = hypothesised probability of success

Here we can test a series of 10 coin flips from a fair coin and a biased coin against the hypothesised probability of 0.5 (even odds).


```r
n <- 10
fair_coin <- rbinom(1, n, 0.5)
biased_coin <- rbinom(1, n, 0.6)

binom.test(fair_coin, n, p = 0.5)
binom.test(biased_coin, n, p = 0.5)
```

```
## 
## 	Exact binomial test
## 
## data:  fair_coin and n
## number of successes = 5, number of trials = 10, p-value = 1
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.187086 0.812914
## sample estimates:
## probability of success 
##                    0.5 
## 
## 
## 	Exact binomial test
## 
## data:  biased_coin and n
## number of successes = 4, number of trials = 10, p-value = 0.7539
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.1215523 0.7376219
## sample estimates:
## probability of success 
##                    0.4
```

<div class="info">
<p>Run the code above several times, noting the p-values for the fair and biased coins. Alternatively, you can <a href="http://shiny.psy.gla.ac.uk/debruine/coinsim/">simulate coin flips</a> online and build up a graph of results and p-values.</p>
<ul>
<li>How does the p-value vary for the fair and biased coins?</li>
<li>What happens to the confidence intervals if you increase n from 10 to 100?</li>
<li>What criterion would you use to tell if the observed data indicate the coin is fair or biased?</li>
<li>How often do you conclude the fair coin is biased (false positives)?</li>
<li>How often do you conclude the biased coin is fair (false negatives)?</li>
</ul>
</div>

#### Statistical terms {#stat-terms}

The **effect** is some measure of your data. This will depend on the type of data you have and the type of statistical test you are using. For example, if you flipped a coin 100 times and it landed heads 66 times, the effect would be 66/100. You can then use the exact binomial test to compare this effect to the **null effect** you would expect from a fair coin (50/100) or to any other effect you choose. The **effect size** refers to the difference between the effect in your data and the null effect (usually a chance value).

<img src="images/memes/p-value.jpg" class="meme right">

{#p-value}
The **p-value** of a test is the probability of seeing an effect at least as extreme as what you have, if the real effect was the value you are testing against (e.g., a null effect). So if you used a binomial test to test against a chance probability of 1/6 (e.g., the probability of rolling 1 with a 6-sided die), then a p-value of 0.17 means that you could expect to see effects at least as extreme as your data 17% of the time just by chance alone. 

{#alpha}
If you are using null hypothesis significance testing (**NHST**), then you need to decide on a cutoff value (**alpha**) for making a decision to reject the null hypothesis. We call p-values below the alpha cutoff **significant**. In psychology, alpha is traditionally set at 0.05, but there are good arguments for [setting a different criterion in some circumstances](http://daniellakens.blogspot.com/2019/05/justifying-your-alpha-by-minimizing-or.html). 

{#false-pos}{#false-neg}
The probability that a test concludes there is an effect when there is really no effect (e.g., concludes a fair coin is biased) is called the **false positive rate** (or _Type I Error Rate_). The alpha is the false positive rate we accept for a test. The probability that a test concludes there is no effect when there really is one (e.g., concludes a biased coin is fair) is called the **false negative rate** (or _Type II Error Rate_). The **beta** is the false negative rate we accept for a test.

<div class="info">
<p>The false positive rate is not the overall probability of getting a false positive, but the probability of a false positive <em>under the null hypothesis</em>. Similarly, the false negative rate is the probability of a false negative <em>under the alternative hypothesis</em>. Unless we know the probability that we are testing a null effect, we can't say anything about the overall probability of false positives or negatives. If 100% of the hypotheses we test are false, then all significant effects are false positives, but if all of the hypotheses we test are true, then all of the positives are true positives and the overall false positive rate is 0.</p>
</div>

{#power}{#sesoi}
**Power** is equal to 1 minus beta (i.e., the **true positive rate**), and depends on the effect size, how many samples we take (n), and what we set alpha to. For any test, if you specify all but one of these values, you can calculate the last. The effect size you use in power calculations should be the smallest effect size of interest (**SESOI**). See [@TOSTtutorial](https://doi.org/10.1177/2515245918770963) for a tutorial on methods for choosing an SESOI. 

<div class="try">
Let's say you want to be able to detect at least a 15% difference from chance (50%) in a coin's fairness, and you want your test to have a 5% chance of false positives and a 10% chance of false negatives. What are the following values?

* alpha = <input class='solveme nospaces' size='4' data-answer='["0.05",".05","5%"]'/>
* beta = <input class='solveme nospaces' size='4' data-answer='["0.1","0.10",".1",".10","10%"]'/>
* false positive rate = <input class='solveme nospaces' size='4' data-answer='["0.05",".05","5%"]'/>
* false negative rate = <input class='solveme nospaces' size='4' data-answer='["0.1","0.10",".1",".10","10%"]'/>
* power = <input class='solveme nospaces' size='4' data-answer='["0.9","0.90",".9",".90","90%"]'/>
* SESOI = <input class='solveme nospaces' size='4' data-answer='["0.15",".15","15%"]'/>
</div>

{#conf-int}
The **confidence interval** is a range around some value (such as a mean) that has some probability (usually 95%, but you can calculate CIs for any percentage) of containing the parameter, if you repeated the process many times. 

<div class="info">
A 95% CI does *not* mean that there is a 95% probability that the true mean lies within this range, but that, if you repeated the study many times and calculated the CI this same way every time, you'd expect the true mean to be inside the CI in 95% of the studies. This seems like a subtle distinction, but can lead to some misunderstandings. See [@Morey2016](https://link.springer.com/article/10.3758/s13423-015-0947-8) for more detailed discussion.
</div>


#### Sampling function

To estimate these rates, we need to repeat the sampling above many times. 
A function is ideal for repeating the exact same procedure over and over. Set the arguments of the function to variables that you might want to change. Here, we will want to estimate power for:

* different sample sizes (`n`)
* different effects (`bias`)
* different hypothesised probabilities (`p`, defaults to 0.5)


```r
sim_binom_test <- function(n, bias, p = 0.5) {
  # simulate 1 coin flip n times with the specified bias
  coin <- rbinom(1, n, bias)
  # run a binomial test on the simulated data for the specified p
  btest <- binom.test(coin, n, p)
  # returun the p-value of this test
  btest$p.value
}
```

Once you've created your function, test it a few times, changing the values.


```r
sim_binom_test(100, 0.6)
```

```
## [1] 0.9204108
```

#### Calculate power {#calc-power}

Then you can use the `replicate()` function to run it many times and save all the output values. You can calculate the *power* of your analysis by checking the proportion of your simulated analyses that have a p-value less than your _alpha_ (the probability of rejecting the null hypothesis when the null hypothesis is true).


```r
my_reps <- replicate(1e4, sim_binom_test(100, 0.6))

alpha <- 0.05 # this does not always have to be 0.05

mean(my_reps < alpha)
```

```
## [1] 0.4663
```

<div class="info">
<p><code>1e4</code> is just scientific notation for a 1 followed by 4 zeros (<code>10000</code>). When you're running simulations, you usually want to run a lot of them. It's a pain to keep track of whether you've typed 5 or 6 zeros (100000 vs 1000000) and this will change your running time by an order of magnitude.</p>
</div>

### Normal Distribution {#normal}

#### Sample distribution

`rnorm(n, mean, sd)`

We can simulate a normal distribution of size `n` if we know the `mean` and standard deviation (`sd`). A density plot is usually the best way to visualise this type of data if your `n` is large.


```r
dv <- rnorm(1e5, 10, 2)

# proportions of normally-distributed data 
# within 1, 2, or 3 SD of the mean
sd1 <- .6827 
sd2 <- .9545
sd3 <- .9973

ggplot() +
  geom_density(aes(dv), fill = "white") +
  geom_vline(xintercept = mean(dv), color = "red") +
  geom_vline(xintercept = quantile(dv, .5 - sd1/2), color = "darkgreen") +
  geom_vline(xintercept = quantile(dv, .5 + sd1/2), color = "darkgreen") +
  geom_vline(xintercept = quantile(dv, .5 - sd2/2), color = "blue") +
  geom_vline(xintercept = quantile(dv, .5 + sd2/2), color = "blue") +
  geom_vline(xintercept = quantile(dv, .5 - sd3/2), color = "purple") +
  geom_vline(xintercept = quantile(dv, .5 + sd3/2), color = "purple") +
  scale_x_continuous(
    limits = c(0,20), 
    breaks = seq(0,20)
  )
```

<img src="08-sim_files/figure-html/rnorm-1.png" width="100%" style="display: block; margin: auto;" />

<div class="info">
<p>Run the simulation above several times, noting how the density plot changes. What do the vertical lines represent? Try changing the values of <code>n</code>, <code>mean</code>, and <code>sd</code>.</p>
</div>

#### T-test {#t-test}

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
## t = 4.988, df = 99, p-value = 2.608e-06
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  0.3087384 0.7166283
## sample estimates:
## mean of x 
## 0.5126833
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
## t = -2.9732, df = 193.23, p-value = 0.003323
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.6300477 -0.1275070
## sample estimates:
## mean of x mean of y 
## 0.3850962 0.7638735
```

<div class="warning">
<p>The <code>paired</code> argument defaults to <code>FALSE</code>, but it's good practice to always explicitly set it so you are never confused about what type of test you are performing.</p>
</div>

#### Sampling function

We can use the `names()` function to find out the names of all the t.test parameters and use this to just get one type of data, like the test statistic (e.g., t-value).


```r
names(t_ind)
t_ind$statistic
```

```
## [1] "statistic"   "parameter"   "p.value"     "conf.int"    "estimate"   
## [6] "null.value"  "alternative" "method"      "data.name"  
##         t 
## -2.973168
```

Alternatively, use `broom::tidy()` to convert the output into a tidy table.


```r
broom::tidy(t_ind)
```

```
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic p.value parameter conf.low conf.high
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>     <dbl>
## 1   -0.379     0.385     0.764     -2.97 0.00332      193.   -0.630    -0.128
## # … with 2 more variables: method <chr>, alternative <chr>
```


If you want to run the simulation many times and record information each time, first you need to turn your simulation into a function.


```r
sim_t_ind <- function(n, m1, sd1, m2, sd2) {
  # simulate v1
  v1 <- rnorm(n, m1, sd1)
  
  #simulate v2
  v2 <- rnorm(n, m2, sd2)
    
  # compare using an independent samples t-test
  t_ind <- t.test(v1, v2, paired = FALSE)
  
  # return the p-value
  return(t_ind$p.value)
}
```

Run it a few times to check that it gives you sensible values.


```r
sim_t_ind(100, 0.7, 1, 0.5, 1)
```

```
## [1] 0.08335778
```

Now replicate the simulation 1000 times.


```r
my_reps <- replicate(1e4, sim_t_ind(100, 0.7, 1, 0.5, 1))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.2959
```

<div class="try">
<p>Run the code above several times. How much does the power value fluctuate? How many replications do you need to run to get a reliable estimate of power?</p>
</div>

Compare your power estimate from simluation to a power calculation using `power.t.test()`. Here, `delta` is the difference between `m1` and `m2` above.


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

<img src="08-sim_files/figure-html/plot-reps-1.png" width="100%" style="display: block; margin: auto;" />

<div class="try">
<p>What do you think the distribution of p-values is when there is no effect (i.e., the means are identical)? Check this yourself.</p>
</div>

<div class="warning">
<p>Make sure the <code>boundary</code> argument is set to <code>0</code> for p-value histograms. See what happens with a null effect if <code>boundary</code> is not set.</p>
</div>

### Bivariate Normal

#### Correlation {#correlation}

You can test if two continuous variables are related to each other using the `cor()` function.

Below is one way to generate two correlated variables: `a` is drawn from a normal distribution, while `x` and `y` the sum of  and another value drawn from a random normal distribution. We'll learn later how to generate specific correlations in simulated data.


```r
n <- 100 # number of random samples

a <- rnorm(n, 0, 1)
x <- a + rnorm(n, 0, 1)
y <- a + rnorm(n, 0, 1)

cor(x, y)
```

```
## [1] 0.3525645
```

<div class="try">
<p>Set <code>n</code> to a large number like 1e6 so that the correlations are less affected by chance. Change the value of the <strong>mean</strong> for <code>a</code>, <code>x</code>, or <code>y</code>. Does it change the correlation between <code>x</code> and <code>y</code>? What happens when you increase or decrease the <strong>sd</strong> for <code>a</code>? Can you work out any rules here?</p>
</div>

`cor()` defaults to Pearson's correlations. Set the `method` argument to use Kendall or Spearman correlations.


```r
cor(x, y, method = "spearman")
```

```
## [1] 0.3062106
```

#### Sample distribution {#bvn}

What if we want to sample from a population with specific relationships between variables? We can sample from a **bivariate normal distribution** using `mvrnorm()` from the `MASS` package. 


```r
n   <- 1000 # number of random samples
rho <- 0.5  # population correlation between the two variables

mu     <- c(10, 20) # the means of the samples
stdevs <- c(5, 6)   # the SDs of the samples

# correlation matrix
cor_mat <- matrix(c(  1, rho, 
                    rho,   1), 2) 

# create the covariance matrix
sigma <- (stdevs %*% t(stdevs)) * cor_mat

# sample from bivariate normal distribution
bvn <- MASS::mvrnorm(n, mu, sigma) 

cor(bvn) # check correlation matrix
```

```
##          [,1]     [,2]
## [1,] 1.000000 0.539311
## [2,] 0.539311 1.000000
```

Plot your sampled variables to check everything worked like you expect. It's easiest to convert the output of `mvnorm` into a tibble in order to use it in ggplot.


```r
bvn %>%
  as_tibble() %>%
  ggplot(aes(V1, V2)) +
    geom_point(alpha = 0.5) + 
    geom_smooth(method = "lm") +
    geom_density2d()
```

```
## Warning: `as_tibble.matrix()` requires a matrix with column names or a `.name_repair` argument. Using compatibility `.name_repair`.
## This warning is displayed once per session.
```

<img src="08-sim_files/figure-html/graph-bvn-1.png" width="100%" style="display: block; margin: auto;" />

### Multivariate Normal {#mvnorm}

You can generate more than 2 correlated variables, but it gets a little trickier to create the correlation matrix.

#### Sample distribution


```r
n      <- 200 # number of random samples
rho1_2 <- 0.5 # correlation betwen v1 and v2
rho1_3 <- 0   # correlation betwen v1 and v3
rho2_3 <- 0.7 # correlation betwen v2 and v3

mu     <- c(10, 20, 30) # the means of the samples
stdevs <- c(8, 9, 10)   # the SDs of the samples

# correlation matrix
cor_mat <- matrix(c(     1, rho1_2, rho1_3, 
                    rho1_2,      1, rho2_3,
                    rho1_3, rho2_3,      1), 3) 

sigma <- (stdevs %*% t(stdevs)) * cor_mat
bvn3 <- MASS::mvrnorm(n, mu, sigma)

cor(bvn3) # check correlation matrix
```

```
##            [,1]     [,2]       [,3]
## [1,] 1.00000000 0.526778 0.04238033
## [2,] 0.52677804 1.000000 0.73857497
## [3,] 0.04238033 0.738575 1.00000000
```

Alternatively, you can use the (in-development) package faux to generate any number of correlated variables. It also allows to to easily name the variables and has a function for checking the parameters of your new simulated data (`check_sim_stats()`).


```r
#devtools::install_github("debruine/faux")
library(faux)
```

```
## 
## ************
## Welcome to faux. For support and examples visit:
## http://debruine.github.io/faux/
## - Get and set global package options with: faux_options()
## ************
```

```r
bvn3 <- faux::rnorm_multi(
  n = n,
  vars = 3,
  mu = mu,
  sd = stdevs,
  r = c(rho1_2, rho1_3, rho2_3),
  varnames = c("A", "B", "C")
)

faux::check_sim_stats(bvn3)
```

```
## Warning: All elements of `...` must be named.
## Did you want `multisim_data = c(A, B, C)`?
```

```
## # A tibble: 3 x 7
##       n var       A     B     C  mean    sd
##   <dbl> <chr> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1   200 A      1     0.48 -0.14  10.4  7.88
## 2   200 B      0.48  1     0.63  21.0  8.37
## 3   200 C     -0.14  0.63  1     30.6  9.28
```


#### 3D Plots

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
  plot_ly(x = ~A, y = ~B, z = ~C, marker = marker_style) %>%
  add_markers()
```

<!--html_preserve--><div id="htmlwidget-a2f50596dc8393459864" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-a2f50596dc8393459864">{"x":{"visdat":{"1de71ea2400f":["function () ","plotlyVisDat"]},"cur_data":"1de71ea2400f","attrs":{"1de71ea2400f":{"x":{},"y":{},"z":{},"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d","mode":"markers","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"A"},"yaxis":{"title":"B"},"zaxis":{"title":"C"}},"hovermode":"closest","showlegend":false},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[12.6083670024058,6.36122646228668,12.2544409381861,22.1714999668419,15.4344310386314,11.6162207555062,5.91706161607455,11.6144808741993,7.27086696886945,26.5105355886793,19.8830950271336,9.79374424555693,14.9348146893983,19.9532420638366,25.0540282290862,15.3788136337759,4.15970067951797,12.7078849440048,5.22527676970516,11.2410890155764,15.3633924690931,2.04618887796837,23.7178687870289,5.70763317997816,11.0405167891847,2.69652082805543,14.6999687833166,16.8041019488886,20.0130241527148,0.45725664315543,7.11698521100179,28.8013197223409,12.293748083555,8.22532318572171,21.1958187702776,-8.77973586959668,13.1709065672923,15.7638532843296,19.259786375195,8.48574515947254,1.56732570400427,2.40477274988207,16.7326773158987,8.10777226855499,13.5677559799233,16.5771058168727,-11.3000067720573,20.0545653751993,0.260123920050518,7.27706274445775,15.3044594112114,-2.34556733099235,7.19468610128647,22.6200730569302,12.3925824502698,4.94866328645585,-1.04345740247651,11.5968557358798,3.79733713978858,0.15628441571082,11.3586691060178,0.590844987693611,18.1457555078082,6.13623772815992,4.5312885957627,17.227330644018,9.23733359016146,3.08251445358619,4.34413539581293,2.03192713569511,8.39508906374432,-4.89265378982637,20.703552161257,2.73177891641275,18.2893351878787,10.6474741464922,17.5110187371093,11.3022354515033,18.2478984277374,6.36534823558046,8.46775925523767,13.0401092659601,6.04426828444106,20.8122565279673,8.12957695808228,7.081775708841,6.66939842348871,10.0267403993135,7.73136125752861,15.1630607263138,0.490490097714313,8.52055654868393,9.69488485131989,14.7068792296266,28.7748861025396,14.1137966276696,3.92183478361084,2.21773720112918,6.62849008547957,4.34818662390257,6.33678583090717,14.5187034665977,2.15465444770301,3.70236253298963,16.7218002517239,14.5723777118697,10.8609952939677,15.7518968666889,0.808781456597835,11.6313757230576,14.645745550223,20.5576671739282,11.465800117087,8.06952106599334,12.2959504260526,19.4033397156026,8.38364477447367,18.1532627773889,15.8335160041359,-2.06647949158381,11.9592500705946,1.07843052170672,8.9099160089493,12.5922964965646,0.268885132445259,10.6254134092356,12.5211927061256,7.14686587008166,14.1585247796275,5.92135001787867,11.7245542405758,18.6957330536429,8.11969922933652,0.456917567382982,7.2576279568463,25.687180941634,16.8130366152809,11.4629100584683,-6.08754876230991,6.11995340626945,0.71529831536415,7.25749213945387,7.77253687192546,6.87304502584013,-5.94794126345833,21.2641677804734,7.9808280168167,31.4033575420326,14.5408470237698,20.536434716855,1.54196197231417,8.42397650418055,9.76048807376718,11.5168914587048,28.0161159957812,-3.62392599497875,11.647998427765,-12.0852347314493,18.8900110972045,4.53104739949392,7.23727416307634,20.8538641397039,8.95348531461343,0.944274737012559,-2.40442028126848,23.2603404796527,-2.18381933409388,21.5508282505303,18.8497766079805,10.2001088077161,0.381382905566344,5.95471690220943,6.89218038666115,22.6108469037705,12.3113459702167,5.89645476493532,-5.68899876987158,6.63762897999473,15.4071780666117,4.70739152791616,10.7674188976629,9.48975104785403,10.1057857073929,17.7628898260405,17.2262038677775,4.07244258753947,10.4609680464575,-2.39726468450969,19.9510994598183,14.461970942805,7.38445480410885,8.24783352658683,24.374528098583,12.0348350436616,13.0936963061619,16.5564424572434,18.4789232614196,11.724032861981,16.7515403052027,12.5605068847005],"y":[20.3624419083991,21.7399189855995,4.08448368941389,26.4756830560029,30.2654998821932,20.2594252834978,18.7966401149551,17.371319134628,30.5485640394181,28.5105731962212,19.0463866805174,26.5927351223509,25.5482250278288,21.8791189891766,29.2300254744169,33.662694587036,29.8032530402373,38.8566110858767,15.9411814840229,12.078774414548,19.3570060207793,18.7180573276479,31.8937181509243,35.3344976503415,11.7365747864685,7.78171657378346,22.0986080053846,12.8492965647197,28.3006068297345,19.713241326703,23.999101375736,38.1992692991946,7.38118139081393,9.79347507552719,17.810759204945,12.6987562120524,18.8440764958371,20.0740657171184,20.2320219299023,14.2267988916655,21.3595771902926,-1.65291755656886,14.392394770534,27.2212002816911,38.2051773301848,27.1926277208883,6.5301170458064,20.9885489280085,15.433308343446,19.0011555025147,25.2386601171441,23.4389225076914,11.1471940071254,19.8930581140936,23.861141167432,7.74394530304086,11.8741152089984,28.4368975444758,10.5989364349715,9.42564748810321,27.4002619394806,19.6411983566845,42.0946166285425,9.45189189267511,23.4199373036897,17.9459693152081,24.4912810949241,23.6952692292045,30.1676988077947,19.8912864323574,18.0038200157678,9.19521272263484,27.9904018157461,6.14066145846881,25.9609653530169,22.5646014701445,34.7519324596088,16.1014984907847,21.7445585675441,21.0182569689852,7.70310511090462,38.2272420404679,13.8754024658153,29.7916875709027,27.963813949996,17.9889155080048,13.8388201781316,18.0524465402826,13.3048547743024,26.4797404787457,18.1841905277461,27.734101542383,35.8332082461659,19.0129456910674,18.589589917262,16.3064865281098,31.0475807575783,16.3787151288282,17.1009872259931,11.8785255483613,23.6169740272319,14.3454314581426,14.6101575597185,22.1476647064362,18.8736518220079,20.011785512349,29.2052881755322,20.5795716537861,7.32330121051379,13.8253448970203,25.1953149490001,19.9200481848172,24.1750852145179,26.4204579319141,22.1120324219909,37.2010556591143,27.6017509173656,18.0902563885676,30.8904072602231,20.6287519984186,1.07977445499293,23.1631313612659,31.9038508606498,25.0782822524923,2.51193943669319,20.9658726221974,27.5920080617383,17.4535032739415,25.1285869291355,16.0830969536434,16.655609776129,23.7473462716602,25.6507044392618,18.4441261963088,30.4459681857659,20.6767635918898,22.9170874309422,33.4656774167904,1.47745099520023,15.5479120849919,5.47768978032888,26.1549987619274,20.0863849438043,25.0717133371158,5.26000287526958,10.7938474332267,24.0341915479121,29.6517504352636,20.3066125892818,29.5809167129068,11.6627058756773,38.5786574176584,23.0937185042567,18.7036116164832,28.7258037428585,7.1802451182579,20.0950381217876,12.1801412888902,20.6874453849478,9.70118255484624,24.8003376332494,30.885309980701,26.9406211595275,11.2554224274649,15.8961489645236,26.2846184020927,17.2776625443671,27.0029444885079,37.9120434958332,23.4293651266291,13.6641587527449,28.6970250277124,21.8012206371381,26.1522289892619,28.170937324054,27.1903997784713,2.72803135441195,17.3863656595155,25.1512122399581,18.416475791199,8.6964470347342,8.77847867031726,27.0272623593204,19.9190517266812,29.1980031542548,20.0533874107572,16.312118046269,16.2993716816882,28.9238752447041,33.4079036598916,22.8080475565866,14.7964285783407,24.9591402291977,28.0302971272888,24.4048864930885,17.1307714790975,32.6564499952205,21.026488775678,24.1621545507367,31.2844793304679],"z":[27.3860811010919,40.0296301001653,5.11841179954811,35.2459968687756,35.3110178069949,26.4858926346628,35.1981323001033,29.7326933747718,39.4448851804835,19.4738078496414,15.6683733535041,40.6879332093763,29.9708632006823,31.8560719022715,34.0024953504457,40.1099257775454,33.5205790445324,49.7847133313449,27.6991255391417,21.9766154691134,24.487132168234,38.6415802500403,36.8375547084378,44.8634722405597,31.0024158253106,20.7229069227014,26.4345106484514,20.4118760921321,36.0925629906455,36.2236296536541,34.9434811238032,26.1754388102085,13.4748676375256,15.2190195604692,15.4828912968415,32.2889586404675,10.4774175008486,24.57446360875,29.392678611346,29.7628602889807,44.7470023935308,8.39343897352797,12.1155277815557,39.8884987185227,45.8746011899287,25.8192342510866,21.7267231569516,26.3502970233454,38.0338287339723,42.1514560402279,26.9722809811804,31.7748643352333,25.6366886497861,20.8037131177544,43.5832172751129,12.0702136075763,22.2536799457062,40.1815688718361,30.5481978659304,21.8033852809598,40.1313256896613,39.0175366730351,50.4641014868608,19.6526961300927,41.3008011201141,16.7543461005783,41.4617282966221,34.5046014998126,44.6172888021044,33.1668580513963,27.5029611383648,31.6942919967995,26.0677051052435,19.9558174892476,28.3569355503812,21.1883581452407,41.9841191311018,21.1240430319158,27.9268821296615,43.848129375457,12.3831970575861,59.3419907921375,27.7008350870915,33.7328309964413,35.7457433774776,23.9387558267141,26.0883852305469,29.7474743365395,26.7528112760428,37.8167756012066,33.1464436574557,37.9282348974103,39.9874492163993,27.3262428258796,24.7928048530788,16.323720549024,44.9468824837964,41.1928932324073,37.0823279993313,27.9928442928912,39.0953598467587,19.1269395385855,31.4034934880158,41.26683139768,36.7285700001738,32.6570217065109,28.4889627100659,25.7548559820811,22.0680352227856,32.4385831743253,26.6446415521046,26.2250953877551,38.8269962067005,35.5469557268423,29.0887675398198,42.6526663882892,35.601913092535,22.5427009944222,45.8051418989035,36.5160176652928,13.5525063010309,41.5620317710596,41.3157041402003,30.2386486389418,18.7639048240464,28.5483500692259,28.4870733856652,29.3617547083935,36.6753089060478,28.7094479004124,35.1589824869552,22.263258681176,43.8689695415958,36.8322001052786,36.3021840283187,19.5089060067416,22.9326960165341,38.3695151699928,17.3696648914706,20.6575283548579,14.3851810193398,45.6684817270334,33.774505052454,46.5738456848668,30.7179732683326,17.2281918998779,30.9681839578836,24.5475500829473,32.83893830319,31.8384613613787,25.3786441162928,44.7254163525105,32.4098035983199,34.5682177632631,28.055630152753,27.2683130675316,35.1025376810619,33.7425103779945,27.990761393749,27.0812021415886,45.6349204027523,33.0894140189154,40.1175958717214,30.3540064691985,35.7354883010401,26.2084097958631,34.2696462500943,24.8274069033203,29.7844798756618,22.6943941377123,17.9089050954875,44.4514156399913,40.0240391447096,15.1757559594292,38.4736535490954,37.7803909137013,20.1363441547869,36.5458802906418,29.5254415981903,47.1285092467619,14.5190604848312,18.398923265443,36.9164803320233,26.8171049299778,30.6713691178226,33.6135344157841,19.2858375339553,29.3637845448849,26.9634659554232,35.9722537058689,34.7785176047443,30.9032828553158,23.0338546693178,40.4857468758141,26.6494799301358,27.3351586038758,37.735278846091,21.037155167658,20.5379550895862,30.0254806423148],"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"type":"scatter3d","mode":"markers","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

## Example

This example uses the [Growth Chart Data Tables](https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv) 
from the [US CDC](https://www.cdc.gov/growthcharts/zscore.htm). The data consist of height in centimeters for the z-scores of –2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, and 2 by sex (1=male; 2=female) and half-month of age (from 24.0 to 240.5 months).

### Load & wrangle

We have to do a little data wrangling first. Have a look at the data after you import it and relabel `Sex` to `male` and `female` instead of `1` and `2`. Also convert `Agemos` (age in months) to years. Relabel the column `0` as `mean` and calculate a new column named `sd` as the difference between columns `1` and `0`. 


```r
orig_height_age <- read_csv("https://www.cdc.gov/growthcharts/data/zscore/zstatage.csv") 
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

```r
height_age <- orig_height_age %>%
  filter(Sex %in% c(1,2)) %>%
  mutate(
    sex = recode(Sex, "1" = "male", "2" = "female"),
    age = as.numeric(Agemos)/12,
    sd = `1` - `0`
  ) %>%
  dplyr::select(sex, age, mean = `0`, sd)
```

<div class="warning">
<p>If you run the code above without putting <code>dplyr::</code> before the <code>select()</code> function, you might get an error message. This is because the <code>MASS</code> package also has a function called <code>select()</code> and, since we loaded <code>MASS</code> after <code>tidyverse</code>, the <code>MASS</code> function becomes the default. When you loaded <code>MASS</code>, you should have seen a warning like &quot;The following object is masked from ‘package:dplyr’: select&quot;. You can use functions with the same name from different packages by specifying the package before the function name, separated by two colons.</p>
</div>

### Plot

Plot your new data frame to see how mean height changes with age for boys and girls.


```r
ggplot(height_age, aes(age, mean, color = sex)) +
  geom_smooth(aes(ymin = mean - sd, ymax = mean + sd), stat="identity")
```

<img src="08-sim_files/figure-html/plot-height-means-1.png" width="100%" style="display: block; margin: auto;" />

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

Simulate 50 random male heights and 50 random female heights using the `rnorm()` function and the means and SDs above. Plot the data.


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

<img src="08-sim_files/figure-html/sim-height-20-1.png" width="100%" style="display: block; margin: auto;" />

<div class="try">
<p>Run the simulation above several times, noting how the density plot changes. Try changing the age you're simulating.</p>
</div>

### Analyse simulated data

Use the `sim_t_ind(n, m1, sd1, m2, sd2)` function we created above to generate one simulation with a sample size of 50 in each group using the means and SDs of male and female 14-year-olds.


```r
height_sub <- height_age %>% filter(age == 14)
m_mean <- height_sub %>% filter(sex == "male") %>% pull(mean)
m_sd   <- height_sub %>% filter(sex == "male") %>% pull(sd)
f_mean <- height_sub %>% filter(sex == "female") %>% pull(mean)
f_sd   <- height_sub %>% filter(sex == "female") %>% pull(sd)

sim_t_ind(50, m_mean, m_sd, f_mean, f_sd)
```

```
## [1] 0.009012868
```

### Replicate simulation

Now replicate this 1e4 times using the `replicate()` function. This function will save the returned p-values in a list (`my_reps`). We can then check what proportion of those p-values are less than our alpha value. This is the power of our test.


```r
my_reps <- replicate(1e4, sim_t_ind(50, m_mean, m_sd, f_mean, f_sd))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.657
```

### One-tailed prediction

This design has about 65% power to detect the sex difference in height (with a 2-tailed test). Modify the `sim_t_ind` function for a 1-tailed prediction.

You could just set `alternative` equal to "greater" in the function, but it might be better to add the `alternative` argument to your function (giving it the same default value as `t.test`) and change the value of `alternative` in the function to `alternative`.


```r
sim_t_ind <- function(n, m1, sd1, m2, sd2, alternative = "two.sided") {
  v1 <- rnorm(n, m1, sd1)
  v2 <- rnorm(n, m2, sd2)
  t_ind <- t.test(v1, v2, paired = FALSE, alternative = alternative)
  
  return(t_ind$p.value)
}

alpha <- 0.05
my_reps <- replicate(1e4, sim_t_ind(50, m_mean, m_sd, f_mean, f_sd, "greater"))
mean(my_reps < alpha)
```

```
## [1] 0.758
```

### Range of sample sizes

What if we want to find out what sample size will give us 80% power? We can try trial and error. We know the number should be slightly larger than 50. But you can search more systematically by repeating your power calculation for a range of sample sizes. 

<div class="info">
<p>This might seem like overkill for a t-test, where you can easily look up sample size calculators online, but it is a valuable skill to learn for when your analyses become more complicated.</p>
</div>

Start with a relatively low number of replications and/or more spread-out samples to estimate where you should be looking more specifically. Then you can repeat with a narrower/denser range of sample sizes and more iterations.


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

<img src="08-sim_files/figure-html/range-sample-sizes-1.png" width="100%" style="display: block; margin: auto;" />

Now we can narrow down our search to values around 55 (plus or minus 5) and increase the number of replications from 1e3 to 1e4.


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

## Exercises

Download the [exercises](exercises/08_sim_exercise.Rmd). See the [answers](exercises/08_sim_answers.Rmd) only after you've attempted all the questions.

