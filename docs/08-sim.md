
# Probability & Simulation {#sim}

## Learning Objectives

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

## Resources

* [Chapter 21: Iteration](http://r4ds.had.co.nz/iteration.html)  of *R for Data Science*
* [Improving your statistical inferences](https://www.coursera.org/learn/statistical-inferences/) on Coursera (week 1)


## Distributions

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
##  [1] 0.1594836 0.4781883 0.7647987 0.7696877 0.2685485 0.6730459 0.9787908
##  [8] 0.8463270 0.8566562 0.4451601
```

#### Sample discrete distribution

`sample(x, size, replace = FALSE, prob = NULL)`

Use `sample()` to sample from a discrete distribution.

Simulate a single roll of a 6-sided die.

```r
sample(6, 1)
```

```
## [1] 5
```

Simulate 10 rolls of a 6-sided die. Set `replace` to `TRUE` so each roll is 
independent. See what happens if you set `replace` to `FALSE`.

```r
sample(6, 10, replace = TRUE)
```

```
##  [1] 6 3 1 4 5 2 3 6 4 6
```

You can also use sample to sample from a list of named outcomes.


```r
pet_types <- c("cat", "dog", "ferret", "bird", "fish")
sample(pet_types, 10, replace = TRUE)
```

```
##  [1] "ferret" "fish"   "bird"   "cat"    "ferret" "bird"   "cat"   
##  [8] "ferret" "cat"    "cat"
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
##  [1] "dog"    "dog"    "dog"    "ferret" "ferret" "cat"    "ferret"
##  [8] "cat"    "ferret" "dog"
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
##  [1] 0 0 1 0 1 0 1 1 1 1 1 1 0 0 0 1 1 1 0 1
```

20 individual coin flips of a baised (0.75) coin

```r
rbinom(20, 1, 0.75)
```

```
##  [1] 1 1 1 1 1 1 1 0 1 1 0 1 1 1 1 1 1 0 1 1
```

You can generate the total number of heads in 1 set of 20 coin flips by setting 
`size` to 20 and `n` to 1.

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
##  [1]  8 10 11 10  6 10  9  8  7  5
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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/sim_flips-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:sim_flips)**CAPTION THIS FIGURE!!**</p>
</div>

<div class="info">
<p>Run the simulation above several times, noting how the histogram changes. Try changing the values of <code>n</code>, <code>size</code>, and <code>prob</code>.</p>
</div>

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
## number of successes = 7, number of trials = 10, p-value = 0.3438
## alternative hypothesis: true probability of success is not equal to 0.5
## 95 percent confidence interval:
##  0.3475471 0.9332605
## sample estimates:
## probability of success 
##                    0.7
```

<div class="info">
<p>Run the code above several times, noting the p-values for the fair and biased coins. Alternatively, you can <a href="https://debruine.shinyapps.io/coinsim/">simulate coin flips</a> online and build up a graph of results and p-values.</p>
<ul>
<li>How does the p-value vary for the fair and biased coins?</li>
<li>What happens to the confidence intervals if you increase n from 10 to 100?</li>
<li>What criterion would you use to tell if the observed data indicate the coin is fair or biased?</li>
<li>How often do you conclude the fair coin is biased (false positives)?</li>
<li>How often do you conclude the biased coin is fair (false negatives)?</li>
</ul>
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
## [1] 0.02097874
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
## [1] 0.4588
```

<div class="info">
<p><code>1e4</code> is just scientific notation for a 1 followed by 4 zeros (<code>10000</code>). When youre running simulations, you usually want to run a lot of them and it’s a pain to keep track of whether you’ve typed 5 or 6 zeros (100000 vs 1000000) and this will change your running time by an order of magnitude.</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/rnorm-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:rnorm)**CAPTION THIS FIGURE!!**</p>
</div>

<div class="info">
<p>Run the simulation above several times, noting how the density plot changes. What do the vertical lines represent? Try changing the values of <code>n</code>, <code>mean</code>, and <code>sd</code>.</p>
</div>

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
## t = 4.2158, df = 99, p-value = 5.507e-05
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  0.2058657 0.5719533
## sample estimates:
## mean of x 
## 0.3889095
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
## t = -1.9196, df = 195.54, p-value = 0.05636
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.520235824  0.007028115
## sample estimates:
## mean of x mean of y 
## 0.3852249 0.6418287
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
##         t 
## -1.919595
```

Alternatively, use `broom::tidy()` to convert the output into a tidy table.


```r
broom::tidy(t_ind)
```

```
## # A tibble: 1 x 10
##   estimate estimate1 estimate2 statistic p.value parameter conf.low
##      <dbl>     <dbl>     <dbl>     <dbl>   <dbl>     <dbl>    <dbl>
## 1   -0.257     0.385     0.642     -1.92  0.0564      196.   -0.520
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
## [1] 0.4973957
```

Now replicate the simulation 1000 times.


```r
my_reps <- replicate(1e4, sim_t_ind(100, 0.7, 1, 0.5, 1))

alpha <- 0.05
power <- mean(my_reps < alpha)
power
```

```
## [1] 0.2938
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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/plot-reps-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:plot-reps)**CAPTION THIS FIGURE!!**</p>
</div>

<div class="try">
<p>What do you think the distribution of p-values is when there is no effect (i.e., the means are identical)? Check this yourself.</p>
</div>

<div class="warning">
<p>Make sure the <code>boundary</code> argument is set to <code>0</code> for p-value histograms. See what happens with a null effect if <code>boundary</code> is not set.</p>
</div>

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
## [1] 0.7039656
```

`cor()` defaults to Pearson's correlations. Set the `method` argument to use 
Kendall or Spearman correlations.


```r
cor(x, y, method = "spearman")
```

```
## [1] 0.6786799
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
## [1,] 1.0000000 0.4709289
## [2,] 0.4709289 1.0000000
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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/graph-bvn-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:graph-bvn)**CAPTION THIS FIGURE!!**</p>
</div>

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
##            [,1]      [,2]       [,3]
## [1,]  1.0000000 0.4145752 -0.1546829
## [2,]  0.4145752 1.0000000  0.6825149
## [3,] -0.1546829 0.6825149  1.0000000
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

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-65195fec4f3edaf36caa" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-65195fec4f3edaf36caa">{"x":{"visdat":{"c0ece314107":["function () ","plotlyVisDat"]},"cur_data":"c0ece314107","attrs":{"c0ece314107":{"x":{},"y":{},"z":{},"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d","mode":"markers","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"V1"},"yaxis":{"title":"V2"},"zaxis":{"title":"V3"}},"hovermode":"closest","showlegend":false},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[15.0818863464403,17.8485163905139,2.42424171288625,-2.25735532102147,26.706928162775,9.04098112791577,7.48311605388697,11.320962382747,8.91195796084032,19.6860431552736,4.81689848284851,-6.01801362829483,21.9777687834598,-2.42529826451902,9.10138114467561,8.89024495944634,-1.07720958607195,10.5256663377068,-3.78773627372285,21.8246387953009,16.7789274432382,10.564398548303,-1.57831664020333,11.8057462941615,16.2139804723132,18.2423976998065,19.6059728466804,8.3879089331999,4.335295842176,18.4367380427685,1.24574998985208,8.82928577129901,14.3962507473857,15.1818407777961,12.427732053677,23.9991073804642,19.3925027488791,-2.42772246959762,10.273546281279,8.49542920038718,11.9923169335278,12.1124480320168,-8.86491756604355,15.2107079505599,16.2930298586203,8.29693097604363,8.81958533517828,7.48398167210688,-2.14918333729162,11.8198311389023,18.6075685883252,25.1428626954037,-3.83530877489615,0.101549522257814,4.30010599076112,8.50097846970563,24.46564435237,5.73216523504048,12.2072714626111,15.4580559438534,22.5038670237314,19.2753866119721,11.53812951169,8.86247422502119,10.1538466509245,7.15277216174504,8.55244735665743,6.93784898537896,5.48815073193964,11.5547149430447,12.5925476107901,12.8634119899524,-6.06496421736628,8.52425829862813,16.2439316875033,20.5640781987319,13.4296274849424,5.1778631224779,16.3171073824993,13.6329881159556,0.693868109167411,23.1563515066898,-3.00269822133391,10.7657711663239,3.34561688150428,20.9424389185875,24.2074998663315,12.3166506089964,20.1135767848055,-1.0461965896547,9.05412836752497,0.514328778734297,4.95556873791952,27.8715995558333,11.10454980226,17.4257653301846,16.0133451678628,14.0761389554257,3.93670867332264,2.16873546585061,13.6392686973322,8.75683630504061,-1.28321037490854,21.3344099721606,12.0618061332867,8.07444185563229,15.5560580883997,5.74026182767639,18.0385425121644,28.5118896361281,0.997646309851673,6.21055705574727,9.72878544048185,0.730581332118192,23.9914036878263,19.7293269376907,-4.22529495815242,13.7793866643686,12.1854684783987,7.60753257829372,21.9976030060433,12.1462783231691,16.0242918840948,6.98347380998409,12.2053951140362,-4.57382765272069,10.4551939234258,-0.0413676520961364,19.6833645914882,10.418436828852,11.5620397041742,-0.941284027598456,25.0231215955247,6.59808867075446,6.42218285597104,10.20033557383,6.14912747861963,6.45061829087009,8.38629450201858,4.84619014556189,-0.324758241993559,19.2840465138907,5.89249584381064,0.839619592597334,9.12955873157689,-3.57057859763231,11.0492478648172,23.1452976758436,4.49205329449674,22.5304268549248,16.227900607486,17.8447308870425,14.9582314647619,22.9643527774362,4.4772903927097,7.77729527528257,21.3121528028561,14.3844973812482,-12.5557588479551,7.69784627801025,15.3142819456261,5.9661248167039,12.3081405159121,15.7173624411485,18.1208885640119,1.86375388739738,16.9279148713015,3.98301266038539,3.0821227331787,1.78825268326931,5.08317427504593,13.9023393324864,5.628656998197,14.5941776168993,4.37367584706786,-0.533268991502512,3.94228972127292,15.4430911176834,11.9291888926573,4.14018639954143,16.6564859604415,13.3031755994419,9.09554683797603,11.7885789800576,22.4248895223528,12.9565377819003,-5.11863786493767,11.6300581256788,23.5154939891208,9.6478674504384,12.4764309846151,14.7581974273566,2.62285420368873,-2.25044962679058,1.3471533958101,15.3511668806125,1.16376660132649,12.7787591320277,17.5941822023168,22.9601056583783],"y":[33.1258725232621,36.8477515667173,8.68523225492388,14.9136784480665,23.4104727292319,21.1998160426576,18.2634994361814,21.4219423058864,5.75403167922016,25.7872272013851,26.3834180756733,1.03904375828748,26.5305464788665,9.33803010865262,15.8859806982239,14.9634223821678,12.6404393702145,20.4719769585787,13.8574901136358,20.1456161955032,28.275075151782,12.0402373588867,19.3187035349848,14.6937556915072,31.7889220519326,21.3667956066573,13.9657764929709,18.2138066736942,12.1178891544343,31.2273135615528,15.8380988115675,19.5625157653846,22.0785938584251,19.5465635325098,22.6541513206671,22.5340783650312,29.8768157156664,12.6909119302889,22.7049695449761,-2.47809311228125,27.9387270218164,10.6413873339529,14.6441831744459,21.6719574446342,26.0377653959233,14.9858075423462,11.1008395750606,21.86811620795,10.9135061330658,29.4959269409507,37.4043457036599,12.7302018313744,14.8298681541443,15.5981177102185,7.83627631930425,9.78637498628681,13.4976069563306,-4.15329310056815,28.7703324655723,23.6675386231705,6.53145370891432,27.6617657288579,25.6510696798856,19.8457876442024,16.1086062625101,25.3120747941445,26.3173528648447,15.0334172846287,23.197600431258,11.2994087774894,21.5805778265358,25.5212179147589,8.38112991065532,14.2428325780842,23.4172088590635,19.7418951436264,26.3234659366059,3.5582146472285,17.3004163551273,28.8840713134848,23.6142011439449,32.5501580997827,-6.53356130335877,10.4058536225434,16.5313943662464,33.2119199076525,24.8372598293727,24.7124016505125,27.5812465065753,5.94193446099381,1.82511701743847,5.66193819242338,18.8969176805236,35.7872853327605,19.4613902687303,12.7596804240321,8.7108882476553,16.1142760619063,13.4674719635332,7.81873366580319,21.1939512899834,13.0143819722408,13.0552800650834,26.0186375019302,17.551458106889,7.92282801292067,35.9760116482503,29.9692250821353,29.3095445990848,39.3120442133773,3.48113098791266,22.5271297724253,36.8207487583027,33.0454399672366,24.5819907767137,34.6505604514112,22.004958081597,4.23252231266419,34.3307450090233,27.8565811203418,19.0735743033448,8.96289736966839,17.1870543353117,33.7508638015363,2.4187532464328,-0.993157514503363,19.192122888247,14.9655599976825,17.7148961559206,25.871269752097,25.843943598696,15.548909207346,12.905199881312,16.1940937883378,22.9984384072848,22.5443927001594,22.3059402068165,34.3070929812936,28.8743796304687,31.3910351179777,11.8110180824938,31.2525913540691,7.82231599183478,15.5232908067367,15.6199302550672,31.8323947354165,15.8951782171502,26.5431982412297,19.684088143228,22.3798259931078,18.9043141159653,38.9736211171114,21.7354036884639,18.1312965947492,25.0282804429979,24.3995036843152,24.4095430647627,31.4201244180732,7.39658831744545,29.716164427036,28.924977108395,9.30730551484841,28.9440112196985,31.3138250787403,16.4810824357515,23.435109350297,38.4007899758197,26.6001364281477,26.5458847064713,26.5031274399226,21.0695425214176,32.7270232197033,14.5478979037607,8.6416628426709,9.85586661628592,20.8482461554516,15.9911877259169,21.7000914315406,17.1148018753901,3.37370393804349,12.8241413757412,20.7919360452422,16.00250091658,23.1388316760568,26.8951802788343,14.3977274881413,6.17904354208777,25.6760838983378,15.7620845285039,14.0863469936865,13.0627109939754,34.5137333611979,13.3920955248232,4.6235680739229,30.1213332032423,29.9748395905896,2.05600483533249,27.0065836256752,23.3820364280511,10.6446365904731],"z":[37.4601456353523,47.6290705396571,11.4643192407805,41.5736892998106,17.4132177442986,33.2687002733345,39.8894490880368,24.1157975899611,21.1201412159788,29.0592879117603,31.7100670134697,17.7022479167546,22.836900828755,19.1725013699563,32.7311246221172,36.6200472594002,36.648951856074,30.8160901779797,31.1013669615409,24.2286210884058,27.259876289389,23.1002744671952,40.3858332042942,32.7558979833803,40.029710984094,27.8180132657382,5.54014817234513,21.4600488706652,26.1650858990458,46.4875638403797,36.8896473100584,32.2181735632706,27.0449043942271,27.7795319839533,35.3286203461956,21.51837143529,27.4640161022832,24.3201911355663,34.6177811547123,7.8329894800413,38.8606517103579,20.1114542754713,39.542962016208,26.1147229809745,26.1991272320058,28.8751362421922,29.4293630749582,41.1328954591802,28.198880807438,44.2091717806706,37.5158392572898,8.19364216235107,40.5677401642579,25.4519181733674,20.1786686823977,26.0869615459061,13.979435931057,9.5270104294024,32.2773741178446,27.2644267364541,18.1502965002491,37.328455701823,31.7597289540551,19.6068929234724,22.0624300452613,38.1046287261356,34.1761346203869,27.6222327452446,37.3241294582789,28.9463981538685,25.9239625957373,34.9080313874188,19.4407077687391,23.8286580271905,27.5735947630064,25.6937132905951,39.0660675631737,3.07900544784756,31.105825946319,52.5653750527605,33.1791223063918,39.3003992955263,18.4552692966046,16.9151912076447,21.4572008709554,46.6798758893924,30.4368789459688,31.8322162458234,28.6831693303144,27.5206177297746,5.63586388828554,28.5596424610769,28.5049331005882,34.3728575909762,36.4304099303031,17.0764378638534,18.1483988582397,31.7156594165599,25.2294424387438,26.5914610914699,28.625059958036,19.1447008365416,35.5901002746332,24.8093761474697,25.1387117370036,16.2352184227194,44.4882181112142,42.0040487593238,35.1245792965563,31.3138927172216,11.8635040765704,36.658841897137,39.0807082243182,45.3159012980193,31.7707290075442,33.4264500892667,43.5732485689659,15.0512626073976,41.5052902531721,38.3364169245727,16.6903602462871,15.2484777296129,16.6466038070921,51.0339054328861,13.8193878391565,22.3716120716912,33.5092097977174,31.4495632715793,8.62042763434349,33.8687600095657,40.9747461966139,35.9328034117815,13.3271344438071,47.3623727698875,35.8162173903266,34.6726489061033,37.4720881039985,51.6840992364653,29.3771167769663,42.0524690774678,19.7547518001655,24.8646219996349,21.1007554603858,25.8173742586242,29.2820734282918,45.9562952335807,27.5639484714428,30.0093301007241,44.4904192550984,20.8677973353152,31.5152419054056,53.0277371925751,35.9407711742365,16.5414516679421,31.6784125295044,39.32555015897,27.3641906379365,32.2631930665374,34.0734168680632,46.1527835601368,48.2958129719647,23.9524011888356,39.8175415483022,36.2740249746929,21.0646215094163,40.5726707111566,42.115252862686,35.1670983781156,45.1802732398571,46.7037694917099,37.713377519472,38.0333618606659,30.5263837804278,19.2199375299199,20.4398604462873,51.8164795237602,27.388279587076,25.7137182880141,31.9219845674518,14.0684146939901,11.714346439734,31.1254767241607,32.3040065553872,37.2477923883052,18.2452448153297,25.4866735711864,22.1455133973114,32.1001760917688,11.5372540274621,25.5770770075716,15.787753077821,38.5168397811715,27.1401635115755,30.4808626813945,48.4919977501569,35.5881789274386,15.3201803794968,32.6323251955889,32.7103865688055,18.8997843105772],"marker":{"color":"#ff0000","line":{"color":"#444","width":1},"opacity":0.5,"size":5},"type":"scatter3d","mode":"markers","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:3d-graph-mvn)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/plot-height-means-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:plot-height-means)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/sim-height-20-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:sim-height-20)**CAPTION THIS FIGURE!!**</p>
</div>

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
## [1] 0.003009548
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
## [1] 0.6435
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
## [1] 0.7605
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

<div class="figure" style="text-align: center">
<img src="08-sim_files/figure-html/range-sample-sizes-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:range-sample-sizes)**CAPTION THIS FIGURE!!**</p>
</div>

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

