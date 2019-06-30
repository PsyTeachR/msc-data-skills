---
title: 'Formative Exercise 06: MSc Data Skills Course'
author: "Psychology, University of Glasgow"
output: html_document
---



This file contains some answer checks after each question. Do not edit this text. When you knit your Rmd file, the checks will give you some information about whether your code created the correct objects.

## Mutating joins

### Question 1A

Load data from [disgust_scores.csv](https://psyteachr.github.io/msc-data-skills/data/disgust_scores.csv) (`disgust`), [personality_scores.csv](https://psyteachr.github.io/msc-data-skills/data/personality_scores.csv) (`ocean`) and [users.csv](https://psyteachr.github.io/msc-data-skills/data/users.csv) (`user`). Each participant is identified by a unique `user_id`.


```r
disgust <- NULL
ocean <- NULL
user <- NULL
```

### Question 1B

Add participant data to the disgust table.


```r
study1 <- NULL
```


### Question 1C

*Intermediate*: Calculate the age of each participant on the date they did the disgust questionnaire and put this in a column called `age_years` in a new table called `study1_ages`. Round to the nearest tenth of a year. 


```r
study1_ages <- NULL
```
    
Answer Checks:

* Your table `study1_ages` **does not** have a column called `age_years`
* The mean age should be 25.39, your mean age is NA


### Question 2A

Add the participant data to the disgust data, but have the columns from the participant table first.


```r
study2 <- NULL
```


### Question 2B

*Intermediate*: How many times was the disgust questionnaire completed by each sex? Create a table called `study2_by_sex` that has two columns: `sex` and `n`.


```r
study2_by_sex <- NULL
```


### Question 2C

*Advanced*: Make a graph of how many people completed the questionnaire each year.
    

```r
ggplot()
```

![plot of chunk ex-2-a](figure/ex-2-a-1.png)
    

### Question 3A

Create a table with only disgust and personality data from the same `user_id` collected on the same `date`.


```r
study3 <- NULL
```


### Question 3B

*Intermediate*: Join data from the same `user_id`, regardless of `date`. Does this give you the same data table as above?
    

```r
study3_nodate <- NULL
```


### Question 4

Create a table of the disgust and personality data with each `user_id:date` on a single row, containing _all_ of the data from both tables.

    

```r
study4 <- NULL
```

## Filtering joins

### Question 5

Create a table of just the data from the disgust table for users who completed the personality questionnaire that same day.
    

```r
study5 <- NULL
```

    
### Question 6

Create a table of data from users who did not complete either the personality questionnaire or the disgust questionnaire. (_Hint: this will require two steps; use pipes._)

    

```r
study6 <- NULL
```

## Binding and sets

### Question 7

Load new user data from [users2.csv](https://psyteachr.github.io/msc-data-skills/data/users2.csv). Bind them into a single table called `users_all`.


```r
user2 <- NULL
users_all <- NULL
```


### Question 8

How many users are in both the first and second user table?
    

```r
both_n <- NULL
```

### Question 9

How many unique users are there in total across the first and second user tables?


```r
unique_users <- NULL
```

### Question 10

How many users are in the first, but not the second, user table?


```r
first_users <- NULL
```

### Question 11

How many users are in the second, but not the first, user table?


```r
second_users <- NULL
```

## Answer Checks

You've made it to the end. Make sure you are able to knit this document to HTML. You can check your answers below in the knit document.


|   |Question                               |Answer    |
|:--|:--------------------------------------|:---------|
|1A |<a href='#question-1A'>Question 1A</a> |incorrect |
|1B |<a href='#question-1B'>Question 1B</a> |incorrect |
|1C |<a href='#question-1C'>Question 1C</a> |incorrect |
|2A |<a href='#question-2A'>Question 2A</a> |incorrect |
|2B |<a href='#question-2B'>Question 2B</a> |incorrect |
|3A |<a href='#question-3A'>Question 3A</a> |incorrect |
|3B |<a href='#question-3B'>Question 3B</a> |incorrect |
|4  |<a href='#question-4'>Question 4</a>   |incorrect |
|5  |<a href='#question-5'>Question 5</a>   |incorrect |
|6  |<a href='#question-6'>Question 6</a>   |incorrect |
|7  |<a href='#question-7'>Question 7</a>   |incorrect |
|8  |<a href='#question-8'>Question 8</a>   |incorrect |
|9  |<a href='#question-9'>Question 9</a>   |incorrect |
|10 |<a href='#question-10'>Question 10</a> |incorrect |
|11 |<a href='#question-11'>Question 11</a> |incorrect |
