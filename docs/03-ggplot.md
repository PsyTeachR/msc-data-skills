
# Data Visualisation {#ggplot}

Take the [quiz](#ggplot-quiz) to see if you need to review this chapter.

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
4. Represent factorial designs with different colours or facets
5. [Save plots](#ggsave) as an image file
    
### Intermediate

6. Superimpose different types of graphs
7. Add lines to graphs
8. Deal with [overlapping data](#overlap)
9. Create less common types of graphs
    + [`geom_tile()`](#geom_tile)
    + [`geom_density2d()`](#geom_density2d)
    + [`geom_bin2d()`](#geom_bin2d)
    + [`geom_hex()`](#geom_hex)
    + [`geom_count()`](#geom_count)
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
* `pet_happy` has `happiness` and `age` for 500 dog owners and 500 cat owners
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

pet_happy <- tibble(
  pet = rep(c("dog", "cat"), each = 500),
  happiness = c(rnorm(500, 55, 10), rnorm(500, 45, 10)),
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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/barplot-1.png" alt="Bar plot" width="100%" />
<p class="caption">(\#fig:barplot)Bar plot</p>
</div>

### Density plot
<a name="geom_density"></a>
Density plots are good for one continuous variable, but only if you have a fairly 
large number of observations.


```r
ggplot(pet_happy, aes(happiness)) +
  geom_density()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density-1.png" alt="Density plot" width="100%" />
<p class="caption">(\#fig:density)Density plot</p>
</div>

You can represent subsets of a variable by assigning the category variable to 
the argument `group`, `fill`, or `color`. 


```r
ggplot(pet_happy, aes(happiness, fill = pet)) +
  geom_density(alpha = 0.5)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density-grouped-1.png" alt="Grouped density plot" width="100%" />
<p class="caption">(\#fig:density-grouped)Grouped density plot</p>
</div>

<div class="try">
<p>Try changing the <code>alpha</code> argument to figure out what it does.</p>
</div>

### Frequency Polygons {#geom_freqpoly}

If you don't want smoothed distributions, try `geom_freqpoly()`.


```r
ggplot(pet_happy, aes(happiness, color = pet)) +
  geom_freqpoly(binwidth = 1)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/freqpoly-1.png" alt="Frequency ploygon plot" width="100%" />
<p class="caption">(\#fig:freqpoly)Frequency ploygon plot</p>
</div>

<div class="try">
<p>Try changing the <code>binwidth</code> argument to 5 and 0.1. How do you figure out the right value?</p>
</div>

### Histogram {#geom_histogram}

Histograms are also good for one continuous variable, and work well if you don't have many observations. Set the `binwidth` to control how wide each bar is.


```r
ggplot(pet_happy, aes(happiness)) +
  geom_histogram(binwidth = 1, fill = "white", color = "black")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/histogram-1.png" alt="Histogram" width="100%" />
<p class="caption">(\#fig:histogram)Histogram</p>
</div>

<div class="info">
<p>Histograms in ggplot look pretty bad unless you set the <code>fill</code> and <code>color</code>.</p>
</div>

If you show grouped histograms, you also probably want to change the default `position` argument.


```r
ggplot(pet_happy, aes(happiness, fill=pet)) +
  geom_histogram(binwidth = 1, alpha = 0.5, position = "dodge")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/histogram-grouped-1.png" alt="Grouped Histogram" width="100%" />
<p class="caption">(\#fig:histogram-grouped)Grouped Histogram</p>
</div>

<div class="try">
<p>Try changing the <code>position</code> argument to &quot;identity&quot;, &quot;fill&quot;, &quot;dodge&quot;, or &quot;stack&quot;.</p>
</div>

### Column plot {#geom_col}

Column plots are the worst way to represent grouped continuous data, but also one of the most common.

To make column plots with error bars, you first need to calculate the means, error bar uper limits (`ymax`) and error bar lower limits (`ymin`) for each category. You'll learn more about how to use the code below in the next two lessons.


```r
# calculate mean and SD for each pet
pet_happy %>%
  group_by(pet) %>%
  summarise(
    mean = mean(happiness),
    sd = sd(happiness)
  ) %>%
ggplot(aes(pet, mean, fill=pet)) +
  geom_col(alpha = 0.5) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.25) +
  geom_hline(yintercept = 40)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/colplot-1.png" alt="Column plot" width="100%" />
<p class="caption">(\#fig:colplot)Column plot</p>
</div>

<div class="try">
<p>What do you think <code>geom_hline()</code> does?</p>
</div>

### Boxplot {#geom_boxplot}

Boxplots are great for representing the distribution of grouped continuous 
variables. They fix most of the problems with using barplots for continuous data.


```r
ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_boxplot(alpha = 0.5)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/boxplot-1.png" alt="Box plot" width="100%" />
<p class="caption">(\#fig:boxplot)Box plot</p>
</div>

### Violin plot {#geom_violin}

Violin pots are like sideways, mirrored density plots. They give even more information than a boxplot about distribution and are especially useful when you have non-normal distributions.


```r
ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.25, 0.5, 0.75), 
    alpha = 0.5
  )
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violin-1.png" alt="Violin plot" width="100%" />
<p class="caption">(\#fig:violin)Violin plot</p>
</div>

<div class="try">
<p>Try changing the numbers in the <code>draw_quantiles</code> argument.</p>
</div>


### Scatter plot {#geom_point}

Scatter plots are a good way to represent the relationship between two continuous variables.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_point()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/scatter-1.png" alt="Scatter plot using geom_point()" width="100%" />
<p class="caption">(\#fig:scatter)Scatter plot using geom_point()</p>
</div>

### Line graph {#geom_smooth}

You often want to represent the relationship as a single line.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_smooth(method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-1.png" alt="Line plot using geom_smooth()" width="100%" />
<p class="caption">(\#fig:line)Line plot using geom_smooth()</p>
</div>
 
 
## Save as File
<a name="ggsave"></a>
You can save a ggplot using `ggsave()`. It saves the last ggplot you made, 
by default, but you can specify which plot you want to save if you assigned that 
plot to a variable.

You can set the `width` and `height` of your plot. The default units are inches, 
but you can change the `units` argument to "in", "cm", or "mm".



```r
box <- ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_boxplot(alpha = 0.5)

violin <- ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_violin(alpha = 0.5)

ggsave("demog_violin_plot.png", width = 5, height = 7)

ggsave("demog_box_plot.jpg", plot = box, width = 5, height = 7)
```


## Combination Plots

### Violinbox plot

To demonstrate the use of `facet_grid()` for factorial designs, we create a new 
column called `agegroup` to split the data into participants older than the 
meadian age or younger than the median age. New factors will display in alphabetical order, so we can use the `factor()` function to set the levels in the order we want.


```r
pet_happy %>%
  mutate(agegroup = ifelse(age<median(age), "Younger", "Older"),
         agegroup = factor(agegroup, levels = c("Younger", "Older"))) %>%
  ggplot(aes(pet, happiness, fill=pet)) +
    geom_violin(trim = FALSE, alpha=0.5, show.legend = FALSE) +
    geom_boxplot(width = 0.25, fill="white") +
    facet_grid(.~agegroup) +
    scale_fill_manual(values = c("orange", "green"))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violinbox-1.png" alt="Violin-box plot" width="100%" />
<p class="caption">(\#fig:violinbox)Violin-box plot</p>
</div>

<div class="info">
<p>Set the <code>show.legend</code> argument to <code>FALSE</code> to hide the legend. We do this here because the x-axis already labels the pet types.</p>
</div>

### Violin-point-range plot

You can use `stat_summary()` to superimpose a point-range plot showning the mean ± 1 SD. You'll learn how to write your own functions in the lesson on [Iteration and Functions](#func).


```r
ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_violin(
    trim = FALSE,
    alpha = 0.5
  ) +
  stat_summary(
    fun.y = mean,
    fun.ymax = function(x) {mean(x) + sd(x)},
    fun.ymin = function(x) {mean(x) - sd(x)},
    geom="pointrange"
  )
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/stat-summary-1.png" alt="Point-range plot using stat_summary()" width="100%" />
<p class="caption">(\#fig:stat-summary)Point-range plot using stat_summary()</p>
</div>

### Violin-jitter plot

If you don't have a lot of data points, it's good to represent them individually. 
You can use `geom_point` to do this, setting `position` to "jitter".


```r
pet_happy %>%
  sample_n(50) %>%  # choose 50 random observations from the dataset
  ggplot(aes(pet, happiness, fill=pet)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.25, 0.5, 0.75), 
    alpha = 0.5
  ) + 
  geom_point(position = "jitter", alpha = 0.7, size = 3)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violin-jitter-1.png" alt="Violin-jitter plot" width="100%" />
<p class="caption">(\#fig:violin-jitter)Violin-jitter plot</p>
</div>

### Scatter-line graph

If your graph isn't too complicated, it's good to also show the individual data 
points behind the line.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/scatter_line-1.png" alt="Scatter-line plot" width="100%" />
<p class="caption">(\#fig:scatter_line)Scatter-line plot</p>
</div>

### Grid of plots {#cowplot}

You can use the [ `cowplot`](https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html) package to easily make grids of different graphs. First, you have to assign each plot a name. Then you list all the plots as the first arguments of `plot_grid()` and provide a list of labels.


```r
library(cowplot)

my_hist <- ggplot(pet_happy, aes(happiness, fill=pet)) +
  geom_histogram(
    binwidth = 1, 
    alpha = 0.5, 
    position = "dodge", 
    show.legend = FALSE
  )

my_violin <- ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.5), 
    alpha = 0.5, 
    show.legend = FALSE
  )

my_box <- ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_boxplot(alpha=0.5, show.legend = FALSE)

my_density <- ggplot(pet_happy, aes(happiness, fill=pet)) +
  geom_density(alpha=0.5, show.legend = FALSE)

my_bar <- pet_happy %>%
  group_by(pet) %>%
  summarise(
    mean = mean(happiness),
    sd = sd(happiness)
  ) %>%
  ggplot(aes(pet, mean, fill=pet)) +
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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/cowplot-1.png" alt="Grid of plots using cowplot" width="100%" />
<p class="caption">(\#fig:cowplot)Grid of plots using cowplot</p>
</div>

<div class="info">
<p>{#theme} Once you load the cowplot package, your ggplot default theme will change. You can get back the default ggplot theme with <code>+ theme_set(theme_grey())</code>.</p>
</div>

## Overlapping Data {#overlap}

### Discrete Data 

You can deal with overlapping data points (very common if you're using Likert scales) by reducing the opacity of the points. You need to use trial and error to adjust these so they look right.


```r
ggplot(overlap, aes(x, y)) +
  geom_point(size = 5, alpha = .05) +
  geom_smooth(method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap_alpha-1.png" alt="Deal with overlapping data using transparency" width="100%" />
<p class="caption">(\#fig:overlap_alpha)Deal with overlapping data using transparency</p>
</div>

{#geom_count}
Or you can set the size of the dot proportional to the number of overlapping 
observations using `geom_count()`.


```r
overlap %>%
  ggplot(aes(x, y)) +
  geom_count(color = "#663399")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap_size-1.png" alt="Deal with overlapping data using geom_count()" width="100%" />
<p class="caption">(\#fig:overlap_size)Deal with overlapping data using geom_count()</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap-colour-1.png" alt="Deal with overlapping data using dot colour" width="100%" />
<p class="caption">(\#fig:overlap-colour)Deal with overlapping data using dot colour</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overplot-point-1.png" alt="Overplotted data" width="100%" />
<p class="caption">(\#fig:overplot-point)Overplotted data</p>
</div>

{#geom_density2d}
Use `geom_density2d()` to create a contour map.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_density2d()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density2d-1.png" alt="Contour map with geom_density2d()" width="100%" />
<p class="caption">(\#fig:density2d)Contour map with geom_density2d()</p>
</div>

You can use `stat_density_2d(aes(fill = ..level..), geom = "polygon")` to create 
a heatmap-style density plot. 


```r
overplot %>%
  ggplot(aes(x, y)) + 
  stat_density_2d(aes(fill = ..level..), geom = "polygon") +
  scale_fill_viridis()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density2d-fill-1.png" alt="Heatmap-density plot" width="100%" />
<p class="caption">(\#fig:density2d-fill)Heatmap-density plot</p>
</div>


{#geom_bin2d}
Use `geom_bin2d()` to create a rectangular heatmap of bin counts. Set the 
`binwidth` to the x and y dimensions to capture in each box.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_bin2d(binwidth = c(1,1))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/bin2d-1.png" alt="Heatmap of bin counts" width="100%" />
<p class="caption">(\#fig:bin2d)Heatmap of bin counts</p>
</div>

{#geom_hex}
Use `geomhex()` to create a hexagonal heatmap of bin counts. Adjust the 
`binwidth`, `xlim()`, `ylim()` and/or the figure dimensions to make the hexagons 
more or less stretched.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_hex(binwidth = c(0.25, 0.25))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overplot-hex-1.png" alt="Hexagonal heatmap of bin counts" width="100%" />
<p class="caption">(\#fig:overplot-hex)Hexagonal heatmap of bin counts</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/heatmap-1.png" alt="Heatmap using geom_tile()" width="100%" />
<p class="caption">(\#fig:heatmap)Heatmap using geom_tile()</p>
</div>

<div class="info">
<p>The file type is set from the filename suffix, or by specifying the argument <code>device</code>, which can take the following values: &quot;eps&quot;, &quot;ps&quot;, &quot;tex&quot;, &quot;pdf&quot;, &quot;jpeg&quot;, &quot;tiff&quot;, &quot;png&quot;, &quot;bmp&quot;, &quot;svg&quot; or &quot;wmf&quot;.</p>
</div>

## Interactive Plots {#plotly}

You can use the `plotly` package to make interactive graphs. Just assign your 
ggplot to a variable and use the function `ggplotly()`.


```r
demog_plot <- ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_point(position = position_jitter(width= 0.2, height = 0), size = 2)

ggplotly(demog_plot)
```

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-b844bb8f4df2d64d1834" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-b844bb8f4df2d64d1834">{"x":{"data":[{"x":[1.01544506037608,0.923629179690033,1.06778024705127,0.85562459519133,0.866980055067688,0.980829780828208,0.951409326959401,1.17531926799566,1.14545475393534,1.11507620792836,1.19047487778589,1.04919033423066,0.818975021969527,0.908173495903611,1.09109468096867,1.02687527975068,1.08533838298172,0.867327738180757,1.08422076543793,0.88226466178894,0.92164714243263,1.19744813665748,0.928207770548761,1.04088134150952,0.891270747222006,1.08036445789039,1.05084162047133,1.01955185187981,0.915299824345857,1.13689174195752,0.973170550912619,1.14253968847916,0.987420512270182,1.07710490515456,1.03885073689744,0.841775402240455,0.902806874644011,1.13648870633915,0.923127058986574,1.07328384323046,0.927440971322358,1.02417820403352,1.0112583482638,1.10616046339273,1.0391635642387,0.979188514128327,1.08537029949948,1.12043206719682,1.00741304056719,1.08424175614491,1.18579161465168,0.812785597704351,0.985857655946165,0.804227524250746,1.0547317346558,0.88760594651103,1.09525768943131,0.813860666751862,0.91950901215896,1.0353728835471,0.920294116158038,1.15779560906813,0.82904878212139,1.01694648889825,0.929775981046259,0.817301984876394,1.13680088007823,1.03146325778216,0.823917463049293,1.07977982098237,0.821755352336913,1.00779059249908,0.924297009687871,1.18653745567426,1.16412772005424,0.851053062546998,0.819704423937947,0.996720588207245,0.901599792018533,0.823632289655507,0.810100665781647,1.130900891684,0.851552940905094,0.927619332168251,1.17625569906086,0.834030851256102,0.918849383387715,1.05366784753278,0.914370690099895,0.845361996907741,1.17508595380932,1.18276336733252,1.01815299214795,1.1497659470886,1.04998081699014,0.955453880224377,1.08465376691893,1.02025797022507,0.990780052542686,0.866043476480991,0.928769166953862,0.93394949445501,0.864874362107366,0.953227192722261,1.19977129818872,1.05304712858051,0.81835747435689,1.03380665648729,1.11159247411415,0.980325927305967,1.08045396860689,1.1842527163215,1.14613729724661,1.13471693415195,0.94195394385606,1.08422036627308,0.823384888656437,0.932486123405397,1.11475216569379,1.17863170383498,0.945135156717151,0.826146709732711,0.808625243324786,1.19472686406225,1.03299940526485,0.897375417407602,1.08034600578248,1.11659459844232,1.16731790397316,0.893753813114017,0.930038685165346,1.0595224593766,1.00277293967083,0.933669185452163,0.928644593898207,1.13120778203011,1.12970013711601,0.851925616525114,1.03879261789843,0.820132302865386,1.09829826513305,0.994887951761484,1.16130841793492,1.18755333516747,0.893237324710935,1.15857815500349,1.03432439696044,1.19498746367171,0.825524493679404,0.812981289904565,0.880151820369065,0.97766085145995,0.846505421679467,1.1039483207278,0.871122035104781,1.14191749887541,1.07030389765278,1.18302352502942,1.1088789912872,0.879529690090567,1.0845532214269,1.02850929601118,1.07862565852702,0.931050122436136,0.996726693958044,1.17774766143411,1.02476572375745,1.09767178613693,0.872417028900236,0.918285685218871,0.875657754670829,1.1719505591318,0.971056753955782,0.84436381245032,1.00900582689792,0.900045166071504,0.92424261784181,0.886902210209519,0.952619267720729,1.04830132117495,1.14177316576242,0.838244310487062,0.934475175663829,0.903371088858694,0.931071389745921,0.817140312958509,1.16224801894277,1.09663573214784,1.08261471632868,0.884813516121358,1.09052980979905,1.09954252205789,0.833905342407525,1.14767962666228,0.9576231979765,1.06365591781214,0.837103052902967,1.13036383893341,1.03954212535173,1.10701911132783,0.917297355644405,0.844130897335708,0.894089672435075,1.0511777235195,0.883856254722923,1.07688575247303,0.861187374126166,0.934436869807541,1.01542869685218,1.19924759259447,1.09913152530789,0.936284709814936,0.832951619662344,0.80629293192178,0.841035024169832,1.01911064404994,1.00436701616272,0.895358487591147,1.16511242408305,0.811092738620937,0.840241597872227,0.839902824256569,0.905751811806113,1.03793235505,0.821957343351096,1.0223415712826,0.893273929134011,1.0885267960839,1.10483845816925,1.16495819408447,0.887462203390896,1.18451553592458,0.865120414365083,1.10949188051745,1.09552968833596,0.827931839972734,1.00931218117476,1.02617538440973,0.939695557951927,0.83339390931651,1.10522495983168,0.929576004762202,1.1597768583335,0.938337279576808,0.821731214690953,0.951258250977844,1.01642091292888,0.902754730265588,0.910507362242788,0.865531827602535,1.06934281084687,0.895912392716855,1.06576451612636,0.884391075093299,1.19032608196139,0.805544898938388,1.18423898015171,1.1517531006597,1.15938947414979,0.803632232919335,1.06992929577827,0.882583459280431,0.90576575724408,0.872652293555438,1.10233798585832,0.875024163443595,0.821511844545603,1.01765965810046,1.07900113379583,1.19896756056696,1.05465992083773,0.900782931223512,1.13053873162717,1.13691319637001,1.14053216297179,1.0750245153904,1.03054999243468,1.14597187712789,1.1209420231171,1.13748843502253,0.874272683542222,0.856115016061813,0.882011661864817,0.971730844397098,0.909183091390878,0.896435722149909,0.856908674072474,0.934843559656292,1.08518855273724,0.996167882531881,1.0358245880343,1.05791827663779,1.16339857438579,1.06661843843758,1.1126703562215,1.17683824263513,1.04250901918858,1.02596465582028,1.04380441075191,1.04891845611855,0.893499764427543,1.14214354585856,1.11552299130708,0.913398583233356,1.04714920725673,1.00794947715476,1.19897032761946,0.862242824118584,1.04814549041912,0.96410501440987,1.07396491775289,0.810528449527919,0.951786770951003,1.16011105626822,1.15053023062646,0.897683705855161,1.01908460380509,0.894933754671365,1.12336828634143,0.851470340229571,1.1227984319441,1.08847702741623,0.812138146720827,0.875786655209959,0.800334434770048,1.15970587953925,1.07773059448227,1.15088378917426,0.92825153619051,0.833242311514914,1.00066503314301,1.03078848049045,0.957657479029149,1.09072823561728,1.19086652770638,1.03622254505754,1.12510019242764,1.03402737528086,1.18643587278202,0.857776369061321,1.036915055383,0.809576465934515,1.14255362013355,0.935151580255479,1.00886914357543,0.825658602826297,0.927743765991181,0.931778463721275,1.14596840133891,1.00944189345464,1.11750344885513,0.950174987129867,1.09281272580847,1.18303392492235,0.889864972420037,0.929557622410357,1.10089708315209,1.04249195372686,1.11629618387669,0.847487366665155,1.06653662761673,0.96163532640785,0.926138123404235,0.808502965327352,0.966394100524485,1.16573353465647,0.901184441056103,0.82176913972944,1.14411347657442,1.01989153474569,0.936851343419403,0.947522936481982,1.03059229347855,1.19393186466768,1.09455265672877,1.09267544904724,0.967566841188818,1.15139313181862,1.12348843328655,1.11385249672458,1.0237985198386,0.978640021011233,0.96136464336887,0.96826201910153,1.17290647234768,0.930097239371389,1.04981968514621,1.02990484042093,0.921088815853,1.03982702484354,1.11432759892195,1.10466391453519,0.954458977747709,1.10975758507848,0.878661328088492,1.06823636190966,0.956408449821174,0.886541364900768,1.04715792583302,1.19637594632804,1.14444927768782,0.974721561092883,1.186244133953,0.804227239266038,0.843879375699908,0.985710379295051,0.968099545873702,0.929724412038922,0.964574888069183,1.10806385073811,0.980085915606469,0.880071560945362,1.17839733632281,0.844506257586181,1.18967815795913,0.920097812917083,0.857485663425177,0.99066693847999,0.863427736982703,1.07786198370159,0.964068047422916,1.15876274472103,0.86050283126533,1.1404273419641,0.932666853070259,0.824203733820468,0.912049333844334,0.922651344258338,0.909125095885247,0.937904415931553,1.08546566711739,0.99829796180129,1.10070187244564,1.0937024503015,0.923325862828642,1.01295903297141,1.102887870837,1.15513851894066,1.14570961045101,1.10351508334279,0.965835198294371,1.07356308177114,1.02793872682378,0.905483248177916,1.10492000253871,1.09871648168191,1.16539946831763,0.919503462128341,1.09643233027309,1.08202193221077,1.08213032837957,1.07747974479571,0.842382766399533,0.862909633014351,0.994624822679907,0.968320120684803,0.901945887692273,1.16429443350062,0.811160062812269,0.950009842868894,0.959208372142166,0.809729689266533,1.04265039265156,1.08168612765148,1.19370416356251,1.12204267214984,0.944855266623199,0.862946354039013,1.06701516527683,0.801193725783378,0.892826045211405,1.0616777272895,0.869974142406136,0.813760476093739,1.03941793134436,0.900955036655068,1.10457756798714,1.13793881423771,1.17155153090134,1.10322027653456,1.1444304372184,0.986677228845656,0.805207823589444,1.14906540466473,1.01205139365047,0.917329554259777,1.0026805229485,1.08927004197612,1.16013142466545,0.824511219188571,0.893445061799139,0.813046109117568,0.809855250827968,0.890455539524555,0.815364520717412,1.16717612296343,1.18061637850478,0.911648995243013,1.04910710304976,1.11716684466228],"y":[60.3993280066307,49.2667100359068,34.7373150587626,38.0969299607942,35.4608618080806,27.443840550856,52.7817560629419,44.4100312282574,52.064191565187,41.8044626044599,36.7300048370598,43.3783313466196,45.1331971856659,56.2342648416459,52.2488255775302,48.8210511756453,43.2713595932256,35.2412096280491,49.5710135576596,39.0167596756483,29.2886146685041,52.3914173792665,44.1979032474844,39.680927120387,39.695613213488,62.6617741542459,22.6900234379969,48.1061101489791,32.6470030557595,42.6095381058337,54.3639103930888,50.4392692635615,53.7239685363019,36.4958707277974,28.3368608272945,53.2904687400854,36.1127951963015,51.8221858146293,41.841944242869,40.1308751742365,55.4506505812835,45.6000187871616,56.365227781681,34.8643007137864,38.7941255724361,30.746857379052,38.4741505005692,41.0788532196054,53.5343863300021,43.9661977467601,35.4711865899145,52.7869585072184,43.4642959977675,42.9646645825706,46.1317885772672,39.3358299096807,70.5419164043442,38.195800117911,48.5337200652751,31.4078750602784,44.9247682058076,23.1852918206532,39.8971910625548,27.3816260306648,45.2732650663814,42.1732178269696,33.1326909321794,46.0352972943087,53.9565339093827,28.728528415682,48.6660600388131,39.4056015459669,30.9415210734523,42.8293644398869,69.966007633469,54.915905310827,33.7492338476271,52.0907512994934,35.084151546317,50.3638991653688,27.0508757988724,42.7723628364182,26.1504192872447,61.4694494352894,31.2746151451934,32.5041583668473,46.6874276783147,50.4155201366602,41.1434734534287,38.3155756310512,47.0913400541438,42.6435992584207,33.6413265474556,49.849165039003,50.1754101552753,44.7268247217641,57.2010928009836,46.5903377921905,45.9092532164111,33.137221206566,46.60860139302,39.803850775435,22.7447982454816,43.5662971521192,35.2252857114441,39.4871293892635,57.8200312230075,53.026420980964,49.3718171363503,44.1219122729724,40.6416201324869,55.7385939172115,51.852308153523,37.6805792519171,57.532314902201,39.6954707542916,63.6750737139838,58.238358550923,55.223172005873,50.6772471709537,52.9695710186909,53.5339911018815,39.2431611396813,50.9700669537192,54.663628834748,43.1539184094119,34.0135863754004,39.9540220880905,40.6038532701086,46.6267949604233,31.1022341977419,44.3877854521197,49.0663445572714,43.6680930637592,45.7467468986868,32.9261500311108,36.7756299068114,36.2125975724898,57.0605023362674,46.2804718070735,35.6443212888235,39.5431298453103,62.1702012655048,48.8606543115372,55.0237536267771,20.3203328286924,54.3653078766447,62.5686391419205,62.0189217325641,38.8065642442733,24.5829925642457,44.758911235609,40.0621370565975,61.0450170287896,42.7502760116194,35.2790100522264,32.432990361585,49.9122904067591,32.673616797514,53.7738127556185,52.8282700703643,57.1760435691106,49.3749339902623,38.5473869781206,57.3779001160055,56.867901906301,36.6466147777927,41.4137819123776,37.9289477879458,66.7467456799918,20.3173460887404,49.5543013182208,65.1745882461388,51.6037823509041,36.2172531174204,35.7457065734808,49.1580428306545,38.029500534089,65.6420826735047,48.8978542571243,50.2195108342318,60.1082794928997,41.3767271321878,50.3408013314174,31.8118613963602,64.9499291967642,56.9922592600061,50.7007745768031,35.4253683036422,52.6297811098446,56.566529876338,68.0479432594656,49.6311876928602,47.7799724786416,35.5325913330884,53.3887542557687,51.8764523948377,52.59154810075,49.2161084194506,44.2204145568143,46.3301119367127,56.8134481014827,44.7867912318673,48.6315224374632,29.0118957312494,56.7390164102888,48.6913315488343,40.6434827162433,35.7152337199804,40.5961313072751,52.3338189879067,47.1487508517656,26.2288021803948,44.5985640612223,36.6719636174612,51.8534913041066,29.1428263841762,56.4188099846927,55.2908693199433,49.9238147048733,29.7862837586801,47.4314052699643,44.8179403148933,61.4618770669307,33.0675970853126,45.1614028568659,49.4148486286225,46.9009394640069,48.4811269640229,45.9678568644516,34.6930595273765,54.8563351701483,47.2294320621391,32.7610161821541,34.6625381014065,46.1443344557659,33.738844824203,35.7550573153216,34.517194840898,54.9843659464185,25.8866683248673,35.1115650653384,39.3823771938714,27.0352395366638,61.6837531551471,49.8695315101,40.0764505050765,48.5190047521606,37.4699518477432,47.2203593247533,58.4382891329794,35.6808113350907,40.9657926166444,39.1878763912977,66.3478905942487,48.6953586541205,43.1832711419489,32.1797670755574,50.0295921022605,47.443277212859,45.4070996613204,39.5526743266749,35.9836119397417,29.2132885585909,56.8718970468956,51.603383326356,40.7363393026779,51.3118524055159,33.9330995994035,56.9163566403705,48.1155658213691,32.1308106578499,46.3342576631669,48.8053182645085,47.988763148162,35.2514538443331,34.4657261165,37.5592336574593,57.3615657088836,59.1379983546159,41.7521029283386,47.5113405764037,48.7250776792693,52.9387636430864,34.7036724163524,59.3725809962949,33.2492265830956,50.6493381596091,52.064644272132,45.8206417845222,49.9656274411589,47.855011619784,34.8208467430808,57.1172482717133,54.3251495339277,59.448606260069,54.7567438962455,61.3898778038518,37.8061542560391,33.6291377518115,52.3956999078296,38.4443200383352,38.0797439023975,30.8127168317824,45.0677131441527,62.7550800713326,24.2919864679202,38.5199464696713,55.0521350510207,47.3725579200492,33.1142323993484,39.994767732738,47.9516794385295,10.504433567576,55.1969572778736,36.3796858543542,48.428598034396,26.2782099654469,35.1983996133595,42.9268079443487,55.7635153202487,41.7711316226564,41.9517064362649,52.5057347463897,52.4342934456867,53.9270498018483,48.8911230788968,30.4808156143357,61.9421914694244,42.6606804256948,45.4801099204316,46.2236613657182,59.9626087614277,54.0227761288721,37.1929055801273,53.7892230740598,49.3198909984941,28.8023305921619,48.7394627598697,36.9252440005017,44.8641670833526,42.355808286339,39.7931035627251,27.910655725513,54.5807746764943,69.5222395752138,58.5895835091703,35.6212682788537,53.1169440294738,57.8679479808566,43.0970421195206,50.5851763680552,53.9264296924252,57.0098511343041,53.4268638215894,57.7807809461657,36.6758283183659,41.2118440735521,52.4864603962819,48.5468385325901,38.7207629975626,39.597796252997,48.7354567219427,59.5695956693544,46.5088219250636,54.2105694487837,37.9556962860486,40.7970365107044,49.4643775487706,47.7616322579903,41.848982188397,19.7580888011417,24.6768432684893,48.8463775026237,43.3215272658167,43.8884639379608,33.6812267187581,35.2345256983474,40.556033005468,51.0633888338615,32.0557049215034,52.7688293115804,30.5462136385644,37.2528449123518,37.9374029079879,18.8970454336767,45.1074569870246,47.6618605913915,33.2761806738953,47.47963435302,68.3177327851854,44.1531572157389,46.7385660726976,47.3401710900872,46.5331538914346,63.1315605234506,50.9101345558233,38.8885432485609,27.9217422347225,50.8263977261551,61.8163181068066,20.0071876995589,45.2553817784439,45.1264405377343,32.6177385754589,41.7773505300348,36.2089031386403,51.6981057699762,26.8323617979574,40.8547865556032,54.5401009284707,42.6298216669833,29.9558021047091,35.7947203973663,44.8199283715346,40.3564533681241,40.736985810578,39.8539469834979,44.2874674503577,43.3048486032973,46.9663029858366,57.4782013672903,49.9902616815832,46.9783885178356,60.5082181581186,47.3304678287747,41.817243610904,35.1414798505938,44.3663928596001,47.4240613451895,48.6891236690579,67.3755904445195,47.5916193849375,41.3794701603172,37.4598584331523,45.3683432068641,61.0538332418918,42.4302224401837,27.2618416510661,41.0551809694909,33.7089854243408,29.0142624653475,54.2443686213679,31.1945431590974,55.3061714289679,51.3302094225025,56.3316020196785,47.4311801146994,34.6595620937298,39.1676673531655,42.3258674246321,32.3680749948138,33.2992565054624,52.0131555271724,61.3182220289968,42.6565706451192,51.4871118359336,54.597311217949,46.0513330942068,46.6115808580833,51.2229278448706,41.2096735246771,31.6861270520315,49.0736796757223,37.0556299100102,46.9071541059917,43.9709566220546,50.2721048219094,45.306000478453,52.1667542717486,34.4988481714802,59.2156356684168,52.2255143514066,59.8491096027461,60.8421528825248,35.2822924327677,38.9499492364794,65.2581273003663,57.6411164080705,39.6135528278724,47.8440034487432,50.2536288844081,33.0084162903286,54.4007789193104,51.9838998638635,46.6866235526079,39.1609336884501,28.4668416283945,52.4949442387485,36.4892691465745,60.8447348284863,49.2711549403046,33.5466843167384,53.6115322546255,18.0548034069717,40.2110191687923,42.6097785565208,43.5414322925327,50.4547953267298,45.41300803391],"text":["pet: cat<br />happiness: 60.39933<br />pet: cat","pet: cat<br />happiness: 49.26671<br />pet: cat","pet: cat<br />happiness: 34.73732<br />pet: cat","pet: cat<br />happiness: 38.09693<br />pet: cat","pet: cat<br />happiness: 35.46086<br />pet: cat","pet: cat<br />happiness: 27.44384<br />pet: cat","pet: cat<br />happiness: 52.78176<br />pet: cat","pet: cat<br />happiness: 44.41003<br />pet: cat","pet: cat<br />happiness: 52.06419<br />pet: cat","pet: cat<br />happiness: 41.80446<br />pet: cat","pet: cat<br />happiness: 36.73000<br />pet: cat","pet: cat<br />happiness: 43.37833<br />pet: cat","pet: cat<br />happiness: 45.13320<br />pet: cat","pet: cat<br />happiness: 56.23426<br />pet: cat","pet: cat<br />happiness: 52.24883<br />pet: cat","pet: cat<br />happiness: 48.82105<br />pet: cat","pet: cat<br />happiness: 43.27136<br />pet: cat","pet: cat<br />happiness: 35.24121<br />pet: cat","pet: cat<br />happiness: 49.57101<br />pet: cat","pet: cat<br />happiness: 39.01676<br />pet: cat","pet: cat<br />happiness: 29.28861<br />pet: cat","pet: cat<br />happiness: 52.39142<br />pet: cat","pet: cat<br />happiness: 44.19790<br />pet: cat","pet: cat<br />happiness: 39.68093<br />pet: cat","pet: cat<br />happiness: 39.69561<br />pet: cat","pet: cat<br />happiness: 62.66177<br />pet: cat","pet: cat<br />happiness: 22.69002<br />pet: cat","pet: cat<br />happiness: 48.10611<br />pet: cat","pet: cat<br />happiness: 32.64700<br />pet: cat","pet: cat<br />happiness: 42.60954<br />pet: cat","pet: cat<br />happiness: 54.36391<br />pet: cat","pet: cat<br />happiness: 50.43927<br />pet: cat","pet: cat<br />happiness: 53.72397<br />pet: cat","pet: cat<br />happiness: 36.49587<br />pet: cat","pet: cat<br />happiness: 28.33686<br />pet: cat","pet: cat<br />happiness: 53.29047<br />pet: cat","pet: cat<br />happiness: 36.11280<br />pet: cat","pet: cat<br />happiness: 51.82219<br />pet: cat","pet: cat<br />happiness: 41.84194<br />pet: cat","pet: cat<br />happiness: 40.13088<br />pet: cat","pet: cat<br />happiness: 55.45065<br />pet: cat","pet: cat<br />happiness: 45.60002<br />pet: cat","pet: cat<br />happiness: 56.36523<br />pet: cat","pet: cat<br />happiness: 34.86430<br />pet: cat","pet: cat<br />happiness: 38.79413<br />pet: cat","pet: cat<br />happiness: 30.74686<br />pet: cat","pet: cat<br />happiness: 38.47415<br />pet: cat","pet: cat<br />happiness: 41.07885<br />pet: cat","pet: cat<br />happiness: 53.53439<br />pet: cat","pet: cat<br />happiness: 43.96620<br />pet: cat","pet: cat<br />happiness: 35.47119<br />pet: cat","pet: cat<br />happiness: 52.78696<br />pet: cat","pet: cat<br />happiness: 43.46430<br />pet: cat","pet: cat<br />happiness: 42.96466<br />pet: cat","pet: cat<br />happiness: 46.13179<br />pet: cat","pet: cat<br />happiness: 39.33583<br />pet: cat","pet: cat<br />happiness: 70.54192<br />pet: cat","pet: cat<br />happiness: 38.19580<br />pet: cat","pet: cat<br />happiness: 48.53372<br />pet: cat","pet: cat<br />happiness: 31.40788<br />pet: cat","pet: cat<br />happiness: 44.92477<br />pet: cat","pet: cat<br />happiness: 23.18529<br />pet: cat","pet: cat<br />happiness: 39.89719<br />pet: cat","pet: cat<br />happiness: 27.38163<br />pet: cat","pet: cat<br />happiness: 45.27327<br />pet: cat","pet: cat<br />happiness: 42.17322<br />pet: cat","pet: cat<br />happiness: 33.13269<br />pet: cat","pet: cat<br />happiness: 46.03530<br />pet: cat","pet: cat<br />happiness: 53.95653<br />pet: cat","pet: cat<br />happiness: 28.72853<br />pet: cat","pet: cat<br />happiness: 48.66606<br />pet: cat","pet: cat<br />happiness: 39.40560<br />pet: cat","pet: cat<br />happiness: 30.94152<br />pet: cat","pet: cat<br />happiness: 42.82936<br />pet: cat","pet: cat<br />happiness: 69.96601<br />pet: cat","pet: cat<br />happiness: 54.91591<br />pet: cat","pet: cat<br />happiness: 33.74923<br />pet: cat","pet: cat<br />happiness: 52.09075<br />pet: cat","pet: cat<br />happiness: 35.08415<br />pet: cat","pet: cat<br />happiness: 50.36390<br />pet: cat","pet: cat<br />happiness: 27.05088<br />pet: cat","pet: cat<br />happiness: 42.77236<br />pet: cat","pet: cat<br />happiness: 26.15042<br />pet: cat","pet: cat<br />happiness: 61.46945<br />pet: cat","pet: cat<br />happiness: 31.27462<br />pet: cat","pet: cat<br />happiness: 32.50416<br />pet: cat","pet: cat<br />happiness: 46.68743<br />pet: cat","pet: cat<br />happiness: 50.41552<br />pet: cat","pet: cat<br />happiness: 41.14347<br />pet: cat","pet: cat<br />happiness: 38.31558<br />pet: cat","pet: cat<br />happiness: 47.09134<br />pet: cat","pet: cat<br />happiness: 42.64360<br />pet: cat","pet: cat<br />happiness: 33.64133<br />pet: cat","pet: cat<br />happiness: 49.84917<br />pet: cat","pet: cat<br />happiness: 50.17541<br />pet: cat","pet: cat<br />happiness: 44.72682<br />pet: cat","pet: cat<br />happiness: 57.20109<br />pet: cat","pet: cat<br />happiness: 46.59034<br />pet: cat","pet: cat<br />happiness: 45.90925<br />pet: cat","pet: cat<br />happiness: 33.13722<br />pet: cat","pet: cat<br />happiness: 46.60860<br />pet: cat","pet: cat<br />happiness: 39.80385<br />pet: cat","pet: cat<br />happiness: 22.74480<br />pet: cat","pet: cat<br />happiness: 43.56630<br />pet: cat","pet: cat<br />happiness: 35.22529<br />pet: cat","pet: cat<br />happiness: 39.48713<br />pet: cat","pet: cat<br />happiness: 57.82003<br />pet: cat","pet: cat<br />happiness: 53.02642<br />pet: cat","pet: cat<br />happiness: 49.37182<br />pet: cat","pet: cat<br />happiness: 44.12191<br />pet: cat","pet: cat<br />happiness: 40.64162<br />pet: cat","pet: cat<br />happiness: 55.73859<br />pet: cat","pet: cat<br />happiness: 51.85231<br />pet: cat","pet: cat<br />happiness: 37.68058<br />pet: cat","pet: cat<br />happiness: 57.53231<br />pet: cat","pet: cat<br />happiness: 39.69547<br />pet: cat","pet: cat<br />happiness: 63.67507<br />pet: cat","pet: cat<br />happiness: 58.23836<br />pet: cat","pet: cat<br />happiness: 55.22317<br />pet: cat","pet: cat<br />happiness: 50.67725<br />pet: cat","pet: cat<br />happiness: 52.96957<br />pet: cat","pet: cat<br />happiness: 53.53399<br />pet: cat","pet: cat<br />happiness: 39.24316<br />pet: cat","pet: cat<br />happiness: 50.97007<br />pet: cat","pet: cat<br />happiness: 54.66363<br />pet: cat","pet: cat<br />happiness: 43.15392<br />pet: cat","pet: cat<br />happiness: 34.01359<br />pet: cat","pet: cat<br />happiness: 39.95402<br />pet: cat","pet: cat<br />happiness: 40.60385<br />pet: cat","pet: cat<br />happiness: 46.62679<br />pet: cat","pet: cat<br />happiness: 31.10223<br />pet: cat","pet: cat<br />happiness: 44.38779<br />pet: cat","pet: cat<br />happiness: 49.06634<br />pet: cat","pet: cat<br />happiness: 43.66809<br />pet: cat","pet: cat<br />happiness: 45.74675<br />pet: cat","pet: cat<br />happiness: 32.92615<br />pet: cat","pet: cat<br />happiness: 36.77563<br />pet: cat","pet: cat<br />happiness: 36.21260<br />pet: cat","pet: cat<br />happiness: 57.06050<br />pet: cat","pet: cat<br />happiness: 46.28047<br />pet: cat","pet: cat<br />happiness: 35.64432<br />pet: cat","pet: cat<br />happiness: 39.54313<br />pet: cat","pet: cat<br />happiness: 62.17020<br />pet: cat","pet: cat<br />happiness: 48.86065<br />pet: cat","pet: cat<br />happiness: 55.02375<br />pet: cat","pet: cat<br />happiness: 20.32033<br />pet: cat","pet: cat<br />happiness: 54.36531<br />pet: cat","pet: cat<br />happiness: 62.56864<br />pet: cat","pet: cat<br />happiness: 62.01892<br />pet: cat","pet: cat<br />happiness: 38.80656<br />pet: cat","pet: cat<br />happiness: 24.58299<br />pet: cat","pet: cat<br />happiness: 44.75891<br />pet: cat","pet: cat<br />happiness: 40.06214<br />pet: cat","pet: cat<br />happiness: 61.04502<br />pet: cat","pet: cat<br />happiness: 42.75028<br />pet: cat","pet: cat<br />happiness: 35.27901<br />pet: cat","pet: cat<br />happiness: 32.43299<br />pet: cat","pet: cat<br />happiness: 49.91229<br />pet: cat","pet: cat<br />happiness: 32.67362<br />pet: cat","pet: cat<br />happiness: 53.77381<br />pet: cat","pet: cat<br />happiness: 52.82827<br />pet: cat","pet: cat<br />happiness: 57.17604<br />pet: cat","pet: cat<br />happiness: 49.37493<br />pet: cat","pet: cat<br />happiness: 38.54739<br />pet: cat","pet: cat<br />happiness: 57.37790<br />pet: cat","pet: cat<br />happiness: 56.86790<br />pet: cat","pet: cat<br />happiness: 36.64661<br />pet: cat","pet: cat<br />happiness: 41.41378<br />pet: cat","pet: cat<br />happiness: 37.92895<br />pet: cat","pet: cat<br />happiness: 66.74675<br />pet: cat","pet: cat<br />happiness: 20.31735<br />pet: cat","pet: cat<br />happiness: 49.55430<br />pet: cat","pet: cat<br />happiness: 65.17459<br />pet: cat","pet: cat<br />happiness: 51.60378<br />pet: cat","pet: cat<br />happiness: 36.21725<br />pet: cat","pet: cat<br />happiness: 35.74571<br />pet: cat","pet: cat<br />happiness: 49.15804<br />pet: cat","pet: cat<br />happiness: 38.02950<br />pet: cat","pet: cat<br />happiness: 65.64208<br />pet: cat","pet: cat<br />happiness: 48.89785<br />pet: cat","pet: cat<br />happiness: 50.21951<br />pet: cat","pet: cat<br />happiness: 60.10828<br />pet: cat","pet: cat<br />happiness: 41.37673<br />pet: cat","pet: cat<br />happiness: 50.34080<br />pet: cat","pet: cat<br />happiness: 31.81186<br />pet: cat","pet: cat<br />happiness: 64.94993<br />pet: cat","pet: cat<br />happiness: 56.99226<br />pet: cat","pet: cat<br />happiness: 50.70077<br />pet: cat","pet: cat<br />happiness: 35.42537<br />pet: cat","pet: cat<br />happiness: 52.62978<br />pet: cat","pet: cat<br />happiness: 56.56653<br />pet: cat","pet: cat<br />happiness: 68.04794<br />pet: cat","pet: cat<br />happiness: 49.63119<br />pet: cat","pet: cat<br />happiness: 47.77997<br />pet: cat","pet: cat<br />happiness: 35.53259<br />pet: cat","pet: cat<br />happiness: 53.38875<br />pet: cat","pet: cat<br />happiness: 51.87645<br />pet: cat","pet: cat<br />happiness: 52.59155<br />pet: cat","pet: cat<br />happiness: 49.21611<br />pet: cat","pet: cat<br />happiness: 44.22041<br />pet: cat","pet: cat<br />happiness: 46.33011<br />pet: cat","pet: cat<br />happiness: 56.81345<br />pet: cat","pet: cat<br />happiness: 44.78679<br />pet: cat","pet: cat<br />happiness: 48.63152<br />pet: cat","pet: cat<br />happiness: 29.01190<br />pet: cat","pet: cat<br />happiness: 56.73902<br />pet: cat","pet: cat<br />happiness: 48.69133<br />pet: cat","pet: cat<br />happiness: 40.64348<br />pet: cat","pet: cat<br />happiness: 35.71523<br />pet: cat","pet: cat<br />happiness: 40.59613<br />pet: cat","pet: cat<br />happiness: 52.33382<br />pet: cat","pet: cat<br />happiness: 47.14875<br />pet: cat","pet: cat<br />happiness: 26.22880<br />pet: cat","pet: cat<br />happiness: 44.59856<br />pet: cat","pet: cat<br />happiness: 36.67196<br />pet: cat","pet: cat<br />happiness: 51.85349<br />pet: cat","pet: cat<br />happiness: 29.14283<br />pet: cat","pet: cat<br />happiness: 56.41881<br />pet: cat","pet: cat<br />happiness: 55.29087<br />pet: cat","pet: cat<br />happiness: 49.92381<br />pet: cat","pet: cat<br />happiness: 29.78628<br />pet: cat","pet: cat<br />happiness: 47.43141<br />pet: cat","pet: cat<br />happiness: 44.81794<br />pet: cat","pet: cat<br />happiness: 61.46188<br />pet: cat","pet: cat<br />happiness: 33.06760<br />pet: cat","pet: cat<br />happiness: 45.16140<br />pet: cat","pet: cat<br />happiness: 49.41485<br />pet: cat","pet: cat<br />happiness: 46.90094<br />pet: cat","pet: cat<br />happiness: 48.48113<br />pet: cat","pet: cat<br />happiness: 45.96786<br />pet: cat","pet: cat<br />happiness: 34.69306<br />pet: cat","pet: cat<br />happiness: 54.85634<br />pet: cat","pet: cat<br />happiness: 47.22943<br />pet: cat","pet: cat<br />happiness: 32.76102<br />pet: cat","pet: cat<br />happiness: 34.66254<br />pet: cat","pet: cat<br />happiness: 46.14433<br />pet: cat","pet: cat<br />happiness: 33.73884<br />pet: cat","pet: cat<br />happiness: 35.75506<br />pet: cat","pet: cat<br />happiness: 34.51719<br />pet: cat","pet: cat<br />happiness: 54.98437<br />pet: cat","pet: cat<br />happiness: 25.88667<br />pet: cat","pet: cat<br />happiness: 35.11157<br />pet: cat","pet: cat<br />happiness: 39.38238<br />pet: cat","pet: cat<br />happiness: 27.03524<br />pet: cat","pet: cat<br />happiness: 61.68375<br />pet: cat","pet: cat<br />happiness: 49.86953<br />pet: cat","pet: cat<br />happiness: 40.07645<br />pet: cat","pet: cat<br />happiness: 48.51900<br />pet: cat","pet: cat<br />happiness: 37.46995<br />pet: cat","pet: cat<br />happiness: 47.22036<br />pet: cat","pet: cat<br />happiness: 58.43829<br />pet: cat","pet: cat<br />happiness: 35.68081<br />pet: cat","pet: cat<br />happiness: 40.96579<br />pet: cat","pet: cat<br />happiness: 39.18788<br />pet: cat","pet: cat<br />happiness: 66.34789<br />pet: cat","pet: cat<br />happiness: 48.69536<br />pet: cat","pet: cat<br />happiness: 43.18327<br />pet: cat","pet: cat<br />happiness: 32.17977<br />pet: cat","pet: cat<br />happiness: 50.02959<br />pet: cat","pet: cat<br />happiness: 47.44328<br />pet: cat","pet: cat<br />happiness: 45.40710<br />pet: cat","pet: cat<br />happiness: 39.55267<br />pet: cat","pet: cat<br />happiness: 35.98361<br />pet: cat","pet: cat<br />happiness: 29.21329<br />pet: cat","pet: cat<br />happiness: 56.87190<br />pet: cat","pet: cat<br />happiness: 51.60338<br />pet: cat","pet: cat<br />happiness: 40.73634<br />pet: cat","pet: cat<br />happiness: 51.31185<br />pet: cat","pet: cat<br />happiness: 33.93310<br />pet: cat","pet: cat<br />happiness: 56.91636<br />pet: cat","pet: cat<br />happiness: 48.11557<br />pet: cat","pet: cat<br />happiness: 32.13081<br />pet: cat","pet: cat<br />happiness: 46.33426<br />pet: cat","pet: cat<br />happiness: 48.80532<br />pet: cat","pet: cat<br />happiness: 47.98876<br />pet: cat","pet: cat<br />happiness: 35.25145<br />pet: cat","pet: cat<br />happiness: 34.46573<br />pet: cat","pet: cat<br />happiness: 37.55923<br />pet: cat","pet: cat<br />happiness: 57.36157<br />pet: cat","pet: cat<br />happiness: 59.13800<br />pet: cat","pet: cat<br />happiness: 41.75210<br />pet: cat","pet: cat<br />happiness: 47.51134<br />pet: cat","pet: cat<br />happiness: 48.72508<br />pet: cat","pet: cat<br />happiness: 52.93876<br />pet: cat","pet: cat<br />happiness: 34.70367<br />pet: cat","pet: cat<br />happiness: 59.37258<br />pet: cat","pet: cat<br />happiness: 33.24923<br />pet: cat","pet: cat<br />happiness: 50.64934<br />pet: cat","pet: cat<br />happiness: 52.06464<br />pet: cat","pet: cat<br />happiness: 45.82064<br />pet: cat","pet: cat<br />happiness: 49.96563<br />pet: cat","pet: cat<br />happiness: 47.85501<br />pet: cat","pet: cat<br />happiness: 34.82085<br />pet: cat","pet: cat<br />happiness: 57.11725<br />pet: cat","pet: cat<br />happiness: 54.32515<br />pet: cat","pet: cat<br />happiness: 59.44861<br />pet: cat","pet: cat<br />happiness: 54.75674<br />pet: cat","pet: cat<br />happiness: 61.38988<br />pet: cat","pet: cat<br />happiness: 37.80615<br />pet: cat","pet: cat<br />happiness: 33.62914<br />pet: cat","pet: cat<br />happiness: 52.39570<br />pet: cat","pet: cat<br />happiness: 38.44432<br />pet: cat","pet: cat<br />happiness: 38.07974<br />pet: cat","pet: cat<br />happiness: 30.81272<br />pet: cat","pet: cat<br />happiness: 45.06771<br />pet: cat","pet: cat<br />happiness: 62.75508<br />pet: cat","pet: cat<br />happiness: 24.29199<br />pet: cat","pet: cat<br />happiness: 38.51995<br />pet: cat","pet: cat<br />happiness: 55.05214<br />pet: cat","pet: cat<br />happiness: 47.37256<br />pet: cat","pet: cat<br />happiness: 33.11423<br />pet: cat","pet: cat<br />happiness: 39.99477<br />pet: cat","pet: cat<br />happiness: 47.95168<br />pet: cat","pet: cat<br />happiness: 10.50443<br />pet: cat","pet: cat<br />happiness: 55.19696<br />pet: cat","pet: cat<br />happiness: 36.37969<br />pet: cat","pet: cat<br />happiness: 48.42860<br />pet: cat","pet: cat<br />happiness: 26.27821<br />pet: cat","pet: cat<br />happiness: 35.19840<br />pet: cat","pet: cat<br />happiness: 42.92681<br />pet: cat","pet: cat<br />happiness: 55.76352<br />pet: cat","pet: cat<br />happiness: 41.77113<br />pet: cat","pet: cat<br />happiness: 41.95171<br />pet: cat","pet: cat<br />happiness: 52.50573<br />pet: cat","pet: cat<br />happiness: 52.43429<br />pet: cat","pet: cat<br />happiness: 53.92705<br />pet: cat","pet: cat<br />happiness: 48.89112<br />pet: cat","pet: cat<br />happiness: 30.48082<br />pet: cat","pet: cat<br />happiness: 61.94219<br />pet: cat","pet: cat<br />happiness: 42.66068<br />pet: cat","pet: cat<br />happiness: 45.48011<br />pet: cat","pet: cat<br />happiness: 46.22366<br />pet: cat","pet: cat<br />happiness: 59.96261<br />pet: cat","pet: cat<br />happiness: 54.02278<br />pet: cat","pet: cat<br />happiness: 37.19291<br />pet: cat","pet: cat<br />happiness: 53.78922<br />pet: cat","pet: cat<br />happiness: 49.31989<br />pet: cat","pet: cat<br />happiness: 28.80233<br />pet: cat","pet: cat<br />happiness: 48.73946<br />pet: cat","pet: cat<br />happiness: 36.92524<br />pet: cat","pet: cat<br />happiness: 44.86417<br />pet: cat","pet: cat<br />happiness: 42.35581<br />pet: cat","pet: cat<br />happiness: 39.79310<br />pet: cat","pet: cat<br />happiness: 27.91066<br />pet: cat","pet: cat<br />happiness: 54.58077<br />pet: cat","pet: cat<br />happiness: 69.52224<br />pet: cat","pet: cat<br />happiness: 58.58958<br />pet: cat","pet: cat<br />happiness: 35.62127<br />pet: cat","pet: cat<br />happiness: 53.11694<br />pet: cat","pet: cat<br />happiness: 57.86795<br />pet: cat","pet: cat<br />happiness: 43.09704<br />pet: cat","pet: cat<br />happiness: 50.58518<br />pet: cat","pet: cat<br />happiness: 53.92643<br />pet: cat","pet: cat<br />happiness: 57.00985<br />pet: cat","pet: cat<br />happiness: 53.42686<br />pet: cat","pet: cat<br />happiness: 57.78078<br />pet: cat","pet: cat<br />happiness: 36.67583<br />pet: cat","pet: cat<br />happiness: 41.21184<br />pet: cat","pet: cat<br />happiness: 52.48646<br />pet: cat","pet: cat<br />happiness: 48.54684<br />pet: cat","pet: cat<br />happiness: 38.72076<br />pet: cat","pet: cat<br />happiness: 39.59780<br />pet: cat","pet: cat<br />happiness: 48.73546<br />pet: cat","pet: cat<br />happiness: 59.56960<br />pet: cat","pet: cat<br />happiness: 46.50882<br />pet: cat","pet: cat<br />happiness: 54.21057<br />pet: cat","pet: cat<br />happiness: 37.95570<br />pet: cat","pet: cat<br />happiness: 40.79704<br />pet: cat","pet: cat<br />happiness: 49.46438<br />pet: cat","pet: cat<br />happiness: 47.76163<br />pet: cat","pet: cat<br />happiness: 41.84898<br />pet: cat","pet: cat<br />happiness: 19.75809<br />pet: cat","pet: cat<br />happiness: 24.67684<br />pet: cat","pet: cat<br />happiness: 48.84638<br />pet: cat","pet: cat<br />happiness: 43.32153<br />pet: cat","pet: cat<br />happiness: 43.88846<br />pet: cat","pet: cat<br />happiness: 33.68123<br />pet: cat","pet: cat<br />happiness: 35.23453<br />pet: cat","pet: cat<br />happiness: 40.55603<br />pet: cat","pet: cat<br />happiness: 51.06339<br />pet: cat","pet: cat<br />happiness: 32.05570<br />pet: cat","pet: cat<br />happiness: 52.76883<br />pet: cat","pet: cat<br />happiness: 30.54621<br />pet: cat","pet: cat<br />happiness: 37.25284<br />pet: cat","pet: cat<br />happiness: 37.93740<br />pet: cat","pet: cat<br />happiness: 18.89705<br />pet: cat","pet: cat<br />happiness: 45.10746<br />pet: cat","pet: cat<br />happiness: 47.66186<br />pet: cat","pet: cat<br />happiness: 33.27618<br />pet: cat","pet: cat<br />happiness: 47.47963<br />pet: cat","pet: cat<br />happiness: 68.31773<br />pet: cat","pet: cat<br />happiness: 44.15316<br />pet: cat","pet: cat<br />happiness: 46.73857<br />pet: cat","pet: cat<br />happiness: 47.34017<br />pet: cat","pet: cat<br />happiness: 46.53315<br />pet: cat","pet: cat<br />happiness: 63.13156<br />pet: cat","pet: cat<br />happiness: 50.91013<br />pet: cat","pet: cat<br />happiness: 38.88854<br />pet: cat","pet: cat<br />happiness: 27.92174<br />pet: cat","pet: cat<br />happiness: 50.82640<br />pet: cat","pet: cat<br />happiness: 61.81632<br />pet: cat","pet: cat<br />happiness: 20.00719<br />pet: cat","pet: cat<br />happiness: 45.25538<br />pet: cat","pet: cat<br />happiness: 45.12644<br />pet: cat","pet: cat<br />happiness: 32.61774<br />pet: cat","pet: cat<br />happiness: 41.77735<br />pet: cat","pet: cat<br />happiness: 36.20890<br />pet: cat","pet: cat<br />happiness: 51.69811<br />pet: cat","pet: cat<br />happiness: 26.83236<br />pet: cat","pet: cat<br />happiness: 40.85479<br />pet: cat","pet: cat<br />happiness: 54.54010<br />pet: cat","pet: cat<br />happiness: 42.62982<br />pet: cat","pet: cat<br />happiness: 29.95580<br />pet: cat","pet: cat<br />happiness: 35.79472<br />pet: cat","pet: cat<br />happiness: 44.81993<br />pet: cat","pet: cat<br />happiness: 40.35645<br />pet: cat","pet: cat<br />happiness: 40.73699<br />pet: cat","pet: cat<br />happiness: 39.85395<br />pet: cat","pet: cat<br />happiness: 44.28747<br />pet: cat","pet: cat<br />happiness: 43.30485<br />pet: cat","pet: cat<br />happiness: 46.96630<br />pet: cat","pet: cat<br />happiness: 57.47820<br />pet: cat","pet: cat<br />happiness: 49.99026<br />pet: cat","pet: cat<br />happiness: 46.97839<br />pet: cat","pet: cat<br />happiness: 60.50822<br />pet: cat","pet: cat<br />happiness: 47.33047<br />pet: cat","pet: cat<br />happiness: 41.81724<br />pet: cat","pet: cat<br />happiness: 35.14148<br />pet: cat","pet: cat<br />happiness: 44.36639<br />pet: cat","pet: cat<br />happiness: 47.42406<br />pet: cat","pet: cat<br />happiness: 48.68912<br />pet: cat","pet: cat<br />happiness: 67.37559<br />pet: cat","pet: cat<br />happiness: 47.59162<br />pet: cat","pet: cat<br />happiness: 41.37947<br />pet: cat","pet: cat<br />happiness: 37.45986<br />pet: cat","pet: cat<br />happiness: 45.36834<br />pet: cat","pet: cat<br />happiness: 61.05383<br />pet: cat","pet: cat<br />happiness: 42.43022<br />pet: cat","pet: cat<br />happiness: 27.26184<br />pet: cat","pet: cat<br />happiness: 41.05518<br />pet: cat","pet: cat<br />happiness: 33.70899<br />pet: cat","pet: cat<br />happiness: 29.01426<br />pet: cat","pet: cat<br />happiness: 54.24437<br />pet: cat","pet: cat<br />happiness: 31.19454<br />pet: cat","pet: cat<br />happiness: 55.30617<br />pet: cat","pet: cat<br />happiness: 51.33021<br />pet: cat","pet: cat<br />happiness: 56.33160<br />pet: cat","pet: cat<br />happiness: 47.43118<br />pet: cat","pet: cat<br />happiness: 34.65956<br />pet: cat","pet: cat<br />happiness: 39.16767<br />pet: cat","pet: cat<br />happiness: 42.32587<br />pet: cat","pet: cat<br />happiness: 32.36807<br />pet: cat","pet: cat<br />happiness: 33.29926<br />pet: cat","pet: cat<br />happiness: 52.01316<br />pet: cat","pet: cat<br />happiness: 61.31822<br />pet: cat","pet: cat<br />happiness: 42.65657<br />pet: cat","pet: cat<br />happiness: 51.48711<br />pet: cat","pet: cat<br />happiness: 54.59731<br />pet: cat","pet: cat<br />happiness: 46.05133<br />pet: cat","pet: cat<br />happiness: 46.61158<br />pet: cat","pet: cat<br />happiness: 51.22293<br />pet: cat","pet: cat<br />happiness: 41.20967<br />pet: cat","pet: cat<br />happiness: 31.68613<br />pet: cat","pet: cat<br />happiness: 49.07368<br />pet: cat","pet: cat<br />happiness: 37.05563<br />pet: cat","pet: cat<br />happiness: 46.90715<br />pet: cat","pet: cat<br />happiness: 43.97096<br />pet: cat","pet: cat<br />happiness: 50.27210<br />pet: cat","pet: cat<br />happiness: 45.30600<br />pet: cat","pet: cat<br />happiness: 52.16675<br />pet: cat","pet: cat<br />happiness: 34.49885<br />pet: cat","pet: cat<br />happiness: 59.21564<br />pet: cat","pet: cat<br />happiness: 52.22551<br />pet: cat","pet: cat<br />happiness: 59.84911<br />pet: cat","pet: cat<br />happiness: 60.84215<br />pet: cat","pet: cat<br />happiness: 35.28229<br />pet: cat","pet: cat<br />happiness: 38.94995<br />pet: cat","pet: cat<br />happiness: 65.25813<br />pet: cat","pet: cat<br />happiness: 57.64112<br />pet: cat","pet: cat<br />happiness: 39.61355<br />pet: cat","pet: cat<br />happiness: 47.84400<br />pet: cat","pet: cat<br />happiness: 50.25363<br />pet: cat","pet: cat<br />happiness: 33.00842<br />pet: cat","pet: cat<br />happiness: 54.40078<br />pet: cat","pet: cat<br />happiness: 51.98390<br />pet: cat","pet: cat<br />happiness: 46.68662<br />pet: cat","pet: cat<br />happiness: 39.16093<br />pet: cat","pet: cat<br />happiness: 28.46684<br />pet: cat","pet: cat<br />happiness: 52.49494<br />pet: cat","pet: cat<br />happiness: 36.48927<br />pet: cat","pet: cat<br />happiness: 60.84473<br />pet: cat","pet: cat<br />happiness: 49.27115<br />pet: cat","pet: cat<br />happiness: 33.54668<br />pet: cat","pet: cat<br />happiness: 53.61153<br />pet: cat","pet: cat<br />happiness: 18.05480<br />pet: cat","pet: cat<br />happiness: 40.21102<br />pet: cat","pet: cat<br />happiness: 42.60978<br />pet: cat","pet: cat<br />happiness: 43.54143<br />pet: cat","pet: cat<br />happiness: 50.45480<br />pet: cat","pet: cat<br />happiness: 45.41301<br />pet: cat"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"cat","legendgroup":"cat","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2.12229072898626,2.11827853098512,1.89005424780771,2.15940054431558,1.97076903097332,2.09538467563689,1.91705897524953,2.09110405258834,2.06956301657483,1.98079141732305,2.16584490779787,2.15512396311387,2.13183700125664,2.14468058906496,1.95443627750501,2.09264921788126,2.03533190181479,2.00149613553658,1.8914887169376,1.9103474101983,1.89211700530723,1.9406572598964,1.83678002618253,1.94274062681943,2.14141379082575,2.05993119254708,2.18350111795589,1.89611222669482,1.94990106774494,2.08723793113604,1.88441656269133,1.96223686169833,2.02930162241682,1.86155137885362,1.80966819589958,1.90663013476878,1.841982134711,2.00272741718218,1.83353908611462,1.87410525241867,1.99170664642006,2.0000979824923,2.14278609445319,1.90385360224172,1.88162263752893,2.06381341284141,1.86903384607285,1.98598797414452,2.03377662505955,1.90944148628041,1.94895526990294,1.96180349867791,2.11799878058955,2.08062583757564,2.03846639050171,1.94795298613608,1.84537833631039,1.99588086837903,1.867201251816,2.06182880243286,1.81507375994697,2.10937767904252,1.9130210833624,1.944158064574,2.00298034790903,2.10296537876129,1.96095683313906,2.00095460228622,1.84746894938871,1.89873843677342,2.00450556026772,1.927939180471,2.10912695266306,1.89736724644899,2.04121363498271,1.95599821070209,2.0626870396547,1.89833782371134,1.84583037877455,1.90915812691674,1.81363628581166,2.17335020704195,2.12991292541847,2.00700272275135,2.09861311325803,2.05558323394507,2.14567972840741,2.05296944566071,1.98239802811295,1.98129528313875,1.91183313699439,2.07860159529373,2.135675388854,2.15953389899805,2.00436369581148,2.14891328606755,2.0577937441878,2.03278165049851,2.09077852331102,2.19775137584656,1.97166142463684,1.85157103687525,1.9856051241979,2.19707031734288,2.19071239838377,2.16774993678555,2.1552803484723,1.91562589211389,2.16733204005286,1.9268624403514,1.97083630282432,2.04328566398472,2.09803091194481,2.1627862136811,2.18972136927769,2.0308093178086,1.86915317010134,1.96679398743436,2.10350754167885,2.13378771124408,2.02783490661532,2.0161426092498,1.81122534861788,2.10255638342351,1.96007197871804,1.83814335213974,2.13565768348053,1.99973053270951,1.97223498914391,2.16406232696027,2.1096097596921,2.19165631039068,2.16828705677763,2.02412213673815,1.81605699006468,1.87503227032721,2.14894209578633,2.13151978049427,1.95172387203202,2.09572670878842,1.94044225467369,2.16821975940838,2.19423712156713,2.12770100766793,1.83700062958524,2.15400886246935,1.96658126330003,2.14206658313051,2.10841216817498,2.0567350721918,2.13462871406227,1.9473281532526,2.05015163747594,1.90988698257133,1.91223257537931,2.09860557215288,2.04178635664284,1.90417403131723,1.89371195128188,1.82035789070651,1.93207505485043,2.06243683053181,1.95872158380225,1.93113622684032,2.11867514383048,2.05734825916588,1.93722528796643,2.13574729915708,2.03026034068316,1.91909624477848,1.94129077699035,1.93157296851277,1.85789149114862,2.07710287189111,2.04529351135716,1.84639410050586,2.17043184842914,1.91522834161296,1.86757979337126,2.12210557516664,2.03251672722399,2.1704587129876,1.94790169149637,2.08143274383619,2.09345484869555,1.81046539377421,2.19903512839228,1.80874086860567,2.17686627116054,2.09429802792147,1.96474582962692,1.84869489511475,2.14500422589481,1.95227137356997,1.80747034624219,1.971880793944,1.87513620685786,2.16295338952914,2.00219177361578,1.94459423581138,1.82318091895431,2.0571831359528,2.1229014467448,2.11044402886182,2.10492948573083,1.92941996622831,2.08827041732147,2.12748127728701,1.85508109610528,2.08374033458531,1.89985505826771,2.04943877737969,2.05331252375618,1.89028587853536,1.99871242586523,1.94437456913292,1.8278176965192,1.93342016423121,2.19925353005528,2.18660024898127,2.147589520365,2.1508712827228,1.98712698761374,2.01133944317698,1.99790848465636,2.18077936368063,1.84487166088074,2.10768845155835,1.91100068083033,1.84931300356984,1.92877153716981,2.04640858089551,1.8923912813887,1.86939746802673,1.95899883713573,2.09832240855321,1.98306083930656,1.81377337230369,1.84128470029682,1.81306653022766,1.82413438837975,2.03302578506991,1.97695323480293,1.82809268310666,2.14715242153034,1.92546320287511,1.87189490729943,2.04900385616347,2.14405591739342,2.03671923400834,1.82724793832749,2.05774092301726,1.80868470557034,1.82152958484367,2.0573647769168,2.19828742984682,2.13739791708067,2.01088703405112,1.97092939782888,1.97182745905593,2.15802971702069,1.98003048216924,2.03653072183952,2.06284445282072,1.85790882771835,2.15693995226175,2.09586259033531,2.0369630577974,1.90398842366412,1.8702459236607,1.99912620214745,1.97267067357898,1.88103162739426,1.97232798468322,2.11348241632804,1.90577536020428,2.16406978359446,1.83525461768731,2.00144796185195,2.1293753195554,2.09075276190415,1.92097219368443,2.01065662289038,2.0622524918057,2.11266248403117,2.03283033715561,2.01151693519205,1.94499538978562,2.0002571862191,2.0863348999992,1.84948825957254,2.0104888218455,1.80304212486371,2.12178664607927,1.87371242940426,2.11045396272093,2.01255669407547,1.98128698775545,2.02120731221512,2.18325019786134,2.10127151170745,2.17272536279634,2.17942259488627,2.00202748551965,1.91380164958537,1.87063425201923,1.97869844958186,1.92054525967687,1.87367171412334,2.08412357270718,2.17774147540331,2.16180254584178,1.96069003064185,1.80541748171672,1.87925173230469,2.16973291756585,1.9860026108101,1.93981133978814,1.84960670527071,1.84730533938855,2.12181873815134,2.19677408719435,1.87289547342807,1.95445982236415,2.02015886297449,2.07854651510715,1.8731865153648,1.84818763742223,1.91634803311899,2.01060408195481,2.02879673624411,2.12895682193339,2.02734774108976,1.80101660173386,1.97638500453904,1.80730063579977,2.00599089320749,1.94420999139547,2.19768685754389,1.92998985731974,2.10936250211671,1.9716305250302,2.153695004154,1.94073660764843,1.85931783830747,2.18176863305271,2.03977135913447,1.9686597966589,2.16506614815444,2.09643247900531,2.10241139288992,1.85889041796327,1.88155468031764,2.02357246465981,1.89042542204261,2.13148228013888,2.17457603113726,1.84281906215474,1.8635135402903,2.1002568565309,2.12358992416412,2.17168653598055,1.92231496181339,1.98923877291381,2.03785425685346,1.86160558825359,2.01115062460303,1.88890806604177,2.19935451690108,1.82752941604704,1.93818980427459,1.90515698296949,2.15679771602154,1.97183463191614,1.98321321941912,2.17696226378903,2.14313467573375,1.8360324175097,2.19580072546378,2.09680998623371,2.12296502422541,1.95123676685616,2.02694003824145,1.88254936384037,2.1644993099384,2.14591257497668,1.87984643997625,2.15801661377773,1.88035404300317,2.04782898407429,2.10184843083844,1.8599933674559,1.8860112993978,1.92393400557339,1.83619904685766,2.18913487559184,1.93598396684974,2.16377786919475,2.16323816888034,2.13790231365711,2.05210710456595,2.13586712405086,1.96827105227858,2.10446608671919,2.05082481298596,2.09831303078681,1.81367318369448,2.18294535074383,2.05652887215838,1.81048562256619,2.14478890774772,2.18103234954178,1.89257765393704,2.04539481429383,1.96688544312492,2.1498990864493,1.85282595027238,1.81878783684224,2.03168391799554,1.82491203667596,2.0769525048323,1.93604019237682,1.80887430980802,2.14250359097496,1.82549876589328,1.94302572961897,1.93142512058839,2.11753507545218,1.8350898059085,2.02598363701254,1.98501336863264,2.13468596357852,2.14803385287523,2.13895614007488,1.90360327102244,2.05423979088664,2.19899530373514,1.88922219229862,2.00098883779719,2.10657647680491,1.82101943101734,1.90992814963683,1.92673101369292,2.1059441735968,1.86792604643852,1.81608386216685,1.93114934088662,2.01114510335028,1.85803590705618,2.15613961620256,1.82390376133844,2.18891102178022,1.99844481023028,2.0011981934309,1.94567199200392,2.0141321583651,1.93322209641337,2.05791018167511,1.93536159694195,2.10516205318272,2.04155918732285,1.81814523329958,2.06454581944272,1.9871484584175,1.89749798253179,1.83999041588977,1.90380740538239,1.9335337121971,1.9285601535812,2.12979868249968,1.86481761755422,2.12063377033919,2.01917579425499,2.16321289539337,1.93380793398246,2.11717291427776,1.99961764700711,2.01754974359646,2.18739003837109,1.96184311266989,2.1646525638178,1.94445214904845,1.86777942096815,2.0187604399398,1.91851914618164,2.00629094829783,2.15229691276327,1.87958019133657,1.89956701546907,1.95555354785174,1.8934495003894,2.10028536897153,2.05591984735802,2.12316850228235,2.08590961098671,2.09901559902355,2.16939047425985,1.97971240505576,1.88631404610351,2.19158484200016],"y":[56.348980379992,56.1758210575528,46.7441087176872,33.6476373531261,57.1420852566974,45.529319300444,48.4835955039011,62.2870326534951,65.4977811914848,56.0196713956355,70.9699140540981,60.6408403246229,53.4463828584239,43.2453268014034,53.5785282225978,64.0078298669407,58.5817694848113,45.8147790829873,41.7797649666038,57.2780001019732,51.5214603725893,68.0072451671968,52.753525926705,29.0313420041752,45.7826744722238,69.6878476826746,45.6053918868517,46.4913652545934,71.6093372475839,41.4247394488671,55.8600488037611,67.5157826232099,61.101210208633,55.2038585527414,62.2253981196261,43.9157267536101,62.6978339050839,65.2712084959997,55.7292701908791,41.8552561634719,56.9474354248509,60.9155773313345,45.7397074059729,47.1259645870389,60.8677672200968,60.3955927234214,65.8698574462304,56.3101780822837,51.0681730202713,75.2069144500301,62.4453767765039,41.5337199195212,58.3014251000117,54.8727467381946,50.3632403970925,57.0494209032875,59.6397505636977,47.4328409919972,44.344596334078,52.3714827341331,38.2527477291103,57.7610633395158,49.7129601358153,66.5563939764121,62.1575083501585,59.2289464986141,52.8018548735395,71.8864317064644,53.883150280247,44.7987747653537,69.9547568423037,48.1011656432593,68.7978401783825,43.3178324183513,58.0251065993467,58.9987921334904,54.9516928304282,67.0484621836554,60.9598074036472,50.0486381688524,61.5797631987522,62.7022809408572,47.8958722616553,47.9465836265595,63.6793452922399,50.2437499508847,54.4855538318562,55.3766957129665,54.30047293239,50.1299948621331,48.0176050642804,38.0125314816194,64.9134919554448,45.4203479767643,49.9559298122974,53.4454576737383,66.6915008313595,60.3346110800217,68.1833414179698,57.6395691570415,51.8088382077301,64.1463753050838,69.2274057949456,44.008987790356,48.952874513094,42.7243470852849,34.0961485493776,45.6589730698622,57.9598394319407,51.0150338979558,64.1571406230563,62.2923850599381,50.6007456848882,52.3862917675036,29.0135507235515,42.5544033892296,44.6587978438829,59.1357227189857,44.1720668824557,65.095557647207,33.8719184006428,61.1079600414955,62.1075061366571,57.1261777209566,69.924049840491,59.0962656325719,49.5443437362911,59.2983056197838,45.8915752770966,44.8058884063392,74.146288126446,69.4031617196148,56.663156846456,38.9458289644278,54.3225965008125,55.0148562167577,30.1084111459232,46.7283430806421,35.9692403590937,64.8991481729908,57.3985792242006,37.3142915847315,56.4570329847652,59.4629242320002,60.9166374450139,65.0609596961482,63.3629966355494,59.5572766137353,60.6161769854027,69.8500929566588,54.1163523964244,55.8114035940751,68.8814524843497,54.7658937829888,64.8759268951391,53.5530364717985,48.965484399723,53.1020433942707,63.7262875854439,42.9762598694685,57.0633120369964,52.1356542927145,83.694916819908,42.9465336959998,50.9486758564846,57.521337335172,76.1717890166646,52.1896309110703,61.4633084812071,32.9711203682081,58.8719957463279,65.3018134521508,60.1648697839587,55.9786636981014,54.2731788758027,54.8624346286349,27.7718097656376,59.1191337725543,67.3162467931885,70.9030642629621,49.8976770450167,68.368846484685,46.0949573392641,39.4660983362272,68.7129948894985,48.911407151938,55.5487484337503,43.794412102778,69.201238458593,66.1402697172692,59.8561234375931,54.2567820508889,47.6944163963388,65.2889940300401,38.3900920738933,45.8203041718305,41.2840083954761,64.2672633439153,47.5246432878671,44.7074875450714,51.6727566823071,53.2631541277312,53.1256186990802,66.5632219026743,45.6180586804783,60.2405232822127,53.7191330143613,36.7368782175643,60.3266578384649,55.404400543126,65.1614077008045,57.722719870563,64.9972077202182,71.0290284857983,54.7046978944406,51.0261507188579,54.0418669135207,46.6987079976261,61.1390238584206,55.5946679242987,38.2180377513814,59.6755179721,36.3945237831118,63.6305060711122,45.0621322667266,50.1480281428998,60.1768224038975,51.4523862854784,53.0756256453944,74.1054487812157,73.1194690180575,58.266082108888,54.6913812985127,58.2977323937898,47.8074331296751,53.3305970477301,31.0995169729889,47.8657741863346,50.3106981250609,57.1835880303568,50.1523677685137,71.7507834635506,53.7285939698378,44.4773100520864,62.2633749103697,47.240488465318,43.6276638746881,65.133452896212,52.889583149521,53.4218204521674,57.6497555394962,65.3616157547902,49.726117326445,55.2581510868053,57.2154581349435,65.0161176753927,67.9180014176452,64.773466062312,52.5812364868432,54.9761944525371,61.0657584216646,58.9627862079031,56.9145025486289,52.9119679405142,61.8115891725922,50.3697305673917,73.8000487354301,51.7419850050931,44.6516291539241,43.154544644383,55.0829177584137,54.5678063803482,49.874601848162,48.1042542748186,61.6675892538921,30.9488469642053,62.133680543385,51.6759347014676,64.1754933509152,62.3964486285391,59.1437951280819,58.7188455273979,48.7250706609221,44.62707331725,53.9479752161003,59.35699285464,31.1571507231622,44.2656122432856,42.1204151114409,52.1362210733047,33.5710759954521,50.2570362409763,42.639900972276,62.386956807877,57.2875789796925,52.6520887618166,50.7685947801054,50.4183553318721,55.5361255330931,55.995245609544,65.2596777577469,51.0753976322663,67.2679288122315,60.4962490506892,59.016089954619,50.313445389845,59.7808162092078,58.2703671182606,42.6556871147064,42.962343697484,58.3904016360441,42.9556210147932,28.9227174279046,73.6857077033091,54.9231381387244,49.1583707636023,67.9391544191982,45.9474238131288,70.2911828829504,63.4002610652443,49.3041074998879,55.4780525832746,59.1215994462602,59.3363917938142,49.7481348717662,56.6433081194327,46.7643126550714,46.8423401136972,57.3966962351859,22.6256142239452,59.9546464907717,54.9926962249185,62.3659482159445,69.4345480949266,56.2664913995163,48.2080864416639,66.7741913814567,57.8143375913318,49.2572387092912,70.9904461455696,42.5896463465402,37.234267208733,65.0102958466925,57.40229536475,43.7975677308243,37.7595476356415,43.502239776386,42.2577749996503,53.9024263118432,44.4210826471562,56.4927789816208,53.1201616920034,63.3155982234204,44.3558310106955,68.9972626970561,59.1195133748471,47.346279826103,64.269265443763,44.1380170325557,55.7112864732048,51.8545150137748,56.1710709152759,37.5253522135759,53.790440236377,56.7524591201242,52.0651050113153,69.2724173288344,47.5792717753578,55.9021521645539,55.7119682724085,45.1370710022505,53.0804561689891,80.2763735056865,38.8790054212263,67.8638671673797,45.0359713212287,51.8386565215699,63.109417499812,50.8456318805362,57.5770458541122,50.581767224624,37.6625859506587,57.3833023544838,75.1005965560552,65.0822142512501,49.4491067929929,47.5979037165513,42.2909490495543,46.8482700558066,41.2209436356555,75.4668156743545,50.050894546648,51.4770436830508,66.0034330962761,34.1140516144025,51.3122723701556,53.8911852773209,51.4464393280248,49.7464193810683,59.8170427098116,65.2430196181112,49.8364425165903,41.8450346716257,51.0606366921629,56.0964512273255,46.4477893424399,54.6969517552996,57.2264122646358,52.0670076778389,52.2950049397374,60.124912362811,49.3696194898711,35.7374264377754,55.0197894964468,69.0271502776492,36.5177132852723,33.5434395798871,37.7360123698205,48.1564009457278,44.0157453075402,41.5815941846202,77.2514109071194,73.2529504960158,40.5121623216306,68.9079153920186,57.8922461492343,54.4891970187462,89.127944088886,56.2525501061707,51.5637468515512,47.2419461285748,52.7438411688957,59.0740355689192,61.5098516451096,54.9944173991586,58.5853980687606,61.2545383794932,67.5086432267035,64.4392078580968,47.9318434179632,54.434208767811,58.673181230923,51.0644826878766,40.6764058858029,48.4409840605075,43.4963342732651,66.514813248245,52.1041896683715,75.9295561217171,28.403543030647,51.0877410942956,77.1272236583338,39.3740900589026,47.2970243543211,49.4529415667966,69.105020228478,50.0979638861404,55.7202949212382,58.8784242484261,45.1290351114932,27.2057751891893,60.0703702687098,72.5726822730862,50.9131138531352,55.4337841189937,66.7211582064629,57.6217604802226,76.375770866664,67.6927631720959,52.7681722859141,70.2853830112649,59.5218016447955,71.9792443727334,65.1571343967023,65.6365954406087,62.2043507226092,77.3856457019744,57.30860065583,57.6612998669301,58.0574869194505,27.6573685643276,50.5129000663718,58.8988723295966,44.5811935013745,43.2368440106042,86.2227710338264,57.8239652338952,59.2544513022294,67.6229291103111,53.4600997185716,44.2423934635197,40.0494273288804,51.6049756302852,59.5470067450711,50.283954084783,41.3307904339869,50.5701499963909,58.837268274811,50.5753597778862,71.4876335767875],"text":["pet: dog<br />happiness: 56.34898<br />pet: dog","pet: dog<br />happiness: 56.17582<br />pet: dog","pet: dog<br />happiness: 46.74411<br />pet: dog","pet: dog<br />happiness: 33.64764<br />pet: dog","pet: dog<br />happiness: 57.14209<br />pet: dog","pet: dog<br />happiness: 45.52932<br />pet: dog","pet: dog<br />happiness: 48.48360<br />pet: dog","pet: dog<br />happiness: 62.28703<br />pet: dog","pet: dog<br />happiness: 65.49778<br />pet: dog","pet: dog<br />happiness: 56.01967<br />pet: dog","pet: dog<br />happiness: 70.96991<br />pet: dog","pet: dog<br />happiness: 60.64084<br />pet: dog","pet: dog<br />happiness: 53.44638<br />pet: dog","pet: dog<br />happiness: 43.24533<br />pet: dog","pet: dog<br />happiness: 53.57853<br />pet: dog","pet: dog<br />happiness: 64.00783<br />pet: dog","pet: dog<br />happiness: 58.58177<br />pet: dog","pet: dog<br />happiness: 45.81478<br />pet: dog","pet: dog<br />happiness: 41.77976<br />pet: dog","pet: dog<br />happiness: 57.27800<br />pet: dog","pet: dog<br />happiness: 51.52146<br />pet: dog","pet: dog<br />happiness: 68.00725<br />pet: dog","pet: dog<br />happiness: 52.75353<br />pet: dog","pet: dog<br />happiness: 29.03134<br />pet: dog","pet: dog<br />happiness: 45.78267<br />pet: dog","pet: dog<br />happiness: 69.68785<br />pet: dog","pet: dog<br />happiness: 45.60539<br />pet: dog","pet: dog<br />happiness: 46.49137<br />pet: dog","pet: dog<br />happiness: 71.60934<br />pet: dog","pet: dog<br />happiness: 41.42474<br />pet: dog","pet: dog<br />happiness: 55.86005<br />pet: dog","pet: dog<br />happiness: 67.51578<br />pet: dog","pet: dog<br />happiness: 61.10121<br />pet: dog","pet: dog<br />happiness: 55.20386<br />pet: dog","pet: dog<br />happiness: 62.22540<br />pet: dog","pet: dog<br />happiness: 43.91573<br />pet: dog","pet: dog<br />happiness: 62.69783<br />pet: dog","pet: dog<br />happiness: 65.27121<br />pet: dog","pet: dog<br />happiness: 55.72927<br />pet: dog","pet: dog<br />happiness: 41.85526<br />pet: dog","pet: dog<br />happiness: 56.94744<br />pet: dog","pet: dog<br />happiness: 60.91558<br />pet: dog","pet: dog<br />happiness: 45.73971<br />pet: dog","pet: dog<br />happiness: 47.12596<br />pet: dog","pet: dog<br />happiness: 60.86777<br />pet: dog","pet: dog<br />happiness: 60.39559<br />pet: dog","pet: dog<br />happiness: 65.86986<br />pet: dog","pet: dog<br />happiness: 56.31018<br />pet: dog","pet: dog<br />happiness: 51.06817<br />pet: dog","pet: dog<br />happiness: 75.20691<br />pet: dog","pet: dog<br />happiness: 62.44538<br />pet: dog","pet: dog<br />happiness: 41.53372<br />pet: dog","pet: dog<br />happiness: 58.30143<br />pet: dog","pet: dog<br />happiness: 54.87275<br />pet: dog","pet: dog<br />happiness: 50.36324<br />pet: dog","pet: dog<br />happiness: 57.04942<br />pet: dog","pet: dog<br />happiness: 59.63975<br />pet: dog","pet: dog<br />happiness: 47.43284<br />pet: dog","pet: dog<br />happiness: 44.34460<br />pet: dog","pet: dog<br />happiness: 52.37148<br />pet: dog","pet: dog<br />happiness: 38.25275<br />pet: dog","pet: dog<br />happiness: 57.76106<br />pet: dog","pet: dog<br />happiness: 49.71296<br />pet: dog","pet: dog<br />happiness: 66.55639<br />pet: dog","pet: dog<br />happiness: 62.15751<br />pet: dog","pet: dog<br />happiness: 59.22895<br />pet: dog","pet: dog<br />happiness: 52.80185<br />pet: dog","pet: dog<br />happiness: 71.88643<br />pet: dog","pet: dog<br />happiness: 53.88315<br />pet: dog","pet: dog<br />happiness: 44.79877<br />pet: dog","pet: dog<br />happiness: 69.95476<br />pet: dog","pet: dog<br />happiness: 48.10117<br />pet: dog","pet: dog<br />happiness: 68.79784<br />pet: dog","pet: dog<br />happiness: 43.31783<br />pet: dog","pet: dog<br />happiness: 58.02511<br />pet: dog","pet: dog<br />happiness: 58.99879<br />pet: dog","pet: dog<br />happiness: 54.95169<br />pet: dog","pet: dog<br />happiness: 67.04846<br />pet: dog","pet: dog<br />happiness: 60.95981<br />pet: dog","pet: dog<br />happiness: 50.04864<br />pet: dog","pet: dog<br />happiness: 61.57976<br />pet: dog","pet: dog<br />happiness: 62.70228<br />pet: dog","pet: dog<br />happiness: 47.89587<br />pet: dog","pet: dog<br />happiness: 47.94658<br />pet: dog","pet: dog<br />happiness: 63.67935<br />pet: dog","pet: dog<br />happiness: 50.24375<br />pet: dog","pet: dog<br />happiness: 54.48555<br />pet: dog","pet: dog<br />happiness: 55.37670<br />pet: dog","pet: dog<br />happiness: 54.30047<br />pet: dog","pet: dog<br />happiness: 50.12999<br />pet: dog","pet: dog<br />happiness: 48.01761<br />pet: dog","pet: dog<br />happiness: 38.01253<br />pet: dog","pet: dog<br />happiness: 64.91349<br />pet: dog","pet: dog<br />happiness: 45.42035<br />pet: dog","pet: dog<br />happiness: 49.95593<br />pet: dog","pet: dog<br />happiness: 53.44546<br />pet: dog","pet: dog<br />happiness: 66.69150<br />pet: dog","pet: dog<br />happiness: 60.33461<br />pet: dog","pet: dog<br />happiness: 68.18334<br />pet: dog","pet: dog<br />happiness: 57.63957<br />pet: dog","pet: dog<br />happiness: 51.80884<br />pet: dog","pet: dog<br />happiness: 64.14638<br />pet: dog","pet: dog<br />happiness: 69.22741<br />pet: dog","pet: dog<br />happiness: 44.00899<br />pet: dog","pet: dog<br />happiness: 48.95287<br />pet: dog","pet: dog<br />happiness: 42.72435<br />pet: dog","pet: dog<br />happiness: 34.09615<br />pet: dog","pet: dog<br />happiness: 45.65897<br />pet: dog","pet: dog<br />happiness: 57.95984<br />pet: dog","pet: dog<br />happiness: 51.01503<br />pet: dog","pet: dog<br />happiness: 64.15714<br />pet: dog","pet: dog<br />happiness: 62.29239<br />pet: dog","pet: dog<br />happiness: 50.60075<br />pet: dog","pet: dog<br />happiness: 52.38629<br />pet: dog","pet: dog<br />happiness: 29.01355<br />pet: dog","pet: dog<br />happiness: 42.55440<br />pet: dog","pet: dog<br />happiness: 44.65880<br />pet: dog","pet: dog<br />happiness: 59.13572<br />pet: dog","pet: dog<br />happiness: 44.17207<br />pet: dog","pet: dog<br />happiness: 65.09556<br />pet: dog","pet: dog<br />happiness: 33.87192<br />pet: dog","pet: dog<br />happiness: 61.10796<br />pet: dog","pet: dog<br />happiness: 62.10751<br />pet: dog","pet: dog<br />happiness: 57.12618<br />pet: dog","pet: dog<br />happiness: 69.92405<br />pet: dog","pet: dog<br />happiness: 59.09627<br />pet: dog","pet: dog<br />happiness: 49.54434<br />pet: dog","pet: dog<br />happiness: 59.29831<br />pet: dog","pet: dog<br />happiness: 45.89158<br />pet: dog","pet: dog<br />happiness: 44.80589<br />pet: dog","pet: dog<br />happiness: 74.14629<br />pet: dog","pet: dog<br />happiness: 69.40316<br />pet: dog","pet: dog<br />happiness: 56.66316<br />pet: dog","pet: dog<br />happiness: 38.94583<br />pet: dog","pet: dog<br />happiness: 54.32260<br />pet: dog","pet: dog<br />happiness: 55.01486<br />pet: dog","pet: dog<br />happiness: 30.10841<br />pet: dog","pet: dog<br />happiness: 46.72834<br />pet: dog","pet: dog<br />happiness: 35.96924<br />pet: dog","pet: dog<br />happiness: 64.89915<br />pet: dog","pet: dog<br />happiness: 57.39858<br />pet: dog","pet: dog<br />happiness: 37.31429<br />pet: dog","pet: dog<br />happiness: 56.45703<br />pet: dog","pet: dog<br />happiness: 59.46292<br />pet: dog","pet: dog<br />happiness: 60.91664<br />pet: dog","pet: dog<br />happiness: 65.06096<br />pet: dog","pet: dog<br />happiness: 63.36300<br />pet: dog","pet: dog<br />happiness: 59.55728<br />pet: dog","pet: dog<br />happiness: 60.61618<br />pet: dog","pet: dog<br />happiness: 69.85009<br />pet: dog","pet: dog<br />happiness: 54.11635<br />pet: dog","pet: dog<br />happiness: 55.81140<br />pet: dog","pet: dog<br />happiness: 68.88145<br />pet: dog","pet: dog<br />happiness: 54.76589<br />pet: dog","pet: dog<br />happiness: 64.87593<br />pet: dog","pet: dog<br />happiness: 53.55304<br />pet: dog","pet: dog<br />happiness: 48.96548<br />pet: dog","pet: dog<br />happiness: 53.10204<br />pet: dog","pet: dog<br />happiness: 63.72629<br />pet: dog","pet: dog<br />happiness: 42.97626<br />pet: dog","pet: dog<br />happiness: 57.06331<br />pet: dog","pet: dog<br />happiness: 52.13565<br />pet: dog","pet: dog<br />happiness: 83.69492<br />pet: dog","pet: dog<br />happiness: 42.94653<br />pet: dog","pet: dog<br />happiness: 50.94868<br />pet: dog","pet: dog<br />happiness: 57.52134<br />pet: dog","pet: dog<br />happiness: 76.17179<br />pet: dog","pet: dog<br />happiness: 52.18963<br />pet: dog","pet: dog<br />happiness: 61.46331<br />pet: dog","pet: dog<br />happiness: 32.97112<br />pet: dog","pet: dog<br />happiness: 58.87200<br />pet: dog","pet: dog<br />happiness: 65.30181<br />pet: dog","pet: dog<br />happiness: 60.16487<br />pet: dog","pet: dog<br />happiness: 55.97866<br />pet: dog","pet: dog<br />happiness: 54.27318<br />pet: dog","pet: dog<br />happiness: 54.86243<br />pet: dog","pet: dog<br />happiness: 27.77181<br />pet: dog","pet: dog<br />happiness: 59.11913<br />pet: dog","pet: dog<br />happiness: 67.31625<br />pet: dog","pet: dog<br />happiness: 70.90306<br />pet: dog","pet: dog<br />happiness: 49.89768<br />pet: dog","pet: dog<br />happiness: 68.36885<br />pet: dog","pet: dog<br />happiness: 46.09496<br />pet: dog","pet: dog<br />happiness: 39.46610<br />pet: dog","pet: dog<br />happiness: 68.71299<br />pet: dog","pet: dog<br />happiness: 48.91141<br />pet: dog","pet: dog<br />happiness: 55.54875<br />pet: dog","pet: dog<br />happiness: 43.79441<br />pet: dog","pet: dog<br />happiness: 69.20124<br />pet: dog","pet: dog<br />happiness: 66.14027<br />pet: dog","pet: dog<br />happiness: 59.85612<br />pet: dog","pet: dog<br />happiness: 54.25678<br />pet: dog","pet: dog<br />happiness: 47.69442<br />pet: dog","pet: dog<br />happiness: 65.28899<br />pet: dog","pet: dog<br />happiness: 38.39009<br />pet: dog","pet: dog<br />happiness: 45.82030<br />pet: dog","pet: dog<br />happiness: 41.28401<br />pet: dog","pet: dog<br />happiness: 64.26726<br />pet: dog","pet: dog<br />happiness: 47.52464<br />pet: dog","pet: dog<br />happiness: 44.70749<br />pet: dog","pet: dog<br />happiness: 51.67276<br />pet: dog","pet: dog<br />happiness: 53.26315<br />pet: dog","pet: dog<br />happiness: 53.12562<br />pet: dog","pet: dog<br />happiness: 66.56322<br />pet: dog","pet: dog<br />happiness: 45.61806<br />pet: dog","pet: dog<br />happiness: 60.24052<br />pet: dog","pet: dog<br />happiness: 53.71913<br />pet: dog","pet: dog<br />happiness: 36.73688<br />pet: dog","pet: dog<br />happiness: 60.32666<br />pet: dog","pet: dog<br />happiness: 55.40440<br />pet: dog","pet: dog<br />happiness: 65.16141<br />pet: dog","pet: dog<br />happiness: 57.72272<br />pet: dog","pet: dog<br />happiness: 64.99721<br />pet: dog","pet: dog<br />happiness: 71.02903<br />pet: dog","pet: dog<br />happiness: 54.70470<br />pet: dog","pet: dog<br />happiness: 51.02615<br />pet: dog","pet: dog<br />happiness: 54.04187<br />pet: dog","pet: dog<br />happiness: 46.69871<br />pet: dog","pet: dog<br />happiness: 61.13902<br />pet: dog","pet: dog<br />happiness: 55.59467<br />pet: dog","pet: dog<br />happiness: 38.21804<br />pet: dog","pet: dog<br />happiness: 59.67552<br />pet: dog","pet: dog<br />happiness: 36.39452<br />pet: dog","pet: dog<br />happiness: 63.63051<br />pet: dog","pet: dog<br />happiness: 45.06213<br />pet: dog","pet: dog<br />happiness: 50.14803<br />pet: dog","pet: dog<br />happiness: 60.17682<br />pet: dog","pet: dog<br />happiness: 51.45239<br />pet: dog","pet: dog<br />happiness: 53.07563<br />pet: dog","pet: dog<br />happiness: 74.10545<br />pet: dog","pet: dog<br />happiness: 73.11947<br />pet: dog","pet: dog<br />happiness: 58.26608<br />pet: dog","pet: dog<br />happiness: 54.69138<br />pet: dog","pet: dog<br />happiness: 58.29773<br />pet: dog","pet: dog<br />happiness: 47.80743<br />pet: dog","pet: dog<br />happiness: 53.33060<br />pet: dog","pet: dog<br />happiness: 31.09952<br />pet: dog","pet: dog<br />happiness: 47.86577<br />pet: dog","pet: dog<br />happiness: 50.31070<br />pet: dog","pet: dog<br />happiness: 57.18359<br />pet: dog","pet: dog<br />happiness: 50.15237<br />pet: dog","pet: dog<br />happiness: 71.75078<br />pet: dog","pet: dog<br />happiness: 53.72859<br />pet: dog","pet: dog<br />happiness: 44.47731<br />pet: dog","pet: dog<br />happiness: 62.26337<br />pet: dog","pet: dog<br />happiness: 47.24049<br />pet: dog","pet: dog<br />happiness: 43.62766<br />pet: dog","pet: dog<br />happiness: 65.13345<br />pet: dog","pet: dog<br />happiness: 52.88958<br />pet: dog","pet: dog<br />happiness: 53.42182<br />pet: dog","pet: dog<br />happiness: 57.64976<br />pet: dog","pet: dog<br />happiness: 65.36162<br />pet: dog","pet: dog<br />happiness: 49.72612<br />pet: dog","pet: dog<br />happiness: 55.25815<br />pet: dog","pet: dog<br />happiness: 57.21546<br />pet: dog","pet: dog<br />happiness: 65.01612<br />pet: dog","pet: dog<br />happiness: 67.91800<br />pet: dog","pet: dog<br />happiness: 64.77347<br />pet: dog","pet: dog<br />happiness: 52.58124<br />pet: dog","pet: dog<br />happiness: 54.97619<br />pet: dog","pet: dog<br />happiness: 61.06576<br />pet: dog","pet: dog<br />happiness: 58.96279<br />pet: dog","pet: dog<br />happiness: 56.91450<br />pet: dog","pet: dog<br />happiness: 52.91197<br />pet: dog","pet: dog<br />happiness: 61.81159<br />pet: dog","pet: dog<br />happiness: 50.36973<br />pet: dog","pet: dog<br />happiness: 73.80005<br />pet: dog","pet: dog<br />happiness: 51.74199<br />pet: dog","pet: dog<br />happiness: 44.65163<br />pet: dog","pet: dog<br />happiness: 43.15454<br />pet: dog","pet: dog<br />happiness: 55.08292<br />pet: dog","pet: dog<br />happiness: 54.56781<br />pet: dog","pet: dog<br />happiness: 49.87460<br />pet: dog","pet: dog<br />happiness: 48.10425<br />pet: dog","pet: dog<br />happiness: 61.66759<br />pet: dog","pet: dog<br />happiness: 30.94885<br />pet: dog","pet: dog<br />happiness: 62.13368<br />pet: dog","pet: dog<br />happiness: 51.67593<br />pet: dog","pet: dog<br />happiness: 64.17549<br />pet: dog","pet: dog<br />happiness: 62.39645<br />pet: dog","pet: dog<br />happiness: 59.14380<br />pet: dog","pet: dog<br />happiness: 58.71885<br />pet: dog","pet: dog<br />happiness: 48.72507<br />pet: dog","pet: dog<br />happiness: 44.62707<br />pet: dog","pet: dog<br />happiness: 53.94798<br />pet: dog","pet: dog<br />happiness: 59.35699<br />pet: dog","pet: dog<br />happiness: 31.15715<br />pet: dog","pet: dog<br />happiness: 44.26561<br />pet: dog","pet: dog<br />happiness: 42.12042<br />pet: dog","pet: dog<br />happiness: 52.13622<br />pet: dog","pet: dog<br />happiness: 33.57108<br />pet: dog","pet: dog<br />happiness: 50.25704<br />pet: dog","pet: dog<br />happiness: 42.63990<br />pet: dog","pet: dog<br />happiness: 62.38696<br />pet: dog","pet: dog<br />happiness: 57.28758<br />pet: dog","pet: dog<br />happiness: 52.65209<br />pet: dog","pet: dog<br />happiness: 50.76859<br />pet: dog","pet: dog<br />happiness: 50.41836<br />pet: dog","pet: dog<br />happiness: 55.53613<br />pet: dog","pet: dog<br />happiness: 55.99525<br />pet: dog","pet: dog<br />happiness: 65.25968<br />pet: dog","pet: dog<br />happiness: 51.07540<br />pet: dog","pet: dog<br />happiness: 67.26793<br />pet: dog","pet: dog<br />happiness: 60.49625<br />pet: dog","pet: dog<br />happiness: 59.01609<br />pet: dog","pet: dog<br />happiness: 50.31345<br />pet: dog","pet: dog<br />happiness: 59.78082<br />pet: dog","pet: dog<br />happiness: 58.27037<br />pet: dog","pet: dog<br />happiness: 42.65569<br />pet: dog","pet: dog<br />happiness: 42.96234<br />pet: dog","pet: dog<br />happiness: 58.39040<br />pet: dog","pet: dog<br />happiness: 42.95562<br />pet: dog","pet: dog<br />happiness: 28.92272<br />pet: dog","pet: dog<br />happiness: 73.68571<br />pet: dog","pet: dog<br />happiness: 54.92314<br />pet: dog","pet: dog<br />happiness: 49.15837<br />pet: dog","pet: dog<br />happiness: 67.93915<br />pet: dog","pet: dog<br />happiness: 45.94742<br />pet: dog","pet: dog<br />happiness: 70.29118<br />pet: dog","pet: dog<br />happiness: 63.40026<br />pet: dog","pet: dog<br />happiness: 49.30411<br />pet: dog","pet: dog<br />happiness: 55.47805<br />pet: dog","pet: dog<br />happiness: 59.12160<br />pet: dog","pet: dog<br />happiness: 59.33639<br />pet: dog","pet: dog<br />happiness: 49.74813<br />pet: dog","pet: dog<br />happiness: 56.64331<br />pet: dog","pet: dog<br />happiness: 46.76431<br />pet: dog","pet: dog<br />happiness: 46.84234<br />pet: dog","pet: dog<br />happiness: 57.39670<br />pet: dog","pet: dog<br />happiness: 22.62561<br />pet: dog","pet: dog<br />happiness: 59.95465<br />pet: dog","pet: dog<br />happiness: 54.99270<br />pet: dog","pet: dog<br />happiness: 62.36595<br />pet: dog","pet: dog<br />happiness: 69.43455<br />pet: dog","pet: dog<br />happiness: 56.26649<br />pet: dog","pet: dog<br />happiness: 48.20809<br />pet: dog","pet: dog<br />happiness: 66.77419<br />pet: dog","pet: dog<br />happiness: 57.81434<br />pet: dog","pet: dog<br />happiness: 49.25724<br />pet: dog","pet: dog<br />happiness: 70.99045<br />pet: dog","pet: dog<br />happiness: 42.58965<br />pet: dog","pet: dog<br />happiness: 37.23427<br />pet: dog","pet: dog<br />happiness: 65.01030<br />pet: dog","pet: dog<br />happiness: 57.40230<br />pet: dog","pet: dog<br />happiness: 43.79757<br />pet: dog","pet: dog<br />happiness: 37.75955<br />pet: dog","pet: dog<br />happiness: 43.50224<br />pet: dog","pet: dog<br />happiness: 42.25777<br />pet: dog","pet: dog<br />happiness: 53.90243<br />pet: dog","pet: dog<br />happiness: 44.42108<br />pet: dog","pet: dog<br />happiness: 56.49278<br />pet: dog","pet: dog<br />happiness: 53.12016<br />pet: dog","pet: dog<br />happiness: 63.31560<br />pet: dog","pet: dog<br />happiness: 44.35583<br />pet: dog","pet: dog<br />happiness: 68.99726<br />pet: dog","pet: dog<br />happiness: 59.11951<br />pet: dog","pet: dog<br />happiness: 47.34628<br />pet: dog","pet: dog<br />happiness: 64.26927<br />pet: dog","pet: dog<br />happiness: 44.13802<br />pet: dog","pet: dog<br />happiness: 55.71129<br />pet: dog","pet: dog<br />happiness: 51.85452<br />pet: dog","pet: dog<br />happiness: 56.17107<br />pet: dog","pet: dog<br />happiness: 37.52535<br />pet: dog","pet: dog<br />happiness: 53.79044<br />pet: dog","pet: dog<br />happiness: 56.75246<br />pet: dog","pet: dog<br />happiness: 52.06511<br />pet: dog","pet: dog<br />happiness: 69.27242<br />pet: dog","pet: dog<br />happiness: 47.57927<br />pet: dog","pet: dog<br />happiness: 55.90215<br />pet: dog","pet: dog<br />happiness: 55.71197<br />pet: dog","pet: dog<br />happiness: 45.13707<br />pet: dog","pet: dog<br />happiness: 53.08046<br />pet: dog","pet: dog<br />happiness: 80.27637<br />pet: dog","pet: dog<br />happiness: 38.87901<br />pet: dog","pet: dog<br />happiness: 67.86387<br />pet: dog","pet: dog<br />happiness: 45.03597<br />pet: dog","pet: dog<br />happiness: 51.83866<br />pet: dog","pet: dog<br />happiness: 63.10942<br />pet: dog","pet: dog<br />happiness: 50.84563<br />pet: dog","pet: dog<br />happiness: 57.57705<br />pet: dog","pet: dog<br />happiness: 50.58177<br />pet: dog","pet: dog<br />happiness: 37.66259<br />pet: dog","pet: dog<br />happiness: 57.38330<br />pet: dog","pet: dog<br />happiness: 75.10060<br />pet: dog","pet: dog<br />happiness: 65.08221<br />pet: dog","pet: dog<br />happiness: 49.44911<br />pet: dog","pet: dog<br />happiness: 47.59790<br />pet: dog","pet: dog<br />happiness: 42.29095<br />pet: dog","pet: dog<br />happiness: 46.84827<br />pet: dog","pet: dog<br />happiness: 41.22094<br />pet: dog","pet: dog<br />happiness: 75.46682<br />pet: dog","pet: dog<br />happiness: 50.05089<br />pet: dog","pet: dog<br />happiness: 51.47704<br />pet: dog","pet: dog<br />happiness: 66.00343<br />pet: dog","pet: dog<br />happiness: 34.11405<br />pet: dog","pet: dog<br />happiness: 51.31227<br />pet: dog","pet: dog<br />happiness: 53.89119<br />pet: dog","pet: dog<br />happiness: 51.44644<br />pet: dog","pet: dog<br />happiness: 49.74642<br />pet: dog","pet: dog<br />happiness: 59.81704<br />pet: dog","pet: dog<br />happiness: 65.24302<br />pet: dog","pet: dog<br />happiness: 49.83644<br />pet: dog","pet: dog<br />happiness: 41.84503<br />pet: dog","pet: dog<br />happiness: 51.06064<br />pet: dog","pet: dog<br />happiness: 56.09645<br />pet: dog","pet: dog<br />happiness: 46.44779<br />pet: dog","pet: dog<br />happiness: 54.69695<br />pet: dog","pet: dog<br />happiness: 57.22641<br />pet: dog","pet: dog<br />happiness: 52.06701<br />pet: dog","pet: dog<br />happiness: 52.29500<br />pet: dog","pet: dog<br />happiness: 60.12491<br />pet: dog","pet: dog<br />happiness: 49.36962<br />pet: dog","pet: dog<br />happiness: 35.73743<br />pet: dog","pet: dog<br />happiness: 55.01979<br />pet: dog","pet: dog<br />happiness: 69.02715<br />pet: dog","pet: dog<br />happiness: 36.51771<br />pet: dog","pet: dog<br />happiness: 33.54344<br />pet: dog","pet: dog<br />happiness: 37.73601<br />pet: dog","pet: dog<br />happiness: 48.15640<br />pet: dog","pet: dog<br />happiness: 44.01575<br />pet: dog","pet: dog<br />happiness: 41.58159<br />pet: dog","pet: dog<br />happiness: 77.25141<br />pet: dog","pet: dog<br />happiness: 73.25295<br />pet: dog","pet: dog<br />happiness: 40.51216<br />pet: dog","pet: dog<br />happiness: 68.90792<br />pet: dog","pet: dog<br />happiness: 57.89225<br />pet: dog","pet: dog<br />happiness: 54.48920<br />pet: dog","pet: dog<br />happiness: 89.12794<br />pet: dog","pet: dog<br />happiness: 56.25255<br />pet: dog","pet: dog<br />happiness: 51.56375<br />pet: dog","pet: dog<br />happiness: 47.24195<br />pet: dog","pet: dog<br />happiness: 52.74384<br />pet: dog","pet: dog<br />happiness: 59.07404<br />pet: dog","pet: dog<br />happiness: 61.50985<br />pet: dog","pet: dog<br />happiness: 54.99442<br />pet: dog","pet: dog<br />happiness: 58.58540<br />pet: dog","pet: dog<br />happiness: 61.25454<br />pet: dog","pet: dog<br />happiness: 67.50864<br />pet: dog","pet: dog<br />happiness: 64.43921<br />pet: dog","pet: dog<br />happiness: 47.93184<br />pet: dog","pet: dog<br />happiness: 54.43421<br />pet: dog","pet: dog<br />happiness: 58.67318<br />pet: dog","pet: dog<br />happiness: 51.06448<br />pet: dog","pet: dog<br />happiness: 40.67641<br />pet: dog","pet: dog<br />happiness: 48.44098<br />pet: dog","pet: dog<br />happiness: 43.49633<br />pet: dog","pet: dog<br />happiness: 66.51481<br />pet: dog","pet: dog<br />happiness: 52.10419<br />pet: dog","pet: dog<br />happiness: 75.92956<br />pet: dog","pet: dog<br />happiness: 28.40354<br />pet: dog","pet: dog<br />happiness: 51.08774<br />pet: dog","pet: dog<br />happiness: 77.12722<br />pet: dog","pet: dog<br />happiness: 39.37409<br />pet: dog","pet: dog<br />happiness: 47.29702<br />pet: dog","pet: dog<br />happiness: 49.45294<br />pet: dog","pet: dog<br />happiness: 69.10502<br />pet: dog","pet: dog<br />happiness: 50.09796<br />pet: dog","pet: dog<br />happiness: 55.72029<br />pet: dog","pet: dog<br />happiness: 58.87842<br />pet: dog","pet: dog<br />happiness: 45.12904<br />pet: dog","pet: dog<br />happiness: 27.20578<br />pet: dog","pet: dog<br />happiness: 60.07037<br />pet: dog","pet: dog<br />happiness: 72.57268<br />pet: dog","pet: dog<br />happiness: 50.91311<br />pet: dog","pet: dog<br />happiness: 55.43378<br />pet: dog","pet: dog<br />happiness: 66.72116<br />pet: dog","pet: dog<br />happiness: 57.62176<br />pet: dog","pet: dog<br />happiness: 76.37577<br />pet: dog","pet: dog<br />happiness: 67.69276<br />pet: dog","pet: dog<br />happiness: 52.76817<br />pet: dog","pet: dog<br />happiness: 70.28538<br />pet: dog","pet: dog<br />happiness: 59.52180<br />pet: dog","pet: dog<br />happiness: 71.97924<br />pet: dog","pet: dog<br />happiness: 65.15713<br />pet: dog","pet: dog<br />happiness: 65.63660<br />pet: dog","pet: dog<br />happiness: 62.20435<br />pet: dog","pet: dog<br />happiness: 77.38565<br />pet: dog","pet: dog<br />happiness: 57.30860<br />pet: dog","pet: dog<br />happiness: 57.66130<br />pet: dog","pet: dog<br />happiness: 58.05749<br />pet: dog","pet: dog<br />happiness: 27.65737<br />pet: dog","pet: dog<br />happiness: 50.51290<br />pet: dog","pet: dog<br />happiness: 58.89887<br />pet: dog","pet: dog<br />happiness: 44.58119<br />pet: dog","pet: dog<br />happiness: 43.23684<br />pet: dog","pet: dog<br />happiness: 86.22277<br />pet: dog","pet: dog<br />happiness: 57.82397<br />pet: dog","pet: dog<br />happiness: 59.25445<br />pet: dog","pet: dog<br />happiness: 67.62293<br />pet: dog","pet: dog<br />happiness: 53.46010<br />pet: dog","pet: dog<br />happiness: 44.24239<br />pet: dog","pet: dog<br />happiness: 40.04943<br />pet: dog","pet: dog<br />happiness: 51.60498<br />pet: dog","pet: dog<br />happiness: 59.54701<br />pet: dog","pet: dog<br />happiness: 50.28395<br />pet: dog","pet: dog<br />happiness: 41.33079<br />pet: dog","pet: dog<br />happiness: 50.57015<br />pet: dog","pet: dog<br />happiness: 58.83727<br />pet: dog","pet: dog<br />happiness: 50.57536<br />pet: dog","pet: dog<br />happiness: 71.48763<br />pet: dog"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"dog","legendgroup":"dog","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":30.8775425487754,"r":9.29846409298464,"b":54.0612702366127,"l":48.4821917808219},"font":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,2.6],"tickmode":"array","ticktext":["cat","dog"],"tickvals":[1,2],"categoryorder":"array","categoryarray":["cat","dog"],"nticks":null,"ticks":"outside","tickcolor":"rgba(0,0,0,1)","ticklen":4.64923204649232,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"tickangle":-0,"showline":true,"linecolor":"rgba(0,0,0,1)","linewidth":0.66417600664176,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"y","title":"pet","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[6.57325804151052,93.0591196149515],"tickmode":"array","ticktext":["25","50","75"],"tickvals":[25,50,75],"categoryorder":"array","categoryarray":["25","50","75"],"nticks":null,"ticks":"outside","tickcolor":"rgba(0,0,0,1)","ticklen":4.64923204649232,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"tickangle":-0,"showline":true,"linecolor":"rgba(0,0,0,1)","linewidth":0.66417600664176,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"x","title":"happiness","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":null,"bordercolor":null,"borderwidth":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"y":0.889763779527559},"annotations":[{"text":"pet","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"cloud":false},"source":"A","attrs":{"c2d73606fb13":{"x":{},"y":{},"fill":{},"type":"scatter"}},"cur_data":"c2d73606fb13","visdat":{"c2d73606fb13":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:plotly)Interactive graph using plotly</p>
</div>

<div class="info">
<p>Hover over the data points above and click on the legend items.</p>
</div>

## Quiz {#ggplot-quiz}

1. Generate a plot like this from the built-in dataset `iris`. Make sure to include the custom axis labels.

    <img src="03-ggplot_files/figure-html/quiz-boxplot-1.png" width="100%" style="display: block; margin: auto;" />
    
    
    <div class='solution'><button>Solution</button>
    
    ```r
    ggplot(iris, aes(Species, Petal.Width, fill = Species)) +
      geom_boxplot(show.legend = FALSE) +
      xlab("Flower Species") +
      ylab("Petal Width (in cm)")
    
    # there are many ways to do things, the code below is also correct
    ggplot(iris) +
      geom_boxplot(aes(Species, Petal.Width, fill = Species), show.legend = FALSE) +
      labs(x = "Flower Species",
           y = "Petal Width (in cm)")
    ```
    
    
    </div>


2. You have just created a plot using the following code. How do you save it?
    
    ```r
    ggplot(cars, aes(speed, dist)) + 
      geom_point() +
      geom_smooth(method = lm)
    ```
    
    <select class='solveme' data-answer='["ggsave(\"figname.png\")"]'> <option></option> <option>ggsave()</option> <option>ggsave("figname")</option> <option>ggsave("figname.png")</option> <option>ggsave("figname.png", plot = cars)</option></select>

  
3. Debug the following code.
    
    ```r
    ggplot(iris) +
      geom_point(aes(Petal.Width, Petal.Length, colour = Species)) +
      geom_smooth(method = lm) +
      facet_grid(Species)
    ```
    
    
    <div class='solution'><button>Solution</button>
    
    ```r
    ggplot(iris, aes(Petal.Width, Petal.Length, colour = Species)) +
      geom_point() +
      geom_smooth(method = lm) +
      facet_grid(~Species)
    ```
    
    <img src="03-ggplot_files/figure-html/quiz-debug-answer-1.png" width="100%" style="display: block; margin: auto;" />
    </div>


4. Generate a plot like this from the built-in dataset `ChickWeight`.  

    <img src="03-ggplot_files/figure-html/unnamed-chunk-15-1.png" width="100%" style="display: block; margin: auto;" />
    
    
    <div class='solution'><button>Solution</button>
    
    ```r
    ggplot(ChickWeight, aes(weight, Time)) +
      geom_hex(binwidth = c(10, 1)) +
      scale_fill_viridis_c()
    ```
    
    
    </div>

    
5. Generate a plot like this from the built-in dataset `iris`.

    <img src="03-ggplot_files/figure-html/quiz-cowplot-1.png" width="100%" style="display: block; margin: auto;" />
    
    
    <div class='solution'><button>Solution</button>
    
    ```r
    pw <- ggplot(iris, aes(Petal.Width, color = Species)) +
      geom_density() +
      xlab("Petal Width (in cm)")
    
    pl <- ggplot(iris, aes(Petal.Length, color = Species)) +
      geom_density() +
      xlab("Petal Length (in cm)") +
      coord_flip()
    
    pw_pl <- ggplot(iris, aes(Petal.Width, Petal.Length, color = Species)) +
      geom_point() +
      geom_smooth(method = lm) +
      xlab("Petal Width (in cm)") +
      ylab("Petal Length (in cm)")
    
    cowplot::plot_grid(
      pw, pl, pw_pl, 
      labels = c("A", "B", "C"),
      nrow = 3
    )
    ```
    
    
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
