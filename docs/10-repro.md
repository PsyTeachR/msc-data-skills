# Reproducible Workflows {#repro}

<img src="images/memes/repro_reports.jpg" class="meme right"
     alt="Top left: young spongebob; top right: Using Base R for your analysis and copy pasting yur results into tables in Word; middle left: older angry spongebob in workout clothes; middle right: learning how to use dplyr visualize data with ggplot2 and report your analysis in rmarkdown documents; bottom left: muscular spongebob shirtless in a boxing ring; bottom right: wielding the entire might of the tidyverse (with 50 hex stikers)">

## Learning Objectives {#ilo10}

### Basic

1. Create a reproducible script in R Markdown
2. Edit the YAML header to add table of contents and other options
3. Include a table 
4. Include a figure 
5. Use `source()` to include code from an external file 
6. Report the output of an analysis using inline R

### Intermediate

7. Output doc and PDF formats
8. Add a bibliography and in-line citations
9. Format tables using `kableExtra`

### Advanced

10. Create a computationally reproducible project in Code Ocean


## Resources {#resources10}

* [Chapter 27: R Markdown](http://r4ds.had.co.nz/r-markdown.html) in *R for Data Science*
* [R Markdown Cheat Sheet](http://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf)
* [R Markdown reference Guide](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)
* [R Markdown Tutorial](https://rmarkdown.rstudio.com/lesson-1.html)
* [R Markdown: The Definitive Guide](https://bookdown.org/yihui/rmarkdown/) by Yihui Xie, J. J. Allaire, & Garrett Grolemund
* [Papaja](https://crsh.github.io/papaja_man/) Reproducible APA Manuscripts
* [Code Ocean](https://codeocean.com/) for Computational Reproducibility


## Setup {#setup10}


```r
library(tidyverse)
library(knitr)
library(broom)
set.seed(8675309)
```

## R Markdown

By now you should be pretty comfortable working with R Markdown files from the weekly formative exercises and set exercises. Here, we'll explore some of the more advanced options and create an R Markdown document that produces a <a class='glossary' target='_blank' title='The extent to which the findings of a study can be repeated in some other context' href='https://psyteachr.github.io/glossary/r#reproducibility'>reproducible</a> manuscript.

First, make a new R Markdown document.

### knitr options

When you create a new R Markdown file in RStudio, a setup chunk is automatically created.

<div class='verbatim'><code>&#96;&#96;&#96;{r setup, include=FALSE}</code>

```r
knitr::opts_chunk$set(echo = TRUE)
```

<code>&#96;&#96;&#96;</code></div>

You can set more default options for code chunks here. See the [knitr options documentation](https://yihui.name/knitr/options/) for explanations of the possible options.

<div class='verbatim'><code>&#96;&#96;&#96;{r setup, include=FALSE}</code>

```r
knitr::opts_chunk$set(
  fig.width  = 8, 
  fig.height = 5, 
  fig.path   = 'images/',
  echo       = FALSE, 
  warning    = TRUE, 
  message    = FALSE,
  cache      = FALSE
)
```

<code>&#96;&#96;&#96;</code></div>

The code above sets the following options:

* `fig.width  = 8` : figure width is 8 inches
* `fig.height = 5` : figure height is 5 inches
* `fig.path   = 'images/'` : figures are saved in the directory "images"
* `echo       = FALSE` : do not show code chunks in the rendered document
* `warning    = FALSE` : do not show any function warnings
* `message    = FALSE` : do not show any function messages
* `cache      = FALSE` : run all the code to create all of the images and objects each time you knit (set to `TRUE` if you have time-consuming code)

### YAML Header

The <a class='glossary' target='_blank' title='A structured format for information' href='https://psyteachr.github.io/glossary/y#yaml'>YAML</a> header is where you can set several options. 

```
---
title: "My Demo Document"
author: "Me"
output:
  html_document:
    theme: spacelab
    highlight: tango
    toc: true
    toc_float:
      collapsed: false
      smooth_scroll: false
    toc_depth: 3
    number_sections: false
---
```

The built-in themes are: "cerulean", "cosmo", "flatly", "journal", "lumen", "paper", "readable", "sandstone", "simplex", "spacelab", "united", and "yeti". You can [view and download more themes](http://www.datadreaming.org/post/r-markdown-theme-gallery/).

<p class="alert alert-info">Try changing the values from `false` to `true` to see what the options do.</p>


### TOC and Document Headers

If you include a table of contents (`toc`), it is created from your document headers. Headers in <a class='glossary' target='_blank' title='A way to specify formatting, such as headers, paragraphs, lists, bolding, and links.' href='https://psyteachr.github.io/glossary/m#markdown'>markdown</a> are created by prefacing the header title with one or more hashes (`#`). Add a typical paper structure to your document like the one below.  

```
## Abstract

My abstract here...

## Introduction

What's the question; why is it interesting?

## Methods

### Participants

How many participants and why? Do your power calculation here.

### Procedure

What will they do?

### Analysis

Describe the analysis plan...

## Results

Demo results for simulated data...

## Discussion

What does it all mean?

## References
```

### Code Chunks

You can include <a class='glossary' target='_blank' title='A section of code in an R Markdown file' href='https://psyteachr.github.io/glossary/c#chunk'>code chunks</a> that create and display images, tables, or computations to include in your text. Let's start by simulating some data.

First, create a code chunk in your document. You can put this before the abstract, since we won't be showing the code in this document. We'll use a modified version of the `two_sample` function from the [GLM lecture](09_glm.html) to create two groups with a difference of 0.75 and 100 observations per group. 

<p class="alert alert-info">This function was modified to add sex and effect-code both sex and group. Using the `recode` function to set effect or difference coding makes it clearer which value corresponds to which level. There is no effect of sex or interaction with group in these simulated data.</p>


```r
two_sample <- function(diff = 0.5, n_per_group = 20) {
  tibble(Y = c(rnorm(n_per_group, -.5 * diff, sd = 1),
               rnorm(n_per_group, .5 * diff, sd = 1)),
         grp = factor(rep(c("a", "b"), each = n_per_group)),
         sex = factor(rep(c("female", "male"), times = n_per_group))
  ) %>%
    mutate(
      grp_e = recode(grp, "a" = -0.5, "b" = 0.5),
      sex_e = recode(sex, "female" = -0.5, "male" = 0.5)
    )
}
```

<p class="alert alert-warning">This function requires the `tibble` and `dplyr` packages, so remember to load the whole tidyverse package at the top of this script (e.g., in the setup chunk).</p>

Now we can make a separate code chunk to create our simulated dataset `dat`. 


```r
dat <- two_sample(diff = 0.75, n_per_group = 100)
```


#### Tables

Next, create a code chunk where you want to display a table of the descriptives (e.g., Participants section of the Methods). We'll use tidyverse functions you learned in the [data wrangling lectures](04_wrangling.html) to create summary statistics for each group.

<pre><code>&#96;&#96;&#96;{r, results='asis'}

dat %>%
  group_by(grp, sex) %>%
  summarise(n = n(),
            Mean = mean(Y),
            SD = sd(Y)) %>%
  rename(group = grp) %>%
  mutate_if(is.numeric, round, 3) %>%
  knitr::kable()

&#96;&#96;&#96;</code></pre>


```
## `summarise()` has grouped output by 'grp'. You can override using the `.groups` argument.
```

```
## `mutate_if()` ignored the following grouping variables:
## Column `group`
```



|group |sex    |  n|   Mean|    SD|
|:-----|:------|--:|------:|-----:|
|a     |female | 50| -0.361| 0.796|
|a     |male   | 50| -0.284| 1.052|
|b     |female | 50|  0.335| 1.080|
|b     |male   | 50|  0.313| 0.904|

<p class="alert alert-info">Notice that the r chunk specifies the option `results='asis'`. This lets you format the table using the `kable()` function from `knitr`. You can also use more specialised functions from [papaja](https://crsh.github.io/papaja_man/reporting.html#tables) or [kableExtra](https://haozhu233.github.io/kableExtra/awesome_table_in_html.html) to format your tables.</p>

#### Images

Next, create a code chunk where you want to display the image in your document. Let's put it in the Results section. Use what you learned in the [data visualisation lecture](03_ggplot.html) to show violin-boxplots for the two groups.

<pre><code>&#96;&#96;&#96;{r, fig1, fig.cap="Figure 1. Scores by group and sex."}
ggplot(dat, aes(grp, Y, fill = sex)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.25, 
               position = position_dodge(width = 0.9),
               show.legend = FALSE) +
  scale_fill_manual(values = c("orange", "purple")) +
  xlab("Group") +
  ylab("Score") +
  theme(text = element_text(size = 30, family = "Times"))
  
&#96;&#96;&#96;</code></pre>

<p class="alert alert-info">The last line changes the default text size and font, which can be useful for generating figures that meet a journal's requirements.</p>

<div class="figure" style="text-align: center">
<img src="10-repro_files/figure-html/unnamed-chunk-5-1.png" alt="Figure 1. Scores by group and sex." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-5)Figure 1. Scores by group and sex.</p>
</div>



You can also include images that you did not create in R using the typical markdown syntax for images: 
```
![All the Things by [Hyperbole and a Half](http://hyperboleandahalf.blogspot.com/)](images/memes/x-all-the-things.png)
```

![All the Things by [Hyperbole and a Half](http://hyperboleandahalf.blogspot.com/)](images/memes/x-all-the-things.png)

#### In-line R

Now let's use what you learned in the [GLM lecture](09_glm.html) to analyse our simulated data. The document is getting a little cluttered, so let's move this code to external scripts.

* Create a new R script called "functions.R"
* Move the `library(tidyverse)` line and the `two_sample()` function definition to this file.
* Create a new R script called "analysis.R"
* Move the code for creating `dat` to this file.
* Add the following code to the end of the setup chunk:


```r
source("functions.R")
source("analysis.R")
```

The `source` function lets you include code from an external file. This is really useful for making your documents readable. Just make sure you call your source files in the right order (e.g., include function definitions before you use the functions).

In the "analysis.R" file, we're going to run the analysis code and save any numbers we might want to use in our manuscript to variables.


```r
grp_lm <- lm(Y ~ grp_e * sex_e, data = dat)

stats <- grp_lm %>%
  broom::tidy() %>%
  mutate_if(is.numeric, round, 3)
```

The code above runs our analysis predicting `Y` from the effect-coded group variable `grp_e`, the effect-coded sex variable `sex_e` and their intereaction. The `tidy` function from the `broom` package turns the output into a tidy table. The `mutate_if` function uses the function `is.numeric` to check if each column should be mutated, adn if it is numeric, applies the `round` function with the digits argument set to 3.

If you want to report the results of the analysis in a paragraph istead of a table, you need to know how to refer to each number in the table. Like with everything in R, there are many wways to do this. One is by specifying the column and row number like this:


```r
stats$p.value[2]
```

```
## [1] 0
```

Another way is to create variables for each row like this:


```r
grp_stats <- filter(stats, term == "grp_e")
sex_stats <- filter(stats, term == "sex_e")
ixn_stats <- filter(stats, term == "grp_e:sex_e")
```

Add the above code to the end of your analysis.R file. Then you can refer to columns by name like this:


```r
grp_stats$p.value
sex_stats$statistic
ixn_stats$estimate
```

```
## [1] 0
## [1] 0.197
## [1] -0.099
```

You can insert these numbers into a paragraph with inline R code that looks like this: 

<pre><code>Scores were higher in group B than group A 
(B = &#96;r grp_stats$estimate&#96;, 
t = &#96;r grp_stats$statistic&#96;, 
p = &#96;r grp_stats$p.value&#96;). 
There was no significant difference between men and women 
(B = &#96;r sex_statsestimate&#96;, 
t = &#96;r sex_stats$statistic&#96;, 
p = &#96;r sex_stats$p.value&#96;) 
and the effect of group was not qualified by an interaction with sex 
(B = &#96;r ixn_stats$estimate&#96;, 
t = &#96;r ixn_stats$statistic&#96;, 
p = &#96;r ixn_stats$p.value&#96;).
</code></pre>

**Rendered text:**  
Scores were higher in group B than group A 
(B = 0.647, 
t = 4.74, 
p = 0). 
There was no significant difference between men and women 
(B = 0.027, 
t = 0.197, 
p = 0.844)
and the effect of group was not qualified by an interaction with sex 
(B = -0.099, 
t = -0.363, 
p = 0.717).

<p class="alert alert-info">Remember, line breaks are ignored when you render the file (unless you add two spaces at the end of lines), so you can use line breaks to make it easier to read your text with inline R code.</p>

The p-values aren't formatted in APA style. We wrote a function to deal with this in the [function lecture](07_functions.html). Add this function to the "functions.R" file and change the inline text to use the `report_p` function.


```r
report_p <- function(p, digits = 3) {
  if (!is.numeric(p)) stop("p must be a number")
  if (p <= 0) warning("p-values are normally greater than 0")
  if (p >= 1) warning("p-values are normally less than 1")
  
  if (p < .001) {
    reported = "p < .001"
  } else {
    roundp <- round(p, digits)
    fmt <- paste0("p = %.", digits, "f")
    reported = sprintf(fmt, roundp)
  }
  
  reported
}
```


<pre><code>Scores were higher in group B than group A 
(B = &#96;r grp_stats$estimate&#96;, 
t = &#96;r grp_stats$statistic&#96;, 
&#96;r report_p(grp_stats$p.value, 3)&#96;). 
There was no significant difference between men and women 
(B = &#96;r sex_stats$estimate&#96;, 
t = &#96;r sex_stats$statistic&#96;, 
&#96;r report_p(sex_stats$p.value, 3)&#96;) 
and the effect of group was not qualified by an interaction with sex 
(B = &#96;r ixn_stats$estimate&#96;, 
t = &#96;r ixn_stats$statistic&#96;, 
&#96;r report_p(ixn_stats$p.value, 3)&#96;).
</code></pre>

**Rendered text:**  
Scores were higher in group B than group A 
(B = 0.647, 
t = 4.74, 
p < .001). 
There was no significant difference between men and women 
(B = 0.027, 
t = 0.197, 
p = 0.844) 
and the effect of group was not qualified by an interaction with sex 
(B = -0.099, 
t = -0.363, 
p = 0.717).

You might also want to report the statistics for the regression. There are a lot of numbers to format and insert, so it is easier to do this in the analysis script using `sprintf` for formatting.


```r
s <- summary(grp_lm)

# calculate p value from fstatistic
fstat.p <- pf(s$fstatistic[1], 
              s$fstatistic[2], 
              s$fstatistic[3], 
              lower=FALSE)

adj_r <- sprintf(
  "The regression equation had an adjusted $R^{2}$ of %.3f ($F_{(%i, %i)}$ = %.3f, %s).",
  round(s$adj.r.squared, 3),
  s$fstatistic[2],
  s$fstatistic[3],
  round(s$fstatistic[1], 3),
  report_p(fstat.p, 3)
)
```

Then you can just insert the text in your manuscript like this: &#96; adj_r&#96;:

The regression equation had an adjusted $R^{2}$ of 0.090 ($F_{(3, 196)}$ = 7.546, p < .001).

### Bibliography

There are several ways to do in-text citations and automatically generate a [bibliography](https://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html#bibliographies) in RMarkdown.

#### Create a BibTeX File Manually

You can just make a BibTeX file and add citations manually. Make a new Text File in RStudio called "bibliography.bib".

Next, add the line `bibliography: bibliography.bib` to your YAML header.

You can add citations in the following format:

```
@article{shortname,
  author = {Author One and Author Two and Author Three},
  title = {Paper Title},
  journal = {Journal Title},
  volume = {vol},
  number = {issue},
  pages = {startpage--endpage},
  year = {year},
  doi = {doi}
}
```

#### Citing R packages

You can get the citation for an R package using the function `citation`. You can paste the bibtex entry into your bibliography.bib file. Make sure to add a short name (e.g., "rmarkdown") before the first comma to refer to the reference.


```r
citation(package="rmarkdown")
```

```
## 
## To cite the 'rmarkdown' package in publications, please use:
## 
##   JJ Allaire and Yihui Xie and Jonathan McPherson and Javier Luraschi
##   and Kevin Ushey and Aron Atkins and Hadley Wickham and Joe Cheng and
##   Winston Chang and Richard Iannone (2021). rmarkdown: Dynamic
##   Documents for R. R package version 2.9.4. URL
##   https://rmarkdown.rstudio.com.
## 
##   Yihui Xie and J.J. Allaire and Garrett Grolemund (2018). R Markdown:
##   The Definitive Guide. Chapman and Hall/CRC. ISBN 9781138359338. URL
##   https://bookdown.org/yihui/rmarkdown.
## 
##   Yihui Xie and Christophe Dervieux and Emily Riederer (2020). R
##   Markdown Cookbook. Chapman and Hall/CRC. ISBN 9780367563837. URL
##   https://bookdown.org/yihui/rmarkdown-cookbook.
## 
## To see these entries in BibTeX format, use 'print(<citation>,
## bibtex=TRUE)', 'toBibtex(.)', or set
## 'options(citation.bibtex.max=999)'.
```


#### Download Citation Info

You can get the BibTeX formatted citation from most publisher websites. For example, go to the publisher's page for [Equivalence Testing for Psychological Research: A Tutorial](https://journals.sagepub.com/doi/abs/10.1177/2515245918770963), click on the Cite button (in the sidebar or under the bottom Explore More menu), choose BibTeX format, and download the citation. You can open up the file in a text editor and copy the text. It should look like this:

```
@article{doi:10.1177/2515245918770963,
author = {Daniël Lakens and Anne M. Scheel and Peder M. Isager},
title ={Equivalence Testing for Psychological Research: A Tutorial},
journal = {Advances in Methods and Practices in Psychological Science},
volume = {1},
number = {2},
pages = {259-269},
year = {2018},
doi = {10.1177/2515245918770963},

URL = { 
        https://doi.org/10.1177/2515245918770963
    
},
eprint = { 
        https://doi.org/10.1177/2515245918770963
    
}
,
    abstract = { Psychologists must be able to test both for the presence of an effect and for the absence of an effect. In addition to testing against zero, researchers can use the two one-sided tests (TOST) procedure to test for equivalence and reject the presence of a smallest effect size of interest (SESOI). The TOST procedure can be used to determine if an observed effect is surprisingly small, given that a true effect at least as extreme as the SESOI exists. We explain a range of approaches to determine the SESOI in psychological science and provide detailed examples of how equivalence tests should be performed and reported. Equivalence tests are an important extension of the statistical tools psychologists currently use and enable researchers to falsify predictions about the presence, and declare the absence, of meaningful effects. }
}
```

Paste the reference into your bibliography.bib file. Change `doi:10.1177/2515245918770963` in the first line of the reference to a short string you will use to cite the reference in your manuscript. We'll use `TOSTtutorial`.

#### Converting from reference software

Most reference software like EndNote, Zotero or mendeley have exporting options that can export to BibTeX format. You just need to check the shortnames in the resulting file.

#### In-text citations

You can cite reference in text like this: 

```
This tutorial uses several R packages [@tidyverse;@rmarkdown].
```

This tutorial uses several R packages [@tidyverse;@rmarkdown].

Put a minus in front of the @ if you just want the year:

```
Lakens, Scheel and Isengar [-@TOSTtutorial] wrote a tutorial explaining how to test for the absence of an effect.
```

Lakens, Scheel and Isengar [-@TOSTtutorial] wrote a tutorial explaining how to test for the absence of an effect.

#### Citation Styles

You can search a [list of style files](https://www.zotero.org/styles) for various journals and download a file that will format your bibliography for a specific journal's style. You'll need to add the line `csl: filename.csl` to your YAML header. 

<p class="alert alert-info">Add some citations to your bibliography.bib file, reference them in your text, and render your manuscript to see the automatically generated reference section. Try a few different citation style files.</p>


### Output Formats

You can knit your file to PDF or Word if you have the right packages installed on your computer.

### Computational Reproducibility

Computational reproducibility refers to making all aspects of your analysis reproducible, including specifics of the software you used to run the code you wrote. R packages get updated periodically and some of these updates may break your code. Using a computational reproducibility platform guards against this by always running your code in the same environment.

[Code Ocean](https://codeocean.com/) is a new platform that lets you run your code in the cloud via a web browser. 

## Glossary {#glossary10}



|term                                                                                                                  |definition                                                                           |
|:---------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/c#chunk'>chunk</a>                     |A section of code in an R Markdown file                                              |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/m#markdown'>markdown</a>               |A way to specify formatting, such as headers, paragraphs, lists, bolding, and links. |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/r#reproducibility'>reproducibility</a> |The extent to which the findings of a study can be repeated in some other context    |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/y#yaml'>yaml</a>                       |A structured format for information                                                  |



## References
