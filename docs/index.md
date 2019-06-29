
--- 
title: Data Skills
author: "[Lisa DeBruine](https://debruine.github.io) & [Dale Barr](http://talklab.psy.gla.ac.uk/)"
date: "2019-06-29"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib]
biblio-style: apalike
link-citations: yes
description: "This course provides an overview of skills needed for reproducible research and open science using the statistical programming language R. Students will learn about data visualisation, data tidying and wrangling, archiving, iteration and functions, probability and data simulations, general linear models, and reproducible workflows. Learning is reinforced through weekly assignments that involve working with different types of data."
---

# Overview {-}

<img src="images/data_skills.png" style="width: 200px; float: right;">

This course provides an overview of skills needed for reproducible research and open science using the statistical programming language R. Students will learn about data visualisation, data tidying and wrangling, archiving, iteration and functions, probability and data simulations, general linear models, and reproducible workflows. Learning is reinforced through weekly assignments that involve working with different types of data.


## Course Aims

This course aims to teach students the basic principles of reproducible research and to provide practical training in data processing and analysis in the statistical programming language R.


## Intended Learning Outcomes

By the end of this course students will be able to:

*	Draw on a range of specialised skills and techniques to formulate a research design appropriate to various kinds of questions in psychology and neuroscience
*	Write scripts in R to organise and transform data sets using best accepted practices
*	Explain basics of probability and its role in statistical inference
*	Critically analyse data and report descriptive and inferential statistics in a reproducible manner


## Course Outline

The overview below lists the beginner learning outcomes only. Some lessons have additional learning outcomes for intermediate or advanced students.

1. [Getting Started](#intro)
    1. Understand the components of the [RStudio IDE](#rstudio_ide)
    2. Type commands into the [console](#console)
    3. Understand [function syntax](#function_syx)
    4. Install a [package](#install-package)
    5. [Organise a project](#projects)
    6. Appropriately [structure an R script or RMarkdown file](#structure)
    7. Create and compile an [Rmarkdown document](#rmarkdown)

2. [Working with Data](#data)
    1. Understand the use the [basic data types](#data_types)
    2. Understand and use the [basic container types](#containers) (list, vector)
    3. [Create vectors](#vectors) and store them as [variables](#vars)
    4. Understand [vectorized operations](#vectorized_ops)
    5. Create a [data table](#tables)
    6. [Import data](#import_data) from CSV and Excel files

3. [Data Visualisation](#ggplot)
    1. Understand what types of graphs are best for [different types of data](#vartypes)
    2. Create common types of graphs with ggplot2
    3. Set custom labels
    4. Represent factorial designs with different colours or facets
    5. [Save plots](#ggsave) as an image file

4. [Tidy Data](#tidyr)
    1. Understand the concept of [tidy data](#tidy-data)
    2. Be able to use the 4 basic `tidyr` verbs: [`gather()`](#gather), [`separate()`](#separate), [`spread()`](#spread), [`unite()`](#unite)
    3. Be able to chain functions using [pipes](#pipes)

5. [Data Wrangling](#dplyr)
    1. Be able to use the 6 main dplyr one-table verbs: [`select()`](#select), [`filter()`](#filter), [`arrange()`](#arrange), [`mutate()`](#mutate), [`summarise()`](#summarise), [`group_by()`](#group_by)

6. [Data Relations](#joins)
    1. Be able to use the 4 mutating join verbs: [`left_join()`](#left_join), [`right_join()`](#right_join), [`inner_join()`](#inner_join), [`full_join()`](#full_join)
    2. Use the [`by`](#join-by) argument to set the join columns

7. [Iteration & Functions](#func)
    1. Work with [iteration functions](#iteration-functions): `rep()`, `seq()`, and `replicate()`
    2. Use [arguments](#arguments) by order or name
    3. Write your own [custom functions](#custom-functions) with `function()`
    4. Set [default values](#defaults) for the arguments in your functions

8. [Probability & Simulation](#sim)
    1. Understand what types of data are best modeled by different distributions: uniform, binomial, normal, poisson
    2. Generate and plot data randomly sampled from the above distributions
    3. Test sampled distributions against a null hypothesis using: exact binomial test, t-test (1-sample, independent samples, paired samples), correlation (pearson, kendall and spearman)
    4. Define the following statistical terms: p-value, alpha, power, false positive (type I error), false negative (type II error), confidence interval

9. [Introduction to GLM](#glm)
    1. Prove to yourself the correspondence among two-sample t-test, one-way ANOVA, and linear regression with dummy coding
    2. Given data and a GLM, generate a decomposition matrix and calculate sums of squares, mean squares, and F ratios

10. [Reproducible Workflows](#repro)
    1. Create a reproducible script in R Markdown
    2. Edit the YAML header to add table of contents and other options
    3. Include a table 
    4. Include a figure 
    5. Use `source()` to include code from an external file 
    6. Report the output of an analysis using inline R


## Formative Exercises

Exercises are available at the end of each lesson's webpage. These are not marked or mandatory, but if you can work through each of these (using web resources, of course), you will easily complete the marked assessments. 

* [01 intro](exercises/01_intro_stub.Rmd): Intro to R, functions, R markdown
* [02 data](exercises/02_data_stub.Rmd): Vectors, tabular data, data import, pipes
* [Essential Skills](exercises/essential_skills_stub.Rmd): You must be able to complete these exercises to advance in the class beyond the first two lectures
* [03 ggplot](exercises/03_ggplot_stub.Rmd): Data visualisation
* [04 tidyr](exercises/04_tidyr_stub.Rmd): Tidy Data
* [05 dplyr](exercises/05_dplyr_stub.Rmd): Data wrangling
* [06 joins](exercises/06_joins_stub.Rmd): Data relations
* [07 functions](exercises/07_func_stub.Rmd): Functions and iteration
* [08 simulation](exercises/08_sim_stub.Rmd): Simulation
* [09 glm](exercises/09_glm_stub.Rmd): GLM

## Packages used in this book

* tidyverse
* cowsay
* [goodshirt](https://github.com/adam-gruer/goodshirt)
* ukbabynames
* cowplot
* plotly
* MASS

## Resources

Miscellanous materials added throughout the semester, such tips on installation, or the results of live-coding demos, can be found in the [Miscellaneous](11_misc.html) section.

<div style="width: 300px; max-width: 100%; float: right;">
  <img src="images/changing-stuff.jpg" style="width:100%;" />
</div>

- <a href="http://rstudio1.psy.gla.ac.uk" target="_blank">Glasgow Psychology RStudio</a> 
- [Learning Statistics with R](https://learningstatisticswithr-bookdown.netlify.com) by Navarro
- [R for Data Science](http://r4ds.had.co.nz) by Grolemund and Wickham

### Online tutorials

- [swirl](http://swirlstats.com)
- [R for Reproducible Scientific Analysis](http://swcarpentry.github.io/r-novice-gapminder/)
- [codeschool.com](http://tryr.codeschool.com)
- [datacamp](https://www.datacamp.com/courses/free-introduction-to-r)
- [Improving your statistical inferences](https://www.coursera.org/learn/statistical-inferences/) on Coursera

### Cheat sheets
  
- You can access several cheatsheets in RStudio under the `Help` menu
- Or get the most recent [RStudio Cheat Sheets](https://www.rstudio.com/resources/cheatsheets/) 

### Other

- [Style guide for R programming](http://style.tidyverse.org)
- [#rstats on twitter](https://twitter.com/search?q=%2523rstats) highly recommended!





