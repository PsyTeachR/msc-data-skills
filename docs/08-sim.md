
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
    + p-value
    + alpha
    + power
    + smallest effect size of interest (SESOI)
    + false positive (type I error)
    + false negative (type II error)
    + confidence interval

### Intermediate

5. Create a function to generate a sample with specific properties and run an inferential test
6. Calculate power using `replicate` and a sampling function
7. Calculate the minimum sample size for a specific power level and design

### Advanced

8. Generate 3+ variables from a multivariate normal distribution and plot them

## Resources

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

Assume a uniform distribution of 30-50 [feral hogs](https://twitter.com/WillieMcNabb/status/1158045307562856448) that daily run into your yard within 3-5 minutes while your small kids play. Simulate a full year of feral hog attacks (365 events). Set `replace` to `TRUE` so each event is independent. See what happens if you set `replace` to `FALSE`.


```r
feralhogs <- sample(30:50, 365, replace = TRUE)

# plot the results
ggplot() + 
  geom_histogram(aes(feralhogs), binwidth = 1, 
                 fill = "white", color = "black")
```

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/sample-replace-1.png" alt="Distribution of feral hogs." width="100%" />
<p class="caption">(\#fig:sample-replace)Distribution of feral hogs.</p>
</div>

You can also use sample to sample from a list of named outcomes.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
sample(pet_types, 10, replace = TRUE)
```

```
##  [1] "fish"   "ferret" "bird"   "fish"   "fish"   "cat"    "fish"  
##  [8] "cat"    "bird"   "dog"
```

Ferrets are a much less common pet than cats and dogs, so our sample isn't very realistic. You can set the probabilities of each item in the list with the `prob` argument.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
pet_prob <- c(0.3, 0.4, 0.1, 0.1, 0.1)
sample(pet_types, 10, replace = TRUE, prob = pet_prob)
```

```
##  [1] "dog"    "cat"    "dog"    "dog"    "ferret" "bird"   "cat"   
##  [8] "dog"    "dog"    "fish"
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
##  [1] 1 1 0 1 0 1 1 1 0 1 0 1 1 0 0 0 1 0 1 0
```



```r
# 20 individual coin flips of a baised (0.75) coin
rbinom(20, 1, 0.75)
```

```
##  [1] 1 1 0 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 1 1
```

You can generate the total number of heads in 1 set of 20 coin flips by setting `size` to 20 and `n` to 1.


```r
rbinom(1, 20, 0.75)
```

```
## [1] 16
```

You can generate more sets of 20 coin flips by increasing the `n`.


```r
rbinom(10, 20, 0.5)
```

```
##  [1] 14 10  9 11  8  9 12 12 14  9
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
## number of successes = 3, number of trials = 10, p-value = 0.3438
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.06673951 0.65245285
## sample estimates:
## probability of success 
##                    0.3 
## 
## 
## 	Exact binomial test
## 
## data:  biased_coin and n
## number of successes = 9, number of trials = 10, p-value = 0.02148
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.5549839 0.9974714
## sample estimates:
## probability of success 
##                    0.9
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

The **p-value** of a test is the probability of seeing an effect at least as extreme as what you have, if the real effect was the value you are testing against (e.g., a null effect). So if you used a binomial test to test against a chance probability of 1/6 (e.g., the probability of rolling 1 with a 6-sided die), then a p-value of 0.17 means that you could expect to see effects at least as extreme as your data 17% of the time just by chance alone. 

If you are using null hypothesis significance testing (**NHST**), then you need to decide on a cutoff value (**alpha**) for making a decision to reject the null hypothesis. We call p-values below the alpha cutoff **significant**. In psychology, alpha is traditionally set at 0.05, but there are good arguments for [setting a different criterion in some circumstances](http://daniellakens.blogspot.com/2019/05/justifying-your-alpha-by-minimizing-or.html). 

The probability that a test concludes there is an effect when there is really no effect (e.g., concludes a fair coin is biased) is called the **false positive rate** (or _Type I Error Rate_). The alpha is the false positive rate we accept for a test. The probability that a test concludes there is no effect when there really is one (e.g., concludes a biased coin is fair) is called the **false negative rate** (or _Type II Error Rate_). The **beta** is the false negative rate we accept for a test.

<div class="info">
<p>The false positive rate is not the overall probability of getting a false positive, but the probability of a false positive <em>under the null hypothesis</em>. Similarly, the false negative rate is the probability of a false negative <em>under the alternative hypothesis</em>. Unless we know the probability that we are testing a null effect, we can’t say anything about the overall probability of false positives or negatives. If 100% of the hypotheses we test are false, then all significant effects are false positives, but if all of the hypotheses we test are true, then all of the positives are true positives and the overall false positive rate is 0.</p>
</div>


**Power** is equal to 1 minus beta (i.e., the **true positive rate**), and depends on the effect size, how many samples we take (n), and what we set alpha to. For any test, if you specify all but one of these values, you can calculate the last.  The effect size you use in power calculations should be the smallest effect size of interest (**SESOI**). See [@TOSTtutorial](https://doi.org/10.1177/2515245918770963) for a tutorial on methods for choosing an SESOI. 

<div class="try">
Let's say you want to be able to detect at least a 15% difference from chance (50%) in a coin's fairness, and you want your test to have a 5% chance of false positives and a 10% chance of false negatives. What are the following values?

* alpha = <input class='solveme nospaces' size='4' data-answer='["0.05",".05","5%"]'/>
* beta = <input class='solveme nospaces' size='4' data-answer='["0.1","0.10",".1",".10","10%"]'/>
* false positive rate = <input class='solveme nospaces' size='4' data-answer='["0.05",".05","5%"]'/>
* false negative rate = <input class='solveme nospaces' size='4' data-answer='["0.1","0.10",".1",".10","10%"]'/>
* power = <input class='solveme nospaces' size='4' data-answer='["0.9","0.90",".9",".90","90%"]'/>
* SESOI = <input class='solveme nospaces' size='4' data-answer='["0.15",".15","15%"]'/>
</div>

The **confidence interval** is a range around some value (such as a mean) that has some probability (usually 95%, but you can calculate CIs for any percentage) of containing the parameter, if you repeated the process many times. 

<div class="info">
A 95% CI does *not* mean that there is a 95% probability that the true mean lies within this range, but that, if you repeated the study many times and calculated the CI this same way every time, you'd expect the true mean to be inside the CI for 95% of the studies. This seems like a subtle distinction, but can lead to some misunderstandings. See [@Morey2016](https://link.springer.com/article/10.3758/s13423-015-0947-8) for more detailed discussion.
</div>


#### Sampling function

To estimate these rates, we need to repeat the sampling above many times. 
A function is ideal for repeating the exact same procedure over and over. Set the arguments of the function to variables that you might want to change. Here, we will want to estimate power for:

* different sample sizes (`n`)
* different effects (`bias`)
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
## [1] 0.271253
```

#### Calculate power

Then you can use the `replicate()` function to run it many times and save all the output values. You can calculate the *power* of your analysis by checking the proportion of your simulated analyses that have a p-value less than your _alpha_ (the probability of rejecting the null hypothesis when the null hypothesis is true).


```r
my_reps <- replicate(1e4, sim_binom_test(100, 0.6))

alpha <- 0.05 # this does not always have to be 0.05

mean(my_reps < alpha)
```

```
## [1] 0.4621
```

<div class="info">
<p><code>1e4</code> is just scientific notation for a 1 followed by 4 zeros (<code>10000</code>). When you’re running simulations, you usually want to run a lot of them. It’s a pain to keep track of whether you’ve typed 5 or 6 zeros (100000 vs 1000000) and this will change your running time by an order of magnitude.</p>
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
## t = 4.1655, df = 99, p-value = 6.647e-05
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  0.2294637 0.6469259
## sample estimates:
## mean of x 
## 0.4381948
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
## t = -0.48867, df = 197.58, p-value = 0.6256
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.3508385  0.2114936
## sample estimates:
## mean of x mean of y 
## 0.3851455 0.4548180
```

<div class="warning">
<p>The <code>paired</code> argument defaults to <code>FALSE</code>, but it’s good practice to always explicitly set it so you are never confused about what type of test you are performing.</p>
</div>

#### Sampling function

We can use the `names()` function to find out the names of all the t.test parameters 
and use this to just get one type of data, like the test statistic (e.g., t-value).

```r
names(t_ind)
t_ind$statistic
```

```
##  [1] "statistic"   "parameter"   "p.value"     "conf.int"    "estimate"   
##  [6] "null.value"  "stderr"      "alternative" "method"      "data.name"  
##          t 
## -0.4886689
```

Alternatively, use `broom::tidy()` to convert the output into a tidy table.


```r
broom::tidy(t_ind)
```

```
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic p.value parameter conf.low
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>
## 1  -0.0697     0.385     0.455    -0.489   0.626      198.   -0.351
## # … with 3 more variables: conf.high <dbl>, method <chr>,
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
## [1] 0.6831236
```

Now replicate the simulation 1000 times.


```r
my_reps <- replicate(1e4, sim_t_ind(100, 0.7, 1, 0.5, 1))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.2881
```

<div class="try">
<p>Run the code above several times. How much does the power value fluctuate? How many replications do you need to run to get a reliable estimate of power?</p>
</div>

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

<img src="08-sim_files/figure-html/plot-reps-1.png" width="100%" style="display: block; margin: auto;" />

<div class="try">
<p>What do you think the distribution of p-values is when there is no effect (i.e., the means are identical)? Check this yourself.</p>
</div>

<div class="warning">
<p>Make sure the <code>boundary</code> argument is set to <code>0</code> for p-value histograms. See what happens with a null effect if <code>boundary</code> is not set.</p>
</div>

#### Bivariate Normal

##### Correlation {#correlation}

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
## [1] 0.7457472
```

`cor()` defaults to Pearson's correlations. Set the `method` argument to use 
Kendall or Spearman correlations.


```r
cor(x, y, method = "spearman")
```

```
## [1] 0.6889409
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
## [1,] 1.0000000 0.4869113
## [2,] 0.4869113 1.0000000
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

```
## Warning: `as_tibble.matrix()` requires a matrix with column names or a `.name_repair` argument. Using compatibility `.name_repair`.
## This warning is displayed once per session.
```

<img src="08-sim_files/figure-html/graph-bvn-1.png" width="100%" style="display: block; margin: auto;" />

### Multivariate Normal {#mvnormal}

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
##             [,1]      [,2]        [,3]
## [1,]  1.00000000 0.4492981 -0.01446969
## [2,]  0.44929815 1.0000000  0.75307538
## [3,] -0.01446969 0.7530754  1.00000000
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

<!--html_preserve--><div id="htmlwidget-2879447767351803fdc2" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-2879447767351803fdc2">{"x":{"visdat":{"16816c3757bc":["function () ","plotlyVisDat"]},"cur_data":"16816c3757bc","attrs":{"16816c3757bc":{"x":{},"y":{},"z":{},"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d","mode":"markers","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"V1"},"yaxis":{"title":"V2"},"zaxis":{"title":"V3"}},"hovermode":"closest","showlegend":false},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[4.67907747212413,4.52344023683387,24.8360353963945,17.1048035853032,5.8933758074909,9.08048671427783,2.81190835822941,19.2077942280692,8.99705335874311,13.6936605864359,20.0062505445599,9.14608452368056,-0.487804947849458,10.3692601893058,16.3017261178368,7.7938835592491,12.7461716326392,13.1425290371071,7.35506684140778,15.2933739398867,14.1984160963122,18.284662080053,16.6620626900739,19.1096252658426,5.65359673013781,18.2654847114886,13.1359326935717,10.2184959045632,12.4736042061048,5.80109447068049,25.9085461383484,10.1694336313408,22.3600421257765,14.2083030141002,8.87478932528106,18.7885088901473,13.7136530021823,17.9158398967896,-1.90963889626715,14.2186255362959,12.1962529218378,7.98018675128273,13.1718550461007,10.5397452338159,4.8832446052406,18.2122032539122,0.101705355759254,4.1360379791199,6.54530920595094,-1.90688055489159,1.13660698958688,-8.46813283122039,23.1195483403938,27.7681182315169,-5.04470919877587,14.2234367060931,-3.81483622191691,12.4841395856909,8.7250934579428,25.4538668834754,2.17591099961449,6.59626200022251,23.8017948845289,3.60344929088621,8.85507518567652,8.85300868001983,10.4587989442247,11.6681166647952,7.3078843333226,11.8130466116114,17.6003951563143,4.48416700268444,-6.5531044807034,3.49701788276773,11.7713460784719,12.4040902493741,9.27781896512095,11.001133491063,12.6177184798162,16.5387093693057,8.51362691689422,15.9979492644169,13.6814820561803,5.24014915180584,20.5940713363957,13.5391723366245,13.622621078029,17.0084562190922,6.64662200189418,-3.9194622363975,21.2541024546605,12.009186102903,10.0807130813151,4.97403270872283,15.6243621275023,-0.603534652888351,5.81505372576677,20.9078430301294,0.0271301857759276,4.71476011233484,22.0737534248947,3.81511645808235,0.181070679606268,7.1199298908302,12.3112370412157,1.16147407724969,7.63036752518409,9.67499263037242,7.37236155240397,18.8569401887164,5.78608146637569,17.454414068133,-0.478545627043887,18.1445591711959,2.39246559116837,16.9469429203207,10.374444450976,5.02956093585476,14.4212370844136,3.75266972303642,14.949395549754,28.1565882475054,14.9575037948333,-1.76492436501701,6.01954089976566,12.3589411347197,12.401495050413,3.03477452505842,8.48034339980193,5.46345487729294,15.0817904124614,21.748378165979,13.938762475701,9.79732762181426,-0.0410979334907644,9.29268947037517,5.70187861217585,16.9264980637973,1.74325208337003,13.2897361949414,11.4374737084697,13.8760658980091,5.93623155118456,-4.1681804289078,9.83179248934774,16.9353763288059,-2.47117840926597,19.6043571657963,7.64284027428454,5.66213167330364,0.106573979884795,10.9732450501507,13.5933993558015,6.33047565254052,9.4771305007756,22.2460194556516,1.59751269172772,10.219162366106,-16.7668342278292,5.81041908562038,12.9847388018267,-10.3595805069869,-5.3365443962932,13.0687731922524,32.7679567298188,4.89771622597855,19.7521466734085,-0.945693684205008,13.109773795868,11.6650678399905,3.27270231410645,16.5289034657958,8.75272017233896,2.15750305136579,7.19657553271203,4.77809846088487,14.4095406117066,-0.632314178504087,-11.065544041398,4.24431366435347,7.14132552988117,3.3130561924938,22.8637971872194,6.38446093984693,2.48370073282526,19.7899342364614,3.76239581063113,11.7540268851056,18.9073928694137,4.01669030066735,-1.22473615182239,9.00273999912486,4.1203689629116,15.8196208619067,10.0690216735002,26.2270934419831,6.71837044348172,-2.91625233617052,15.7255210096967,20.9803164920777],"y":[19.5608265678665,14.262167511924,44.1969684823533,7.11508680635299,24.4248764256211,14.5089070603066,17.9150598483397,33.290881505064,25.3636608436326,20.0659309128522,17.8412507907248,22.9941220411588,11.5072765380398,20.6943594732558,25.4542017795886,25.2363695401936,26.1981548177652,18.9605541745476,29.9479135712081,21.4504731821235,23.6351589358638,26.5763634657886,14.1309286797015,19.2159358432547,19.5009695689723,28.7746433374283,15.1249422507125,17.6931209742845,19.8818264640572,20.4995704353599,17.0946704347308,11.911896029455,34.8442293138438,25.8303651241979,16.1831710027331,29.1207105061875,16.4456381724281,23.7290759607772,23.7220773296002,27.0382656065806,21.5208427168341,16.1372512598974,25.9958509003022,2.89778662109439,14.9714194303958,16.574337850378,15.3132057514937,-2.51144818479682,32.7070482299053,15.2346730321471,14.5957962131258,24.8580484833472,33.6120347752591,5.36791206060885,20.6945936704379,24.9748813700184,27.7174663782225,22.3934971292783,18.6338036326404,36.524735918527,15.9952062264372,16.7810532915528,39.6764797913898,21.4939993475879,18.1280107799123,24.7861546069968,16.7025183672831,21.1689589733694,9.46976123452126,22.5792573848954,24.1407393771307,24.9705171874583,13.5836308445169,16.7158944732626,16.7480898604145,22.9051355364896,18.9876906991791,12.872964089534,11.8461219445788,27.685023212378,8.88076583377177,24.324848263004,29.6247907280875,17.6105814981179,37.1352253273874,22.0542209797522,15.2589073750357,29.7819204678686,31.1601645290516,2.66665914011536,29.5230591801513,15.328572896049,20.4147522971488,7.23272855591857,29.4394952754934,21.3220259347071,36.2296521056839,33.2012869715318,32.1853379534354,20.0872011055366,37.9821427630878,11.2599364657747,17.7002102954837,24.1731647077084,16.3652129476104,12.4587517867818,26.5399612471372,37.7378896212642,15.5056607603213,20.7459153534904,10.4098825500851,20.5260902659753,35.2909028924583,22.4034006775107,28.139751618525,29.544555724792,22.3119831909921,33.3557640644305,19.8485318810355,22.7376559925498,38.1546144074388,28.1260608416354,30.657619043642,21.8487413198501,36.2915048716571,17.5878508363633,22.3209683970065,19.0231874822668,28.0208231287878,23.187832448555,18.9454886657451,23.9736311507625,27.4162685694341,6.55906199947339,2.05510247655673,-1.17861462134528,21.5002081753657,30.499145106062,13.4883427483811,16.3844781692406,12.4385599678479,27.060821077247,11.1962680604901,1.25861032362708,38.696019662636,26.6665592186617,9.43258219975647,32.7455049777596,23.5404871780586,21.6516026224971,16.1496519187142,4.09915007463819,14.1998965617315,25.0207149502785,14.9790583634259,31.807368313708,10.4927651707732,14.2942341746191,1.2072415174848,29.4057758544312,16.2010598770884,2.53076704771246,13.3647358683145,31.6298283785638,26.1595045652348,16.4542741420567,25.2148631156298,7.97412542744627,22.626330921776,28.5520864095424,12.3082316871455,21.1262166053203,6.41669127014676,15.9807248248603,13.0149989966323,20.1935821764183,11.3107157750283,2.91027626193888,25.4145882207792,15.2403752508117,6.10622331812739,28.2952914917891,38.616838119925,11.5808514698627,26.6192801964547,21.7047105524567,14.5082113235283,4.15469372699389,40.8828860435029,6.61649302976747,9.20480894555023,15.0108603052807,15.9238468662351,19.9095331766472,18.4710473452149,37.7878349763809,16.6376888752255,11.9261607237891,19.3056580025855,52.748732778801],"z":[39.6706665207903,24.4066745284212,47.2669224805981,14.8496767950106,28.7826012499115,36.3447982812964,40.4865159655292,36.4996868671654,33.9893584376976,24.2025494510405,13.8253583184365,33.8241621954177,25.735429506267,27.1057388364891,35.8552189355118,37.8226818193615,29.5334907656669,24.8031431458807,46.4520295465562,28.2800475505831,36.2148153572162,36.1986450284051,17.3296587342305,20.204890878311,38.3226657520848,33.5189150667645,15.5781151170019,26.2897735994318,38.9529975654038,27.6927079718767,20.2148553118261,21.7760305842258,45.6835170277281,34.4602711266401,32.3727204744422,32.9432875058752,26.7372146008989,44.0028435169545,42.6311126983614,34.8040702566409,33.0997289650796,19.2720846069971,32.8089088233797,2.68011701673587,24.6838555043286,26.6499267974633,35.295817955363,4.32190848715915,37.8053336452794,33.4533218502426,28.2557303962803,47.6734071833513,34.6967589536772,-3.41313110195429,28.7102166425435,29.4413295413546,49.0679084649242,28.8425847823638,39.1304343810162,27.1415001262544,28.7881420791571,35.1146196678529,43.3379801930597,38.6817398912618,34.8739746701553,33.0443468809544,21.6277289828421,23.9642665353345,11.9066284322044,36.494188947021,33.5865700238833,25.5376715638958,40.2474395745834,33.9813449252348,21.0028310574334,39.7803816271853,31.7591674209149,14.1024197955893,20.1890231117663,35.2000967743616,15.6212405230232,34.9646412691843,45.8369984672622,15.1073003168132,35.7137130688383,20.9197907100274,24.6308257347813,43.5525949814169,36.0768935121554,14.8272441507836,32.3816439682322,23.5283152213004,39.0070369053428,24.516317445373,37.6025411347626,43.292683813279,52.7303440827481,46.9739409252814,43.7027976594317,28.5224230208711,47.4116892649407,19.0679210673476,30.0637354786243,28.2957447738785,19.0321718247252,20.6131480154011,32.1891167800781,43.5350594916,32.9109405986874,18.2951597405184,24.4938714266536,27.1280988872255,58.938479086087,21.3563070971627,40.1142703668311,41.6630442216973,35.3952441124581,55.7057148228926,32.8632166642252,51.252411899167,53.2029066073098,25.0588335711889,36.2428989319525,44.5525948574348,44.4798522609116,19.2765528448254,38.9491147936875,37.952587474591,47.0559598684385,32.9235172558355,19.0237748992799,32.8369216681091,39.8678437198108,14.2844578523613,9.1710289113308,7.48023461833557,41.7814966239004,44.5031634366802,24.7507761006853,24.9399015548823,18.191884755275,36.1618262639184,26.5908555377012,16.3803231203185,50.7118643687616,35.8608252057434,34.2001200364532,31.9044378250081,34.8077921162237,23.2078550677111,29.4612418915654,18.59440889965,35.2768626910479,33.9515756255211,23.3126010221282,37.4653000040246,26.2990136573142,20.7589866489522,34.4325371953573,45.071264968852,32.7799549139528,23.6511256237972,27.1375516978006,47.1613310144573,16.2162827487226,34.2502745926094,33.2483353537458,15.1770505026392,26.5528252528019,39.1058883358111,28.650907099739,28.3997933827652,13.1358527624828,33.3432075782472,24.3566476242517,27.1243263101875,26.5730727860122,21.3148620462258,41.2397990331289,34.2437009467794,17.9359490250835,41.5814023478699,44.5468758173188,23.1573508816135,38.1561183286752,28.2712357114411,22.1524455100534,13.6264275709355,43.4042820141001,18.8178888327428,20.9960228854173,26.7357715061526,27.2269213228505,28.5647839099557,26.3180264935283,39.7952050950438,28.5220164930232,27.0506739735047,29.5706668331776,47.9698183352923],"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"type":"scatter3d","mode":"markers","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

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

<div class="warning">
<p>If you run the code above without putting <code>dplyr::</code> before the <code>select()</code> function, you will get an error message. This is because the <code>MASS</code> package also has a function called <code>select()</code> and, since we loaded <code>MASS</code> after <code>tidyverse</code>, the <code>MASS</code> function is the default. When you loaded <code>MASS</code>, you should have seen a warning like “The following object is masked from ‘package:dplyr’: select”. You can use functions with the same name from different packages by specifying the package before the function name, separated by two colons.</p>
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

<img src="08-sim_files/figure-html/sim-height-20-1.png" width="100%" style="display: block; margin: auto;" />

<div class="try">
<p>Run the simulation above several times, noting how the density plot changes. Try changing the age you’re simulating.</p>
</div>

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
## [1] 0.05057527
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
## [1] 0.6437
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
## [1] 0.762
```

### Range of sample sizes

What if we want to find out what sample size will give us 80% power? We can try 
trial and error. We know the number should be slightly larger than 50. But you 
can search more systematically by repeating your power calculation for a range 
of sample sizes. 

<div class="info">
<p>This might seem like overkill for a t-test, where you can easily look up sample size calculators online, but it is a valuable skill to learn for when your analyses become more complicated.</p>
</div>

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

<img src="08-sim_files/figure-html/range-sample-sizes-1.png" width="100%" style="display: block; margin: auto;" />

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

## Exercises

Download the [exercises](exercises/08_sim_exercise.Rmd). See the [answers](exercises/08_sim_answers.Rmd) only after you've attempted all the questions.

