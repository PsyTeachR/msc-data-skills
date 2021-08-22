--- 
title: Data Skills for Reproducible Science
date: "2021-08-22"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib]
biblio-style: apalike
link-citations: yes
description: "This course provides an overview of skills needed for reproducible research and open science using the statistical programming language R. Students will learn about data visualisation, data tidying and wrangling, archiving, iteration and functions, probability and data simulations, general linear models, and reproducible workflows. Learning is reinforced through weekly assignments that involve working with different types of data."
---

# Overview {-}

<img src="images/data_skills.png" style="width: 200px; float: right;"
     alt="Hex sticker, blue, text: MSC DATA SKILLS">

This course provides an overview of skills needed for reproducible research and open science using the statistical programming language R. Students will learn about data visualisation, data tidying and wrangling, archiving, iteration and functions, probability and data simulations, general linear models, and reproducible workflows. Learning is reinforced through weekly assignments that involve working with different types of data.


## Course Aims

This course aims to teach students the basic principles of reproducible research and to provide practical training in data processing and analysis in the statistical programming language R.


## Intended Learning Outcomes

<img src="images/memes/changing-stuff.jpg" class="right meme"
     alt="Fake O'Reilly-style book cover, line drawing of a kitten; title: Changing Stuff and Seeing What Happens; top text: How to actually learn any new programming concept"/>

By the end of this course students will be able to:

*	Write scripts in R to organise and transform data sets using best accepted practices
*	Explain basics of probability and its role in statistical inference
*	Critically analyse data and report descriptive and inferential statistics in a reproducible manner

## Course Resources

