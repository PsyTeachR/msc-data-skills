# Data Visualisation {#ggplot}

<img src="images/memes/better_graphs.png" class="meme right"
     alt = "xkcd comic titled 'General quality of charts and graphs in scientific papers'; y-axis: BAD on the bottom to GOOD on the top; x-axis: 1950s to 2010s; Line graph increases with time except for a dip between 1990 and 2010 labelled POWERPOINT/MSPAINT ERA">

## Learning Objectives {#ilo3}

### Basic

1. Understand what types of graphs are best for [different types of data](#vartypes) [(video)](https://youtu.be/tOFQFPRgZ3M){class="video"}
    + 1 discrete
    + 1 continuous
    + 2 discrete
    + 2 continuous
    + 1 discrete, 1 continuous
    + 3 continuous
2. Create common types of graphs with ggplot2 [(video)](https://youtu.be/kKlQupjD__g){class="video"}
    + [`geom_bar()`](#geom_bar)
    + [`geom_density()`](#geom_density)
    + [`geom_freqpoly()`](#geom_freqpoly)
    + [`geom_histogram()`](#geom_histogram)
    + [`geom_col()`](#geom_col)
    + [`geom_boxplot()`](#geom_boxplot)
    + [`geom_violin()`](#geom_violin)
    + [Vertical Intervals](#vertical_intervals)
        + `geom_crossbar()`
        + `geom_errorbar()`
        + `geom_linerange()`
        + `geom_pointrange()`
    + [`geom_point()`](#geom_point)
    + [`geom_smooth()`](#geom_smooth)
3. Set custom [labels](#custom-labels),  [colours](#custom-colours), and [themes](#themes) [(video)](https://youtu.be/6pHuCbOh86s){class="video"}
4. [Combine plots](combo_plots) on the same plot, as facets, or as a grid using cowplot [(video)](https://youtu.be/AnqlfuU-VZk){class="video"}
5. [Save plots](#ggsave) as an image file [(video)](https://youtu.be/f1Y53mjEli0){class="video"}
    
### Intermediate

6. Add lines to graphs
7. Deal with [overlapping data](#overlap)
8. Create less common types of graphs
    + [`geom_tile()`](#geom_tile)
    + [`geom_density2d()`](#geom_density2d)
    + [`geom_bin2d()`](#geom_bin2d)
    + [`geom_hex()`](#geom_hex)
    + [`geom_count()`](#geom_count)
9. Adjust axes (e.g., flip coordinates, set axis limits)
10. Create interactive graphs with [`plotly`](#plotly)


## Resources {#resources3}

* [Chapter 3: Data Visualisation](http://r4ds.had.co.nz/data-visualisation.html) of *R for Data Science*
* [ggplot2 cheat sheet](https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf)
* [Chapter 28: Graphics for communication](http://r4ds.had.co.nz/graphics-for-communication.html) of *R for Data Science*
* [Look at Data](http://socviz.co/look-at-data.html) from [Data Vizualization for Social Science](http://socviz.co/)
* [Hack Your Data Beautiful](https://psyteachr.github.io/hack-your-data/) workshop by University of Glasgow postgraduate students
* [Graphs](http://www.cookbook-r.com/Graphs) in *Cookbook for R*

* [ggplot2 documentation](https://ggplot2.tidyverse.org/reference/)
* [The R Graph Gallery](http://www.r-graph-gallery.com/) (this is really useful)
* [Top 50 ggplot2 Visualizations](http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html)
* [R Graphics Cookbook](http://www.cookbook-r.com/Graphs/) by Winston Chang
* [ggplot extensions](https://www.ggplot2-exts.org/)
* [plotly](https://plot.ly/ggplot2/) for creating interactive graphs


## Setup {#setup3}


```r
# libraries needed for these graphs
library(tidyverse)
library(dataskills)
library(plotly)
library(cowplot) 
set.seed(30250) # makes sure random numbers are reproducible
```

## Common Variable Combinations {#vartypes}

<a class='glossary' target='_blank' title='Data that can take on any values between other existing values.' href='https://psyteachr.github.io/glossary/c#continuous'>Continuous</a> variables are properties you can measure, like height. <a class='glossary' target='_blank' title='Data that can only take certain values, such as integers.' href='https://psyteachr.github.io/glossary/d#discrete'>Discrete</a> variables are things you can count, like the number of pets you have. Categorical variables can be <a class='glossary' target='_blank' title='Categorical variables that don’t have an inherent order, such as types of animal.' href='https://psyteachr.github.io/glossary/n#nominal'>nominal</a>, where the categories don't really have an order, like cats, dogs and ferrets (even though ferrets are obviously best). They can also be <a class='glossary' target='_blank' title='Discrete variables that have an inherent order, such as number of legs' href='https://psyteachr.github.io/glossary/o#ordinal'>ordinal</a>, where there is a clear order, but the distance between the categories isn't something you could exactly equate, like points on a <a class='glossary' target='_blank' title='A rating scale with a small number of discrete points in order' href='https://psyteachr.github.io/glossary/l#likert'>Likert</a> rating scale.

Different types of visualisations are good for different types of variables. 

Load the `pets` dataset from the `dataskills` package and explore it with `glimpse(pets)` or `View(pets)`. This is a simulated dataset with one random factor (`id`), two categorical factors (`pet`, `country`) and three continuous variables (`score`, `age`, `weight`). 


```r
data("pets")
# if you don't have the dataskills package, use:
# pets <- read_csv("https://psyteachr.github.io/msc-data-skills/data/pets.csv", col_types = "cffiid")
glimpse(pets)
```

```
## Rows: 800
## Columns: 6
## $ id      <chr> "S001", "S002", "S003", "S004", "S005", "S006", "S007", "S008"…
## $ pet     <fct> dog, dog, dog, dog, dog, dog, dog, dog, dog, dog, dog, dog, do…
## $ country <fct> UK, UK, UK, UK, UK, UK, UK, UK, UK, UK, UK, UK, UK, UK, UK, UK…
## $ score   <int> 90, 107, 94, 120, 111, 110, 100, 107, 106, 109, 85, 110, 102, …
## $ age     <int> 6, 8, 2, 10, 4, 8, 9, 8, 6, 11, 5, 9, 1, 10, 7, 8, 1, 8, 5, 13…
## $ weight  <dbl> 19.78932, 20.01422, 19.14863, 19.56953, 21.39259, 21.31880, 19…
```


<div class="try">
<p>Before you read ahead, come up with an example of each type of variable combination and sketch the types of graphs that would best display these data.</p>
<ul>
<li>1 categorical</li>
<li>1 continuous</li>
<li>2 categorical</li>
<li>2 continuous</li>
<li>1 categorical, 1 continuous</li>
<li>3 continuous</li>
</ul>
</div>


## Basic Plots

R has some basic plotting functions, but they're difficult to use and aesthetically not very nice. They can be useful to have a quick look at data while you're working on a script, though. The function `plot()` usually defaults to a sensible type of plot, depending on whether the arguments `x` and `y` are categorical, continuous, or missing.


```r
plot(x = pets$pet)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/plot0-1.png" alt="plot() with categorical x" width="100%" />
<p class="caption">(\#fig:plot0)plot() with categorical x</p>
</div>


```r
plot(x = pets$pet, y = pets$score)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/plot1-1.png" alt="plot() with categorical x and continuous y" width="100%" />
<p class="caption">(\#fig:plot1)plot() with categorical x and continuous y</p>
</div>


```r
plot(x = pets$age, y = pets$weight)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/plot2-1.png" alt="plot() with continuous x and y" width="100%" />
<p class="caption">(\#fig:plot2)plot() with continuous x and y</p>
</div>
The function `hist()` creates a quick histogram so you can see the distribution of your data. You can adjust how many columns are plotted with the argument `breaks`.


```r
hist(pets$score, breaks = 20)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/hist-1.png" alt="hist()" width="100%" />
<p class="caption">(\#fig:hist)hist()</p>
</div>

## GGplots

While the functions above are nice for quick visualisations, it's hard to make pretty, publication-ready plots. The package `ggplot2` (loaded with `tidyverse`) is one of the most common packages for creating beautiful visualisations.

`ggplot2` creates plots using a "grammar of graphics" where you add <a class='glossary' target='_blank' title='The geometric style in which data are displayed, such as boxplot, density, or histogram.' href='https://psyteachr.github.io/glossary/g#geom'>geoms</a> in layers. It can be complex to understand, but it's very powerful once you have a mental model of how it works. 

Let's start with a totally empty plot layer created by the `ggplot()` function with no arguments.


```r
ggplot()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/ggplot-empty-1.png" alt="A plot base created by ggplot()" width="100%" />
<p class="caption">(\#fig:ggplot-empty)A plot base created by ggplot()</p>
</div>

The first argument to `ggplot()` is the `data` table you want to plot. Let's use the `pets` data we loaded above. The second argument is the `mapping` for which columns in your data table correspond to which properties of the plot, such as the `x`-axis, the `y`-axis, line `colour` or `linetype`, point `shape`, or object `fill`. These mappings are specified by the `aes()` function. Just adding this to the `ggplot` function creates the labels and ranges for the `x` and `y` axes. They usually have sensible default values, given your data, but we'll learn how to change them later.


```r
mapping <- aes(x = pet, 
               y = score, 
               colour = country, 
               fill = country)
ggplot(data = pets, mapping = mapping)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/ggplot-labels-1.png" alt="Empty ggplot with x and y labels" width="100%" />
<p class="caption">(\#fig:ggplot-labels)Empty ggplot with x and y labels</p>
</div>

People usually omit the argument names and just put the `aes()` function directly as the second argument to `ggplot`. They also usually omit `x` and `y` as argument names to `aes()` (but you have to name the other properties). Next we can add "geoms", or plot styles. You literally add them with the `+` symbol. You can also add other plot attributes, such as labels, or change the theme and base font size.


```r
ggplot(pets, aes(pet, score, colour = country, fill = country)) +
  geom_violin(alpha = 0.5) +
  labs(x = "Pet type",
       y = "Score on an Important Test",
       colour = "Country of Origin",
       fill = "Country of Origin",
       title = "My first plot!") +
  theme_bw(base_size = 15)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/ggplot-geom-1.png" alt="Violin plot with country represented by colour." width="100%" />
<p class="caption">(\#fig:ggplot-geom)Violin plot with country represented by colour.</p>
</div>


## Common Plot Types

There are many geoms, and they can take different arguments to customise their appearance. We'll learn about some of the most common below.

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

Density plots are good for one continuous variable, but only if you have a fairly large number of observations.


```r
ggplot(pets, aes(score)) +
  geom_density()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density-1.png" alt="Density plot" width="100%" />
<p class="caption">(\#fig:density)Density plot</p>
</div>

You can represent subsets of a variable by assigning the category variable to the argument `group`, `fill`, or `color`. 


```r
ggplot(pets, aes(score, fill = pet)) +
  geom_density(alpha = 0.5)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density-grouped-1.png" alt="Grouped density plot" width="100%" />
<p class="caption">(\#fig:density-grouped)Grouped density plot</p>
</div>

<div class="try">
<p>Try changing the <code>alpha</code> argument to figure out what it does.</p>
</div>

### Frequency polygons {#geom_freqpoly}

If you want the y-axis to represent count rather than density, try `geom_freqpoly()`.


```r
ggplot(pets, aes(score, color = pet)) +
  geom_freqpoly(binwidth = 5)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/freqpoly-1.png" alt="Frequency ploygon plot" width="100%" />
<p class="caption">(\#fig:freqpoly)Frequency ploygon plot</p>
</div>

<div class="try">
<p>Try changing the <code>binwidth</code> argument to 10 and 1. How do you figure out the right value?</p>
</div>

### Histogram {#geom_histogram}

Histograms are also good for one continuous variable, and work well if you don't have many observations. Set the `binwidth` to control how wide each bar is.


```r
ggplot(pets, aes(score)) +
  geom_histogram(binwidth = 5, fill = "white", color = "black")
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
ggplot(pets, aes(score, fill=pet)) +
  geom_histogram(binwidth = 5, alpha = 0.5, 
                 position = "dodge")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/histogram-grouped-1.png" alt="Grouped Histogram" width="100%" />
<p class="caption">(\#fig:histogram-grouped)Grouped Histogram</p>
</div>

<div class="try">
<p>Try changing the <code>position</code> argument to “identity”, “fill”, “dodge”, or “stack”.</p>
</div>

### Column plot {#geom_col}

Column plots are the worst way to represent grouped continuous data, but also one of the most common. If your data are already aggregated (e.g., you have rows for each group with columns for the mean and standard error), you can use `geom_bar` or `geom_col` and `geom_errorbar` directly. If not, you can use the function `stat_summary` to calculate the mean and standard error and send those numbers to the appropriate geom for plotting.


```r
ggplot(pets, aes(pet, score, fill=pet)) +
  stat_summary(fun = mean, geom = "col", alpha = 0.5) + 
  stat_summary(fun.data = mean_se, geom = "errorbar",
               width = 0.25) +
  coord_cartesian(ylim = c(80, 120))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/colplot-statsum-1.png" alt="Column plot" width="100%" />
<p class="caption">(\#fig:colplot-statsum)Column plot</p>
</div>

<div class="try">
<p>Try changing the values for <code>coord_cartesian</code>. What does this do?</p>
</div>

### Boxplot {#geom_boxplot}

Boxplots are great for representing the distribution of grouped continuous variables. They fix most of the problems with using bar/column plots for continuous data.


```r
ggplot(pets, aes(pet, score, fill=pet)) +
  geom_boxplot(alpha = 0.5)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/boxplot-1.png" alt="Box plot" width="100%" />
<p class="caption">(\#fig:boxplot)Box plot</p>
</div>

### Violin plot {#geom_violin}

Violin pots are like sideways, mirrored density plots. They give even more information than a boxplot about distribution and are especially useful when you have non-normal distributions.


```r
ggplot(pets, aes(pet, score, fill=pet)) +
  geom_violin(draw_quantiles = .5,
              trim = FALSE, alpha = 0.5,)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violin-1.png" alt="Violin plot" width="100%" />
<p class="caption">(\#fig:violin)Violin plot</p>
</div>

<div class="try">
<p>Try changing the <code>quantile</code> argument. Set it to a vector of the numbers 0.1 to 0.9 in steps of 0.1.</p>
</div>

### Vertical intervals {#vertical_intervals}

Boxplots and violin plots don't always map well onto inferential stats that use the mean. You can represent the mean and standard error or any other value you can calculate.

Here, we will create a table with the means and standard errors for two groups. We'll learn how to calculate this from raw data in the chapter on [data wrangling](#dplyr). We also create a new object called `gg` that sets up the base of the plot. 


```r
dat <- tibble(
  group = c("A", "B"),
  mean = c(10, 20),
  se = c(2, 3)
)
gg <- ggplot(dat, aes(group, mean, 
                      ymin = mean-se, 
                      ymax = mean+se))
```

The trick above can be useful if you want to represent the same data in different ways. You can add different geoms to the base plot without having to re-type the base plot code.


```r
gg + geom_crossbar()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/geom-crossbar-1.png" alt="geom_crossbar()" width="100%" />
<p class="caption">(\#fig:geom-crossbar)geom_crossbar()</p>
</div>


```r
gg + geom_errorbar()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/geom-errorbar-1.png" alt="geom_errorbar()" width="100%" />
<p class="caption">(\#fig:geom-errorbar)geom_errorbar()</p>
</div>


```r
gg + geom_linerange()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/geom-linerange-1.png" alt="geom_linerange()" width="100%" />
<p class="caption">(\#fig:geom-linerange)geom_linerange()</p>
</div>


```r
gg + geom_pointrange()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/geom-pointrange-1.png" alt="geom_pointrange()" width="100%" />
<p class="caption">(\#fig:geom-pointrange)geom_pointrange()</p>
</div>


You can also use the function `stats_summary` to calculate mean, standard error, or any other value for your data and display it using any geom. 


```r
ggplot(pets, aes(pet, score, color=pet)) +
  stat_summary(fun.data = mean_se, geom = "crossbar") +
  stat_summary(fun.min = function(x) mean(x) - sd(x),
               fun.max = function(x) mean(x) + sd(x),
               geom = "errorbar", width = 0) +
  theme(legend.position = "none") # gets rid of the legend
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/vertint-statssum-1.png" alt="Vertical intervals with stats_summary()" width="100%" />
<p class="caption">(\#fig:vertint-statssum)Vertical intervals with stats_summary()</p>
</div>

### Scatter plot {#geom_point}

Scatter plots are a good way to represent the relationship between two continuous variables.


```r
ggplot(pets, aes(age, score, color = pet)) +
  geom_point()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/scatter-1.png" alt="Scatter plot using geom_point()" width="100%" />
<p class="caption">(\#fig:scatter)Scatter plot using geom_point()</p>
</div>

### Line graph {#geom_smooth}

You often want to represent the relationship as a single line.


```r
ggplot(pets, aes(age, score, color = pet)) +
  geom_smooth(formula = y ~ x, method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/smooth-1.png" alt="Line plot using geom_smooth()" width="100%" />
<p class="caption">(\#fig:smooth)Line plot using geom_smooth()</p>
</div>

<div class="try">
<p>What are some other options for the <code>method</code> argument to <code>geom_smooth</code>? When might you want to use them?</p>
</div>

<div class="info">

You can plot functions other than the linear `y ~ x`. The code below creates a data table where `x` is 101 values between -10 and 10. and `y` is `x` squared plus `3*x` plus `1`. You'll probably recognise this from algebra as the quadratic equation. You can set the `formula` argument in `geom_smooth` to a quadratic formula (`y ~ x + I(x^2)`) to fit a quadratic function to the data.


```r
quad <- tibble(
  x = seq(-10, 10, length.out = 101),
  y = x^2 + 3*x + 1
)

ggplot(quad, aes(x, y)) +
  geom_point() +
  geom_smooth(formula = y ~ x + I(x^2), 
              method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/quadratic-1.png" alt="Fitting quadratic functions" width="100%" />
<p class="caption">(\#fig:quadratic)Fitting quadratic functions</p>
</div>
</div>

## Customisation

### Labels {#custom-labels}

You can set custom titles and axis labels in a few different ways.


```r
ggplot(pets, aes(age, score, color = pet)) +
  geom_smooth(formula = y ~ x, method="lm") +
  labs(title = "Pet score with Age",
       x = "Age (in Years)",
       y = "score Score",
       color = "Pet Type")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-labels1-1.png" alt="Set custom labels with labs()" width="100%" />
<p class="caption">(\#fig:line-labels1)Set custom labels with labs()</p>
</div>


```r
ggplot(pets, aes(age, score, color = pet)) +
  geom_smooth(formula = y ~ x, method="lm") +
  ggtitle("Pet score with Age") +
  xlab("Age (in Years)") +
  ylab("score Score") +
  scale_color_discrete(name = "Pet Type")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-labels2-1.png" alt="Set custom labels with individual functions" width="100%" />
<p class="caption">(\#fig:line-labels2)Set custom labels with individual functions</p>
</div>

### Colours {#custom-colours}

You can set custom values for colour and fill using functions like `scale_colour_manual()` and `scale_fill_manual()`. The [Colours chapter in Cookbook for R](http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/) has many more ways to customise colour.


```r
ggplot(pets, aes(pet, score, colour = pet, fill = pet)) +
  geom_violin() +
  scale_color_manual(values = c("darkgreen", "dodgerblue", "orange")) +
  scale_fill_manual(values = c("#CCFFCC", "#BBDDFF", "#FFCC66"))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-labels-1.png" alt="Set custom colour" width="100%" />
<p class="caption">(\#fig:line-labels)Set custom colour</p>
</div>

### Themes {#themes}

GGplot comes with several additional themes and the ability to fully customise your theme. Type `?theme` into the console to see the full list. Other packages such as `cowplot` also have custom themes. You can add a custom theme to the end of your ggplot object and specify a new `base_size` to make the default fonts and lines larger or smaller.


```r
ggplot(pets, aes(age, score, color = pet)) +
  geom_smooth(formula = y ~ x, method="lm") +
  theme_minimal(base_size = 18)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/themes-1.png" alt="Minimal theme with 18-point base font size" width="100%" />
<p class="caption">(\#fig:themes)Minimal theme with 18-point base font size</p>
</div>

It's more complicated, but you can fully customise your theme with `theme()`. You can save this to an object and add it to the end of all of your plots to make the style consistent. Alternatively, you can set the theme at the top of a script with `theme_set()` and this will apply to all subsequent ggplot plots.





```r
vampire_theme <- theme(
  rect = element_rect(fill = "black"),
  panel.background = element_rect(fill = "black"),
  text = element_text(size = 20, colour = "white"),
  axis.text = element_text(size = 16, colour = "grey70"),
  line = element_line(colour = "white", size = 2),
  panel.grid = element_blank(),
  axis.line = element_line(colour = "white"),
  axis.ticks = element_blank(),
  legend.position = "top"
)

theme_set(vampire_theme)

ggplot(pets, aes(age, score, color = pet)) +
  geom_smooth(formula = y ~ x, method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/custom-themes-1.png" alt="Custom theme" width="100%" />
<p class="caption">(\#fig:custom-themes)Custom theme</p>
</div>




### Save as file {#ggsave}

You can save a ggplot using `ggsave()`. It saves the last ggplot you made, by default, but you can specify which plot you want to save if you assigned that plot to a variable.

You can set the `width` and `height` of your plot. The default units are inches, but you can change the `units` argument to "in", "cm", or "mm".



```r
box <- ggplot(pets, aes(pet, score, fill=pet)) +
  geom_boxplot(alpha = 0.5)

violin <- ggplot(pets, aes(pet, score, fill=pet)) +
  geom_violin(alpha = 0.5)

ggsave("demog_violin_plot.png", width = 5, height = 7)

ggsave("demog_box_plot.jpg", plot = box, width = 5, height = 7)
```

<div class="info">
<p>The file type is set from the filename suffix, or by specifying the argument <code>device</code>, which can take the following values: “eps”, “ps”, “tex”, “pdf”, “jpeg”, “tiff”, “png”, “bmp”, “svg” or “wmf”.</p>
</div>

## Combination Plots {#combo_plots}

### Violinbox plot

A combination of a violin plot to show the shape of the distribution and a boxplot to show the median and interquartile ranges can be a very useful visualisation.


```r
ggplot(pets, aes(pet, score, fill = pet)) +
  geom_violin(show.legend = FALSE) + 
  geom_boxplot(width = 0.2, fill = "white", 
               show.legend = FALSE)
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
ggplot(pets, aes(pet, score, fill=pet)) +
  geom_violin(trim = FALSE, alpha = 0.5) +
  stat_summary(
    fun = mean,
    fun.max = function(x) {mean(x) + sd(x)},
    fun.min = function(x) {mean(x) - sd(x)},
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
# sample_n chooses 50 random observations from the dataset
ggplot(sample_n(pets, 50), aes(pet, score, fill=pet)) +
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
ggplot(sample_n(pets, 50), aes(age, weight, colour = pet)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/scatter-line-1.png" alt="Scatter-line plot" width="100%" />
<p class="caption">(\#fig:scatter-line)Scatter-line plot</p>
</div>

### Grid of plots {#cowplot}

You can use the [ `cowplot`](https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html) package to easily make grids of different graphs. First, you have to assign each plot a name. Then you list all the plots as the first arguments of `plot_grid()` and provide a vector of labels.


```r
gg <- ggplot(pets, aes(pet, score, colour = pet))
nolegend <- theme(legend.position = 0)

vp <- gg + geom_violin(alpha = 0.5) + nolegend +
  ggtitle("Violin Plot")
bp <- gg + geom_boxplot(alpha = 0.5) + nolegend +
  ggtitle("Box Plot")
cp <- gg + stat_summary(fun = mean, geom = "col", fill = "white") + nolegend +
  ggtitle("Column Plot")
dp <- ggplot(pets, aes(score, colour = pet)) + 
  geom_density() + nolegend +
  ggtitle("Density Plot")

plot_grid(vp, bp, cp, dp, labels = LETTERS[1:4])
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/grid-1.png" alt="Grid of plots" width="100%" />
<p class="caption">(\#fig:grid)Grid of plots</p>
</div>

## Overlapping Discrete Data {#overlap}

### Reducing Opacity 

You can deal with overlapping data points (very common if you're using Likert scales) by reducing the opacity of the points. You need to use trial and error to adjust these so they look right.


```r
ggplot(pets, aes(age, score, colour = pet)) +
  geom_point(alpha = 0.25) +
  geom_smooth(formula = y ~ x, method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap-alpha-1.png" alt="Deal with overlapping data using transparency" width="100%" />
<p class="caption">(\#fig:overlap-alpha)Deal with overlapping data using transparency</p>
</div>

### Proportional Dot Plots {#geom_count}

Or you can set the size of the dot proportional to the number of overlapping observations using `geom_count()`.


```r
ggplot(pets, aes(age, score, colour = pet)) +
  geom_count()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap-size-1.png" alt="Deal with overlapping data using geom_count()" width="100%" />
<p class="caption">(\#fig:overlap-size)Deal with overlapping data using geom_count()</p>
</div>

Alternatively, you can transform your data (we will learn to do this in the [data wrangling](#dplyr) chapter) to create a count column and use the count to set the dot colour.


```r
pets %>%
  group_by(age, score) %>%
  summarise(count = n(), .groups = "drop") %>%
  ggplot(aes(age, score, color=count)) +
  geom_point(size = 2) +
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
ggplot(pets, aes(age, score)) +
  geom_point()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overplot-point-1.png" alt="Overplotted data" width="100%" />
<p class="caption">(\#fig:overplot-point)Overplotted data</p>
</div>

### 2D Density Plot {#geom_density2d}
Use `geom_density2d()` to create a contour map.


```r
ggplot(pets, aes(age, score)) +
  geom_density2d()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density2d-1.png" alt="Contour map with geom_density2d()" width="100%" />
<p class="caption">(\#fig:density2d)Contour map with geom_density2d()</p>
</div>

You can use `stat_density_2d(aes(fill = ..level..), geom = "polygon")` to create a heatmap-style density plot. 


```r
ggplot(pets, aes(age, score)) +
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
ggplot(pets, aes(age, score)) +
  geom_bin2d(binwidth = c(1, 5))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/bin2d-1.png" alt="Heatmap of bin counts" width="100%" />
<p class="caption">(\#fig:bin2d)Heatmap of bin counts</p>
</div>

### Hexagonal Heatmap {#geom_hex}

Use `geomhex()` to create a hexagonal heatmap of bin counts. Adjust the `binwidth`, `xlim()`, `ylim()` and/or the figure dimensions to make the hexagons more or less stretched.


```r
ggplot(pets, aes(age, score)) +
  geom_hex(binwidth = c(1, 5))
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overplot-hex-1.png" alt="Hexagonal heatmap of bin counts" width="100%" />
<p class="caption">(\#fig:overplot-hex)Hexagonal heatmap of bin counts</p>
</div>

### Correlation Heatmap {#geom_tile}

I've included the code for creating a correlation matrix from a table of variables, but you don't need to understand how this is done yet. We'll cover `mutate()` and `gather()` functions in the [dplyr](#dplyr) and [tidyr](#tidyr) lessons.


```r
heatmap <- pets %>%
  select_if(is.numeric) %>% # get just the numeric columns
  cor() %>% # create the correlation matrix
  as_tibble(rownames = "V1") %>% # make it a tibble
  gather("V2", "r", 2:ncol(.)) # wide to long (V2)
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

## Interactive Plots {#plotly}

You can use the `plotly` package to make interactive graphs. Just assign your ggplot to a variable and use the function `ggplotly()`.


```r
demog_plot <- ggplot(pets, aes(age, score, fill=pet)) +
  geom_point() +
  geom_smooth(formula = y~x, method = lm)

ggplotly(demog_plot)
```

<div class="figure" style="text-align: center">

```{=html}
<div id="htmlwidget-73ed398e49eb255651ed" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-73ed398e49eb255651ed">{"x":{"data":[{"x":[6,8,2,10,4,8,9,8,6,11,5,9,1,10,7,8,1,8,5,13,8,4,4,7,6,8,16,6,4,3,9,5,11,11,2,9,7,11,3,5,4,8,9,4,13,10,10,3,10,10,7,8,8,2,10,5,7,13,7,7,5,7,5,2,6,10,9,10,5,8,12,5,11,3,8,9,5,5,9,1,3,7,7,6,10,6,14,9,8,6,9,3,7,10,6,10,10,5,6,11,7,2,10,7,6,4,4,4,7,7,6,6,5,9,6,8,2,8,9,10,7,6,9,7,5,14,4,9,5,4,8,7,8,10,9,3,14,10,10,8,13,8,12,4,6,8,10,9,8,6,3,9,5,5,6,9,4,5,10,10,7,11,14,1,4,7,3,11,2,6,8,7,7,6,10,6,10,10,6,15,7,8,5,2,8,8,2,5,7,4,10,11,4,7,11,14,11,11,7,11,3,11,9,8,1,6,9,9,6,5,7,7,10,10,4,5,7,5,11,2,7,9,5,5,7,11,9,8,2,4,6,6,5,6,8,2,11,7,4,7,5,6,10,4,7,3,6,3,9,9,6,8,8,11,6,2,13,9,4,6,10,9,7,16,6,10,7,15,10,9,5,9,8,6,6,5,5,10,3,8,5,6,3,4,10,3,5,12,7,9,7,8,10,13,4,0,5,12,6,4,5,6,5,5,4,2,8,8,4,6,10,9,6,2,7,5,9,8,5,9,7,14,15,7,7,6,10,10,9,6,10,7,11,11,7,15,8,7,10,6,2,9,7,7,5,2,5,10,12,5,3,15,7,8,10,7,10,5,11,8,4,8,10,10,6,9,7,9,8,8,5,2,7,7,2,7,9,10,6,6,4,2,7,7,7,7,2,9,11,11,7,11,5,10,6,7,3,7,10,9],"y":[90,107,94,120,111,110,100,107,106,109,85,110,102,93,90,120,96,91,99,91,120,101,96,95,96,107,106,105,99,104,104,112,115,105,94,98,101,97,98,99,94,100,100,107,97,98,91,81,102,100,101,101,92,79,102,91,93,107,111,101,116,106,99,89,99,109,104,91,87,102,96,113,97,74,90,115,91,91,117,87,101,113,106,100,107,89,107,110,101,87,102,106,91,92,106,105,110,102,96,120,108,87,103,100,95,102,105,93,89,97,84,103,95,111,107,104,98,117,99,89,115,93,114,88,103,103,100,112,106,95,107,108,93,93,109,95,99,100,99,95,92,83,110,91,95,98,112,105,113,103,97,109,115,89,94,88,79,91,103,96,109,107,95,98,74,87,90,104,90,110,79,106,107,102,115,104,94,104,91,89,119,114,102,84,99,100,75,92,81,110,102,82,102,105,106,110,108,104,106,115,91,108,98,98,102,94,125,93,104,86,100,78,95,82,101,97,88,101,109,84,104,94,86,98,125,110,88,107,90,106,82,98,81,117,86,88,101,106,96,93,102,98,88,105,106,100,112,102,101,88,102,95,78,98,90,95,112,108,105,99,95,111,107,92,113,94,119,113,110,106,108,108,94,106,110,98,89,95,96,102,86,99,105,99,101,88,92,91,112,101,91,95,117,103,110,76,110,117,117,94,80,100,95,116,98,91,87,105,88,109,108,112,104,94,112,112,91,96,93,122,75,104,120,107,91,91,104,93,120,104,105,115,96,105,87,119,112,106,90,108,112,123,105,103,91,109,107,107,104,99,102,111,100,104,84,112,103,96,90,95,108,102,81,99,92,107,84,111,110,105,85,103,100,116,89,100,104,102,103,101,90,111,102,88,89,101,89,91,89,110,81,90,95,82,117,105,95,104,92,102],"text":["age:  6<br />score:  90<br />pet: dog","age:  8<br />score: 107<br />pet: dog","age:  2<br />score:  94<br />pet: dog","age: 10<br />score: 120<br />pet: dog","age:  4<br />score: 111<br />pet: dog","age:  8<br />score: 110<br />pet: dog","age:  9<br />score: 100<br />pet: dog","age:  8<br />score: 107<br />pet: dog","age:  6<br />score: 106<br />pet: dog","age: 11<br />score: 109<br />pet: dog","age:  5<br />score:  85<br />pet: dog","age:  9<br />score: 110<br />pet: dog","age:  1<br />score: 102<br />pet: dog","age: 10<br />score:  93<br />pet: dog","age:  7<br />score:  90<br />pet: dog","age:  8<br />score: 120<br />pet: dog","age:  1<br />score:  96<br />pet: dog","age:  8<br />score:  91<br />pet: dog","age:  5<br />score:  99<br />pet: dog","age: 13<br />score:  91<br />pet: dog","age:  8<br />score: 120<br />pet: dog","age:  4<br />score: 101<br />pet: dog","age:  4<br />score:  96<br />pet: dog","age:  7<br />score:  95<br />pet: dog","age:  6<br />score:  96<br />pet: dog","age:  8<br />score: 107<br />pet: dog","age: 16<br />score: 106<br />pet: dog","age:  6<br />score: 105<br />pet: dog","age:  4<br />score:  99<br />pet: dog","age:  3<br />score: 104<br />pet: dog","age:  9<br />score: 104<br />pet: dog","age:  5<br />score: 112<br />pet: dog","age: 11<br />score: 115<br />pet: dog","age: 11<br />score: 105<br />pet: dog","age:  2<br />score:  94<br />pet: dog","age:  9<br />score:  98<br />pet: dog","age:  7<br />score: 101<br />pet: dog","age: 11<br />score:  97<br />pet: dog","age:  3<br />score:  98<br />pet: dog","age:  5<br />score:  99<br />pet: dog","age:  4<br />score:  94<br />pet: dog","age:  8<br />score: 100<br />pet: dog","age:  9<br />score: 100<br />pet: dog","age:  4<br />score: 107<br />pet: dog","age: 13<br />score:  97<br />pet: dog","age: 10<br />score:  98<br />pet: dog","age: 10<br />score:  91<br />pet: dog","age:  3<br />score:  81<br />pet: dog","age: 10<br />score: 102<br />pet: dog","age: 10<br />score: 100<br />pet: dog","age:  7<br />score: 101<br />pet: dog","age:  8<br />score: 101<br />pet: dog","age:  8<br />score:  92<br />pet: dog","age:  2<br />score:  79<br />pet: dog","age: 10<br />score: 102<br />pet: dog","age:  5<br />score:  91<br />pet: dog","age:  7<br />score:  93<br />pet: dog","age: 13<br />score: 107<br />pet: dog","age:  7<br />score: 111<br />pet: dog","age:  7<br />score: 101<br />pet: dog","age:  5<br />score: 116<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age:  5<br />score:  99<br />pet: dog","age:  2<br />score:  89<br />pet: dog","age:  6<br />score:  99<br />pet: dog","age: 10<br />score: 109<br />pet: dog","age:  9<br />score: 104<br />pet: dog","age: 10<br />score:  91<br />pet: dog","age:  5<br />score:  87<br />pet: dog","age:  8<br />score: 102<br />pet: dog","age: 12<br />score:  96<br />pet: dog","age:  5<br />score: 113<br />pet: dog","age: 11<br />score:  97<br />pet: dog","age:  3<br />score:  74<br />pet: dog","age:  8<br />score:  90<br />pet: dog","age:  9<br />score: 115<br />pet: dog","age:  5<br />score:  91<br />pet: dog","age:  5<br />score:  91<br />pet: dog","age:  9<br />score: 117<br />pet: dog","age:  1<br />score:  87<br />pet: dog","age:  3<br />score: 101<br />pet: dog","age:  7<br />score: 113<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age:  6<br />score: 100<br />pet: dog","age: 10<br />score: 107<br />pet: dog","age:  6<br />score:  89<br />pet: dog","age: 14<br />score: 107<br />pet: dog","age:  9<br />score: 110<br />pet: dog","age:  8<br />score: 101<br />pet: dog","age:  6<br />score:  87<br />pet: dog","age:  9<br />score: 102<br />pet: dog","age:  3<br />score: 106<br />pet: dog","age:  7<br />score:  91<br />pet: dog","age: 10<br />score:  92<br />pet: dog","age:  6<br />score: 106<br />pet: dog","age: 10<br />score: 105<br />pet: dog","age: 10<br />score: 110<br />pet: dog","age:  5<br />score: 102<br />pet: dog","age:  6<br />score:  96<br />pet: dog","age: 11<br />score: 120<br />pet: dog","age:  7<br />score: 108<br />pet: dog","age:  2<br />score:  87<br />pet: dog","age: 10<br />score: 103<br />pet: dog","age:  7<br />score: 100<br />pet: dog","age:  6<br />score:  95<br />pet: dog","age:  4<br />score: 102<br />pet: dog","age:  4<br />score: 105<br />pet: dog","age:  4<br />score:  93<br />pet: dog","age:  7<br />score:  89<br />pet: dog","age:  7<br />score:  97<br />pet: dog","age:  6<br />score:  84<br />pet: dog","age:  6<br />score: 103<br />pet: dog","age:  5<br />score:  95<br />pet: dog","age:  9<br />score: 111<br />pet: dog","age:  6<br />score: 107<br />pet: dog","age:  8<br />score: 104<br />pet: dog","age:  2<br />score:  98<br />pet: dog","age:  8<br />score: 117<br />pet: dog","age:  9<br />score:  99<br />pet: dog","age: 10<br />score:  89<br />pet: dog","age:  7<br />score: 115<br />pet: dog","age:  6<br />score:  93<br />pet: dog","age:  9<br />score: 114<br />pet: dog","age:  7<br />score:  88<br />pet: dog","age:  5<br />score: 103<br />pet: dog","age: 14<br />score: 103<br />pet: dog","age:  4<br />score: 100<br />pet: dog","age:  9<br />score: 112<br />pet: dog","age:  5<br />score: 106<br />pet: dog","age:  4<br />score:  95<br />pet: dog","age:  8<br />score: 107<br />pet: dog","age:  7<br />score: 108<br />pet: dog","age:  8<br />score:  93<br />pet: dog","age: 10<br />score:  93<br />pet: dog","age:  9<br />score: 109<br />pet: dog","age:  3<br />score:  95<br />pet: dog","age: 14<br />score:  99<br />pet: dog","age: 10<br />score: 100<br />pet: dog","age: 10<br />score:  99<br />pet: dog","age:  8<br />score:  95<br />pet: dog","age: 13<br />score:  92<br />pet: dog","age:  8<br />score:  83<br />pet: dog","age: 12<br />score: 110<br />pet: dog","age:  4<br />score:  91<br />pet: dog","age:  6<br />score:  95<br />pet: dog","age:  8<br />score:  98<br />pet: dog","age: 10<br />score: 112<br />pet: dog","age:  9<br />score: 105<br />pet: dog","age:  8<br />score: 113<br />pet: dog","age:  6<br />score: 103<br />pet: dog","age:  3<br />score:  97<br />pet: dog","age:  9<br />score: 109<br />pet: dog","age:  5<br />score: 115<br />pet: dog","age:  5<br />score:  89<br />pet: dog","age:  6<br />score:  94<br />pet: dog","age:  9<br />score:  88<br />pet: dog","age:  4<br />score:  79<br />pet: dog","age:  5<br />score:  91<br />pet: dog","age: 10<br />score: 103<br />pet: dog","age: 10<br />score:  96<br />pet: dog","age:  7<br />score: 109<br />pet: dog","age: 11<br />score: 107<br />pet: dog","age: 14<br />score:  95<br />pet: dog","age:  1<br />score:  98<br />pet: dog","age:  4<br />score:  74<br />pet: dog","age:  7<br />score:  87<br />pet: dog","age:  3<br />score:  90<br />pet: dog","age: 11<br />score: 104<br />pet: dog","age:  2<br />score:  90<br />pet: dog","age:  6<br />score: 110<br />pet: dog","age:  8<br />score:  79<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age:  7<br />score: 107<br />pet: dog","age:  6<br />score: 102<br />pet: dog","age: 10<br />score: 115<br />pet: dog","age:  6<br />score: 104<br />pet: dog","age: 10<br />score:  94<br />pet: dog","age: 10<br />score: 104<br />pet: dog","age:  6<br />score:  91<br />pet: dog","age: 15<br />score:  89<br />pet: dog","age:  7<br />score: 119<br />pet: dog","age:  8<br />score: 114<br />pet: dog","age:  5<br />score: 102<br />pet: dog","age:  2<br />score:  84<br />pet: dog","age:  8<br />score:  99<br />pet: dog","age:  8<br />score: 100<br />pet: dog","age:  2<br />score:  75<br />pet: dog","age:  5<br />score:  92<br />pet: dog","age:  7<br />score:  81<br />pet: dog","age:  4<br />score: 110<br />pet: dog","age: 10<br />score: 102<br />pet: dog","age: 11<br />score:  82<br />pet: dog","age:  4<br />score: 102<br />pet: dog","age:  7<br />score: 105<br />pet: dog","age: 11<br />score: 106<br />pet: dog","age: 14<br />score: 110<br />pet: dog","age: 11<br />score: 108<br />pet: dog","age: 11<br />score: 104<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age: 11<br />score: 115<br />pet: dog","age:  3<br />score:  91<br />pet: dog","age: 11<br />score: 108<br />pet: dog","age:  9<br />score:  98<br />pet: dog","age:  8<br />score:  98<br />pet: dog","age:  1<br />score: 102<br />pet: dog","age:  6<br />score:  94<br />pet: dog","age:  9<br />score: 125<br />pet: dog","age:  9<br />score:  93<br />pet: dog","age:  6<br />score: 104<br />pet: dog","age:  5<br />score:  86<br />pet: dog","age:  7<br />score: 100<br />pet: dog","age:  7<br />score:  78<br />pet: dog","age: 10<br />score:  95<br />pet: dog","age: 10<br />score:  82<br />pet: dog","age:  4<br />score: 101<br />pet: dog","age:  5<br />score:  97<br />pet: dog","age:  7<br />score:  88<br />pet: dog","age:  5<br />score: 101<br />pet: dog","age: 11<br />score: 109<br />pet: dog","age:  2<br />score:  84<br />pet: dog","age:  7<br />score: 104<br />pet: dog","age:  9<br />score:  94<br />pet: dog","age:  5<br />score:  86<br />pet: dog","age:  5<br />score:  98<br />pet: dog","age:  7<br />score: 125<br />pet: dog","age: 11<br />score: 110<br />pet: dog","age:  9<br />score:  88<br />pet: dog","age:  8<br />score: 107<br />pet: dog","age:  2<br />score:  90<br />pet: dog","age:  4<br />score: 106<br />pet: dog","age:  6<br />score:  82<br />pet: dog","age:  6<br />score:  98<br />pet: dog","age:  5<br />score:  81<br />pet: dog","age:  6<br />score: 117<br />pet: dog","age:  8<br />score:  86<br />pet: dog","age:  2<br />score:  88<br />pet: dog","age: 11<br />score: 101<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age:  4<br />score:  96<br />pet: dog","age:  7<br />score:  93<br />pet: dog","age:  5<br />score: 102<br />pet: dog","age:  6<br />score:  98<br />pet: dog","age: 10<br />score:  88<br />pet: dog","age:  4<br />score: 105<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age:  3<br />score: 100<br />pet: dog","age:  6<br />score: 112<br />pet: dog","age:  3<br />score: 102<br />pet: dog","age:  9<br />score: 101<br />pet: dog","age:  9<br />score:  88<br />pet: dog","age:  6<br />score: 102<br />pet: dog","age:  8<br />score:  95<br />pet: dog","age:  8<br />score:  78<br />pet: dog","age: 11<br />score:  98<br />pet: dog","age:  6<br />score:  90<br />pet: dog","age:  2<br />score:  95<br />pet: dog","age: 13<br />score: 112<br />pet: dog","age:  9<br />score: 108<br />pet: dog","age:  4<br />score: 105<br />pet: dog","age:  6<br />score:  99<br />pet: dog","age: 10<br />score:  95<br />pet: dog","age:  9<br />score: 111<br />pet: dog","age:  7<br />score: 107<br />pet: dog","age: 16<br />score:  92<br />pet: dog","age:  6<br />score: 113<br />pet: dog","age: 10<br />score:  94<br />pet: dog","age:  7<br />score: 119<br />pet: dog","age: 15<br />score: 113<br />pet: dog","age: 10<br />score: 110<br />pet: dog","age:  9<br />score: 106<br />pet: dog","age:  5<br />score: 108<br />pet: dog","age:  9<br />score: 108<br />pet: dog","age:  8<br />score:  94<br />pet: dog","age:  6<br />score: 106<br />pet: dog","age:  6<br />score: 110<br />pet: dog","age:  5<br />score:  98<br />pet: dog","age:  5<br />score:  89<br />pet: dog","age: 10<br />score:  95<br />pet: dog","age:  3<br />score:  96<br />pet: dog","age:  8<br />score: 102<br />pet: dog","age:  5<br />score:  86<br />pet: dog","age:  6<br />score:  99<br />pet: dog","age:  3<br />score: 105<br />pet: dog","age:  4<br />score:  99<br />pet: dog","age: 10<br />score: 101<br />pet: dog","age:  3<br />score:  88<br />pet: dog","age:  5<br />score:  92<br />pet: dog","age: 12<br />score:  91<br />pet: dog","age:  7<br />score: 112<br />pet: dog","age:  9<br />score: 101<br />pet: dog","age:  7<br />score:  91<br />pet: dog","age:  8<br />score:  95<br />pet: dog","age: 10<br />score: 117<br />pet: dog","age: 13<br />score: 103<br />pet: dog","age:  4<br />score: 110<br />pet: dog","age:  0<br />score:  76<br />pet: dog","age:  5<br />score: 110<br />pet: dog","age: 12<br />score: 117<br />pet: dog","age:  6<br />score: 117<br />pet: dog","age:  4<br />score:  94<br />pet: dog","age:  5<br />score:  80<br />pet: dog","age:  6<br />score: 100<br />pet: dog","age:  5<br />score:  95<br />pet: dog","age:  5<br />score: 116<br />pet: dog","age:  4<br />score:  98<br />pet: dog","age:  2<br />score:  91<br />pet: dog","age:  8<br />score:  87<br />pet: dog","age:  8<br />score: 105<br />pet: dog","age:  4<br />score:  88<br />pet: dog","age:  6<br />score: 109<br />pet: dog","age: 10<br />score: 108<br />pet: dog","age:  9<br />score: 112<br />pet: dog","age:  6<br />score: 104<br />pet: dog","age:  2<br />score:  94<br />pet: dog","age:  7<br />score: 112<br />pet: dog","age:  5<br />score: 112<br />pet: dog","age:  9<br />score:  91<br />pet: dog","age:  8<br />score:  96<br />pet: dog","age:  5<br />score:  93<br />pet: dog","age:  9<br />score: 122<br />pet: dog","age:  7<br />score:  75<br />pet: dog","age: 14<br />score: 104<br />pet: dog","age: 15<br />score: 120<br />pet: dog","age:  7<br />score: 107<br />pet: dog","age:  7<br />score:  91<br />pet: dog","age:  6<br />score:  91<br />pet: dog","age: 10<br />score: 104<br />pet: dog","age: 10<br />score:  93<br />pet: dog","age:  9<br />score: 120<br />pet: dog","age:  6<br />score: 104<br />pet: dog","age: 10<br />score: 105<br />pet: dog","age:  7<br />score: 115<br />pet: dog","age: 11<br />score:  96<br />pet: dog","age: 11<br />score: 105<br />pet: dog","age:  7<br />score:  87<br />pet: dog","age: 15<br />score: 119<br />pet: dog","age:  8<br />score: 112<br />pet: dog","age:  7<br />score: 106<br />pet: dog","age: 10<br />score:  90<br />pet: dog","age:  6<br />score: 108<br />pet: dog","age:  2<br />score: 112<br />pet: dog","age:  9<br />score: 123<br />pet: dog","age:  7<br />score: 105<br />pet: dog","age:  7<br />score: 103<br />pet: dog","age:  5<br />score:  91<br />pet: dog","age:  2<br />score: 109<br />pet: dog","age:  5<br />score: 107<br />pet: dog","age: 10<br />score: 107<br />pet: dog","age: 12<br />score: 104<br />pet: dog","age:  5<br />score:  99<br />pet: dog","age:  3<br />score: 102<br />pet: dog","age: 15<br />score: 111<br />pet: dog","age:  7<br />score: 100<br />pet: dog","age:  8<br />score: 104<br />pet: dog","age: 10<br />score:  84<br />pet: dog","age:  7<br />score: 112<br />pet: dog","age: 10<br />score: 103<br />pet: dog","age:  5<br />score:  96<br />pet: dog","age: 11<br />score:  90<br />pet: dog","age:  8<br />score:  95<br />pet: dog","age:  4<br />score: 108<br />pet: dog","age:  8<br />score: 102<br />pet: dog","age: 10<br />score:  81<br />pet: dog","age: 10<br />score:  99<br />pet: dog","age:  6<br />score:  92<br />pet: dog","age:  9<br />score: 107<br />pet: dog","age:  7<br />score:  84<br />pet: dog","age:  9<br />score: 111<br />pet: dog","age:  8<br />score: 110<br />pet: dog","age:  8<br />score: 105<br />pet: dog","age:  5<br />score:  85<br />pet: dog","age:  2<br />score: 103<br />pet: dog","age:  7<br />score: 100<br />pet: dog","age:  7<br />score: 116<br />pet: dog","age:  2<br />score:  89<br />pet: dog","age:  7<br />score: 100<br />pet: dog","age:  9<br />score: 104<br />pet: dog","age: 10<br />score: 102<br />pet: dog","age:  6<br />score: 103<br />pet: dog","age:  6<br />score: 101<br />pet: dog","age:  4<br />score:  90<br />pet: dog","age:  2<br />score: 111<br />pet: dog","age:  7<br />score: 102<br />pet: dog","age:  7<br />score:  88<br />pet: dog","age:  7<br />score:  89<br />pet: dog","age:  7<br />score: 101<br />pet: dog","age:  2<br />score:  89<br />pet: dog","age:  9<br />score:  91<br />pet: dog","age: 11<br />score:  89<br />pet: dog","age: 11<br />score: 110<br />pet: dog","age:  7<br />score:  81<br />pet: dog","age: 11<br />score:  90<br />pet: dog","age:  5<br />score:  95<br />pet: dog","age: 10<br />score:  82<br />pet: dog","age:  6<br />score: 117<br />pet: dog","age:  7<br />score: 105<br />pet: dog","age:  3<br />score:  95<br />pet: dog","age:  7<br />score: 104<br />pet: dog","age: 10<br />score:  92<br />pet: dog","age:  9<br />score: 102<br />pet: dog"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"dog","legendgroup":"dog","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2,7,4,6,3,2,6,10,4,10,5,9,5,5,10,10,7,5,10,7,10,7,6,4,11,8,5,11,7,14,8,9,8,6,9,4,11,4,5,10,4,3,8,9,9,7,3,5,6,4,10,6,3,6,5,4,5,2,6,8,9,4,0,10,5,6,4,11,6,6,3,5,7,2,13,10,5,5,9,10,8,2,7,11,1,6,9,12,8,7,8,8,8,7,9,7,5,5,9,6,12,5,12,10,7,11,8,7,9,10,4,4,8,3,10,6,12,10,7,7,6,10,5,6,5,7,10,2,4,7,1,7,14,4,1,4,2,8,7,4,8,7,5,5,4,5,6,12,9,10,3,11,9,7,7,12,8,9,2,8,6,5,10,4,2,15,9,8,6,12,7,8,6,11,7,3,12,5,12,1,6,8,10,9,7,8,8,9,4,9,9,8,13,9,8,7,6,5,2,2,10,9,7,6,3,4,9,11,8,7,11,4,10,2,7,13,2,3,9,12,4,6,3,10,10,7,10,10,5,8,11,10,9,10,8,12,7,8,5,7,5,8,11,9,7,1,8,13,9,7,5,5,8,2,6,5,7,11,2,7,6,6,6,5,9,7,8,3,7,9,5,10,9,7,8,3,1,10,3,7,4,9,5,9,4,4,5,11,5,6,10,5,6,4,8,9,10,4,7,8],"y":[95,96,72,99,85,115,89,86,87,106,89,93,88,78,98,83,92,93,76,92,100,99,95,89,97,79,76,88,89,76,86,106,91,80,73,108,91,94,92,78,84,99,95,89,95,70,103,119,97,89,86,86,74,88,88,81,92,96,85,89,79,89,90,82,72,97,81,81,100,109,98,94,100,83,88,90,92,94,66,105,107,94,73,75,85,106,85,75,98,104,83,83,79,92,88,96,75,108,92,100,76,97,78,82,97,86,85,91,86,110,80,93,99,96,91,91,101,95,81,95,89,88,83,97,86,88,82,87,94,110,102,86,76,95,88,98,92,90,91,99,88,98,101,86,106,115,106,90,98,85,88,95,74,96,77,85,94,89,84,84,88,115,89,97,71,71,85,92,79,84,97,90,90,84,103,82,89,83,80,83,106,107,92,93,87,92,88,95,88,100,102,80,71,76,76,85,71,91,99,82,86,77,104,102,103,98,95,63,93,78,80,104,84,106,104,85,102,96,117,84,101,83,85,80,85,97,100,77,101,90,84,95,90,102,105,85,94,90,83,106,93,92,93,77,103,101,73,93,87,81,96,89,84,89,90,80,107,89,84,80,83,51,86,81,109,91,90,99,91,108,100,91,85,99,102,84,89,95,96,79,89,82,95,84,83,114,101,73,90,83,90,95,55,94,88,79,99,119,86,93],"text":["age:  2<br />score:  95<br />pet: cat","age:  7<br />score:  96<br />pet: cat","age:  4<br />score:  72<br />pet: cat","age:  6<br />score:  99<br />pet: cat","age:  3<br />score:  85<br />pet: cat","age:  2<br />score: 115<br />pet: cat","age:  6<br />score:  89<br />pet: cat","age: 10<br />score:  86<br />pet: cat","age:  4<br />score:  87<br />pet: cat","age: 10<br />score: 106<br />pet: cat","age:  5<br />score:  89<br />pet: cat","age:  9<br />score:  93<br />pet: cat","age:  5<br />score:  88<br />pet: cat","age:  5<br />score:  78<br />pet: cat","age: 10<br />score:  98<br />pet: cat","age: 10<br />score:  83<br />pet: cat","age:  7<br />score:  92<br />pet: cat","age:  5<br />score:  93<br />pet: cat","age: 10<br />score:  76<br />pet: cat","age:  7<br />score:  92<br />pet: cat","age: 10<br />score: 100<br />pet: cat","age:  7<br />score:  99<br />pet: cat","age:  6<br />score:  95<br />pet: cat","age:  4<br />score:  89<br />pet: cat","age: 11<br />score:  97<br />pet: cat","age:  8<br />score:  79<br />pet: cat","age:  5<br />score:  76<br />pet: cat","age: 11<br />score:  88<br />pet: cat","age:  7<br />score:  89<br />pet: cat","age: 14<br />score:  76<br />pet: cat","age:  8<br />score:  86<br />pet: cat","age:  9<br />score: 106<br />pet: cat","age:  8<br />score:  91<br />pet: cat","age:  6<br />score:  80<br />pet: cat","age:  9<br />score:  73<br />pet: cat","age:  4<br />score: 108<br />pet: cat","age: 11<br />score:  91<br />pet: cat","age:  4<br />score:  94<br />pet: cat","age:  5<br />score:  92<br />pet: cat","age: 10<br />score:  78<br />pet: cat","age:  4<br />score:  84<br />pet: cat","age:  3<br />score:  99<br />pet: cat","age:  8<br />score:  95<br />pet: cat","age:  9<br />score:  89<br />pet: cat","age:  9<br />score:  95<br />pet: cat","age:  7<br />score:  70<br />pet: cat","age:  3<br />score: 103<br />pet: cat","age:  5<br />score: 119<br />pet: cat","age:  6<br />score:  97<br />pet: cat","age:  4<br />score:  89<br />pet: cat","age: 10<br />score:  86<br />pet: cat","age:  6<br />score:  86<br />pet: cat","age:  3<br />score:  74<br />pet: cat","age:  6<br />score:  88<br />pet: cat","age:  5<br />score:  88<br />pet: cat","age:  4<br />score:  81<br />pet: cat","age:  5<br />score:  92<br />pet: cat","age:  2<br />score:  96<br />pet: cat","age:  6<br />score:  85<br />pet: cat","age:  8<br />score:  89<br />pet: cat","age:  9<br />score:  79<br />pet: cat","age:  4<br />score:  89<br />pet: cat","age:  0<br />score:  90<br />pet: cat","age: 10<br />score:  82<br />pet: cat","age:  5<br />score:  72<br />pet: cat","age:  6<br />score:  97<br />pet: cat","age:  4<br />score:  81<br />pet: cat","age: 11<br />score:  81<br />pet: cat","age:  6<br />score: 100<br />pet: cat","age:  6<br />score: 109<br />pet: cat","age:  3<br />score:  98<br />pet: cat","age:  5<br />score:  94<br />pet: cat","age:  7<br />score: 100<br />pet: cat","age:  2<br />score:  83<br />pet: cat","age: 13<br />score:  88<br />pet: cat","age: 10<br />score:  90<br />pet: cat","age:  5<br />score:  92<br />pet: cat","age:  5<br />score:  94<br />pet: cat","age:  9<br />score:  66<br />pet: cat","age: 10<br />score: 105<br />pet: cat","age:  8<br />score: 107<br />pet: cat","age:  2<br />score:  94<br />pet: cat","age:  7<br />score:  73<br />pet: cat","age: 11<br />score:  75<br />pet: cat","age:  1<br />score:  85<br />pet: cat","age:  6<br />score: 106<br />pet: cat","age:  9<br />score:  85<br />pet: cat","age: 12<br />score:  75<br />pet: cat","age:  8<br />score:  98<br />pet: cat","age:  7<br />score: 104<br />pet: cat","age:  8<br />score:  83<br />pet: cat","age:  8<br />score:  83<br />pet: cat","age:  8<br />score:  79<br />pet: cat","age:  7<br />score:  92<br />pet: cat","age:  9<br />score:  88<br />pet: cat","age:  7<br />score:  96<br />pet: cat","age:  5<br />score:  75<br />pet: cat","age:  5<br />score: 108<br />pet: cat","age:  9<br />score:  92<br />pet: cat","age:  6<br />score: 100<br />pet: cat","age: 12<br />score:  76<br />pet: cat","age:  5<br />score:  97<br />pet: cat","age: 12<br />score:  78<br />pet: cat","age: 10<br />score:  82<br />pet: cat","age:  7<br />score:  97<br />pet: cat","age: 11<br />score:  86<br />pet: cat","age:  8<br />score:  85<br />pet: cat","age:  7<br />score:  91<br />pet: cat","age:  9<br />score:  86<br />pet: cat","age: 10<br />score: 110<br />pet: cat","age:  4<br />score:  80<br />pet: cat","age:  4<br />score:  93<br />pet: cat","age:  8<br />score:  99<br />pet: cat","age:  3<br />score:  96<br />pet: cat","age: 10<br />score:  91<br />pet: cat","age:  6<br />score:  91<br />pet: cat","age: 12<br />score: 101<br />pet: cat","age: 10<br />score:  95<br />pet: cat","age:  7<br />score:  81<br />pet: cat","age:  7<br />score:  95<br />pet: cat","age:  6<br />score:  89<br />pet: cat","age: 10<br />score:  88<br />pet: cat","age:  5<br />score:  83<br />pet: cat","age:  6<br />score:  97<br />pet: cat","age:  5<br />score:  86<br />pet: cat","age:  7<br />score:  88<br />pet: cat","age: 10<br />score:  82<br />pet: cat","age:  2<br />score:  87<br />pet: cat","age:  4<br />score:  94<br />pet: cat","age:  7<br />score: 110<br />pet: cat","age:  1<br />score: 102<br />pet: cat","age:  7<br />score:  86<br />pet: cat","age: 14<br />score:  76<br />pet: cat","age:  4<br />score:  95<br />pet: cat","age:  1<br />score:  88<br />pet: cat","age:  4<br />score:  98<br />pet: cat","age:  2<br />score:  92<br />pet: cat","age:  8<br />score:  90<br />pet: cat","age:  7<br />score:  91<br />pet: cat","age:  4<br />score:  99<br />pet: cat","age:  8<br />score:  88<br />pet: cat","age:  7<br />score:  98<br />pet: cat","age:  5<br />score: 101<br />pet: cat","age:  5<br />score:  86<br />pet: cat","age:  4<br />score: 106<br />pet: cat","age:  5<br />score: 115<br />pet: cat","age:  6<br />score: 106<br />pet: cat","age: 12<br />score:  90<br />pet: cat","age:  9<br />score:  98<br />pet: cat","age: 10<br />score:  85<br />pet: cat","age:  3<br />score:  88<br />pet: cat","age: 11<br />score:  95<br />pet: cat","age:  9<br />score:  74<br />pet: cat","age:  7<br />score:  96<br />pet: cat","age:  7<br />score:  77<br />pet: cat","age: 12<br />score:  85<br />pet: cat","age:  8<br />score:  94<br />pet: cat","age:  9<br />score:  89<br />pet: cat","age:  2<br />score:  84<br />pet: cat","age:  8<br />score:  84<br />pet: cat","age:  6<br />score:  88<br />pet: cat","age:  5<br />score: 115<br />pet: cat","age: 10<br />score:  89<br />pet: cat","age:  4<br />score:  97<br />pet: cat","age:  2<br />score:  71<br />pet: cat","age: 15<br />score:  71<br />pet: cat","age:  9<br />score:  85<br />pet: cat","age:  8<br />score:  92<br />pet: cat","age:  6<br />score:  79<br />pet: cat","age: 12<br />score:  84<br />pet: cat","age:  7<br />score:  97<br />pet: cat","age:  8<br />score:  90<br />pet: cat","age:  6<br />score:  90<br />pet: cat","age: 11<br />score:  84<br />pet: cat","age:  7<br />score: 103<br />pet: cat","age:  3<br />score:  82<br />pet: cat","age: 12<br />score:  89<br />pet: cat","age:  5<br />score:  83<br />pet: cat","age: 12<br />score:  80<br />pet: cat","age:  1<br />score:  83<br />pet: cat","age:  6<br />score: 106<br />pet: cat","age:  8<br />score: 107<br />pet: cat","age: 10<br />score:  92<br />pet: cat","age:  9<br />score:  93<br />pet: cat","age:  7<br />score:  87<br />pet: cat","age:  8<br />score:  92<br />pet: cat","age:  8<br />score:  88<br />pet: cat","age:  9<br />score:  95<br />pet: cat","age:  4<br />score:  88<br />pet: cat","age:  9<br />score: 100<br />pet: cat","age:  9<br />score: 102<br />pet: cat","age:  8<br />score:  80<br />pet: cat","age: 13<br />score:  71<br />pet: cat","age:  9<br />score:  76<br />pet: cat","age:  8<br />score:  76<br />pet: cat","age:  7<br />score:  85<br />pet: cat","age:  6<br />score:  71<br />pet: cat","age:  5<br />score:  91<br />pet: cat","age:  2<br />score:  99<br />pet: cat","age:  2<br />score:  82<br />pet: cat","age: 10<br />score:  86<br />pet: cat","age:  9<br />score:  77<br />pet: cat","age:  7<br />score: 104<br />pet: cat","age:  6<br />score: 102<br />pet: cat","age:  3<br />score: 103<br />pet: cat","age:  4<br />score:  98<br />pet: cat","age:  9<br />score:  95<br />pet: cat","age: 11<br />score:  63<br />pet: cat","age:  8<br />score:  93<br />pet: cat","age:  7<br />score:  78<br />pet: cat","age: 11<br />score:  80<br />pet: cat","age:  4<br />score: 104<br />pet: cat","age: 10<br />score:  84<br />pet: cat","age:  2<br />score: 106<br />pet: cat","age:  7<br />score: 104<br />pet: cat","age: 13<br />score:  85<br />pet: cat","age:  2<br />score: 102<br />pet: cat","age:  3<br />score:  96<br />pet: cat","age:  9<br />score: 117<br />pet: cat","age: 12<br />score:  84<br />pet: cat","age:  4<br />score: 101<br />pet: cat","age:  6<br />score:  83<br />pet: cat","age:  3<br />score:  85<br />pet: cat","age: 10<br />score:  80<br />pet: cat","age: 10<br />score:  85<br />pet: cat","age:  7<br />score:  97<br />pet: cat","age: 10<br />score: 100<br />pet: cat","age: 10<br />score:  77<br />pet: cat","age:  5<br />score: 101<br />pet: cat","age:  8<br />score:  90<br />pet: cat","age: 11<br />score:  84<br />pet: cat","age: 10<br />score:  95<br />pet: cat","age:  9<br />score:  90<br />pet: cat","age: 10<br />score: 102<br />pet: cat","age:  8<br />score: 105<br />pet: cat","age: 12<br />score:  85<br />pet: cat","age:  7<br />score:  94<br />pet: cat","age:  8<br />score:  90<br />pet: cat","age:  5<br />score:  83<br />pet: cat","age:  7<br />score: 106<br />pet: cat","age:  5<br />score:  93<br />pet: cat","age:  8<br />score:  92<br />pet: cat","age: 11<br />score:  93<br />pet: cat","age:  9<br />score:  77<br />pet: cat","age:  7<br />score: 103<br />pet: cat","age:  1<br />score: 101<br />pet: cat","age:  8<br />score:  73<br />pet: cat","age: 13<br />score:  93<br />pet: cat","age:  9<br />score:  87<br />pet: cat","age:  7<br />score:  81<br />pet: cat","age:  5<br />score:  96<br />pet: cat","age:  5<br />score:  89<br />pet: cat","age:  8<br />score:  84<br />pet: cat","age:  2<br />score:  89<br />pet: cat","age:  6<br />score:  90<br />pet: cat","age:  5<br />score:  80<br />pet: cat","age:  7<br />score: 107<br />pet: cat","age: 11<br />score:  89<br />pet: cat","age:  2<br />score:  84<br />pet: cat","age:  7<br />score:  80<br />pet: cat","age:  6<br />score:  83<br />pet: cat","age:  6<br />score:  51<br />pet: cat","age:  6<br />score:  86<br />pet: cat","age:  5<br />score:  81<br />pet: cat","age:  9<br />score: 109<br />pet: cat","age:  7<br />score:  91<br />pet: cat","age:  8<br />score:  90<br />pet: cat","age:  3<br />score:  99<br />pet: cat","age:  7<br />score:  91<br />pet: cat","age:  9<br />score: 108<br />pet: cat","age:  5<br />score: 100<br />pet: cat","age: 10<br />score:  91<br />pet: cat","age:  9<br />score:  85<br />pet: cat","age:  7<br />score:  99<br />pet: cat","age:  8<br />score: 102<br />pet: cat","age:  3<br />score:  84<br />pet: cat","age:  1<br />score:  89<br />pet: cat","age: 10<br />score:  95<br />pet: cat","age:  3<br />score:  96<br />pet: cat","age:  7<br />score:  79<br />pet: cat","age:  4<br />score:  89<br />pet: cat","age:  9<br />score:  82<br />pet: cat","age:  5<br />score:  95<br />pet: cat","age:  9<br />score:  84<br />pet: cat","age:  4<br />score:  83<br />pet: cat","age:  4<br />score: 114<br />pet: cat","age:  5<br />score: 101<br />pet: cat","age: 11<br />score:  73<br />pet: cat","age:  5<br />score:  90<br />pet: cat","age:  6<br />score:  83<br />pet: cat","age: 10<br />score:  90<br />pet: cat","age:  5<br />score:  95<br />pet: cat","age:  6<br />score:  55<br />pet: cat","age:  4<br />score:  94<br />pet: cat","age:  8<br />score:  88<br />pet: cat","age:  9<br />score:  79<br />pet: cat","age: 10<br />score:  99<br />pet: cat","age:  4<br />score: 119<br />pet: cat","age:  7<br />score:  86<br />pet: cat","age:  8<br />score:  93<br />pet: cat"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,186,56,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"cat","legendgroup":"cat","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[6,7,5,2,7,4,4,6,8,9,5,11,12,8,5,2,9,7,9,7,8,6,11,12,4,9,6,7,6,11,6,5,5,7,6,3,10,8,9,7,4,6,3,10,15,3,10,8,9,5,9,9,7,4,5,3,6,4,4,8,8,6,3,5,6,5,9,6,3,13,4,11,7,11,10,8,8,3,9,9,7,7,4,8,9,5,1,7,3,9,10,7,5,8,1,7,10,3,8,5],"y":[117,117,115,124,98,115,127,102,106,129,124,108,104,117,122,122,116,108,107,119,106,114,123,119,112,93,107,108,107,96,114,117,113,120,122,130,122,115,120,119,117,106,107,106,120,116,122,112,107,101,106,111,123,116,118,107,117,96,123,115,107,124,103,115,117,108,117,112,109,105,106,104,101,118,98,115,106,109,105,111,121,116,119,107,113,92,101,98,103,105,112,92,123,88,116,118,98,123,103,120],"text":["age:  6<br />score: 117<br />pet: ferret","age:  7<br />score: 117<br />pet: ferret","age:  5<br />score: 115<br />pet: ferret","age:  2<br />score: 124<br />pet: ferret","age:  7<br />score:  98<br />pet: ferret","age:  4<br />score: 115<br />pet: ferret","age:  4<br />score: 127<br />pet: ferret","age:  6<br />score: 102<br />pet: ferret","age:  8<br />score: 106<br />pet: ferret","age:  9<br />score: 129<br />pet: ferret","age:  5<br />score: 124<br />pet: ferret","age: 11<br />score: 108<br />pet: ferret","age: 12<br />score: 104<br />pet: ferret","age:  8<br />score: 117<br />pet: ferret","age:  5<br />score: 122<br />pet: ferret","age:  2<br />score: 122<br />pet: ferret","age:  9<br />score: 116<br />pet: ferret","age:  7<br />score: 108<br />pet: ferret","age:  9<br />score: 107<br />pet: ferret","age:  7<br />score: 119<br />pet: ferret","age:  8<br />score: 106<br />pet: ferret","age:  6<br />score: 114<br />pet: ferret","age: 11<br />score: 123<br />pet: ferret","age: 12<br />score: 119<br />pet: ferret","age:  4<br />score: 112<br />pet: ferret","age:  9<br />score:  93<br />pet: ferret","age:  6<br />score: 107<br />pet: ferret","age:  7<br />score: 108<br />pet: ferret","age:  6<br />score: 107<br />pet: ferret","age: 11<br />score:  96<br />pet: ferret","age:  6<br />score: 114<br />pet: ferret","age:  5<br />score: 117<br />pet: ferret","age:  5<br />score: 113<br />pet: ferret","age:  7<br />score: 120<br />pet: ferret","age:  6<br />score: 122<br />pet: ferret","age:  3<br />score: 130<br />pet: ferret","age: 10<br />score: 122<br />pet: ferret","age:  8<br />score: 115<br />pet: ferret","age:  9<br />score: 120<br />pet: ferret","age:  7<br />score: 119<br />pet: ferret","age:  4<br />score: 117<br />pet: ferret","age:  6<br />score: 106<br />pet: ferret","age:  3<br />score: 107<br />pet: ferret","age: 10<br />score: 106<br />pet: ferret","age: 15<br />score: 120<br />pet: ferret","age:  3<br />score: 116<br />pet: ferret","age: 10<br />score: 122<br />pet: ferret","age:  8<br />score: 112<br />pet: ferret","age:  9<br />score: 107<br />pet: ferret","age:  5<br />score: 101<br />pet: ferret","age:  9<br />score: 106<br />pet: ferret","age:  9<br />score: 111<br />pet: ferret","age:  7<br />score: 123<br />pet: ferret","age:  4<br />score: 116<br />pet: ferret","age:  5<br />score: 118<br />pet: ferret","age:  3<br />score: 107<br />pet: ferret","age:  6<br />score: 117<br />pet: ferret","age:  4<br />score:  96<br />pet: ferret","age:  4<br />score: 123<br />pet: ferret","age:  8<br />score: 115<br />pet: ferret","age:  8<br />score: 107<br />pet: ferret","age:  6<br />score: 124<br />pet: ferret","age:  3<br />score: 103<br />pet: ferret","age:  5<br />score: 115<br />pet: ferret","age:  6<br />score: 117<br />pet: ferret","age:  5<br />score: 108<br />pet: ferret","age:  9<br />score: 117<br />pet: ferret","age:  6<br />score: 112<br />pet: ferret","age:  3<br />score: 109<br />pet: ferret","age: 13<br />score: 105<br />pet: ferret","age:  4<br />score: 106<br />pet: ferret","age: 11<br />score: 104<br />pet: ferret","age:  7<br />score: 101<br />pet: ferret","age: 11<br />score: 118<br />pet: ferret","age: 10<br />score:  98<br />pet: ferret","age:  8<br />score: 115<br />pet: ferret","age:  8<br />score: 106<br />pet: ferret","age:  3<br />score: 109<br />pet: ferret","age:  9<br />score: 105<br />pet: ferret","age:  9<br />score: 111<br />pet: ferret","age:  7<br />score: 121<br />pet: ferret","age:  7<br />score: 116<br />pet: ferret","age:  4<br />score: 119<br />pet: ferret","age:  8<br />score: 107<br />pet: ferret","age:  9<br />score: 113<br />pet: ferret","age:  5<br />score:  92<br />pet: ferret","age:  1<br />score: 101<br />pet: ferret","age:  7<br />score:  98<br />pet: ferret","age:  3<br />score: 103<br />pet: ferret","age:  9<br />score: 105<br />pet: ferret","age: 10<br />score: 112<br />pet: ferret","age:  7<br />score:  92<br />pet: ferret","age:  5<br />score: 123<br />pet: ferret","age:  8<br />score:  88<br />pet: ferret","age:  1<br />score: 116<br />pet: ferret","age:  7<br />score: 118<br />pet: ferret","age: 10<br />score:  98<br />pet: ferret","age:  3<br />score: 123<br />pet: ferret","age:  8<br />score: 103<br />pet: ferret","age:  5<br />score: 120<br />pet: ferret"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(97,156,255,1)","opacity":1,"size":5.66929133858268,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"ferret","legendgroup":"ferret","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[0,0.20253164556962,0.405063291139241,0.607594936708861,0.810126582278481,1.0126582278481,1.21518987341772,1.41772151898734,1.62025316455696,1.82278481012658,2.0253164556962,2.22784810126582,2.43037974683544,2.63291139240506,2.83544303797468,3.0379746835443,3.24050632911392,3.44303797468354,3.64556962025316,3.84810126582278,4.05063291139241,4.25316455696202,4.45569620253165,4.65822784810127,4.86075949367089,5.06329113924051,5.26582278481013,5.46835443037975,5.67088607594937,5.87341772151899,6.07594936708861,6.27848101265823,6.48101265822785,6.68354430379747,6.88607594936709,7.08860759493671,7.29113924050633,7.49367088607595,7.69620253164557,7.89873417721519,8.10126582278481,8.30379746835443,8.50632911392405,8.70886075949367,8.91139240506329,9.11392405063291,9.31645569620253,9.51898734177215,9.72151898734177,9.92405063291139,10.126582278481,10.3291139240506,10.5316455696203,10.7341772151899,10.9367088607595,11.1392405063291,11.3417721518987,11.5443037974684,11.746835443038,11.9493670886076,12.1518987341772,12.3544303797468,12.5569620253165,12.7594936708861,12.9620253164557,13.1645569620253,13.3670886075949,13.5696202531646,13.7721518987342,13.9746835443038,14.1772151898734,14.379746835443,14.5822784810127,14.7848101265823,14.9873417721519,15.1898734177215,15.3924050632911,15.5949367088608,15.7974683544304,16],"y":[94.1492853820296,94.3127458532213,94.4762063244131,94.6396667956048,94.8031272667966,94.9665877379883,95.13004820918,95.2935086803718,95.4569691515635,95.6204296227553,95.783890093947,95.9473505651387,96.1108110363305,96.2742715075222,96.437731978714,96.6011924499057,96.7646529210975,96.9281133922892,97.0915738634809,97.2550343346727,97.4184948058644,97.5819552770562,97.7454157482479,97.9088762194396,98.0723366906314,98.2357971618231,98.3992576330149,98.5627181042066,98.7261785753984,98.8896390465901,99.0530995177818,99.2165599889736,99.3800204601653,99.5434809313571,99.7069414025488,99.8704018737405,100.033862344932,100.197322816124,100.360783287316,100.524243758507,100.687704229699,100.851164700891,101.014625172083,101.178085643274,101.341546114466,101.505006585658,101.66846705685,101.831927528041,101.995387999233,102.158848470425,102.322308941617,102.485769412808,102.649229884,102.812690355192,102.976150826384,103.139611297575,103.303071768767,103.466532239959,103.629992711151,103.793453182342,103.956913653534,104.120374124726,104.283834595918,104.447295067109,104.610755538301,104.774216009493,104.937676480685,105.101136951876,105.264597423068,105.42805789426,105.591518365451,105.754978836643,105.918439307835,106.081899779027,106.245360250218,106.40882072141,106.572281192602,106.735741663794,106.899202134985,107.062662606177],"text":["age:  0.0000000<br />score:  94.14929<br />pet: dog","age:  0.2025316<br />score:  94.31275<br />pet: dog","age:  0.4050633<br />score:  94.47621<br />pet: dog","age:  0.6075949<br />score:  94.63967<br />pet: dog","age:  0.8101266<br />score:  94.80313<br />pet: dog","age:  1.0126582<br />score:  94.96659<br />pet: dog","age:  1.2151899<br />score:  95.13005<br />pet: dog","age:  1.4177215<br />score:  95.29351<br />pet: dog","age:  1.6202532<br />score:  95.45697<br />pet: dog","age:  1.8227848<br />score:  95.62043<br />pet: dog","age:  2.0253165<br />score:  95.78389<br />pet: dog","age:  2.2278481<br />score:  95.94735<br />pet: dog","age:  2.4303797<br />score:  96.11081<br />pet: dog","age:  2.6329114<br />score:  96.27427<br />pet: dog","age:  2.8354430<br />score:  96.43773<br />pet: dog","age:  3.0379747<br />score:  96.60119<br />pet: dog","age:  3.2405063<br />score:  96.76465<br />pet: dog","age:  3.4430380<br />score:  96.92811<br />pet: dog","age:  3.6455696<br />score:  97.09157<br />pet: dog","age:  3.8481013<br />score:  97.25503<br />pet: dog","age:  4.0506329<br />score:  97.41849<br />pet: dog","age:  4.2531646<br />score:  97.58196<br />pet: dog","age:  4.4556962<br />score:  97.74542<br />pet: dog","age:  4.6582278<br />score:  97.90888<br />pet: dog","age:  4.8607595<br />score:  98.07234<br />pet: dog","age:  5.0632911<br />score:  98.23580<br />pet: dog","age:  5.2658228<br />score:  98.39926<br />pet: dog","age:  5.4683544<br />score:  98.56272<br />pet: dog","age:  5.6708861<br />score:  98.72618<br />pet: dog","age:  5.8734177<br />score:  98.88964<br />pet: dog","age:  6.0759494<br />score:  99.05310<br />pet: dog","age:  6.2784810<br />score:  99.21656<br />pet: dog","age:  6.4810127<br />score:  99.38002<br />pet: dog","age:  6.6835443<br />score:  99.54348<br />pet: dog","age:  6.8860759<br />score:  99.70694<br />pet: dog","age:  7.0886076<br />score:  99.87040<br />pet: dog","age:  7.2911392<br />score: 100.03386<br />pet: dog","age:  7.4936709<br />score: 100.19732<br />pet: dog","age:  7.6962025<br />score: 100.36078<br />pet: dog","age:  7.8987342<br />score: 100.52424<br />pet: dog","age:  8.1012658<br />score: 100.68770<br />pet: dog","age:  8.3037975<br />score: 100.85116<br />pet: dog","age:  8.5063291<br />score: 101.01463<br />pet: dog","age:  8.7088608<br />score: 101.17809<br />pet: dog","age:  8.9113924<br />score: 101.34155<br />pet: dog","age:  9.1139241<br />score: 101.50501<br />pet: dog","age:  9.3164557<br />score: 101.66847<br />pet: dog","age:  9.5189873<br />score: 101.83193<br />pet: dog","age:  9.7215190<br />score: 101.99539<br />pet: dog","age:  9.9240506<br />score: 102.15885<br />pet: dog","age: 10.1265823<br />score: 102.32231<br />pet: dog","age: 10.3291139<br />score: 102.48577<br />pet: dog","age: 10.5316456<br />score: 102.64923<br />pet: dog","age: 10.7341772<br />score: 102.81269<br />pet: dog","age: 10.9367089<br />score: 102.97615<br />pet: dog","age: 11.1392405<br />score: 103.13961<br />pet: dog","age: 11.3417722<br />score: 103.30307<br />pet: dog","age: 11.5443038<br />score: 103.46653<br />pet: dog","age: 11.7468354<br />score: 103.62999<br />pet: dog","age: 11.9493671<br />score: 103.79345<br />pet: dog","age: 12.1518987<br />score: 103.95691<br />pet: dog","age: 12.3544304<br />score: 104.12037<br />pet: dog","age: 12.5569620<br />score: 104.28383<br />pet: dog","age: 12.7594937<br />score: 104.44730<br />pet: dog","age: 12.9620253<br />score: 104.61076<br />pet: dog","age: 13.1645570<br />score: 104.77422<br />pet: dog","age: 13.3670886<br />score: 104.93768<br />pet: dog","age: 13.5696203<br />score: 105.10114<br />pet: dog","age: 13.7721519<br />score: 105.26460<br />pet: dog","age: 13.9746835<br />score: 105.42806<br />pet: dog","age: 14.1772152<br />score: 105.59152<br />pet: dog","age: 14.3797468<br />score: 105.75498<br />pet: dog","age: 14.5822785<br />score: 105.91844<br />pet: dog","age: 14.7848101<br />score: 106.08190<br />pet: dog","age: 14.9873418<br />score: 106.24536<br />pet: dog","age: 15.1898734<br />score: 106.40882<br />pet: dog","age: 15.3924051<br />score: 106.57228<br />pet: dog","age: 15.5949367<br />score: 106.73574<br />pet: dog","age: 15.7974684<br />score: 106.89920<br />pet: dog","age: 16.0000000<br />score: 107.06266<br />pet: dog"],"type":"scatter","mode":"lines","name":"dog","line":{"width":3.77952755905512,"color":"rgba(51,102,255,1)","dash":"solid"},"hoveron":"points","legendgroup":"dog","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[0,0.189873417721519,0.379746835443038,0.569620253164557,0.759493670886076,0.949367088607595,1.13924050632911,1.32911392405063,1.51898734177215,1.70886075949367,1.89873417721519,2.08860759493671,2.27848101265823,2.46835443037975,2.65822784810127,2.84810126582278,3.0379746835443,3.22784810126582,3.41772151898734,3.60759493670886,3.79746835443038,3.9873417721519,4.17721518987342,4.36708860759494,4.55696202531646,4.74683544303798,4.93670886075949,5.12658227848101,5.31645569620253,5.50632911392405,5.69620253164557,5.88607594936709,6.07594936708861,6.26582278481013,6.45569620253165,6.64556962025317,6.83544303797468,7.0253164556962,7.21518987341772,7.40506329113924,7.59493670886076,7.78481012658228,7.9746835443038,8.16455696202532,8.35443037974684,8.54430379746836,8.73417721518987,8.92405063291139,9.11392405063291,9.30379746835443,9.49367088607595,9.68354430379747,9.87341772151899,10.0632911392405,10.253164556962,10.4430379746835,10.6329113924051,10.8227848101266,11.0126582278481,11.2025316455696,11.3924050632911,11.5822784810127,11.7721518987342,11.9620253164557,12.1518987341772,12.3417721518987,12.5316455696203,12.7215189873418,12.9113924050633,13.1012658227848,13.2911392405063,13.4810126582278,13.6708860759494,13.8607594936709,14.0506329113924,14.2405063291139,14.4303797468354,14.620253164557,14.8101265822785,15],"y":[95.3909359538568,95.2507269674075,95.1105179809582,94.970308994509,94.8301000080597,94.6898910216104,94.5496820351612,94.4094730487119,94.2692640622626,94.1290550758134,93.9888460893641,93.8486371029149,93.7084281164656,93.5682191300163,93.4280101435671,93.2878011571178,93.1475921706685,93.0073831842193,92.86717419777,92.7269652113207,92.5867562248715,92.4465472384222,92.3063382519729,92.1661292655237,92.0259202790744,91.8857112926252,91.7455023061759,91.6052933197266,91.4650843332774,91.3248753468281,91.1846663603788,91.0444573739296,90.9042483874803,90.764039401031,90.6238304145818,90.4836214281325,90.3434124416832,90.203203455234,90.0629944687847,89.9227854823355,89.7825764958862,89.6423675094369,89.5021585229877,89.3619495365384,89.2217405500891,89.0815315636399,88.9413225771906,88.8011135907413,88.6609046042921,88.5206956178428,88.3804866313936,88.2402776449443,88.100068658495,87.9598596720458,87.8196506855965,87.6794416991472,87.539232712698,87.3990237262487,87.2588147397994,87.1186057533502,86.9783967669009,86.8381877804516,86.6979787940024,86.5577698075531,86.4175608211038,86.2773518346546,86.1371428482053,85.996933861756,85.8567248753068,85.7165158888575,85.5763069024082,85.436097915959,85.2958889295097,85.1556799430605,85.0154709566112,84.8752619701619,84.7350529837127,84.5948439972634,84.4546350108141,84.3144260243649],"text":["age:  0.0000000<br />score:  95.39094<br />pet: cat","age:  0.1898734<br />score:  95.25073<br />pet: cat","age:  0.3797468<br />score:  95.11052<br />pet: cat","age:  0.5696203<br />score:  94.97031<br />pet: cat","age:  0.7594937<br />score:  94.83010<br />pet: cat","age:  0.9493671<br />score:  94.68989<br />pet: cat","age:  1.1392405<br />score:  94.54968<br />pet: cat","age:  1.3291139<br />score:  94.40947<br />pet: cat","age:  1.5189873<br />score:  94.26926<br />pet: cat","age:  1.7088608<br />score:  94.12906<br />pet: cat","age:  1.8987342<br />score:  93.98885<br />pet: cat","age:  2.0886076<br />score:  93.84864<br />pet: cat","age:  2.2784810<br />score:  93.70843<br />pet: cat","age:  2.4683544<br />score:  93.56822<br />pet: cat","age:  2.6582278<br />score:  93.42801<br />pet: cat","age:  2.8481013<br />score:  93.28780<br />pet: cat","age:  3.0379747<br />score:  93.14759<br />pet: cat","age:  3.2278481<br />score:  93.00738<br />pet: cat","age:  3.4177215<br />score:  92.86717<br />pet: cat","age:  3.6075949<br />score:  92.72697<br />pet: cat","age:  3.7974684<br />score:  92.58676<br />pet: cat","age:  3.9873418<br />score:  92.44655<br />pet: cat","age:  4.1772152<br />score:  92.30634<br />pet: cat","age:  4.3670886<br />score:  92.16613<br />pet: cat","age:  4.5569620<br />score:  92.02592<br />pet: cat","age:  4.7468354<br />score:  91.88571<br />pet: cat","age:  4.9367089<br />score:  91.74550<br />pet: cat","age:  5.1265823<br />score:  91.60529<br />pet: cat","age:  5.3164557<br />score:  91.46508<br />pet: cat","age:  5.5063291<br />score:  91.32488<br />pet: cat","age:  5.6962025<br />score:  91.18467<br />pet: cat","age:  5.8860759<br />score:  91.04446<br />pet: cat","age:  6.0759494<br />score:  90.90425<br />pet: cat","age:  6.2658228<br />score:  90.76404<br />pet: cat","age:  6.4556962<br />score:  90.62383<br />pet: cat","age:  6.6455696<br />score:  90.48362<br />pet: cat","age:  6.8354430<br />score:  90.34341<br />pet: cat","age:  7.0253165<br />score:  90.20320<br />pet: cat","age:  7.2151899<br />score:  90.06299<br />pet: cat","age:  7.4050633<br />score:  89.92279<br />pet: cat","age:  7.5949367<br />score:  89.78258<br />pet: cat","age:  7.7848101<br />score:  89.64237<br />pet: cat","age:  7.9746835<br />score:  89.50216<br />pet: cat","age:  8.1645570<br />score:  89.36195<br />pet: cat","age:  8.3544304<br />score:  89.22174<br />pet: cat","age:  8.5443038<br />score:  89.08153<br />pet: cat","age:  8.7341772<br />score:  88.94132<br />pet: cat","age:  8.9240506<br />score:  88.80111<br />pet: cat","age:  9.1139241<br />score:  88.66090<br />pet: cat","age:  9.3037975<br />score:  88.52070<br />pet: cat","age:  9.4936709<br />score:  88.38049<br />pet: cat","age:  9.6835443<br />score:  88.24028<br />pet: cat","age:  9.8734177<br />score:  88.10007<br />pet: cat","age: 10.0632911<br />score:  87.95986<br />pet: cat","age: 10.2531646<br />score:  87.81965<br />pet: cat","age: 10.4430380<br />score:  87.67944<br />pet: cat","age: 10.6329114<br />score:  87.53923<br />pet: cat","age: 10.8227848<br />score:  87.39902<br />pet: cat","age: 11.0126582<br />score:  87.25881<br />pet: cat","age: 11.2025316<br />score:  87.11861<br />pet: cat","age: 11.3924051<br />score:  86.97840<br />pet: cat","age: 11.5822785<br />score:  86.83819<br />pet: cat","age: 11.7721519<br />score:  86.69798<br />pet: cat","age: 11.9620253<br />score:  86.55777<br />pet: cat","age: 12.1518987<br />score:  86.41756<br />pet: cat","age: 12.3417722<br />score:  86.27735<br />pet: cat","age: 12.5316456<br />score:  86.13714<br />pet: cat","age: 12.7215190<br />score:  85.99693<br />pet: cat","age: 12.9113924<br />score:  85.85672<br />pet: cat","age: 13.1012658<br />score:  85.71652<br />pet: cat","age: 13.2911392<br />score:  85.57631<br />pet: cat","age: 13.4810127<br />score:  85.43610<br />pet: cat","age: 13.6708861<br />score:  85.29589<br />pet: cat","age: 13.8607595<br />score:  85.15568<br />pet: cat","age: 14.0506329<br />score:  85.01547<br />pet: cat","age: 14.2405063<br />score:  84.87526<br />pet: cat","age: 14.4303797<br />score:  84.73505<br />pet: cat","age: 14.6202532<br />score:  84.59484<br />pet: cat","age: 14.8101266<br />score:  84.45464<br />pet: cat","age: 15.0000000<br />score:  84.31443<br />pet: cat"],"type":"scatter","mode":"lines","name":"cat","line":{"width":3.77952755905512,"color":"rgba(51,102,255,1)","dash":"solid"},"hoveron":"points","legendgroup":"cat","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[1,1.17721518987342,1.35443037974684,1.53164556962025,1.70886075949367,1.88607594936709,2.06329113924051,2.24050632911392,2.41772151898734,2.59493670886076,2.77215189873418,2.94936708860759,3.12658227848101,3.30379746835443,3.48101265822785,3.65822784810127,3.83544303797468,4.0126582278481,4.18987341772152,4.36708860759494,4.54430379746835,4.72151898734177,4.89873417721519,5.07594936708861,5.25316455696202,5.43037974683544,5.60759493670886,5.78481012658228,5.9620253164557,6.13924050632911,6.31645569620253,6.49367088607595,6.67088607594937,6.84810126582278,7.0253164556962,7.20253164556962,7.37974683544304,7.55696202531646,7.73417721518987,7.91139240506329,8.08860759493671,8.26582278481013,8.44303797468354,8.62025316455696,8.79746835443038,8.9746835443038,9.15189873417722,9.32911392405063,9.50632911392405,9.68354430379747,9.86075949367089,10.0379746835443,10.2151898734177,10.3924050632911,10.5696202531646,10.746835443038,10.9240506329114,11.1012658227848,11.2784810126582,11.4556962025316,11.6329113924051,11.8101265822785,11.9873417721519,12.1645569620253,12.3417721518987,12.5189873417722,12.6962025316456,12.873417721519,13.0506329113924,13.2278481012658,13.4050632911392,13.5822784810127,13.7594936708861,13.9367088607595,14.1139240506329,14.2911392405063,14.4683544303797,14.6455696202532,14.8227848101266,15],"y":[114.469230871714,114.386921275938,114.304611680162,114.222302084386,114.139992488609,114.057682892833,113.975373297057,113.893063701281,113.810754105505,113.728444509728,113.646134913952,113.563825318176,113.4815157224,113.399206126623,113.316896530847,113.234586935071,113.152277339295,113.069967743519,112.987658147742,112.905348551966,112.82303895619,112.740729360414,112.658419764637,112.576110168861,112.493800573085,112.411490977309,112.329181381533,112.246871785756,112.16456218998,112.082252594204,111.999942998428,111.917633402652,111.835323806875,111.753014211099,111.670704615323,111.588395019547,111.50608542377,111.423775827994,111.341466232218,111.259156636442,111.176847040666,111.094537444889,111.012227849113,110.929918253337,110.847608657561,110.765299061784,110.682989466008,110.600679870232,110.518370274456,110.43606067868,110.353751082903,110.271441487127,110.189131891351,110.106822295575,110.024512699799,109.942203104022,109.859893508246,109.77758391247,109.695274316694,109.612964720917,109.530655125141,109.448345529365,109.366035933589,109.283726337813,109.201416742036,109.11910714626,109.036797550484,108.954487954708,108.872178358931,108.789868763155,108.707559167379,108.625249571603,108.542939975827,108.46063038005,108.378320784274,108.296011188498,108.213701592722,108.131391996946,108.049082401169,107.966772805393],"text":["age:  1.0000000<br />score: 114.46923<br />pet: ferret","age:  1.1772152<br />score: 114.38692<br />pet: ferret","age:  1.3544304<br />score: 114.30461<br />pet: ferret","age:  1.5316456<br />score: 114.22230<br />pet: ferret","age:  1.7088608<br />score: 114.13999<br />pet: ferret","age:  1.8860759<br />score: 114.05768<br />pet: ferret","age:  2.0632911<br />score: 113.97537<br />pet: ferret","age:  2.2405063<br />score: 113.89306<br />pet: ferret","age:  2.4177215<br />score: 113.81075<br />pet: ferret","age:  2.5949367<br />score: 113.72844<br />pet: ferret","age:  2.7721519<br />score: 113.64613<br />pet: ferret","age:  2.9493671<br />score: 113.56383<br />pet: ferret","age:  3.1265823<br />score: 113.48152<br />pet: ferret","age:  3.3037975<br />score: 113.39921<br />pet: ferret","age:  3.4810127<br />score: 113.31690<br />pet: ferret","age:  3.6582278<br />score: 113.23459<br />pet: ferret","age:  3.8354430<br />score: 113.15228<br />pet: ferret","age:  4.0126582<br />score: 113.06997<br />pet: ferret","age:  4.1898734<br />score: 112.98766<br />pet: ferret","age:  4.3670886<br />score: 112.90535<br />pet: ferret","age:  4.5443038<br />score: 112.82304<br />pet: ferret","age:  4.7215190<br />score: 112.74073<br />pet: ferret","age:  4.8987342<br />score: 112.65842<br />pet: ferret","age:  5.0759494<br />score: 112.57611<br />pet: ferret","age:  5.2531646<br />score: 112.49380<br />pet: ferret","age:  5.4303797<br />score: 112.41149<br />pet: ferret","age:  5.6075949<br />score: 112.32918<br />pet: ferret","age:  5.7848101<br />score: 112.24687<br />pet: ferret","age:  5.9620253<br />score: 112.16456<br />pet: ferret","age:  6.1392405<br />score: 112.08225<br />pet: ferret","age:  6.3164557<br />score: 111.99994<br />pet: ferret","age:  6.4936709<br />score: 111.91763<br />pet: ferret","age:  6.6708861<br />score: 111.83532<br />pet: ferret","age:  6.8481013<br />score: 111.75301<br />pet: ferret","age:  7.0253165<br />score: 111.67070<br />pet: ferret","age:  7.2025316<br />score: 111.58840<br />pet: ferret","age:  7.3797468<br />score: 111.50609<br />pet: ferret","age:  7.5569620<br />score: 111.42378<br />pet: ferret","age:  7.7341772<br />score: 111.34147<br />pet: ferret","age:  7.9113924<br />score: 111.25916<br />pet: ferret","age:  8.0886076<br />score: 111.17685<br />pet: ferret","age:  8.2658228<br />score: 111.09454<br />pet: ferret","age:  8.4430380<br />score: 111.01223<br />pet: ferret","age:  8.6202532<br />score: 110.92992<br />pet: ferret","age:  8.7974684<br />score: 110.84761<br />pet: ferret","age:  8.9746835<br />score: 110.76530<br />pet: ferret","age:  9.1518987<br />score: 110.68299<br />pet: ferret","age:  9.3291139<br />score: 110.60068<br />pet: ferret","age:  9.5063291<br />score: 110.51837<br />pet: ferret","age:  9.6835443<br />score: 110.43606<br />pet: ferret","age:  9.8607595<br />score: 110.35375<br />pet: ferret","age: 10.0379747<br />score: 110.27144<br />pet: ferret","age: 10.2151899<br />score: 110.18913<br />pet: ferret","age: 10.3924051<br />score: 110.10682<br />pet: ferret","age: 10.5696203<br />score: 110.02451<br />pet: ferret","age: 10.7468354<br />score: 109.94220<br />pet: ferret","age: 10.9240506<br />score: 109.85989<br />pet: ferret","age: 11.1012658<br />score: 109.77758<br />pet: ferret","age: 11.2784810<br />score: 109.69527<br />pet: ferret","age: 11.4556962<br />score: 109.61296<br />pet: ferret","age: 11.6329114<br />score: 109.53066<br />pet: ferret","age: 11.8101266<br />score: 109.44835<br />pet: ferret","age: 11.9873418<br />score: 109.36604<br />pet: ferret","age: 12.1645570<br />score: 109.28373<br />pet: ferret","age: 12.3417722<br />score: 109.20142<br />pet: ferret","age: 12.5189873<br />score: 109.11911<br />pet: ferret","age: 12.6962025<br />score: 109.03680<br />pet: ferret","age: 12.8734177<br />score: 108.95449<br />pet: ferret","age: 13.0506329<br />score: 108.87218<br />pet: ferret","age: 13.2278481<br />score: 108.78987<br />pet: ferret","age: 13.4050633<br />score: 108.70756<br />pet: ferret","age: 13.5822785<br />score: 108.62525<br />pet: ferret","age: 13.7594937<br />score: 108.54294<br />pet: ferret","age: 13.9367089<br />score: 108.46063<br />pet: ferret","age: 14.1139241<br />score: 108.37832<br />pet: ferret","age: 14.2911392<br />score: 108.29601<br />pet: ferret","age: 14.4683544<br />score: 108.21370<br />pet: ferret","age: 14.6455696<br />score: 108.13139<br />pet: ferret","age: 14.8227848<br />score: 108.04908<br />pet: ferret","age: 15.0000000<br />score: 107.96677<br />pet: ferret"],"type":"scatter","mode":"lines","name":"ferret","line":{"width":3.77952755905512,"color":"rgba(51,102,255,1)","dash":"solid"},"hoveron":"points","legendgroup":"ferret","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[0,0.20253164556962,0.405063291139241,0.607594936708861,0.810126582278481,1.0126582278481,1.21518987341772,1.41772151898734,1.62025316455696,1.82278481012658,2.0253164556962,2.22784810126582,2.43037974683544,2.63291139240506,2.83544303797468,3.0379746835443,3.24050632911392,3.44303797468354,3.64556962025316,3.84810126582278,4.05063291139241,4.25316455696202,4.45569620253165,4.65822784810127,4.86075949367089,5.06329113924051,5.26582278481013,5.46835443037975,5.67088607594937,5.87341772151899,6.07594936708861,6.27848101265823,6.48101265822785,6.68354430379747,6.88607594936709,7.08860759493671,7.29113924050633,7.49367088607595,7.69620253164557,7.89873417721519,8.10126582278481,8.30379746835443,8.50632911392405,8.70886075949367,8.91139240506329,9.11392405063291,9.31645569620253,9.51898734177215,9.72151898734177,9.92405063291139,10.126582278481,10.3291139240506,10.5316455696203,10.7341772151899,10.9367088607595,11.1392405063291,11.3417721518987,11.5443037974684,11.746835443038,11.9493670886076,12.1518987341772,12.3544303797468,12.5569620253165,12.7594936708861,12.9620253164557,13.1645569620253,13.3670886075949,13.5696202531646,13.7721518987342,13.9746835443038,14.1772151898734,14.379746835443,14.5822784810127,14.7848101265823,14.9873417721519,15.1898734177215,15.3924050632911,15.5949367088608,15.7974683544304,16,16,16,15.7974683544304,15.5949367088608,15.3924050632911,15.1898734177215,14.9873417721519,14.7848101265823,14.5822784810127,14.379746835443,14.1772151898734,13.9746835443038,13.7721518987342,13.5696202531646,13.3670886075949,13.1645569620253,12.9620253164557,12.7594936708861,12.5569620253165,12.3544303797468,12.1518987341772,11.9493670886076,11.746835443038,11.5443037974684,11.3417721518987,11.1392405063291,10.9367088607595,10.7341772151899,10.5316455696203,10.3291139240506,10.126582278481,9.92405063291139,9.72151898734177,9.51898734177215,9.31645569620253,9.11392405063291,8.91139240506329,8.70886075949367,8.50632911392405,8.30379746835443,8.10126582278481,7.89873417721519,7.69620253164557,7.49367088607595,7.29113924050633,7.08860759493671,6.88607594936709,6.68354430379747,6.48101265822785,6.27848101265823,6.07594936708861,5.87341772151899,5.67088607594937,5.46835443037975,5.26582278481013,5.06329113924051,4.86075949367089,4.65822784810127,4.45569620253165,4.25316455696202,4.05063291139241,3.84810126582278,3.64556962025316,3.44303797468354,3.24050632911392,3.0379746835443,2.83544303797468,2.63291139240506,2.43037974683544,2.22784810126582,2.0253164556962,1.82278481012658,1.62025316455696,1.41772151898734,1.21518987341772,1.0126582278481,0.810126582278481,0.607594936708861,0.405063291139241,0.20253164556962,0,0],"y":[91.6713274276087,91.8938804287467,92.1161706896138,92.3381780619178,92.5598803960718,92.7812533030088,93.0022698841752,93.2229004252989,93.4431120489979,93.6628683207537,93.88212880225,94.1008485456267,94.3189775218851,94.5364599766364,94.7532337067552,94.9692292525428,95.1843690020424,95.3985662076415,95.6117239206605,95.8237338580326,96.0344752274057,96.2438135541261,96.4515995767235,96.6576683075752,96.8618383925373,97.0639119461866,97.2636750840433,97.4608994120469,97.6553447539215,97.846763380939,98.0349059346366,98.2195290819945,98.4004047068481,98.577330137337,98.7501385872383,98.9187087320456,99.0829722448289,99.24291825465,99.398594070263,99.5501020594589,99.6975931509811,99.8412578811607,99.9813161385222,100.118006744748,100.251577802393,100.382278430889,100.510352193953,100.636032256802,100.759538128963,100.881073747759,101.000826622445,101.118967768148,101.235652192549,101.351019741936,101.465196157472,101.578294231981,101.690414990314,101.801648841992,101.912076674051,102.021770865959,102.130796218152,102.239210792265,102.347066665333,102.454410602708,102.561284655872,102.667726691846,102.773770861033,102.879448010076,102.984786045905,103.089810256663,103.194543594626,103.299006925732,103.403219249797,103.507197895023,103.61095868998,103.714516115831,103.817883441247,103.921072842129,104.024095507989,104.126961736622,104.126961736622,109.998363475732,109.774308761982,109.550410485458,109.326678943957,109.10312532699,108.879761810457,108.65660166303,108.433659365873,108.210950747554,107.988493136277,107.766305531856,107.544408800231,107.322825893677,107.101582100336,106.88070532714,106.66022642073,106.440179531511,106.220602526502,106.001537457186,105.783031088917,105.565135498725,105.34790874825,105.131415637926,104.91572854722,104.70092836317,104.487105495295,104.274360968448,104.062807575452,103.852571057468,103.643791260788,103.436623193091,103.231237869504,103.027822799281,102.826581919746,102.627734740427,102.43151442654,102.2381645418,102.047934205643,101.861071520621,101.677815308417,101.498385457556,101.322972504369,101.151727377598,100.984752445036,100.822095015435,100.663744217859,100.509631725377,100.359636213483,100.213590895953,100.071293100927,99.9325147122412,99.7970123968752,99.6645367963663,99.5348401819865,99.4076823774597,99.2828349887254,99.1600841313041,99.0392319197723,98.9200969999863,98.8025143843231,98.6863348113128,98.5714238063014,98.4576605769369,98.3449368401525,98.2331556472686,98.1222302506727,98.0120830384081,97.9026445507759,97.7938525846508,97.685651385644,97.5779909247569,97.4708262541291,97.3641169354447,97.2578265341849,97.1519221729678,97.0463741375214,96.9411555292919,96.8362419592124,96.731611277696,96.6272433364505,91.6713274276087],"text":["age:  0.0000000<br />score:  94.14929<br />pet: dog","age:  0.2025316<br />score:  94.31275<br />pet: dog","age:  0.4050633<br />score:  94.47621<br />pet: dog","age:  0.6075949<br />score:  94.63967<br />pet: dog","age:  0.8101266<br />score:  94.80313<br />pet: dog","age:  1.0126582<br />score:  94.96659<br />pet: dog","age:  1.2151899<br />score:  95.13005<br />pet: dog","age:  1.4177215<br />score:  95.29351<br />pet: dog","age:  1.6202532<br />score:  95.45697<br />pet: dog","age:  1.8227848<br />score:  95.62043<br />pet: dog","age:  2.0253165<br />score:  95.78389<br />pet: dog","age:  2.2278481<br />score:  95.94735<br />pet: dog","age:  2.4303797<br />score:  96.11081<br />pet: dog","age:  2.6329114<br />score:  96.27427<br />pet: dog","age:  2.8354430<br />score:  96.43773<br />pet: dog","age:  3.0379747<br />score:  96.60119<br />pet: dog","age:  3.2405063<br />score:  96.76465<br />pet: dog","age:  3.4430380<br />score:  96.92811<br />pet: dog","age:  3.6455696<br />score:  97.09157<br />pet: dog","age:  3.8481013<br />score:  97.25503<br />pet: dog","age:  4.0506329<br />score:  97.41849<br />pet: dog","age:  4.2531646<br />score:  97.58196<br />pet: dog","age:  4.4556962<br />score:  97.74542<br />pet: dog","age:  4.6582278<br />score:  97.90888<br />pet: dog","age:  4.8607595<br />score:  98.07234<br />pet: dog","age:  5.0632911<br />score:  98.23580<br />pet: dog","age:  5.2658228<br />score:  98.39926<br />pet: dog","age:  5.4683544<br />score:  98.56272<br />pet: dog","age:  5.6708861<br />score:  98.72618<br />pet: dog","age:  5.8734177<br />score:  98.88964<br />pet: dog","age:  6.0759494<br />score:  99.05310<br />pet: dog","age:  6.2784810<br />score:  99.21656<br />pet: dog","age:  6.4810127<br />score:  99.38002<br />pet: dog","age:  6.6835443<br />score:  99.54348<br />pet: dog","age:  6.8860759<br />score:  99.70694<br />pet: dog","age:  7.0886076<br />score:  99.87040<br />pet: dog","age:  7.2911392<br />score: 100.03386<br />pet: dog","age:  7.4936709<br />score: 100.19732<br />pet: dog","age:  7.6962025<br />score: 100.36078<br />pet: dog","age:  7.8987342<br />score: 100.52424<br />pet: dog","age:  8.1012658<br />score: 100.68770<br />pet: dog","age:  8.3037975<br />score: 100.85116<br />pet: dog","age:  8.5063291<br />score: 101.01463<br />pet: dog","age:  8.7088608<br />score: 101.17809<br />pet: dog","age:  8.9113924<br />score: 101.34155<br />pet: dog","age:  9.1139241<br />score: 101.50501<br />pet: dog","age:  9.3164557<br />score: 101.66847<br />pet: dog","age:  9.5189873<br />score: 101.83193<br />pet: dog","age:  9.7215190<br />score: 101.99539<br />pet: dog","age:  9.9240506<br />score: 102.15885<br />pet: dog","age: 10.1265823<br />score: 102.32231<br />pet: dog","age: 10.3291139<br />score: 102.48577<br />pet: dog","age: 10.5316456<br />score: 102.64923<br />pet: dog","age: 10.7341772<br />score: 102.81269<br />pet: dog","age: 10.9367089<br />score: 102.97615<br />pet: dog","age: 11.1392405<br />score: 103.13961<br />pet: dog","age: 11.3417722<br />score: 103.30307<br />pet: dog","age: 11.5443038<br />score: 103.46653<br />pet: dog","age: 11.7468354<br />score: 103.62999<br />pet: dog","age: 11.9493671<br />score: 103.79345<br />pet: dog","age: 12.1518987<br />score: 103.95691<br />pet: dog","age: 12.3544304<br />score: 104.12037<br />pet: dog","age: 12.5569620<br />score: 104.28383<br />pet: dog","age: 12.7594937<br />score: 104.44730<br />pet: dog","age: 12.9620253<br />score: 104.61076<br />pet: dog","age: 13.1645570<br />score: 104.77422<br />pet: dog","age: 13.3670886<br />score: 104.93768<br />pet: dog","age: 13.5696203<br />score: 105.10114<br />pet: dog","age: 13.7721519<br />score: 105.26460<br />pet: dog","age: 13.9746835<br />score: 105.42806<br />pet: dog","age: 14.1772152<br />score: 105.59152<br />pet: dog","age: 14.3797468<br />score: 105.75498<br />pet: dog","age: 14.5822785<br />score: 105.91844<br />pet: dog","age: 14.7848101<br />score: 106.08190<br />pet: dog","age: 14.9873418<br />score: 106.24536<br />pet: dog","age: 15.1898734<br />score: 106.40882<br />pet: dog","age: 15.3924051<br />score: 106.57228<br />pet: dog","age: 15.5949367<br />score: 106.73574<br />pet: dog","age: 15.7974684<br />score: 106.89920<br />pet: dog","age: 16.0000000<br />score: 107.06266<br />pet: dog","age: 16.0000000<br />score: 107.06266<br />pet: dog","age: 16.0000000<br />score: 107.06266<br />pet: dog","age: 15.7974684<br />score: 106.89920<br />pet: dog","age: 15.5949367<br />score: 106.73574<br />pet: dog","age: 15.3924051<br />score: 106.57228<br />pet: dog","age: 15.1898734<br />score: 106.40882<br />pet: dog","age: 14.9873418<br />score: 106.24536<br />pet: dog","age: 14.7848101<br />score: 106.08190<br />pet: dog","age: 14.5822785<br />score: 105.91844<br />pet: dog","age: 14.3797468<br />score: 105.75498<br />pet: dog","age: 14.1772152<br />score: 105.59152<br />pet: dog","age: 13.9746835<br />score: 105.42806<br />pet: dog","age: 13.7721519<br />score: 105.26460<br />pet: dog","age: 13.5696203<br />score: 105.10114<br />pet: dog","age: 13.3670886<br />score: 104.93768<br />pet: dog","age: 13.1645570<br />score: 104.77422<br />pet: dog","age: 12.9620253<br />score: 104.61076<br />pet: dog","age: 12.7594937<br />score: 104.44730<br />pet: dog","age: 12.5569620<br />score: 104.28383<br />pet: dog","age: 12.3544304<br />score: 104.12037<br />pet: dog","age: 12.1518987<br />score: 103.95691<br />pet: dog","age: 11.9493671<br />score: 103.79345<br />pet: dog","age: 11.7468354<br />score: 103.62999<br />pet: dog","age: 11.5443038<br />score: 103.46653<br />pet: dog","age: 11.3417722<br />score: 103.30307<br />pet: dog","age: 11.1392405<br />score: 103.13961<br />pet: dog","age: 10.9367089<br />score: 102.97615<br />pet: dog","age: 10.7341772<br />score: 102.81269<br />pet: dog","age: 10.5316456<br />score: 102.64923<br />pet: dog","age: 10.3291139<br />score: 102.48577<br />pet: dog","age: 10.1265823<br />score: 102.32231<br />pet: dog","age:  9.9240506<br />score: 102.15885<br />pet: dog","age:  9.7215190<br />score: 101.99539<br />pet: dog","age:  9.5189873<br />score: 101.83193<br />pet: dog","age:  9.3164557<br />score: 101.66847<br />pet: dog","age:  9.1139241<br />score: 101.50501<br />pet: dog","age:  8.9113924<br />score: 101.34155<br />pet: dog","age:  8.7088608<br />score: 101.17809<br />pet: dog","age:  8.5063291<br />score: 101.01463<br />pet: dog","age:  8.3037975<br />score: 100.85116<br />pet: dog","age:  8.1012658<br />score: 100.68770<br />pet: dog","age:  7.8987342<br />score: 100.52424<br />pet: dog","age:  7.6962025<br />score: 100.36078<br />pet: dog","age:  7.4936709<br />score: 100.19732<br />pet: dog","age:  7.2911392<br />score: 100.03386<br />pet: dog","age:  7.0886076<br />score:  99.87040<br />pet: dog","age:  6.8860759<br />score:  99.70694<br />pet: dog","age:  6.6835443<br />score:  99.54348<br />pet: dog","age:  6.4810127<br />score:  99.38002<br />pet: dog","age:  6.2784810<br />score:  99.21656<br />pet: dog","age:  6.0759494<br />score:  99.05310<br />pet: dog","age:  5.8734177<br />score:  98.88964<br />pet: dog","age:  5.6708861<br />score:  98.72618<br />pet: dog","age:  5.4683544<br />score:  98.56272<br />pet: dog","age:  5.2658228<br />score:  98.39926<br />pet: dog","age:  5.0632911<br />score:  98.23580<br />pet: dog","age:  4.8607595<br />score:  98.07234<br />pet: dog","age:  4.6582278<br />score:  97.90888<br />pet: dog","age:  4.4556962<br />score:  97.74542<br />pet: dog","age:  4.2531646<br />score:  97.58196<br />pet: dog","age:  4.0506329<br />score:  97.41849<br />pet: dog","age:  3.8481013<br />score:  97.25503<br />pet: dog","age:  3.6455696<br />score:  97.09157<br />pet: dog","age:  3.4430380<br />score:  96.92811<br />pet: dog","age:  3.2405063<br />score:  96.76465<br />pet: dog","age:  3.0379747<br />score:  96.60119<br />pet: dog","age:  2.8354430<br />score:  96.43773<br />pet: dog","age:  2.6329114<br />score:  96.27427<br />pet: dog","age:  2.4303797<br />score:  96.11081<br />pet: dog","age:  2.2278481<br />score:  95.94735<br />pet: dog","age:  2.0253165<br />score:  95.78389<br />pet: dog","age:  1.8227848<br />score:  95.62043<br />pet: dog","age:  1.6202532<br />score:  95.45697<br />pet: dog","age:  1.4177215<br />score:  95.29351<br />pet: dog","age:  1.2151899<br />score:  95.13005<br />pet: dog","age:  1.0126582<br />score:  94.96659<br />pet: dog","age:  0.8101266<br />score:  94.80313<br />pet: dog","age:  0.6075949<br />score:  94.63967<br />pet: dog","age:  0.4050633<br />score:  94.47621<br />pet: dog","age:  0.2025316<br />score:  94.31275<br />pet: dog","age:  0.0000000<br />score:  94.14929<br />pet: dog","age:  0.0000000<br />score:  94.14929<br />pet: dog"],"type":"scatter","mode":"lines","line":{"width":3.77952755905512,"color":"transparent","dash":"solid"},"fill":"toself","fillcolor":"rgba(248,118,109,0.4)","hoveron":"points","hoverinfo":"x+y","name":"dog","legendgroup":"dog","showlegend":false,"xaxis":"x","yaxis":"y","frame":null},{"x":[0,0.189873417721519,0.379746835443038,0.569620253164557,0.759493670886076,0.949367088607595,1.13924050632911,1.32911392405063,1.51898734177215,1.70886075949367,1.89873417721519,2.08860759493671,2.27848101265823,2.46835443037975,2.65822784810127,2.84810126582278,3.0379746835443,3.22784810126582,3.41772151898734,3.60759493670886,3.79746835443038,3.9873417721519,4.17721518987342,4.36708860759494,4.55696202531646,4.74683544303798,4.93670886075949,5.12658227848101,5.31645569620253,5.50632911392405,5.69620253164557,5.88607594936709,6.07594936708861,6.26582278481013,6.45569620253165,6.64556962025317,6.83544303797468,7.0253164556962,7.21518987341772,7.40506329113924,7.59493670886076,7.78481012658228,7.9746835443038,8.16455696202532,8.35443037974684,8.54430379746836,8.73417721518987,8.92405063291139,9.11392405063291,9.30379746835443,9.49367088607595,9.68354430379747,9.87341772151899,10.0632911392405,10.253164556962,10.4430379746835,10.6329113924051,10.8227848101266,11.0126582278481,11.2025316455696,11.3924050632911,11.5822784810127,11.7721518987342,11.9620253164557,12.1518987341772,12.3417721518987,12.5316455696203,12.7215189873418,12.9113924050633,13.1012658227848,13.2911392405063,13.4810126582278,13.6708860759494,13.8607594936709,14.0506329113924,14.2405063291139,14.4303797468354,14.620253164557,14.8101265822785,15,15,14.8101265822785,14.620253164557,14.4303797468354,14.2405063291139,14.0506329113924,13.8607594936709,13.6708860759494,13.4810126582278,13.2911392405063,13.1012658227848,12.9113924050633,12.7215189873418,12.5316455696203,12.3417721518987,12.1518987341772,11.9620253164557,11.7721518987342,11.5822784810127,11.3924050632911,11.2025316455696,11.0126582278481,10.8227848101266,10.6329113924051,10.4430379746835,10.253164556962,10.0632911392405,9.87341772151899,9.68354430379747,9.49367088607595,9.30379746835443,9.11392405063291,8.92405063291139,8.73417721518987,8.54430379746836,8.35443037974684,8.16455696202532,7.9746835443038,7.78481012658228,7.59493670886076,7.40506329113924,7.21518987341772,7.0253164556962,6.83544303797468,6.64556962025317,6.45569620253165,6.26582278481013,6.07594936708861,5.88607594936709,5.69620253164557,5.50632911392405,5.31645569620253,5.12658227848101,4.93670886075949,4.74683544303798,4.55696202531646,4.36708860759494,4.17721518987342,3.9873417721519,3.79746835443038,3.60759493670886,3.41772151898734,3.22784810126582,3.0379746835443,2.84810126582278,2.65822784810127,2.46835443037975,2.27848101265823,2.08860759493671,1.89873417721519,1.70886075949367,1.51898734177215,1.32911392405063,1.13924050632911,0.949367088607595,0.759493670886076,0.569620253164557,0.379746835443038,0.189873417721519,0,0],"y":[92.3685778015054,92.2982848921995,92.2276895564643,92.1567693459667,92.0854996557304,92.0138534760348,91.9418011122866,91.869309868581,91.7963436901661,91.7228627595166,91.6488230402216,91.5741757624501,91.4988668434394,91.4228362363391,91.3460172009886,91.2683354909953,91.189708453083,91.1100440374764,91.0292397225568,90.9471813638187,90.8637419870549,90.7787805596431,90.6921407927968,90.6036500526017,90.5131184891318,90.4203385305843,90.3250849312304,90.227115603465,90.126173497041,90.0219897998902,89.9142887075977,89.802793923477,89.687236892493,89.5673665364141,89.4429599635469,89.31383332314,89.1798517383789,89.040937168532,88.8970731835465,88.7483059904852,88.5947415656793,88.4365392972524,88.2739029940286,88.1070703699353,87.9363021375746,87.7618716782152,87.5840559765303,87.4031282014848,87.219352044335,87.0329777249273,86.844239455344,86.6533540947448,86.4605207227296,86.2659208820049,86.069719279405,85.8720647767585,85.6730915433249,85.4729202763499,85.2716594246232,85.0694063719352,84.8662485537805,84.6622644925525,84.4575247447763,84.2520927595252,84.046025650766,83.8393748885507,83.6321869151485,83.4245036927104,83.2163631891142,83.0077998084148,82.7988447719334,82.5895264555469,82.3798706882292,82.1699010163871,81.9596389380456,81.7491041104799,81.5383145344724,81.3272867179969,81.1160358217887,80.9045757889625,87.7242762597673,87.7932341998396,87.8624012765299,87.9317914329529,88.001419829844,88.0713029751768,88.1414588697339,88.2119071707903,88.2826693763711,88.3537690328831,88.4252319693003,88.4970865614994,88.5693640308017,88.6420987812621,88.7153287807585,88.7890959914417,88.863446855581,88.9384328432284,89.0141110683508,89.0905449800213,89.1678051347652,89.2459700549756,89.3251271761475,89.405373882071,89.4868186215359,89.569582091788,89.6537984620866,89.7396165942604,89.8272011951437,89.9167338074432,90.0084135107583,90.1024571642492,90.1990989799978,90.2985891778509,90.4011914490646,90.5071789626037,90.6168287031415,90.7304140519467,90.8481957216215,90.9704114260931,91.0972649741857,91.2289157540229,91.365469741936,91.5069731449876,91.653409533125,91.8047008656167,91.960712265648,92.1212598824676,92.2861208243821,92.45504401316,92.627760893766,92.8039951695137,92.9834710359883,93.1659196811214,93.3510840546661,93.538722069017,93.7286084784457,93.9205357111491,94.1143139172013,94.3097704626881,94.5067490588228,94.7051086729832,94.9047223309622,95.1054758882541,95.3072668232403,95.5100030861455,95.7136020236936,95.9179893894918,96.1230984433797,96.3288691385067,96.5352473921101,96.7421844343592,96.9496362288428,97.1575629580357,97.3659285671861,97.574700360389,97.7838486430513,97.9933464054522,98.2031690426155,98.4132941062082,92.3685778015054],"text":["age:  0.0000000<br />score:  95.39094<br />pet: cat","age:  0.1898734<br />score:  95.25073<br />pet: cat","age:  0.3797468<br />score:  95.11052<br />pet: cat","age:  0.5696203<br />score:  94.97031<br />pet: cat","age:  0.7594937<br />score:  94.83010<br />pet: cat","age:  0.9493671<br />score:  94.68989<br />pet: cat","age:  1.1392405<br />score:  94.54968<br />pet: cat","age:  1.3291139<br />score:  94.40947<br />pet: cat","age:  1.5189873<br />score:  94.26926<br />pet: cat","age:  1.7088608<br />score:  94.12906<br />pet: cat","age:  1.8987342<br />score:  93.98885<br />pet: cat","age:  2.0886076<br />score:  93.84864<br />pet: cat","age:  2.2784810<br />score:  93.70843<br />pet: cat","age:  2.4683544<br />score:  93.56822<br />pet: cat","age:  2.6582278<br />score:  93.42801<br />pet: cat","age:  2.8481013<br />score:  93.28780<br />pet: cat","age:  3.0379747<br />score:  93.14759<br />pet: cat","age:  3.2278481<br />score:  93.00738<br />pet: cat","age:  3.4177215<br />score:  92.86717<br />pet: cat","age:  3.6075949<br />score:  92.72697<br />pet: cat","age:  3.7974684<br />score:  92.58676<br />pet: cat","age:  3.9873418<br />score:  92.44655<br />pet: cat","age:  4.1772152<br />score:  92.30634<br />pet: cat","age:  4.3670886<br />score:  92.16613<br />pet: cat","age:  4.5569620<br />score:  92.02592<br />pet: cat","age:  4.7468354<br />score:  91.88571<br />pet: cat","age:  4.9367089<br />score:  91.74550<br />pet: cat","age:  5.1265823<br />score:  91.60529<br />pet: cat","age:  5.3164557<br />score:  91.46508<br />pet: cat","age:  5.5063291<br />score:  91.32488<br />pet: cat","age:  5.6962025<br />score:  91.18467<br />pet: cat","age:  5.8860759<br />score:  91.04446<br />pet: cat","age:  6.0759494<br />score:  90.90425<br />pet: cat","age:  6.2658228<br />score:  90.76404<br />pet: cat","age:  6.4556962<br />score:  90.62383<br />pet: cat","age:  6.6455696<br />score:  90.48362<br />pet: cat","age:  6.8354430<br />score:  90.34341<br />pet: cat","age:  7.0253165<br />score:  90.20320<br />pet: cat","age:  7.2151899<br />score:  90.06299<br />pet: cat","age:  7.4050633<br />score:  89.92279<br />pet: cat","age:  7.5949367<br />score:  89.78258<br />pet: cat","age:  7.7848101<br />score:  89.64237<br />pet: cat","age:  7.9746835<br />score:  89.50216<br />pet: cat","age:  8.1645570<br />score:  89.36195<br />pet: cat","age:  8.3544304<br />score:  89.22174<br />pet: cat","age:  8.5443038<br />score:  89.08153<br />pet: cat","age:  8.7341772<br />score:  88.94132<br />pet: cat","age:  8.9240506<br />score:  88.80111<br />pet: cat","age:  9.1139241<br />score:  88.66090<br />pet: cat","age:  9.3037975<br />score:  88.52070<br />pet: cat","age:  9.4936709<br />score:  88.38049<br />pet: cat","age:  9.6835443<br />score:  88.24028<br />pet: cat","age:  9.8734177<br />score:  88.10007<br />pet: cat","age: 10.0632911<br />score:  87.95986<br />pet: cat","age: 10.2531646<br />score:  87.81965<br />pet: cat","age: 10.4430380<br />score:  87.67944<br />pet: cat","age: 10.6329114<br />score:  87.53923<br />pet: cat","age: 10.8227848<br />score:  87.39902<br />pet: cat","age: 11.0126582<br />score:  87.25881<br />pet: cat","age: 11.2025316<br />score:  87.11861<br />pet: cat","age: 11.3924051<br />score:  86.97840<br />pet: cat","age: 11.5822785<br />score:  86.83819<br />pet: cat","age: 11.7721519<br />score:  86.69798<br />pet: cat","age: 11.9620253<br />score:  86.55777<br />pet: cat","age: 12.1518987<br />score:  86.41756<br />pet: cat","age: 12.3417722<br />score:  86.27735<br />pet: cat","age: 12.5316456<br />score:  86.13714<br />pet: cat","age: 12.7215190<br />score:  85.99693<br />pet: cat","age: 12.9113924<br />score:  85.85672<br />pet: cat","age: 13.1012658<br />score:  85.71652<br />pet: cat","age: 13.2911392<br />score:  85.57631<br />pet: cat","age: 13.4810127<br />score:  85.43610<br />pet: cat","age: 13.6708861<br />score:  85.29589<br />pet: cat","age: 13.8607595<br />score:  85.15568<br />pet: cat","age: 14.0506329<br />score:  85.01547<br />pet: cat","age: 14.2405063<br />score:  84.87526<br />pet: cat","age: 14.4303797<br />score:  84.73505<br />pet: cat","age: 14.6202532<br />score:  84.59484<br />pet: cat","age: 14.8101266<br />score:  84.45464<br />pet: cat","age: 15.0000000<br />score:  84.31443<br />pet: cat","age: 15.0000000<br />score:  84.31443<br />pet: cat","age: 14.8101266<br />score:  84.45464<br />pet: cat","age: 14.6202532<br />score:  84.59484<br />pet: cat","age: 14.4303797<br />score:  84.73505<br />pet: cat","age: 14.2405063<br />score:  84.87526<br />pet: cat","age: 14.0506329<br />score:  85.01547<br />pet: cat","age: 13.8607595<br />score:  85.15568<br />pet: cat","age: 13.6708861<br />score:  85.29589<br />pet: cat","age: 13.4810127<br />score:  85.43610<br />pet: cat","age: 13.2911392<br />score:  85.57631<br />pet: cat","age: 13.1012658<br />score:  85.71652<br />pet: cat","age: 12.9113924<br />score:  85.85672<br />pet: cat","age: 12.7215190<br />score:  85.99693<br />pet: cat","age: 12.5316456<br />score:  86.13714<br />pet: cat","age: 12.3417722<br />score:  86.27735<br />pet: cat","age: 12.1518987<br />score:  86.41756<br />pet: cat","age: 11.9620253<br />score:  86.55777<br />pet: cat","age: 11.7721519<br />score:  86.69798<br />pet: cat","age: 11.5822785<br />score:  86.83819<br />pet: cat","age: 11.3924051<br />score:  86.97840<br />pet: cat","age: 11.2025316<br />score:  87.11861<br />pet: cat","age: 11.0126582<br />score:  87.25881<br />pet: cat","age: 10.8227848<br />score:  87.39902<br />pet: cat","age: 10.6329114<br />score:  87.53923<br />pet: cat","age: 10.4430380<br />score:  87.67944<br />pet: cat","age: 10.2531646<br />score:  87.81965<br />pet: cat","age: 10.0632911<br />score:  87.95986<br />pet: cat","age:  9.8734177<br />score:  88.10007<br />pet: cat","age:  9.6835443<br />score:  88.24028<br />pet: cat","age:  9.4936709<br />score:  88.38049<br />pet: cat","age:  9.3037975<br />score:  88.52070<br />pet: cat","age:  9.1139241<br />score:  88.66090<br />pet: cat","age:  8.9240506<br />score:  88.80111<br />pet: cat","age:  8.7341772<br />score:  88.94132<br />pet: cat","age:  8.5443038<br />score:  89.08153<br />pet: cat","age:  8.3544304<br />score:  89.22174<br />pet: cat","age:  8.1645570<br />score:  89.36195<br />pet: cat","age:  7.9746835<br />score:  89.50216<br />pet: cat","age:  7.7848101<br />score:  89.64237<br />pet: cat","age:  7.5949367<br />score:  89.78258<br />pet: cat","age:  7.4050633<br />score:  89.92279<br />pet: cat","age:  7.2151899<br />score:  90.06299<br />pet: cat","age:  7.0253165<br />score:  90.20320<br />pet: cat","age:  6.8354430<br />score:  90.34341<br />pet: cat","age:  6.6455696<br />score:  90.48362<br />pet: cat","age:  6.4556962<br />score:  90.62383<br />pet: cat","age:  6.2658228<br />score:  90.76404<br />pet: cat","age:  6.0759494<br />score:  90.90425<br />pet: cat","age:  5.8860759<br />score:  91.04446<br />pet: cat","age:  5.6962025<br />score:  91.18467<br />pet: cat","age:  5.5063291<br />score:  91.32488<br />pet: cat","age:  5.3164557<br />score:  91.46508<br />pet: cat","age:  5.1265823<br />score:  91.60529<br />pet: cat","age:  4.9367089<br />score:  91.74550<br />pet: cat","age:  4.7468354<br />score:  91.88571<br />pet: cat","age:  4.5569620<br />score:  92.02592<br />pet: cat","age:  4.3670886<br />score:  92.16613<br />pet: cat","age:  4.1772152<br />score:  92.30634<br />pet: cat","age:  3.9873418<br />score:  92.44655<br />pet: cat","age:  3.7974684<br />score:  92.58676<br />pet: cat","age:  3.6075949<br />score:  92.72697<br />pet: cat","age:  3.4177215<br />score:  92.86717<br />pet: cat","age:  3.2278481<br />score:  93.00738<br />pet: cat","age:  3.0379747<br />score:  93.14759<br />pet: cat","age:  2.8481013<br />score:  93.28780<br />pet: cat","age:  2.6582278<br />score:  93.42801<br />pet: cat","age:  2.4683544<br />score:  93.56822<br />pet: cat","age:  2.2784810<br />score:  93.70843<br />pet: cat","age:  2.0886076<br />score:  93.84864<br />pet: cat","age:  1.8987342<br />score:  93.98885<br />pet: cat","age:  1.7088608<br />score:  94.12906<br />pet: cat","age:  1.5189873<br />score:  94.26926<br />pet: cat","age:  1.3291139<br />score:  94.40947<br />pet: cat","age:  1.1392405<br />score:  94.54968<br />pet: cat","age:  0.9493671<br />score:  94.68989<br />pet: cat","age:  0.7594937<br />score:  94.83010<br />pet: cat","age:  0.5696203<br />score:  94.97031<br />pet: cat","age:  0.3797468<br />score:  95.11052<br />pet: cat","age:  0.1898734<br />score:  95.25073<br />pet: cat","age:  0.0000000<br />score:  95.39094<br />pet: cat","age:  0.0000000<br />score:  95.39094<br />pet: cat"],"type":"scatter","mode":"lines","line":{"width":3.77952755905512,"color":"transparent","dash":"solid"},"fill":"toself","fillcolor":"rgba(0,186,56,0.4)","hoveron":"points","hoverinfo":"x+y","name":"cat","legendgroup":"cat","showlegend":false,"xaxis":"x","yaxis":"y","frame":null},{"x":[1,1.17721518987342,1.35443037974684,1.53164556962025,1.70886075949367,1.88607594936709,2.06329113924051,2.24050632911392,2.41772151898734,2.59493670886076,2.77215189873418,2.94936708860759,3.12658227848101,3.30379746835443,3.48101265822785,3.65822784810127,3.83544303797468,4.0126582278481,4.18987341772152,4.36708860759494,4.54430379746835,4.72151898734177,4.89873417721519,5.07594936708861,5.25316455696202,5.43037974683544,5.60759493670886,5.78481012658228,5.9620253164557,6.13924050632911,6.31645569620253,6.49367088607595,6.67088607594937,6.84810126582278,7.0253164556962,7.20253164556962,7.37974683544304,7.55696202531646,7.73417721518987,7.91139240506329,8.08860759493671,8.26582278481013,8.44303797468354,8.62025316455696,8.79746835443038,8.9746835443038,9.15189873417722,9.32911392405063,9.50632911392405,9.68354430379747,9.86075949367089,10.0379746835443,10.2151898734177,10.3924050632911,10.5696202531646,10.746835443038,10.9240506329114,11.1012658227848,11.2784810126582,11.4556962025316,11.6329113924051,11.8101265822785,11.9873417721519,12.1645569620253,12.3417721518987,12.5189873417722,12.6962025316456,12.873417721519,13.0506329113924,13.2278481012658,13.4050632911392,13.5822784810127,13.7594936708861,13.9367088607595,14.1139240506329,14.2911392405063,14.4683544303797,14.6455696202532,14.8227848101266,15,15,14.8227848101266,14.6455696202532,14.4683544303797,14.2911392405063,14.1139240506329,13.9367088607595,13.7594936708861,13.5822784810127,13.4050632911392,13.2278481012658,13.0506329113924,12.873417721519,12.6962025316456,12.5189873417722,12.3417721518987,12.1645569620253,11.9873417721519,11.8101265822785,11.6329113924051,11.4556962025316,11.2784810126582,11.1012658227848,10.9240506329114,10.746835443038,10.5696202531646,10.3924050632911,10.2151898734177,10.0379746835443,9.86075949367089,9.68354430379747,9.50632911392405,9.32911392405063,9.15189873417722,8.9746835443038,8.79746835443038,8.62025316455696,8.44303797468354,8.26582278481013,8.08860759493671,7.91139240506329,7.73417721518987,7.55696202531646,7.37974683544304,7.20253164556962,7.0253164556962,6.84810126582278,6.67088607594937,6.49367088607595,6.31645569620253,6.13924050632911,5.9620253164557,5.78481012658228,5.60759493670886,5.43037974683544,5.25316455696202,5.07594936708861,4.89873417721519,4.72151898734177,4.54430379746835,4.36708860759494,4.18987341772152,4.0126582278481,3.83544303797468,3.65822784810127,3.48101265822785,3.30379746835443,3.12658227848101,2.94936708860759,2.77215189873418,2.59493670886076,2.41772151898734,2.24050632911392,2.06329113924051,1.88607594936709,1.70886075949367,1.53164556962025,1.35443037974684,1.17721518987342,1,1],"y":[110.34501242225,110.365544911787,110.385454083293,110.404689867339,110.423197071305,110.440914767539,110.457775603475,110.473705024666,110.488620401318,110.502430048919,110.515032134115,110.52631345842,110.536148115103,110.544396019143,110.550901317343,110.555490696376,110.557971621969,110.558130563801,110.555731289555,110.550513348935,110.542190915,110.530452204882,110.514959761458,110.495351934491,110.471245941371,110.442242894833,110.407935133363,110.367916053022,110.321792397318,110.269198613865,110.209812465143,110.143370659856,110.069682960483,109.988643138982,109.900235376532,109.804535233974,109.701705057173,109.591984452361,109.475677084424,109.353135385797,109.224744780154,109.090908779997,108.952035920732,108.808529062158,108.66077720936,108.509149725209,108.353992635027,108.195626645829,108.034346492484,107.870421255398,107.704095347739,107.5355899299,107.365104565849,107.192818985543,107.01889485811,106.843477512206,106.666697563714,106.488672428304,106.309507708541,106.129298453494,105.948130294189,105.766080461544,105.583218695247,105.399608052873,105.215305628706,105.030363191459,104.844827749575,104.658742052161,104.47214503287,104.285072203335,104.097556002089,103.909626104202,103.721309696314,103.53263172116,103.343615095215,103.154280902634,102.964648568281,102.774736012293,102.584559788339,102.394135207446,113.53941040334,113.513605013999,113.488047981598,113.462754617162,113.437741474362,113.413026473334,113.388629038941,113.364570255339,113.340873039003,113.317562332669,113.294665322975,113.272211684993,113.250233857254,113.228767351393,113.207851101061,113.187527855366,113.167844622752,113.148853171931,113.130610597186,113.113179956093,113.096630988341,113.081040924846,113.066495396636,113.053089452778,113.040928695838,113.030130541487,113.020825605607,113.013159216853,113.007293044355,113.003406818068,113.001700101961,113.002394056428,113.005733094635,113.011986296989,113.02144839836,113.034440105762,113.051307444516,113.072419777494,113.098166109782,113.128949301177,113.165177887087,113.207255380012,113.255567203627,113.310465790368,113.372254805119,113.441173854113,113.517385283217,113.600964653267,113.691896145447,113.790073531712,113.895306574543,114.007331982643,114.125827518491,114.250427629702,114.380739059785,114.516355204799,114.656868403231,114.801879767817,114.951006515945,115.10388699738,115.260183754997,115.41958500593,115.581804923236,115.74658305662,115.913683173766,116.082891744352,116.254016234104,116.426883329697,116.601337177932,116.777237693789,116.954458970537,117.132887809691,117.312422377896,117.492970990639,117.674451018127,117.856787905913,118.039914301432,118.223769277031,118.408297640089,118.593449321179,110.34501242225],"text":["age:  1.0000000<br />score: 114.46923<br />pet: ferret","age:  1.1772152<br />score: 114.38692<br />pet: ferret","age:  1.3544304<br />score: 114.30461<br />pet: ferret","age:  1.5316456<br />score: 114.22230<br />pet: ferret","age:  1.7088608<br />score: 114.13999<br />pet: ferret","age:  1.8860759<br />score: 114.05768<br />pet: ferret","age:  2.0632911<br />score: 113.97537<br />pet: ferret","age:  2.2405063<br />score: 113.89306<br />pet: ferret","age:  2.4177215<br />score: 113.81075<br />pet: ferret","age:  2.5949367<br />score: 113.72844<br />pet: ferret","age:  2.7721519<br />score: 113.64613<br />pet: ferret","age:  2.9493671<br />score: 113.56383<br />pet: ferret","age:  3.1265823<br />score: 113.48152<br />pet: ferret","age:  3.3037975<br />score: 113.39921<br />pet: ferret","age:  3.4810127<br />score: 113.31690<br />pet: ferret","age:  3.6582278<br />score: 113.23459<br />pet: ferret","age:  3.8354430<br />score: 113.15228<br />pet: ferret","age:  4.0126582<br />score: 113.06997<br />pet: ferret","age:  4.1898734<br />score: 112.98766<br />pet: ferret","age:  4.3670886<br />score: 112.90535<br />pet: ferret","age:  4.5443038<br />score: 112.82304<br />pet: ferret","age:  4.7215190<br />score: 112.74073<br />pet: ferret","age:  4.8987342<br />score: 112.65842<br />pet: ferret","age:  5.0759494<br />score: 112.57611<br />pet: ferret","age:  5.2531646<br />score: 112.49380<br />pet: ferret","age:  5.4303797<br />score: 112.41149<br />pet: ferret","age:  5.6075949<br />score: 112.32918<br />pet: ferret","age:  5.7848101<br />score: 112.24687<br />pet: ferret","age:  5.9620253<br />score: 112.16456<br />pet: ferret","age:  6.1392405<br />score: 112.08225<br />pet: ferret","age:  6.3164557<br />score: 111.99994<br />pet: ferret","age:  6.4936709<br />score: 111.91763<br />pet: ferret","age:  6.6708861<br />score: 111.83532<br />pet: ferret","age:  6.8481013<br />score: 111.75301<br />pet: ferret","age:  7.0253165<br />score: 111.67070<br />pet: ferret","age:  7.2025316<br />score: 111.58840<br />pet: ferret","age:  7.3797468<br />score: 111.50609<br />pet: ferret","age:  7.5569620<br />score: 111.42378<br />pet: ferret","age:  7.7341772<br />score: 111.34147<br />pet: ferret","age:  7.9113924<br />score: 111.25916<br />pet: ferret","age:  8.0886076<br />score: 111.17685<br />pet: ferret","age:  8.2658228<br />score: 111.09454<br />pet: ferret","age:  8.4430380<br />score: 111.01223<br />pet: ferret","age:  8.6202532<br />score: 110.92992<br />pet: ferret","age:  8.7974684<br />score: 110.84761<br />pet: ferret","age:  8.9746835<br />score: 110.76530<br />pet: ferret","age:  9.1518987<br />score: 110.68299<br />pet: ferret","age:  9.3291139<br />score: 110.60068<br />pet: ferret","age:  9.5063291<br />score: 110.51837<br />pet: ferret","age:  9.6835443<br />score: 110.43606<br />pet: ferret","age:  9.8607595<br />score: 110.35375<br />pet: ferret","age: 10.0379747<br />score: 110.27144<br />pet: ferret","age: 10.2151899<br />score: 110.18913<br />pet: ferret","age: 10.3924051<br />score: 110.10682<br />pet: ferret","age: 10.5696203<br />score: 110.02451<br />pet: ferret","age: 10.7468354<br />score: 109.94220<br />pet: ferret","age: 10.9240506<br />score: 109.85989<br />pet: ferret","age: 11.1012658<br />score: 109.77758<br />pet: ferret","age: 11.2784810<br />score: 109.69527<br />pet: ferret","age: 11.4556962<br />score: 109.61296<br />pet: ferret","age: 11.6329114<br />score: 109.53066<br />pet: ferret","age: 11.8101266<br />score: 109.44835<br />pet: ferret","age: 11.9873418<br />score: 109.36604<br />pet: ferret","age: 12.1645570<br />score: 109.28373<br />pet: ferret","age: 12.3417722<br />score: 109.20142<br />pet: ferret","age: 12.5189873<br />score: 109.11911<br />pet: ferret","age: 12.6962025<br />score: 109.03680<br />pet: ferret","age: 12.8734177<br />score: 108.95449<br />pet: ferret","age: 13.0506329<br />score: 108.87218<br />pet: ferret","age: 13.2278481<br />score: 108.78987<br />pet: ferret","age: 13.4050633<br />score: 108.70756<br />pet: ferret","age: 13.5822785<br />score: 108.62525<br />pet: ferret","age: 13.7594937<br />score: 108.54294<br />pet: ferret","age: 13.9367089<br />score: 108.46063<br />pet: ferret","age: 14.1139241<br />score: 108.37832<br />pet: ferret","age: 14.2911392<br />score: 108.29601<br />pet: ferret","age: 14.4683544<br />score: 108.21370<br />pet: ferret","age: 14.6455696<br />score: 108.13139<br />pet: ferret","age: 14.8227848<br />score: 108.04908<br />pet: ferret","age: 15.0000000<br />score: 107.96677<br />pet: ferret","age: 15.0000000<br />score: 107.96677<br />pet: ferret","age: 14.8227848<br />score: 108.04908<br />pet: ferret","age: 14.6455696<br />score: 108.13139<br />pet: ferret","age: 14.4683544<br />score: 108.21370<br />pet: ferret","age: 14.2911392<br />score: 108.29601<br />pet: ferret","age: 14.1139241<br />score: 108.37832<br />pet: ferret","age: 13.9367089<br />score: 108.46063<br />pet: ferret","age: 13.7594937<br />score: 108.54294<br />pet: ferret","age: 13.5822785<br />score: 108.62525<br />pet: ferret","age: 13.4050633<br />score: 108.70756<br />pet: ferret","age: 13.2278481<br />score: 108.78987<br />pet: ferret","age: 13.0506329<br />score: 108.87218<br />pet: ferret","age: 12.8734177<br />score: 108.95449<br />pet: ferret","age: 12.6962025<br />score: 109.03680<br />pet: ferret","age: 12.5189873<br />score: 109.11911<br />pet: ferret","age: 12.3417722<br />score: 109.20142<br />pet: ferret","age: 12.1645570<br />score: 109.28373<br />pet: ferret","age: 11.9873418<br />score: 109.36604<br />pet: ferret","age: 11.8101266<br />score: 109.44835<br />pet: ferret","age: 11.6329114<br />score: 109.53066<br />pet: ferret","age: 11.4556962<br />score: 109.61296<br />pet: ferret","age: 11.2784810<br />score: 109.69527<br />pet: ferret","age: 11.1012658<br />score: 109.77758<br />pet: ferret","age: 10.9240506<br />score: 109.85989<br />pet: ferret","age: 10.7468354<br />score: 109.94220<br />pet: ferret","age: 10.5696203<br />score: 110.02451<br />pet: ferret","age: 10.3924051<br />score: 110.10682<br />pet: ferret","age: 10.2151899<br />score: 110.18913<br />pet: ferret","age: 10.0379747<br />score: 110.27144<br />pet: ferret","age:  9.8607595<br />score: 110.35375<br />pet: ferret","age:  9.6835443<br />score: 110.43606<br />pet: ferret","age:  9.5063291<br />score: 110.51837<br />pet: ferret","age:  9.3291139<br />score: 110.60068<br />pet: ferret","age:  9.1518987<br />score: 110.68299<br />pet: ferret","age:  8.9746835<br />score: 110.76530<br />pet: ferret","age:  8.7974684<br />score: 110.84761<br />pet: ferret","age:  8.6202532<br />score: 110.92992<br />pet: ferret","age:  8.4430380<br />score: 111.01223<br />pet: ferret","age:  8.2658228<br />score: 111.09454<br />pet: ferret","age:  8.0886076<br />score: 111.17685<br />pet: ferret","age:  7.9113924<br />score: 111.25916<br />pet: ferret","age:  7.7341772<br />score: 111.34147<br />pet: ferret","age:  7.5569620<br />score: 111.42378<br />pet: ferret","age:  7.3797468<br />score: 111.50609<br />pet: ferret","age:  7.2025316<br />score: 111.58840<br />pet: ferret","age:  7.0253165<br />score: 111.67070<br />pet: ferret","age:  6.8481013<br />score: 111.75301<br />pet: ferret","age:  6.6708861<br />score: 111.83532<br />pet: ferret","age:  6.4936709<br />score: 111.91763<br />pet: ferret","age:  6.3164557<br />score: 111.99994<br />pet: ferret","age:  6.1392405<br />score: 112.08225<br />pet: ferret","age:  5.9620253<br />score: 112.16456<br />pet: ferret","age:  5.7848101<br />score: 112.24687<br />pet: ferret","age:  5.6075949<br />score: 112.32918<br />pet: ferret","age:  5.4303797<br />score: 112.41149<br />pet: ferret","age:  5.2531646<br />score: 112.49380<br />pet: ferret","age:  5.0759494<br />score: 112.57611<br />pet: ferret","age:  4.8987342<br />score: 112.65842<br />pet: ferret","age:  4.7215190<br />score: 112.74073<br />pet: ferret","age:  4.5443038<br />score: 112.82304<br />pet: ferret","age:  4.3670886<br />score: 112.90535<br />pet: ferret","age:  4.1898734<br />score: 112.98766<br />pet: ferret","age:  4.0126582<br />score: 113.06997<br />pet: ferret","age:  3.8354430<br />score: 113.15228<br />pet: ferret","age:  3.6582278<br />score: 113.23459<br />pet: ferret","age:  3.4810127<br />score: 113.31690<br />pet: ferret","age:  3.3037975<br />score: 113.39921<br />pet: ferret","age:  3.1265823<br />score: 113.48152<br />pet: ferret","age:  2.9493671<br />score: 113.56383<br />pet: ferret","age:  2.7721519<br />score: 113.64613<br />pet: ferret","age:  2.5949367<br />score: 113.72844<br />pet: ferret","age:  2.4177215<br />score: 113.81075<br />pet: ferret","age:  2.2405063<br />score: 113.89306<br />pet: ferret","age:  2.0632911<br />score: 113.97537<br />pet: ferret","age:  1.8860759<br />score: 114.05768<br />pet: ferret","age:  1.7088608<br />score: 114.13999<br />pet: ferret","age:  1.5316456<br />score: 114.22230<br />pet: ferret","age:  1.3544304<br />score: 114.30461<br />pet: ferret","age:  1.1772152<br />score: 114.38692<br />pet: ferret","age:  1.0000000<br />score: 114.46923<br />pet: ferret","age:  1.0000000<br />score: 114.46923<br />pet: ferret"],"type":"scatter","mode":"lines","line":{"width":3.77952755905512,"color":"transparent","dash":"solid"},"fill":"toself","fillcolor":"rgba(97,156,255,0.4)","hoveron":"points","hoverinfo":"x+y","name":"ferret","legendgroup":"ferret","showlegend":false,"xaxis":"x","yaxis":"y","frame":null}],"layout":{"margin":{"t":26.2283105022831,"r":7.30593607305936,"b":40.1826484018265,"l":43.1050228310502},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.8,16.8],"tickmode":"array","ticktext":["0","5","10","15"],"tickvals":[0,5,10,15],"categoryorder":"array","categoryarray":["0","5","10","15"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"age","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[47.05,133.95],"tickmode":"array","ticktext":["50","70","90","110","130"],"tickvals":[50,70,90,110,130],"categoryorder":"array","categoryarray":["50","70","90","110","130"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(235,235,235,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"score","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(51,51,51,1)","width":0.66417600664176,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"y":0.913385826771654},"annotations":[{"text":"pet","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"7124ee112e7":{"x":{},"y":{},"fill":{},"type":"scatter"},"7121aa02426":{"x":{},"y":{},"fill":{}}},"cur_data":"7124ee112e7","visdat":{"7124ee112e7":["function (y) ","x"],"7121aa02426":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
```

<p class="caption">(\#fig:plotly)Interactive graph using plotly</p>
</div>

<div class="info">
<p>Hover over the data points above and click on the legend items.</p>
</div>

## Glossary {#glossary3}



|term                                                                                                        |definition                                                                               |
|:-----------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/c#continuous'>continuous</a> |Data that can take on any values between other existing values.                          |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/d#discrete'>discrete</a>     |Data that can only take certain values, such as integers.                                |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/g#geom'>geom</a>             |The geometric style in which data are displayed, such as boxplot, density, or histogram. |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/l#likert'>likert</a>         |A rating scale with a small number of discrete points in order                           |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/n#nominal'>nominal</a>       |Categorical variables that don’t have an inherent order, such as types of animal.        |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/o#ordinal'>ordinal</a>       |Discrete variables that have an inherent order, such as number of legs                   |




## Exercises {#exercises3}

Download the [exercises](exercises/03_ggplot_exercise.Rmd). See the [plots](exercises/03_ggplot_answers.html) to see what your plots should look like (this doesn't contain the answer code). See the [answers](exercises/03_ggplot_answers.Rmd) only after you've attempted all the questions.


```r
# run this to access the exercise
dataskills::exercise(3)

# run this to access the answers
dataskills::exercise(3, answers = TRUE)
```
