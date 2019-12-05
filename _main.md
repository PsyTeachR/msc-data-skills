--- 
title: Data Skills for Reproducible Science
date: "2019-11-15"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib]
biblio-style: apalike
link-citations: yes
description: "This course provides an overview of skills needed for reproducible research and open science using the statistical programming language R. Students will learn about data visualisation, data tidying and wrangling, archiving, iteration and functions, probability and data simulations, general linear models, and reproducible workflows. Learning is reinforced through weekly assignments that involve working with different types of data."
---

# Overview {-}

Placeholder


## Course Aims
## Intended Learning Outcomes
## Course Outline
## Formative Exercises
## Packages used in this book
## Resources
### Online tutorials
### Cheat sheets
### Other

<!--chapter:end:index.Rmd-->


# Getting Started {#intro}

Placeholder


## Learning Objectives
## Resources
## What is R?
### The Base R Console {#rconsole}
### RStudio {#rstudio_ide}
### Configure RStudio
## Getting Started
### Console commands {#console}
### Variables {#vars}
### The environment
### Whitespace
### Function syntax {#function_syx}
### Getting help {#help}
## Add-on packages {#install-package}
### Installing a package 
### Loading a package
### Install from GitHub
## Organising a project {#projects}
### Structure {#structure}
### Reproducible reports with R Markdown {#rmarkdown}
### Working Directory
## Exercises

<!--chapter:end:01-intro.Rmd-->


# Working with Data {#data}

Placeholder


## Learning Objectives
## Resources
## Basic data types {#data_types}
## Basic container types {#containers}
### Vectors {#vectors}
#### Selecting values from a vector
#### Repeating Sequences
#### Vectorized Operations {#vectorized_ops}
#### Exercises {#ex_vector}
### Lists
### Tabular data {#tables}
#### Viewing your tibble
#### Accessing rows and columns
#### Exercises {#ex_tibble}
## Importing data {#import_data}
### Writing Data
## Exercises

<!--chapter:end:02-data.Rmd-->


# Data Visualisation {#ggplot}

Placeholder


## Learning Objectives
### Basic
### Intermediate
### Advanced
## Resources
## Setup
## Common Variable Combinations {#vartypes}
### Data
## Basic Plots
### Bar plot {#geom_bar}
### Density plot {#geom_density}
### Frequency Polygons {#geom_freqpoly}
### Histogram {#geom_histogram}
### Column plot {#geom_col}
### Boxplot {#geom_boxplot}
### Violin plot {#geom_violin}
### Scatter plot {#geom_point}
### Line graph {#geom_smooth}
## Customisation
### Labels {#custom-labels}
### Colours {#custom-colours}
### Save as File {#ggsave}
## Combination Plots
### Violinbox plot
### Violin-point-range plot
### Violin-jitter plot
### Scatter-line graph
### Grid of plots {#cowplot}
## Overlapping Discrete Data {#overlap}
### Reducing Opacity 
### Proportional Dot Plots {#geom_count}
## Overlapping Continuous Data
### 2D Density Plot {#geom_density2d}
### 2D Histogram {#geom_bin2d}
### Hexagonal Heatmap {#geom_hex}
### Correlation Heatmap {#geom_tile}
## Interactive Plots {#plotly}
## Quiz {#ggplot-quiz}
## Exercises

<!--chapter:end:03-ggplot.Rmd-->


# Tidy Data {#tidyr}

Placeholder


## Learning Objectives
### Basic
### Intermediate
### Advanced
## Resources
## Setup
## Three Rules for Tidy Data {#tidy-data}
## Tidying Data
### gather() {#gather}
### separate() {#separate} 
### unite() {#unite} 
### spread() {#spread} 
## Pipes {#pipes}
## More Complex Example
### Load Data 
### Wide to Long
### One Piece of Data per Column
#### Handle spare columns with `extra` {#extra}
#### Set delimiters with `sep` {#sep}
#### Fix data types with `convert` {#convert}
### All in one step
### Columns by Year
### Merge Columns
#### Control separation with `sep`
## Quiz {#tidyr-quiz}
## Exercises

<!--chapter:end:04-tidyr.Rmd-->


# Data Wrangling {#dplyr}

Placeholder


## Learning Objectives
### Basic
### Intermediate
### Advanced
## Resources
## Setup
## The `disgust` dataset {#data-disgust}
## Six main dplyr verbs
### select() {#select}
#### `starts_with()` {#starts_with}
#### `ends_with()` {#ends_with}
#### `contains()` {#contains}
#### `num_range()` {#num_range}
### filter() {#filter}
#### Dates {#dates}
### arrange() {#arrange}
### mutate() {#mutate}
### summarise() {#summarise}
### group_by() {#group_by}
### All Together
## Additional dplyr one-table verbs
### rename() {#rename}
### distinct() {#distinct}
### count() {#count}
### slice() {#slice}
### pull() {#pull}
## Window functions {#window}
### Ranking functions
### Offset functions
### Cumulative aggregates
## Exercises

