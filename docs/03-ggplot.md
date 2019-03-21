
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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/barplot-1.png" alt="Bar plot" width="100%" />
<p class="caption">(\#fig:barplot)Bar plot</p>
</div>

### Density plot
<a name="geom_density"></a>
Density plots are good for one continuous variable, but only if you have a fairly 
large number of observations.


```r
ggplot(demog, aes(height)) +
  geom_density()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density-1.png" alt="Density plot" width="100%" />
<p class="caption">(\#fig:density)Density plot</p>
</div>

You can represent subsets of a variable by assigning the category variable to 
the argument `group`, `fill`, or `color`. 


```r
ggplot(demog, aes(height, fill = sex)) +
  geom_density(alpha = 0.5)
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density-sex-1.png" alt="Density plot with fill defined by sex" width="100%" />
<p class="caption">(\#fig:density-sex)Density plot with fill defined by sex</p>
</div>

<div class="try">
<p>Try changing the <code>alpha</code> argument to figure out what it does.</p>
</div>

### Frequency Polygons {#geom_freqpoly}

If you don't want smoothed distributions, try `geom_freqpoly()`.


```r
ggplot(demog, aes(height, color = sex)) +
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
ggplot(demog, aes(height)) +
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
ggplot(demog, aes(height, fill=sex)) +
  geom_histogram(binwidth = 1, alpha = 0.5, position = "dodge")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/histogram-sex-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:histogram-sex)**CAPTION THIS FIGURE!!**</p>
</div>

<div class="try">
<p>Try changing the <code>position</code> argument to &quot;identity&quot;, &quot;fill&quot;, &quot;dodge&quot;, or &quot;stack&quot;.</p>
</div>

### Column plot {#geom_col}

Column plots are the worst way to represent grouped continuous data, but also one of the most common.

To make column plots with error bars, you first need to calculate the means, error bar uper limits (`ymax`) and error bar lower limits (`ymin`) for each category. You'll learn more about how to use the code below in the next two lessons.


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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/colplot-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:colplot)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/boxplot-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:boxplot)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violin-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:violin)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/stat-summary-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:stat-summary)**CAPTION THIS FIGURE!!**</p>
</div>

### Scatter plot {#geom_point}

Scatter plots are a good way to represent the relationship between two continuous variables.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_point()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/scatter-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:scatter)**CAPTION THIS FIGURE!!**</p>
</div>

### Line graph {#geom_smooth}

You often want to represent the relationship as a single line.


```r
ggplot(x_vs_y, aes(x, y)) +
  geom_smooth(method="lm")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/line-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:line)**CAPTION THIS FIGURE!!**</p>
</div>
 
 
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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violinbox-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:violinbox)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/violin-jitter-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:violin-jitter)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/scatter_line-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:scatter_line)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/cowplot-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:cowplot)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap_alpha-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:overlap_alpha)**CAPTION THIS FIGURE!!**</p>
</div>

