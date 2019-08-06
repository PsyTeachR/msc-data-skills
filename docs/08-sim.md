
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
runif(10, min = 0, max = 1)
```

```
##  [1] 0.1594836 0.4781883 0.7647987 0.7696877 0.2685485 0.6730459 0.9787908
##  [8] 0.8463270 0.8566562 0.4451601
```

#### Sample discrete distribution

`sample(x, size, replace = FALSE, prob = NULL)`

Use `sample()` to sample from a discrete distribution.

Simulate the number of feral hogs (30-50) that will run into your yard within 3-5 minutes while your small kids play.


```r
sample(30:50, 1)
```

```
## [1] 50
```

Simulate a full year of feral hog attacks (365 events). Set `replace` to `TRUE` so each event is independent. See what happens if you set `replace` to `FALSE`.


```r
feralhogs <- sample(30:50, 365, replace = TRUE)

# plot the results
ggplot() + 
  geom_histogram(aes(feralhogs), binwidth = 1, 
                 fill = "white", color = "black")
```

<img src="08-sim_files/figure-html/sample-replace-1.png" width="100%" style="display: block; margin: auto;" />

You can also use sample to sample from a list of named outcomes.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
sample(pet_types, 10, replace = TRUE)
```

```
##  [1] "dog"    "ferret" "fish"   "fish"   "dog"    "bird"   "cat"   
##  [8] "cat"    "ferret" "fish"
```

Ferrets are a much less common pet than cats and dogs, so our sample isn't very realistic. You can set the probabilities of each item in the list with the `prob` argument.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
pet_prob <- c(0.3, 0.4, 0.1, 0.1, 0.1)
sample(pet_types, 10, replace = TRUE, prob = pet_prob)
```

```
##  [1] "dog"  "dog"  "cat"  "cat"  "dog"  "cat"  "bird" "bird" "cat"  "fish"
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
##  [1] 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 1 1 0 0 1
```



```r
# 20 individual coin flips of a baised (0.75) coin
rbinom(20, 1, 0.75)
```

```
##  [1] 1 1 1 0 0 1 0 1 0 0 1 0 1 1 1 1 1 1 1 1
```

You can generate the total number of heads in 1 set of 20 coin flips by setting `size` to 20 and `n` to 1.


```r
rbinom(1, 20, 0.75)
```

```
## [1] 15
```

You can generate more sets of 20 coin flips by increasing the `n`.


```r
rbinom(10, 20, 0.5)
```

```
##  [1]  9 12  9  9 12 14 11  9 12  8
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
## number of successes = 6, number of trials = 10, p-value = 0.7539
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.2623781 0.8784477
## sample estimates:
## probability of success 
##                    0.6 
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
## [1] 0.4608
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
## t = 3.8878, df = 99, p-value = 0.0001831
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  0.1856698 0.5727292
## sample estimates:
## mean of x 
## 0.3791995
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
## t = -0.97844, df = 197.56, p-value = 0.3291
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.3959699  0.1333474
## sample estimates:
## mean of x mean of y 
## 0.5436880 0.6749993
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
## -0.9784364
```

Alternatively, use `broom::tidy()` to convert the output into a tidy table.


```r
broom::tidy(t_ind)
```

```
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic p.value parameter conf.low
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>
## 1   -0.131     0.544     0.675    -0.978   0.329      198.   -0.396
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
## [1] 0.571057
```

Now replicate the simulation 1000 times.


```r
my_reps <- replicate(1e4, sim_t_ind(100, 0.7, 1, 0.5, 1))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.295
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
## [1] 0.7306851
```

`cor()` defaults to Pearson's correlations. Set the `method` argument to use 
Kendall or Spearman correlations.


```r
cor(x, y, method = "spearman")
```

```
## [1] 0.6618542
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
## [1,] 1.0000000 0.4646801
## [2,] 0.4646801 1.0000000
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
## [1,]  1.00000000 0.5435482 -0.04119722
## [2,]  0.54354825 1.0000000  0.66643567
## [3,] -0.04119722 0.6664357  1.00000000
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

