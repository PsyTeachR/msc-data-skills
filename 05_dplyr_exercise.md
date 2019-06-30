---
title: 'Formative Exercise 05: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



## UK Baby Names

Here we will convert the data table from the ukbabynames package to a tibble and assign it the variable name `ukb`. Use this data tibble for questions 1-13.


```r
# do not alter this code chunk
ukb <- as_tibble(ukbabynames) # convert to a tibble
```


### Question 1

How many records are in the dataset?


```r
nrecords <- NULL
```

### Question 2

Remove the column `rank` from the dataset.


```r
norank <- NULL
```

### Question 3

What is the range of birth years contained in the dataset? Use `summarise` to make a table with two columns: `minyear` and `maxyear`.


```r
birth_range <- NULL
```

### Question 4

Make a table of only the data from babies named Hermione.


```r
hermiones <- NULL
```

### Question 5

Sort the dataset by sex and then by year (descending) and then by rank (descending).


```r
sorted_babies <- NULL
```

### Question 6

Create a new column, `decade`, that contains the decade of birth (1990, 2000, 2010).  Hint: see `?floor`


```r
ukb_decade <- NULL
```

### Question 7

Make a table of only the data from male babies named Courtney that were born between 1998 and 2001 (inclusive).


```r
courtney <- NULL
```


### Question 8

How many distinct names are represented in the dataset? Make sure `distinct_names` is an integer, not a data table.


```r
distinct_names <- NULL
```

### Question 9

Make a table of only the data from the female babies named Frankie that were born before 1999 or after 2010.


```r
frankie <- NULL
```

### Question 10

How many total babies in the dataset were named 'Emily'? Make sure `emily` is an integer, not a data table.


```r
emily <- NULL
```

### Question 11

How many distinct names are there for each sex?


```r
names_per_sex <- NULL
```

### Question 12

What is the most popular name in the dataset?


```r
most_popular <- NULL
```

### Question 13

How many babies were born each year for each sex?  Make a plot.


```r
babies_per_year <- NULL

ggplot(babies_per_year)
```

![plot of chunk Q13](figure/Q13-1.png)

## Advanced Questions

There are several ways to complete the following two tasks. Different people will solve them different ways, so they cannot be automatically checked, but you should be able to tell if your answers make sense.

### Question 14

Load the dataset [family_composition.csv](https://psyteachr.github.io/msc-data-skills/data/family_composition.csv) from last week's exercise.

The columns `oldbro` through `twinsis` give the number of siblings of that age and sex. Put this into long format and create separate columns for sibling age (old, young, twin) and sex (bro, sis). 

Then, calculate how many siblings of each sex each person has, narrow the dataset down to people with fewer than 6 siblings, and generate at least two different ways to graph this.

    

```r
sib6 <- NULL

ggplot(sib6)
```

![plot of chunk Q14a](figure/Q14a-1.png)
    

```r
ggplot(sib6)
```

![plot of chunk Q14b](figure/Q14b-1.png)


### Question 15

Use the data from [eye_descriptions.csv](https://psyteachr.github.io/msc-data-skills/data/eye_descriptions.csv) from last week's exercise.

Create a list of the 10 most common descriptions from the eyes dataset. Remove useless descriptions and merge redundant descriptions. Display the table by piping the resulting tibble to `knitr::kable()`.
    

```r
eyes <- NULL

knitr::kable(eyes) # displays the table in a nice format
```

```
## Warning in kable_markdown(x = structure(character(0), .Dim = c(0L,
## 0L), .Dimnames = list(: The table should have a header (column names)
```



||
||
||
||

## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                               |Answer    |
|:--------------------------------------|:---------|
|<a href='#question-1'>Question 1</a>   |incorrect |
|<a href='#question-2'>Question 2</a>   |incorrect |
|<a href='#question-3'>Question 3</a>   |incorrect |
|<a href='#question-4'>Question 4</a>   |incorrect |
|<a href='#question-5'>Question 5</a>   |incorrect |
|<a href='#question-6'>Question 6</a>   |incorrect |
|<a href='#question-7'>Question 7</a>   |incorrect |
|<a href='#question-8'>Question 8</a>   |incorrect |
|<a href='#question-9'>Question 9</a>   |incorrect |
|<a href='#question-10'>Question 10</a> |incorrect |
|<a href='#question-11'>Question 11</a> |incorrect |
|<a href='#question-12'>Question 12</a> |incorrect |
|<a href='#question-13'>Question 13</a> |incorrect |