<!--chapter:end:05-dplyr.Rmd-->


# Data Relations {#joins}

Placeholder


## Learning Objectives
### Beginner
### Intermediate
## Resources
## Data
## Mutating Joins
### left_join() {#left_join}
### right_join() {#right_join}
### inner_join() {#inner_join}
### full_join() {#full_join}
## Filtering Joins
### semi_join() {#semi_join}
### anti_join() {#anti_join}
## Binding Joins
### bind_rows() {#bind_rows}
### bind_cols() {#bind_cols}
## Set Operations
### intersect() {#intersect}
### union() {#union}
### setdiff() {#setdiff}
## Exercises

<!--chapter:end:06-joins.Rmd-->


# Iteration & Functions {#func}

Placeholder


## Learning Objectives
### Basic
### Intermediate
### Advanced
## Resources
## Iteration functions {#iteration-functions}
### `rep()`
### `seq()`
### `aov()`, `summary()`, and `broom::tidy()`
## Custom functions {#custom-functions}
### Structuring a function {#structure-function}
### Arguments {#arguments}
### Argument defaults {#defaults}
### Scope {#scope}
### Warnings and errors {#warnings-errors}
## Iterating your own functions
### `rnorm()`
### `tibble::tibble()`
### `t.test`
### `broom::tidy()`
### Turn into a function
### `replicate()`
### Set seed {#seed}
### Add arguments
## Exercises

<!--chapter:end:07-func.Rmd-->


# Probability & Simulation {#sim}

Placeholder


## Learning Objectives
### Basic
### Intermediate
### Advanced
## Resources
## Distributions
### Uniform Distribution {#uniform}
#### Sample continuous distribution
#### Sample discrete distribution
### Binomial Distribution {#binomial}
#### Sample distribution
#### Exact binomial test {#exact-binom}
#### Statistical terms {#stat-terms}
#### Sampling function
#### Calculate power {#calc-power}
### Normal Distribution {#normal}
#### Sample distribution
#### T-test {#t-test}
#### Sampling function
### Bivariate Normal
#### Correlation {#correlation}
#### Sample distribution {#bvn}
### Multivariate Normal {#mvnorm}
#### Sample distribution
#### 3D Plots
## Example
### Load & wrangle
### Plot
### Get means and SDs
### Simulate a population
### Analyse simulated data
### Replicate simulation
### One-tailed prediction
### Range of sample sizes
## Exercises

<!--chapter:end:08-sim.Rmd-->


# Introduction to GLM {#glm}

Placeholder


## Learning Objectives
### Basic
### Intermediate
## Resources
## Setup
## GLM
### What is the GLM?
### Components {#glm-components}
### Simulating data from GLM {#sim-glm}
### Linear Regression
### Residuals {#residuals}
### Predict New Values {#predict}
### Coding Categorical Variables {#coding-schemes}
## Relationships among tests {#test-rels}
### T-test
### ANOVA
## Understanding ANOVA
### Means, Variability, and Deviation Scores
### Decomposition matrices {#decomp}
## Exercises

<!--chapter:end:09-glm.Rmd-->


# Reproducible Workflows {#repro}

Placeholder


## Learning Objectives
### Basic
### Intermediate
### Advanced
## Resources
## R Markdown
### knitr options
### YAML Header
### TOC and Document Headers
### Code Chunks
#### Tables
#### Images
#### In-line R
### Bibliography
#### Create a BibTeX File Manually
#### Citing R packages
#### Download Citation Info
#### Converting from reference software
#### In-text citations
#### Citation Styles
### Output Formats
### Computational Reproducibility
## References

<!--chapter:end:10-repro.Rmd-->


# Acknowledgements {-}