* [Data Skills Videos](https://www.youtube.com/playlist?list=PLA2iRWVwbpTIweEBHD2dOKjZHK1atRmXt){target="_blank"}
    Each chapter has several short video lectures for the main learning outcomes at the playlist . The videos are captioned and watching with the captioning on is a useful way to learn the jargon of computational reproducibility. If you cannot access YouTube, the videos are available on the course Teams and Moodle sites or by request from the instructor.

* [dataskills](https://github.com/psyteachr/msc-data-skills){target="_blank"}
    This is a custom R package for this course. You can install it with the code below. It will download all of the packages that are used in the book, along with an offline copy of this book, the shiny apps used in the book, and the exercises.
    
    
    ```r
    devtools::install_github("psyteachr/msc-data-skills")
    ```

* [glossary](https://github.com/psyteachr/glossary){target="_blank"}
    Coding and statistics both have a lot of specialist terms. Throughout this book, jargon will be linked to the glossary.


## Course Outline

The overview below lists the beginner learning outcomes only. Some lessons have additional learning outcomes for intermediate or advanced students.

1. [Getting Started](#intro)
    1. Understand the components of the [RStudio IDE](#rstudio_ide)
    2. Type commands into the [console](#console)
    3. Understand [function syntax](#function_syx)
    4. Install a [package](#install-package)
    5. Organise a [project](#projects)
    6. Create and compile an [Rmarkdown document](#rmarkdown)

2. [Working with Data](#data)
    1. Load [built-in datasets](#builtin)
    2. [Import data](#import_data) from CSV and Excel files
    3. Create a [data table](#tables)
    4. Understand the use the [basic data types](#data_types)
    5. Understand and use the [basic container types](#containers) (list, vector)
    6. Use [vectorized operations](#vectorized_ops)
    7. Be able to [troubleshoot](#Troubleshooting) common data import problems

3. [Data Visualisation](#ggplot)
    1. Understand what types of graphs are best for [different types of data](#vartypes)
    2. Create common types of graphs with ggplot2
    3. Set custom [labels](#custom-labels),  [colours](#custom-colours), and [themes](#themes)
    4. [Combine plots](combo_plots) on the same plot, as facets, or as a grid using cowplot
    5. [Save plots](#ggsave) as an image file

4. [Tidy Data](#tidyr)
    1. Understand the concept of [tidy data](#tidy-data)
    2. Be able to convert between long and wide formats using [pivot functions](#pivot)
    3. Be able to use the 4 basic [`tidyr` verbs](#tidy-verbs)
    4. Be able to chain functions using [pipes](#pipes)

5. [Data Wrangling](#dplyr)
    1. Be able to use the 6 main dplyr one-table verbs: [`select()`](#select), [`filter()`](#filter), [`arrange()`](#arrange), [`mutate()`](#mutate), [`summarise()`](#summarise), [`group_by()`](#group_by)
    2. Be able to [wrangle data by chaining tidyr and dplyr functions](#all-together)
    3. Be able to use these additional one-table verbs: [`rename()`](#rename), [`distinct()`](#distinct), [`count()`](#count), [`slice()`](#slice), [`pull()`](#pull)

6. [Data Relations](#joins)
    1. Be able to use the 4 mutating join verbs: [`left_join()`](#left_join), [`right_join()`](#right_join), [`inner_join()`](#inner_join), [`full_join()`](#full_join)
    2. Be able to use the 2 filtering join verbs: [`semi_join()`](#semi_join), [`anti_join()`](#anti_join)
    3. Be able to use the 2 binding join verbs: [`bind_rows()`](#bind_rows), [`bind_cols()`](#bind_cols)
    4. Be able to use the 3 set operations: [`intersect()`](#intersect), [`union()`](#union), [`setdiff()`](#setdiff)

7. [Iteration & Functions](#func)
    1. Work with [iteration functions](#iteration-functions): `rep()`, `seq()`, and `replicate()`
    2. Use [`map()` and `apply()` functions](#map-apply) 
    3. Write your own [custom functions](#custom-functions) with `function()`
    4. Set [default values](#defaults) for the arguments in your functions

8. [Probability & Simulation](#sim)
    1. Generate and plot data randomly sampled from common distributions: uniform, binomial, normal, poisson
    2. Generate related variables from a [multivariate](#mvdist) distribution
    3. Define the following statistical terms: [p-value](#p-value), [alpha](#alpha), [power](#power), smallest effect size of interest ([SESOI](#sesoi)), [false positive](#false-pos) (type I error), [false negative](#false-neg) (type II error), confidence interval ([CI](#conf-inf))
    4. Test sampled distributions against a null hypothesis using: [exact binomial test](#exact-binom), [t-test](#t-test) (1-sample, independent samples, paired samples), [correlation](#correlation) (pearson, kendall and spearman)
    5. [Calculate power](#calc-power-binom) using iteration and a sampling function

9. [Introduction to GLM](#glm)
    1. Define the [components](#glm-components) of the GLM
    2. [Simulate data](#sim-glm) using GLM equations
    3. Identify the model parameters that correspond to the data-generation parameters
    4. Understand and plot [residuals](#residuals)
    5. [Predict new values](#predict) using the model
    6. Explain the differences among [coding schemes](#coding-schemes) 

10. [Reproducible Workflows](#repro)
    1. Create a reproducible script in R Markdown
    2. Edit the YAML header to add table of contents and other options
    3. Include a table 
    4. Include a figure 
    5. Use `source()` to include code from an external file 
    6. Report the output of an analysis using inline R



## Formative Exercises

Exercises are available at the end of each lesson's webpage. These are not marked or mandatory, but if you can work through each of these (using web resources, of course), you will easily complete the marked assessments. 

Download all [exercises and data files](exercises/msc-data-skills-exercises.zip) below as a ZIP archive.

* [01 intro](exercises/01_intro_exercise.Rmd): Intro to R, functions, R markdown
* [02 data](exercises/02_data_exercise.Rmd): Vectors, tabular data, data import, pipes
* [03 ggplot](exercises/03_ggplot_exercise.Rmd): Data visualisation
* [04 tidyr](exercises/04_tidyr_exercise.Rmd): Tidy Data
* [05 dplyr](exercises/05_dplyr_exercise.Rmd): Data wrangling
* [06 joins](exercises/06_joins_exercise.Rmd): Data relations
* [07 functions](exercises/07_func_exercise.Rmd): Functions and iteration
* [08 simulation](exercises/08_sim_exercise.Rmd): Simulation
* [09 glm](exercises/09_glm_exercise.Rmd): GLM


## I found a bug!

This book is a work in progress, so you might find errors. Please help me fix them! The best way is to open an [issue on github](https://github.com/PsyTeachR/msc-data-skills/issues){target="_blank"} that describes the error, but you can also mention it on the class Teams forum or [email Lisa](mailto:lisa.debruine@glasgow.ac.uk?subject=msc-data-skills).

## Other Resources 

- [Learning Statistics with R](https://learningstatisticswithr-bookdown.netlify.com) by Navarro
- [R for Data Science](http://r4ds.had.co.nz) by Grolemund and Wickham
- [swirl](http://swirlstats.com)
- [R for Reproducible Scientific Analysis](http://swcarpentry.github.io/r-novice-gapminder/)
- [codeschool.com](http://tryr.codeschool.com)
- [datacamp](https://www.datacamp.com/courses/free-introduction-to-r)
- [Improving your statistical inferences](https://www.coursera.org/learn/statistical-inferences/) on Coursera
- You can access several cheatsheets in RStudio under the `Help` menu, or get the most recent [RStudio Cheat Sheets](https://www.rstudio.com/resources/cheatsheets/) 
- [Style guide for R programming](http://style.tidyverse.org)
- [#rstats on twitter](https://twitter.com/search?q=%2523rstats) highly recommended!