<!--html_preserve--><div id="htmlwidget-0ece189f667176d1cd7c" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-0ece189f667176d1cd7c">{"x":{"visdat":{"1664c2a070743":["function () ","plotlyVisDat"]},"cur_data":"1664c2a070743","attrs":{"1664c2a070743":{"x":{},"y":{},"z":{},"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d","mode":"markers","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"V1"},"yaxis":{"title":"V2"},"zaxis":{"title":"V3"}},"hovermode":"closest","showlegend":false},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[0.685208328007118,8.06704399216201,0.979646928247671,17.1885139873201,15.2092855732425,-4.00463621139152,4.77865275540326,18.3548493119544,22.4647071166635,11.5760836166994,7.47075275778106,17.6069700932851,8.0582875565804,8.87442337509713,-3.37978825058039,14.8401507802809,9.2778244822238,15.5451950499029,12.2275573362882,16.0126638102551,7.68993021870436,6.46304753087888,19.2330580813855,1.31657853095186,-9.44074617850683,15.8370430824237,6.51750931488968,-8.00511575639492,9.5912486062037,18.2204666578282,2.52256730619358,5.4845903589886,11.1799826878725,15.0785215158451,-2.21583497684586,11.3680040956568,-3.58906337365327,13.1968565614297,16.4589621030767,0.315434321528706,10.2453604138687,3.00819509102722,0.157025254337938,11.7640210507412,0.0548842004734453,8.08440960369633,13.3550209106815,0.906017312559136,18.3912412707808,9.02070709687291,10.5326319152282,12.0276495404503,12.9704873396786,14.912268000751,26.5667454610012,10.6726324574777,7.78692075578975,25.6591638636137,13.9691057414372,4.29079647260162,20.3953309968051,5.08956580432569,3.32907695626621,18.1120428107014,12.9557758509152,16.5197760464564,9.69944226787579,19.6063614953716,5.57193737889914,2.32827243784935,-2.62534482032862,5.06233183679175,9.54352411713271,26.1166120582753,16.1114766645423,5.22397298484664,4.04828375033874,11.1319420888164,-14.8846938678716,9.34075650009586,10.8904165546188,4.60211287223272,7.71549636217822,24.5435833265506,18.3072638487508,15.2537095109404,26.1080711805042,5.03151755398127,15.550752477405,3.8209282160039,17.6013422688369,6.65851735245289,9.96347004413828,-7.34488049377218,13.9279375742979,1.99331842789121,2.88970820313194,-0.0301715953431465,15.2697828232189,19.0617733067892,5.82745555825996,15.0081983743269,21.2983716876694,3.29986479103347,9.53134924116424,-4.67231198283632,6.00900954306903,10.8285895151553,15.2726177980438,7.12600775510276,9.07696834975252,18.2380765306437,21.1151103951816,4.76377362967041,5.04455063161645,5.26533853853586,14.2994972022179,3.86809642602708,1.0446777804525,9.59281102253685,-8.29738932594821,13.5826304329133,14.7376547217819,3.05031565691513,7.98794931088993,17.5034334805329,6.47989420386708,3.68009646640273,5.47759503749657,24.8704929735895,5.42135339213442,9.81047159923884,16.7858401765049,16.2230660750126,2.76986635385302,16.7771268421683,15.7770201879421,10.3679643272546,-5.43164003099461,6.43473496229707,16.0277144866465,9.76073192072653,17.4035164291334,7.1369388793152,-2.02159462761094,16.6902300739988,2.91087523102326,7.78125618454871,-1.44815484282016,11.0949437168151,13.9301612395164,7.220664850071,16.5492574163678,5.60091861917362,-4.8999870433491,12.9843663069953,11.1239713509326,1.91596944079503,1.21081930745112,-7.45251317066725,-4.75203882072058,7.67298824485507,10.3159925602302,23.1356610029829,17.773450537946,9.91347673631213,6.53803844415817,11.5271562332866,15.3625108842063,11.3239897032335,9.82314728352872,20.8947751219629,10.4990619605362,9.9192972687458,10.9763915397566,15.8043874102771,2.60918845574428,3.53804921688478,8.02198701957764,-4.97107356900057,3.3400345364001,9.76257858085091,8.56917148244616,21.222035058215,-2.95129202369125,12.7225766877541,-1.05337432088759,3.43903995375922,5.35974797153939,15.0662098032626,-0.446681526249851,1.96027415142439,18.5380781352513,15.9389578793377,6.62211976463319,20.7115966038721,5.94703490514281,7.39492633144605,14.1357217868164,16.5338169477465],"y":[14.8454240687677,38.6479111572129,18.4241780477619,27.9820207198267,27.5296917947962,26.107029740531,26.2660781678157,18.89386554451,29.0057253176758,27.007216473745,19.3841828733679,17.0747474104175,16.0904944027778,14.0375141724286,16.2343497083214,26.8921903896722,22.9095287013953,13.4870004590222,16.8265505347012,24.4428089601387,28.7064234851855,18.2351230926102,31.269692706011,18.8726134052436,13.596014873,18.2231809718818,30.903871038558,5.59654200624372,26.453143717033,23.4296261665697,20.4995902077396,32.5929794269777,26.0664834394621,33.1286458820489,8.81532348765904,29.1612512188615,6.53890500686241,18.4806449116511,36.3533380737719,15.2687842853028,28.6784126935281,25.3680154411424,16.6188682168665,13.8303228241163,11.8130066279678,28.0765048555705,23.7065502150609,4.01071416808041,33.2583986982454,25.9819785560723,20.9474481060007,22.9928940410797,15.4144025606279,22.6142638775408,39.5073028054965,22.6737876308516,15.0588649607263,22.4859006766888,16.6984545969947,30.2220445282613,33.7337080950809,4.53165086211303,21.0480583711372,18.7498134051173,17.9489191119341,36.649670567532,25.7760088907629,29.6849159500177,13.0565101364656,21.2147528404105,4.40049612741694,15.4900969703636,7.14580040733317,40.8581891610313,17.8544109086651,14.5837209402565,5.61108586282781,33.884845245252,1.65415738247369,16.2541849893476,13.8179343743042,16.9729040679431,10.1099127375262,26.9702928037669,12.0677376888442,20.2664791093315,38.057768337496,17.0618037857254,14.2516264573781,18.5846596161481,8.29823573668833,18.7888556963307,32.6452659008646,9.30109462062542,38.8894691017058,21.5209065209183,21.664485649476,21.7811014736065,35.6540436306368,19.69809846442,15.6452345274945,26.8724419169248,28.6622833186873,-6.48637732396124,7.93311493505778,17.0676464289407,12.4823953769178,18.0658586534466,26.0437535505205,33.3079838396495,7.72838593529862,26.4936874063467,12.4175641630319,10.457184387557,6.58221739718467,12.3032717636455,27.8660702392732,13.8611134511468,25.9288426587295,18.7756122533866,-2.57610651459562,12.8797592133835,26.5509535061153,15.8105952678582,19.0044252231672,32.625057905308,22.8967486641655,12.0428674086541,15.9580115520365,42.9285096479483,20.7298421484356,7.9473632023582,20.3235090518943,40.1540644044725,25.0662688774547,25.7945788363524,29.2247679021804,11.3073836201315,2.5480178453364,10.6189230467636,23.017996024539,10.7755187484522,21.342124326959,23.2457527995255,32.9873915928216,29.8952960528425,16.8999986516766,31.1111768336401,15.0196776594506,20.4918395287291,21.5387920731414,6.8590880595842,28.8117587076365,9.51447660902242,14.1340359980963,35.6678949733369,17.2619642476858,21.2066778585596,26.5165590835128,9.20454626143601,1.21779012533228,13.6140535484282,18.9359755969044,28.7837200590983,19.6458982389887,30.9650003478774,13.6833287977278,17.8212331484901,10.2863673225246,19.8412206901748,15.9757513504558,32.4733828950848,29.6451289913857,18.7492120072702,12.5271257881239,14.1817293070405,23.1609924820634,18.5136353557768,11.9415398314614,10.820603544703,16.6271174491801,29.2342237953097,30.8557895436737,23.6492560806648,6.2340037017683,20.8231482415547,11.9380796501394,20.5802097424406,18.3123154211489,29.5044746594115,5.40529395425686,4.00130907414241,13.5902229879743,24.2780989724243,21.3329761631248,36.5974084023125,19.2165307860635,11.7979535132849,25.906938018836,18.5865836937611],"z":[35.1574107084982,52.5824560084806,38.0762329135636,25.2412361586535,35.1682107562361,57.823814520172,37.9366274009068,31.4753437371447,25.9279871887231,29.7067114398061,20.2186174504165,25.9255712434871,29.3034999843628,21.7620729032747,38.3205367667264,31.3246313582241,29.8068785219177,11.8245505368642,33.6029975407276,38.7818985282085,45.6618259629519,32.2165723399461,28.6476349546068,42.9580478069909,29.4645668693006,11.3945307942057,39.8549066438416,27.5082427053793,34.935657582715,19.5455143975022,39.7510174713845,46.4271521723948,28.0527010365186,38.3542136275491,21.8026281076198,36.8235181754729,25.9978315879967,22.4805979596157,46.1500757799059,32.8420168978795,45.2500917924137,45.5291719106615,40.3765814601253,26.6738799184504,25.6515636410288,31.403089691453,31.4673537465325,19.4801779324264,42.6291661966096,32.3497717759798,34.7058985798725,28.0261884466357,17.5022029058542,38.7159520363321,45.5099360281156,23.1338128055605,22.8576220650727,19.4769769061726,4.91434104633759,47.2020820850481,33.3377375254768,7.82030586530336,46.8700411152846,26.3831723073113,21.3406542827375,46.7399369719101,39.1113211356451,40.9241791778093,16.6858628832661,44.7758117671366,22.2821071297248,32.7775793661389,20.8703283511115,43.1783230653652,29.1414840813838,30.596322351612,18.194317874807,57.4577120154815,30.1918399588784,22.6448787294199,32.1203931845268,21.088755384345,17.3545705560566,19.9593513429242,17.8067227668577,16.8165675079947,33.9619443022255,31.2957029326671,19.7413708644309,30.8052656094226,2.81087380537066,34.9487850120975,44.1250402922528,21.0966889737133,43.5086089070478,40.3141205802052,28.8642520613636,35.1048138731569,49.5819716316054,17.7651676547098,23.7732226968938,46.4561565266756,28.1882877358276,7.77844805607118,24.8144774945062,31.984484174401,33.0895460675104,29.2189295853648,30.8808305896181,40.5978009887143,17.9569139306589,28.512197020713,20.1140251723887,15.5387776884549,15.2127009576235,22.6163479082593,25.0376424261041,27.3013703171096,42.0095826611902,26.9637017527452,16.6246870490028,25.7837580527434,37.0095237532768,36.5500628314497,30.7645092298724,43.2654414807518,33.4895297001614,34.0052440012026,32.3409824068008,40.3868127638559,38.4455860828003,16.9677348557177,30.4793137349131,50.1742967487693,29.1530237043411,38.4288987225382,25.0172096091982,25.1905939661069,23.0643187628059,9.80449251481853,32.9830417697017,30.806375523155,31.3512945829918,39.995496413109,52.4023722349221,34.5975966215076,31.4017718372988,47.0244060555172,20.1647319379699,32.618983968552,25.3385492179053,16.7859536996743,37.0972827147824,14.3293893105086,40.2495610005006,47.0653060967903,35.1511343522224,44.7236840468975,48.0391056238615,25.9003714407301,19.1063562122109,19.8530117863292,29.1225783768293,26.4876036148393,12.9210287861878,40.7314002689774,24.2296241876654,31.0207454086179,5.06228152881263,31.1631079315555,23.5410915039134,32.3625732073344,41.0959604205197,26.4024382900168,12.9019134664859,21.8484923042414,25.0080960129943,38.1728359673731,29.2056014317355,33.4932856876762,31.7140734299172,41.1684179751794,40.0789442210135,19.5703210046787,26.2665807985231,29.251097445612,27.3515418088464,34.7707729697386,36.5628887228531,35.9191394954038,36.1315431486532,18.9939934391609,16.6254182222704,25.7703869007354,22.8486025824718,33.6672103296585,24.1076657331662,26.5952789425033,44.221132838068,24.203697606676],"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"type":"scatter3d","mode":"markers","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

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
## [1] 0.06928972
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
## [1] 0.6622
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
## [1] 0.7603
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