{#geom_coun}
Or you can set the size of the dot proportional to the number of overlapping 
observations using `geom_count()`.


```r
overlap %>%
  ggplot(aes(x, y)) +
  geom_count(color = "#663399")
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/overlap_size-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:overlap_size)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/overlap-colour-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:overlap-colour)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/overplot-point-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:overplot-point)**CAPTION THIS FIGURE!!**</p>
</div>

{#geom_density2d}
Use `geom_density2d()` to create a contour map.


```r
overplot %>%
  ggplot(aes(x, y)) + 
  geom_density2d()
```

<div class="figure" style="text-align: center">
<img src="03-ggplot_files/figure-html/density2d-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:density2d)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/density2d-fill-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:density2d-fill)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/bin2d-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:bin2d)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/overplot-hex-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:overplot-hex)**CAPTION THIS FIGURE!!**</p>
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
<img src="03-ggplot_files/figure-html/heatmap-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:heatmap)**CAPTION THIS FIGURE!!**</p>
</div>

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

<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-b844bb8f4df2d64d1834" style="width:100%;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-b844bb8f4df2d64d1834">{"x":{"data":[{"x":[21.0154450603761,23.92362917969,24.0677802470513,21.8556245951913,20.8669800550677,20.9808297808282,21.9514093269594,22.1753192679957,24.1454547539353,23.1150762079284,22.1904748777859,22.0491903342307,21.8189750219695,22.9081734959036,23.0910946809687,22.0268752797507,22.0853383829817,26.8673277381808,27.0842207654379,21.8822646617889,20.9216471424326,25.1974481366575,22.9282077705488,24.0408813415095,23.891270747222,22.0803644578904,24.0508416204713,21.0195518518798,22.9152998243459,23.1368917419575,22.9731705509126,24.1425396884792,24.9874205122702,24.0771049051546,24.0388507368974,22.8417754022405,20.902806874644,23.1364887063392,23.9231270589866,25.0732838432305,22.9274409713224,23.0241782040335,22.0112583482638,25.1061604633927,22.0391635642387,23.9791885141283,24.0853702994995,25.1204320671968,22.0074130405672,26.0842417561449,23.1857916146517,21.8127855977044,20.9858576559462,22.8042275242507,22.0547317346558,22.887605946511,24.0952576894313,21.8138606667519,26.919509012159,22.0353728835471,24.920294116158,21.1577956090681,21.8290487821214,24.0169464888982,20.9297759810463,20.8173019848764,24.1368008800782,20.0314632577822,22.8239174630493,23.0797798209824,23.8217553523369,21.0077905924991,22.9242970096879,22.1865374556743,23.1641277200542,22.851053062547,22.8197044239379,21.9967205882072,23.9015997920185,22.8236322896555,21.8101006657816,22.130900891684,23.8515529409051,22.9276193321683,25.1762556990609,21.8340308512561,21.9188493833877,23.0536678475328,25.9143706900999,24.8453619969077,28.1750859538093,27.1827633673325,26.018152992148,23.1497659470886,23.0499808169901,21.9554538802244,24.0846537669189,22.0202579702251,21.9907800525427,22.866043476481,25.9287691669539,21.933949494455,21.8648743621074,28.9532271927223,26.1997712981887,25.0530471285805,22.8183574743569,22.0338066564873,26.1115924741142,21.980325927306,26.0804539686069,23.1842527163215,23.1461372972466,22.1347169341519,20.9419539438561,21.0842203662731,24.8233848886564,22.9324861234054,21.1147521656938,26.178631703835,24.9451351567171,22.8261467097327,21.8086252433248,22.1947268640623,24.0329994052649,19.8973754174076,25.0803460057825,21.1165945984423,21.1673179039732,21.893753813114,21.9300386851653,23.0595224593766,23.0027729396708,21.9336691854522,23.9286445938982,21.1312077820301,21.129700137116,22.8519256165251,23.0387926178984,21.8201323028654,21.0982982651331,21.9948879517615,22.1613084179349,22.1875533351675,22.8932373247109,27.1585781550035,24.0343243969604,23.1949874636717,20.8255244936794,22.8129812899046,21.8801518203691,19.97766085146,25.8465054216795,23.1039483207278,19.8711220351048,22.1419174988754,22.0703038976528,25.1830235250294,20.1088789912872,25.8795296900906,22.0845532214269,23.0285092960112,21.078625658527,20.9310501224361,22.996726693958,22.1777476614341,24.0247657237574,22.0976717861369,21.8724170289002,19.9182856852189,22.8756577546708,21.1719505591318,20.9710567539558,19.8443638124503,24.0090058268979,20.9000451660715,23.9242426178418,20.8869022102095,21.9526192677207,23.048301321175,25.1417731657624,23.8382443104871,25.9344751756638,22.9033710888587,22.9310713897459,22.8171403129585,22.1622480189428,20.0966357321478,22.0826147163287,21.8848135161214,24.090529809799,23.0995425220579,23.8339053424075,24.1476796266623,22.9576231979765,24.0636559178121,22.837103052903,23.1303638389334,24.0395421253517,20.1070191113278,21.9172973556444,19.8441308973357,23.8940896724351,23.0511777235195,26.8838562547229,22.076885752473,23.8611873741262,22.9344368698075,24.0154286968522,21.1992475925945,26.0991315253079,22.9362847098149,23.8329516196623,21.8062929319218,25.8410350241698,21.0191106440499,23.0043670161627,21.8953584875911,22.1651124240831,22.8110927386209,21.8402415978722,20.8399028242566,24.9057518118061,23.03793235505,30.8219573433511,26.0223415712826,20.893273929134,23.0885267960839,25.1048384581693,21.1649581940845,23.8874622033909,22.1845155359246,24.8651204143651,22.1094918805175,22.095529688336,23.8279318399727,23.0093121811748,23.0261753844097,21.9396955579519,23.8333939093165,25.1052249598317,21.9295760047622,24.1597768583335,23.9383372795768,21.821731214691,23.9512582509778,26.0164209129289,21.9027547302656,19.9105073622428,21.8655318276025,22.0693428108469,20.8959123927169,25.0657645161264,22.8843910750933,23.1903260819614,21.8055448989384,23.1842389801517,22.1517531006597,21.1593894741498,23.8036322329193,21.0699292957783,24.8825834592804,25.9057657572441,24.8726522935554,23.1023379858583,23.8750241634436,21.8215118445456,23.0176596581005,29.0790011337958,23.198967560567,21.0546599208377,24.9007829312235,22.1305387316272,20.13691319637,21.1405321629718,22.0750245153904,21.0305499924347,24.1459718771279,23.1209420231171,22.1374884350225,21.8742726835422,24.8561150160618,22.8820116618648,21.9717308443971,23.9091830913909,29.8964357221499,22.8569086740725,22.9348435596563,22.0851885527372,23.9961678825319,22.0358245880343,21.0579182766378,25.1633985743858,22.0666184384376,23.1126703562215,23.1768382426351,22.0425090191886,22.0259646558203,22.0438044107519,24.0489184561186,20.8934997644275,27.1421435458586,24.1155229913071,21.9133985832334,21.0471492072567,21.0079494771548,22.1989703276195,24.8622428241186,22.0481454904191,24.9641050144099,21.0739649177529,21.8105284495279,22.951786770951,20.1601110562682,23.1505302306265,22.8976837058552,22.0190846038051,22.8949337546714,21.1233682863414,20.8514703402296,26.1227984319441,22.0884770274162,23.8121381467208,22.87578665521,21.80033443477,24.1597058795393,26.0777305944823,23.1508837891743,20.9282515361905,21.8332423115149,23.000665033143,25.0307884804904,19.9576574790291,25.0907282356173,21.1908665277064,25.0362225450575,23.1251001924276,21.0340273752809,22.186435872782,23.8577763690613,23.036915055383,21.8095764659345,22.1425536201335,21.9351515802555,24.0088691435754,22.8256586028263,22.9277437659912,21.9317784637213,25.1459684013389,23.0094418934546,23.1175034488551,21.9501749871299,21.0928127258085,21.1830339249223,25.88986497242,23.9295576224104,25.1008970831521,20.0424919537269,22.1162961838767,25.8474873666652,27.0665366276167,22.9616353264079,22.9261381234042,19.8085029653274,19.9663941005245,26.1657335346565,24.9011844410561,23.8217691397294,29.1441134765744,21.0198915347457,23.9368513434194,23.947522936482,26.0305922934785,22.1939318646677,23.0945526567288,24.0926754490472,22.9675668411888,25.1513931318186,24.1234884332865,23.1138524967246,22.0237985198386,21.9786400210112,22.9613646433689,23.9682620191015,24.1729064723477,23.9300972393714,25.0498196851462,21.0299048404209,23.921088815853,25.0398270248435,22.114327598922,21.1046639145352,21.9544589777477,24.1097575850785,20.8786613280885,23.0682363619097,20.9564084498212,22.8865413649008,21.047157925833,21.196375946328,24.1444492776878,22.9747215610929,24.186244133953,22.804227239266,23.8438793756999,21.985710379295,20.9680995458737,29.9297244120389,20.9645748880692,22.1080638507381,19.9800859156065,20.8800715609454,25.1783973363228,22.8445062575862,27.1896781579591,24.9200978129171,21.8574856634252,22.99066693848,20.8634277369827,25.0778619837016,19.9640680474229,25.158762744721,23.8605028312653,23.1404273419641,22.9326668530703,21.8242037338205,22.9120493338443,22.9226513442583,20.9091250958852,23.9379044159316,21.0854656671174,22.9982979618013,24.1007018724456,23.0937024503015,22.9233258628286,26.0129590329714,24.102887870837,22.1551385189407,21.145709610451,24.1035150833428,22.9658351982944,23.0735630817711,23.0279387268238,23.9054832481779,26.1049200025387,26.0987164816819,26.1653994683176,21.9195034621283,21.0964323302731,25.0820219322108,27.0821303283796,22.0774797447957,20.8423827663995,24.8629096330144,25.9946248226799,22.9683201206848,26.9019458876923,23.1642944335006,20.8111600628123,21.9500098428689,24.9592083721422,23.8097296892665,23.0426503926516,25.0816861276515,21.1937041635625,26.1220426721498,23.9448552666232,20.862946354039,23.0670151652768,27.8011937257834,23.8928260452114,22.0616777272895,24.8699741424061,23.8137604760937,27.0394179313444,25.9009550366551,21.1045775679871,22.1379388142377,23.1715515309013,25.1032202765346,22.1444304372184,20.9866772288457,21.8052078235894,22.1490654046647,21.0120513936505,20.9173295542598,22.0026805229485,21.0892700419761,22.1601314246655,23.8245112191886,21.8934450617991,23.8130461091176,23.809855250828,23.8904555395246,21.8153645207174,26.1671761229634,23.1806163785048,22.911648995243,24.0491071030498,24.1171668446623],"y":[70.3897648023207,66.4933485125674,61.4080602705669,62.583925486278,61.6613016328282,58.8553441927996,67.7236146220297,64.7935109298901,67.4724670478154,63.881561911561,62.1055016929709,64.4324159713169,65.0466190149831,68.9319926945761,67.5370889521356,66.3373679114759,64.3949758576289,61.5844233698172,66.5998547451808,62.9058658864769,59.5010151339764,67.5869960827433,64.7192661366196,63.1383244921355,63.1434646247208,71.1816209539861,57.1915082032989,66.0871385521427,60.6764510695158,64.1633383370418,68.2773686375811,66.9037442422465,68.0533889877057,62.0235547547291,59.1679012895531,67.9016640590299,61.8894783187055,67.3877650351203,63.8946804850042,63.2958063109828,68.6577277034492,65.2100065755066,68.9778297235884,61.4525052498252,62.8279439503526,60.0114000826682,62.7159526751992,63.6275986268619,67.9870352155007,64.638169211366,61.6649153064701,67.7254354775264,64.4625035992186,64.2876326038997,65.3961260020435,63.0175404683883,73.9396707415205,62.6185300412688,66.2368020228463,60.2427562710975,64.9736688720327,57.3648521372286,63.2140168718942,58.8335691107327,65.0956427732335,64.0106262394394,60.8464418262628,65.362354053008,68.1347868682839,59.3049849454887,66.2831210135846,63.0419605410884,60.0795323757083,64.2402775539604,73.7381026717141,68.4705668587894,61.0622318466695,67.4817629548227,61.5294530412109,66.8773647078791,58.7178065296053,64.2203269927464,58.4026467505357,70.7643073023513,60.1961153008177,60.6264554283966,65.5905996874102,66.8954320478311,63.6502157087,62.6604514708679,65.7319690189503,64.1752597404473,61.0244642916095,66.6972077636511,66.8113935543463,64.9043886526174,69.2703824803443,65.5566182272667,65.3182386257439,60.8480274222981,65.563010487557,63.1813477714023,57.2106793859186,64.4982040032417,61.5788499990054,63.0704952862422,69.4870109280526,67.8092473433374,66.5301359977226,64.6926692955403,63.4745670463704,68.758507871024,67.3983078537331,62.438202738171,69.3863102157703,63.143414764002,71.5362757998943,69.633425492823,68.5781102020555,66.9870365098338,67.7893498565418,67.9868968856585,62.9851063988885,67.0895234338017,68.3822700921618,64.3538714432942,61.1547552313901,63.2339077308317,63.461348644538,65.5693782361481,60.1357819692097,64.7857249082419,66.423220595045,64.5338325723157,65.2613614145404,60.7741525108888,62.121470467384,61.9244091503714,69.2211758176936,65.4481651324757,61.7255124510882,63.0900954458586,71.0095704429267,66.351229009038,68.508313769372,56.3621164900423,68.2778577568257,71.1490236996722,70.9566226063974,62.8322974854957,57.854047397486,64.9156189324632,63.2717479698091,70.6157559600764,64.2125966040668,61.5976535182793,60.6015466265548,66.7193016423657,60.6857658791299,68.0708344644665,67.7398945246275,69.2616152491887,66.5312268965918,62.7415854423422,69.3322650406019,69.1537656672054,62.0763151722275,63.7448236693322,62.525131725781,72.6113609879971,56.3610711310591,66.5940054613773,72.0611058861486,67.3113238228164,61.9260385910971,61.7609973007183,66.4553149907291,62.5603251869311,72.2247289357267,66.3642489899935,66.8268287919811,70.2878978225149,63.7318544962657,66.8692804659961,60.3841514887261,71.9824752188675,69.1972907410021,66.9952711018811,61.6488789062748,67.6704233884456,69.0482854567183,73.066780140813,66.6209156925011,65.9729903675245,61.6864069665809,67.936063989519,67.4067583381932,67.6570418352625,66.4756379468077,64.727145094885,65.4655391778495,69.134706835519,64.9253769311536,66.2710328531121,59.4041635059373,69.1086557436011,66.291966042092,63.4752189506852,61.7503318019931,63.4586459575463,67.5668366457674,65.7520627981179,58.4300807631382,64.8594974214278,62.0851872661114,67.3987219564373,59.4499892344617,68.9965834946425,68.6018042619802,66.7233351467057,59.675199315538,65.8509918444875,64.9362791102127,70.7616569734257,60.8236589798594,65.056490999903,66.5451970200179,65.6653288124024,66.218394437408,65.3387499025581,61.3925708345818,68.4497173095519,65.7803012217487,60.7163556637539,61.3818883354923,65.4005170595181,61.0585956884711,61.7642700603625,61.3310181943143,68.4945280812465,58.3103339137036,61.5390477728685,63.033832017855,58.7123338378323,70.8393136043015,66.704336028535,63.2767576767768,66.2316516632562,62.3644831467101,65.7771257636637,69.7034011965428,61.7382839672817,63.5880274158255,62.9657567369542,72.471761707987,66.2933755289422,64.3641448996821,60.5129184764451,66.7603572357912,65.8551470245007,65.1424848814621,63.0934360143362,61.8442641789096,59.4746509955068,69.1551639664135,67.3111841642246,63.5077187559373,67.2091483419306,61.1265848597912,69.1707248241297,66.0904480374792,60.4957837302475,65.4669901821084,66.331861392578,66.0460671018567,61.5880088455166,61.313004140775,62.3957317801108,69.3265479981092,69.9482994241156,63.8632360249185,65.8789692017413,66.3037771877443,67.7785672750802,61.3962853457233,70.0304033487032,60.8872293040835,66.9772683558632,67.4726254952462,65.2872246245828,66.7379696044056,65.9992540669244,61.4372963600783,69.2410368950997,68.2638023368747,70.0570121910241,68.4148603636859,70.7364572313481,62.4821539896137,61.020198213134,67.5884949677404,62.7055120134173,62.5779103658391,60.0344508911239,65.0236996004534,71.2142780249664,57.7521952637721,62.7319812643849,68.5182472678572,65.8303952720172,60.8399813397719,63.2481687064583,66.0330878034853,52.9265517486516,68.5689350472558,61.982890049024,66.2000093120386,58.4473734879064,61.5694398646758,64.274382780522,68.7672303620871,63.8698960679298,63.9330972526927,67.6270071612364,67.6020027059903,68.1244674306469,66.3618930776139,59.9182854650175,70.9297670142985,64.1812381489932,65.1680384721511,65.4282814780014,70.2369130664997,68.1579716451052,62.2675169530446,68.0762280759209,66.5119618494729,59.3308157072567,66.3088119659544,62.1738354001756,64.9524584791734,64.0745329002187,63.1775862469538,59.0187295039295,68.353271136773,73.5827838513248,69.7563542282096,61.7174438975988,67.8409304103158,69.5037817932998,64.3339647418322,66.9548117288193,68.1242503923488,69.2034478970064,67.9494023375563,69.473273331158,62.086539911428,63.6741454257432,67.6202611386987,66.2413934864065,62.8022670491469,63.109228688549,66.30740985268,70.099358484274,65.5280876737723,68.2236993070743,62.534493700117,63.5289627787466,66.5625321420697,65.9665712902966,63.897143765939,56.1653310803996,57.8868951439713,66.3462321259183,64.4125345430358,64.6109623782863,61.0384293515653,61.5820839944216,63.4446115519138,67.1221860918515,60.4694967225262,67.7190902590531,59.9411747734976,62.2884957193231,62.5280910177958,55.8639659017868,65.0376099454586,65.931651206987,60.8966632358633,65.867872023557,73.1612064748149,64.7036050255086,65.6084981254442,65.8190598815305,65.5366038620021,71.3460461832077,67.0685470945381,62.8609901369963,59.0226097821529,67.0392392041543,70.8857113373823,56.2525156948456,65.0893836224554,65.044254188207,60.6662085014106,63.8720726855122,61.9231160985241,67.3443370194917,58.6413266292851,63.5491752944611,68.3390353249648,64.1704375834442,59.7345307366482,61.7781521390782,64.9369749300371,63.3747586788434,63.5079450337023,63.1988814442243,64.7506136076252,64.4066970111541,65.6882060450428,69.3673704785516,66.7465915885541,65.6924359812425,70.4278763553415,65.8156637400711,63.8860352638164,61.5495179477078,64.77823750086,65.8484214708163,66.2911932841703,72.8314566555818,65.9070667847281,63.732814556111,62.3609504516033,65.1289201224024,70.6188416346621,64.1005778540643,58.7916445778731,63.6193133393218,61.0481448985193,59.4049918628716,68.2355290174788,60.1680901056841,68.6071600001388,67.2155732978759,68.9660607068875,65.8509130401448,61.3808467328054,62.9586835736079,64.0640535986213,60.5788262481848,60.9047397769118,67.4546044345104,70.7113777101489,64.1797997257917,67.2704891425768,68.3590589262821,65.3679665829724,65.5640533003292,67.1780247457047,63.673385733637,60.340144468211,66.4257878865028,62.2194704685036,65.6675039370971,64.6398348177191,66.8452366876683,65.1071001674586,67.508363995112,61.3245968600181,69.9754724839459,67.5289300229923,70.1971883609611,70.5447535088837,61.5988023514687,62.8824822327678,72.0903445551282,69.4243907428247,63.1147434897553,65.9954012070601,66.8387701095428,60.802945701615,68.2902726217586,67.4443649523522,65.5903182434128,62.9563267909575,59.2133945699381,67.623230483562,62.0212442013011,70.5456571899702,66.4949042291066,60.9913395108584,68.0140362891189,55.5691811924401,63.3238567090773,64.1634224947823,64.4895013023865,66.9091783643554,65.1445528118685],"text":["age: 21<br />height: 70.38976<br />sex: female","age: 24<br />height: 66.49335<br />sex: female","age: 24<br />height: 61.40806<br />sex: female","age: 22<br />height: 62.58393<br />sex: female","age: 21<br />height: 61.66130<br />sex: female","age: 21<br />height: 58.85534<br />sex: female","age: 22<br />height: 67.72361<br />sex: female","age: 22<br />height: 64.79351<br />sex: female","age: 24<br />height: 67.47247<br />sex: female","age: 23<br />height: 63.88156<br />sex: female","age: 22<br />height: 62.10550<br />sex: female","age: 22<br />height: 64.43242<br />sex: female","age: 22<br />height: 65.04662<br />sex: female","age: 23<br />height: 68.93199<br />sex: female","age: 23<br />height: 67.53709<br />sex: female","age: 22<br />height: 66.33737<br />sex: female","age: 22<br />height: 64.39498<br />sex: female","age: 27<br />height: 61.58442<br />sex: female","age: 27<br />height: 66.59985<br />sex: female","age: 22<br />height: 62.90587<br />sex: female","age: 21<br />height: 59.50102<br />sex: female","age: 25<br />height: 67.58700<br />sex: female","age: 23<br />height: 64.71927<br />sex: female","age: 24<br />height: 63.13832<br />sex: female","age: 24<br />height: 63.14346<br />sex: female","age: 22<br />height: 71.18162<br />sex: female","age: 24<br />height: 57.19151<br />sex: female","age: 21<br />height: 66.08714<br />sex: female","age: 23<br />height: 60.67645<br />sex: female","age: 23<br />height: 64.16334<br />sex: female","age: 23<br />height: 68.27737<br />sex: female","age: 24<br />height: 66.90374<br />sex: female","age: 25<br />height: 68.05339<br />sex: female","age: 24<br />height: 62.02355<br />sex: female","age: 24<br />height: 59.16790<br />sex: female","age: 23<br />height: 67.90166<br />sex: female","age: 21<br />height: 61.88948<br />sex: female","age: 23<br />height: 67.38777<br />sex: female","age: 24<br />height: 63.89468<br />sex: female","age: 25<br />height: 63.29581<br />sex: female","age: 23<br />height: 68.65773<br />sex: female","age: 23<br />height: 65.21001<br />sex: female","age: 22<br />height: 68.97783<br />sex: female","age: 25<br />height: 61.45251<br />sex: female","age: 22<br />height: 62.82794<br />sex: female","age: 24<br />height: 60.01140<br />sex: female","age: 24<br />height: 62.71595<br />sex: female","age: 25<br />height: 63.62760<br />sex: female","age: 22<br />height: 67.98704<br />sex: female","age: 26<br />height: 64.63817<br />sex: female","age: 23<br />height: 61.66492<br />sex: female","age: 22<br />height: 67.72544<br />sex: female","age: 21<br />height: 64.46250<br />sex: female","age: 23<br />height: 64.28763<br />sex: female","age: 22<br />height: 65.39613<br />sex: female","age: 23<br />height: 63.01754<br />sex: female","age: 24<br />height: 73.93967<br />sex: female","age: 22<br />height: 62.61853<br />sex: female","age: 27<br />height: 66.23680<br />sex: female","age: 22<br />height: 60.24276<br />sex: female","age: 25<br />height: 64.97367<br />sex: female","age: 21<br />height: 57.36485<br />sex: female","age: 22<br />height: 63.21402<br />sex: female","age: 24<br />height: 58.83357<br />sex: female","age: 21<br />height: 65.09564<br />sex: female","age: 21<br />height: 64.01063<br />sex: female","age: 24<br />height: 60.84644<br />sex: female","age: 20<br />height: 65.36235<br />sex: female","age: 23<br />height: 68.13479<br />sex: female","age: 23<br />height: 59.30498<br />sex: female","age: 24<br />height: 66.28312<br />sex: female","age: 21<br />height: 63.04196<br />sex: female","age: 23<br />height: 60.07953<br />sex: female","age: 22<br />height: 64.24028<br />sex: female","age: 23<br />height: 73.73810<br />sex: female","age: 23<br />height: 68.47057<br />sex: female","age: 23<br />height: 61.06223<br />sex: female","age: 22<br />height: 67.48176<br />sex: female","age: 24<br />height: 61.52945<br />sex: female","age: 23<br />height: 66.87736<br />sex: female","age: 22<br />height: 58.71781<br />sex: female","age: 22<br />height: 64.22033<br />sex: female","age: 24<br />height: 58.40265<br />sex: female","age: 23<br />height: 70.76431<br />sex: female","age: 25<br />height: 60.19612<br />sex: female","age: 22<br />height: 60.62646<br />sex: female","age: 22<br />height: 65.59060<br />sex: female","age: 23<br />height: 66.89543<br />sex: female","age: 26<br />height: 63.65022<br />sex: female","age: 25<br />height: 62.66045<br />sex: female","age: 28<br />height: 65.73197<br />sex: female","age: 27<br />height: 64.17526<br />sex: female","age: 26<br />height: 61.02446<br />sex: female","age: 23<br />height: 66.69721<br />sex: female","age: 23<br />height: 66.81139<br />sex: female","age: 22<br />height: 64.90439<br />sex: female","age: 24<br />height: 69.27038<br />sex: female","age: 22<br />height: 65.55662<br />sex: female","age: 22<br />height: 65.31824<br />sex: female","age: 23<br />height: 60.84803<br />sex: female","age: 26<br />height: 65.56301<br />sex: female","age: 22<br />height: 63.18135<br />sex: female","age: 22<br />height: 57.21068<br />sex: female","age: 29<br />height: 64.49820<br />sex: female","age: 26<br />height: 61.57885<br />sex: female","age: 25<br />height: 63.07050<br />sex: female","age: 23<br />height: 69.48701<br />sex: female","age: 22<br />height: 67.80925<br />sex: female","age: 26<br />height: 66.53014<br />sex: female","age: 22<br />height: 64.69267<br />sex: female","age: 26<br />height: 63.47457<br />sex: female","age: 23<br />height: 68.75851<br />sex: female","age: 23<br />height: 67.39831<br />sex: female","age: 22<br />height: 62.43820<br />sex: female","age: 21<br />height: 69.38631<br />sex: female","age: 21<br />height: 63.14341<br />sex: female","age: 25<br />height: 71.53628<br />sex: female","age: 23<br />height: 69.63343<br />sex: female","age: 21<br />height: 68.57811<br />sex: female","age: 26<br />height: 66.98704<br />sex: female","age: 25<br />height: 67.78935<br />sex: female","age: 23<br />height: 67.98690<br />sex: female","age: 22<br />height: 62.98511<br />sex: female","age: 22<br />height: 67.08952<br />sex: female","age: 24<br />height: 68.38227<br />sex: female","age: 20<br />height: 64.35387<br />sex: female","age: 25<br />height: 61.15476<br />sex: female","age: 21<br />height: 63.23391<br />sex: female","age: 21<br />height: 63.46135<br />sex: female","age: 22<br />height: 65.56938<br />sex: female","age: 22<br />height: 60.13578<br />sex: female","age: 23<br />height: 64.78572<br />sex: female","age: 23<br />height: 66.42322<br />sex: female","age: 22<br />height: 64.53383<br />sex: female","age: 24<br />height: 65.26136<br />sex: female","age: 21<br />height: 60.77415<br />sex: female","age: 21<br />height: 62.12147<br />sex: female","age: 23<br />height: 61.92441<br />sex: female","age: 23<br />height: 69.22118<br />sex: female","age: 22<br />height: 65.44817<br />sex: female","age: 21<br />height: 61.72551<br />sex: female","age: 22<br />height: 63.09010<br />sex: female","age: 22<br />height: 71.00957<br />sex: female","age: 22<br />height: 66.35123<br />sex: female","age: 23<br />height: 68.50831<br />sex: female","age: 27<br />height: 56.36212<br />sex: female","age: 24<br />height: 68.27786<br />sex: female","age: 23<br />height: 71.14902<br />sex: female","age: 21<br />height: 70.95662<br />sex: female","age: 23<br />height: 62.83230<br />sex: female","age: 22<br />height: 57.85405<br />sex: female","age: 20<br />height: 64.91562<br />sex: female","age: 26<br />height: 63.27175<br />sex: female","age: 23<br />height: 70.61576<br />sex: female","age: 20<br />height: 64.21260<br />sex: female","age: 22<br />height: 61.59765<br />sex: female","age: 22<br />height: 60.60155<br />sex: female","age: 25<br />height: 66.71930<br />sex: female","age: 20<br />height: 60.68577<br />sex: female","age: 26<br />height: 68.07083<br />sex: female","age: 22<br />height: 67.73989<br />sex: female","age: 23<br />height: 69.26162<br />sex: female","age: 21<br />height: 66.53123<br />sex: female","age: 21<br />height: 62.74159<br />sex: female","age: 23<br />height: 69.33227<br />sex: female","age: 22<br />height: 69.15377<br />sex: female","age: 24<br />height: 62.07632<br />sex: female","age: 22<br />height: 63.74482<br />sex: female","age: 22<br />height: 62.52513<br />sex: female","age: 20<br />height: 72.61136<br />sex: female","age: 23<br />height: 56.36107<br />sex: female","age: 21<br />height: 66.59401<br />sex: female","age: 21<br />height: 72.06111<br />sex: female","age: 20<br />height: 67.31132<br />sex: female","age: 24<br />height: 61.92604<br />sex: female","age: 21<br />height: 61.76100<br />sex: female","age: 24<br />height: 66.45531<br />sex: female","age: 21<br />height: 62.56033<br />sex: female","age: 22<br />height: 72.22473<br />sex: female","age: 23<br />height: 66.36425<br />sex: female","age: 25<br />height: 66.82683<br />sex: female","age: 24<br />height: 70.28790<br />sex: female","age: 26<br />height: 63.73185<br />sex: female","age: 23<br />height: 66.86928<br />sex: female","age: 23<br />height: 60.38415<br />sex: female","age: 23<br />height: 71.98248<br />sex: female","age: 22<br />height: 69.19729<br />sex: female","age: 20<br />height: 66.99527<br />sex: female","age: 22<br />height: 61.64888<br />sex: female","age: 22<br />height: 67.67042<br />sex: female","age: 24<br />height: 69.04829<br />sex: female","age: 23<br />height: 73.06678<br />sex: female","age: 24<br />height: 66.62092<br />sex: female","age: 24<br />height: 65.97299<br />sex: female","age: 23<br />height: 61.68641<br />sex: female","age: 24<br />height: 67.93606<br />sex: female","age: 23<br />height: 67.40676<br />sex: female","age: 23<br />height: 67.65704<br />sex: female","age: 24<br />height: 66.47564<br />sex: female","age: 20<br />height: 64.72715<br />sex: female","age: 22<br />height: 65.46554<br />sex: female","age: 20<br />height: 69.13471<br />sex: female","age: 24<br />height: 64.92538<br />sex: female","age: 23<br />height: 66.27103<br />sex: female","age: 27<br />height: 59.40416<br />sex: female","age: 22<br />height: 69.10866<br />sex: female","age: 24<br />height: 66.29197<br />sex: female","age: 23<br />height: 63.47522<br />sex: female","age: 24<br />height: 61.75033<br />sex: female","age: 21<br />height: 63.45865<br />sex: female","age: 26<br />height: 67.56684<br />sex: female","age: 23<br />height: 65.75206<br />sex: female","age: 24<br />height: 58.43008<br />sex: female","age: 22<br />height: 64.85950<br />sex: female","age: 26<br />height: 62.08519<br />sex: female","age: 21<br />height: 67.39872<br />sex: female","age: 23<br />height: 59.44999<br />sex: female","age: 22<br />height: 68.99658<br />sex: female","age: 22<br />height: 68.60180<br />sex: female","age: 23<br />height: 66.72334<br />sex: female","age: 22<br />height: 59.67520<br />sex: female","age: 21<br />height: 65.85099<br />sex: female","age: 25<br />height: 64.93628<br />sex: female","age: 23<br />height: 70.76166<br />sex: female","age: 31<br />height: 60.82366<br />sex: female","age: 26<br />height: 65.05649<br />sex: female","age: 21<br />height: 66.54520<br />sex: female","age: 23<br />height: 65.66533<br />sex: female","age: 25<br />height: 66.21839<br />sex: female","age: 21<br />height: 65.33875<br />sex: female","age: 24<br />height: 61.39257<br />sex: female","age: 22<br />height: 68.44972<br />sex: female","age: 25<br />height: 65.78030<br />sex: female","age: 22<br />height: 60.71636<br />sex: female","age: 22<br />height: 61.38189<br />sex: female","age: 24<br />height: 65.40052<br />sex: female","age: 23<br />height: 61.05860<br />sex: female","age: 23<br />height: 61.76427<br />sex: female","age: 22<br />height: 61.33102<br />sex: female","age: 24<br />height: 68.49453<br />sex: female","age: 25<br />height: 58.31033<br />sex: female","age: 22<br />height: 61.53905<br />sex: female","age: 24<br />height: 63.03383<br />sex: female","age: 24<br />height: 58.71233<br />sex: female","age: 22<br />height: 70.83931<br />sex: female","age: 24<br />height: 66.70434<br />sex: female","age: 26<br />height: 63.27676<br />sex: female","age: 22<br />height: 66.23165<br />sex: female","age: 20<br />height: 62.36448<br />sex: female","age: 22<br />height: 65.77713<br />sex: female","age: 22<br />height: 69.70340<br />sex: female","age: 21<br />height: 61.73828<br />sex: female","age: 25<br />height: 63.58803<br />sex: female","age: 23<br />height: 62.96576<br />sex: female","age: 23<br />height: 72.47176<br />sex: female","age: 22<br />height: 66.29338<br />sex: female","age: 23<br />height: 64.36414<br />sex: female","age: 22<br />height: 60.51292<br />sex: female","age: 21<br />height: 66.76036<br />sex: female","age: 24<br />height: 65.85515<br />sex: female","age: 21<br />height: 65.14248<br />sex: female","age: 25<br />height: 63.09344<br />sex: female","age: 26<br />height: 61.84426<br />sex: female","age: 25<br />height: 59.47465<br />sex: female","age: 23<br />height: 69.15516<br />sex: female","age: 24<br />height: 67.31118<br />sex: female","age: 22<br />height: 63.50772<br />sex: female","age: 23<br />height: 67.20915<br />sex: female","age: 29<br />height: 61.12658<br />sex: female","age: 23<br />height: 69.17072<br />sex: female","age: 21<br />height: 66.09045<br />sex: female","age: 25<br />height: 60.49578<br />sex: female","age: 22<br />height: 65.46699<br />sex: female","age: 20<br />height: 66.33186<br />sex: female","age: 21<br />height: 66.04607<br />sex: female","age: 22<br />height: 61.58801<br />sex: female","age: 21<br />height: 61.31300<br />sex: female","age: 24<br />height: 62.39573<br />sex: female","age: 23<br />height: 69.32655<br />sex: female","age: 22<br />height: 69.94830<br />sex: female","age: 22<br />height: 63.86324<br />sex: female","age: 25<br />height: 65.87897<br />sex: female","age: 23<br />height: 66.30378<br />sex: female","age: 22<br />height: 67.77857<br />sex: female","age: 24<br />height: 61.39629<br />sex: female","age: 30<br />height: 70.03040<br />sex: female","age: 23<br />height: 60.88723<br />sex: female","age: 23<br />height: 66.97727<br />sex: female","age: 22<br />height: 67.47263<br />sex: female","age: 24<br />height: 65.28722<br />sex: female","age: 22<br />height: 66.73797<br />sex: female","age: 21<br />height: 65.99925<br />sex: female","age: 25<br />height: 61.43730<br />sex: female","age: 22<br />height: 69.24104<br />sex: female","age: 23<br />height: 68.26380<br />sex: female","age: 23<br />height: 70.05701<br />sex: female","age: 22<br />height: 68.41486<br />sex: female","age: 22<br />height: 70.73646<br />sex: female","age: 22<br />height: 62.48215<br />sex: female","age: 24<br />height: 61.02020<br />sex: female","age: 21<br />height: 67.58849<br />sex: female","age: 27<br />height: 62.70551<br />sex: female","age: 24<br />height: 62.57791<br />sex: female","age: 22<br />height: 60.03445<br />sex: female","age: 21<br />height: 65.02370<br />sex: female","age: 21<br />height: 71.21428<br />sex: female","age: 22<br />height: 57.75220<br />sex: female","age: 25<br />height: 62.73198<br />sex: female","age: 22<br />height: 68.51825<br />sex: female","age: 25<br />height: 65.83040<br />sex: female","age: 21<br />height: 60.83998<br />sex: female","age: 22<br />height: 63.24817<br />sex: female","age: 23<br />height: 66.03309<br />sex: female","age: 20<br />height: 52.92655<br />sex: female","age: 23<br />height: 68.56894<br />sex: female","age: 23<br />height: 61.98289<br />sex: female","age: 22<br />height: 66.20001<br />sex: female","age: 23<br />height: 58.44737<br />sex: female","age: 21<br />height: 61.56944<br />sex: female","age: 21<br />height: 64.27438<br />sex: female","age: 26<br />height: 68.76723<br />sex: female","age: 22<br />height: 63.86990<br />sex: female","age: 24<br />height: 63.93310<br />sex: female","age: 23<br />height: 67.62701<br />sex: female","age: 22<br />height: 67.60200<br />sex: female","age: 24<br />height: 68.12447<br />sex: female","age: 26<br />height: 66.36189<br />sex: female","age: 23<br />height: 59.91829<br />sex: female","age: 21<br />height: 70.92977<br />sex: female","age: 22<br />height: 64.18124<br />sex: female","age: 23<br />height: 65.16804<br />sex: female","age: 25<br />height: 65.42828<br />sex: female","age: 20<br />height: 70.23691<br />sex: female","age: 25<br />height: 68.15797<br />sex: female","age: 21<br />height: 62.26752<br />sex: female","age: 25<br />height: 68.07623<br />sex: female","age: 23<br />height: 66.51196<br />sex: female","age: 21<br />height: 59.33082<br />sex: female","age: 22<br />height: 66.30881<br />sex: female","age: 24<br />height: 62.17384<br />sex: female","age: 23<br />height: 64.95246<br />sex: female","age: 22<br />height: 64.07453<br />sex: female","age: 22<br />height: 63.17759<br />sex: female","age: 22<br />height: 59.01873<br />sex: female","age: 24<br />height: 68.35327<br />sex: female","age: 23<br />height: 73.58278<br />sex: female","age: 23<br />height: 69.75635<br />sex: female","age: 22<br />height: 61.71744<br />sex: female","age: 25<br />height: 67.84093<br />sex: female","age: 23<br />height: 69.50378<br />sex: female","age: 23<br />height: 64.33396<br />sex: female","age: 22<br />height: 66.95481<br />sex: female","age: 21<br />height: 68.12425<br />sex: female","age: 21<br />height: 69.20345<br />sex: female","age: 26<br />height: 67.94940<br />sex: female","age: 24<br />height: 69.47327<br />sex: female","age: 25<br />height: 62.08654<br />sex: female","age: 20<br />height: 63.67415<br />sex: female","age: 22<br />height: 67.62026<br />sex: female","age: 26<br />height: 66.24139<br />sex: female","age: 27<br />height: 62.80227<br />sex: female","age: 23<br />height: 63.10923<br />sex: female","age: 23<br />height: 66.30741<br />sex: female","age: 20<br />height: 70.09936<br />sex: female","age: 20<br />height: 65.52809<br />sex: female","age: 26<br />height: 68.22370<br />sex: female","age: 25<br />height: 62.53449<br />sex: female","age: 24<br />height: 63.52896<br />sex: female","age: 29<br />height: 66.56253<br />sex: female","age: 21<br />height: 65.96657<br />sex: female","age: 24<br />height: 63.89714<br />sex: female","age: 24<br />height: 56.16533<br />sex: female","age: 26<br />height: 57.88690<br />sex: female","age: 22<br />height: 66.34623<br />sex: female","age: 23<br />height: 64.41253<br />sex: female","age: 24<br />height: 64.61096<br />sex: female","age: 23<br />height: 61.03843<br />sex: female","age: 25<br />height: 61.58208<br />sex: female","age: 24<br />height: 63.44461<br />sex: female","age: 23<br />height: 67.12219<br />sex: female","age: 22<br />height: 60.46950<br />sex: female","age: 22<br />height: 67.71909<br />sex: female","age: 23<br />height: 59.94117<br />sex: female","age: 24<br />height: 62.28850<br />sex: female","age: 24<br />height: 62.52809<br />sex: female","age: 24<br />height: 55.86397<br />sex: female","age: 25<br />height: 65.03761<br />sex: female","age: 21<br />height: 65.93165<br />sex: female","age: 24<br />height: 60.89666<br />sex: female","age: 25<br />height: 65.86787<br />sex: female","age: 22<br />height: 73.16121<br />sex: female","age: 21<br />height: 64.70361<br />sex: female","age: 22<br />height: 65.60850<br />sex: female","age: 24<br />height: 65.81906<br />sex: female","age: 21<br />height: 65.53660<br />sex: female","age: 23<br />height: 71.34605<br />sex: female","age: 21<br />height: 67.06855<br />sex: female","age: 23<br />height: 62.86099<br />sex: female","age: 21<br />height: 59.02261<br />sex: female","age: 21<br />height: 67.03924<br />sex: female","age: 24<br />height: 70.88571<br />sex: female","age: 23<br />height: 56.25252<br />sex: female","age: 24<br />height: 65.08938<br />sex: female","age: 23<br />height: 65.04425<br />sex: female","age: 24<br />height: 60.66621<br />sex: female","age: 22<br />height: 63.87207<br />sex: female","age: 21<br />height: 61.92312<br />sex: female","age: 30<br />height: 67.34434<br />sex: female","age: 21<br />height: 58.64133<br />sex: female","age: 22<br />height: 63.54918<br />sex: female","age: 20<br />height: 68.33904<br />sex: female","age: 21<br />height: 64.17044<br />sex: female","age: 25<br />height: 59.73453<br />sex: female","age: 23<br />height: 61.77815<br />sex: female","age: 27<br />height: 64.93697<br />sex: female","age: 25<br />height: 63.37476<br />sex: female","age: 22<br />height: 63.50795<br />sex: female","age: 23<br />height: 63.19888<br />sex: female","age: 21<br />height: 64.75061<br />sex: female","age: 25<br />height: 64.40670<br />sex: female","age: 20<br />height: 65.68821<br />sex: female","age: 25<br />height: 69.36737<br />sex: female","age: 24<br />height: 66.74659<br />sex: female","age: 23<br />height: 65.69244<br />sex: female","age: 23<br />height: 70.42788<br />sex: female","age: 22<br />height: 65.81566<br />sex: female","age: 23<br />height: 63.88604<br />sex: female","age: 23<br />height: 61.54952<br />sex: female","age: 21<br />height: 64.77824<br />sex: female","age: 24<br />height: 65.84842<br />sex: female","age: 21<br />height: 66.29119<br />sex: female","age: 23<br />height: 72.83146<br />sex: female","age: 24<br />height: 65.90707<br />sex: female","age: 23<br />height: 63.73281<br />sex: female","age: 23<br />height: 62.36095<br />sex: female","age: 26<br />height: 65.12892<br />sex: female","age: 24<br />height: 70.61884<br />sex: female","age: 22<br />height: 64.10058<br />sex: female","age: 21<br />height: 58.79164<br />sex: female","age: 24<br />height: 63.61931<br />sex: female","age: 23<br />height: 61.04814<br />sex: female","age: 23<br />height: 59.40499<br />sex: female","age: 23<br />height: 68.23553<br />sex: female","age: 24<br />height: 60.16809<br />sex: female","age: 26<br />height: 68.60716<br />sex: female","age: 26<br />height: 67.21557<br />sex: female","age: 26<br />height: 68.96606<br />sex: female","age: 22<br />height: 65.85091<br />sex: female","age: 21<br />height: 61.38085<br />sex: female","age: 25<br />height: 62.95868<br />sex: female","age: 27<br />height: 64.06405<br />sex: female","age: 22<br />height: 60.57883<br />sex: female","age: 21<br />height: 60.90474<br />sex: female","age: 25<br />height: 67.45460<br />sex: female","age: 26<br />height: 70.71138<br />sex: female","age: 23<br />height: 64.17980<br />sex: female","age: 27<br />height: 67.27049<br />sex: female","age: 23<br />height: 68.35906<br />sex: female","age: 21<br />height: 65.36797<br />sex: female","age: 22<br />height: 65.56405<br />sex: female","age: 25<br />height: 67.17802<br />sex: female","age: 24<br />height: 63.67339<br />sex: female","age: 23<br />height: 60.34014<br />sex: female","age: 25<br />height: 66.42579<br />sex: female","age: 21<br />height: 62.21947<br />sex: female","age: 26<br />height: 65.66750<br />sex: female","age: 24<br />height: 64.63983<br />sex: female","age: 21<br />height: 66.84524<br />sex: female","age: 23<br />height: 65.10710<br />sex: female","age: 28<br />height: 67.50836<br />sex: female","age: 24<br />height: 61.32460<br />sex: female","age: 22<br />height: 69.97547<br />sex: female","age: 25<br />height: 67.52893<br />sex: female","age: 24<br />height: 70.19719<br />sex: female","age: 27<br />height: 70.54475<br />sex: female","age: 26<br />height: 61.59880<br />sex: female","age: 21<br />height: 62.88248<br />sex: female","age: 22<br />height: 72.09034<br />sex: female","age: 23<br />height: 69.42439<br />sex: female","age: 25<br />height: 63.11474<br />sex: female","age: 22<br />height: 65.99540<br />sex: female","age: 21<br />height: 66.83877<br />sex: female","age: 22<br />height: 60.80295<br />sex: female","age: 22<br />height: 68.29027<br />sex: female","age: 21<br />height: 67.44436<br />sex: female","age: 21<br />height: 65.59032<br />sex: female","age: 22<br />height: 62.95633<br />sex: female","age: 21<br />height: 59.21339<br />sex: female","age: 22<br />height: 67.62323<br />sex: female","age: 24<br />height: 62.02124<br />sex: female","age: 22<br />height: 70.54566<br />sex: female","age: 24<br />height: 66.49490<br />sex: female","age: 24<br />height: 60.99134<br />sex: female","age: 24<br />height: 68.01404<br />sex: female","age: 22<br />height: 55.56918<br />sex: female","age: 26<br />height: 63.32386<br />sex: female","age: 23<br />height: 64.16342<br />sex: female","age: 23<br />height: 64.48950<br />sex: female","age: 24<br />height: 66.90918<br />sex: female","age: 24<br />height: 65.14455<br />sex: female"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(248,118,109,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"female","legendgroup":"female","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[21.1222907289863,24.1182785309851,24.8900542478077,21.1594005443156,20.9707690309733,24.0953846756369,22.9170589752495,25.0911040525883,24.0695630165748,20.9807914173231,22.1658449077979,20.1551239631139,24.1318370012566,21.144680589065,22.954436277505,25.0926492178813,24.0353319018148,24.0014961355366,23.8914887169376,26.9103474101983,23.8921170053072,23.9406572598964,23.8367800261825,22.9427406268194,22.1414137908258,24.0599311925471,24.1835011179559,23.8961122266948,21.9499010677449,22.087237931136,20.8844165626913,19.9622368616983,24.0293016224168,20.8615513788536,19.8096681958996,22.9066301347688,24.841982134711,26.0027274171822,21.8335390861146,24.8741052524187,20.9917066464201,22.0000979824923,22.1427860944532,19.9038536022417,21.8816226375289,22.0638134128414,21.8690338460729,21.9859879741445,21.0337766250595,23.9094414862804,22.9489552699029,20.9618034986779,24.1179987805896,22.0806258375756,24.0384663905017,19.9479529861361,20.8453783363104,20.995880868379,22.867201251816,20.0618288024329,23.815073759947,23.1093776790425,25.9130210833624,22.944158064574,23.002980347909,23.1029653787613,23.9609568331391,21.0009546022862,20.8474689493887,21.8987384367734,24.0045055602677,23.927939180471,24.1091269526631,24.897367246449,21.0412136349827,23.9559982107021,24.0626870396547,23.8983378237113,24.8458303787746,22.9091581269167,21.8136362858117,24.1733502070419,21.1299129254185,24.0070027227513,24.098613113258,22.0555832339451,22.1456797284074,25.0529694456607,25.9823980281129,23.9812952831388,21.9118331369944,23.0786015952937,21.135675388854,23.1595338989981,22.0043636958115,23.1489132860675,24.0577937441878,27.0327816504985,21.090778523311,23.1977513758466,24.9716614246368,23.8515710368752,20.9856051241979,26.1970703173429,20.1907123983838,21.1677499367855,22.1552803484723,25.9156258921139,23.1673320400529,23.9268624403514,24.9708363028243,24.0432856639847,25.0980309119448,22.1627862136811,24.1897213692777,22.0308093178086,22.8691531701013,19.9667939874344,24.1035075416788,21.1337877112441,21.0278349066153,24.0161426092498,24.8112253486179,24.1025563834235,22.960071978718,21.8381433521397,23.1356576834805,25.9997305327095,23.9722349891439,22.1640623269603,24.1096097596921,20.1916563103907,21.1682870567776,22.0241221367381,22.8160569900647,20.8750322703272,23.1489420957863,24.1315197804943,19.951723872032,24.0957267087884,19.9404422546737,20.1682197594084,25.1942371215671,23.1277010076679,22.8370006295852,22.1540088624693,21.9665812633,22.1420665831305,23.108412168175,22.0567350721918,24.1346287140623,23.9473281532526,25.0501516374759,23.9098869825713,20.9122325753793,24.0986055721529,27.0417863566428,21.9041740313172,22.8937119512819,22.8203578907065,24.9320750548504,23.0624368305318,20.9587215838023,23.9311362268403,24.1186751438305,23.0573482591659,19.9372252879664,24.1357472991571,25.0302603406832,23.9190962447785,25.9412907769904,24.9315729685128,21.8578914911486,24.0771028718911,22.0452935113572,22.8463941005059,22.1704318484291,20.915228341613,24.8675797933713,21.1221055751666,22.032516727224,24.1704587129876,23.9479016914964,26.0814327438362,23.0934548486955,20.8104653937742,23.1990351283923,21.8087408686057,25.1768662711605,24.0942980279215,24.9647458296269,23.8486948951148,24.1450042258948,24.95227137357,20.8074703462422,20.971880793944,23.8751362068579,20.1629533895291,24.0021917736158,21.9445942358114,22.8231809189543,23.0571831359528,24.1229014467448,23.1104440288618,23.1049294857308,25.9294199662283,22.0882704173215,23.127481277287,21.8550810961053,22.0837403345853,27.8998550582677,23.0494387773797,23.0533125237562,22.8902858785354,21.9987124258652,22.9443745691329,22.8278176965192,24.9334201642312,22.1992535300553,22.1866002489813,25.147589520365,24.1508712827228,23.9871269876137,23.011339443177,21.9979084846564,25.1807793636806,20.8448716608807,22.1076884515584,22.9110006808303,25.8493130035698,22.9287715371698,23.0464085808955,21.8923912813887,26.8693974680267,24.9589988371357,21.0983224085532,21.9830608393066,20.8137733723037,23.8412847002968,22.8130665302277,23.8241343883798,22.0330257850699,26.9769532348029,27.8280926831067,20.1471524215303,27.9254632028751,23.8718949072994,22.0490038561635,23.1440559173934,21.0367192340083,21.8272479383275,24.0577409230173,20.8086847055703,21.8215295848437,23.0573647769168,24.1982874298468,28.1373979170807,21.0108870340511,24.9709293978289,21.9718274590559,26.1580297170207,23.9800304821692,23.0365307218395,29.0628444528207,21.8579088277183,23.1569399522617,23.0958625903353,21.0369630577974,25.9039884236641,21.8702459236607,23.9991262021475,20.972670673579,20.8810316273943,23.9723279846832,20.113482416328,24.9057753602043,23.1640697835945,21.8352546176873,20.001447961852,23.1293753195554,27.0907527619041,19.9209721936844,22.0106566228904,22.0622524918057,21.1126624840312,26.0328303371556,22.011516935192,20.9449953897856,22.0002571862191,22.0863348999992,20.8494882595725,22.0104888218455,22.8030421248637,25.1217866460793,21.8737124294043,25.1104539627209,22.0125566940755,21.9812869877554,23.0212073122151,23.1832501978613,24.1012715117075,20.1727253627963,24.1794225948863,22.0020274855196,19.9138016495854,22.8706342520192,24.9786984495819,21.9205452596769,21.8736717141233,21.0841235727072,28.1777414754033,23.1618025458418,22.9606900306419,21.8054174817167,21.8792517323047,20.1697329175659,21.9860026108101,25.9398113397881,25.8496067052707,22.8473053393885,23.1218187381513,26.1967740871944,22.8728954734281,23.9544598223642,23.0201588629745,22.0785465151072,20.8731865153648,20.8481876374222,23.916348033119,21.0106040819548,22.0287967362441,24.1289568219334,23.0273477410898,27.8010166017339,22.976385004539,21.8073006357998,21.0059908932075,22.9442099913955,23.1976868575439,22.9299898573197,25.1093625021167,23.9716305250302,24.153695004154,22.9407366076484,23.8593178383075,26.1817686330527,23.0397713591345,22.9686597966589,24.1650661481544,24.0964324790053,21.1024113928899,21.8588904179633,20.8815546803176,22.0235724646598,21.8904254220426,22.1314822801389,23.1745760311373,21.8428190621547,20.8635135402903,22.1002568565309,22.1235899241641,23.1716865359806,25.9223149618134,22.9892387729138,23.0378542568535,22.8616055882536,21.011150624603,24.8889080660418,20.1993545169011,20.827529416047,25.9381898042746,21.9051569829695,23.1567977160215,24.9718346319161,22.9832132194191,23.176962263789,23.1431346757337,20.8360324175097,21.1958007254638,22.0968099862337,22.1229650242254,25.9512367668562,25.0269400382414,21.8825493638404,24.1644993099384,20.1459125749767,22.8798464399762,21.1580166137777,23.8803540430032,23.0478289840743,20.1018484308384,20.8599933674559,24.8860112993978,25.9239340055734,28.8361990468577,22.1891348755918,23.9359839668497,25.1637778691947,23.1632381688803,22.1379023136571,22.0521071045659,22.1358671240509,21.9682710522786,22.1044660867192,21.050824812986,23.0983130307868,21.8136731836945,23.1829453507438,23.0565288721584,22.8104856225662,21.1447889077477,21.1810323495418,22.892577653937,21.0453948142938,23.9668854431249,27.1498990864493,21.8528259502724,20.8187878368422,23.0316839179955,20.824912036676,21.0769525048323,25.9360401923768,22.808874309808,21.142503590975,22.8254987658933,22.943025729619,20.9314251205884,25.1175350754522,19.8350898059085,26.0259836370125,23.9850133686326,22.1346859635785,21.1480338528752,24.1389561400749,20.9036032710224,24.0542397908866,25.1989953037351,22.8892221922986,27.0009888377972,22.1065764768049,23.8210194310173,20.9099281496368,22.9267310136929,23.1059441735968,24.8679260464385,22.8160838621669,21.9311493408866,23.0111451033503,21.8580359070562,22.1561396162026,22.8239037613384,22.1889110217802,22.9984448102303,24.0011981934309,23.9456719920039,24.0141321583651,19.9332220964134,24.0579101816751,25.9353615969419,22.1051620531827,26.0415591873229,22.8181452332996,24.0645458194427,22.9871484584175,19.8974979825318,21.8399904158898,20.9038074053824,21.9335337121971,21.9285601535812,20.1297986824997,25.8648176175542,24.1206337703392,22.019175794255,23.1632128953934,20.9338079339825,24.1171729142778,23.9996176470071,25.0175497435965,26.1873900383711,23.9618431126699,22.1646525638178,23.9444521490484,21.8677794209681,23.0187604399398,20.9185191461816,22.0062909482978,23.1522969127633,20.8795801913366,21.8995670154691,21.9555535478517,23.8934495003894,25.1002853689715,21.055919847358,26.1231685022824,26.0859096109867,25.0990155990236,23.1693904742599,23.9797124050558,24.8863140461035,23.1915848420002],"y":[70.5395921519968,70.4703284230211,66.6976434870749,61.4590549412504,70.856834102679,66.2117277201776,67.3934382015604,72.914813061398,74.1991124765939,70.4078685582542,76.3879656216392,72.2563361298491,69.3785531433695,65.2981307205613,69.4314112890391,73.6031319467763,71.4327077939245,66.3259116331949,64.7119059866415,70.9112000407893,68.6085841490357,75.2028980668787,69.101410370682,59.6125368016701,66.3130697888895,75.8751390730698,66.2421567547407,66.5965461018374,76.6437348990336,64.5698957795468,70.3440195215044,75.006313049284,72.4404840834532,70.0815434210965,72.8901592478504,65.566290701444,73.0791335620336,74.1084833983999,70.2917080763516,64.7421024653888,70.7789741699404,72.3662309325338,66.2958829623892,66.8503858348155,72.3471068880387,72.1582370893685,74.3479429784922,70.5240712329135,68.4272692081085,78.0827657800121,72.9781507106016,64.6134879678085,71.3205700400047,69.9490986952778,68.145296158837,70.819768361315,71.8559002254791,66.9731363967989,65.7378385336312,68.9485930936533,63.3010990916441,71.1044253358063,67.8851840543261,74.6225575905648,72.8630033400634,71.6915785994456,69.1207419494158,76.7545726825857,69.5532601120988,65.9195099061415,75.9819027369215,67.2404662573037,75.519136071353,65.3271329673405,71.2100426397387,71.5995168533962,69.9806771321713,74.8193848734622,72.3839229614589,68.019455267541,72.6319052795009,73.0809123763429,67.1583489046621,67.1786334506238,73.4717381168959,68.0974999803539,69.7942215327425,70.1506782851866,69.720189172956,68.0519979448533,67.2070420257121,63.2050125926478,73.9653967821779,66.1681391907057,67.982371924919,69.3781830694953,74.6766003325438,72.1338444320087,75.2733365671879,71.0558276628166,68.723535283092,73.6585501220335,75.6909623179782,65.6035951161424,67.5811498052376,65.0897388341139,61.6384594197511,66.2635892279449,71.1839357727763,68.4060135591823,73.6628562492225,72.9169540239753,68.2402982739553,68.9545167070014,59.6054202894206,65.0217613556919,65.8635191375531,71.6542890875943,65.6688267529823,74.0382230588828,61.5487673602571,72.4431840165982,72.8430024546629,70.8504710883826,75.9696199361964,71.6385062530287,67.8177374945165,71.7193222479135,66.3566301108386,65.9223553625357,77.6585152505784,75.7612646878459,70.6652627385824,63.5783315857711,69.729038600325,70.0059424867031,60.0433644583693,66.6913372322568,62.3876961436375,73.9596592691963,70.9594316896802,62.9257166338926,70.5828131939061,71.7851696928001,72.3666549780056,74.0243838784593,73.3451986542198,71.8229106454941,72.2464707941611,75.9400371826635,69.6465409585697,70.32456143763,75.5525809937399,69.9063575131955,73.9503707580557,69.4212145887194,67.5861937598892,69.2408173577083,73.4905150341775,65.1905039477874,70.8253248147986,68.8542617170858,81.4779667279632,65.1786134783999,68.3794703425938,71.0085349340688,78.4687156066658,68.8758523644281,72.5853233924829,61.1884481472833,71.5487982985312,74.1207253808603,72.0659479135835,70.3914654792406,69.7092715503211,69.944973851454,59.108723906255,71.6476535090217,74.9264987172754,76.3612257051848,67.9590708180067,75.347538593874,66.4379829357056,63.7864393344909,75.4851979557994,67.5645628607752,70.2194993735001,65.5177648411112,75.6804953834372,74.4561078869077,71.9424493750373,69.7027128203556,67.0777665585355,74.115597612016,63.3560368295573,66.3281216687322,64.5136033581904,73.7069053375661,67.0098573151468,65.8829950180285,68.6691026729228,69.3052616510925,69.2502474796321,74.6252887610697,66.2472234721913,72.0962093128851,69.4876532057445,62.6947512870257,72.130663135386,70.1617602172504,74.0645630803218,71.0890879482252,73.9988830880873,76.4116113943193,69.8818791577762,68.4104602875432,69.6167467654083,66.6794831990504,72.4556095433682,70.2378671697195,63.2872151005526,71.87020718884,62.5578095132447,73.4522024284449,66.0248529066906,68.0592112571599,72.070728961559,68.5809545141914,69.2302502581578,77.6421795124863,77.247787607223,71.3064328435552,69.8765525194051,71.3190929575159,67.12297325187,69.3322388190921,60.4398067891956,67.1463096745339,68.1242792500244,70.8734352121427,68.0609471074055,76.7003133854202,69.4914375879351,65.7909240208346,72.9053499641479,66.8961953861272,65.4510655498753,74.0533811584848,69.1558332598084,69.368728180867,71.0599022157985,74.1446463019161,67.890446930578,70.1032604347221,70.8861832539774,74.0064470701571,75.1672005670581,73.9093864249248,69.0324945947373,69.9904777810148,72.4263033686659,71.5851144831612,70.7658010194516,69.1647871762057,72.7246356690369,68.1478922269567,77.520019494172,68.6967940020372,65.8606516615696,65.2618178577532,70.0331671033655,69.8271225521393,67.9498407392648,67.2417017099275,72.6670357015568,60.3795387856821,72.853472217354,68.670373880587,73.6701973403661,72.9585794514156,71.6575180512327,71.4875382109592,67.4900282643688,65.8508293269,69.5791900864401,71.742797141856,60.4628602892649,65.7062448973142,64.8481660445764,68.8544884293219,61.4284303981808,68.1028144963905,65.0559603889104,72.9547827231508,70.915031591877,69.0608355047267,68.3074379120422,68.1673421327489,70.2144502132372,70.3980982438176,74.1038711030988,68.4301590529065,74.9071715248926,72.1984996202757,71.6064359818476,68.125378155938,71.9123264836831,71.3081468473042,65.0622748458826,65.1849374789936,71.3561606544176,65.1822484059173,59.5690869711618,77.4742830813237,69.9692552554897,67.6633483054409,75.1756617676793,66.3789695252515,76.1164731531802,73.3601044260977,67.7216429999552,70.1912210333098,71.6486397785041,71.7345567175257,67.8992539487065,70.6573232477731,66.7057250620286,66.7369360454789,70.9586784940743,57.0502456895781,71.9818585963087,69.9970784899674,72.9463792863778,75.7738192379706,70.5065965598065,67.2832345766656,74.7096765525827,71.1257350365327,67.7028954837165,76.3961784582278,65.0358585386161,62.8937068834932,74.004118338677,70.9609181459,65.5190270923297,63.1038190542566,65.4008959105544,64.9031099998601,69.5609705247373,65.7684330588625,70.5971115926483,69.2480646768013,73.3262392893681,65.7423324042782,75.5989050788224,71.6478053499388,66.9385119304412,73.7077061775052,65.6552068130223,70.2845145892819,68.7418060055099,70.4684283661104,63.0101408854304,69.5161760945508,70.7009836480497,68.8260420045261,75.7089669315338,67.0317087101431,70.3608608658216,70.2847873089634,66.0548284009002,69.2321824675956,80.1105494022746,63.5516021684905,75.1455468669519,66.0143885284915,68.735462608628,73.2437669999248,68.3382527522145,71.0308183416449,68.2327068898496,63.0650343802635,70.9533209417935,78.0402386224221,74.0328857005,67.7796427171972,67.0391614866205,64.9163796198217,66.7393080223227,64.4883774542622,78.1867262697418,68.0203578186592,68.5908174732203,74.4013732385104,61.645620645761,68.5249089480622,69.5564741109283,68.5785757312099,67.8985677524273,71.9268170839246,74.0972078472445,67.9345770066361,64.7380138686503,68.4242546768652,70.4385804909302,66.579115736976,69.8787807021199,70.8905649058543,68.8268030711356,68.918001975895,72.0499649451244,67.7478477959484,62.2949705751102,70.0079157985787,75.6108601110597,62.6070853141089,61.4173758319548,63.0944049479282,67.2625603782911,65.6062981230161,64.6326376738481,78.9005643628478,77.3011801984063,64.2048649286522,75.5631661568074,71.1568984596937,69.7956788074985,83.6511776355544,70.5010200424683,68.6254987406205,66.8967784514299,69.0975364675583,71.6296142275677,72.6039406580438,69.9977669596635,71.4341592275042,72.5018153517973,75.0034572906814,73.7756831432387,67.1727373671853,69.7736835071244,71.4692724923692,68.4257930751506,64.2705623543212,67.376393624203,65.398533709306,74.605925299298,68.8416758673486,78.3718224486868,59.3614172122588,68.4350964377183,78.8508894633335,63.749636023561,66.9188097417284,67.7811766267186,75.6420080913912,68.0391855544562,70.2881179684953,71.5513696993704,66.0516140445973,58.8823100756757,72.0281481074839,77.0290729092345,68.3652455412541,70.1735136475975,74.6884632825852,71.048704192089,78.5503083466656,75.0771052688384,69.1072689143656,76.114153204506,71.8087206579182,76.7916977490934,74.0628537586809,74.2546381762435,72.8817402890437,78.9542582807897,70.923440262332,71.064519946772,71.2229947677802,59.062947425731,68.2051600265487,71.5595489318386,65.8324774005498,65.2947376042417,82.4891084135306,71.1295860935581,71.7017805208918,75.0491716441244,69.3840398874287,65.6969573854079,64.0197709315521,68.6419902521141,71.8188026980284,68.1135816339132,64.5323161735948,68.2280599985563,71.5349073099244,68.2301439111545,76.595053430715],"text":["age: 21<br />height: 70.53959<br />sex: male","age: 24<br />height: 70.47033<br />sex: male","age: 25<br />height: 66.69764<br />sex: male","age: 21<br />height: 61.45905<br />sex: male","age: 21<br />height: 70.85683<br />sex: male","age: 24<br />height: 66.21173<br />sex: male","age: 23<br />height: 67.39344<br />sex: male","age: 25<br />height: 72.91481<br />sex: male","age: 24<br />height: 74.19911<br />sex: male","age: 21<br />height: 70.40787<br />sex: male","age: 22<br />height: 76.38797<br />sex: male","age: 20<br />height: 72.25634<br />sex: male","age: 24<br />height: 69.37855<br />sex: male","age: 21<br />height: 65.29813<br />sex: male","age: 23<br />height: 69.43141<br />sex: male","age: 25<br />height: 73.60313<br />sex: male","age: 24<br />height: 71.43271<br />sex: male","age: 24<br />height: 66.32591<br />sex: male","age: 24<br />height: 64.71191<br />sex: male","age: 27<br />height: 70.91120<br />sex: male","age: 24<br />height: 68.60858<br />sex: male","age: 24<br />height: 75.20290<br />sex: male","age: 24<br />height: 69.10141<br />sex: male","age: 23<br />height: 59.61254<br />sex: male","age: 22<br />height: 66.31307<br />sex: male","age: 24<br />height: 75.87514<br />sex: male","age: 24<br />height: 66.24216<br />sex: male","age: 24<br />height: 66.59655<br />sex: male","age: 22<br />height: 76.64373<br />sex: male","age: 22<br />height: 64.56990<br />sex: male","age: 21<br />height: 70.34402<br />sex: male","age: 20<br />height: 75.00631<br />sex: male","age: 24<br />height: 72.44048<br />sex: male","age: 21<br />height: 70.08154<br />sex: male","age: 20<br />height: 72.89016<br />sex: male","age: 23<br />height: 65.56629<br />sex: male","age: 25<br />height: 73.07913<br />sex: male","age: 26<br />height: 74.10848<br />sex: male","age: 22<br />height: 70.29171<br />sex: male","age: 25<br />height: 64.74210<br />sex: male","age: 21<br />height: 70.77897<br />sex: male","age: 22<br />height: 72.36623<br />sex: male","age: 22<br />height: 66.29588<br />sex: male","age: 20<br />height: 66.85039<br />sex: male","age: 22<br />height: 72.34711<br />sex: male","age: 22<br />height: 72.15824<br />sex: male","age: 22<br />height: 74.34794<br />sex: male","age: 22<br />height: 70.52407<br />sex: male","age: 21<br />height: 68.42727<br />sex: male","age: 24<br />height: 78.08277<br />sex: male","age: 23<br />height: 72.97815<br />sex: male","age: 21<br />height: 64.61349<br />sex: male","age: 24<br />height: 71.32057<br />sex: male","age: 22<br />height: 69.94910<br />sex: male","age: 24<br />height: 68.14530<br />sex: male","age: 20<br />height: 70.81977<br />sex: male","age: 21<br />height: 71.85590<br />sex: male","age: 21<br />height: 66.97314<br />sex: male","age: 23<br />height: 65.73784<br />sex: male","age: 20<br />height: 68.94859<br />sex: male","age: 24<br />height: 63.30110<br />sex: male","age: 23<br />height: 71.10443<br />sex: male","age: 26<br />height: 67.88518<br />sex: male","age: 23<br />height: 74.62256<br />sex: male","age: 23<br />height: 72.86300<br />sex: male","age: 23<br />height: 71.69158<br />sex: male","age: 24<br />height: 69.12074<br />sex: male","age: 21<br />height: 76.75457<br />sex: male","age: 21<br />height: 69.55326<br />sex: male","age: 22<br />height: 65.91951<br />sex: male","age: 24<br />height: 75.98190<br />sex: male","age: 24<br />height: 67.24047<br />sex: male","age: 24<br />height: 75.51914<br />sex: male","age: 25<br />height: 65.32713<br />sex: male","age: 21<br />height: 71.21004<br />sex: male","age: 24<br />height: 71.59952<br />sex: male","age: 24<br />height: 69.98068<br />sex: male","age: 24<br />height: 74.81938<br />sex: male","age: 25<br />height: 72.38392<br />sex: male","age: 23<br />height: 68.01946<br />sex: male","age: 22<br />height: 72.63191<br />sex: male","age: 24<br />height: 73.08091<br />sex: male","age: 21<br />height: 67.15835<br />sex: male","age: 24<br />height: 67.17863<br />sex: male","age: 24<br />height: 73.47174<br />sex: male","age: 22<br />height: 68.09750<br />sex: male","age: 22<br />height: 69.79422<br />sex: male","age: 25<br />height: 70.15068<br />sex: male","age: 26<br />height: 69.72019<br />sex: male","age: 24<br />height: 68.05200<br />sex: male","age: 22<br />height: 67.20704<br />sex: male","age: 23<br />height: 63.20501<br />sex: male","age: 21<br />height: 73.96540<br />sex: male","age: 23<br />height: 66.16814<br />sex: male","age: 22<br />height: 67.98237<br />sex: male","age: 23<br />height: 69.37818<br />sex: male","age: 24<br />height: 74.67660<br />sex: male","age: 27<br />height: 72.13384<br />sex: male","age: 21<br />height: 75.27334<br />sex: male","age: 23<br />height: 71.05583<br />sex: male","age: 25<br />height: 68.72354<br />sex: male","age: 24<br />height: 73.65855<br />sex: male","age: 21<br />height: 75.69096<br />sex: male","age: 26<br />height: 65.60360<br />sex: male","age: 20<br />height: 67.58115<br />sex: male","age: 21<br />height: 65.08974<br />sex: male","age: 22<br />height: 61.63846<br />sex: male","age: 26<br />height: 66.26359<br />sex: male","age: 23<br />height: 71.18394<br />sex: male","age: 24<br />height: 68.40601<br />sex: male","age: 25<br />height: 73.66286<br />sex: male","age: 24<br />height: 72.91695<br />sex: male","age: 25<br />height: 68.24030<br />sex: male","age: 22<br />height: 68.95452<br />sex: male","age: 24<br />height: 59.60542<br />sex: male","age: 22<br />height: 65.02176<br />sex: male","age: 23<br />height: 65.86352<br />sex: male","age: 20<br />height: 71.65429<br />sex: male","age: 24<br />height: 65.66883<br />sex: male","age: 21<br />height: 74.03822<br />sex: male","age: 21<br />height: 61.54877<br />sex: male","age: 24<br />height: 72.44318<br />sex: male","age: 25<br />height: 72.84300<br />sex: male","age: 24<br />height: 70.85047<br />sex: male","age: 23<br />height: 75.96962<br />sex: male","age: 22<br />height: 71.63851<br />sex: male","age: 23<br />height: 67.81774<br />sex: male","age: 26<br />height: 71.71932<br />sex: male","age: 24<br />height: 66.35663<br />sex: male","age: 22<br />height: 65.92236<br />sex: male","age: 24<br />height: 77.65852<br />sex: male","age: 20<br />height: 75.76126<br />sex: male","age: 21<br />height: 70.66526<br />sex: male","age: 22<br />height: 63.57833<br />sex: male","age: 23<br />height: 69.72904<br />sex: male","age: 21<br />height: 70.00594<br />sex: male","age: 23<br />height: 60.04336<br />sex: male","age: 24<br />height: 66.69134<br />sex: male","age: 20<br />height: 62.38770<br />sex: male","age: 24<br />height: 73.95966<br />sex: male","age: 20<br />height: 70.95943<br />sex: male","age: 20<br />height: 62.92572<br />sex: male","age: 25<br />height: 70.58281<br />sex: male","age: 23<br />height: 71.78517<br />sex: male","age: 23<br />height: 72.36665<br />sex: male","age: 22<br />height: 74.02438<br />sex: male","age: 22<br />height: 73.34520<br />sex: male","age: 22<br />height: 71.82291<br />sex: male","age: 23<br />height: 72.24647<br />sex: male","age: 22<br />height: 75.94004<br />sex: male","age: 24<br />height: 69.64654<br />sex: male","age: 24<br />height: 70.32456<br />sex: male","age: 25<br />height: 75.55258<br />sex: male","age: 24<br />height: 69.90636<br />sex: male","age: 21<br />height: 73.95037<br />sex: male","age: 24<br />height: 69.42121<br />sex: male","age: 27<br />height: 67.58619<br />sex: male","age: 22<br />height: 69.24082<br />sex: male","age: 23<br />height: 73.49052<br />sex: male","age: 23<br />height: 65.19050<br />sex: male","age: 25<br />height: 70.82532<br />sex: male","age: 23<br />height: 68.85426<br />sex: male","age: 21<br />height: 81.47797<br />sex: male","age: 24<br />height: 65.17861<br />sex: male","age: 24<br />height: 68.37947<br />sex: male","age: 23<br />height: 71.00853<br />sex: male","age: 20<br />height: 78.46872<br />sex: male","age: 24<br />height: 68.87585<br />sex: male","age: 25<br />height: 72.58532<br />sex: male","age: 24<br />height: 61.18845<br />sex: male","age: 26<br />height: 71.54880<br />sex: male","age: 25<br />height: 74.12073<br />sex: male","age: 22<br />height: 72.06595<br />sex: male","age: 24<br />height: 70.39147<br />sex: male","age: 22<br />height: 69.70927<br />sex: male","age: 23<br />height: 69.94497<br />sex: male","age: 22<br />height: 59.10872<br />sex: male","age: 21<br />height: 71.64765<br />sex: male","age: 25<br />height: 74.92650<br />sex: male","age: 21<br />height: 76.36123<br />sex: male","age: 22<br />height: 67.95907<br />sex: male","age: 24<br />height: 75.34754<br />sex: male","age: 24<br />height: 66.43798<br />sex: male","age: 26<br />height: 63.78644<br />sex: male","age: 23<br />height: 75.48520<br />sex: male","age: 21<br />height: 67.56456<br />sex: male","age: 23<br />height: 70.21950<br />sex: male","age: 22<br />height: 65.51776<br />sex: male","age: 25<br />height: 75.68050<br />sex: male","age: 24<br />height: 74.45611<br />sex: male","age: 25<br />height: 71.94245<br />sex: male","age: 24<br />height: 69.70271<br />sex: male","age: 24<br />height: 67.07777<br />sex: male","age: 25<br />height: 74.11560<br />sex: male","age: 21<br />height: 63.35604<br />sex: male","age: 21<br />height: 66.32812<br />sex: male","age: 24<br />height: 64.51360<br />sex: male","age: 20<br />height: 73.70691<br />sex: male","age: 24<br />height: 67.00986<br />sex: male","age: 22<br />height: 65.88300<br />sex: male","age: 23<br />height: 68.66910<br />sex: male","age: 23<br />height: 69.30526<br />sex: male","age: 24<br />height: 69.25025<br />sex: male","age: 23<br />height: 74.62529<br />sex: male","age: 23<br />height: 66.24722<br />sex: male","age: 26<br />height: 72.09621<br />sex: male","age: 22<br />height: 69.48765<br />sex: male","age: 23<br />height: 62.69475<br />sex: male","age: 22<br />height: 72.13066<br />sex: male","age: 22<br />height: 70.16176<br />sex: male","age: 28<br />height: 74.06456<br />sex: male","age: 23<br />height: 71.08909<br />sex: male","age: 23<br />height: 73.99888<br />sex: male","age: 23<br />height: 76.41161<br />sex: male","age: 22<br />height: 69.88188<br />sex: male","age: 23<br />height: 68.41046<br />sex: male","age: 23<br />height: 69.61675<br />sex: male","age: 25<br />height: 66.67948<br />sex: male","age: 22<br />height: 72.45561<br />sex: male","age: 22<br />height: 70.23787<br />sex: male","age: 25<br />height: 63.28722<br />sex: male","age: 24<br />height: 71.87021<br />sex: male","age: 24<br />height: 62.55781<br />sex: male","age: 23<br />height: 73.45220<br />sex: male","age: 22<br />height: 66.02485<br />sex: male","age: 25<br />height: 68.05921<br />sex: male","age: 21<br />height: 72.07073<br />sex: male","age: 22<br />height: 68.58095<br />sex: male","age: 23<br />height: 69.23025<br />sex: male","age: 26<br />height: 77.64218<br />sex: male","age: 23<br />height: 77.24779<br />sex: male","age: 23<br />height: 71.30643<br />sex: male","age: 22<br />height: 69.87655<br />sex: male","age: 27<br />height: 71.31909<br />sex: male","age: 25<br />height: 67.12297<br />sex: male","age: 21<br />height: 69.33224<br />sex: male","age: 22<br />height: 60.43981<br />sex: male","age: 21<br />height: 67.14631<br />sex: male","age: 24<br />height: 68.12428<br />sex: male","age: 23<br />height: 70.87344<br />sex: male","age: 24<br />height: 68.06095<br />sex: male","age: 22<br />height: 76.70031<br />sex: male","age: 27<br />height: 69.49144<br />sex: male","age: 28<br />height: 65.79092<br />sex: male","age: 20<br />height: 72.90535<br />sex: male","age: 28<br />height: 66.89620<br />sex: male","age: 24<br />height: 65.45107<br />sex: male","age: 22<br />height: 74.05338<br />sex: male","age: 23<br />height: 69.15583<br />sex: male","age: 21<br />height: 69.36873<br />sex: male","age: 22<br />height: 71.05990<br />sex: male","age: 24<br />height: 74.14465<br />sex: male","age: 21<br />height: 67.89045<br />sex: male","age: 22<br />height: 70.10326<br />sex: male","age: 23<br />height: 70.88618<br />sex: male","age: 24<br />height: 74.00645<br />sex: male","age: 28<br />height: 75.16720<br />sex: male","age: 21<br />height: 73.90939<br />sex: male","age: 25<br />height: 69.03249<br />sex: male","age: 22<br />height: 69.99048<br />sex: male","age: 26<br />height: 72.42630<br />sex: male","age: 24<br />height: 71.58511<br />sex: male","age: 23<br />height: 70.76580<br />sex: male","age: 29<br />height: 69.16479<br />sex: male","age: 22<br />height: 72.72464<br />sex: male","age: 23<br />height: 68.14789<br />sex: male","age: 23<br />height: 77.52002<br />sex: male","age: 21<br />height: 68.69679<br />sex: male","age: 26<br />height: 65.86065<br />sex: male","age: 22<br />height: 65.26182<br />sex: male","age: 24<br />height: 70.03317<br />sex: male","age: 21<br />height: 69.82712<br />sex: male","age: 21<br />height: 67.94984<br />sex: male","age: 24<br />height: 67.24170<br />sex: male","age: 20<br />height: 72.66704<br />sex: male","age: 25<br />height: 60.37954<br />sex: male","age: 23<br />height: 72.85347<br />sex: male","age: 22<br />height: 68.67037<br />sex: male","age: 20<br />height: 73.67020<br />sex: male","age: 23<br />height: 72.95858<br />sex: male","age: 27<br />height: 71.65752<br />sex: male","age: 20<br />height: 71.48754<br />sex: male","age: 22<br />height: 67.49003<br />sex: male","age: 22<br />height: 65.85083<br />sex: male","age: 21<br />height: 69.57919<br />sex: male","age: 26<br />height: 71.74280<br />sex: male","age: 22<br />height: 60.46286<br />sex: male","age: 21<br />height: 65.70624<br />sex: male","age: 22<br />height: 64.84817<br />sex: male","age: 22<br />height: 68.85449<br />sex: male","age: 21<br />height: 61.42843<br />sex: male","age: 22<br />height: 68.10281<br />sex: male","age: 23<br />height: 65.05596<br />sex: male","age: 25<br />height: 72.95478<br />sex: male","age: 22<br />height: 70.91503<br />sex: male","age: 25<br />height: 69.06084<br />sex: male","age: 22<br />height: 68.30744<br />sex: male","age: 22<br />height: 68.16734<br />sex: male","age: 23<br />height: 70.21445<br />sex: male","age: 23<br />height: 70.39810<br />sex: male","age: 24<br />height: 74.10387<br />sex: male","age: 20<br />height: 68.43016<br />sex: male","age: 24<br />height: 74.90717<br />sex: male","age: 22<br />height: 72.19850<br />sex: male","age: 20<br />height: 71.60644<br />sex: male","age: 23<br />height: 68.12538<br />sex: male","age: 25<br />height: 71.91233<br />sex: male","age: 22<br />height: 71.30815<br />sex: male","age: 22<br />height: 65.06227<br />sex: male","age: 21<br />height: 65.18494<br />sex: male","age: 28<br />height: 71.35616<br />sex: male","age: 23<br />height: 65.18225<br />sex: male","age: 23<br />height: 59.56909<br />sex: male","age: 22<br />height: 77.47428<br />sex: male","age: 22<br />height: 69.96926<br />sex: male","age: 20<br />height: 67.66335<br />sex: male","age: 22<br />height: 75.17566<br />sex: male","age: 26<br />height: 66.37897<br />sex: male","age: 26<br />height: 76.11647<br />sex: male","age: 23<br />height: 73.36010<br />sex: male","age: 23<br />height: 67.72164<br />sex: male","age: 26<br />height: 70.19122<br />sex: male","age: 23<br />height: 71.64864<br />sex: male","age: 24<br />height: 71.73456<br />sex: male","age: 23<br />height: 67.89925<br />sex: male","age: 22<br />height: 70.65732<br />sex: male","age: 21<br />height: 66.70573<br />sex: male","age: 21<br />height: 66.73694<br />sex: male","age: 24<br />height: 70.95868<br />sex: male","age: 21<br />height: 57.05025<br />sex: male","age: 22<br />height: 71.98186<br />sex: male","age: 24<br />height: 69.99708<br />sex: male","age: 23<br />height: 72.94638<br />sex: male","age: 28<br />height: 75.77382<br />sex: male","age: 23<br />height: 70.50660<br />sex: male","age: 22<br />height: 67.28323<br />sex: male","age: 21<br />height: 74.70968<br />sex: male","age: 23<br />height: 71.12574<br />sex: male","age: 23<br />height: 67.70290<br />sex: male","age: 23<br />height: 76.39618<br />sex: male","age: 25<br />height: 65.03586<br />sex: male","age: 24<br />height: 62.89371<br />sex: male","age: 24<br />height: 74.00412<br />sex: male","age: 23<br />height: 70.96092<br />sex: male","age: 24<br />height: 65.51903<br />sex: male","age: 26<br />height: 63.10382<br />sex: male","age: 23<br />height: 65.40090<br />sex: male","age: 23<br />height: 64.90311<br />sex: male","age: 24<br />height: 69.56097<br />sex: male","age: 24<br />height: 65.76843<br />sex: male","age: 21<br />height: 70.59711<br />sex: male","age: 22<br />height: 69.24806<br />sex: male","age: 21<br />height: 73.32624<br />sex: male","age: 22<br />height: 65.74233<br />sex: male","age: 22<br />height: 75.59891<br />sex: male","age: 22<br />height: 71.64781<br />sex: male","age: 23<br />height: 66.93851<br />sex: male","age: 22<br />height: 73.70771<br />sex: male","age: 21<br />height: 65.65521<br />sex: male","age: 22<br />height: 70.28451<br />sex: male","age: 22<br />height: 68.74181<br />sex: male","age: 23<br />height: 70.46843<br />sex: male","age: 26<br />height: 63.01014<br />sex: male","age: 23<br />height: 69.51618<br />sex: male","age: 23<br />height: 70.70098<br />sex: male","age: 23<br />height: 68.82604<br />sex: male","age: 21<br />height: 75.70897<br />sex: male","age: 25<br />height: 67.03171<br />sex: male","age: 20<br />height: 70.36086<br />sex: male","age: 21<br />height: 70.28479<br />sex: male","age: 26<br />height: 66.05483<br />sex: male","age: 22<br />height: 69.23218<br />sex: male","age: 23<br />height: 80.11055<br />sex: male","age: 25<br />height: 63.55160<br />sex: male","age: 23<br />height: 75.14555<br />sex: male","age: 23<br />height: 66.01439<br />sex: male","age: 23<br />height: 68.73546<br />sex: male","age: 21<br />height: 73.24377<br />sex: male","age: 21<br />height: 68.33825<br />sex: male","age: 22<br />height: 71.03082<br />sex: male","age: 22<br />height: 68.23271<br />sex: male","age: 26<br />height: 63.06503<br />sex: male","age: 25<br />height: 70.95332<br />sex: male","age: 22<br />height: 78.04024<br />sex: male","age: 24<br />height: 74.03289<br />sex: male","age: 20<br />height: 67.77964<br />sex: male","age: 23<br />height: 67.03916<br />sex: male","age: 21<br />height: 64.91638<br />sex: male","age: 24<br />height: 66.73931<br />sex: male","age: 23<br />height: 64.48838<br />sex: male","age: 20<br />height: 78.18673<br />sex: male","age: 21<br />height: 68.02036<br />sex: male","age: 25<br />height: 68.59082<br />sex: male","age: 26<br />height: 74.40137<br />sex: male","age: 29<br />height: 61.64562<br />sex: male","age: 22<br />height: 68.52491<br />sex: male","age: 24<br />height: 69.55647<br />sex: male","age: 25<br />height: 68.57858<br />sex: male","age: 23<br />height: 67.89857<br />sex: male","age: 22<br />height: 71.92682<br />sex: male","age: 22<br />height: 74.09721<br />sex: male","age: 22<br />height: 67.93458<br />sex: male","age: 22<br />height: 64.73801<br />sex: male","age: 22<br />height: 68.42425<br />sex: male","age: 21<br />height: 70.43858<br />sex: male","age: 23<br />height: 66.57912<br />sex: male","age: 22<br />height: 69.87878<br />sex: male","age: 23<br />height: 70.89056<br />sex: male","age: 23<br />height: 68.82680<br />sex: male","age: 23<br />height: 68.91800<br />sex: male","age: 21<br />height: 72.04996<br />sex: male","age: 21<br />height: 67.74785<br />sex: male","age: 23<br />height: 62.29497<br />sex: male","age: 21<br />height: 70.00792<br />sex: male","age: 24<br />height: 75.61086<br />sex: male","age: 27<br />height: 62.60709<br />sex: male","age: 22<br />height: 61.41738<br />sex: male","age: 21<br />height: 63.09440<br />sex: male","age: 23<br />height: 67.26256<br />sex: male","age: 21<br />height: 65.60630<br />sex: male","age: 21<br />height: 64.63264<br />sex: male","age: 26<br />height: 78.90056<br />sex: male","age: 23<br />height: 77.30118<br />sex: male","age: 21<br />height: 64.20486<br />sex: male","age: 23<br />height: 75.56317<br />sex: male","age: 23<br />height: 71.15690<br />sex: male","age: 21<br />height: 69.79568<br />sex: male","age: 25<br />height: 83.65118<br />sex: male","age: 20<br />height: 70.50102<br />sex: male","age: 26<br />height: 68.62550<br />sex: male","age: 24<br />height: 66.89678<br />sex: male","age: 22<br />height: 69.09754<br />sex: male","age: 21<br />height: 71.62961<br />sex: male","age: 24<br />height: 72.60394<br />sex: male","age: 21<br />height: 69.99777<br />sex: male","age: 24<br />height: 71.43416<br />sex: male","age: 25<br />height: 72.50182<br />sex: male","age: 23<br />height: 75.00346<br />sex: male","age: 27<br />height: 73.77568<br />sex: male","age: 22<br />height: 67.17274<br />sex: male","age: 24<br />height: 69.77368<br />sex: male","age: 21<br />height: 71.46927<br />sex: male","age: 23<br />height: 68.42579<br />sex: male","age: 23<br />height: 64.27056<br />sex: male","age: 25<br />height: 67.37639<br />sex: male","age: 23<br />height: 65.39853<br />sex: male","age: 22<br />height: 74.60593<br />sex: male","age: 23<br />height: 68.84168<br />sex: male","age: 22<br />height: 78.37182<br />sex: male","age: 22<br />height: 59.36142<br />sex: male","age: 23<br />height: 68.43510<br />sex: male","age: 22<br />height: 78.85089<br />sex: male","age: 23<br />height: 63.74964<br />sex: male","age: 24<br />height: 66.91881<br />sex: male","age: 24<br />height: 67.78118<br />sex: male","age: 24<br />height: 75.64201<br />sex: male","age: 20<br />height: 68.03919<br />sex: male","age: 24<br />height: 70.28812<br />sex: male","age: 26<br />height: 71.55137<br />sex: male","age: 22<br />height: 66.05161<br />sex: male","age: 26<br />height: 58.88231<br />sex: male","age: 23<br />height: 72.02815<br />sex: male","age: 24<br />height: 77.02907<br />sex: male","age: 23<br />height: 68.36525<br />sex: male","age: 20<br />height: 70.17351<br />sex: male","age: 22<br />height: 74.68846<br />sex: male","age: 21<br />height: 71.04870<br />sex: male","age: 22<br />height: 78.55031<br />sex: male","age: 22<br />height: 75.07711<br />sex: male","age: 20<br />height: 69.10727<br />sex: male","age: 26<br />height: 76.11415<br />sex: male","age: 24<br />height: 71.80872<br />sex: male","age: 22<br />height: 76.79170<br />sex: male","age: 23<br />height: 74.06285<br />sex: male","age: 21<br />height: 74.25464<br />sex: male","age: 24<br />height: 72.88174<br />sex: male","age: 24<br />height: 78.95426<br />sex: male","age: 25<br />height: 70.92344<br />sex: male","age: 26<br />height: 71.06452<br />sex: male","age: 24<br />height: 71.22299<br />sex: male","age: 22<br />height: 59.06295<br />sex: male","age: 24<br />height: 68.20516<br />sex: male","age: 22<br />height: 71.55955<br />sex: male","age: 23<br />height: 65.83248<br />sex: male","age: 21<br />height: 65.29474<br />sex: male","age: 22<br />height: 82.48911<br />sex: male","age: 23<br />height: 71.12959<br />sex: male","age: 21<br />height: 71.70178<br />sex: male","age: 22<br />height: 75.04917<br />sex: male","age: 22<br />height: 69.38404<br />sex: male","age: 24<br />height: 65.69696<br />sex: male","age: 25<br />height: 64.01977<br />sex: male","age: 21<br />height: 68.64199<br />sex: male","age: 26<br />height: 71.81880<br />sex: male","age: 26<br />height: 68.11358<br />sex: male","age: 25<br />height: 64.53232<br />sex: male","age: 23<br />height: 68.22806<br />sex: male","age: 24<br />height: 71.53491<br />sex: male","age: 25<br />height: 68.23014<br />sex: male","age: 23<br />height: 76.59505<br />sex: male"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,191,196,1)","opacity":1,"size":7.55905511811024,"symbol":"circle","line":{"width":1.88976377952756,"color":"rgba(0,0,0,1)"}},"hoveron":"points","name":"male","legendgroup":"male","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":30.8775425487754,"r":9.29846409298464,"b":54.0612702366127,"l":48.4821917808219},"font":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[19.2578302464262,31.3726300622523],"tickmode":"array","ticktext":["20","24","28"],"tickvals":[20,24,28],"categoryorder":"array","categoryarray":["20","24","28"],"nticks":null,"ticks":"outside","tickcolor":"rgba(0,0,0,1)","ticklen":4.64923204649232,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"tickangle":-0,"showline":true,"linecolor":"rgba(0,0,0,1)","linewidth":0.66417600664176,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"y","title":"age","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[51.3903204543065,85.1874089298995],"tickmode":"array","ticktext":["60","70","80"],"tickvals":[60,70,80],"categoryorder":"array","categoryarray":["60","70","80"],"nticks":null,"ticks":"outside","tickcolor":"rgba(0,0,0,1)","ticklen":4.64923204649232,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"tickangle":-0,"showline":true,"linecolor":"rgba(0,0,0,1)","linewidth":0.66417600664176,"showgrid":false,"gridcolor":null,"gridwidth":0,"zeroline":false,"anchor":"x","title":"height","titlefont":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":null,"bordercolor":null,"borderwidth":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":15.9375674553757},"y":0.889763779527559},"annotations":[{"text":"sex","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":18.5969281859693},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":[{"name":"Collaborate","icon":{"width":1000,"ascent":500,"descent":-50,"path":"M487 375c7-10 9-23 5-36l-79-259c-3-12-11-23-22-31-11-8-22-12-35-12l-263 0c-15 0-29 5-43 15-13 10-23 23-28 37-5 13-5 25-1 37 0 0 0 3 1 7 1 5 1 8 1 11 0 2 0 4-1 6 0 3-1 5-1 6 1 2 2 4 3 6 1 2 2 4 4 6 2 3 4 5 5 7 5 7 9 16 13 26 4 10 7 19 9 26 0 2 0 5 0 9-1 4-1 6 0 8 0 2 2 5 4 8 3 3 5 5 5 7 4 6 8 15 12 26 4 11 7 19 7 26 1 1 0 4 0 9-1 4-1 7 0 8 1 2 3 5 6 8 4 4 6 6 6 7 4 5 8 13 13 24 4 11 7 20 7 28 1 1 0 4 0 7-1 3-1 6-1 7 0 2 1 4 3 6 1 1 3 4 5 6 2 3 3 5 5 6 1 2 3 5 4 9 2 3 3 7 5 10 1 3 2 6 4 10 2 4 4 7 6 9 2 3 4 5 7 7 3 2 7 3 11 3 3 0 8 0 13-1l0-1c7 2 12 2 14 2l218 0c14 0 25-5 32-16 8-10 10-23 6-37l-79-259c-7-22-13-37-20-43-7-7-19-10-37-10l-248 0c-5 0-9-2-11-5-2-3-2-7 0-12 4-13 18-20 41-20l264 0c5 0 10 2 16 5 5 3 8 6 10 11l85 282c2 5 2 10 2 17 7-3 13-7 17-13z m-304 0c-1-3-1-5 0-7 1-1 3-2 6-2l174 0c2 0 4 1 7 2 2 2 4 4 5 7l6 18c0 3 0 5-1 7-1 1-3 2-6 2l-173 0c-3 0-5-1-8-2-2-2-4-4-4-7z m-24-73c-1-3-1-5 0-7 2-2 3-2 6-2l174 0c2 0 5 0 7 2 3 2 4 4 5 7l6 18c1 2 0 5-1 6-1 2-3 3-5 3l-174 0c-3 0-5-1-7-3-3-1-4-4-5-6z"},"click":"function(gd) { \n        // is this being viewed in RStudio?\n        if (location.search == '?viewer_pane=1') {\n          alert('To learn about plotly for collaboration, visit:\\n https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html');\n        } else {\n          window.open('https://cpsievert.github.io/plotly_book/plot-ly-for-collaboration.html', '_blank');\n        }\n      }"}],"cloud":false},"source":"A","attrs":{"eb8912fe0877":{"x":{},"y":{},"fill":{},"type":"scatter"}},"cur_data":"eb8912fe0877","visdat":{"eb8912fe0877":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"base_url":"https://plot.ly"},"evals":["config.modeBarButtonsToAdd.0.click"],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:plotly)**CAPTION THIS FIGURE!!**</p>
</div>

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
