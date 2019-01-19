# Data Visualisation {#ggplot}

## Learning Objectives

### Basic

1. Understand what types of graphs are best for [different types of data](#vartypes)
    + 1 discrete
    + 1 continuous
    + 2 discrete
    + 2 continuous
    + 1 discrete, 1 continuous
    + 3 continuous
2. Create common types of graphs with ggplot2
    + [`geom_bar()`](#geom_bar)
    + [`geom_density()`](#geom_density)
    + [`geom_freqpoly()`](#geom_freqpoly)
    + [`geom_histogram()`](#geom_histogram)
    + [`geom_violin()`](#geom_violin)
    + [`geom_boxplot()`](#geom_boxplot)
    + [`geom_col()`](#geom_col)
    + [`geom_point()`](#geom_point)
    + [`geom_smooth()`](#geom_smooth)
3. Set custom labels
4. [Save plots](#ggsave) as an image file
    
### Intermediate

5. Represent factorial designs with different colours or facets
6. Superimpose different types of graphs
7. Add lines to graphs
8. Create less common types of graphs
    + [`geom_tile()`](#geom_tile)
    + [`geom_density2d()`](#geom_density2d)
    + [`geom_bin2d()`](#geom_bin2d)
    + [`geom_hex()`](#geom_hex)
    + [`geom_count()`](#geom_count)
9. Deal with [overlapping data](#overlap)
10. Use the [`viridis`](#viridis) package to set colours

### Advanced

11. Arrange plots in a grid using [`cowplot`](#cowplot)
12. Adjust axes (e.g., flip coordinates, set axis limits)
13. Change the [theme](#theme)
14. Create interactive graphs with [`plotly`](#plotly)


## Resources

* [Look at Data](http://socviz.co/look-at-data.html) from [Data Vizualization for Social Science](http://socviz.co/)
* [Chapter 3: Data Visualisation](http://r4ds.had.co.nz/data-visualisation.html) of *R for Data Science*
* [Chapter 28: Graphics for communication](http://r4ds.had.co.nz/graphics-for-communication.html) of *R for Data Science*
* [ggplot2 cheat sheet](https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf)
* [ggplot2 documentation](http://ggplot2.tidyverse.org/reference/)
* [The R Graph Gallery](http://www.r-graph-gallery.com/) (this is really useful)
* [Top 50 ggplot2 Visualizations](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html)
* [R Graphics Cookbook](http://www.cookbook-r.com/Graphs/) by Winston Chang
* [The viridis color palettes](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html)
* [ggplot extensions](https://www.ggplot2-exts.org/)
* [plotly](https://plot.ly/ggplot2/) for creating interactive graphs


## Setup


```r
# libraries needed for these graphs
library(tidyverse)
library(viridis)
library(plotly)

# cowplot will change the default theme of graphs, so we're loading it later
# library(cowplot) 
```

## Common Variable Combinations {#vartypes}

* 1 discrete
* 1 continuous
* 2 discrete
* 2 continuous
* 1 discrete, 1 continuous
* 3 continuous

<div class="try">
<p>Before you read ahead, come up with an example of each type of variable combination and sketch the types of graphs that would best display these data.</p>
</div>

## Data

Here we've created some data frames with different types of data. 

* `pets` has a column with pet type
* `demog` has `height` and `age` for 500 men and 500 women.
* `x_vs_y` has two correlated continuous variables (`x` and `y`)
* `overlap` has two correlated ordinal variables and 1000 observations so there is a lot of overlap
* `overplot` has two correlated continuous variables and 10000 observations



```r
pets <- tibble(
  pet = sample(
    c("dog", "cat", "ferret", "bird", "fish"), 
    100, 
    TRUE, 
    c(0.45, 0.40, 0.05, 0.05, 0.05)
  )
)

demog <- tibble(
  sex = rep(c("male", "female"), each = 500),
  height = c(rnorm(500, 70, 4), rnorm(500, 65, 3.5)),
  age = rpois(1000, 3) + 20
)

x_vs_y <- tibble(
  x = rnorm(100),
  y = x + rnorm(100, 0, 0.5)
)

overlap <- tibble(
  x = rbinom(1000, 10, 0.5),
  y = x + rbinom(1000, 20, 0.5)
)

overplot <- tibble(
  x = rnorm(10000),
  y = x + rnorm(10000, 0, 0.5)
)
```

First, think about what kinds of graphs are best for representing these different types of data.

## Basic Plots

### Bar plot {#geom_bar}

Bar plots are good for categorical data where you want to represent the count.


```r
ggplot(pets, aes(pet)) +
  geom_bar()
```

<img src="03-ggplot_files/figure-html/barplot-1.png" width="672" />

### Density plot
<a name="geom_density"></a>
Density plots are good for one continuous variable, but only if you have a fairly 
large number of observations.


```r
ggplot(demog, aes(height)) +
  geom_density()
```

<img src="03-ggplot_files/figure-html/density-1.png" width="672" />

You can represent subsets of a variable by assigning the category variable to 
the argument `group`, `fill`, or `color`. 


```r
ggplot(demog, aes(height, fill = sex)) +
  geom_density(alpha = 0.5)
```

<img src="03-ggplot_files/figure-html/density-sex-1.png" width="672" />

<div class="try">
<p>Try changing the <code>alpha</code> argument to figure out what it does.</p>
</div>

### Frequency Polygons {#geom_freqpoly}

If you don't want smoothed distributions, try `geom_freqpoly()`.


```r
ggplot(demog, aes(height, color = sex)) +
  geom_freqpoly(binwidth = 1)
```

<img src="03-ggplot_files/figure-html/freqpoly-1.png" width="672" />

<div class="try">
<p>Try changing the <code>binwidth</code> argument to 5 and 0.1. How do you figure out the right value?</p>
</div>

### Histogram {#geom_histogram}

Histograms are also good for one continuous variable, and work well if you don't 
have many observations. Set the `binwidth` to control how wide each bar is.


```r
ggplot(demog, aes(height)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black")
```

<img src="03-ggplot_files/figure-html/histogram-1.png" width="672" />

If you show grouped histograms, you also probably want to change the default 
`position` argument.


```r
ggplot(demog, aes(height, fill=sex)) +
  geom_histogram(binwidth = 1, alpha = 0.5, position = "dodge")
```

<img src="03-ggplot_files/figure-html/histogram-sex-1.png" width="672" />

<div class="try">
<p>Try changing the <code>position</code> argument to &quot;identity&quot;, &quot;fill&quot;, &quot;dodge&quot;, or &quot;stack&quot;.</p>
</div>

### Column plot {#geom_col}

Column plots are the worst way to represent grouped continuous data, but also 
one of the most common.

To make column plots with error bars, you first need to calculate the means, 
error bar uper limits (`ymax`) and error bar lower limits (`ymin`) for each 
category. You'll learn more about how to use the code below in the next two lessons.


```r
# calculate mean and SD for each sex
demog %>%
  group_by(sex) %>%
  summarise(
    mean = mean(height),
    sd = sd(height)
  ) %>%
ggplot(aes(sex, mean, fill=sex)) +
  geom_col(alpha = 0.5) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.25) +
  geom_hline(yintercept = 40)
```

<img src="03-ggplot_files/figure-html/colplot-1.png" width="672" />

<div class="try">
<p>What do you think <code>geom_hline()</code> does?</p>
</div>

### Boxplot {#geom_boxplot}

Boxplots are great for representing the distribution of grouped continuous 
variables. They fix most of the problems with using barplots for continuous data.


```r
ggplot(demog, aes(sex, height, fill=sex)) +
  geom_boxplot(alpha = 0.5)
```

<img src="03-ggplot_files/figure-html/boxplot-1.png" width="672" />

### Violin plot {#geom_violin}

Violin pots are like sideways, mirrored density plots. They give even more information 
than a boxplot about distribution and are especially useful when you have non-normal 
distributions.


```r
ggplot(demog, aes(sex, height, fill=sex)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.25, 0.5, 0.75), 
    alpha = 0.5
  )
```

<img src="03-ggplot_files/figure-html/violin-1.png" width="672" />

<div class="try">
<p>Try changing the numbers in the <code>draw_quantiles</code> argument.</p>
</div>


```r
ggplot(demog, aes(sex, height, fill=sex)) +
  geom_violin(
    trim = FALSE,
    alpha = 0.5
  ) +
  stat_summary(
    fun.data = function(x) {
      m <- mean(x)
      sd <- sd(x)
      
      c(y    = m,
        ymin = m - sd,
        ymax = m + sd)
    }, 
    geom="pointrange")
```

<img src="03-ggplot_files/figure-html/stat-summary-1.png" width="672" />

### Scatter plot {#geom_point}

Scatter plots are a good way to represent the relationship between two continuous variables.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_point()
```

<img src="03-ggplot_files/figure-html/scatter-1.png" width="672" />

### Line graph {#geom_smooth}

You often want to represent the relationship as a single line.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_smooth(method="lm")
```

<img src="03-ggplot_files/figure-html/line-1.png" width="672" />
 
 
## Save as File
<a name="ggsave"></a>
You can save a ggplot using `ggsave()`. It saves the last ggplot you made, 
by default, but you can specify which plot you want to save if you assigned that 
plot to a variable.

You can set the `width` and `height` of your plot. The default units are inches, 
but you can change the `units` argument to "in", "cm", or "mm".



```r
demog_box <- ggplot(demog, aes(sex, height, fill=sex)) +
  geom_boxplot(alpha = 0.5)

demog_violin <- ggplot(demog, aes(sex, height, fill=sex)) +
  geom_violin(alpha = 0.5)

ggsave("demog_violin_plot.png", width = 5, height = 7)

ggsave("demog_box_plot.jpg", plot = demog_box, width = 5, height = 7)
```


## Combination Plots

### Violinbox plot

To demonstrate the use of `facet_grid()` for factorial designs, I created a new 
column called `agegroup` to split the data into participants older than the 
meadian age or younger than the median age.


```r
demog %>%
  mutate(agegroup = ifelse(age<median(age), "Younger", "Older")) %>%
  ggplot(aes(sex, height, fill=sex)) +
    geom_violin(trim = FALSE, alpha=0.5, show.legend = FALSE) +
    geom_boxplot(width = 0.25, fill="white") +
    facet_grid(.~agegroup) +
    scale_fill_manual(values = c("orange", "green"))
```

<img src="03-ggplot_files/figure-html/violinbox-1.png" width="672" />

<div class="info">
<p>Set the <code>show.legend</code> argument to <code>FALSE</code> to hide the legend. We do this here because the x-axis already labels the sexes.</p>
</div>

### Violin-jitter plot

If you don't have a lot of data points, it's good to represent them individually. 
You can use `geom_point` to do this, setting `position` to "jitter".


```r
demog %>%
  sample_n(50) %>%  # choose 50 random observations from the dataset
  ggplot(aes(sex, height, fill=sex)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.25, 0.5, 0.75), 
    alpha=0.5
  ) + 
  geom_point(position = "jitter", alpha = 0.7, size = 3)
```

<img src="03-ggplot_files/figure-html/violin-jitter-1.png" width="672" />

### Scatter-line graph

If your graph isn't too complicated, it's good to also show the individual data 
points behind the line.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method="lm")
```

<img src="03-ggplot_files/figure-html/scatter_line-1.png" width="672" />

### Grid of plots {#cowplot}

You can use the [ `cowplot`](https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html) 
package to easily make grids of different graphs. First, you have to assign each 
plot a name. Then you list all the plots as the first arguments of `plot_grid()` 
and provide a list of labels.

<div class="info">
<p>{#theme}You can get back the default ggplot theme with <code>+ theme_set(theme_grey())</code>.</p>
</div>


```r
library(cowplot)
```

```
## 
## Attaching package: 'cowplot'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     ggsave
```

```r
my_hist <- ggplot(demog, aes(height, fill=sex)) +
  geom_histogram(
    binwidth = 1, 
    alpha = 0.5, 
    position = "dodge", 
    show.legend = FALSE
  )

my_violin <- ggplot(demog, aes(sex, height, fill=sex)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.5), 
    alpha = 0.5, 
    show.legend = FALSE
  )

my_box <- ggplot(demog, aes(sex, height, fill=sex)) +
  geom_boxplot(alpha=0.5, show.legend = FALSE)

my_density <- ggplot(demog, aes(height, fill=sex)) +
  geom_density(alpha=0.5, show.legend = FALSE)

my_bar <- demog %>%
  group_by(sex) %>%
  summarise(
    mean = mean(height),
    sd = sd(height)
  ) %>%
ggplot(aes(sex, mean, fill=sex)) +
  geom_bar(stat="identity", alpha = 0.5, show.legend = FALSE) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.25)

plot_grid(
  my_violin, 
  my_box, 
  my_density, 
  my_bar, 
  labels = c("A", "B", "C", "D")
)
```

<img src="03-ggplot_files/figure-html/cowplot-1.png" width="672" />

<div class="info">
<p>Once you load the cowplot package, your ggplot default theme will change.</p>
</div>

## Overlapping Data {#overlap}

### Discrete Data 

You can deal with overlapping data points (very common if you're using Likert scales) by reducing the opacity of the points. You need to use trial and error to adjust these so they look right.


```r
ggplot(overlap, aes(x, y)) +
  geom_point(size = 5, alpha = .05) +
  geom_smooth(method="lm")
```

<img src="03-ggplot_files/figure-html/overlap_alpha-1.png" width="672" />

{#geom_coun}
Or you can set the size of the dot proportional to the number of overlapping 
observations using `geom_count()`.


```r
overlap %>%
  ggplot(aes(x, y)) +
  geom_count(color = "#663399")
```

<img src="03-ggplot_files/figure-html/overlap_size-1.png" width="672" />

Alternatively, you can transform your data to create a count column and use the 
count to set the dot colour.


```r
overlap %>%
  group_by(x, y) %>%
  summarise(count = n()) %>%
  ggplot(aes(x, y, color=count)) +
  geom_point(size = 5) +
  scale_color_viridis()
```

<img src="03-ggplot_files/figure-html/overlap_colour-1.png" width="672" />

### Colours {#viridis}

The [viridis package](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html) 
changes the colour themes to be easier to read by people with colourblindness 
and to print better in greyscale. Use `scale_color_viridis()` to set the colour 
palette and `scale_fill_viridis()` to set the fill palette in ggplot. If you need 
discrete (as opposed to continuous) colours, use `scale_color_viridis(discrete=TRUE)` 
or `scale_fill_viridis(discrete=TRUE)` instead. 


<div class="info">
<p>The newest version of <code>ggplot2</code> v3.0.0 has viridis built in. It uses <code>scale_colour_viridis_c()</code> and <code>scale_fill_viridis_c()</code> for continuous variables and <code>scale_colour_viridis_d()</code> and <code>scale_fill_viridis_d()</code> for discrete variables.</p>
</div>

### Continuous Data

Even if the variables are continuous, overplotting might obscure any relationships 
if you have lots of data.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_point()
```

<img src="03-ggplot_files/figure-html/overplot-point-1.png" width="672" />

{#geom_density2d}
Use `geom_density2d()` to create a contour map.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_density2d()
```

<img src="03-ggplot_files/figure-html/density2d-1.png" width="672" />

You can use `stat_density_2d(aes(fill = ..level..), geom = "polygon")` to create 
a heatmap-style density plot. 


```r
overplot %>%
  ggplot(aes(x, y)) + 
  stat_density_2d(aes(fill = ..level..), geom = "polygon") +
  scale_fill_viridis()
```

<img src="03-ggplot_files/figure-html/density2d-fill-1.png" width="672" />


{#geom_bin2d}
Use `geom_bin2d()` to create a rectangular heatmap of bin counts. Set the 
`binwidth` to the x and y dimensions to capture in each box.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_bin2d(binwidth = c(1,1))
```

<img src="03-ggplot_files/figure-html/bin2d-1.png" width="672" />

{#geom_hex}
Use `geomhex()` to create a hexagonal heatmap of bin counts. Adjust the 
`binwidth`, `xlim()`, `ylim()` and/or the figure dimensions to make the hexagons 
more or less stretched.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_hex(binwidth = c(0.25, 0.25))
```

<img src="03-ggplot_files/figure-html/overplot-hex-1.png" width="576" />

## Heat map {#geom_tile}

I've included the code for creating a correlation matrix from a table of variables, 
but you don't need to understand how this is done yet. We'll cover `mutate` and 
`gather` functions in the `dplyr` and `tidyr` lessons.


```r
# generate two sets of correlated variables (a and b)
heatmap <- tibble(
  a1 = rnorm(100),
  b1 = rnorm(100)
) %>% 
mutate(
  a2 = a1 + rnorm(100),
  a3 = a1 + rnorm(100),
  a4 = a1 + rnorm(100),
  b2 = b1 + rnorm(100),
  b3 = b1 + rnorm(100),
  b4 = b1 + rnorm(100)
) %>%
cor() %>% # create the correlation matrix
as.data.frame() %>% # make it a data frame
rownames_to_column(var = "V1") %>% # set rownames as V1
gather("V2", "r", a1:b4) # wide to long (V2)
```

Once you have a correlation matrix in the correct (long) format, it's easy to 
make a heatmap using `geom_tile()`.


```r
ggplot(heatmap, aes(V1, V2, fill=r)) +
  geom_tile() +
  scale_fill_viridis()
```

<img src="03-ggplot_files/figure-html/heatmap-1.png" width="672" />

<div class="info">
<p>The file type is set from the filename suffix, or by specifying the argument <code>device</code>, which can take the following values: &quot;eps&quot;, &quot;ps&quot;, &quot;tex&quot;, &quot;pdf&quot;, &quot;jpeg&quot;, &quot;tiff&quot;, &quot;png&quot;, &quot;bmp&quot;, &quot;svg&quot; or &quot;wmf&quot;.</p>
</div>

## Interactive Plots {#plotly}

You can use the `plotly` package to make interactive graphs. Just assign your 
ggplot to a variable and use the function `ggplotly()`.


```r
demog_plot <- ggplot(demog, aes(age, height, fill=sex)) +
  geom_point(position = position_jitter(width= 0.2, height = 0), size = 2)

ggplotly(demog_plot)
```

<!--html_preserve--><div id="htmlwidget-27c17b1906d0ae34ff4c" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-27c17b1906d0ae34ff4c">{"x":{"data":[{"x":[24.1030626880005,20.8605129294097,23.0312547801994,26.9188619041815,20.8357565011829,19.8572190201841,28.0048463748768,21.8725053057075,22.8167294006795,23.0016691486351,22.8161376477219,20.8887052458711,19.9469397892244,19.8012552573346,22.886881868355,22.0680537210777,23.1716563923284,24.9099842957221,22.094113988243,20.8774350645952,23.16885161018,21.8197908557951,22.168312811479,22.18002940882,21.8470383084379,21.9521970880218,22.9218551721424,20.8456736400723,23.0967181432992,22.8155275890604,27.1219930809923,22.071522865165,20.901302856952,21.1062840176746,23.1901530708186,24.8908955321647,24.0572869247757,24.8852207999676,21.8949284099042,21.9120554801077,25.0922385829501,23.0453671150841,21.097196965199,21.9149486872368,22.1074320938438,24.0307879095897,22.836982169468,21.1826106357388,23.9043340745382,23.8687590885907,26.0171357287094,24.9696128741838,20.8479630956426,24.9270555271767,22.9361088498496,23.0109796840698,22.1024396409281,25.1721362253651,22.9683082339354,23.9227477366105,23.0403172102757,21.1012467813678,21.9481912896037,24.1284801668487,22.1935353444889,20.0601427895017,23.8491463744082,23.8223166264594,23.1032868176699,21.8878685177304,22.0280859149061,24.8932226443663,23.9791230793111,24.1326114519499,23.0383537157439,22.9508997707628,21.9090443526395,23.0062710138038,24.0416281244718,22.8721606144682,21.9848558468744,23.112094707042,22.8786247274838,23.0490901542827,22.8706752521917,24.0653183733113,24.8800973656587,22.1818998880684,21.8330859904178,22.0311815100722,19.8980834996328,21.8076189691201,24.0571867302991,23.1024052054621,23.9444826484658,24.0117554000579,21.0138262280263,24.1769288509153,22.1820496503264,20.8032868960872,24.1604653670453,21.1337753356434,22.1807656778023,22.8912996501662,22.8011224993505,25.0741828990169,23.965486181993,22.8080940120853,23.9284015879035,22.0872491698712,24.9129822674207,20.878559274599,21.8939877709374,21.8729911313392,22.0121731627733,19.8555639497936,23.1110137120821,24.9536832261831,24.9834078640677,23.055224041827,24.0597853312269,23.1845805870369,23.0361100361682,25.8146664533764,25.0204902174883,20.889698521141,20.9010907558724,22.9851677964441,19.9376620765775,20.8747265747748,24.1359056727029,27.9298162461258,23.9748304381967,23.1072488245554,22.9072996152565,24.1182252237573,20.909940408729,20.9659442648292,19.9395332425833,22.9381804049946,21.947439553868,25.9095082368702,20.8950806370005,23.1936334771104,22.1894356702454,21.8563839473762,21.0292787963524,23.1460249292664,22.0507964039221,23.0318109154701,25.0748181733303,23.0746642965823,23.8411843423732,23.0131423016079,22.0355557726696,24.1412620825693,24.837615940813,22.9823362365365,22.0596701555885,21.1514376307838,27.8547265747562,22.9536934264004,24.0391148433089,26.0568538775668,25.8718695798889,21.9437545652501,25.9687554753385,22.0670548235998,24.9262101940811,22.042754556518,23.0128111667,22.8008006457239,23.0712566579692,24.0080834190361,23.0103780037723,20.0219549606554,21.1749318559654,26.1010874391533,22.1831289716996,22.9118154562078,20.1260576063767,22.9143674810417,21.0979482354596,21.0279189281166,23.999369345326,24.8682648068294,23.8030265187845,22.9721881423146,23.9443569207564,21.1474964187481,25.1506366727874,19.8995155686513,21.9153489522636,24.8210267003626,23.1925794446841,25.1226128505543,21.0246412049979,25.855317636393,24.1389127618633,23.8426124279387,21.1152373737656,24.1011387560517,21.8066156145185,25.1659891197458,21.8268161633983,21.8674320875667,21.8082309880294,22.0174245133996,26.0122634711675,21.1680784675293,23.885074605979,23.0157334991731,21.8013764617033,23.9891807596199,23.0241109358147,23.1354942995124,23.1194476506673,22.1688382353634,24.0717147273943,23.8057663025334,22.906647824496,21.0880239852704,23.9244028332643,25.1320907320827,22.9602310962044,21.9528839515522,24.1651875548065,21.963685744442,21.0379463102669,22.1848191423342,23.024697718583,22.932784437947,23.8551952140406,23.1178304000758,25.1399122665636,22.0435538427904,23.0283170538954,21.9007565397769,23.9989708841778,22.9861649355851,22.090134979412,22.8923638085835,22.8987231191248,24.1580782002769,22.1716563370079,22.0264743408188,21.9274204981513,20.961822146643,19.9397980240174,22.0372777768411,24.9341970763169,21.1005430020392,24.8101396235637,22.1448926930316,23.9459695303813,21.0534417347051,23.8883716292679,20.8004571678117,21.9644386575557,20.1535007086582,21.987869663164,24.8052504308522,22.16845541941,25.8451899865642,23.1430473444983,25.1744575222954,22.1202709662728,23.9153827869333,20.0803150800988,26.1111416124739,21.9368330296129,24.1083037043922,25.8763015927747,24.8418515547179,24.8957095215097,22.1402515259571,20.0872911529616,23.8016823728569,21.9921087711118,23.0326143411919,20.0000407590531,24.0080945200287,25.1292076066136,21.0975921043195,21.0414248844609,21.9769336552359,25.166907797195,22.8407473568805,22.9434401738457,20.9568879758939,22.0102507752366,23.1506826804951,19.9792731167749,26.0473944376223,20.8535613839515,21.9956901765428,21.8483363046311,20.04313092269,21.1907791652717,24.8051695381291,26.0341351037845,22.8856189790182,24.1146077603102,23.8337308517657,20.9255548681132,22.8105582437478,23.0305918400176,23.0858136422932,20.8640529227443,23.8837288585491,25.8791646706872,19.9976826364174,19.8578832467087,22.9822229413316,25.0371103236452,22.158823194541,21.8861984762363,22.0465868885629,24.1289572490379,23.8300941056572,21.9755121925846,24.876212862879,21.9794382938184,23.107170592621,24.0732728671283,24.1664396584034,22.1952947455458,23.9356315208599,22.0645045660436,22.0112973879091,20.9595009951852,23.1148511113599,19.8970986383036,20.8501517006196,23.0020010097884,21.9057763772085,21.9486561345868,20.0084226028062,22.0728159078397,25.1113976090215,21.0030115619302,22.8453432397917,22.8999473937787,23.8647588388063,24.1099113618955,23.8714361437596,23.0452712709084,22.0705580507405,22.1515989582986,22.9677567941137,20.8932762470096,23.8456142895855,22.8271734368056,20.885149309691,25.8330573342741,21.1116811082698,21.9430020685308,23.9400709289126,21.0269613791257,20.8197523984127,23.1963619153015,23.0012531553395,23.9391386182979,23.1186575450003,23.9421201920137,23.0683006226085,22.8113320149481,24.1540978298523,22.9855844008736,26.923686024826,21.1804291912355,23.1949145537801,26.1237448089756,22.1720992776565,22.145260455925,21.1194574813358,20.9683475551195,22.9295619085431,21.1583354585804,21.9504129047506,27.1087192394771,21.9425326410681,22.016411038395,24.0261928683147,24.9660850724205,22.9125534281135,23.8582069876604,24.9246568338014,21.9334369439632,20.9775374428369,22.1830193966627,26.9785324412398,23.0944247016683,23.8605209171772,25.1920201249421,21.8028292854317,22.1944856932387,20.8212360840291,21.176362163946,21.9941964423284,27.0643129013479,22.0827894411981,25.9346326920204,25.0169731552713,23.8255402667448,21.0033304643817,21.0902457815595,23.0750324988738,24.0304433329962,23.1410635350272,21.9318423034623,23.8465284835547,24.9017465242185,19.8463236377575,21.1769098149613,23.9591293015517,22.0419014716521,22.0071930412203,24.1936803911813,22.1847634450532,24.8586490886286,19.9498127062805,22.8221005570143,21.948489542678,23.0643898223527,27.0844868993387,25.0240856939927,23.8012875954621,26.0313224993646,21.974354232382,22.9416699879803,23.0655169428326,22.9411150024272,22.172561446391,23.1949219020084,25.021782713756,28.104591031,22.8709166451357,24.0288174567744,22.8485122676939,21.9117898243479,22.8554786051624,26.0174607493915,22.889896494709,23.8970858070068,21.9467082009651,19.8240532777272,22.0915933971293,20.9743308668956,24.0918560340069,25.0374500532635,19.8334773945622,21.0798766074702,19.8186165018007,23.1166740471497,21.9285547150299,23.8293266933411,21.1611509346403,21.9650507911108,23.9539038423449,22.8460822581314,23.0514875640161,19.9133132670075,23.9892583445646,27.0513541663997,22.8205849293619,24.9640441000462,20.9971126496792,22.1800369325094,22.0008573290892,22.8461239892989,24.8815726429224,23.9482505027205,24.0157357032411,24.1207005078904,25.0661089252681,23.1599383141845,22.1411244770512,21.8286786463112,19.8199877809733,20.9930112089962,22.0691321521997,20.9532343002968,26.0641281912103,22.9215030953288,23.0056311204098,21.9830386938527,23.1481759246439,23.8326965684071,25.9570985494182,21.1484819472767,23.9470736370422,24.8102309275419,23.9761398474686,24.8862494441681,23.1870220600627,21.1317394087091,25.1169165411033,24.128813729994,21.0509691296145],"y":[59.0441874143127,68.4518382627156,67.40750856041,70.1528378256936,66.3448523462241,66.0112375012315,61.6285022844077,61.4389526806356,68.4283195300964,60.7812095020629,69.4383313487412,60.3122265280164,70.0728016301015,59.3196594841701,64.4033619223466,67.0451182118992,64.1465197700084,64.5492874121295,63.2655461183991,65.0689840752762,65.860845914951,58.1123935334522,61.8580290156886,65.7767256445447,71.3497756911614,66.1582189746488,66.1641470571738,63.4966322405732,64.9148105396345,63.6122742273839,68.6596308460359,60.1894797577413,66.8042297602444,65.3427589951605,64.764730291256,63.1761688290974,68.9152853028376,66.4168181850037,66.9704223860494,72.2144792545312,66.8848047546424,63.9060038521207,70.1476147444879,69.5909050385843,60.7370913884019,65.9758529513609,66.0844754308505,65.1697247838485,67.9277545205743,66.9952645143977,66.8887687906941,62.8086200733998,75.6716324851977,69.7517504341292,64.357597916289,61.5762438998268,67.9411406860652,66.1860889866561,59.8555814452375,61.2649049255324,67.3846713279061,60.8889808428831,63.2009187506631,69.495098765935,68.8394139354581,62.4635110945598,62.4380240745971,63.9860201989999,70.2823060350251,63.7474202282169,66.0003025431854,59.4438217699922,66.0314102124584,63.8418657052353,64.9659177592737,75.063942414092,64.1261412644843,62.8754444752624,67.3380316956479,64.9781126395296,64.8585837802709,63.0830288425313,61.8971845208357,65.2375124226419,69.1029549491904,63.6997164633309,65.2895956091698,62.9871629582057,68.2901887755958,61.0147304747902,64.8329873101568,66.1004109337229,70.111526138442,64.9083137838234,70.9485187965159,67.1278805533688,66.0079082446553,64.2528825608863,59.7349804564578,64.2839611765226,58.4898766045206,62.635394112442,70.3311996597493,60.3754841086673,59.7861435425264,63.2833002144776,65.5806661541729,70.5797495823765,64.1125834094581,61.7984507084422,62.7754931851893,68.2714460373198,64.0230847030342,65.4234715459105,62.0654746531838,66.9037658027987,65.7071736813053,57.874560994127,69.9089109065115,69.7443938274209,68.0163997821095,68.805350242034,67.5580387838486,67.1975552054398,58.7340876215942,66.9187770439955,70.1579059049556,57.6470541166395,65.8861603070946,61.6930341888625,63.3540989023614,62.1233710769062,65.8793658741389,62.3833153920507,64.9478541945162,71.3561778054656,69.8507628744128,67.461229405146,63.8722912083008,65.8084318355319,61.9143610722257,69.3863014829279,63.549752555745,62.798377358841,64.9647130259076,64.8919422796752,67.03429614316,65.9508514016621,64.2204739540562,70.512712118469,59.1277803587737,64.0812038032144,65.4066317703625,66.8923649760482,67.5502623555692,65.4369813516347,60.8192121149041,60.4879511410585,64.450256128678,61.6575078944787,67.4995865950634,58.9991342140199,61.4367650391169,64.354637075964,62.8614360251896,69.7102070359941,68.8801958153319,58.8152498495192,62.7044847105256,63.6378605861632,58.6284468339176,67.1060956353885,63.2955356985222,67.7506915074492,66.4895493477167,63.915541101097,68.9048206568234,63.1140410767301,67.0833583818903,67.5939214631127,65.3836084125653,65.0435502230145,70.105135129572,64.0612997943756,61.5678517486505,61.3624525073721,65.912280397285,63.1053767869727,64.5736782235329,62.2085206401541,66.1916505949513,59.8279194471248,59.5043918662446,64.7478368374699,64.7739713494271,59.3192295175589,65.8236093249899,74.6359004946834,67.5273819186097,71.0002286758155,63.749520088495,67.5945596980926,63.0848240318112,70.7167966000855,66.1532683139842,71.7802350393644,58.3900826686078,68.2173554490452,64.6630844992647,64.4111931435647,63.0229296335208,63.7715936062657,66.4773281290648,67.3079226332188,60.4846377168724,61.2530483798587,68.8793245033798,65.2904522263774,68.0509095765303,61.1373365589128,68.7300023120615,71.798275327841,62.5451337674948,67.5297383756781,64.8741464994937,61.7380585449628,62.7208185828658,61.7569371728938,65.077302964427,64.836013188055,66.3763733618712,67.6798014589997,59.9396253907033,69.3785653849573,68.916622259741,71.4970452418118,71.2866897105816,59.3211957852773,67.0849071817602,60.3951009161287,70.3746639045939,66.6950918821841,62.8111696296519,65.6605174219203,79.1577836572902,66.8116074150001,65.3555537839318,71.0025300163835,63.2779173505106,66.1842960081152,64.5818028621386,63.4089637423599,73.2092489585096,61.9897593736874,61.4081795808651,60.4228967964251,60.1229575581041,65.153315795355,64.287269117916,64.4170075981624,64.6885513976647,67.866690408814,62.6648063044679,65.8341304019154,64.7105572631973,67.3065677882784,57.6772096606509,60.7334452955781,66.5205767726157,63.8700987916937,67.0669828764693,69.5887043815346,61.7461755549655,64.3968927041811,64.101686270926,65.1842023054788,62.5735618518479,62.805692077224,62.0769349597152,68.6644458818522,67.5732274083903,66.1716701015037,65.0552370368535,65.5979175132731,64.9794591059891,64.1093269268551,67.0290531088119,65.950877124504,69.0878683522968,70.0587176890888,65.0180454080854,65.8959652703076,57.9785892657465,65.6485376686508,64.1199003656189,59.2464632955207,52.8454967570255,65.9000404308201,60.7826358813944,65.4435988554518,67.4056713412992,56.2636698433052,66.9029978948288,68.6576442625534,66.2989923608485,69.046477323355,67.6159673049548,62.4795809732718,64.8098428906307,68.0512260108242,66.1206978029653,63.3450199862801,67.6595572804123,66.5958284762739,66.9021953547268,66.5296576878691,58.5481349756101,67.09218881196,69.5556136954243,62.918084035892,67.5125373832215,62.3195989080574,64.6743525093038,62.8708729592409,70.5762167736417,66.595092129005,64.0810493736079,71.3346977534331,67.8495381338527,68.2836003568066,58.7510837578872,66.4151359688045,67.5110308601459,60.1664458605373,61.141133218126,65.1222500312332,62.0434465915881,63.5802845608916,62.8669954715791,62.0248620693399,63.5783822416505,72.0840044212511,64.0861540167988,65.5781442371952,62.846205697386,65.460278073626,64.9153524864841,68.0444844825236,69.8791537456732,67.1444836839665,68.5018005716884,69.3371183607021,63.5112384637192,67.1598150287575,69.7891263907381,71.8425717592576,68.3258566201198,67.5590296287442,65.8242052512145,61.4858979984228,62.0376629810709,67.3841158624593,63.9696668212489,63.5569056841244,63.8189842330537,62.0651254431667,70.6757799347692,67.2042971237509,66.6605296122771,64.0700517140428,59.442943998324,64.6507790089042,62.5061574290037,59.38515305839,63.5628368685454,61.932303040753,63.5689812615038,66.3327091912186,60.6555784991761,62.9585763942113,58.9213107174656,58.3804590568808,61.7462745959826,60.1214666655025,63.730443435302,64.3111849022705,64.6023943040378,68.2149014117511,63.0312803352533,71.7902443654928,67.9014581157616,74.420637924102,65.6581249220926,65.9823277191825,64.4167299384163,68.1263522372181,64.5076980569829,72.9384960316936,68.8508908255086,64.6846259433022,63.9139852160655,69.0273433336477,65.6110607538196,60.9100860400161,69.7304171797555,60.5954537958669,66.2800254461483,67.2872315688258,65.8455506853112,67.4505393631976,68.8821799001114,74.2464641516305,68.7946142628276,66.1208051904363,66.8632519549484,62.7976008921197,60.9492305460796,61.4402721398954,61.4713049305851,65.8546552521689,67.1220275839112,66.9973706059677,60.2246701679479,68.0004182854211,72.8406256787476,66.9782165672756,64.7963736367417,65.9674837387502,67.7986034256406,64.0778099695424,65.4047842353513,68.2983099997017,61.9527775452544,73.6268588332942,64.0332921228742,60.1485021719519,72.4441143134251,63.6785875179411,68.2459943553594,64.0574210189453,67.9852534881773,67.5615869422713,63.9407487271744,63.6439544720611,67.3403624054898,65.2147861509888,68.3581559208861,66.576865185361,60.9272947640423,65.8855408477872,64.2715177568005,63.3863097720027,67.7268946260622,66.7575781961526,66.6619226094889,63.6399696642038,60.1159540495278,64.7681727669534,65.324893231927,68.9178112118647,66.5703233122284,67.2899001481067,62.9448150570063,64.9342408196336,65.4782416670898,67.6316156587151,66.7157759162445,57.9166287576279,63.6707569465257,65.1370396028051,61.1677938246742,68.1121987248244,68.1423364016292,68.564406959346,68.8886401023301,62.0956811059351,61.1086543090563,60.9962906857003,62.3623826851987,65.3604527228984,65.6625436671124,62.3030502706083,60.5071288568245,64.0460985553028,69.5833747922291,59.3582603796433,63.9181085477005,64.6311313120784,62.9912878465212,58.9061308884198,64.0834114566072,62.3024844130624,62.2454208972759,66.7270136031135,65.9795088064782,70.2095792267577,69.1558509636893,66.4517256103478,66.6198337521864,64.7657765055377],"text":["age: 24<br />height: 59.04419<br />sex: female","age: 21<br />height: 68.45184<br />sex: female","age: 23<br />height: 67.40751<br />sex: female","age: 27<br />height: 70.15284<br />sex: female","age: 21<br />height: 66.34485<br />sex: female","age: 20<br />height: 66.01124<br />sex: female","age: 28<br />height: 61.62850<br />sex: female","age: 22<br />height: 61.43895<br />sex: female","age: 23<br />height: 68.42832<br />sex: female","age: 23<br />height: 60.78121<br />sex: female","age: 23<br />height: 69.43833<br />sex: female","age: 21<br />height: 60.31223<br />sex: female","age: 20<br />height: 70.07280<br />sex: female","age: 20<br />height: 59.31966<br />sex: female","age: 23<br />height: 64.40336<br />sex: female","age: 22<br />height: 67.04512<br />sex: female","age: 23<br />height: 64.14652<br />sex: female","age: 25<br />height: 64.54929<br />sex: female","age: 22<br />height: 63.26555<br />sex: female","age: 21<br />height: 65.06898<br />sex: female","age: 23<br />height: 65.86085<br />sex: female","age: 22<br />height: 58.11239<br />sex: female","age: 22<br />height: 61.85803<br />sex: female","age: 22<br />height: 65.77673<br />sex: female","age: 22<br />height: 71.34978<br />sex: female","age: 22<br />height: 66.15822<br />sex: female","age: 23<br />height: 66.16415<br />sex: female","age: 21<br />height: 63.49663<br />sex: female","age: 23<br />height: 64.91481<br />sex: female","age: 23<br />height: 63.61227<br />sex: female","age: 27<br />height: 68.65963<br />sex: female","age: 22<br />height: 60.18948<br />sex: female","age: 21<br />height: 66.80423<br />sex: female","age: 21<br />height: 65.34276<br />sex: female","age: 23<br />height: 64.76473<br />sex: female","age: 25<br />height: 63.17617<br />sex: female","age: 24<br />height: 68.91529<br />sex: female","age: 25<br />height: 66.41682<br />sex: female","age: 22<br />height: 66.97042<br />sex: female","age: 22<br />height: 72.21448<br />sex: female","age: 25<br />height: 66.88480<br />sex: female","age: 23<br />height: 63.90600<br />sex: female","age: 21<br />height: 70.14761<br />sex: female","age: 22<br />height: 69.59091<br />sex: female","age: 22<br />height: 60.73709<br />sex: female","age: 24<br />height: 65.97585<br />sex: female","age: 23<br />height: 66.08448<br />sex: female","age: 21<br />height: 65.16972<br />sex: female","age: 24<br />height: 67.92775<br />sex: female","age: 24<br />height: 66.99526<br />sex: female","age: 26<br />height: 66.88877<br />sex: female","age: 25<br />height: 62.80862<br />sex: female","age: 21<br />height: 75.67163<br />sex: female","age: 25<br />height: 69.75175<br />sex: female","age: 23<br />height: 64.35760<br />sex: female","age: 23<br />height: 61.57624<br />sex: female","age: 22<br />height: 67.94114<br />sex: female","age: 25<br />height: 66.18609<br />sex: female","age: 23<br />height: 59.85558<br />sex: female","age: 24<br />height: 61.26490<br />sex: female","age: 23<br />height: 67.38467<br />sex: female","age: 21<br />height: 60.88898<br />sex: female","age: 22<br />height: 63.20092<br />sex: female","age: 24<br />height: 69.49510<br />sex: female","age: 22<br />height: 68.83941<br />sex: female","age: 20<br />height: 62.46351<br />sex: female","age: 24<br />height: 62.43802<br />sex: female","age: 24<br />height: 63.98602<br />sex: female","age: 23<br />height: 70.28231<br />sex: female","age: 22<br />height: 63.74742<br />sex: female","age: 22<br />height: 66.00030<br />sex: female","age: 25<br />height: 59.44382<br />sex: female","age: 24<br />height: 66.03141<br />sex: female","age: 24<br />height: 63.84187<br />sex: female","age: 23<br />height: 64.96592<br />sex: female","age: 23<br />height: 75.06394<br />sex: female","age: 22<br />height: 64.12614<br />sex: female","age: 23<br />height: 62.87544<br />sex: female","age: 24<br />height: 67.33803<br />sex: female","age: 23<br />height: 64.97811<br />sex: female","age: 22<br />height: 64.85858<br />sex: female","age: 23<br />height: 63.08303<br />sex: female","age: 23<br />height: 61.89718<br />sex: female","age: 23<br />height: 65.23751<br />sex: female","age: 23<br />height: 69.10295<br />sex: female","age: 24<br />height: 63.69972<br />sex: female","age: 25<br />height: 65.28960<br />sex: female","age: 22<br />height: 62.98716<br />sex: female","age: 22<br />height: 68.29019<br />sex: female","age: 22<br />height: 61.01473<br />sex: female","age: 20<br />height: 64.83299<br />sex: female","age: 22<br />height: 66.10041<br />sex: female","age: 24<br />height: 70.11153<br />sex: female","age: 23<br />height: 64.90831<br />sex: female","age: 24<br />height: 70.94852<br />sex: female","age: 24<br />height: 67.12788<br />sex: female","age: 21<br />height: 66.00791<br />sex: female","age: 24<br />height: 64.25288<br />sex: female","age: 22<br />height: 59.73498<br />sex: female","age: 21<br />height: 64.28396<br />sex: female","age: 24<br />height: 58.48988<br />sex: female","age: 21<br />height: 62.63539<br />sex: female","age: 22<br />height: 70.33120<br />sex: female","age: 23<br />height: 60.37548<br />sex: female","age: 23<br />height: 59.78614<br />sex: female","age: 25<br />height: 63.28330<br />sex: female","age: 24<br />height: 65.58067<br />sex: female","age: 23<br />height: 70.57975<br />sex: female","age: 24<br />height: 64.11258<br />sex: female","age: 22<br />height: 61.79845<br />sex: female","age: 25<br />height: 62.77549<br />sex: female","age: 21<br />height: 68.27145<br />sex: female","age: 22<br />height: 64.02308<br />sex: female","age: 22<br />height: 65.42347<br />sex: female","age: 22<br />height: 62.06547<br />sex: female","age: 20<br />height: 66.90377<br />sex: female","age: 23<br />height: 65.70717<br />sex: female","age: 25<br />height: 57.87456<br />sex: female","age: 25<br />height: 69.90891<br />sex: female","age: 23<br />height: 69.74439<br />sex: female","age: 24<br />height: 68.01640<br />sex: female","age: 23<br />height: 68.80535<br />sex: female","age: 23<br />height: 67.55804<br />sex: female","age: 26<br />height: 67.19756<br />sex: female","age: 25<br />height: 58.73409<br />sex: female","age: 21<br />height: 66.91878<br />sex: female","age: 21<br />height: 70.15791<br />sex: female","age: 23<br />height: 57.64705<br />sex: female","age: 20<br />height: 65.88616<br />sex: female","age: 21<br />height: 61.69303<br />sex: female","age: 24<br />height: 63.35410<br />sex: female","age: 28<br />height: 62.12337<br />sex: female","age: 24<br />height: 65.87937<br />sex: female","age: 23<br />height: 62.38332<br />sex: female","age: 23<br />height: 64.94785<br />sex: female","age: 24<br />height: 71.35618<br />sex: female","age: 21<br />height: 69.85076<br />sex: female","age: 21<br />height: 67.46123<br />sex: female","age: 20<br />height: 63.87229<br />sex: female","age: 23<br />height: 65.80843<br />sex: female","age: 22<br />height: 61.91436<br />sex: female","age: 26<br />height: 69.38630<br />sex: female","age: 21<br />height: 63.54975<br />sex: female","age: 23<br />height: 62.79838<br />sex: female","age: 22<br />height: 64.96471<br />sex: female","age: 22<br />height: 64.89194<br />sex: female","age: 21<br />height: 67.03430<br />sex: female","age: 23<br />height: 65.95085<br />sex: female","age: 22<br />height: 64.22047<br />sex: female","age: 23<br />height: 70.51271<br />sex: female","age: 25<br />height: 59.12778<br />sex: female","age: 23<br />height: 64.08120<br />sex: female","age: 24<br />height: 65.40663<br />sex: female","age: 23<br />height: 66.89236<br />sex: female","age: 22<br />height: 67.55026<br />sex: female","age: 24<br />height: 65.43698<br />sex: female","age: 25<br />height: 60.81921<br />sex: female","age: 23<br />height: 60.48795<br />sex: female","age: 22<br />height: 64.45026<br />sex: female","age: 21<br />height: 61.65751<br />sex: female","age: 28<br />height: 67.49959<br />sex: female","age: 23<br />height: 58.99913<br />sex: female","age: 24<br />height: 61.43677<br />sex: female","age: 26<br />height: 64.35464<br />sex: female","age: 26<br />height: 62.86144<br />sex: female","age: 22<br />height: 69.71021<br />sex: female","age: 26<br />height: 68.88020<br />sex: female","age: 22<br />height: 58.81525<br />sex: female","age: 25<br />height: 62.70448<br />sex: female","age: 22<br />height: 63.63786<br />sex: female","age: 23<br />height: 58.62845<br />sex: female","age: 23<br />height: 67.10610<br />sex: female","age: 23<br />height: 63.29554<br />sex: female","age: 24<br />height: 67.75069<br />sex: female","age: 23<br />height: 66.48955<br />sex: female","age: 20<br />height: 63.91554<br />sex: female","age: 21<br />height: 68.90482<br />sex: female","age: 26<br />height: 63.11404<br />sex: female","age: 22<br />height: 67.08336<br />sex: female","age: 23<br />height: 67.59392<br />sex: female","age: 20<br />height: 65.38361<br />sex: female","age: 23<br />height: 65.04355<br />sex: female","age: 21<br />height: 70.10514<br />sex: female","age: 21<br />height: 64.06130<br />sex: female","age: 24<br />height: 61.56785<br />sex: female","age: 25<br />height: 61.36245<br />sex: female","age: 24<br />height: 65.91228<br />sex: female","age: 23<br />height: 63.10538<br />sex: female","age: 24<br />height: 64.57368<br />sex: female","age: 21<br />height: 62.20852<br />sex: female","age: 25<br />height: 66.19165<br />sex: female","age: 20<br />height: 59.82792<br />sex: female","age: 22<br />height: 59.50439<br />sex: female","age: 25<br />height: 64.74784<br />sex: female","age: 23<br />height: 64.77397<br />sex: female","age: 25<br />height: 59.31923<br />sex: female","age: 21<br />height: 65.82361<br />sex: female","age: 26<br />height: 74.63590<br />sex: female","age: 24<br />height: 67.52738<br />sex: female","age: 24<br />height: 71.00023<br />sex: female","age: 21<br />height: 63.74952<br />sex: female","age: 24<br />height: 67.59456<br />sex: female","age: 22<br />height: 63.08482<br />sex: female","age: 25<br />height: 70.71680<br />sex: female","age: 22<br />height: 66.15327<br />sex: female","age: 22<br />height: 71.78024<br />sex: female","age: 22<br />height: 58.39008<br />sex: female","age: 22<br />height: 68.21736<br />sex: female","age: 26<br />height: 64.66308<br />sex: female","age: 21<br />height: 64.41119<br />sex: female","age: 24<br />height: 63.02293<br />sex: female","age: 23<br />height: 63.77159<br />sex: female","age: 22<br />height: 66.47733<br />sex: female","age: 24<br />height: 67.30792<br />sex: female","age: 23<br />height: 60.48464<br />sex: female","age: 23<br />height: 61.25305<br />sex: female","age: 23<br />height: 68.87932<br />sex: female","age: 22<br />height: 65.29045<br />sex: female","age: 24<br />height: 68.05091<br />sex: female","age: 24<br />height: 61.13734<br />sex: female","age: 23<br />height: 68.73000<br />sex: female","age: 21<br />height: 71.79828<br />sex: female","age: 24<br />height: 62.54513<br />sex: female","age: 25<br />height: 67.52974<br />sex: female","age: 23<br />height: 64.87415<br />sex: female","age: 22<br />height: 61.73806<br />sex: female","age: 24<br />height: 62.72082<br />sex: female","age: 22<br />height: 61.75694<br />sex: female","age: 21<br />height: 65.07730<br />sex: female","age: 22<br />height: 64.83601<br />sex: female","age: 23<br />height: 66.37637<br />sex: female","age: 23<br />height: 67.67980<br />sex: female","age: 24<br />height: 59.93963<br />sex: female","age: 23<br />height: 69.37857<br />sex: female","age: 25<br />height: 68.91662<br />sex: female","age: 22<br />height: 71.49705<br />sex: female","age: 23<br />height: 71.28669<br />sex: female","age: 22<br />height: 59.32120<br />sex: female","age: 24<br />height: 67.08491<br />sex: female","age: 23<br />height: 60.39510<br />sex: female","age: 22<br />height: 70.37466<br />sex: female","age: 23<br />height: 66.69509<br />sex: female","age: 23<br />height: 62.81117<br />sex: female","age: 24<br />height: 65.66052<br />sex: female","age: 22<br />height: 79.15778<br />sex: female","age: 22<br />height: 66.81161<br />sex: female","age: 22<br />height: 65.35555<br />sex: female","age: 21<br />height: 71.00253<br />sex: female","age: 20<br />height: 63.27792<br />sex: female","age: 22<br />height: 66.18430<br />sex: female","age: 25<br />height: 64.58180<br />sex: female","age: 21<br />height: 63.40896<br />sex: female","age: 25<br />height: 73.20925<br />sex: female","age: 22<br />height: 61.98976<br />sex: female","age: 24<br />height: 61.40818<br />sex: female","age: 21<br />height: 60.42290<br />sex: female","age: 24<br />height: 60.12296<br />sex: female","age: 21<br />height: 65.15332<br />sex: female","age: 22<br />height: 64.28727<br />sex: female","age: 20<br />height: 64.41701<br />sex: female","age: 22<br />height: 64.68855<br />sex: female","age: 25<br />height: 67.86669<br />sex: female","age: 22<br />height: 62.66481<br />sex: female","age: 26<br />height: 65.83413<br />sex: female","age: 23<br />height: 64.71056<br />sex: female","age: 25<br />height: 67.30657<br />sex: female","age: 22<br />height: 57.67721<br />sex: female","age: 24<br />height: 60.73345<br />sex: female","age: 20<br />height: 66.52058<br />sex: female","age: 26<br />height: 63.87010<br />sex: female","age: 22<br />height: 67.06698<br />sex: female","age: 24<br />height: 69.58870<br />sex: female","age: 26<br />height: 61.74618<br />sex: female","age: 25<br />height: 64.39689<br />sex: female","age: 25<br />height: 64.10169<br />sex: female","age: 22<br />height: 65.18420<br />sex: female","age: 20<br />height: 62.57356<br />sex: female","age: 24<br />height: 62.80569<br />sex: female","age: 22<br />height: 62.07693<br />sex: female","age: 23<br />height: 68.66445<br />sex: female","age: 20<br />height: 67.57323<br />sex: female","age: 24<br />height: 66.17167<br />sex: female","age: 25<br />height: 65.05524<br />sex: female","age: 21<br />height: 65.59792<br />sex: female","age: 21<br />height: 64.97946<br />sex: female","age: 22<br />height: 64.10933<br />sex: female","age: 25<br />height: 67.02905<br />sex: female","age: 23<br />height: 65.95088<br />sex: female","age: 23<br />height: 69.08787<br />sex: female","age: 21<br />height: 70.05872<br />sex: female","age: 22<br />height: 65.01805<br />sex: female","age: 23<br />height: 65.89597<br />sex: female","age: 20<br />height: 57.97859<br />sex: female","age: 26<br />height: 65.64854<br />sex: female","age: 21<br />height: 64.11990<br />sex: female","age: 22<br />height: 59.24646<br />sex: female","age: 22<br />height: 52.84550<br />sex: female","age: 20<br />height: 65.90004<br />sex: female","age: 21<br />height: 60.78264<br />sex: female","age: 25<br />height: 65.44360<br />sex: female","age: 26<br />height: 67.40567<br />sex: female","age: 23<br />height: 56.26367<br />sex: female","age: 24<br />height: 66.90300<br />sex: female","age: 24<br />height: 68.65764<br />sex: female","age: 21<br />height: 66.29899<br />sex: female","age: 23<br />height: 69.04648<br />sex: female","age: 23<br />height: 67.61597<br />sex: female","age: 23<br />height: 62.47958<br />sex: female","age: 21<br />height: 64.80984<br />sex: female","age: 24<br />height: 68.05123<br />sex: female","age: 26<br />height: 66.12070<br />sex: female","age: 20<br />height: 63.34502<br />sex: female","age: 20<br />height: 67.65956<br />sex: female","age: 23<br />height: 66.59583<br />sex: female","age: 25<br />height: 66.90220<br />sex: female","age: 22<br />height: 66.52966<br />sex: female","age: 22<br />height: 58.54813<br />sex: female","age: 22<br />height: 67.09219<br />sex: female","age: 24<br />height: 69.55561<br />sex: female","age: 24<br />height: 62.91808<br />sex: female","age: 22<br />height: 67.51254<br />sex: female","age: 25<br />height: 62.31960<br />sex: female","age: 22<br />height: 64.67435<br />sex: female","age: 23<br />height: 62.87087<br />sex: female","age: 24<br />height: 70.57622<br />sex: female","age: 24<br />height: 66.59509<br />sex: female","age: 22<br />height: 64.08105<br />sex: female","age: 24<br />height: 71.33470<br />sex: female","age: 22<br />height: 67.84954<br />sex: female","age: 22<br />height: 68.28360<br />sex: female","age: 21<br />height: 58.75108<br />sex: female","age: 23<br />height: 66.41514<br />sex: female","age: 20<br />height: 67.51103<br />sex: female","age: 21<br />height: 60.16645<br />sex: female","age: 23<br />height: 61.14113<br />sex: female","age: 22<br />height: 65.12225<br />sex: female","age: 22<br />height: 62.04345<br />sex: female","age: 20<br />height: 63.58028<br />sex: female","age: 22<br />height: 62.86700<br />sex: female","age: 25<br />height: 62.02486<br />sex: female","age: 21<br />height: 63.57838<br />sex: female","age: 23<br />height: 72.08400<br />sex: female","age: 23<br />height: 64.08615<br />sex: female","age: 24<br />height: 65.57814<br />sex: female","age: 24<br />height: 62.84621<br />sex: female","age: 24<br />height: 65.46028<br />sex: female","age: 23<br />height: 64.91535<br />sex: female","age: 22<br />height: 68.04448<br />sex: female","age: 22<br />height: 69.87915<br />sex: female","age: 23<br />height: 67.14448<br />sex: female","age: 21<br />height: 68.50180<br />sex: female","age: 24<br />height: 69.33712<br />sex: female","age: 23<br />height: 63.51124<br />sex: female","age: 21<br />height: 67.15982<br />sex: female","age: 26<br />height: 69.78913<br />sex: female","age: 21<br />height: 71.84257<br />sex: female","age: 22<br />height: 68.32586<br />sex: female","age: 24<br />height: 67.55903<br />sex: female","age: 21<br />height: 65.82421<br />sex: female","age: 21<br />height: 61.48590<br />sex: female","age: 23<br />height: 62.03766<br />sex: female","age: 23<br />height: 67.38412<br />sex: female","age: 24<br />height: 63.96967<br />sex: female","age: 23<br />height: 63.55691<br />sex: female","age: 24<br />height: 63.81898<br />sex: female","age: 23<br />height: 62.06513<br />sex: female","age: 23<br />height: 70.67578<br />sex: female","age: 24<br />height: 67.20430<br />sex: female","age: 23<br />height: 66.66053<br />sex: female","age: 27<br />height: 64.07005<br />sex: female","age: 21<br />height: 59.44294<br />sex: female","age: 23<br />height: 64.65078<br />sex: female","age: 26<br />height: 62.50616<br />sex: female","age: 22<br />height: 59.38515<br />sex: female","age: 22<br />height: 63.56284<br />sex: female","age: 21<br />height: 61.93230<br />sex: female","age: 21<br />height: 63.56898<br />sex: female","age: 23<br />height: 66.33271<br />sex: female","age: 21<br />height: 60.65558<br />sex: female","age: 22<br />height: 62.95858<br />sex: female","age: 27<br />height: 58.92131<br />sex: female","age: 22<br />height: 58.38046<br />sex: female","age: 22<br />height: 61.74627<br />sex: female","age: 24<br />height: 60.12147<br />sex: female","age: 25<br />height: 63.73044<br />sex: female","age: 23<br />height: 64.31118<br />sex: female","age: 24<br />height: 64.60239<br />sex: female","age: 25<br />height: 68.21490<br />sex: female","age: 22<br />height: 63.03128<br />sex: female","age: 21<br />height: 71.79024<br />sex: female","age: 22<br />height: 67.90146<br />sex: female","age: 27<br />height: 74.42064<br />sex: female","age: 23<br />height: 65.65812<br />sex: female","age: 24<br />height: 65.98233<br />sex: female","age: 25<br />height: 64.41673<br />sex: female","age: 22<br />height: 68.12635<br />sex: female","age: 22<br />height: 64.50770<br />sex: female","age: 21<br />height: 72.93850<br />sex: female","age: 21<br />height: 68.85089<br />sex: female","age: 22<br />height: 64.68463<br />sex: female","age: 27<br />height: 63.91399<br />sex: female","age: 22<br />height: 69.02734<br />sex: female","age: 26<br />height: 65.61106<br />sex: female","age: 25<br />height: 60.91009<br />sex: female","age: 24<br />height: 69.73042<br />sex: female","age: 21<br />height: 60.59545<br />sex: female","age: 21<br />height: 66.28003<br />sex: female","age: 23<br />height: 67.28723<br />sex: female","age: 24<br />height: 65.84555<br />sex: female","age: 23<br />height: 67.45054<br />sex: female","age: 22<br />height: 68.88218<br />sex: female","age: 24<br />height: 74.24646<br />sex: female","age: 25<br />height: 68.79461<br />sex: female","age: 20<br />height: 66.12081<br />sex: female","age: 21<br />height: 66.86325<br />sex: female","age: 24<br />height: 62.79760<br />sex: female","age: 22<br />height: 60.94923<br />sex: female","age: 22<br />height: 61.44027<br />sex: female","age: 24<br />height: 61.47130<br />sex: female","age: 22<br />height: 65.85466<br />sex: female","age: 25<br />height: 67.12203<br />sex: female","age: 20<br />height: 66.99737<br />sex: female","age: 23<br />height: 60.22467<br />sex: female","age: 22<br />height: 68.00042<br />sex: female","age: 23<br />height: 72.84063<br />sex: female","age: 27<br />height: 66.97822<br />sex: female","age: 25<br />height: 64.79637<br />sex: female","age: 24<br />height: 65.96748<br />sex: female","age: 26<br />height: 67.79860<br />sex: female","age: 22<br />height: 64.07781<br />sex: female","age: 23<br />height: 65.40478<br />sex: female","age: 23<br />height: 68.29831<br />sex: female","age: 23<br />height: 61.95278<br />sex: female","age: 22<br />height: 73.62686<br />sex: female","age: 23<br />height: 64.03329<br />sex: female","age: 25<br />height: 60.14850<br />sex: female","age: 28<br />height: 72.44411<br />sex: female","age: 23<br />height: 63.67859<br />sex: female","age: 24<br />height: 68.24599<br />sex: female","age: 23<br />height: 64.05742<br />sex: female","age: 22<br />height: 67.98525<br />sex: female","age: 23<br />height: 67.56159<br />sex: female","age: 26<br />height: 63.94075<br />sex: female","age: 23<br />height: 63.64395<br />sex: female","age: 24<br />height: 67.34036<br />sex: female","age: 22<br />height: 65.21479<br />sex: female","age: 20<br />height: 68.35816<br />sex: female","age: 22<br />height: 66.57687<br />sex: female","age: 21<br />height: 60.92729<br />sex: female","age: 24<br />height: 65.88554<br />sex: female","age: 25<br />height: 64.27152<br />sex: female","age: 20<br />height: 63.38631<br />sex: female","age: 21<br />height: 67.72689<br />sex: female","age: 20<br />height: 66.75758<br />sex: female","age: 23<br />height: 66.66192<br />sex: female","age: 22<br />height: 63.63997<br />sex: female","age: 24<br />height: 60.11595<br />sex: female","age: 21<br />height: 64.76817<br />sex: female","age: 22<br />height: 65.32489<br />sex: female","age: 24<br />height: 68.91781<br />sex: female","age: 23<br />height: 66.57032<br />sex: female","age: 23<br />height: 67.28990<br />sex: female","age: 20<br />height: 62.94482<br />sex: female","age: 24<br />height: 64.93424<br />sex: female","age: 27<br />height: 65.47824<br />sex: female","age: 23<br />height: 67.63162<br />sex: female","age: 25<br />height: 66.71578<br />sex: female","age: 21<br />height: 57.91663<br />sex: female","age: 22<br />height: 63.67076<br />sex: female","age: 22<br />height: 65.13704<br />sex: female","age: 23<br />height: 61.16779<br />sex: female","age: 25<br />height: 68.11220<br />sex: female","age: 24<br />height: 68.14234<br />sex: female","age: 24<br />height: 68.56441<br />sex: female","age: 24<br />height: 68.88864<br />sex: female","age: 25<br />height: 62.09568<br />sex: female","age: 23<br />height: 61.10865<br />sex: female","age: 22<br />height: 60.99629<br />sex: female","age: 22<br />height: 62.36238<br />sex: female","age: 20<br />height: 65.36045<br />sex: female","age: 21<br />height: 65.66254<br />sex: female","age: 22<br />height: 62.30305<br />sex: female","age: 21<br />height: 60.50713<br />sex: female","age: 26<br />height: 64.04610<br />sex: female","age: 23<br />height: 69.58337<br />sex: female","age: 23<br />height: 59.35826<br />sex: female","age: 22<br />height: 63.91811<br />sex: female","age: 23<br />height: 64.63113<br />sex: female","age: 24<br />height: 62.99129<br />sex: female","age: 26<br />height: 58.90613<br />sex: female","age: 21<br />height: 64.08341<br />sex: female","age: 24<br />height: 62.30248<br />sex: female","age: 25<br />height: 62.24542<br />sex: female","age: 24<br />height: 66.72701<br />sex: female","age: 25<br />height: 65.97951<br />sex: female","age: 23<br />height: 70.20958<br />sex: female","age: 21<br />height: 69.15585<br />sex: female","age: 25<br />height: 66.45173<br />sex: female","age: 24<br />height: 66.61983<br />sex: female","age: 21<br />height: 64.76578<br />sex: female"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"female","legendgroup":"female","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[23.0573887359351,22.035733097326,24.19046901986,21.985248530563,27.1303027928807,23.1694930164143,20.9596227411181,20.1306375510991,22.8292645835318,24.1996371195652,21.9994959359989,21.8156017391011,20.1004024809226,23.195105521474,23.1305134389549,23.909208717104,23.1692503070459,23.1255673320964,21.8540262718685,21.8837174369954,22.0708799174055,23.0018394692801,22.9238922514953,25.1497554712929,23.8325033234432,22.8333124568686,23.8943475954235,22.0751577573828,25.9697978639975,22.1956010988913,22.0091886392795,19.9730164123699,23.8671180167235,22.8996529105119,21.8071584394202,21.0023273668252,23.9124407579191,22.9380258586258,23.8614756529219,19.9252598334104,23.0869262640364,22.1986756476574,24.0033961637877,23.8993772775866,21.9608744494617,22.9476621109061,21.0514822384343,21.9779880699702,23.9189207277261,22.0219742307439,21.9603504256345,24.8094669961371,21.0801995048299,23.1536314045079,22.0208234839141,21.9604314127006,24.0470519656315,23.0861682081595,25.1809211350977,25.1066441701725,24.9653935099021,22.062086906936,20.9991890186444,23.8813140433282,23.1826213680208,22.8450568675995,21.0953325813636,24.0074725761078,22.1980049293488,23.0297289035283,27.1557622721419,20.1022227957845,24.011535041593,20.8734792275354,22.1860549133271,26.8515773160383,20.8149926065467,22.829005851876,20.9552813421004,23.9480158316903,22.1222454283386,21.1628835854121,23.9460093180649,24.0636846147478,22.850595829729,23.9672372198664,25.0670783155598,24.9404872460291,20.8693415074609,22.8139948962256,22.1133377069607,24.9157213981263,25.0309003108181,24.1506090214476,23.0506476605311,26.9468366998248,22.0716513567604,21.943746456597,22.9590740268119,22.9467008997686,24.0964546040632,21.0895399292931,20.8762637506239,26.1190453222953,21.1334723534063,21.1817247078754,24.0328540510498,25.9845866709016,21.8655339634046,23.0610035506077,23.0299233625643,23.0559107291512,20.8206135412678,20.8740556296892,21.9180341687053,22.1705854618922,26.8116219427437,21.0059431157075,24.0145321393386,24.0515640389174,24.9851358209737,21.8008547000587,26.0296068660915,23.1455980261788,21.9195399602875,25.0493605365045,21.951755431015,22.0343940413557,21.9373897513375,21.8733081810176,22.0398900732398,26.98698564386,21.1440970358439,20.9134199392982,23.176828711573,23.0873900218867,20.8827660429291,26.9838694781996,23.9369212441146,25.9852249259129,27.9419864027761,22.8929271320812,21.9362241481431,24.0104494472034,22.8440062497742,22.8974091409706,21.0386814936064,22.0262535226531,26.1765750903636,23.8738873831928,26.1572093712166,26.8616315335035,25.8046927315183,19.8649314718321,22.929484497197,21.8162892394699,26.1445680540986,20.8758759403601,21.9940710608847,26.0196475496516,24.8098895909265,22.1870043914765,23.0078900752589,22.8426465358585,24.1300689698197,29.9046826913953,23.029412061628,24.9811061372049,20.1383646585979,22.8154232348315,23.9974180253223,22.1381104175933,26.1823473962955,23.8204078588635,27.94116662452,25.9572209500708,22.8602358694188,21.0679701718502,19.8355038723908,23.1047611438669,24.099953804072,22.0198132133111,23.0330520625226,23.0466864163056,23.1518023197539,20.8775643424131,24.9020579728298,20.9642422761768,22.874066227302,19.9212852350436,23.9983537770808,22.1582816007547,21.9625826339237,24.0667835758999,21.1625100299716,23.0744768432342,21.8036138123833,22.8915800763294,22.8817124514841,28.079644248914,20.8912238440476,23.8227609869093,23.1202654053457,22.8483145291917,22.9844957987778,21.8189509811811,22.169548128359,23.0105726227164,21.9280039403588,22.8100962190889,21.8858346889727,25.0557368503883,23.1318966628984,25.129853321705,25.9852603456937,22.8777842661366,25.1443257839419,20.8513114996254,22.8068033512682,20.9239930280484,21.1184931122698,26.8285800608806,22.0311124389991,22.0575162995607,23.9842867259867,22.9300613510422,22.1749637460336,22.9436119647697,23.0137253955007,21.1992084758356,23.0764774240553,23.1733383484185,24.9677884565666,21.9784237442538,21.9553675995208,23.1758329721168,22.0426937955432,21.9876268071122,23.0805614000186,21.9872829187661,21.0148964889348,22.135372254625,21.8725978104398,26.1441957553849,23.1682130544446,24.1860221255571,23.1017153400928,23.9384646210819,25.8569320032373,22.9653511112556,22.0493990921415,25.8677337834612,21.0971676960588,20.9325914321467,26.181095900666,25.0268854343332,21.9006366947666,21.9985953509808,23.8484350962564,21.8440872083418,24.1957625483163,23.068636620976,26.9871284483932,21.9957328488119,24.0706884109415,24.9691684653051,23.1566059834324,24.1669249467552,24.0955667829141,25.1058975849301,26.1416652493179,22.0574571946636,25.0445904728957,25.0939710334875,20.9676379999146,20.9801894763485,23.0004603029229,20.8757592195645,20.8688232436776,19.8121707841754,21.1069598038681,22.0833330510184,22.8625004054047,21.9595715458505,22.9564089673571,23.1103313555941,20.8418375309557,22.0229156255722,27.0197863763198,23.0585568091832,24.1507086179219,22.9301977630705,24.8815877602436,22.8719470394775,22.0259967718273,22.8059942819178,29.0868919911794,20.1643072822131,23.8621350943111,22.1188527307473,21.8208092572168,21.0519742160104,25.1602909830399,20.1146473824047,22.8692953056656,22.8130301643163,25.0812692814507,22.9415246615186,21.0435633015819,22.8541280039586,23.8113248894922,22.9063707607798,22.8681137694046,25.0253987192176,25.0355503517203,22.1549786943942,22.1624128825963,21.0789009841159,20.0494961334392,24.053192585241,21.9910132602789,23.1095280273817,20.8105258480646,25.1966346315108,26.0242286313325,21.9306734818965,25.0704588165507,22.0872726763599,22.1967611166649,23.8204385695979,21.1560707803816,24.1634352344088,21.0994059387594,22.8778111265041,20.9185143708251,23.0803217848763,22.9076263548806,25.1961552687921,19.9604814392515,23.995123743359,23.9619317996316,23.1439115950838,22.1288929977454,20.066132982634,24.8023252489977,22.8712588225491,25.1215408116579,22.1848785732873,21.82592645064,21.835960899014,23.840193803329,22.045107414946,25.8923307772726,22.9220681054518,21.1789965623058,23.0943417415023,22.0366056410596,26.1505729848519,23.8065468030982,24.9863212282769,22.8546522252262,22.8908665695228,22.1403100576252,22.8607000593096,23.0778922529891,22.1391163704917,23.8121534679085,21.1930528106168,21.8521056322381,27.008366215881,22.9748043036088,22.8230600997806,25.044621742703,22.8757610917091,22.9767019226216,22.9015501443297,20.9077004050836,24.9697304087691,25.0329509467818,20.9855265521444,20.9747335460968,21.9797576950863,20.0951807810925,24.0767705930397,22.0821722327732,23.8095299336128,25.1556630361825,22.0377971199341,23.1808282027952,21.8368988948874,28.1265904115513,20.9343700808473,22.1713551657274,21.009636511188,22.9228424954228,23.1918192943558,21.8160290528089,20.8097960257903,24.8955643200316,23.047584789712,19.8447399681434,22.8665151528083,22.1165797266178,23.0592537435703,28.9190124478191,23.0964451773092,22.8394802438095,21.8426139508374,22.1927759433165,22.1693307992071,25.9223081095144,21.1624900395982,26.1885511876084,27.1999064597301,23.9184572746046,21.1585585425608,24.0468227880076,25.1033047011122,24.8410921158269,19.885777986981,23.0148908561096,22.1124968049116,20.9943563340232,22.1780993713997,20.9494056716561,21.8983809971251,20.1215860303491,22.0408600564115,22.0009806721471,23.839946024958,22.0370113341138,22.0978929005563,21.9596031908877,22.0721233289689,25.1651197132654,24.8795957342722,24.9312795981765,21.1143628572114,21.0831900304183,24.0805982799269,22.8500396003947,20.933580753766,25.9795273341239,24.1992992649786,22.989888170734,20.889673278667,20.9448046728969,24.061569606699,20.9374780789949,24.8826071335003,21.0917518784292,23.0251916470937,23.1484930739738,20.1043705584481,26.895513131842,24.885741008725,22.8360837270506,21.9043416569941,21.9743058706634,20.9565655713901,23.1796687467024,23.0406796711497,19.8940741455182,22.0440622916445,24.1487885251641,25.1628012450412,24.8169639879838,24.841528336145,20.0440343939699,20.8172055306844,22.8803154321387,22.980805355683,24.037611379195,27.114617537614,22.9395410999656,23.9902935964987,20.1434221277013,20.9256170191802,23.1538964227773,22.902585021127,22.0680045911111,21.1873634476215,25.8986261160113,22.0399970361963,25.0982875404879,23.997546624206,21.1522076808848,21.1249009383842,22.8865953424014,23.8174154426903,23.1945517211221,23.1110498701222,21.0972386313602,22.0637579170056,21.0755234377459,27.177860277053,20.8892510696314,22.9079930521548,25.1422074280679,23.1700939532369],"y":[64.4814444193098,71.6601198416242,78.0989920386949,64.8614512484568,67.79699191793,66.9022423189483,69.0229324337397,71.1913814017124,75.9586086840637,72.7249414599674,64.3581210138574,65.936412394473,69.9088998905627,69.9625544078172,68.9703167713183,65.4780978634978,75.58414206749,69.7856669963537,76.6585676501728,64.3581129483151,62.7701409024473,73.1024012790086,61.052932902152,69.5663907866765,66.5021328976972,64.2539837349372,70.6405181500693,64.3734262149484,71.2178178483808,62.1451886379196,68.0137787738871,69.1426385737591,69.8555668348776,66.0396758080661,63.753622845769,69.9342524255055,64.7893336426317,73.6440043379069,73.334913270708,72.1762465314488,70.6721292513883,76.3144075313173,70.7489353613581,73.648394958055,69.243124126988,67.9169108443393,65.9437235958125,59.2242831660925,66.6677350209324,64.0580691352236,66.6835957683528,74.883394216611,71.7706921922137,64.1807560388479,67.2539679699595,71.2326399089327,71.6527231103604,71.9862586360448,71.2444583722208,71.2123731700522,69.9748953670434,67.224109782364,70.7473928101614,72.550631433637,66.9484390342575,71.063316782762,68.5343035355261,68.2062098015814,73.364813765828,71.1979685818308,71.3299001316131,69.2337533628361,60.5316531315934,70.4361432090438,73.5753803210149,65.6241150784344,77.8519332654779,74.4020360956779,70.8502576859316,74.21548651634,58.8942299194746,73.2256814262587,74.2286260601034,80.9964753729736,70.5161708271937,64.169366314208,69.9786201749016,74.0324842217136,73.5646665445493,69.1949241401766,67.6952454121929,68.3407050637214,73.5895075118125,73.9187115621604,67.5917788528531,69.4491691405753,74.7241614822222,67.926938940654,75.74867190564,74.7037740683814,66.2770050426383,69.7849849893152,69.3154483758211,62.7825388073768,64.3811157094385,64.9418158784257,71.2777758524965,70.022292007945,73.2173152312187,77.880885884376,68.7347258624037,73.1180438933829,79.1709396896281,65.6530100861773,69.2102821461363,64.2852505027657,69.8214085509507,69.8513889045468,72.2711827964031,73.144941504153,72.1393656239651,70.2409983296359,64.8172087869235,74.0329766349974,69.6740099941185,67.5141143037728,65.7049187862145,70.8353535056632,72.7294012142373,68.8805520173636,71.6279664215534,71.9015247587975,71.556231278926,75.3295166753849,70.2448404248617,71.050772380782,70.0993879667315,64.2604858947824,70.497685570371,75.9931137923192,71.7806979224488,77.3834513479707,74.7804445597034,67.4994095079953,68.3490918297667,73.2020168666625,65.6800374401233,65.4053927135222,75.3952134470485,66.3631011193467,71.800871918679,70.4810506407892,67.8355221796751,66.069576084869,64.1760124559774,66.7075581913174,62.091714074102,73.5395403172065,62.2620734491558,71.839150460814,67.1245815385818,73.8558201159337,68.083912359162,70.6591009341647,72.262108811876,73.0317283327361,66.131878858415,70.3824533011572,70.9825846101015,69.5910711376168,74.0690054598577,70.5944919323496,72.8395177700394,66.6507304189189,75.709848293014,65.8987003157713,72.8623983217094,73.5283480294647,74.245933371971,70.1579832384566,60.826794613742,72.4862940503373,68.0947141242853,65.2123565131547,63.358856224659,64.9056514802604,68.8955533295789,70.8040420766864,69.2203664183798,68.3808106508266,69.1078636542974,74.5005089196979,69.491349555666,76.5879108975045,75.2297429560904,68.4718847809441,75.4400480266589,71.7230261090405,74.3110855577426,70.605578677592,68.8335023859767,70.4288449009332,72.3527897978766,61.0185342312899,66.8338737248123,74.1140046083793,69.1739679452216,77.7132209914774,69.407267250501,67.2398398006649,74.6548826854561,69.6721919223191,72.5741287534142,66.1881770260562,72.6372846663276,69.385916267805,70.4687701374723,65.2848924869679,73.7408128546149,70.7680364362371,69.2910617222693,66.7831282887845,68.2091950595061,66.1533158448503,69.2514884555436,72.1609257520526,74.7103777621347,71.4163919528389,71.2020518913538,66.8749698039052,72.1263654758965,78.0436634482534,69.059910222928,68.2800790697309,64.144375165423,72.6278242912752,65.6405221886524,71.3229291575087,70.2894945862601,67.4158640922901,68.81435059287,62.3600696684886,66.3645623899265,65.6627249809597,66.9504136644065,69.4180277176948,66.3176337463432,76.8030166017972,69.1115420689906,70.8345934584536,73.303625676611,70.3782199759793,72.294393419917,71.6088373587985,69.8711255960144,71.7263592685112,71.2743968208618,77.1367227599861,67.5453972950348,76.6405054528465,74.052393637002,74.2790578698576,69.6934924854129,68.6759990665616,72.7177193810638,72.9144864961425,75.8425626403286,72.7194235038566,67.7220606659356,64.4011373452299,66.576768906045,73.2023505245559,63.5551455514107,63.3503644376438,68.5215830109088,72.1947749448976,74.1793811158364,70.7484478678985,73.5312514072245,73.2931335909664,68.6101663038419,64.2829534583042,70.9849863407728,65.115060192713,71.1275867478499,81.2723418338205,66.88318616868,71.5888828294523,67.581711438976,61.564064361302,65.2743413207427,72.3540657888923,67.3744430874882,66.0950537516508,73.0537230459512,71.7728170656995,71.9344468444568,71.8999304221427,66.8706914364787,65.1479098470517,70.3513411082427,71.4695791461297,72.7439358057223,65.6430242834194,64.8920883169297,65.0070966104923,80.1701738189853,76.8585062044936,77.6155704114428,67.1651890142387,68.4226082474034,68.2385342930659,79.2864993243694,69.2832262568747,70.0693067956492,73.1310179837798,76.7342152861272,72.6639064244141,65.42865363639,62.1669522924576,79.1727230023053,74.712068011894,74.8661668046067,66.0616091667786,72.389802201089,68.7296707945137,61.4401747332706,64.1799571362271,73.0710250413497,67.9684516599637,69.9319820437633,70.9686450393724,76.5343792461902,74.8653670498316,72.7136659982851,73.5747818214954,65.6642739600375,71.0469022158382,70.6966500408332,70.3684307984471,78.5718762410113,73.5093272351244,67.2776788703109,67.8202904454811,73.5325156082569,71.5911425541534,69.0591984462732,68.6190718371078,62.7042655056333,70.6478299134461,77.8933624771349,68.1676762979988,64.0745526824183,72.4019725289182,73.0728470359984,77.0998221777019,71.0185657538397,66.2212332364129,70.0868626088452,69.5015099137972,72.9435736113177,67.1308950132296,70.176612888827,71.0578020846914,73.8913204352817,71.6201664325836,68.9640546813823,70.6989257704569,68.5020746453698,66.0904004754963,71.1876511759438,75.2103345020454,70.3143401836472,65.0809608372268,78.2357834812416,70.4430425894487,67.6681552164126,73.6192519553779,71.645606497157,66.3058864342777,67.5182590491971,68.784718351334,69.2800249069644,69.0793244403902,74.3319318992964,68.2409434034317,67.8271978210589,65.4790919192359,71.0535286542495,74.431940069212,67.8817935186864,67.9477978592107,74.8190938426696,68.5279872976373,59.5877642008272,65.2070264413036,83.2273560780245,66.7418484707688,69.7506110349896,64.847150550747,73.1129518367266,67.2299416700488,71.2682555464082,68.306521150886,69.1587171236344,68.7750146334846,68.4327399508433,71.3033991955485,70.8254018350493,66.5624940609676,72.5022152574887,72.5746053297461,69.2766604277621,69.5122940336996,67.9056235770651,70.0341488903171,66.7633628343728,74.1111886869463,68.631756756501,74.0452714502633,69.9406575101192,68.95121994281,69.7656978579628,73.1511747621038,76.7150399383665,68.8902378312911,66.2734372720453,70.1915240385475,72.7090218568664,68.7907822327976,72.9922988139621,66.1290971684299,62.8745231519671,63.0553811242839,75.8880745817452,69.3325075795441,69.0046992012707,74.89535807439,70.1404098630781,74.6502376211127,65.6306549315484,70.0252108222829,63.0492698367696,73.2275225224103,70.8882451854116,72.6297727837781,73.7946360113029,72.8646814868717,72.4901884396999,66.6428990354412,64.1674419532531,71.0368193749423,72.8140111345099,68.0792161816204,67.370996048273,69.0162295663932,71.6580755885782,64.2050010751834,71.0974890031258,63.3814966144592,63.5922046914384,74.5745416430881,70.8492055365833,74.6846277188943,69.1988007605317,74.0844933007978,71.55082457195,76.5944937125142,71.0047055227546,68.5133381221452,67.1438264828856,73.1419053896596,62.9999644554747,73.0050500782642,71.6238385772183,66.2215302531188,74.1376882633529,64.8821699186932,77.5107357089608,64.2007502276901,72.3729501701812,67.6681407871448,72.5036296737831,72.9436385898525,75.0767053579801,70.0440279760753,72.3749043779204,68.043418567206,71.7091113512144,71.9054169349117,69.748762637615,67.5265048340123,65.1544471966548,70.7187623024936,66.7666851486249,71.1977766327406,70.3667421873477,60.771850719235,76.888558783109,73.8214617621382],"text":["age: 23<br />height: 64.48144<br />sex: male","age: 22<br />height: 71.66012<br />sex: male","age: 24<br />height: 78.09899<br />sex: male","age: 22<br />height: 64.86145<br />sex: male","age: 27<br />height: 67.79699<br />sex: male","age: 23<br />height: 66.90224<br />sex: male","age: 21<br />height: 69.02293<br />sex: male","age: 20<br />height: 71.19138<br />sex: male","age: 23<br />height: 75.95861<br />sex: male","age: 24<br />height: 72.72494<br />sex: male","age: 22<br />height: 64.35812<br />sex: male","age: 22<br />height: 65.93641<br />sex: male","age: 20<br />height: 69.90890<br />sex: male","age: 23<br />height: 69.96255<br />sex: male","age: 23<br />height: 68.97032<br />sex: male","age: 24<br />height: 65.47810<br />sex: male","age: 23<br />height: 75.58414<br />sex: male","age: 23<br />height: 69.78567<br />sex: male","age: 22<br />height: 76.65857<br />sex: male","age: 22<br />height: 64.35811<br />sex: male","age: 22<br />height: 62.77014<br />sex: male","age: 23<br />height: 73.10240<br />sex: male","age: 23<br />height: 61.05293<br />sex: male","age: 25<br />height: 69.56639<br />sex: male","age: 24<br />height: 66.50213<br />sex: male","age: 23<br />height: 64.25398<br />sex: male","age: 24<br />height: 70.64052<br />sex: male","age: 22<br />height: 64.37343<br />sex: male","age: 26<br />height: 71.21782<br />sex: male","age: 22<br />height: 62.14519<br />sex: male","age: 22<br />height: 68.01378<br />sex: male","age: 20<br />height: 69.14264<br />sex: male","age: 24<br />height: 69.85557<br />sex: male","age: 23<br />height: 66.03968<br />sex: male","age: 22<br />height: 63.75362<br />sex: male","age: 21<br />height: 69.93425<br />sex: male","age: 24<br />height: 64.78933<br />sex: male","age: 23<br />height: 73.64400<br />sex: male","age: 24<br />height: 73.33491<br />sex: male","age: 20<br />height: 72.17625<br />sex: male","age: 23<br />height: 70.67213<br />sex: male","age: 22<br />height: 76.31441<br />sex: male","age: 24<br />height: 70.74894<br />sex: male","age: 24<br />height: 73.64839<br />sex: male","age: 22<br />height: 69.24312<br />sex: male","age: 23<br />height: 67.91691<br />sex: male","age: 21<br />height: 65.94372<br />sex: male","age: 22<br />height: 59.22428<br />sex: male","age: 24<br />height: 66.66774<br />sex: male","age: 22<br />height: 64.05807<br />sex: male","age: 22<br />height: 66.68360<br />sex: male","age: 25<br />height: 74.88339<br />sex: male","age: 21<br />height: 71.77069<br />sex: male","age: 23<br />height: 64.18076<br />sex: male","age: 22<br />height: 67.25397<br />sex: male","age: 22<br />height: 71.23264<br />sex: male","age: 24<br />height: 71.65272<br />sex: male","age: 23<br />height: 71.98626<br />sex: male","age: 25<br />height: 71.24446<br />sex: male","age: 25<br />height: 71.21237<br />sex: male","age: 25<br />height: 69.97490<br />sex: male","age: 22<br />height: 67.22411<br />sex: male","age: 21<br />height: 70.74739<br />sex: male","age: 24<br />height: 72.55063<br />sex: male","age: 23<br />height: 66.94844<br />sex: male","age: 23<br />height: 71.06332<br />sex: male","age: 21<br />height: 68.53430<br />sex: male","age: 24<br />height: 68.20621<br />sex: male","age: 22<br />height: 73.36481<br />sex: male","age: 23<br />height: 71.19797<br />sex: male","age: 27<br />height: 71.32990<br />sex: male","age: 20<br />height: 69.23375<br />sex: male","age: 24<br />height: 60.53165<br />sex: male","age: 21<br />height: 70.43614<br />sex: male","age: 22<br />height: 73.57538<br />sex: male","age: 27<br />height: 65.62412<br />sex: male","age: 21<br />height: 77.85193<br />sex: male","age: 23<br />height: 74.40204<br />sex: male","age: 21<br />height: 70.85026<br />sex: male","age: 24<br />height: 74.21549<br />sex: male","age: 22<br />height: 58.89423<br />sex: male","age: 21<br />height: 73.22568<br />sex: male","age: 24<br />height: 74.22863<br />sex: male","age: 24<br />height: 80.99648<br />sex: male","age: 23<br />height: 70.51617<br />sex: male","age: 24<br />height: 64.16937<br />sex: male","age: 25<br />height: 69.97862<br />sex: male","age: 25<br />height: 74.03248<br />sex: male","age: 21<br />height: 73.56467<br />sex: male","age: 23<br />height: 69.19492<br />sex: male","age: 22<br />height: 67.69525<br />sex: male","age: 25<br />height: 68.34071<br />sex: male","age: 25<br />height: 73.58951<br />sex: male","age: 24<br />height: 73.91871<br />sex: male","age: 23<br />height: 67.59178<br />sex: male","age: 27<br />height: 69.44917<br />sex: male","age: 22<br />height: 74.72416<br />sex: male","age: 22<br />height: 67.92694<br />sex: male","age: 23<br />height: 75.74867<br />sex: male","age: 23<br />height: 74.70377<br />sex: male","age: 24<br />height: 66.27701<br />sex: male","age: 21<br />height: 69.78498<br />sex: male","age: 21<br />height: 69.31545<br />sex: male","age: 26<br />height: 62.78254<br />sex: male","age: 21<br />height: 64.38112<br />sex: male","age: 21<br />height: 64.94182<br />sex: male","age: 24<br />height: 71.27778<br />sex: male","age: 26<br />height: 70.02229<br />sex: male","age: 22<br />height: 73.21732<br />sex: male","age: 23<br />height: 77.88089<br />sex: male","age: 23<br />height: 68.73473<br />sex: male","age: 23<br />height: 73.11804<br />sex: male","age: 21<br />height: 79.17094<br />sex: male","age: 21<br />height: 65.65301<br />sex: male","age: 22<br />height: 69.21028<br />sex: male","age: 22<br />height: 64.28525<br />sex: male","age: 27<br />height: 69.82141<br />sex: male","age: 21<br />height: 69.85139<br />sex: male","age: 24<br />height: 72.27118<br />sex: male","age: 24<br />height: 73.14494<br />sex: male","age: 25<br />height: 72.13937<br />sex: male","age: 22<br />height: 70.24100<br />sex: male","age: 26<br />height: 64.81721<br />sex: male","age: 23<br />height: 74.03298<br />sex: male","age: 22<br />height: 69.67401<br />sex: male","age: 25<br />height: 67.51411<br />sex: male","age: 22<br />height: 65.70492<br />sex: male","age: 22<br />height: 70.83535<br />sex: male","age: 22<br />height: 72.72940<br />sex: male","age: 22<br />height: 68.88055<br />sex: male","age: 22<br />height: 71.62797<br />sex: male","age: 27<br />height: 71.90152<br />sex: male","age: 21<br />height: 71.55623<br />sex: male","age: 21<br />height: 75.32952<br />sex: male","age: 23<br />height: 70.24484<br />sex: male","age: 23<br />height: 71.05077<br />sex: male","age: 21<br />height: 70.09939<br />sex: male","age: 27<br />height: 64.26049<br />sex: male","age: 24<br />height: 70.49769<br />sex: male","age: 26<br />height: 75.99311<br />sex: male","age: 28<br />height: 71.78070<br />sex: male","age: 23<br />height: 77.38345<br />sex: male","age: 22<br />height: 74.78044<br />sex: male","age: 24<br />height: 67.49941<br />sex: male","age: 23<br />height: 68.34909<br />sex: male","age: 23<br />height: 73.20202<br />sex: male","age: 21<br />height: 65.68004<br />sex: male","age: 22<br />height: 65.40539<br />sex: male","age: 26<br />height: 75.39521<br />sex: male","age: 24<br />height: 66.36310<br />sex: male","age: 26<br />height: 71.80087<br />sex: male","age: 27<br />height: 70.48105<br />sex: male","age: 26<br />height: 67.83552<br />sex: male","age: 20<br />height: 66.06958<br />sex: male","age: 23<br />height: 64.17601<br />sex: male","age: 22<br />height: 66.70756<br />sex: male","age: 26<br />height: 62.09171<br />sex: male","age: 21<br />height: 73.53954<br />sex: male","age: 22<br />height: 62.26207<br />sex: male","age: 26<br />height: 71.83915<br />sex: male","age: 25<br />height: 67.12458<br />sex: male","age: 22<br />height: 73.85582<br />sex: male","age: 23<br />height: 68.08391<br />sex: male","age: 23<br />height: 70.65910<br />sex: male","age: 24<br />height: 72.26211<br />sex: male","age: 30<br />height: 73.03173<br />sex: male","age: 23<br />height: 66.13188<br />sex: male","age: 25<br />height: 70.38245<br />sex: male","age: 20<br />height: 70.98258<br />sex: male","age: 23<br />height: 69.59107<br />sex: male","age: 24<br />height: 74.06901<br />sex: male","age: 22<br />height: 70.59449<br />sex: male","age: 26<br />height: 72.83952<br />sex: male","age: 24<br />height: 66.65073<br />sex: male","age: 28<br />height: 75.70985<br />sex: male","age: 26<br />height: 65.89870<br />sex: male","age: 23<br />height: 72.86240<br />sex: male","age: 21<br />height: 73.52835<br />sex: male","age: 20<br />height: 74.24593<br />sex: male","age: 23<br />height: 70.15798<br />sex: male","age: 24<br />height: 60.82679<br />sex: male","age: 22<br />height: 72.48629<br />sex: male","age: 23<br />height: 68.09471<br />sex: male","age: 23<br />height: 65.21236<br />sex: male","age: 23<br />height: 63.35886<br />sex: male","age: 21<br />height: 64.90565<br />sex: male","age: 25<br />height: 68.89555<br />sex: male","age: 21<br />height: 70.80404<br />sex: male","age: 23<br />height: 69.22037<br />sex: male","age: 20<br />height: 68.38081<br />sex: male","age: 24<br />height: 69.10786<br />sex: male","age: 22<br />height: 74.50051<br />sex: male","age: 22<br />height: 69.49135<br />sex: male","age: 24<br />height: 76.58791<br />sex: male","age: 21<br />height: 75.22974<br />sex: male","age: 23<br />height: 68.47188<br />sex: male","age: 22<br />height: 75.44005<br />sex: male","age: 23<br />height: 71.72303<br />sex: male","age: 23<br />height: 74.31109<br />sex: male","age: 28<br />height: 70.60558<br />sex: male","age: 21<br />height: 68.83350<br />sex: male","age: 24<br />height: 70.42884<br />sex: male","age: 23<br />height: 72.35279<br />sex: male","age: 23<br />height: 61.01853<br />sex: male","age: 23<br />height: 66.83387<br />sex: male","age: 22<br />height: 74.11400<br />sex: male","age: 22<br />height: 69.17397<br />sex: male","age: 23<br />height: 77.71322<br />sex: male","age: 22<br />height: 69.40727<br />sex: male","age: 23<br />height: 67.23984<br />sex: male","age: 22<br />height: 74.65488<br />sex: male","age: 25<br />height: 69.67219<br />sex: male","age: 23<br />height: 72.57413<br />sex: male","age: 25<br />height: 66.18818<br />sex: male","age: 26<br />height: 72.63728<br />sex: male","age: 23<br />height: 69.38592<br />sex: male","age: 25<br />height: 70.46877<br />sex: male","age: 21<br />height: 65.28489<br />sex: male","age: 23<br />height: 73.74081<br />sex: male","age: 21<br />height: 70.76804<br />sex: male","age: 21<br />height: 69.29106<br />sex: male","age: 27<br />height: 66.78313<br />sex: male","age: 22<br />height: 68.20920<br />sex: male","age: 22<br />height: 66.15332<br />sex: male","age: 24<br />height: 69.25149<br />sex: male","age: 23<br />height: 72.16093<br />sex: male","age: 22<br />height: 74.71038<br />sex: male","age: 23<br />height: 71.41639<br />sex: male","age: 23<br />height: 71.20205<br />sex: male","age: 21<br />height: 66.87497<br />sex: male","age: 23<br />height: 72.12637<br />sex: male","age: 23<br />height: 78.04366<br />sex: male","age: 25<br />height: 69.05991<br />sex: male","age: 22<br />height: 68.28008<br />sex: male","age: 22<br />height: 64.14438<br />sex: male","age: 23<br />height: 72.62782<br />sex: male","age: 22<br />height: 65.64052<br />sex: male","age: 22<br />height: 71.32293<br />sex: male","age: 23<br />height: 70.28949<br />sex: male","age: 22<br />height: 67.41586<br />sex: male","age: 21<br />height: 68.81435<br />sex: male","age: 22<br />height: 62.36007<br />sex: male","age: 22<br />height: 66.36456<br />sex: male","age: 26<br />height: 65.66272<br />sex: male","age: 23<br />height: 66.95041<br />sex: male","age: 24<br />height: 69.41803<br />sex: male","age: 23<br />height: 66.31763<br />sex: male","age: 24<br />height: 76.80302<br />sex: male","age: 26<br />height: 69.11154<br />sex: male","age: 23<br />height: 70.83459<br />sex: male","age: 22<br />height: 73.30363<br />sex: male","age: 26<br />height: 70.37822<br />sex: male","age: 21<br />height: 72.29439<br />sex: male","age: 21<br />height: 71.60884<br />sex: male","age: 26<br />height: 69.87113<br />sex: male","age: 25<br />height: 71.72636<br />sex: male","age: 22<br />height: 71.27440<br />sex: male","age: 22<br />height: 77.13672<br />sex: male","age: 24<br />height: 67.54540<br />sex: male","age: 22<br />height: 76.64051<br />sex: male","age: 24<br />height: 74.05239<br />sex: male","age: 23<br />height: 74.27906<br />sex: male","age: 27<br />height: 69.69349<br />sex: male","age: 22<br />height: 68.67600<br />sex: male","age: 24<br />height: 72.71772<br />sex: male","age: 25<br />height: 72.91449<br />sex: male","age: 23<br />height: 75.84256<br />sex: male","age: 24<br />height: 72.71942<br />sex: male","age: 24<br />height: 67.72206<br />sex: male","age: 25<br />height: 64.40114<br />sex: male","age: 26<br />height: 66.57677<br />sex: male","age: 22<br />height: 73.20235<br />sex: male","age: 25<br />height: 63.55515<br />sex: male","age: 25<br />height: 63.35036<br />sex: male","age: 21<br />height: 68.52158<br />sex: male","age: 21<br />height: 72.19477<br />sex: male","age: 23<br />height: 74.17938<br />sex: male","age: 21<br />height: 70.74845<br />sex: male","age: 21<br />height: 73.53125<br />sex: male","age: 20<br />height: 73.29313<br />sex: male","age: 21<br />height: 68.61017<br />sex: male","age: 22<br />height: 64.28295<br />sex: male","age: 23<br />height: 70.98499<br />sex: male","age: 22<br />height: 65.11506<br />sex: male","age: 23<br />height: 71.12759<br />sex: male","age: 23<br />height: 81.27234<br />sex: male","age: 21<br />height: 66.88319<br />sex: male","age: 22<br />height: 71.58888<br />sex: male","age: 27<br />height: 67.58171<br />sex: male","age: 23<br />height: 61.56406<br />sex: male","age: 24<br />height: 65.27434<br />sex: male","age: 23<br />height: 72.35407<br />sex: male","age: 25<br />height: 67.37444<br />sex: male","age: 23<br />height: 66.09505<br />sex: male","age: 22<br />height: 73.05372<br />sex: male","age: 23<br />height: 71.77282<br />sex: male","age: 29<br />height: 71.93445<br />sex: male","age: 20<br />height: 71.89993<br />sex: male","age: 24<br />height: 66.87069<br />sex: male","age: 22<br />height: 65.14791<br />sex: male","age: 22<br />height: 70.35134<br />sex: male","age: 21<br />height: 71.46958<br />sex: male","age: 25<br />height: 72.74394<br />sex: male","age: 20<br />height: 65.64302<br />sex: male","age: 23<br />height: 64.89209<br />sex: male","age: 23<br />height: 65.00710<br />sex: male","age: 25<br />height: 80.17017<br />sex: male","age: 23<br />height: 76.85851<br />sex: male","age: 21<br />height: 77.61557<br />sex: male","age: 23<br />height: 67.16519<br />sex: male","age: 24<br />height: 68.42261<br />sex: male","age: 23<br />height: 68.23853<br />sex: male","age: 23<br />height: 79.28650<br />sex: male","age: 25<br />height: 69.28323<br />sex: male","age: 25<br />height: 70.06931<br />sex: male","age: 22<br />height: 73.13102<br />sex: male","age: 22<br />height: 76.73422<br />sex: male","age: 21<br />height: 72.66391<br />sex: male","age: 20<br />height: 65.42865<br />sex: male","age: 24<br />height: 62.16695<br />sex: male","age: 22<br />height: 79.17272<br />sex: male","age: 23<br />height: 74.71207<br />sex: male","age: 21<br />height: 74.86617<br />sex: male","age: 25<br />height: 66.06161<br />sex: male","age: 26<br />height: 72.38980<br />sex: male","age: 22<br />height: 68.72967<br />sex: male","age: 25<br />height: 61.44017<br />sex: male","age: 22<br />height: 64.17996<br />sex: male","age: 22<br />height: 73.07103<br />sex: male","age: 24<br />height: 67.96845<br />sex: male","age: 21<br />height: 69.93198<br />sex: male","age: 24<br />height: 70.96865<br />sex: male","age: 21<br />height: 76.53438<br />sex: male","age: 23<br />height: 74.86537<br />sex: male","age: 21<br />height: 72.71367<br />sex: male","age: 23<br />height: 73.57478<br />sex: male","age: 23<br />height: 65.66427<br />sex: male","age: 25<br />height: 71.04690<br />sex: male","age: 20<br />height: 70.69665<br />sex: male","age: 24<br />height: 70.36843<br />sex: male","age: 24<br />height: 78.57188<br />sex: male","age: 23<br />height: 73.50933<br />sex: male","age: 22<br />height: 67.27768<br />sex: male","age: 20<br />height: 67.82029<br />sex: male","age: 25<br />height: 73.53252<br />sex: male","age: 23<br />height: 71.59114<br />sex: male","age: 25<br />height: 69.05920<br />sex: male","age: 22<br />height: 68.61907<br />sex: male","age: 22<br />height: 62.70427<br />sex: male","age: 22<br />height: 70.64783<br />sex: male","age: 24<br />height: 77.89336<br />sex: male","age: 22<br />height: 68.16768<br />sex: male","age: 26<br />height: 64.07455<br />sex: male","age: 23<br />height: 72.40197<br />sex: male","age: 21<br />height: 73.07285<br />sex: male","age: 23<br />height: 77.09982<br />sex: male","age: 22<br />height: 71.01857<br />sex: male","age: 26<br />height: 66.22123<br />sex: male","age: 24<br />height: 70.08686<br />sex: male","age: 25<br />height: 69.50151<br />sex: male","age: 23<br />height: 72.94357<br />sex: male","age: 23<br />height: 67.13090<br />sex: male","age: 22<br />height: 70.17661<br />sex: male","age: 23<br />height: 71.05780<br />sex: male","age: 23<br />height: 73.89132<br />sex: male","age: 22<br />height: 71.62017<br />sex: male","age: 24<br />height: 68.96405<br />sex: male","age: 21<br />height: 70.69893<br />sex: male","age: 22<br />height: 68.50207<br />sex: male","age: 27<br />height: 66.09040<br />sex: male","age: 23<br />height: 71.18765<br />sex: male","age: 23<br />height: 75.21033<br />sex: male","age: 25<br />height: 70.31434<br />sex: male","age: 23<br />height: 65.08096<br />sex: male","age: 23<br />height: 78.23578<br />sex: male","age: 23<br />height: 70.44304<br />sex: male","age: 21<br />height: 67.66816<br />sex: male","age: 25<br />height: 73.61925<br />sex: male","age: 25<br />height: 71.64561<br />sex: male","age: 21<br />height: 66.30589<br />sex: male","age: 21<br />height: 67.51826<br />sex: male","age: 22<br />height: 68.78472<br />sex: male","age: 20<br />height: 69.28002<br />sex: male","age: 24<br />height: 69.07932<br />sex: male","age: 22<br />height: 74.33193<br />sex: male","age: 24<br />height: 68.24094<br />sex: male","age: 25<br />height: 67.82720<br />sex: male","age: 22<br />height: 65.47909<br />sex: male","age: 23<br />height: 71.05353<br />sex: male","age: 22<br />height: 74.43194<br />sex: male","age: 28<br />height: 67.88179<br />sex: male","age: 21<br />height: 67.94780<br />sex: male","age: 22<br />height: 74.81909<br />sex: male","age: 21<br />height: 68.52799<br />sex: male","age: 23<br />height: 59.58776<br />sex: male","age: 23<br />height: 65.20703<br />sex: male","age: 22<br />height: 83.22736<br />sex: male","age: 21<br />height: 66.74185<br />sex: male","age: 25<br />height: 69.75061<br />sex: male","age: 23<br />height: 64.84715<br />sex: male","age: 20<br />height: 73.11295<br />sex: male","age: 23<br />height: 67.22994<br />sex: male","age: 22<br />height: 71.26826<br />sex: male","age: 23<br />height: 68.30652<br />sex: male","age: 29<br />height: 69.15872<br />sex: male","age: 23<br />height: 68.77501<br />sex: male","age: 23<br />height: 68.43274<br />sex: male","age: 22<br />height: 71.30340<br />sex: male","age: 22<br />height: 70.82540<br />sex: male","age: 22<br />height: 66.56249<br />sex: male","age: 26<br />height: 72.50222<br />sex: male","age: 21<br />height: 72.57461<br />sex: male","age: 26<br />height: 69.27666<br />sex: male","age: 27<br />height: 69.51229<br />sex: male","age: 24<br />height: 67.90562<br />sex: male","age: 21<br />height: 70.03415<br />sex: male","age: 24<br />height: 66.76336<br />sex: male","age: 25<br />height: 74.11119<br />sex: male","age: 25<br />height: 68.63176<br />sex: male","age: 20<br />height: 74.04527<br />sex: male","age: 23<br />height: 69.94066<br />sex: male","age: 22<br />height: 68.95122<br />sex: male","age: 21<br />height: 69.76570<br />sex: male","age: 22<br />height: 73.15117<br />sex: male","age: 21<br />height: 76.71504<br />sex: male","age: 22<br />height: 68.89024<br />sex: male","age: 20<br />height: 66.27344<br />sex: male","age: 22<br />height: 70.19152<br />sex: male","age: 22<br />height: 72.70902<br />sex: male","age: 24<br />height: 68.79078<br />sex: male","age: 22<br />height: 72.99230<br />sex: male","age: 22<br />height: 66.12910<br />sex: male","age: 22<br />height: 62.87452<br />sex: male","age: 22<br />height: 63.05538<br />sex: male","age: 25<br />height: 75.88807<br />sex: male","age: 25<br />height: 69.33251<br />sex: male","age: 25<br />height: 69.00470<br />sex: male","age: 21<br />height: 74.89536<br />sex: male","age: 21<br />height: 70.14041<br />sex: male","age: 24<br />height: 74.65024<br />sex: male","age: 23<br />height: 65.63065<br />sex: male","age: 21<br />height: 70.02521<br />sex: male","age: 26<br />height: 63.04927<br />sex: male","age: 24<br />height: 73.22752<br />sex: male","age: 23<br />height: 70.88825<br />sex: male","age: 21<br />height: 72.62977<br />sex: male","age: 21<br />height: 73.79464<br />sex: male","age: 24<br />height: 72.86468<br />sex: male","age: 21<br />height: 72.49019<br />sex: male","age: 25<br />height: 66.64290<br />sex: male","age: 21<br />height: 64.16744<br />sex: male","age: 23<br />height: 71.03682<br />sex: male","age: 23<br />height: 72.81401<br />sex: male","age: 20<br />height: 68.07922<br />sex: male","age: 27<br />height: 67.37100<br />sex: male","age: 25<br />height: 69.01623<br />sex: male","age: 23<br />height: 71.65808<br />sex: male","age: 22<br />height: 64.20500<br />sex: male","age: 22<br />height: 71.09749<br />sex: male","age: 21<br />height: 63.38150<br />sex: male","age: 23<br />height: 63.59220<br />sex: male","age: 23<br />height: 74.57454<br />sex: male","age: 20<br />height: 70.84921<br />sex: male","age: 22<br />height: 74.68463<br />sex: male","age: 24<br />height: 69.19880<br />sex: male","age: 25<br />height: 74.08449<br />sex: male","age: 25<br />height: 71.55082<br />sex: male","age: 25<br />height: 76.59449<br />sex: male","age: 20<br />height: 71.00471<br />sex: male","age: 21<br />height: 68.51334<br />sex: male","age: 23<br />height: 67.14383<br />sex: male","age: 23<br />height: 73.14191<br />sex: male","age: 24<br />height: 62.99996<br />sex: male","age: 27<br />height: 73.00505<br />sex: male","age: 23<br />height: 71.62384<br />sex: male","age: 24<br />height: 66.22153<br />sex: male","age: 20<br />height: 74.13769<br />sex: male","age: 21<br />height: 64.88217<br />sex: male","age: 23<br />height: 77.51074<br />sex: male","age: 23<br />height: 64.20075<br />sex: male","age: 22<br />height: 72.37295<br />sex: male","age: 21<br />height: 67.66814<br />sex: male","age: 26<br />height: 72.50363<br />sex: male","age: 22<br />height: 72.94364<br />sex: male","age: 25<br />height: 75.07671<br />sex: male","age: 24<br />height: 70.04403<br />sex: male","age: 21<br />height: 72.37490<br />sex: male","age: 21<br />height: 68.04342<br />sex: male","age: 23<br />height: 71.70911<br />sex: male","age: 24<br />height: 71.90542<br />sex: male","age: 23<br />height: 69.74876<br />sex: male","age: 23<br />height: 67.52650<br />sex: male","age: 21<br />height: 65.15445<br />sex: male","age: 22<br />height: 70.71876<br />sex: male","age: 21<br />height: 66.76669<br />sex: male","age: 27<br />height: 71.19778<br />sex: male","age: 21<br />height: 70.36674<br />sex: male","age: 23<br />height: 60.77185<br />sex: male","age: 25<br />height: 76.88856<br />sex: male","age: 23<br />height: 73.82146<br />sex: male"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"male","legendgroup":"male","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":29.0178497301785,"r":9.29846409298464,"b":52.2015774180158,"l":48.4821917808219},"font":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[19.2960838856315,30.4098540630983],"tickmode":"array","ticktext":["20.0","22.5","25.0","27.5","30.0"],"tickvals":[20,22.5,25,27.5,30],"categoryorder":"array","categoryarray":["20.0","22.5","25.0","27.5","30.0"],"nticks":null,"ticks":"outside","tickcolor":"rgba(0,0,0,1)","ticklen":4.64923204649232,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"tickangle":-0,"showline":true,"linecolor":"rgba(0,0,0,1)","linewidth":0.66417600664176,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"y","title":"age","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[51.3264037909755,84.7464490440745],"tickmode":"array","ticktext":["60","70","80"],"tickvals":[60,70,80],"categoryorder":"array","categoryarray":["60","70","80"],"nticks":null,"ticks":"outside","tickcolor":"rgba(0,0,0,1)","ticklen":4.64923204649232,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"tickangle":-0,"showline":true,"linecolor":"rgba(0,0,0,1)","linewidth":0.66417600664176,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"x","title":"height","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":null,"bordercolor":null,"borderwidth":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"y":0.889763779527559},"annotations":[{"text":"sex","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"cloud":false},"source":"A","attrs":{"e06c663449c8":{"x":{},"y":{},"fill":{},"type":"scatter"}},"cur_data":"e06c663449c8","visdat":{"e06c663449c8":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script><!--/html_preserve-->

<div class="info">
<p>Hover over the data points above and click on the legend items.</p>
</div>

## Exercises

Download the [formative exercises](formative_exercises/03_ggplot_stub.Rmd). See the [answer demo](formative_exercises/03_ggplot_answers.html) to see what your plots should look like (this doesn't contain the answer code).


### Common Plots

Generate a violin plot, boxplot, histogram, density plot, and column plot for the following data. 


```r
# dog weights estimated from http://petobesityprevention.org/ideal-weight-ranges/

dogs <- tibble(
  breed = rep(c("beagle", "boxer", "bulldog"), each = 100),
  weight = c(
    rnorm(100, 24, 6),
    rnorm(100, 62.5, 12.5),
    rnorm(100, 45, 5)
  )
)
```

*Basic*: Create each plot.

*Intermediate*: Change the axis labels and colours. Save each plot as a PNG file.

*Advanced*: Create a grid of the first four plot styles (exclude the column plot). In your RMarkdown file, display just the graph, but not the `r` code for the graph.


### Two continuous variables

Represent the relationships among moral, sexual and pathogen disgust scores from the dataset [disgust_scores.csv](data/disgust_scores.csv). 

*Basic*: Graph the linear relationship between moral and pathogen disgust. Make sure the axes run from the minimum to maximum possible scores on both axes. Give the graph an appropriate title and axis lables.
  
  
*Intermediate*: Create a 2d density plot of the relationship between pathogen and sexual disgust. 

Use `stat_density_2d(aes(fill = ..level..), geom = "polygon", n = ?, 
h = c(?, ?))`, set n and h to values that make the graph look good, and 
figure out what `n` and `h` represent.

*Advanced*: Create a 3x3 grid of plots with columns representing the x-axis and 
rows representing the y-axis. Put a density plot of each variable along the 
diagonal. Make sure the graphs have appropriate titles and axis labels and 
that the range of the axes are the same in all graphs.

|              | moral   | sexual  | pathogen |
|--------------|---------|---------|----------|
| **moral**    | density | line    | line     | 
| **sexual**   | line    | density | line     |
| **pathogen** | line    | line    | density  |



### Many correlated variables

*Basic*: Create a heatmap of the relationships among all the questions in 
[disgust_cors.csv](data/disgust_cors.csv) 
(the correlations have already been calculated for you). 

*Intermediate*: Figure out how to rotate the text on the x-axis so it's readable.
