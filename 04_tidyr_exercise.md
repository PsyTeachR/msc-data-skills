---
title: 'Formative Exercise 04: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



## Pipes

### Question 1

Re-write the following sequence of commands into a single 'pipeline'.


```r
# do not edit this chunk
x <- 1:20 # integers from 1:20
y <- rep(x, 2) # then repeat them twice
z <- sum(y) # and then take the sum
```


```r
x <- NULL
```

### Question 2

Deconstruct the pipeline below back into separate commands.


```r
# do not edit this chunk
lager <- LETTERS[c(18, 5, 7, 1, 12)] %>%
  rev() %>%
  paste(collapse = "")
```


```r
regal <- NULL
reversed <- NULL
lager <- NULL # make it into a string
```


## Sensation Seeking 

Questions 3-7 all have errors. Fix the errors in the code blocks below them.

### Question 3

Load the data from [sensation_seeking.csv](https://psyteachr.github.io/msc-data-skills/data/sensation_seeking.csv).


```r
ss <- read_csv(https://psyteachr.github.io/msc-data-skills/data/sensation_seeking.csv)
```

```
## Error: <text>:1:22: unexpected '/'
## 1: ss <- read_csv(https:/
##                          ^
```


```r
ss <- NULL
```


### Question 4

Convert from wide to long format.

```r
ss_long <- gather(ss, "question", "score")
```

```
## Error in UseMethod("gather_"): no applicable method for 'gather_' applied to an object of class "NULL"
```

    

```r
ss_long <- NULL
```

    
### Question 5

Split the `question` column into two columns: `domain` and `qnumber`.

```r
ss_sep <- ss_long %>%
  separate(question, domain, qnumber, sep = 3)
```

```
## Error in UseMethod("separate_"): no applicable method for 'separate_' applied to an object of class "NULL"
```


```r
ss_sep <- NULL
```

    
### Question 6

Put the `id` and `user_id` columns together into a new column named `super_id`. Make it in a format like "id-user_id".

```r
ss_unite <- ss_sep %>%
  unite(id, user_id, "super_id", sep = "-")
```

```
## Error in UseMethod("unite_"): no applicable method for 'unite_' applied to an object of class "NULL"
```


```r
ss_unite <- NULL
```

 
### Question 7

Convert back to wide format.

```r
ss_wide <- ss_unite %>%
  spreadr(qnumber, score)
```

```
## Error in spreadr(., qnumber, score): could not find function "spreadr"
```


```r
ss_wide <- NULL
```

## Family Composition

### Question 8

Load the dataset [family_composition.csv](https://psyteachr.github.io/msc-data-skills/data/family_composition.csv).

The columns `oldbro` through `twinsis` give the number of siblings of that age and sex. Put this into long format and create separate columns for sibling age (`sibage` = old, young, twin) and sex (`sibsex` = bro, sis).


```r
family <- NULL
```


## Eye Descriptions

### Question 9

Tidy the data from [eye_descriptions.csv](https://psyteachr.github.io/msc-data-skills/data/eye_descriptions.csv). This dataset contains descriptions of the eyes of 50 people. Some raters wrote more than one description per face (maximum 4), separated by commas, semicolons, or slashes. 

Create a dataset with separate columns for `face_id`, `description`, and description number (`desc_n`). Hint: to separate a string by tildes or slashes, you would set the `sep` argument to `"(~|\\/)+"`.
    

```r
eyes <- NULL
```

## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|Question                             |Answer    |
|:------------------------------------|:---------|
|<a href='#question-1'>Question 1</a> |incorrect |
|<a href='#question-2'>Question 2</a> |incorrect |
|<a href='#question-3'>Question 3</a> |incorrect |
|<a href='#question-4'>Question 4</a> |incorrect |
|<a href='#question-5'>Question 5</a> |incorrect |
|<a href='#question-6'>Question 6</a> |incorrect |
|<a href='#question-7'>Question 7</a> |incorrect |
|<a href='#question-8'>Question 8</a> |incorrect |
|<a href='#question-9'>Question 9</a> |incorrect |