The whole [psyTeachR](https://psyteachr.github.io) team at the University of Glasgow School of Psychology deserves enormous thanks for making it possible and rewarding to teach methods with a focus on reproducibility and open science. Particularly [Heather Cleland Woods](https://github.com/clelandwoods/), [Phil McAleer](https://github.com/philmcaleer), [Helena Paterson](https://github.com/HelenaPaterson), [Emily Nordmann](https://github.com/emilynordmann/), [Benedict Jones](http://facelab.org/People/benjones), and [Niamh Stack](https://github.com/eavanmac). We greatly appreciate [Iris Holzleitner](https://github.com/orgs/facelab/people/iholzleitner)'s volunteer in-class assistance with the first year of this course. We were ever so lucky to get [Rebecca Lai](https://github.com/RebeccaJLai) as a teaching assistant in the second year; her kind and patient approach to teaching technical skills is an inspiration. Thanks to [Daniël Lakens](https://github.com/Lakens) for many inspirational discussions and resources.

## Contributors

Several people contributed to testing these materials.

* [Rebecca Lai](https://github.com/RebeccaJLai)
* [Richard Morey](https://github.com/richarddmorey)
* [Mossa Merhi Reimert](https://github.com/CGMossa)

<!--chapter:end:11_acknowledgements.Rmd-->


# (APPENDIX) Appendices {-} 

<!--chapter:end:appendix-0.Rmd-->


# Installing R {#installingr}

Installing R and RStudio is usually straightforward. The sections below explain how and [there is a helpful YouTube video here](https://www.youtube.com/watch?v=lVKMsaWju8w).

## Installing Base R

Install base R from <https://cran.rstudio.com/>. Choose the download link for your operating system (Linux, Mac OS X, or Windows).

If you have a Mac, install the latest release from the newest `R-x.x.x.pkg` link (or a legacy version if you have an older operating system). After you install R, you should also install [XQuartz](http://xquartz.macosforge.org/) to be able to use some visualisation packages.

If you are installing the Windows version, choose the "[base](https://cran.rstudio.com/bin/windows/base/)" subdirectory and click on the download link at the top of the page. After you install R, you should also install [RTools](https://cran.rstudio.com/bin/windows/Rtools/); use the "recommended" version highlighted near the top of the list.

If you are using Linux, choose your specific operating system and follow the installation instructions.

## Installing RStudio

Go to [rstudio.com](https://www.rstudio.com/products/rstudio/download/#download) and download the RStudio Desktop (Open Source License) version for your operating system under the list titled **Installers for Supported Platforms**.

## Installing LaTeX

You can install the LaTeX typesetting system to produce PDF reports from RStudio. Without this additional installation, you will be able to produce reports in HTML but not PDF. To generate PDF reports, you will additionally need: 

1.  [pandoc](http://pandoc.org/installing.html), and
2.  LaTeX, a typesetting language, available for
    - WINDOWS: [MikTeX](http://miktex.org/)
    - Mac OS: [MacTex](https://tug.org/mactex/downloading.html) (3.2GB download) or [BasicTeX](http://ww.tug.org/mactex/morepackages.html) (78MB download, but should work fine)
    - Linux: [TeX Live](https://www.tug.org/texlive/)


<!--chapter:end:appendix-a-installing-r.Rmd-->


# Symbols {#symbols}

Placeholder



<!--chapter:end:appendix-b-symbols.Rmd-->


# Exercise Answers {#exercise-answers}

Download all [exercises and data files](exercises/msc-data-skills-exercises.zip) below as a ZIP archive. The answers are not included in the zip file.

* [01 intro](exercises/01_intro_exercise.Rmd) ([answers](exercises/01_intro_answers.html)): Intro to R, functions, R markdown
* [02 data](exercises/02_data_exercise.Rmd) ([answers](exercises/02_data_answers.html)): Vectors, tabular data, data import, pipes
* [Essential Skills](exercises/essential_skills_exercise.Rmd) ([answers](exercises/essential_skills_answers.html)): You must be able to complete these exercises to advance in the class beyond the first two lectures
* [03 ggplot](exercises/03_ggplot_exercise.Rmd) ([answers](exercises/03_ggplot_answers.html)): Data visualisation
* [04 tidyr](exercises/04_tidyr_exercise.Rmd) ([answers](exercises/04_tidyr_answers.html)): Tidy Data
* [05 dplyr](exercises/05_dplyr_exercise.Rmd) ([answers](exercises/05_dplyr_answers.html)): Data wrangling
* [06 joins](exercises/06_joins_exercise.Rmd) ([answers](exercises/06_joins_answers.html)): Data relations
* [07 functions](exercises/07_func_exercise.Rmd) ([answers](exercises/07_func_answers.html)): Functions and iteration
* [08 simulation](exercises/08_sim_exercise.Rmd) ([answers](exercises/08_sim_answers.html)): Simulation
* [09 glm](exercises/09_glm_exercise.Rmd) ([answers](exercises/09_glm_answers.html)): GLM

<!--chapter:end:appendix-c-answers.Rmd-->


# Datasets {#datasets}

Placeholder



<!--chapter:end:appendix-d-datasets.Rmd-->


# Agenda 2019 {#agenda-2019}

Placeholder


## 2019-09-27 Class 1
### Welcome to Data Skills for Reproducible Science!
## 2019-10-04 Class 2
## 2019-10-11 Class 3
## 2019-10-18 Class 4

<!--chapter:end:appendix-e-agenda.Rmd-->


# References

<!--chapter:end:references.Rmd-->

