
# Data Visualisation {#ggplot}

<img src="images/memes/better_graphs.png" class="meme right">

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
3. Set custom [labels](#custom-labels) and [colours](#custom-colours)
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

### Advanced

10. Arrange plots in a grid using [`cowplot`](#cowplot)
11. Adjust axes (e.g., flip coordinates, set axis limits)
12. Change the [theme](#theme)
13. Create interactive graphs with [`plotly`](#plotly)


## Resources

* [Look at Data](http://socviz.co/look-at-data.html) from [Data Vizualization for Social Science](http://socviz.co/)
* [Chapter 3: Data Visualisation](http://r4ds.had.co.nz/data-visualisation.html) of *R for Data Science*
* [Chapter 28: Graphics for communication](http://r4ds.had.co.nz/graphics-for-communication.html) of *R for Data Science*
* [Graphs](http://www.cookbook-r.com/Graphs) in *Cookbook for R*
* [ggplot2 cheat sheet](https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf)
* [ggplot2 documentation](https://ggplot2.tidyverse.org/reference/)
* [The R Graph Gallery](http://www.r-graph-gallery.com/) (this is really useful)
* [Top 50 ggplot2 Visualizations](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html)
* [R Graphics Cookbook](http://www.cookbook-r.com/Graphs/) by Winston Chang
* [ggplot extensions](https://www.ggplot2-exts.org/)
* [plotly](https://plot.ly/ggplot2/) for creating interactive graphs


[Stub for this lesson](stubs/3_viz.Rmd)

## Setup


```r
# libraries needed for these graphs
library(tidyverse)
library(plotly)
library(cowplot) 
set.seed(30250) # makes sure random numbers are reproducible
```

## Common Variable Combinations {#vartypes}

**Continuous** variables are properties you can measure, like height. **Discrete** (or categorical) variables are things you can count, like the number of pets you have. Categorical variables can be **nominal**, where the categories don't really have an order, like cats, dogs and ferrets (even though ferrets are obviously best). They can also be **ordinal**, where there is a clear order, but the distance between the categories isn't something you could exactly equate, like points on a Likert rating scale.

Different types of visualisations are good for different types of variables. 

<div class="try">
<p>Before you read ahead, come up with an example of each type of variable combination and sketch the types of graphs that would best display these data.</p>
<ul>
<li>1 discrete</li>
<li>1 continuous</li>
<li>2 discrete</li>
<li>2 continuous</li>
<li>1 discrete, 1 continuous</li>
<li>3 continuous</li>
</ul>
</div>

### Data

The code below creates some data frames with different types of data. We'll learn how to simulate data like this in the [Probability & Simulation](#sim) chapter, but for now just run the code chunk below.

* `pets` has a column with pet type
* `pet_happy` has `happiness` and `age` for 500 dog owners and 500 cat owners
* `x_vs_y` has two correlated continuous variables (`x` and `y`)
* `overlap` has two correlated ordinal variables and 1000 observations so there is a lot of overlap
* `overplot` has two correlated continuous variables and 10000 observations

<div class="try">
<p>First, think about what kinds of graphs are best for representing these different types of data.</p>
</div>


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

### Density plot {#geom_density}

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

You can represent subsets of a variable by assigning the category variable to the argument `group`, `fill`, or `color`. 


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
avg_pet_happy <- pet_happy %>%
  group_by(pet) %>%
  summarise(
    mean = mean(happiness),
    sd = sd(happiness)
  )

ggplot(avg_pet_happy, aes(pet, mean, fill=pet)) +
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

## Customisation

### Labels {#custom-labels}

You can set custom titles and axis labels in a few different ways.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_smooth(method="lm") +
  ggtitle("My Plot Title") +
  xlab("The X Variable") +
  ylab("The Y Variable")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-labels1-1.png" alt="Set custom labels with ggtitle(), xlab() and ylab()" width="100%" />
<p class="caption">(\#fig:line-labels1)Set custom labels with ggtitle(), xlab() and ylab()</p>
</div>


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_smooth(method="lm") +
  labs(title = "My Plot Title",
       x = "The X Variable",
       y = "The Y Variable")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-labels2-1.png" alt="Set custom labels with labs()" width="100%" />
<p class="caption">(\#fig:line-labels2)Set custom labels with labs()</p>
</div>

### Colours {#custom-colours}

You can set custom values for colour and fill using functions like `scale_colour_manual()` and `scale_fill_manual()`. The [Colours chapter in Cookbook for R](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/) has many more ways to customise colour.


```r
ggplot(pet_happy, aes(pet, happiness, colour = pet, fill = pet)) +
  geom_violin() +
  scale_color_manual(values = c("darkgreen", "dodgerblue")) +
  scale_fill_manual(values = c("#CCFFCC", "#BBDDFF"))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-labels-1.png" alt="Set custom colour" width="100%" />
<p class="caption">(\#fig:line-labels)Set custom colour</p>
</div>
 
### Save as File {#ggsave}

You can save a ggplot using `ggsave()`. It saves the last ggplot you made, 
by default, but you can specify which plot you want to save if you assigned that plot to a variable.

You can set the `width` and `height` of your plot. The default units are inches, but you can change the `units` argument to "in", "cm", or "mm".



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

To demonstrate the use of `facet_grid()` for factorial designs, we create a new column called `agegroup` to split the data into participants older than the meadian age or younger than the median age. New factors will display in alphabetical order, so we can use the `factor()` function to set the levels in the order we want.


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

If you don't have a lot of data points, it's good to represent them individually. You can use `geom_jitter` to do this.


```r
pet_happy %>%
  sample_n(50) %>%  # choose 50 random observations from the dataset
  ggplot(aes(pet, happiness, fill=pet)) +
  geom_violin(
    trim = FALSE,
    draw_quantiles = c(0.25, 0.5, 0.75), 
    alpha = 0.5
  ) + 
  geom_jitter(
    width = 0.15, # points spread out over 15% of available width
    height = 0, # do not move position on the y-axis
    alpha = 0.5, 
    size = 3
  )
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violin-jitter-1.png" alt="Violin-jitter plot" width="100%" />
<p class="caption">(\#fig:violin-jitter)Violin-jitter plot</p>
</div>

### Scatter-line graph

If your graph isn't too complicated, it's good to also show the individual data points behind the line.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_point(alpha = 0.25) +
  geom_smooth(method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/scatter-line-1.png" alt="Scatter-line plot" width="100%" />
<p class="caption">(\#fig:scatter-line)Scatter-line plot</p>
</div>

### Grid of plots {#cowplot}

You can use the [ `cowplot`](https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html) package to easily make grids of different graphs. First, you have to assign each plot a name. Then you list all the plots as the first arguments of `plot_grid()` and provide a list of labels.


```r
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
    geom_bar(stat="identity", alpha = 0.5, 
             color = "black", show.legend = FALSE) +
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


## Overlapping Discrete Data {#overlap}

### Reducing Opacity 

You can deal with overlapping data points (very common if you're using Likert scales) by reducing the opacity of the points. You need to use trial and error to adjust these so they look right.


```r
ggplot(overlap, aes(x, y)) +
  geom_point(size = 5, alpha = .05) +
  geom_smooth(method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap-alpha-1.png" alt="Deal with overlapping data using transparency" width="100%" />
<p class="caption">(\#fig:overlap-alpha)Deal with overlapping data using transparency</p>
</div>

### Proportional Dot Plots {#geom_count}

Or you can set the size of the dot proportional to the number of overlapping observations using `geom_count()`.


```r
overlap %>%
  ggplot(aes(x, y)) +
  geom_count(color = "#663399")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap-size-1.png" alt="Deal with overlapping data using geom_count()" width="100%" />
<p class="caption">(\#fig:overlap-size)Deal with overlapping data using geom_count()</p>
</div>

Alternatively, you can transform your data to create a count column and use the count to set the dot colour.


```r
overlap %>%
  group_by(x, y) %>%
  summarise(count = n()) %>%
  ggplot(aes(x, y, color=count)) +
  geom_point(size = 5) +
  scale_color_viridis_c()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap-colour-1.png" alt="Deal with overlapping data using dot colour" width="100%" />
<p class="caption">(\#fig:overlap-colour)Deal with overlapping data using dot colour</p>
</div>


<div class="info">
<p>The <a href="https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html">viridis package</a> changes the colour themes to be easier to read by people with colourblindness and to print better in greyscale. Viridis is built into <code>ggplot2</code> since v3.0.0. It uses <code>scale_colour_viridis_c()</code> and <code>scale_fill_viridis_c()</code> for continuous variables and <code>scale_colour_viridis_d()</code> and <code>scale_fill_viridis_d()</code> for discrete variables.</p>
</div>

## Overlapping Continuous Data

Even if the variables are continuous, overplotting might obscure any relationships if you have lots of data.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_point()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overplot-point-1.png" alt="Overplotted data" width="100%" />
<p class="caption">(\#fig:overplot-point)Overplotted data</p>
</div>

### 2D Density Plot {#geom_density2d}
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

You can use `stat_density_2d(aes(fill = ..level..), geom = "polygon")` to create a heatmap-style density plot. 


```r
overplot %>%
  ggplot(aes(x, y)) + 
  stat_density_2d(aes(fill = ..level..), geom = "polygon") +
  scale_fill_viridis_c()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density2d-fill-1.png" alt="Heatmap-density plot" width="100%" />
<p class="caption">(\#fig:density2d-fill)Heatmap-density plot</p>
</div>


### 2D Histogram {#geom_bin2d}

Use `geom_bin2d()` to create a rectangular heatmap of bin counts. Set the `binwidth` to the x and y dimensions to capture in each box.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_bin2d(binwidth = c(1,1))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/bin2d-1.png" alt="Heatmap of bin counts" width="100%" />
<p class="caption">(\#fig:bin2d)Heatmap of bin counts</p>
</div>

### Hexagonal Heatmap {#geom_hex}

Use `geomhex()` to create a hexagonal heatmap of bin counts. Adjust the `binwidth`, `xlim()`, `ylim()` and/or the figure dimensions to make the hexagons more or less stretched.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_hex(binwidth = c(0.25, 0.25))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overplot-hex-1.png" alt="Hexagonal heatmap of bin counts" width="100%" />
<p class="caption">(\#fig:overplot-hex)Hexagonal heatmap of bin counts</p>
</div>

### Correlation Heatmap {#geom_tile}

I've included the code for creating a correlation matrix from a table of variables, but you don't need to understand how this is done yet. We'll cover `mutate()` and `gather()` functions in the [dplyr](#dplyr) and [tidyr](#tidyr) lessons.


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

Once you have a correlation matrix in the correct (long) format, it's easy to make a heatmap using `geom_tile()`.


```r
ggplot(heatmap, aes(V1, V2, fill=r)) +
  geom_tile() +
  scale_fill_viridis_c()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/heatmap-1.png" alt="Heatmap using geom_tile()" width="100%" />
<p class="caption">(\#fig:heatmap)Heatmap using geom_tile()</p>
</div>

<div class="info">
<p>The file type is set from the filename suffix, or by specifying the argument <code>device</code>, which can take the following values: &quot;eps&quot;, &quot;ps&quot;, &quot;tex&quot;, &quot;pdf&quot;, &quot;jpeg&quot;, &quot;tiff&quot;, &quot;png&quot;, &quot;bmp&quot;, &quot;svg&quot; or &quot;wmf&quot;.</p>
</div>

## Interactive Plots {#plotly}

You can use the `plotly` package to make interactive graphs. Just assign your ggplot to a variable and use the function `ggplotly()`.


```r
demog_plot <- ggplot(pet_happy, aes(pet, happiness, fill=pet)) +
  geom_point(position = position_jitter(width= 0.2, height = 0), size = 2)

ggplotly(demog_plot)
```

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-dfad9303570ccc7d1a68" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-dfad9303570ccc7d1a68">{"x":{"data":[{"x":[1.17529864087701,1.0492422580719,1.11336405491456,0.857685153186321,0.835444555059075,1.00205458542332,0.952692575380206,0.850857357867062,0.806027988251299,0.973019440472126,0.833529269881547,0.98696720758453,0.80477081630379,0.860733404010534,1.05462501887232,1.01704105213285,1.04320970438421,0.841626016888767,0.963549224846065,1.03230283400044,1.15456760711968,1.07611854933202,1.11605344684795,1.114538062457,0.925127448048443,1.19030201015994,1.08675578245893,1.03350186645985,1.16558912936598,0.881971454899758,0.831579465512186,0.837223594821989,1.16495563248172,0.886049764696509,1.03150365548208,0.936868692189455,0.954208572022617,0.860584886651486,1.05946977389976,1.00294281719252,1.04674717597663,0.815105482656509,0.834068061038852,0.952856729924679,1.14872026126832,0.937315007019788,0.918818797636777,0.810097704548389,1.13852812480181,0.98781426474452,1.05533806532621,0.907744703162461,1.10323895215988,0.969954047631472,0.97147724153474,1.02046917211264,0.903409303724766,0.8067811537534,1.03163050934672,1.15706282034516,1.06414640359581,1.03758940342814,0.909651149064302,1.12827711580321,0.985540504287928,0.977403751015663,1.09125839117914,0.807950371783227,0.92547815432772,0.995087215770036,0.841563736833632,1.19091886011884,0.859186905156821,0.852821731660515,0.937929123081267,1.14718877281994,0.883985580503941,1.19718691930175,1.12465749466792,0.908709847275168,0.893303801119328,1.0708098246716,1.16099704680964,0.805776895210147,0.896791963931173,0.829989666119218,0.93096761032939,0.912836150079966,1.16367628322914,1.03035248890519,0.819467119965702,1.09209238663316,0.809980446007103,0.923847882263362,1.08464429201558,0.898322710674256,0.913657865859568,1.11774580087513,0.864358285348862,1.1127034181729,0.832626205775887,1.11653306474909,1.17606238853186,1.1908400401473,0.83765586828813,1.08142480887473,0.849646844901145,0.909085226990282,0.95558793740347,0.919003730267286,1.13546651825309,1.19160868497565,0.907640856225044,1.0049538445659,0.969328316021711,0.831782555393875,1.12120172269642,1.16663127075881,1.1451086435467,0.83411751659587,0.80523488894105,1.13129841098562,1.00568695282564,0.843438862077892,1.02152860630304,0.92960465149954,0.935247380658984,1.1450045382604,0.891158169321716,0.95635536685586,0.863588976860046,0.858892799913883,0.998138843942434,1.00016149794683,1.05286601409316,0.985173256322742,1.13341927183792,1.19894434548914,0.992588496860117,0.957207885105163,0.968103979621083,1.01507275952026,0.812206821516156,0.869879901781678,1.10726764649153,1.14139684345573,1.15395721960813,1.0054958101362,0.970418977644295,0.921333471685648,0.98433846225962,0.929125408735126,0.950161696411669,1.15733109246939,0.831680062040687,1.08961840420961,1.14237775644287,1.03930760445073,0.838240889832377,0.986521129310131,0.871534204296768,1.02756255175918,1.15970454001799,1.13655299562961,0.927247171383351,1.18478643232957,1.17338148448616,0.962732917629182,1.15954343676567,0.829765346553177,0.847100993897766,0.981723821070045,1.01575436089188,1.10756440265104,0.883147277031094,0.89590341001749,0.886223128437996,1.16926932064816,1.19245337676257,1.00338755203411,0.932493554707617,1.07606664998457,1.1346478074789,0.961794507317245,1.1883876462467,1.17517162961885,0.827431153971702,0.861492738220841,1.16380842924118,1.10455485153943,1.15988765377551,1.17905253916979,0.904459013324231,1.13551667099819,0.981058090925217,0.866575770732015,0.938157565053552,0.89696157630533,0.919721055030823,0.821858163923025,1.18017296027392,1.06325358506292,0.868418225646019,1.05090412590653,0.912711661402136,0.991465053707361,0.900971049722284,0.981355922948569,1.11364506362006,1.1299772772938,1.0938298820518,1.19564974540845,0.947509155608714,1.04412391753867,0.987718864623457,0.811570857092738,1.18198467427865,1.07799567086622,1.17148472713307,1.08351541860029,0.886219672206789,0.915278166346252,1.05459128720686,1.12411243654788,0.931109661888331,0.815539710130542,1.1090818609111,1.06497346535325,1.02188753876835,1.07980337170884,1.0790569646284,1.13533311402425,0.904459105618298,0.831989608611912,0.877084768284112,0.993933046516031,0.805825007520616,0.994240390043706,1.15990519737825,0.84223648738116,1.03836531545967,0.834941035415977,0.825079900771379,1.03792052930221,1.05946704288945,0.891820937488228,0.95987815214321,0.963933625537902,0.962820188608021,0.99257043292746,1.19848294816911,1.03731874553487,0.990907610952854,0.846038269065321,0.879117984231561,1.11084495941177,0.890215601213276,0.963849958311766,0.849350287951529,1.10825986787677,0.836839449033141,1.02877478711307,1.1022475996986,1.0262709248811,1.04000933729112,0.900760356336832,0.930119257513434,0.994992108270526,0.907675821799785,0.845046986266971,1.09399575237185,0.829771820176393,0.887083725165576,1.07051999159157,1.17438473459333,1.02629383895546,1.17424248661846,1.08042576881126,1.13043985851109,0.997605079226196,1.06428210055456,1.01760332584381,0.94162732521072,0.987885261699557,0.871995238121599,1.11460778964683,0.844282736815512,0.918284261226654,1.17182213999331,0.939151774160564,0.809868164081126,0.851224719546735,0.851996750663966,1.01501571433619,1.03382937414572,1.00616718716919,0.815702419448644,1.02402812633663,1.13647709507495,1.12403827421367,1.0432782523334,0.885583044867963,0.910321373958141,0.8411147961393,0.972704572696239,1.0083232681267,1.0817921907641,1.04964905213565,1.10894625037909,1.11775166867301,0.841930019762367,1.16445634365082,1.03823770834133,0.879323119204491,0.801173378620297,0.859819365758449,1.01119795581326,0.891497470345348,1.03072289768606,1.05995931401849,0.915529401693493,1.16466534780338,1.08456749115139,0.800830959714949,1.08411767398939,0.97647839197889,0.905598354991525,0.916350160352886,0.963823768403381,0.843235902488232,0.88353336872533,1.01247046161443,0.99972199620679,0.908154202997684,1.1728023503907,1.06950399652123,1.09120671078563,1.10273929769173,1.08818057067692,0.868635156191885,1.06927495524287,0.993684441410005,1.04847065201029,0.896512846648693,1.16823719283566,0.868088539224118,1.18084750538692,0.932130382489413,1.00316231977195,1.0476307538338,0.897542273811996,1.08502099933103,0.920806641876698,0.95548908431083,1.05671627232805,0.849161193799227,1.14412882095203,0.840730351954699,0.859548332449049,1.15436509661376,0.897841236833483,0.86315675675869,1.18943359656259,1.00509285023436,0.991251889802516,1.15777130033821,1.0752819516696,1.05845870710909,1.06663330672309,0.829348415695131,0.837838818877935,0.963568799477071,1.18119768230245,1.08532961905003,1.13004466388375,0.909147778339684,1.12966306516901,0.834477815870196,1.10566326947883,1.18658729549497,0.941982356738299,0.978790500108153,0.850819859094918,0.931030613742769,0.901257654838264,1.17442818423733,1.09347290694714,0.958971976302564,1.17510012788698,0.931239098869264,1.1069902908057,1.13267526729032,0.941405251901597,0.956399804074317,0.923853728827089,1.09997034044936,1.11493908166885,1.18224414465949,0.821337881591171,0.841445133648813,1.07120281048119,1.16701029678807,0.953162951115519,0.88006742997095,0.849562052171677,0.977058364171535,1.18409719392657,1.18080999748781,0.915804130677134,0.831847032811493,1.19359333170578,0.971766942925751,0.969522764068097,1.02470569005236,1.15686807818711,1.18227960839868,1.0875601388514,0.833825681637973,0.975464745238423,1.00392992980778,1.02329086475074,0.964464842714369,1.17000940386206,0.906832086574286,1.12131982948631,1.03559514246881,1.06910274066031,1.08533212980255,0.940443283040077,1.02507400512695,1.04727304829285,0.949108091089874,1.08726655803621,1.10992190092802,0.98506867159158,0.979679929371923,0.823315455578268,0.970026654470712,1.05938170272857,1.15164563078433,1.11151602808386,1.09485567854717,1.18660289635882,1.0756819691509,1.19853674657643,1.1483671429567,0.896433975547552,0.811889997124672,0.938677159976214,1.03950845524669,1.08492266153917,1.07434234581888,0.809644371178001,1.11443515373394,1.03861709972844,0.996886937040836,1.17759094843641,1.1423400961794,0.814624747727066,0.984958482906222,1.02193414056674,1.16886086016893,0.860049785766751,1.03409172389656,0.985587922111154,1.02813606215641,0.917359826900065,1.17451157579198,1.13637235434726,0.995630422234535,0.982889820076525,1.08347753603011,0.922807419020683,0.935389374475926,1.1541581954807,0.947487596329302,0.938185665104538,1.05007305918261,0.975283841881901,0.926489083189517,1.12483875583857,1.10317779211327,1.14815823957324,1.02214717492461,0.976587641704828,0.880975933559239,1.15806307010353,1.05237276507542,1.06141054620966,1.02662328165025,1.07153961509466,1.04825929105282,0.861149036325514,0.974994347244501,0.871649812255055,1.10811092853546,1.03494000555947,0.819091975130141,1.16662738053128,1.10612854082137],"y":[35.3811778980652,44.8219715184304,39.2173032467429,51.0467175864377,57.065646571496,59.2583745783749,38.6269458335796,44.9047226313368,42.2549963304467,51.2502565642543,48.108659653327,45.0530525900592,42.7519932548031,50.7436497539717,54.5121505271154,31.8709522079484,35.8687235248078,50.8435780336784,25.3243994804453,57.9421212366076,42.9896341882336,44.1665187644521,31.3466674778537,45.8155917365736,47.1046667065194,41.1843045093704,43.0071088046759,42.6812983244253,41.2709028908419,31.8879943187694,31.9900716201833,51.1946790287161,54.1810269202146,56.6080142387776,31.0677757711284,54.4491498578571,47.3547547403568,56.1066379713011,59.7671752409216,33.8795865456588,52.500719786526,29.9646627974749,47.012457047925,61.1665444430676,37.415322174558,52.9711878087744,45.4632050151875,54.750585778299,34.586532194498,38.86011814353,58.0090077428656,35.8346878673852,41.5761912788066,29.3179361524087,60.0591684226618,55.1100335513044,59.0468217286712,44.0808285742799,47.4248902288718,46.8370364843163,68.6455901669851,44.7948606685633,51.776737329203,51.8210149729511,55.053580747997,46.4924477272146,32.6734009122175,39.1397096449609,47.1327113858191,39.3979003349048,49.2507706945753,40.1897944468376,31.6247393953437,40.2206619499785,62.1275164919012,35.2523658671875,66.7972824150252,52.5748571302188,49.1931598376863,49.5967865549996,53.1517354289546,58.4049164249284,59.7281402911733,57.1244954910085,55.5063725037733,70.498489544224,54.5679338659033,48.0452763746218,38.5027470191609,50.1325067716551,40.8909047205347,42.6637379981198,48.4916093586211,37.7017322967972,51.8699832698518,50.4443437912629,31.4504167390183,39.6232672294671,54.3183894372092,28.6860699565753,41.9410475635885,54.4813905787944,54.1113121661233,40.6246000133681,44.6281507228987,48.7287664689397,56.7567621607922,37.4859100119033,48.1239033896428,55.0533154143494,46.8802605332637,32.8610509760892,42.823883779389,59.4918958289697,64.9329092736719,39.0342870555263,25.0669689350711,36.1643610560199,54.1174389513585,51.9495317975065,46.2366885494556,49.587946549363,33.8384582638267,47.2061675037226,35.8788597847467,34.2114296225947,42.2958078886889,55.0481494299282,59.978749783638,28.5899161318859,52.2724600667564,46.8326576272608,71.2403290629513,39.2520466143459,52.3709259309121,56.8035035451839,52.0185899828462,25.7084260164093,58.2695765747047,30.2006472535596,58.6398099719759,48.5869282191415,68.9993089003824,44.1224401277201,51.6352379677984,68.1256644206222,27.5178283194337,42.0105894924589,34.9021605197341,33.9203369865282,47.7042043604661,43.0288296782435,47.0833880103838,53.7936520596596,32.6073505441537,60.8511638416271,61.6304037565955,41.7514365231247,57.8235421105175,46.6830805527213,44.8178276627585,56.0079950109924,55.6178165342756,29.8731706855415,55.8035286252884,36.067018332602,36.7166966248736,55.6039159953624,35.3682104344071,56.643538290697,39.6744681231543,49.3513315141119,37.8579810238087,31.1210086179983,34.8001389250396,57.6674665292238,59.2590003690604,38.0976018359415,35.9237616430318,40.5600595070076,61.3905630917231,63.0239659224377,50.4336376702161,57.7994051645972,47.7206817629305,54.9224929102974,77.5810683511197,50.2758570155833,43.3078407352268,47.1077409568026,41.7236401734888,46.1694883262395,51.4022235421503,24.9950458916537,42.1523982662211,32.4244147222287,51.8125853518243,35.212551897853,46.2326177977572,50.3069089522438,38.6447918040119,43.8248780394455,55.2093395374968,31.5901974750658,25.9038739965618,52.8338103867552,45.0320569941603,49.9511541876668,54.7643336558559,37.2151097969731,42.3243058111672,35.7886157551071,41.4763222832257,49.0254803902814,44.5529994139913,43.4532610442828,53.6106570528103,35.0881033521933,46.2897298993652,43.7619981214053,46.8458800903657,47.5529064151464,47.3783773378773,28.4077916753697,47.5240946575458,53.260051613555,47.4411617497182,37.2190516687142,43.0110042564814,52.5779689045228,38.6941466261844,41.5603994811627,34.8587754321875,31.9138372517676,38.8888660706534,51.7168702995673,36.5666853508916,46.4220885389424,46.4565119178831,37.1617973240384,42.889407883293,61.9734006224119,65.4138594410705,54.3588141859161,38.1510320786396,42.8246925006936,51.8479563105076,47.5340035961881,44.4926386913947,34.0216586094972,60.0294498247253,43.0588840511554,30.977292406543,53.0939955047098,39.2518296518348,48.1788376696666,50.7146213134774,40.3902587199197,29.134669673164,33.5623461291658,41.7380302293396,53.2188281297887,58.4282197257284,37.7604603384393,55.1806302709262,48.5414548164169,34.3235426878358,47.9972289812523,54.6189612604858,28.8536571535931,38.8403501967562,31.6049749200994,53.8964673020864,27.5430411333314,57.4371259511589,46.0790232775894,43.5438475657288,48.3930223835943,34.5449871002911,47.7052369045711,43.8887495568193,41.4711612763537,46.5674782261323,56.9703988109214,46.0844306953934,47.7349611131696,63.0575661125902,62.306333829638,53.0304576002181,24.0344741520413,36.0006339029012,46.6427926405313,47.2398587421419,38.4639831354719,36.2606496994207,57.1105217919983,36.4714847248397,49.0750797743774,72.2955245868335,47.9616617630947,41.7423441631097,55.7266773096622,44.5692095595866,37.7403625410456,44.3215192566116,41.3710508688733,36.1208769068858,44.7680079651631,54.0916852237344,27.4819374057567,44.0005282193953,59.7401171334029,32.901835539898,46.5564582820534,49.0960090186226,60.1805893960787,51.7415946881985,64.6380425918757,47.3824315979939,54.9385221202497,53.0136894665389,52.2162782603976,64.1456525544445,49.0354238356568,44.0781885036968,57.0445137111033,51.6821160568402,34.2332585892791,41.4426266430015,58.3817821209781,51.8312911457327,42.3281688523281,42.1239908646225,28.0595422843748,37.3030287865251,52.1242510390634,40.5924487690425,53.6736870322361,27.6404835096828,61.8156334556404,40.9544982178934,51.5792905375618,52.4233677398587,49.1690312209772,57.726950860457,34.9877445237654,38.9728408672699,41.6373623894274,42.4695220301696,48.4661096495681,47.0591990443877,59.4773829088427,63.9374262408604,57.5860100362243,38.1229725698407,39.1372571916366,44.7544488483543,35.0617604556116,41.3329867393869,38.3763401004266,36.8278250258893,61.7116182527638,29.4214319759866,41.9246020829454,39.0895947736108,47.6189198238223,69.8007328861621,28.0720917676133,26.4325202782375,47.9509278878915,31.5529172546707,28.3535263910498,54.3210455281708,41.5697576827806,55.4992064260723,50.0487046711159,43.0463527329072,58.8620093787008,58.0713524765874,21.3702695157613,33.3904300582367,40.087385663402,42.1002351917317,39.4996369987186,32.915521943964,28.8709354977335,34.5139815655534,36.6651255192073,41.1900188464134,42.357947062102,43.1257275777002,38.6217179018049,42.2778526631199,34.6674798749957,55.7698620460136,43.4942640179044,44.4332059011481,42.8751193406722,43.6947450427919,46.2677499208834,48.7751417642862,61.4741589704342,43.4918949824207,29.2744287974983,51.4817461411424,31.2432704849293,29.1055089802294,52.4220099889636,51.8250177264719,64.6052352941444,45.9755324315457,27.3116123145124,39.8311203577871,44.2856839387027,45.1262292461221,50.4791985981813,59.1191975065334,49.0881476063084,38.4282940883216,71.0780434694101,55.1624442521494,34.7807007843169,34.2421484268185,37.0354538189787,41.467806208145,38.2233657265271,68.9348396062863,45.3983674771773,45.1114025653748,58.3521541455263,47.126206223312,44.8781458778108,20.2576509187066,49.3635898258255,56.1665003391157,46.1057746654312,45.4855906755331,44.5592088268045,37.4887061558133,40.2958478079105,55.2972860712518,60.8803278593241,44.583590889843,37.8887549483432,47.3216088845618,40.8716305489611,24.924474725466,38.3025253145777,51.0464914906965,50.5922579722676,50.9234629607449,59.9802753800985,40.0233947275803,47.5095137678404,38.6038216419583,64.7763563441065,69.8801782011327,41.8830880454377,53.4188425762503,40.5871952469539,44.4593693031987,33.4565566858733,56.1254748261717,29.390420553251,50.9064255468724,58.0843215106214,47.3400050818469,47.2736233505797,42.9649607610517,28.3976885517259,53.3814706388523,46.5818485664013,47.4724360876433,38.885648947661,49.6351327440611,31.9868960271045,29.0072034413613,59.2852293590092,72.9948293765684,36.7691531958363,38.2152213017322,43.8876047788783,56.3051184827452,48.024474310634,51.8002572040429,47.8953450979482,33.1831481748138,41.042434440092,52.8709687116033,65.4483766561458,50.2008476999244,42.8385745713839,61.2716181621525,37.8619685544109,45.4940906814598,43.8782159335267,40.688232635243,37.1411654935385,41.9588758652705,31.2608583064805],"text":["pet: cat<br />happiness: 35.38118<br />pet: cat","pet: cat<br />happiness: 44.82197<br />pet: cat","pet: cat<br />happiness: 39.21730<br />pet: cat","pet: cat<br />happiness: 51.04672<br />pet: cat","pet: cat<br />happiness: 57.06565<br />pet: cat","pet: cat<br />happiness: 59.25837<br />pet: cat","pet: cat<br />happiness: 38.62695<br />pet: cat","pet: cat<br />happiness: 44.90472<br />pet: cat","pet: cat<br />happiness: 42.25500<br />pet: cat","pet: cat<br />happiness: 51.25026<br />pet: cat","pet: cat<br />happiness: 48.10866<br />pet: cat","pet: cat<br />happiness: 45.05305<br />pet: cat","pet: cat<br />happiness: 42.75199<br />pet: cat","pet: cat<br />happiness: 50.74365<br />pet: cat","pet: cat<br />happiness: 54.51215<br />pet: cat","pet: cat<br />happiness: 31.87095<br />pet: cat","pet: cat<br />happiness: 35.86872<br />pet: cat","pet: cat<br />happiness: 50.84358<br />pet: cat","pet: cat<br />happiness: 25.32440<br />pet: cat","pet: cat<br />happiness: 57.94212<br />pet: cat","pet: cat<br />happiness: 42.98963<br />pet: cat","pet: cat<br />happiness: 44.16652<br />pet: cat","pet: cat<br />happiness: 31.34667<br />pet: cat","pet: cat<br />happiness: 45.81559<br />pet: cat","pet: cat<br />happiness: 47.10467<br />pet: cat","pet: cat<br />happiness: 41.18430<br />pet: cat","pet: cat<br />happiness: 43.00711<br />pet: cat","pet: cat<br />happiness: 42.68130<br />pet: cat","pet: cat<br />happiness: 41.27090<br />pet: cat","pet: cat<br />happiness: 31.88799<br />pet: cat","pet: cat<br />happiness: 31.99007<br />pet: cat","pet: cat<br />happiness: 51.19468<br />pet: cat","pet: cat<br />happiness: 54.18103<br />pet: cat","pet: cat<br />happiness: 56.60801<br />pet: cat","pet: cat<br />happiness: 31.06778<br />pet: cat","pet: cat<br />happiness: 54.44915<br />pet: cat","pet: cat<br />happiness: 47.35475<br />pet: cat","pet: cat<br />happiness: 56.10664<br />pet: cat","pet: cat<br />happiness: 59.76718<br />pet: cat","pet: cat<br />happiness: 33.87959<br />pet: cat","pet: cat<br />happiness: 52.50072<br />pet: cat","pet: cat<br />happiness: 29.96466<br />pet: cat","pet: cat<br />happiness: 47.01246<br />pet: cat","pet: cat<br />happiness: 61.16654<br />pet: cat","pet: cat<br />happiness: 37.41532<br />pet: cat","pet: cat<br />happiness: 52.97119<br />pet: cat","pet: cat<br />happiness: 45.46321<br />pet: cat","pet: cat<br />happiness: 54.75059<br />pet: cat","pet: cat<br />happiness: 34.58653<br />pet: cat","pet: cat<br />happiness: 38.86012<br />pet: cat","pet: cat<br />happiness: 58.00901<br />pet: cat","pet: cat<br />happiness: 35.83469<br />pet: cat","pet: cat<br />happiness: 41.57619<br />pet: cat","pet: cat<br />happiness: 29.31794<br />pet: cat","pet: cat<br />happiness: 60.05917<br />pet: cat","pet: cat<br />happiness: 55.11003<br />pet: cat","pet: cat<br />happiness: 59.04682<br />pet: cat","pet: cat<br />happiness: 44.08083<br />pet: cat","pet: cat<br />happiness: 47.42489<br />pet: cat","pet: cat<br />happiness: 46.83704<br />pet: cat","pet: cat<br />happiness: 68.64559<br />pet: cat","pet: cat<br />happiness: 44.79486<br />pet: cat","pet: cat<br />happiness: 51.77674<br />pet: cat","pet: cat<br />happiness: 51.82101<br />pet: cat","pet: cat<br />happiness: 55.05358<br />pet: cat","pet: cat<br />happiness: 46.49245<br />pet: cat","pet: cat<br />happiness: 32.67340<br />pet: cat","pet: cat<br />happiness: 39.13971<br />pet: cat","pet: cat<br />happiness: 47.13271<br />pet: cat","pet: cat<br />happiness: 39.39790<br />pet: cat","pet: cat<br />happiness: 49.25077<br />pet: cat","pet: cat<br />happiness: 40.18979<br />pet: cat","pet: cat<br />happiness: 31.62474<br />pet: cat","pet: cat<br />happiness: 40.22066<br />pet: cat","pet: cat<br />happiness: 62.12752<br />pet: cat","pet: cat<br />happiness: 35.25237<br />pet: cat","pet: cat<br />happiness: 66.79728<br />pet: cat","pet: cat<br />happiness: 52.57486<br />pet: cat","pet: cat<br />happiness: 49.19316<br />pet: cat","pet: cat<br />happiness: 49.59679<br />pet: cat","pet: cat<br />happiness: 53.15174<br />pet: cat","pet: cat<br />happiness: 58.40492<br />pet: cat","pet: cat<br />happiness: 59.72814<br />pet: cat","pet: cat<br />happiness: 57.12450<br />pet: cat","pet: cat<br />happiness: 55.50637<br />pet: cat","pet: cat<br />happiness: 70.49849<br />pet: cat","pet: cat<br />happiness: 54.56793<br />pet: cat","pet: cat<br />happiness: 48.04528<br />pet: cat","pet: cat<br />happiness: 38.50275<br />pet: cat","pet: cat<br />happiness: 50.13251<br />pet: cat","pet: cat<br />happiness: 40.89090<br />pet: cat","pet: cat<br />happiness: 42.66374<br />pet: cat","pet: cat<br />happiness: 48.49161<br />pet: cat","pet: cat<br />happiness: 37.70173<br />pet: cat","pet: cat<br />happiness: 51.86998<br />pet: cat","pet: cat<br />happiness: 50.44434<br />pet: cat","pet: cat<br />happiness: 31.45042<br />pet: cat","pet: cat<br />happiness: 39.62327<br />pet: cat","pet: cat<br />happiness: 54.31839<br />pet: cat","pet: cat<br />happiness: 28.68607<br />pet: cat","pet: cat<br />happiness: 41.94105<br />pet: cat","pet: cat<br />happiness: 54.48139<br />pet: cat","pet: cat<br />happiness: 54.11131<br />pet: cat","pet: cat<br />happiness: 40.62460<br />pet: cat","pet: cat<br />happiness: 44.62815<br />pet: cat","pet: cat<br />happiness: 48.72877<br />pet: cat","pet: cat<br />happiness: 56.75676<br />pet: cat","pet: cat<br />happiness: 37.48591<br />pet: cat","pet: cat<br />happiness: 48.12390<br />pet: cat","pet: cat<br />happiness: 55.05332<br />pet: cat","pet: cat<br />happiness: 46.88026<br />pet: cat","pet: cat<br />happiness: 32.86105<br />pet: cat","pet: cat<br />happiness: 42.82388<br />pet: cat","pet: cat<br />happiness: 59.49190<br />pet: cat","pet: cat<br />happiness: 64.93291<br />pet: cat","pet: cat<br />happiness: 39.03429<br />pet: cat","pet: cat<br />happiness: 25.06697<br />pet: cat","pet: cat<br />happiness: 36.16436<br />pet: cat","pet: cat<br />happiness: 54.11744<br />pet: cat","pet: cat<br />happiness: 51.94953<br />pet: cat","pet: cat<br />happiness: 46.23669<br />pet: cat","pet: cat<br />happiness: 49.58795<br />pet: cat","pet: cat<br />happiness: 33.83846<br />pet: cat","pet: cat<br />happiness: 47.20617<br />pet: cat","pet: cat<br />happiness: 35.87886<br />pet: cat","pet: cat<br />happiness: 34.21143<br />pet: cat","pet: cat<br />happiness: 42.29581<br />pet: cat","pet: cat<br />happiness: 55.04815<br />pet: cat","pet: cat<br />happiness: 59.97875<br />pet: cat","pet: cat<br />happiness: 28.58992<br />pet: cat","pet: cat<br />happiness: 52.27246<br />pet: cat","pet: cat<br />happiness: 46.83266<br />pet: cat","pet: cat<br />happiness: 71.24033<br />pet: cat","pet: cat<br />happiness: 39.25205<br />pet: cat","pet: cat<br />happiness: 52.37093<br />pet: cat","pet: cat<br />happiness: 56.80350<br />pet: cat","pet: cat<br />happiness: 52.01859<br />pet: cat","pet: cat<br />happiness: 25.70843<br />pet: cat","pet: cat<br />happiness: 58.26958<br />pet: cat","pet: cat<br />happiness: 30.20065<br />pet: cat","pet: cat<br />happiness: 58.63981<br />pet: cat","pet: cat<br />happiness: 48.58693<br />pet: cat","pet: cat<br />happiness: 68.99931<br />pet: cat","pet: cat<br />happiness: 44.12244<br />pet: cat","pet: cat<br />happiness: 51.63524<br />pet: cat","pet: cat<br />happiness: 68.12566<br />pet: cat","pet: cat<br />happiness: 27.51783<br />pet: cat","pet: cat<br />happiness: 42.01059<br />pet: cat","pet: cat<br />happiness: 34.90216<br />pet: cat","pet: cat<br />happiness: 33.92034<br />pet: cat","pet: cat<br />happiness: 47.70420<br />pet: cat","pet: cat<br />happiness: 43.02883<br />pet: cat","pet: cat<br />happiness: 47.08339<br />pet: cat","pet: cat<br />happiness: 53.79365<br />pet: cat","pet: cat<br />happiness: 32.60735<br />pet: cat","pet: cat<br />happiness: 60.85116<br />pet: cat","pet: cat<br />happiness: 61.63040<br />pet: cat","pet: cat<br />happiness: 41.75144<br />pet: cat","pet: cat<br />happiness: 57.82354<br />pet: cat","pet: cat<br />happiness: 46.68308<br />pet: cat","pet: cat<br />happiness: 44.81783<br />pet: cat","pet: cat<br />happiness: 56.00800<br />pet: cat","pet: cat<br />happiness: 55.61782<br />pet: cat","pet: cat<br />happiness: 29.87317<br />pet: cat","pet: cat<br />happiness: 55.80353<br />pet: cat","pet: cat<br />happiness: 36.06702<br />pet: cat","pet: cat<br />happiness: 36.71670<br />pet: cat","pet: cat<br />happiness: 55.60392<br />pet: cat","pet: cat<br />happiness: 35.36821<br />pet: cat","pet: cat<br />happiness: 56.64354<br />pet: cat","pet: cat<br />happiness: 39.67447<br />pet: cat","pet: cat<br />happiness: 49.35133<br />pet: cat","pet: cat<br />happiness: 37.85798<br />pet: cat","pet: cat<br />happiness: 31.12101<br />pet: cat","pet: cat<br />happiness: 34.80014<br />pet: cat","pet: cat<br />happiness: 57.66747<br />pet: cat","pet: cat<br />happiness: 59.25900<br />pet: cat","pet: cat<br />happiness: 38.09760<br />pet: cat","pet: cat<br />happiness: 35.92376<br />pet: cat","pet: cat<br />happiness: 40.56006<br />pet: cat","pet: cat<br />happiness: 61.39056<br />pet: cat","pet: cat<br />happiness: 63.02397<br />pet: cat","pet: cat<br />happiness: 50.43364<br />pet: cat","pet: cat<br />happiness: 57.79941<br />pet: cat","pet: cat<br />happiness: 47.72068<br />pet: cat","pet: cat<br />happiness: 54.92249<br />pet: cat","pet: cat<br />happiness: 77.58107<br />pet: cat","pet: cat<br />happiness: 50.27586<br />pet: cat","pet: cat<br />happiness: 43.30784<br />pet: cat","pet: cat<br />happiness: 47.10774<br />pet: cat","pet: cat<br />happiness: 41.72364<br />pet: cat","pet: cat<br />happiness: 46.16949<br />pet: cat","pet: cat<br />happiness: 51.40222<br />pet: cat","pet: cat<br />happiness: 24.99505<br />pet: cat","pet: cat<br />happiness: 42.15240<br />pet: cat","pet: cat<br />happiness: 32.42441<br />pet: cat","pet: cat<br />happiness: 51.81259<br />pet: cat","pet: cat<br />happiness: 35.21255<br />pet: cat","pet: cat<br />happiness: 46.23262<br />pet: cat","pet: cat<br />happiness: 50.30691<br />pet: cat","pet: cat<br />happiness: 38.64479<br />pet: cat","pet: cat<br />happiness: 43.82488<br />pet: cat","pet: cat<br />happiness: 55.20934<br />pet: cat","pet: cat<br />happiness: 31.59020<br />pet: cat","pet: cat<br />happiness: 25.90387<br />pet: cat","pet: cat<br />happiness: 52.83381<br />pet: cat","pet: cat<br />happiness: 45.03206<br />pet: cat","pet: cat<br />happiness: 49.95115<br />pet: cat","pet: cat<br />happiness: 54.76433<br />pet: cat","pet: cat<br />happiness: 37.21511<br />pet: cat","pet: cat<br />happiness: 42.32431<br />pet: cat","pet: cat<br />happiness: 35.78862<br />pet: cat","pet: cat<br />happiness: 41.47632<br />pet: cat","pet: cat<br />happiness: 49.02548<br />pet: cat","pet: cat<br />happiness: 44.55300<br />pet: cat","pet: cat<br />happiness: 43.45326<br />pet: cat","pet: cat<br />happiness: 53.61066<br />pet: cat","pet: cat<br />happiness: 35.08810<br />pet: cat","pet: cat<br />happiness: 46.28973<br />pet: cat","pet: cat<br />happiness: 43.76200<br />pet: cat","pet: cat<br />happiness: 46.84588<br />pet: cat","pet: cat<br />happiness: 47.55291<br />pet: cat","pet: cat<br />happiness: 47.37838<br />pet: cat","pet: cat<br />happiness: 28.40779<br />pet: cat","pet: cat<br />happiness: 47.52409<br />pet: cat","pet: cat<br />happiness: 53.26005<br />pet: cat","pet: cat<br />happiness: 47.44116<br />pet: cat","pet: cat<br />happiness: 37.21905<br />pet: cat","pet: cat<br />happiness: 43.01100<br />pet: cat","pet: cat<br />happiness: 52.57797<br />pet: cat","pet: cat<br />happiness: 38.69415<br />pet: cat","pet: cat<br />happiness: 41.56040<br />pet: cat","pet: cat<br />happiness: 34.85878<br />pet: cat","pet: cat<br />happiness: 31.91384<br />pet: cat","pet: cat<br />happiness: 38.88887<br />pet: cat","pet: cat<br />happiness: 51.71687<br />pet: cat","pet: cat<br />happiness: 36.56669<br />pet: cat","pet: cat<br />happiness: 46.42209<br />pet: cat","pet: cat<br />happiness: 46.45651<br />pet: cat","pet: cat<br />happiness: 37.16180<br />pet: cat","pet: cat<br />happiness: 42.88941<br />pet: cat","pet: cat<br />happiness: 61.97340<br />pet: cat","pet: cat<br />happiness: 65.41386<br />pet: cat","pet: cat<br />happiness: 54.35881<br />pet: cat","pet: cat<br />happiness: 38.15103<br />pet: cat","pet: cat<br />happiness: 42.82469<br />pet: cat","pet: cat<br />happiness: 51.84796<br />pet: cat","pet: cat<br />happiness: 47.53400<br />pet: cat","pet: cat<br />happiness: 44.49264<br />pet: cat","pet: cat<br />happiness: 34.02166<br />pet: cat","pet: cat<br />happiness: 60.02945<br />pet: cat","pet: cat<br />happiness: 43.05888<br />pet: cat","pet: cat<br />happiness: 30.97729<br />pet: cat","pet: cat<br />happiness: 53.09400<br />pet: cat","pet: cat<br />happiness: 39.25183<br />pet: cat","pet: cat<br />happiness: 48.17884<br />pet: cat","pet: cat<br />happiness: 50.71462<br />pet: cat","pet: cat<br />happiness: 40.39026<br />pet: cat","pet: cat<br />happiness: 29.13467<br />pet: cat","pet: cat<br />happiness: 33.56235<br />pet: cat","pet: cat<br />happiness: 41.73803<br />pet: cat","pet: cat<br />happiness: 53.21883<br />pet: cat","pet: cat<br />happiness: 58.42822<br />pet: cat","pet: cat<br />happiness: 37.76046<br />pet: cat","pet: cat<br />happiness: 55.18063<br />pet: cat","pet: cat<br />happiness: 48.54145<br />pet: cat","pet: cat<br />happiness: 34.32354<br />pet: cat","pet: cat<br />happiness: 47.99723<br />pet: cat","pet: cat<br />happiness: 54.61896<br />pet: cat","pet: cat<br />happiness: 28.85366<br />pet: cat","pet: cat<br />happiness: 38.84035<br />pet: cat","pet: cat<br />happiness: 31.60497<br />pet: cat","pet: cat<br />happiness: 53.89647<br />pet: cat","pet: cat<br />happiness: 27.54304<br />pet: cat","pet: cat<br />happiness: 57.43713<br />pet: cat","pet: cat<br />happiness: 46.07902<br />pet: cat","pet: cat<br />happiness: 43.54385<br />pet: cat","pet: cat<br />happiness: 48.39302<br />pet: cat","pet: cat<br />happiness: 34.54499<br />pet: cat","pet: cat<br />happiness: 47.70524<br />pet: cat","pet: cat<br />happiness: 43.88875<br />pet: cat","pet: cat<br />happiness: 41.47116<br />pet: cat","pet: cat<br />happiness: 46.56748<br />pet: cat","pet: cat<br />happiness: 56.97040<br />pet: cat","pet: cat<br />happiness: 46.08443<br />pet: cat","pet: cat<br />happiness: 47.73496<br />pet: cat","pet: cat<br />happiness: 63.05757<br />pet: cat","pet: cat<br />happiness: 62.30633<br />pet: cat","pet: cat<br />happiness: 53.03046<br />pet: cat","pet: cat<br />happiness: 24.03447<br />pet: cat","pet: cat<br />happiness: 36.00063<br />pet: cat","pet: cat<br />happiness: 46.64279<br />pet: cat","pet: cat<br />happiness: 47.23986<br />pet: cat","pet: cat<br />happiness: 38.46398<br />pet: cat","pet: cat<br />happiness: 36.26065<br />pet: cat","pet: cat<br />happiness: 57.11052<br />pet: cat","pet: cat<br />happiness: 36.47148<br />pet: cat","pet: cat<br />happiness: 49.07508<br />pet: cat","pet: cat<br />happiness: 72.29552<br />pet: cat","pet: cat<br />happiness: 47.96166<br />pet: cat","pet: cat<br />happiness: 41.74234<br />pet: cat","pet: cat<br />happiness: 55.72668<br />pet: cat","pet: cat<br />happiness: 44.56921<br />pet: cat","pet: cat<br />happiness: 37.74036<br />pet: cat","pet: cat<br />happiness: 44.32152<br />pet: cat","pet: cat<br />happiness: 41.37105<br />pet: cat","pet: cat<br />happiness: 36.12088<br />pet: cat","pet: cat<br />happiness: 44.76801<br />pet: cat","pet: cat<br />happiness: 54.09169<br />pet: cat","pet: cat<br />happiness: 27.48194<br />pet: cat","pet: cat<br />happiness: 44.00053<br />pet: cat","pet: cat<br />happiness: 59.74012<br />pet: cat","pet: cat<br />happiness: 32.90184<br />pet: cat","pet: cat<br />happiness: 46.55646<br />pet: cat","pet: cat<br />happiness: 49.09601<br />pet: cat","pet: cat<br />happiness: 60.18059<br />pet: cat","pet: cat<br />happiness: 51.74159<br />pet: cat","pet: cat<br />happiness: 64.63804<br />pet: cat","pet: cat<br />happiness: 47.38243<br />pet: cat","pet: cat<br />happiness: 54.93852<br />pet: cat","pet: cat<br />happiness: 53.01369<br />pet: cat","pet: cat<br />happiness: 52.21628<br />pet: cat","pet: cat<br />happiness: 64.14565<br />pet: cat","pet: cat<br />happiness: 49.03542<br />pet: cat","pet: cat<br />happiness: 44.07819<br />pet: cat","pet: cat<br />happiness: 57.04451<br />pet: cat","pet: cat<br />happiness: 51.68212<br />pet: cat","pet: cat<br />happiness: 34.23326<br />pet: cat","pet: cat<br />happiness: 41.44263<br />pet: cat","pet: cat<br />happiness: 58.38178<br />pet: cat","pet: cat<br />happiness: 51.83129<br />pet: cat","pet: cat<br />happiness: 42.32817<br />pet: cat","pet: cat<br />happiness: 42.12399<br />pet: cat","pet: cat<br />happiness: 28.05954<br />pet: cat","pet: cat<br />happiness: 37.30303<br />pet: cat","pet: cat<br />happiness: 52.12425<br />pet: cat","pet: cat<br />happiness: 40.59245<br />pet: cat","pet: cat<br />happiness: 53.67369<br />pet: cat","pet: cat<br />happiness: 27.64048<br />pet: cat","pet: cat<br />happiness: 61.81563<br />pet: cat","pet: cat<br />happiness: 40.95450<br />pet: cat","pet: cat<br />happiness: 51.57929<br />pet: cat","pet: cat<br />happiness: 52.42337<br />pet: cat","pet: cat<br />happiness: 49.16903<br />pet: cat","pet: cat<br />happiness: 57.72695<br />pet: cat","pet: cat<br />happiness: 34.98774<br />pet: cat","pet: cat<br />happiness: 38.97284<br />pet: cat","pet: cat<br />happiness: 41.63736<br />pet: cat","pet: cat<br />happiness: 42.46952<br />pet: cat","pet: cat<br />happiness: 48.46611<br />pet: cat","pet: cat<br />happiness: 47.05920<br />pet: cat","pet: cat<br />happiness: 59.47738<br />pet: cat","pet: cat<br />happiness: 63.93743<br />pet: cat","pet: cat<br />happiness: 57.58601<br />pet: cat","pet: cat<br />happiness: 38.12297<br />pet: cat","pet: cat<br />happiness: 39.13726<br />pet: cat","pet: cat<br />happiness: 44.75445<br />pet: cat","pet: cat<br />happiness: 35.06176<br />pet: cat","pet: cat<br />happiness: 41.33299<br />pet: cat","pet: cat<br />happiness: 38.37634<br />pet: cat","pet: cat<br />happiness: 36.82783<br />pet: cat","pet: cat<br />happiness: 61.71162<br />pet: cat","pet: cat<br />happiness: 29.42143<br />pet: cat","pet: cat<br />happiness: 41.92460<br />pet: cat","pet: cat<br />happiness: 39.08959<br />pet: cat","pet: cat<br />happiness: 47.61892<br />pet: cat","pet: cat<br />happiness: 69.80073<br />pet: cat","pet: cat<br />happiness: 28.07209<br />pet: cat","pet: cat<br />happiness: 26.43252<br />pet: cat","pet: cat<br />happiness: 47.95093<br />pet: cat","pet: cat<br />happiness: 31.55292<br />pet: cat","pet: cat<br />happiness: 28.35353<br />pet: cat","pet: cat<br />happiness: 54.32105<br />pet: cat","pet: cat<br />happiness: 41.56976<br />pet: cat","pet: cat<br />happiness: 55.49921<br />pet: cat","pet: cat<br />happiness: 50.04870<br />pet: cat","pet: cat<br />happiness: 43.04635<br />pet: cat","pet: cat<br />happiness: 58.86201<br />pet: cat","pet: cat<br />happiness: 58.07135<br />pet: cat","pet: cat<br />happiness: 21.37027<br />pet: cat","pet: cat<br />happiness: 33.39043<br />pet: cat","pet: cat<br />happiness: 40.08739<br />pet: cat","pet: cat<br />happiness: 42.10024<br />pet: cat","pet: cat<br />happiness: 39.49964<br />pet: cat","pet: cat<br />happiness: 32.91552<br />pet: cat","pet: cat<br />happiness: 28.87094<br />pet: cat","pet: cat<br />happiness: 34.51398<br />pet: cat","pet: cat<br />happiness: 36.66513<br />pet: cat","pet: cat<br />happiness: 41.19002<br />pet: cat","pet: cat<br />happiness: 42.35795<br />pet: cat","pet: cat<br />happiness: 43.12573<br />pet: cat","pet: cat<br />happiness: 38.62172<br />pet: cat","pet: cat<br />happiness: 42.27785<br />pet: cat","pet: cat<br />happiness: 34.66748<br />pet: cat","pet: cat<br />happiness: 55.76986<br />pet: cat","pet: cat<br />happiness: 43.49426<br />pet: cat","pet: cat<br />happiness: 44.43321<br />pet: cat","pet: cat<br />happiness: 42.87512<br />pet: cat","pet: cat<br />happiness: 43.69475<br />pet: cat","pet: cat<br />happiness: 46.26775<br />pet: cat","pet: cat<br />happiness: 48.77514<br />pet: cat","pet: cat<br />happiness: 61.47416<br />pet: cat","pet: cat<br />happiness: 43.49189<br />pet: cat","pet: cat<br />happiness: 29.27443<br />pet: cat","pet: cat<br />happiness: 51.48175<br />pet: cat","pet: cat<br />happiness: 31.24327<br />pet: cat","pet: cat<br />happiness: 29.10551<br />pet: cat","pet: cat<br />happiness: 52.42201<br />pet: cat","pet: cat<br />happiness: 51.82502<br />pet: cat","pet: cat<br />happiness: 64.60524<br />pet: cat","pet: cat<br />happiness: 45.97553<br />pet: cat","pet: cat<br />happiness: 27.31161<br />pet: cat","pet: cat<br />happiness: 39.83112<br />pet: cat","pet: cat<br />happiness: 44.28568<br />pet: cat","pet: cat<br />happiness: 45.12623<br />pet: cat","pet: cat<br />happiness: 50.47920<br />pet: cat","pet: cat<br />happiness: 59.11920<br />pet: cat","pet: cat<br />happiness: 49.08815<br />pet: cat","pet: cat<br />happiness: 38.42829<br />pet: cat","pet: cat<br />happiness: 71.07804<br />pet: cat","pet: cat<br />happiness: 55.16244<br />pet: cat","pet: cat<br />happiness: 34.78070<br />pet: cat","pet: cat<br />happiness: 34.24215<br />pet: cat","pet: cat<br />happiness: 37.03545<br />pet: cat","pet: cat<br />happiness: 41.46781<br />pet: cat","pet: cat<br />happiness: 38.22337<br />pet: cat","pet: cat<br />happiness: 68.93484<br />pet: cat","pet: cat<br />happiness: 45.39837<br />pet: cat","pet: cat<br />happiness: 45.11140<br />pet: cat","pet: cat<br />happiness: 58.35215<br />pet: cat","pet: cat<br />happiness: 47.12621<br />pet: cat","pet: cat<br />happiness: 44.87815<br />pet: cat","pet: cat<br />happiness: 20.25765<br />pet: cat","pet: cat<br />happiness: 49.36359<br />pet: cat","pet: cat<br />happiness: 56.16650<br />pet: cat","pet: cat<br />happiness: 46.10577<br />pet: cat","pet: cat<br />happiness: 45.48559<br />pet: cat","pet: cat<br />happiness: 44.55921<br />pet: cat","pet: cat<br />happiness: 37.48871<br />pet: cat","pet: cat<br />happiness: 40.29585<br />pet: cat","pet: cat<br />happiness: 55.29729<br />pet: cat","pet: cat<br />happiness: 60.88033<br />pet: cat","pet: cat<br />happiness: 44.58359<br />pet: cat","pet: cat<br />happiness: 37.88875<br />pet: cat","pet: cat<br />happiness: 47.32161<br />pet: cat","pet: cat<br />happiness: 40.87163<br />pet: cat","pet: cat<br />happiness: 24.92447<br />pet: cat","pet: cat<br />happiness: 38.30253<br />pet: cat","pet: cat<br />happiness: 51.04649<br />pet: cat","pet: cat<br />happiness: 50.59226<br />pet: cat","pet: cat<br />happiness: 50.92346<br />pet: cat","pet: cat<br />happiness: 59.98028<br />pet: cat","pet: cat<br />happiness: 40.02339<br />pet: cat","pet: cat<br />happiness: 47.50951<br />pet: cat","pet: cat<br />happiness: 38.60382<br />pet: cat","pet: cat<br />happiness: 64.77636<br />pet: cat","pet: cat<br />happiness: 69.88018<br />pet: cat","pet: cat<br />happiness: 41.88309<br />pet: cat","pet: cat<br />happiness: 53.41884<br />pet: cat","pet: cat<br />happiness: 40.58720<br />pet: cat","pet: cat<br />happiness: 44.45937<br />pet: cat","pet: cat<br />happiness: 33.45656<br />pet: cat","pet: cat<br />happiness: 56.12547<br />pet: cat","pet: cat<br />happiness: 29.39042<br />pet: cat","pet: cat<br />happiness: 50.90643<br />pet: cat","pet: cat<br />happiness: 58.08432<br />pet: cat","pet: cat<br />happiness: 47.34001<br />pet: cat","pet: cat<br />happiness: 47.27362<br />pet: cat","pet: cat<br />happiness: 42.96496<br />pet: cat","pet: cat<br />happiness: 28.39769<br />pet: cat","pet: cat<br />happiness: 53.38147<br />pet: cat","pet: cat<br />happiness: 46.58185<br />pet: cat","pet: cat<br />happiness: 47.47244<br />pet: cat","pet: cat<br />happiness: 38.88565<br />pet: cat","pet: cat<br />happiness: 49.63513<br />pet: cat","pet: cat<br />happiness: 31.98690<br />pet: cat","pet: cat<br />happiness: 29.00720<br />pet: cat","pet: cat<br />happiness: 59.28523<br />pet: cat","pet: cat<br />happiness: 72.99483<br />pet: cat","pet: cat<br />happiness: 36.76915<br />pet: cat","pet: cat<br />happiness: 38.21522<br />pet: cat","pet: cat<br />happiness: 43.88760<br />pet: cat","pet: cat<br />happiness: 56.30512<br />pet: cat","pet: cat<br />happiness: 48.02447<br />pet: cat","pet: cat<br />happiness: 51.80026<br />pet: cat","pet: cat<br />happiness: 47.89535<br />pet: cat","pet: cat<br />happiness: 33.18315<br />pet: cat","pet: cat<br />happiness: 41.04243<br />pet: cat","pet: cat<br />happiness: 52.87097<br />pet: cat","pet: cat<br />happiness: 65.44838<br />pet: cat","pet: cat<br />happiness: 50.20085<br />pet: cat","pet: cat<br />happiness: 42.83857<br />pet: cat","pet: cat<br />happiness: 61.27162<br />pet: cat","pet: cat<br />happiness: 37.86197<br />pet: cat","pet: cat<br />happiness: 45.49409<br />pet: cat","pet: cat<br />happiness: 43.87822<br />pet: cat","pet: cat<br />happiness: 40.68823<br />pet: cat","pet: cat<br />happiness: 37.14117<br />pet: cat","pet: cat<br />happiness: 41.95888<br />pet: cat","pet: cat<br />happiness: 31.26086<br />pet: cat"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"cat","legendgroup":"cat","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2.00126951057464,1.95370249841362,2.17789688576013,2.00226885313168,2.15034499522299,2.13157089482993,2.03065094854683,2.09551846189424,2.06705205347389,2.06539737246931,2.01294439155608,2.07908135671169,1.85092740161344,1.93165974635631,2.15564784612507,2.15216641323641,2.05816251030192,1.89211696228012,2.17034894749522,2.18215401005,1.9889829384163,2.12389000989497,1.95847936542705,2.01359952380881,2.19421091685072,1.95344134448096,1.91099578803405,2.1369413045235,2.09436691459268,1.93722498985007,2.09248597733676,1.80230369763449,1.93861583555117,1.96508152037859,1.98475853633136,2.15225276360288,1.81335892248899,2.15180616695434,1.82590489145368,1.89229097887874,2.12164324624464,1.95070525789633,1.85280413422734,2.03200103668496,2.10560022974387,1.84853650117293,1.92728267963976,1.90795922381803,2.00218354323879,1.92711144424975,2.00303944991902,1.99575690440834,1.96991034653038,1.98316015126184,1.86661785515025,1.82417827351019,1.99390022214502,1.8264937822707,2.14956969721243,2.15308999018744,1.90340595915914,2.17055785767734,2.07238928163424,2.15919970767573,2.10385548733175,1.844898023922,1.82023043306544,2.1028746271506,2.063283287175,2.06321692653,1.92551052514464,2.15819395324215,1.96648794906214,2.03562512127683,1.90394398532808,1.99394829794765,1.84795977696776,1.89022606266662,2.03577282680199,2.11842531338334,1.96052880100906,1.85655334368348,1.97665283475071,2.19005811112002,2.01740122977644,2.06261378135532,1.86521181520075,1.94670343045145,1.96749123502523,2.1557715353556,2.1505901102908,2.15750833870843,1.9061094163917,1.9485953329131,2.17607993735,2.1640268696472,2.09826967380941,2.14617425473407,1.98562714671716,1.922587627545,2.08726197276264,1.81732912184671,2.10524675743654,2.04908514004201,2.10039398223162,2.19049341641366,2.11540923267603,2.03516261912882,2.19137217272073,1.92557130400091,1.92826181966811,1.80951907699928,1.83112302524969,2.02950658854097,2.07989997193217,2.15227277707309,1.9833531155251,1.89440531702712,1.89304436417297,1.95033267717808,2.03070138059556,2.16016383413225,2.12227035705,1.80951429782435,1.86976371211931,2.02726492667571,2.1134593158029,1.83322477620095,1.84930454064161,1.94572289502248,2.06942763449624,2.06263692704961,2.03514660289511,1.82334415689111,1.84656520215794,2.06747075701132,2.00602761749178,1.91916667893529,1.84294430725276,2.16531805414706,1.86622825395316,1.85189043721184,2.05007842453197,2.10781128332019,1.92586788842455,2.13643353646621,2.18194219022989,1.96462682457641,2.10040743099526,2.00065543288365,2.0153057073243,1.8859022825025,1.86932612508535,1.83899119300768,1.86658201701939,2.11460903156549,1.85117174256593,2.05301797706634,1.80334118437022,2.06620690738782,1.98689224161208,1.82388071464375,1.90745098041371,1.8573623211123,1.87566834827885,1.96904840748757,2.01607195865363,1.99194865068421,1.86892000036314,2.02081800606102,1.85666094291955,1.87344043338671,2.06188393803313,2.00418039429933,2.12114716153592,2.04273876259103,2.00509882988408,2.08327777506784,1.81716298274696,1.99023688016459,2.03572811717167,1.88685909565538,1.82294309483841,1.95887402873486,2.11133976038545,2.12747855158523,1.88613100470975,2.13887810530141,1.93755036946386,2.01805165214464,2.10001118155196,1.80133352857083,2.04842235380784,1.9303295169957,1.87299520196393,2.12805143492296,2.02296666037291,2.16476660743356,1.94584628669545,1.80852826144546,1.88330351086333,2.06333410032094,2.00707100667059,1.8491000527516,2.17806740943342,2.1124601373449,1.85149735826999,1.91830438347533,1.93434146856889,1.87852172162384,2.09327121973038,1.97930070869625,1.96680608205497,2.06712690778077,1.97839722493663,2.09836052143946,2.11366333849728,2.08195004109293,2.07011330761015,2.12842400427908,2.12485991213471,2.06073613474146,1.95291864257306,1.87443323507905,1.92021978618577,1.95682672504336,1.95308101242408,2.04897691374645,2.04243839103729,1.96805147463456,1.98419865686446,1.91866194484755,2.06542490245774,2.0522114591673,2.12208312228322,2.1953484557569,2.05051285363734,2.10431142579764,1.9419835829176,1.87697773575783,1.9489926410839,1.99178394451737,2.13876942507923,1.88025961881503,1.9874092258513,1.87876953585073,2.0572089494206,1.98253797991201,2.13402819503099,1.902343894355,2.11842402489856,2.1309879725799,2.05857996940613,2.02179731726646,2.01177554670721,1.8947537320666,2.10442417450249,2.19524301895872,1.95730512635782,1.98180004619062,2.02830931441858,2.10714636305347,1.95382128274068,1.82136294953525,2.19286632398143,2.15079967398196,2.0539016042836,2.13735081953928,2.05818718541414,1.97341999011114,1.85918559739366,2.08130470374599,1.99563913997263,1.92798150824383,1.81957512451336,2.02623441275209,1.81002577636391,1.91801235647872,1.80970673207194,1.95105880890042,1.94315934106708,1.8922888206318,2.11949264751747,2.06932579101995,2.08164086742327,1.94578378330916,2.14339735880494,1.80836217775941,2.00919288173318,2.14210122795776,1.92012715609744,1.90657774144784,2.1396428398788,2.09935104558244,2.1493659330532,1.99934870013967,2.05187136372551,2.14817757718265,1.8455128531903,1.91537960218266,2.18260055379942,1.82671464560553,2.14684645328671,2.17657262338325,1.90970575576648,2.13846847685054,1.93473705463111,1.97291283328086,2.02571110818535,1.91670040301979,1.96396253611892,2.07562114540488,1.95536439279094,1.89609884954989,1.85539589580148,1.98619656916708,2.10870926389471,2.06619435921311,2.15618503233418,2.09785782201216,2.19889807878062,1.86778084877878,1.8996487355791,1.92031165314838,2.19621843528002,1.8362045140937,1.93211692804471,2.17226795963943,2.1343147081323,2.17828715518117,2.16531394217163,1.86188025996089,2.01338756484911,2.16462428700179,2.09668985223398,2.16955104880035,1.87434578789398,1.80253325877711,2.08102537384257,1.98523169066757,2.15147364288568,1.89120929110795,2.1054096265696,1.90122383097187,1.8248717312701,1.8426208996214,2.01904726624489,2.05182112343609,2.07375225191936,1.91069591967389,1.88667203681543,1.93605829235166,2.12280520480126,1.81592516517267,1.91885683210567,1.82996252849698,1.80860569374636,1.96324586635455,1.80690304702148,2.14785791430622,2.09400730933994,2.16647323248908,2.1660483869724,1.96060059461743,1.90954755572602,1.88819130435586,2.03277559075505,1.80986749092117,2.11692761639133,2.01580140702426,1.94314680332318,1.97340080263093,1.93618208728731,2.13881254065782,1.85986462496221,1.95016842763871,2.00275520766154,2.02457240661606,1.8271331852302,1.82857563979924,1.90390527117997,2.15211706068367,1.96964625716209,1.87519389241934,1.95733143752441,1.8079812922515,2.10356283579022,1.94467141274363,1.93514203531668,2.0313140465878,2.08664847835898,1.96314686415717,1.99041394228116,1.93480715751648,1.81424117395654,2.03945927703753,2.01188651267439,1.91085583493114,2.08703640457243,1.84641191065311,2.04440978346393,1.97443221611902,1.83121195677668,1.81622895048931,1.92096451008692,2.14755620667711,1.87348873419687,1.99160616016015,2.10882426155731,1.99541801279411,2.18220108877867,1.99592054123059,2.17590227266774,2.1876319215633,2.03629911541939,1.81546451104805,2.09153238842264,2.00205942979082,1.81345018856227,1.91810409240425,2.07622141977772,2.16601864965633,2.12353996699676,1.86126354839653,2.16143636601046,1.95149405859411,1.92526305988431,1.93390461243689,2.11268824581057,1.94495630972087,2.12908457070589,1.91078276680782,2.18984624054283,2.1924078934826,1.87593696946278,2.19020219929516,2.12301644701511,1.9458205319941,2.14850283032283,2.10065976399928,2.17553763892502,2.16747494507581,1.86391711933538,2.13238698523492,2.00674248086289,2.13492462718859,2.07847838811576,2.03569117989391,2.14568047840148,2.1819781569764,1.81485064439476,1.81821498908103,1.88848147839308,2.10185810886323,2.11631663870066,1.92526833601296,2.05765724889934,2.19346729954705,2.01270411405712,2.17776355231181,1.8535450710915,1.82096918812022,2.11729185841978,2.14592009121552,2.17044864445925,1.9679062356241,2.09885231684893,1.83578921565786,2.09231907334179,2.06668843245134,1.93565710177645,1.87277366174385,1.94856871524826,2.09316609557718,1.8632442346774,2.07003589970991,2.05003233607858,1.86488467557356,2.00092155886814,1.85612538047135,1.83112282352522,1.96525396825746,1.86216536844149,2.11599638778716,1.82235759804025,1.88611175017431,2.03935806006193,1.86675823032856,1.95950459195301,1.8865070794709,1.85615156153217,1.89536970099434,2.05418598121032,2.13912457432598,1.90729320859537,1.92176728546619,2.00958633869886,1.99109777351841,1.99794911528006,2.13428906854242],"y":[59.3232970155649,62.0470124238799,62.7223650150982,51.0812706480202,57.792142093518,24.2050840549579,58.4824679235144,65.5486362525563,50.6123397981094,46.1055443388724,58.959497168528,55.6817672169934,61.5963696341057,48.7058762348572,44.0239519072813,40.9786803479715,41.5561627916918,42.6124479761828,65.6799156779876,56.5954514334278,46.0247163265014,68.9530280314266,46.600058571875,60.6427216731335,51.0112767666846,51.306876387846,43.4369659393814,46.8681875413508,54.119027376187,58.2192045403988,44.684245353342,77.8459087157233,60.3199767004849,45.1503143654938,33.50115032338,30.4096168001683,59.3989794799624,63.3279023045472,53.8855057618221,54.7387766259985,74.6828507480383,59.2757386775091,69.7494668496896,56.2774788801195,41.6526673388154,49.2661122011897,61.8335497793372,68.1170601263406,65.8810420977537,49.0444361152227,62.6634686089561,47.5080161719613,54.9848283139041,40.9227162413551,50.9468818805633,55.9713564707288,59.7001590441541,56.2651306234764,50.1001499372122,54.791521765202,52.8073084971205,46.4053971936761,43.3338573983132,40.7436927229748,52.0191743362766,31.7593309390562,66.274526299453,65.7919089904336,55.7618422585182,68.0974573123317,49.1792496243595,49.4387226383743,45.8434517698742,77.8442681827855,48.8742601460754,71.4804399370992,59.2422857643597,64.8662314597421,50.0655507572252,44.5424030549729,60.7846674214035,58.8177873148574,61.9570390482191,41.8614548430263,55.6898951059615,47.9004570191576,51.2669960427495,46.1824966534775,59.4988290844428,61.3836508257284,55.7676189378681,61.158259744373,60.0477677391226,50.3144760086114,51.4326621852644,51.8695928873157,59.6590854062588,69.5479588927877,66.7893897878122,50.9347017749029,62.5111593934315,48.7085960504816,72.4079857887089,36.4836568635729,64.1156050414231,60.7191706002648,52.8584613955895,68.1643250292781,56.9308191613008,56.2273543883906,55.6482697363725,47.1470142433931,56.7059199542052,32.5392965080912,34.7689074453395,58.1270572047469,61.3678785270267,52.8235423710894,49.8007974319455,49.1029692477851,39.6736946097674,45.7502718036266,43.0856843250749,35.1994951560491,65.603316463044,74.1796656260543,61.484581773149,50.4660336314899,32.5485010472447,53.0891943328322,45.5437163315726,44.4705803610746,37.909813120533,31.1898939170397,57.1026034494193,58.2796107230929,50.5829714044371,52.7692423265948,56.4772414587902,72.4931388204588,63.0195314305468,65.9237753428125,42.452425426363,50.3936353478637,43.1693278575398,42.5697860544963,34.5786334245869,51.6986393200442,47.9982848446813,54.2754963017401,60.229061987575,45.4912591249763,68.6232639625269,57.4209161374242,72.5980231852044,36.9681547624803,61.3080079852848,55.2932970259702,56.6290374552751,47.5141116697807,60.681899094328,58.5367977167238,67.3761194524629,49.3082047604054,48.3974289753025,53.8877732418167,61.1108919657462,43.7982838367799,65.3511790971099,51.8651738340103,44.6849257517246,50.329840684079,37.0972097561973,53.3073520546312,46.3006284469092,52.4589373500347,54.5593865813085,41.7084976837727,48.5371030768371,56.3692412772575,62.996576159593,55.1848409118493,34.3249991850828,51.0225115057366,65.7257251006702,55.6462105049644,56.7547475297714,64.1400904450003,67.6094824276937,62.7041712750177,49.1783097118301,46.4325855302422,48.9411803194589,43.9542364479464,59.8506058033076,42.3975300767922,69.7887206341218,40.1661036810368,39.8832513335655,65.0860463724127,52.1731669274357,60.5179014894746,49.078710247694,58.3753809744395,54.1410694329306,27.2157629007869,64.1663990383969,56.8228766903454,55.0094292696423,59.9717954870123,38.8225266137207,64.1487400862298,67.4170103536868,58.6813025589746,37.6951397620935,59.8119917640012,58.1526839621835,60.5764178792556,52.4640148691514,42.4985622268364,54.4879311387778,55.9074012566349,66.5798528418457,44.2036183268791,47.8756050736637,69.2286862640933,55.0186927973383,67.5023871238164,59.0451646071944,66.8010261389852,57.6352385337934,52.8373687551018,65.1630479520935,58.4423256013926,67.2507891238831,54.4942076893014,55.4713400512423,57.5784064317438,46.0994672760059,71.27501271407,56.8130431891919,52.0641001570804,61.0744390611452,48.95369567116,71.1081520255361,46.1361956899123,48.2483797797195,66.1711869880248,74.6671142529607,39.1880255088707,49.1621666333193,46.8303267238942,49.8788311472205,53.0148137683229,51.235619493,39.5734774415124,48.6200950768545,55.8112784431699,43.4139867952147,55.5493999969385,53.1218405226362,57.7734239873928,59.192961438998,51.9755712591652,58.8728428211184,59.6823964449591,70.9537888221438,58.0399320474756,53.7603220476104,42.6164218449405,85.3392885608209,80.5191075981226,10.7905912904778,53.7324593500776,38.827965336431,72.5069051470691,60.9502506958558,39.7733563560786,64.4865479069665,46.1149474611005,83.0689807059198,65.9174934067721,58.8968170615751,68.8209738430891,64.1800566150289,74.2749105203193,63.1891599406191,61.0325258079339,50.3880481508301,40.2111530488832,64.7747586989139,53.049617904852,61.7265827707602,63.4401668525257,60.8440029463998,58.6482990591463,52.7342410231635,43.3240020851225,57.1643722646014,53.9004577836023,54.8493387728102,51.9921906877755,76.1413395256501,62.5761729702212,56.8683661574053,49.6478969215104,47.5082223527396,65.2354668894749,31.6155203436696,48.2682605363857,54.8116324500191,54.8704815910262,47.3099589421468,48.5578131805244,71.8872998010086,54.9273341262255,41.9653758203657,68.675181616562,61.0824888603749,36.8027635767685,62.0187477655124,55.3547604084032,58.3264047331658,46.9698992703384,67.30933466746,48.7422275764969,48.5306206143428,35.1300880183543,43.8201605155701,59.9908191809927,53.9472415645694,49.3968320981759,56.999775830458,75.1481073600579,58.9432238486723,61.0962907809223,62.2076525014089,47.7421613031437,52.4254836694953,67.2788022787154,48.5397365225738,57.0996723873929,61.3852151065293,54.8844025917933,49.0082925756674,57.7655752732984,59.9941346130654,45.7590453831646,63.1157554316964,64.0134789985866,57.4607278447799,64.3579194697997,55.4977479505777,40.1275221745971,47.0308147679925,54.0562185483086,43.6108788687828,70.0846878173258,50.3664570260182,59.9761519384762,43.3765284768161,47.3877602635069,50.2861253986795,51.6695499116486,47.928244076725,43.7310565664776,50.0007968699658,48.7492950261453,56.8424401491562,61.5146730457016,46.952500350264,61.3459276946868,42.0554397660588,42.5499173734787,53.6789245134316,46.0928020304213,46.7328825814869,41.2426508987843,55.3179235370556,40.0808716456388,33.7216297667535,68.8824821736627,44.4862127211559,51.1703909841618,37.009103738099,58.9610752866269,52.5295627970849,42.7425504939757,54.2272520544965,41.7731818721505,51.5482084981561,39.7458363447026,55.4819037966458,62.0847325217116,52.7678390079499,58.5988516474045,55.1714118583384,52.8193814445724,41.7995884256485,42.9704630764684,57.2641867416187,53.1501082615327,65.6858526976121,62.4030951698301,46.9942102063916,55.3928491848184,72.3379886614838,71.3539772044699,54.6576823100427,57.2695695086765,70.956869286385,58.1379289407313,63.2642705037403,57.3317374488586,32.7835081299829,61.2229370482507,56.1413377571063,53.3549062326636,54.8782027985905,46.3271501016871,91.5383226642589,65.6453615757837,56.2749213127824,45.2386313713074,48.324269728738,55.1893028543878,52.7920078454061,58.213917150366,64.59726838744,51.7665956122559,44.2219003286043,38.2301221849606,53.1376830989117,75.9846605956824,68.3299500421054,46.0044916014967,63.5923757676696,75.2260081228939,64.6385798239374,48.1757101146743,78.2528130584451,62.9448322519349,55.2174121523765,40.3338693532993,74.1219141883748,41.8672471701971,57.6465929532154,64.4052233426529,60.2362527022626,62.6427825863137,54.3132867344827,57.8231928804619,40.237496308156,50.845621057552,45.6328613585221,66.0243841388562,63.7424734634001,49.4023227353767,58.7592218087206,43.001293115553,54.1230403659215,47.8871738829274,72.9055250131351,49.454767634396,56.8808263542661,54.3845404846844,52.9098523030061,62.5846476958829,57.1279883272587,65.5628868139919,51.5000935032718,56.6648181899508,51.4539890814112,48.5236939563452,64.6835944761806,49.664083741181,69.601714653558,64.1304954012244,67.915016003606,45.2669411976417,53.1440066844341,59.3165586084409,46.5487631606704,58.9750074057627,44.4191070943389,63.8609823251104,65.6904632960339,52.748135838416,33.4485776097717,57.440655110435,34.930875975774,64.584880940615,72.2200096872503,43.2069352253506,66.3778506373015,63.0610967681046,49.49945977465,50.0755794699864,60.6956865225291,56.3276364145066],"text":["pet: dog<br />happiness: 59.32330<br />pet: dog","pet: dog<br />happiness: 62.04701<br />pet: dog","pet: dog<br />happiness: 62.72237<br />pet: dog","pet: dog<br />happiness: 51.08127<br />pet: dog","pet: dog<br />happiness: 57.79214<br />pet: dog","pet: dog<br />happiness: 24.20508<br />pet: dog","pet: dog<br />happiness: 58.48247<br />pet: dog","pet: dog<br />happiness: 65.54864<br />pet: dog","pet: dog<br />happiness: 50.61234<br />pet: dog","pet: dog<br />happiness: 46.10554<br />pet: dog","pet: dog<br />happiness: 58.95950<br />pet: dog","pet: dog<br />happiness: 55.68177<br />pet: dog","pet: dog<br />happiness: 61.59637<br />pet: dog","pet: dog<br />happiness: 48.70588<br />pet: dog","pet: dog<br />happiness: 44.02395<br />pet: dog","pet: dog<br />happiness: 40.97868<br />pet: dog","pet: dog<br />happiness: 41.55616<br />pet: dog","pet: dog<br />happiness: 42.61245<br />pet: dog","pet: dog<br />happiness: 65.67992<br />pet: dog","pet: dog<br />happiness: 56.59545<br />pet: dog","pet: dog<br />happiness: 46.02472<br />pet: dog","pet: dog<br />happiness: 68.95303<br />pet: dog","pet: dog<br />happiness: 46.60006<br />pet: dog","pet: dog<br />happiness: 60.64272<br />pet: dog","pet: dog<br />happiness: 51.01128<br />pet: dog","pet: dog<br />happiness: 51.30688<br />pet: dog","pet: dog<br />happiness: 43.43697<br />pet: dog","pet: dog<br />happiness: 46.86819<br />pet: dog","pet: dog<br />happiness: 54.11903<br />pet: dog","pet: dog<br />happiness: 58.21920<br />pet: dog","pet: dog<br />happiness: 44.68425<br />pet: dog","pet: dog<br />happiness: 77.84591<br />pet: dog","pet: dog<br />happiness: 60.31998<br />pet: dog","pet: dog<br />happiness: 45.15031<br />pet: dog","pet: dog<br />happiness: 33.50115<br />pet: dog","pet: dog<br />happiness: 30.40962<br />pet: dog","pet: dog<br />happiness: 59.39898<br />pet: dog","pet: dog<br />happiness: 63.32790<br />pet: dog","pet: dog<br />happiness: 53.88551<br />pet: dog","pet: dog<br />happiness: 54.73878<br />pet: dog","pet: dog<br />happiness: 74.68285<br />pet: dog","pet: dog<br />happiness: 59.27574<br />pet: dog","pet: dog<br />happiness: 69.74947<br />pet: dog","pet: dog<br />happiness: 56.27748<br />pet: dog","pet: dog<br />happiness: 41.65267<br />pet: dog","pet: dog<br />happiness: 49.26611<br />pet: dog","pet: dog<br />happiness: 61.83355<br />pet: dog","pet: dog<br />happiness: 68.11706<br />pet: dog","pet: dog<br />happiness: 65.88104<br />pet: dog","pet: dog<br />happiness: 49.04444<br />pet: dog","pet: dog<br />happiness: 62.66347<br />pet: dog","pet: dog<br />happiness: 47.50802<br />pet: dog","pet: dog<br />happiness: 54.98483<br />pet: dog","pet: dog<br />happiness: 40.92272<br />pet: dog","pet: dog<br />happiness: 50.94688<br />pet: dog","pet: dog<br />happiness: 55.97136<br />pet: dog","pet: dog<br />happiness: 59.70016<br />pet: dog","pet: dog<br />happiness: 56.26513<br />pet: dog","pet: dog<br />happiness: 50.10015<br />pet: dog","pet: dog<br />happiness: 54.79152<br />pet: dog","pet: dog<br />happiness: 52.80731<br />pet: dog","pet: dog<br />happiness: 46.40540<br />pet: dog","pet: dog<br />happiness: 43.33386<br />pet: dog","pet: dog<br />happiness: 40.74369<br />pet: dog","pet: dog<br />happiness: 52.01917<br />pet: dog","pet: dog<br />happiness: 31.75933<br />pet: dog","pet: dog<br />happiness: 66.27453<br />pet: dog","pet: dog<br />happiness: 65.79191<br />pet: dog","pet: dog<br />happiness: 55.76184<br />pet: dog","pet: dog<br />happiness: 68.09746<br />pet: dog","pet: dog<br />happiness: 49.17925<br />pet: dog","pet: dog<br />happiness: 49.43872<br />pet: dog","pet: dog<br />happiness: 45.84345<br />pet: dog","pet: dog<br />happiness: 77.84427<br />pet: dog","pet: dog<br />happiness: 48.87426<br />pet: dog","pet: dog<br />happiness: 71.48044<br />pet: dog","pet: dog<br />happiness: 59.24229<br />pet: dog","pet: dog<br />happiness: 64.86623<br />pet: dog","pet: dog<br />happiness: 50.06555<br />pet: dog","pet: dog<br />happiness: 44.54240<br />pet: dog","pet: dog<br />happiness: 60.78467<br />pet: dog","pet: dog<br />happiness: 58.81779<br />pet: dog","pet: dog<br />happiness: 61.95704<br />pet: dog","pet: dog<br />happiness: 41.86145<br />pet: dog","pet: dog<br />happiness: 55.68990<br />pet: dog","pet: dog<br />happiness: 47.90046<br />pet: dog","pet: dog<br />happiness: 51.26700<br />pet: dog","pet: dog<br />happiness: 46.18250<br />pet: dog","pet: dog<br />happiness: 59.49883<br />pet: dog","pet: dog<br />happiness: 61.38365<br />pet: dog","pet: dog<br />happiness: 55.76762<br />pet: dog","pet: dog<br />happiness: 61.15826<br />pet: dog","pet: dog<br />happiness: 60.04777<br />pet: dog","pet: dog<br />happiness: 50.31448<br />pet: dog","pet: dog<br />happiness: 51.43266<br />pet: dog","pet: dog<br />happiness: 51.86959<br />pet: dog","pet: dog<br />happiness: 59.65909<br />pet: dog","pet: dog<br />happiness: 69.54796<br />pet: dog","pet: dog<br />happiness: 66.78939<br />pet: dog","pet: dog<br />happiness: 50.93470<br />pet: dog","pet: dog<br />happiness: 62.51116<br />pet: dog","pet: dog<br />happiness: 48.70860<br />pet: dog","pet: dog<br />happiness: 72.40799<br />pet: dog","pet: dog<br />happiness: 36.48366<br />pet: dog","pet: dog<br />happiness: 64.11561<br />pet: dog","pet: dog<br />happiness: 60.71917<br />pet: dog","pet: dog<br />happiness: 52.85846<br />pet: dog","pet: dog<br />happiness: 68.16433<br />pet: dog","pet: dog<br />happiness: 56.93082<br />pet: dog","pet: dog<br />happiness: 56.22735<br />pet: dog","pet: dog<br />happiness: 55.64827<br />pet: dog","pet: dog<br />happiness: 47.14701<br />pet: dog","pet: dog<br />happiness: 56.70592<br />pet: dog","pet: dog<br />happiness: 32.53930<br />pet: dog","pet: dog<br />happiness: 34.76891<br />pet: dog","pet: dog<br />happiness: 58.12706<br />pet: dog","pet: dog<br />happiness: 61.36788<br />pet: dog","pet: dog<br />happiness: 52.82354<br />pet: dog","pet: dog<br />happiness: 49.80080<br />pet: dog","pet: dog<br />happiness: 49.10297<br />pet: dog","pet: dog<br />happiness: 39.67369<br />pet: dog","pet: dog<br />happiness: 45.75027<br />pet: dog","pet: dog<br />happiness: 43.08568<br />pet: dog","pet: dog<br />happiness: 35.19950<br />pet: dog","pet: dog<br />happiness: 65.60332<br />pet: dog","pet: dog<br />happiness: 74.17967<br />pet: dog","pet: dog<br />happiness: 61.48458<br />pet: dog","pet: dog<br />happiness: 50.46603<br />pet: dog","pet: dog<br />happiness: 32.54850<br />pet: dog","pet: dog<br />happiness: 53.08919<br />pet: dog","pet: dog<br />happiness: 45.54372<br />pet: dog","pet: dog<br />happiness: 44.47058<br />pet: dog","pet: dog<br />happiness: 37.90981<br />pet: dog","pet: dog<br />happiness: 31.18989<br />pet: dog","pet: dog<br />happiness: 57.10260<br />pet: dog","pet: dog<br />happiness: 58.27961<br />pet: dog","pet: dog<br />happiness: 50.58297<br />pet: dog","pet: dog<br />happiness: 52.76924<br />pet: dog","pet: dog<br />happiness: 56.47724<br />pet: dog","pet: dog<br />happiness: 72.49314<br />pet: dog","pet: dog<br />happiness: 63.01953<br />pet: dog","pet: dog<br />happiness: 65.92378<br />pet: dog","pet: dog<br />happiness: 42.45243<br />pet: dog","pet: dog<br />happiness: 50.39364<br />pet: dog","pet: dog<br />happiness: 43.16933<br />pet: dog","pet: dog<br />happiness: 42.56979<br />pet: dog","pet: dog<br />happiness: 34.57863<br />pet: dog","pet: dog<br />happiness: 51.69864<br />pet: dog","pet: dog<br />happiness: 47.99828<br />pet: dog","pet: dog<br />happiness: 54.27550<br />pet: dog","pet: dog<br />happiness: 60.22906<br />pet: dog","pet: dog<br />happiness: 45.49126<br />pet: dog","pet: dog<br />happiness: 68.62326<br />pet: dog","pet: dog<br />happiness: 57.42092<br />pet: dog","pet: dog<br />happiness: 72.59802<br />pet: dog","pet: dog<br />happiness: 36.96815<br />pet: dog","pet: dog<br />happiness: 61.30801<br />pet: dog","pet: dog<br />happiness: 55.29330<br />pet: dog","pet: dog<br />happiness: 56.62904<br />pet: dog","pet: dog<br />happiness: 47.51411<br />pet: dog","pet: dog<br />happiness: 60.68190<br />pet: dog","pet: dog<br />happiness: 58.53680<br />pet: dog","pet: dog<br />happiness: 67.37612<br />pet: dog","pet: dog<br />happiness: 49.30820<br />pet: dog","pet: dog<br />happiness: 48.39743<br />pet: dog","pet: dog<br />happiness: 53.88777<br />pet: dog","pet: dog<br />happiness: 61.11089<br />pet: dog","pet: dog<br />happiness: 43.79828<br />pet: dog","pet: dog<br />happiness: 65.35118<br />pet: dog","pet: dog<br />happiness: 51.86517<br />pet: dog","pet: dog<br />happiness: 44.68493<br />pet: dog","pet: dog<br />happiness: 50.32984<br />pet: dog","pet: dog<br />happiness: 37.09721<br />pet: dog","pet: dog<br />happiness: 53.30735<br />pet: dog","pet: dog<br />happiness: 46.30063<br />pet: dog","pet: dog<br />happiness: 52.45894<br />pet: dog","pet: dog<br />happiness: 54.55939<br />pet: dog","pet: dog<br />happiness: 41.70850<br />pet: dog","pet: dog<br />happiness: 48.53710<br />pet: dog","pet: dog<br />happiness: 56.36924<br />pet: dog","pet: dog<br />happiness: 62.99658<br />pet: dog","pet: dog<br />happiness: 55.18484<br />pet: dog","pet: dog<br />happiness: 34.32500<br />pet: dog","pet: dog<br />happiness: 51.02251<br />pet: dog","pet: dog<br />happiness: 65.72573<br />pet: dog","pet: dog<br />happiness: 55.64621<br />pet: dog","pet: dog<br />happiness: 56.75475<br />pet: dog","pet: dog<br />happiness: 64.14009<br />pet: dog","pet: dog<br />happiness: 67.60948<br />pet: dog","pet: dog<br />happiness: 62.70417<br />pet: dog","pet: dog<br />happiness: 49.17831<br />pet: dog","pet: dog<br />happiness: 46.43259<br />pet: dog","pet: dog<br />happiness: 48.94118<br />pet: dog","pet: dog<br />happiness: 43.95424<br />pet: dog","pet: dog<br />happiness: 59.85061<br />pet: dog","pet: dog<br />happiness: 42.39753<br />pet: dog","pet: dog<br />happiness: 69.78872<br />pet: dog","pet: dog<br />happiness: 40.16610<br />pet: dog","pet: dog<br />happiness: 39.88325<br />pet: dog","pet: dog<br />happiness: 65.08605<br />pet: dog","pet: dog<br />happiness: 52.17317<br />pet: dog","pet: dog<br />happiness: 60.51790<br />pet: dog","pet: dog<br />happiness: 49.07871<br />pet: dog","pet: dog<br />happiness: 58.37538<br />pet: dog","pet: dog<br />happiness: 54.14107<br />pet: dog","pet: dog<br />happiness: 27.21576<br />pet: dog","pet: dog<br />happiness: 64.16640<br />pet: dog","pet: dog<br />happiness: 56.82288<br />pet: dog","pet: dog<br />happiness: 55.00943<br />pet: dog","pet: dog<br />happiness: 59.97180<br />pet: dog","pet: dog<br />happiness: 38.82253<br />pet: dog","pet: dog<br />happiness: 64.14874<br />pet: dog","pet: dog<br />happiness: 67.41701<br />pet: dog","pet: dog<br />happiness: 58.68130<br />pet: dog","pet: dog<br />happiness: 37.69514<br />pet: dog","pet: dog<br />happiness: 59.81199<br />pet: dog","pet: dog<br />happiness: 58.15268<br />pet: dog","pet: dog<br />happiness: 60.57642<br />pet: dog","pet: dog<br />happiness: 52.46401<br />pet: dog","pet: dog<br />happiness: 42.49856<br />pet: dog","pet: dog<br />happiness: 54.48793<br />pet: dog","pet: dog<br />happiness: 55.90740<br />pet: dog","pet: dog<br />happiness: 66.57985<br />pet: dog","pet: dog<br />happiness: 44.20362<br />pet: dog","pet: dog<br />happiness: 47.87561<br />pet: dog","pet: dog<br />happiness: 69.22869<br />pet: dog","pet: dog<br />happiness: 55.01869<br />pet: dog","pet: dog<br />happiness: 67.50239<br />pet: dog","pet: dog<br />happiness: 59.04516<br />pet: dog","pet: dog<br />happiness: 66.80103<br />pet: dog","pet: dog<br />happiness: 57.63524<br />pet: dog","pet: dog<br />happiness: 52.83737<br />pet: dog","pet: dog<br />happiness: 65.16305<br />pet: dog","pet: dog<br />happiness: 58.44233<br />pet: dog","pet: dog<br />happiness: 67.25079<br />pet: dog","pet: dog<br />happiness: 54.49421<br />pet: dog","pet: dog<br />happiness: 55.47134<br />pet: dog","pet: dog<br />happiness: 57.57841<br />pet: dog","pet: dog<br />happiness: 46.09947<br />pet: dog","pet: dog<br />happiness: 71.27501<br />pet: dog","pet: dog<br />happiness: 56.81304<br />pet: dog","pet: dog<br />happiness: 52.06410<br />pet: dog","pet: dog<br />happiness: 61.07444<br />pet: dog","pet: dog<br />happiness: 48.95370<br />pet: dog","pet: dog<br />happiness: 71.10815<br />pet: dog","pet: dog<br />happiness: 46.13620<br />pet: dog","pet: dog<br />happiness: 48.24838<br />pet: dog","pet: dog<br />happiness: 66.17119<br />pet: dog","pet: dog<br />happiness: 74.66711<br />pet: dog","pet: dog<br />happiness: 39.18803<br />pet: dog","pet: dog<br />happiness: 49.16217<br />pet: dog","pet: dog<br />happiness: 46.83033<br />pet: dog","pet: dog<br />happiness: 49.87883<br />pet: dog","pet: dog<br />happiness: 53.01481<br />pet: dog","pet: dog<br />happiness: 51.23562<br />pet: dog","pet: dog<br />happiness: 39.57348<br />pet: dog","pet: dog<br />happiness: 48.62010<br />pet: dog","pet: dog<br />happiness: 55.81128<br />pet: dog","pet: dog<br />happiness: 43.41399<br />pet: dog","pet: dog<br />happiness: 55.54940<br />pet: dog","pet: dog<br />happiness: 53.12184<br />pet: dog","pet: dog<br />happiness: 57.77342<br />pet: dog","pet: dog<br />happiness: 59.19296<br />pet: dog","pet: dog<br />happiness: 51.97557<br />pet: dog","pet: dog<br />happiness: 58.87284<br />pet: dog","pet: dog<br />happiness: 59.68240<br />pet: dog","pet: dog<br />happiness: 70.95379<br />pet: dog","pet: dog<br />happiness: 58.03993<br />pet: dog","pet: dog<br />happiness: 53.76032<br />pet: dog","pet: dog<br />happiness: 42.61642<br />pet: dog","pet: dog<br />happiness: 85.33929<br />pet: dog","pet: dog<br />happiness: 80.51911<br />pet: dog","pet: dog<br />happiness: 10.79059<br />pet: dog","pet: dog<br />happiness: 53.73246<br />pet: dog","pet: dog<br />happiness: 38.82797<br />pet: dog","pet: dog<br />happiness: 72.50691<br />pet: dog","pet: dog<br />happiness: 60.95025<br />pet: dog","pet: dog<br />happiness: 39.77336<br />pet: dog","pet: dog<br />happiness: 64.48655<br />pet: dog","pet: dog<br />happiness: 46.11495<br />pet: dog","pet: dog<br />happiness: 83.06898<br />pet: dog","pet: dog<br />happiness: 65.91749<br />pet: dog","pet: dog<br />happiness: 58.89682<br />pet: dog","pet: dog<br />happiness: 68.82097<br />pet: dog","pet: dog<br />happiness: 64.18006<br />pet: dog","pet: dog<br />happiness: 74.27491<br />pet: dog","pet: dog<br />happiness: 63.18916<br />pet: dog","pet: dog<br />happiness: 61.03253<br />pet: dog","pet: dog<br />happiness: 50.38805<br />pet: dog","pet: dog<br />happiness: 40.21115<br />pet: dog","pet: dog<br />happiness: 64.77476<br />pet: dog","pet: dog<br />happiness: 53.04962<br />pet: dog","pet: dog<br />happiness: 61.72658<br />pet: dog","pet: dog<br />happiness: 63.44017<br />pet: dog","pet: dog<br />happiness: 60.84400<br />pet: dog","pet: dog<br />happiness: 58.64830<br />pet: dog","pet: dog<br />happiness: 52.73424<br />pet: dog","pet: dog<br />happiness: 43.32400<br />pet: dog","pet: dog<br />happiness: 57.16437<br />pet: dog","pet: dog<br />happiness: 53.90046<br />pet: dog","pet: dog<br />happiness: 54.84934<br />pet: dog","pet: dog<br />happiness: 51.99219<br />pet: dog","pet: dog<br />happiness: 76.14134<br />pet: dog","pet: dog<br />happiness: 62.57617<br />pet: dog","pet: dog<br />happiness: 56.86837<br />pet: dog","pet: dog<br />happiness: 49.64790<br />pet: dog","pet: dog<br />happiness: 47.50822<br />pet: dog","pet: dog<br />happiness: 65.23547<br />pet: dog","pet: dog<br />happiness: 31.61552<br />pet: dog","pet: dog<br />happiness: 48.26826<br />pet: dog","pet: dog<br />happiness: 54.81163<br />pet: dog","pet: dog<br />happiness: 54.87048<br />pet: dog","pet: dog<br />happiness: 47.30996<br />pet: dog","pet: dog<br />happiness: 48.55781<br />pet: dog","pet: dog<br />happiness: 71.88730<br />pet: dog","pet: dog<br />happiness: 54.92733<br />pet: dog","pet: dog<br />happiness: 41.96538<br />pet: dog","pet: dog<br />happiness: 68.67518<br />pet: dog","pet: dog<br />happiness: 61.08249<br />pet: dog","pet: dog<br />happiness: 36.80276<br />pet: dog","pet: dog<br />happiness: 62.01875<br />pet: dog","pet: dog<br />happiness: 55.35476<br />pet: dog","pet: dog<br />happiness: 58.32640<br />pet: dog","pet: dog<br />happiness: 46.96990<br />pet: dog","pet: dog<br />happiness: 67.30933<br />pet: dog","pet: dog<br />happiness: 48.74223<br />pet: dog","pet: dog<br />happiness: 48.53062<br />pet: dog","pet: dog<br />happiness: 35.13009<br />pet: dog","pet: dog<br />happiness: 43.82016<br />pet: dog","pet: dog<br />happiness: 59.99082<br />pet: dog","pet: dog<br />happiness: 53.94724<br />pet: dog","pet: dog<br />happiness: 49.39683<br />pet: dog","pet: dog<br />happiness: 56.99978<br />pet: dog","pet: dog<br />happiness: 75.14811<br />pet: dog","pet: dog<br />happiness: 58.94322<br />pet: dog","pet: dog<br />happiness: 61.09629<br />pet: dog","pet: dog<br />happiness: 62.20765<br />pet: dog","pet: dog<br />happiness: 47.74216<br />pet: dog","pet: dog<br />happiness: 52.42548<br />pet: dog","pet: dog<br />happiness: 67.27880<br />pet: dog","pet: dog<br />happiness: 48.53974<br />pet: dog","pet: dog<br />happiness: 57.09967<br />pet: dog","pet: dog<br />happiness: 61.38522<br />pet: dog","pet: dog<br />happiness: 54.88440<br />pet: dog","pet: dog<br />happiness: 49.00829<br />pet: dog","pet: dog<br />happiness: 57.76558<br />pet: dog","pet: dog<br />happiness: 59.99413<br />pet: dog","pet: dog<br />happiness: 45.75905<br />pet: dog","pet: dog<br />happiness: 63.11576<br />pet: dog","pet: dog<br />happiness: 64.01348<br />pet: dog","pet: dog<br />happiness: 57.46073<br />pet: dog","pet: dog<br />happiness: 64.35792<br />pet: dog","pet: dog<br />happiness: 55.49775<br />pet: dog","pet: dog<br />happiness: 40.12752<br />pet: dog","pet: dog<br />happiness: 47.03081<br />pet: dog","pet: dog<br />happiness: 54.05622<br />pet: dog","pet: dog<br />happiness: 43.61088<br />pet: dog","pet: dog<br />happiness: 70.08469<br />pet: dog","pet: dog<br />happiness: 50.36646<br />pet: dog","pet: dog<br />happiness: 59.97615<br />pet: dog","pet: dog<br />happiness: 43.37653<br />pet: dog","pet: dog<br />happiness: 47.38776<br />pet: dog","pet: dog<br />happiness: 50.28613<br />pet: dog","pet: dog<br />happiness: 51.66955<br />pet: dog","pet: dog<br />happiness: 47.92824<br />pet: dog","pet: dog<br />happiness: 43.73106<br />pet: dog","pet: dog<br />happiness: 50.00080<br />pet: dog","pet: dog<br />happiness: 48.74930<br />pet: dog","pet: dog<br />happiness: 56.84244<br />pet: dog","pet: dog<br />happiness: 61.51467<br />pet: dog","pet: dog<br />happiness: 46.95250<br />pet: dog","pet: dog<br />happiness: 61.34593<br />pet: dog","pet: dog<br />happiness: 42.05544<br />pet: dog","pet: dog<br />happiness: 42.54992<br />pet: dog","pet: dog<br />happiness: 53.67892<br />pet: dog","pet: dog<br />happiness: 46.09280<br />pet: dog","pet: dog<br />happiness: 46.73288<br />pet: dog","pet: dog<br />happiness: 41.24265<br />pet: dog","pet: dog<br />happiness: 55.31792<br />pet: dog","pet: dog<br />happiness: 40.08087<br />pet: dog","pet: dog<br />happiness: 33.72163<br />pet: dog","pet: dog<br />happiness: 68.88248<br />pet: dog","pet: dog<br />happiness: 44.48621<br />pet: dog","pet: dog<br />happiness: 51.17039<br />pet: dog","pet: dog<br />happiness: 37.00910<br />pet: dog","pet: dog<br />happiness: 58.96108<br />pet: dog","pet: dog<br />happiness: 52.52956<br />pet: dog","pet: dog<br />happiness: 42.74255<br />pet: dog","pet: dog<br />happiness: 54.22725<br />pet: dog","pet: dog<br />happiness: 41.77318<br />pet: dog","pet: dog<br />happiness: 51.54821<br />pet: dog","pet: dog<br />happiness: 39.74584<br />pet: dog","pet: dog<br />happiness: 55.48190<br />pet: dog","pet: dog<br />happiness: 62.08473<br />pet: dog","pet: dog<br />happiness: 52.76784<br />pet: dog","pet: dog<br />happiness: 58.59885<br />pet: dog","pet: dog<br />happiness: 55.17141<br />pet: dog","pet: dog<br />happiness: 52.81938<br />pet: dog","pet: dog<br />happiness: 41.79959<br />pet: dog","pet: dog<br />happiness: 42.97046<br />pet: dog","pet: dog<br />happiness: 57.26419<br />pet: dog","pet: dog<br />happiness: 53.15011<br />pet: dog","pet: dog<br />happiness: 65.68585<br />pet: dog","pet: dog<br />happiness: 62.40310<br />pet: dog","pet: dog<br />happiness: 46.99421<br />pet: dog","pet: dog<br />happiness: 55.39285<br />pet: dog","pet: dog<br />happiness: 72.33799<br />pet: dog","pet: dog<br />happiness: 71.35398<br />pet: dog","pet: dog<br />happiness: 54.65768<br />pet: dog","pet: dog<br />happiness: 57.26957<br />pet: dog","pet: dog<br />happiness: 70.95687<br />pet: dog","pet: dog<br />happiness: 58.13793<br />pet: dog","pet: dog<br />happiness: 63.26427<br />pet: dog","pet: dog<br />happiness: 57.33174<br />pet: dog","pet: dog<br />happiness: 32.78351<br />pet: dog","pet: dog<br />happiness: 61.22294<br />pet: dog","pet: dog<br />happiness: 56.14134<br />pet: dog","pet: dog<br />happiness: 53.35491<br />pet: dog","pet: dog<br />happiness: 54.87820<br />pet: dog","pet: dog<br />happiness: 46.32715<br />pet: dog","pet: dog<br />happiness: 91.53832<br />pet: dog","pet: dog<br />happiness: 65.64536<br />pet: dog","pet: dog<br />happiness: 56.27492<br />pet: dog","pet: dog<br />happiness: 45.23863<br />pet: dog","pet: dog<br />happiness: 48.32427<br />pet: dog","pet: dog<br />happiness: 55.18930<br />pet: dog","pet: dog<br />happiness: 52.79201<br />pet: dog","pet: dog<br />happiness: 58.21392<br />pet: dog","pet: dog<br />happiness: 64.59727<br />pet: dog","pet: dog<br />happiness: 51.76660<br />pet: dog","pet: dog<br />happiness: 44.22190<br />pet: dog","pet: dog<br />happiness: 38.23012<br />pet: dog","pet: dog<br />happiness: 53.13768<br />pet: dog","pet: dog<br />happiness: 75.98466<br />pet: dog","pet: dog<br />happiness: 68.32995<br />pet: dog","pet: dog<br />happiness: 46.00449<br />pet: dog","pet: dog<br />happiness: 63.59238<br />pet: dog","pet: dog<br />happiness: 75.22601<br />pet: dog","pet: dog<br />happiness: 64.63858<br />pet: dog","pet: dog<br />happiness: 48.17571<br />pet: dog","pet: dog<br />happiness: 78.25281<br />pet: dog","pet: dog<br />happiness: 62.94483<br />pet: dog","pet: dog<br />happiness: 55.21741<br />pet: dog","pet: dog<br />happiness: 40.33387<br />pet: dog","pet: dog<br />happiness: 74.12191<br />pet: dog","pet: dog<br />happiness: 41.86725<br />pet: dog","pet: dog<br />happiness: 57.64659<br />pet: dog","pet: dog<br />happiness: 64.40522<br />pet: dog","pet: dog<br />happiness: 60.23625<br />pet: dog","pet: dog<br />happiness: 62.64278<br />pet: dog","pet: dog<br />happiness: 54.31329<br />pet: dog","pet: dog<br />happiness: 57.82319<br />pet: dog","pet: dog<br />happiness: 40.23750<br />pet: dog","pet: dog<br />happiness: 50.84562<br />pet: dog","pet: dog<br />happiness: 45.63286<br />pet: dog","pet: dog<br />happiness: 66.02438<br />pet: dog","pet: dog<br />happiness: 63.74247<br />pet: dog","pet: dog<br />happiness: 49.40232<br />pet: dog","pet: dog<br />happiness: 58.75922<br />pet: dog","pet: dog<br />happiness: 43.00129<br />pet: dog","pet: dog<br />happiness: 54.12304<br />pet: dog","pet: dog<br />happiness: 47.88717<br />pet: dog","pet: dog<br />happiness: 72.90553<br />pet: dog","pet: dog<br />happiness: 49.45477<br />pet: dog","pet: dog<br />happiness: 56.88083<br />pet: dog","pet: dog<br />happiness: 54.38454<br />pet: dog","pet: dog<br />happiness: 52.90985<br />pet: dog","pet: dog<br />happiness: 62.58465<br />pet: dog","pet: dog<br />happiness: 57.12799<br />pet: dog","pet: dog<br />happiness: 65.56289<br />pet: dog","pet: dog<br />happiness: 51.50009<br />pet: dog","pet: dog<br />happiness: 56.66482<br />pet: dog","pet: dog<br />happiness: 51.45399<br />pet: dog","pet: dog<br />happiness: 48.52369<br />pet: dog","pet: dog<br />happiness: 64.68359<br />pet: dog","pet: dog<br />happiness: 49.66408<br />pet: dog","pet: dog<br />happiness: 69.60171<br />pet: dog","pet: dog<br />happiness: 64.13050<br />pet: dog","pet: dog<br />happiness: 67.91502<br />pet: dog","pet: dog<br />happiness: 45.26694<br />pet: dog","pet: dog<br />happiness: 53.14401<br />pet: dog","pet: dog<br />happiness: 59.31656<br />pet: dog","pet: dog<br />happiness: 46.54876<br />pet: dog","pet: dog<br />happiness: 58.97501<br />pet: dog","pet: dog<br />happiness: 44.41911<br />pet: dog","pet: dog<br />happiness: 63.86098<br />pet: dog","pet: dog<br />happiness: 65.69046<br />pet: dog","pet: dog<br />happiness: 52.74814<br />pet: dog","pet: dog<br />happiness: 33.44858<br />pet: dog","pet: dog<br />happiness: 57.44066<br />pet: dog","pet: dog<br />happiness: 34.93088<br />pet: dog","pet: dog<br />happiness: 64.58488<br />pet: dog","pet: dog<br />happiness: 72.22001<br />pet: dog","pet: dog<br />happiness: 43.20694<br />pet: dog","pet: dog<br />happiness: 66.37785<br />pet: dog","pet: dog<br />happiness: 63.06110<br />pet: dog","pet: dog<br />happiness: 49.49946<br />pet: dog","pet: dog<br />happiness: 50.07558<br />pet: dog","pet: dog<br />happiness: 60.69569<br />pet: dog","pet: dog<br />happiness: 56.32764<br />pet: dog"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"dog","legendgroup":"dog","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":27.689497716895,"r":7.30593607305936,"b":41.6438356164384,"l":37.2602739726027},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,2.6],"tickmode":"array","ticktext":["cat","dog"],"tickvals":[1,2],"categoryorder":"array","categoryarray":["cat","dog"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"pet","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[6.75320472178878,95.575709232948],"tickmode":"array","ticktext":["25","50","75"],"tickvals":[25,50,75],"categoryorder":"array","categoryarray":["25","50","75"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"happiness","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(51,51,51,1)","width":0.66417600664176,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"y":0.913385826771654},"annotations":[{"text":"pet","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"1c993085474f":{"x":{},"y":{},"fill":{},"type":"scatter"}},"cur_data":"1c993085474f","visdat":{"1c993085474f":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
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
    
    <pre class="mcq"><select class='solveme' data-answer='["ggsave(\"figname.png\")"]'> <option></option> <option>ggsave()</option> <option>ggsave("figname")</option> <option>ggsave("figname.png")</option> <option>ggsave("figname.png", plot = cars)</option></select></pre>

  
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

Download the [exercises](exercises/03_ggplot_exercise.Rmd). See the [plots](exercises/03_ggplot_answers.html) to see what your plots should look like (this doesn't contain the answer code). See the [answers](exercises/03_ggplot_answers.Rmd) only after you've attempted all the questions.
