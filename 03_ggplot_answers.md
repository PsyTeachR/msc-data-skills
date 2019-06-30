---
title: 'Formative Exercise 03: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---




## Common Plots

Generate a violin plot, boxplot, histogram, density plot, and column plot for the following data. 



### Basic

Create each plot.

#### Violin Plot
![plot of chunk exercise-violin](figure/exercise-violin-1.png)


#### Boxplot
![plot of chunk exercise-boxplot](figure/exercise-boxplot-1.png)


#### Histogram
![plot of chunk exercise-histogram](figure/exercise-histogram-1.png)


#### Density plot
![plot of chunk exercise-density](figure/exercise-density-1.png)


#### Column Plot
![plot of chunk exercise-colplot](figure/exercise-colplot-1.png)

### Intermediate

Change the axis labels so the x-axis reads "Breed of Dog" or "Weight of Dog" (depending on the plot type) and the y-axis reads "Weight of Dog", "Number of Dogs", or "Density of Dogs" (depending on the plot type).

Change the default colours to "orange", "dodgerblue", and "hotpink". 

Save each plot as a PNG file with the names "dog_violin.png", "dog_boxplot.png","dog_histogram.png", "dog_density.png", and "dog_column.png" (the names are important so they show up in the code below; remeber to remove the two lines indicated).



![](dog_violin.png)
![](dog_boxplot.png)
![](dog_histogram.png)
![](dog_column.png)
![](dog_violin.png)

### Advanced

Create a grid of the first four plot styles (exclude the column plot). 

![plot of chunk exercise-dog-advanced](figure/exercise-dog-advanced-1.png)


## Two continuous variables

Represent the relationships among moral, sexual and pathogen disgust scores from the dataset [disgust_scores.csv](https://psyteachr.github.io/msc-data-skills/data/disgust_scores.csv). Load the data into the variable `disgust`.

### Basic

Graph the linear relationship between moral and pathogen disgust. Make sure the 
axes run from the minimum to maximum possible scores on both axes. Give the 
graph an appropriate title and axis lables.
  
![plot of chunk exercise-cor-basic](figure/exercise-cor-basic-1.png)
  
### Intermediate

Create a 2d density plot of the relationship between pathogen and sexual disgust. 

Use `stat_density_2d(aes(fill = ..level..), geom = "polygon", n = n, 
h = h)`, set n and h to values that make the graph look good, and 
figure out what `n` and `h` represent.

![plot of chunk exercise-density2d](figure/exercise-density2d-1.png)


### Advanced

Create a 3x3 grid of plots with columns representing the x-axis and 
rows representing the y-axis and assign it to `disgust_grid`. 
Put a density plot of each variable along the diagonal. Make sure the graphs have 
appropriate titles and axis labels and that the range of the axes are the same 
in all graphs.

|              | moral   | sexual  | pathogen |
|--------------|---------|---------|----------|
| **moral**    | density | line    | line     | 
| **sexual**   | line    | density | line     |
| **pathogen** | line    | line    | density  |


![plot of chunk exercise-cor-advanced](figure/exercise-cor-advanced-1.png)


## Many correlated variables

*Basic*: Create a heatmap of the relationships among all the questions in [disgust_cors.csv](https://psyteachr.github.io/msc-data-skills/data/disgust_cors.csv) (the correlations have already been calculated for you). 

*Intermediate*: Figure out how to rotate the text on the x-axis so it's readable.

![plot of chunk exercise-heatmap](figure/exercise-heatmap-1.png)

