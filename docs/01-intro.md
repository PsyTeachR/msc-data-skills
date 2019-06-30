
# Getting Started {#intro}


## Learning Objectives

1. Understand the components of the [RStudio IDE](#rstudio_ide)
2. Type commands into the [console](#console)
3. Understand [function syntax](#function_syx)
4. Install a [package](#install-package)
5. [Organise a project](#projects)
6. Appropriately [structure an R script or RMarkdown file](#structure)
7. Create and compile an [Rmarkdown document](#rmarkdown)


## Resources

* [Chapter 1: Introduction](http://r4ds.had.co.nz/introduction.html) in *R for Data Science*
* [RStudio IDE Cheatsheet](https://github.com/rstudio/cheatsheets/raw/master/rstudio-ide.pdf)
* [Introduction to R Markdown](https://rmarkdown.rstudio.com/lesson-1.html)
* [R Markdown Cheatsheet](https://www.rstudio.com/wp-content/uploads/2016/03/rmarkdown-cheatsheet-2.0.pdf)
* [R Markdown Reference](https://www.rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)


## What is R?

<img src="images/01/new_R_logo.png" style="float: right;">

R is a programming environment for data processing and statistical analysis. We use R in Psychology at the University of Glasgow to promote **reproducible research**. This refers to being able to document and reproduce all of the steps between raw data and results. R allows you to write scripts that combine data files, clean data, and run analyses. There are many other ways to do this, including writing SPSS syntax files, but we find R to be a useful tool that is free, open source, and commonly used by research psychologists.

<div class="info">
<p>See Appendix @ref(installing-r) for more information on on how to install R and associated programs.</p>
</div>

### The Base R Console {#rconsole}

If you open up the application called R, you will see an "R Console" window that looks something like this.

<div class="figure" style="text-align: center">
<img src="images/01/r_console.png" alt="The R Console window." width="100%" />
<p class="caption">(\#fig:img-repl)The R Console window.</p>
</div>

You can close R and never open it again. We'll be working entirely in RStudio in this class.

<div class="warning">
<p>ALWAYS REMEMBER: Launch R though the RStudio IDE<br />
<img src="images/01/launch.png" /></p>
</div>

### RStudio {#rstudio_ide}

[RStudio](http://www.rstudio.com) is an Integrated Development Environment (IDE). This is a program that serves as a text editor, file manager, and provides many functions to help you read and write R code.

<div class="figure" style="text-align: center">
<img src="images/01/rstudio.png" alt="The RStudio IDE" width="100%" />
<p class="caption">(\#fig:img-rstudio)The RStudio IDE</p>
</div>

RStudio is arranged with four window <a class='glossary' target='_blank' title='RStudio is arranged with four window “panes”.' href='https://psyteachr.github.io/glossary/p#panes'>panes</a>. By default, the upper left pane is the **source pane**, where you view and edit source code from files. The bottom left pane is usually the **console pane**, where you can type in commands and view output messages. The right panes have several different tabs that show you information about your code. You can change the location of panes and what tabs are shown under **`Preferences > Pane Layout`**.

<video width="640" height="480" controls>
  <source src="http://www.psy.gla.ac.uk/~lisad/r_movies/panes.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>

### Configure RStudio

In this class, you will be learning how to develop **reproducible scripts**.  This means scripts that completely and transparently perform some analysis from start to finish in a way that yields the same result for different people using the same software on different computers. Transparency is a key value of science, as embodied in the "trust but verify" motto. When you do things reproducibly, others can understand and check your work. This benefits science, but there is a selfish reason, too: the most important person who will benefit from a reproducible script is your future self. When you return to an analysis after two weeks of vacation, you will thank your earlier self for doing things in a transparent, reproducible way, as you can easily pick up right where you left off.

There are two tweaks that you should do to your RStudio installation to maximize reproducibility. Go to the preferences/settings menu, and uncheck the box that says **`Restore .RData into workspace at startup`**;.  If you keep things around in your workspace, things will get messy, and unexpected things will happen. You should always start with a clear workspace. This also means that you never want to save your workspace when you exit, so set this to **`Never`**. The only thing you want to save are your scripts.

<div class="figure" style="text-align: center">
<img src="images/01/repro.png" alt="Alter these settings for increased reproducibility." width="50%" />
<p class="caption">(\#fig:img-repro)Alter these settings for increased reproducibility.</p>
</div>

<div class="try">
Your settings should have:

* Restore .RData into workspace at startup: <select class='solveme' data-answer='["Not Checked"]'> <option></option> <option>Checked</option> <option>Not Checked</option></select>
* Save workspace to .RData on exit: <select class='solveme' data-answer='["Never"]'> <option></option> <option>Always</option> <option>Never</option> <option>Ask</option></select>
</div>

## Getting Started

### Console commands {#console}

We are first going to learn about how to interact with the console. In general, you will be developing R scripts or R markdown files, rather than working directly in the console window.  However, you can consider the console a kind of **sandbox** where you can try out lines of code and adapt them until you get them to do what you want. Then you can copy them back into the script editor.

Mostly, however, you will be typing into the script editor window (either into an R script or an R Markdown file) and then sending the commands to the console by placing the cursor on the line and holding down the Ctrl key while you press Enter. The Ctrl+Enter key sequence sends the command in the script to the console.

One simple way to learn about the R console is to use it as a calculator. Enter the lines of code below and see if your results match. Be prepared to make lots of typos (at first) :/


```r
1 + 1
```

```
## [1] 2
```

The R console remembers a history of the commands you typed in the past. Use the up and down arrow keys on your keyboard to scroll backwards and forwards through your history. It's a lot faster than re-typing.


```r
1 + 1 + 3
```

```
## [1] 5
```

You can break up math expressions over multiple lines; R waits for a complete expression before processing it.


```r
## here comes a long expression
## let's break it over multiple lines
1 + 2 + 3 + 4 + 5 + 6 +
    7 + 8 + 9 +
    10
```

```
## [1] 55
```

Text inside quotes is called a <a class='glossary' target='_blank' title='A piece of text inside of quotes.' href='https://psyteachr.github.io/glossary/s#string'>string</a>.


```r
"Good afternoon"
```

```
## [1] "Good afternoon"
```

You can break up text over multiple lines; R waits for a close quote before processing it. If you want to include a double quote inside this quoted string, <a class='glossary' target='_blank' title='Include special characters like " inside of a string by prefacing them with a backslash.' href='https://psyteachr.github.io/glossary/e#escape'>escape</a> it with a backslash.


```r
africa <- "I hear the drums echoing tonight  
But she hears only whispers of some quiet conversation  
She's coming in, 12:30 flight  
The moonlit wings reflect the stars that guide me towards salvation  
I stopped an old man along the way  
Hoping to find some old forgotten words or ancient melodies  
He turned to me as if to say, \"Hurry boy, it's waiting there for you\"

- Toto"

cat(africa) # cat() prints the string
```

```
## I hear the drums echoing tonight  
## But she hears only whispers of some quiet conversation  
## She's coming in, 12:30 flight  
## The moonlit wings reflect the stars that guide me towards salvation  
## I stopped an old man along the way  
## Hoping to find some old forgotten words or ancient melodies  
## He turned to me as if to say, "Hurry boy, it's waiting there for you"
## 
## - Toto
```


### Variables {#vars}

Often you want to store the result of some computation for later use.  You can store it in a <a class='glossary' target='_blank' title='A word that identifies and stores the value of some data for later use.' href='https://psyteachr.github.io/glossary/v#variable'>variable</a>. A variable in R:

* contains only letters, numbers, full stops, and underscores
* starts with a letter or a full stop and a letter
* distinguishes uppercase and lowercase letters (`rickastley` is not the same as `RickAstley`)

The following are valid and different variables:

* songdata
* SongData
* song_data
* song.data
* .song.data
* never_gonna_give_you_up_never_gonna_let_you_down

The following are not valid variables:

* _song_data
* 1song
* .1song
* song data
* song-data

Use the assignment operator `<-` to assign the value on the right to the variable named on the left.


```r
## use the assignment operator '<-'
## R stores the number in the variable
x <- 5
```

Now that we have set `x` to a value, we can do something with it:


```r
x * 2

## R evaluates the expression and stores the result in the variable
boring_calculation <- 2 + 2
```

```
## [1] 10
```

Note that it doesn't print the result back at you when it's stored. To view the result, just type the variable name on a blank line.


```r
boring_calculation
```

```
## [1] 4
```

Once a variable is assigned a value, its value doesn't change unless you reassign the variable, even if the variables you used to calculate it change. Predict what the code below does and test yourself:


```r
this_year <- 2019
my_birth_year <- 1976
my_age <- this_year - my_birth_year
this_year <- 2020
```

<div class="try">
After all the code above is run:

* `this_year` = <select class='solveme' data-answer='["2020"]'> <option></option> <option>43</option> <option>44</option> <option>1976</option> <option>2019</option> <option>2020</option></select>
* `my_birth_year` = <select class='solveme' data-answer='["1976"]'> <option></option> <option>43</option> <option>44</option> <option>1976</option> <option>2019</option> <option>2020</option></select>
* `my_age` = <select class='solveme' data-answer='["43"]'> <option></option> <option>43</option> <option>44</option> <option>1976</option> <option>2019</option> <option>2020</option></select>

</div>


### The environment

Anytime you assign something to a new variable, R creates a new object in the <a class='glossary' target='_blank' title='The interactive workspace where your script runs' href='https://psyteachr.github.io/glossary/g#global-environment'>global environment</a>. Objects in the global environment exist until you end your session; then they disappear forever (unless you save them).

Look at the **Environment** tab in the upper right pane. It lists all of the variables you have created. Click the broom icon to clear all of the variables and start fresh. You can also use the following functions in the console to view all variables, remove one variable, or remove all variables. 


```r
ls()            # print the variables in the global environment
rm("x")         # remove the variable named x from the global environment
rm(list = ls()) # clear out the global environment
```

<div class="info">
<p>In the upper right corner of the Environment tab, change <strong><code>List</code></strong> to <strong><code>Grid</code></strong>. Now you can see the type, length, and size of your variables, and reorder the list by any of these attributes.</p>
</div>

### Whitespace

When you see `>` at the beginning of a line, that means R is waiting for you to start a new command.  However, if you see a `+` instead of `>` at the start of the line, that means R is waiting for you to finish a command you started on a previous line.  If you want to cancel whatever command you started, just press the Esc key in the console window and you'll get back to the `>` command prompt.


```r
# R waits until next line for evaluation
(3 + 2) *
     5
```

```
## [1] 25
```

It is often useful to break up long functions onto several lines.


```r
cat("3, 6, 9, the goose drank wine",
    "The monkey chewed tobacco on the streetcar line",
    "The line broke, the monkey got choked",
    "And they all went to heaven in a little rowboat",
    sep = "  \n")
```

```
## 3, 6, 9, the goose drank wine  
## The monkey chewed tobacco on the streetcar line  
## The line broke, the monkey got choked  
## And they all went to heaven in a little rowboat
```


### Function syntax {#function_syx}

A lot of what you do in R involves calling a <a class='glossary' target='_blank' title='A named section of code that can be reused.' href='https://psyteachr.github.io/glossary/f#function'>function</a> and storing the results. A function is a named section of code that can be reused. 

For example, `sd` is a function that returns the standard deviation of the <a class='glossary' target='_blank' title='A type of data structure that is basically a list of things like T/F values, numbers, or strings.' href='https://psyteachr.github.io/glossary/v#vector'>vector</a> of numbers that you provide as the input <a class='glossary' target='_blank' title='A variable that provides input to a function.' href='https://psyteachr.github.io/glossary/a#argument'>argument</a>. Functions are set up like this: 

`function_name(argument1, argument2 = "value")`. 

The arguments in parentheses can be named (like, `argument1 = 10`) or you can skip the names if you put them in the exact same order that they're defined in the function. You can check this by typing `?sd` (or whatever function name you're looking up) into the console and the Help pane will show you the default order under **Usage**. You can also skip arguments that have a default value specified.

Most functions return a value, but may also produce side effects like printing to the console.

To illustrate, the function `rnorm()` generates random numbers from the standard normal distribution.  The help page for `rnorm()` (accessed by typing `?rnorm` in the console) shows that it has the syntax 

`rnorm(n, mean = 0, sd = 1)`

where `n` is the number of randomly generated numbers you want, `mean` is the mean of the distribution, and `sd` is the standard deviation. The default mean is 0, and the default standard deviation is 1. There is no default for `n`, which means you'll get an error if you don't specify it:


```r
rnorm()
```

```
## Error in rnorm(): argument "n" is missing, with no default
```

If you want 10 random numbers from a distribution with mean of 0 and standard deviation, you can just use the defaults.


```r
rnorm(10)
```

```
##  [1] -1.78388290 -1.16692994 -0.58356951 -1.15549405 -1.98853097
##  [6]  0.35926622 -1.98264401  1.29309642  0.65504768 -0.08689169
```

If you want 10 numbers from a distribution with a mean of 100:


```r
rnorm(10, 100)
```

```
##  [1]  98.10059  99.57959  98.13696 100.65395  99.25197  99.19705 100.15611
##  [8]  99.04759  99.77266 100.45402
```

This would be an equivalent but less efficient way of calling the function:


```r
rnorm(n = 10, mean = 100)
```

```
##  [1]  99.36981 101.85932  98.10672 100.91911 102.67713 100.77014 102.05360
##  [8] 101.78143  97.85600  99.59732
```

We don't need to name the arguments because R will recognize that we intended to fill in the first and second arguments by their position in the function call. However, if we want to change the default for an argument coming later in the list, then we need to name it. For instance, if we wanted to keep the default `mean = 0` but change the standard deviation to 100 we would do it this way:


```r
rnorm(10, sd = 100)
```

```
##  [1] -119.20782   63.03238 -157.94187 -104.83739   42.34801   55.55016
##  [7]   14.97177   37.19145   34.37412   66.92535
```

Some functions give a list of options after an argument; this means the default value is the first option. The usage entry for the `power.t.test()` function looks like this:


```r
power.t.test(n = NULL, delta = NULL, sd = 1, sig.level = 0.05,
             power = NULL,
             type = c("two.sample", "one.sample", "paired"),
             alternative = c("two.sided", "one.sided"),
             strict = FALSE, tol = .Machine$double.eps^0.25)
```

<div class="try">
* What is the default value for `sd`? <select class='solveme' data-answer='["1"]'> <option></option> <option>NULL</option> <option>1</option> <option>0.05</option> <option>two.sample</option></select>
* What is the default value for `type`? <select class='solveme' data-answer='["two.sample"]'> <option></option> <option>NULL</option> <option>two.sample</option> <option>one.sample</option> <option>paired</option></select>
* Which is equivalent to `power.t.test(100, 0.5)`? <select class='solveme' data-answer='["power.t.test(delta = 0.5, n = 100)"]'> <option></option> <option>power.t.test(100, 0.5, sig.level = 1, sd = 0.05)</option> <option>power.t.test()</option> <option>power.t.test(n = 100)</option> <option>power.t.test(delta = 0.5, n = 100)</option></select>
</div>

### Getting help {#help}

Start up help in a browser using the function `help.start()`.

If a function is in base R or a loaded package, you can use the `help("function_name")` function or the `?function_name` shortcut to access the help file. If the package isn't loaded, specify the package name as the second argument to the help function.


```r
# these methods are all equivalent ways of getting help
help("rnorm")
?rnorm
help("rnorm", package="stats") 
```

When the package isn't loaded or you aren't sure what package the function is in, use the shortcut `??function_name`.

<div class="try">
* What is the first argument to the `mean` function? <select class='solveme' data-answer='["x"]'> <option></option> <option>trim</option> <option>na.rm</option> <option>mean</option> <option>x</option></select>
* What package is `read_excel` in? <select class='solveme' data-answer='["readxl"]'> <option></option> <option>readr</option> <option>readxl</option> <option>base</option> <option>stats</option></select>
</div>

## Add-on packages {#install-package}

One of the great things about R is that it is **user extensible**: anyone can create a new add-on software package that extends its functionality. There are currently thousands of add-on packages that R users have created to solve many different kinds of problems, or just simply to have fun. There are packages for data visualisation, machine learning, neuroimaging, eyetracking, web scraping, and playing games such as Sudoku.

Add-on packages are not distributed with base R, but have to be downloaded and installed from an archive, in the same way that you would, for instance, download and install a fitness app on your smartphone.

The main repository where packages reside is called CRAN, the Comprehensive R Archive Network. A package has to pass strict tests devised by the R core team to be allowed to be part of the CRAN archive. You can install from the CRAN archive through R using the `install.packages()` function.

There is an important distinction between **installing** a package and **loading** a package.

### Installing a package 

This is done using `install.packages()`. This is like installing an app on your smartphone: you only have to do it once and the app will remain installed until you remove it.For instance, if you want to use PokemonGo on your phone you install it once from the App Store or Play Store, and you don't have to re-install it each time you want to use it. Once you launch the app, it will run in the background until you close it or restart your phone. Likewise, when you install a package, the package will be available (but not *loaded*) every time you open up R.

<div class="warning">
<p>You may only be able to permanently install packages if you are using R on your own system; you may not be able to do this on public workstations because you will lack the appropriate privileges.</p>
</div>

Install the `fortunes` package on your system:


```r
install.packages("fortunes")
```

If you don't get an error message, the installation was successful. 

### Loading a package

This is done using `library(packagename)`. This is like **launching** an app on your phone: the functionality is only there where the app is launched and remains there until you close the app or restart. Likewise, when you run `library(packagename)` within a session, the functionality of the package referred to by `packagename` will be made available for your R session. The next time you start R, you will need to run the `library()` function again if you want to access its functionality.

You can load the functions in `fortune` for your current R session as follows:


```r
library(fortunes)
```

Once you have typed this, you can run the function `fortune()`, which spouts random wisdom from one of the R help lists:


```r
fortune()
```

```
## 
## I'm always thrilled when people discover what lexical scoping really means.
##    -- Robert Gentleman
##       Statistical Computing 2003, Reisensburg (June 2003)
```

Note that we will use the convention `package::function()` to indicate in which add-on package a function resides. For instance, if you see `readr::read_csv()`, that refers to the function `read_csv()` in the `readr` add-on package.

### Install from GitHub

Many R packages are not yet on CRAN because they are still in development. Increasingly, datasets and code for papers are available as packages you can download from github. You'll need to install the devtools package to be able to install packages from github. 


```r
install.packages("devtools")
devtools::install_github("adam-gruer/goodshirt")
```


```r
library(goodshirt)
# quotes from The Good Place
chidi()
eleanor()
```

```
## 
##  I missed my mom's back surgery because I had already promised my landlord's nephew that I would help him figure out his new phone. 
## 
##  ~ Chidi
##  Why don't I ever listen to people when they talk about themselves? No, it's annoying, and I'm right not to. 
## 
##  ~ Eleanor
```


## Organising a project {#projects}

Projects in RStudio are a way to group all of the files you need for one project. Most projects include scripts, data files, and output files like the PDF version of the script or images.

<div class="try">
<p>Make a new directory where you will keep all of your materials for this class. If you’re using a lab computer, make sure you make this directory in your network drive so you can access it from other computers.</p>
<p>Choose <strong><code>New Project...</code></strong> under the <strong><code>File</code></strong> menu to create a new project called <code>01-intro</code> in this directory.</p>
</div>

### Structure {#structure}

Here is what an R script looks like. Don't worry about the details for now.


```r
# load add-on packages
library(tidyverse)

# set variables ----
n <- 100

# simulate data ----
data <- data.frame(
  id = 1:n,
  dv = c(rnorm(n/2, 0), rnorm(n/2, 1)),
  condition = rep(c("A", "B"), each = n/2)
)

# plot data ----
ggplot(data, aes(condition, dv)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width = 0.25, 
               aes(fill = condition),
               show.legend = FALSE)

# save plot ----
ggsave("sim_data.png", width = 8, height = 6)
```

It's best if you follow the following structure when developing your own scripts: 

* load in any add-on packages you need to use
* define any custom functions
* load or simulate the data you will be working with
* work with the data
* save anything you need to save

Often when you are working on a script, you will realize that you need to load another add-on package. Don't bury the call to `library(package_I_need)` way down in the script. Put it in the top, so the user has an overview of what packages are needed.

You can add comments to an R script by with the hash symbol (`#`). The R interpreter will ignore characters from the hash to the end of the line.


```r
## comments: any text from '#' on is ignored until end of line
22 / 7  # approximation to pi
```

```
## [1] 3.142857
```

### Reproducible reports with R Markdown {#rmarkdown}

We will make reproducible reports following the principles of [literate programming](https://en.wikipedia.org/wiki/Literate_programming). The basic idea is to have the text of the report together in a single document along with the code needed to perform all analyses and generate the tables. The report is then "compiled" from the original format into some other, more portable format, such as HTML or PDF. This is different from traditional cutting and pasting approaches where, for instance, you create a graph in Microsoft Excel or a statistics program like SPSS and then paste it into Microsoft Word.

We will use [R Markdown](http://rmarkdown.rstudio.com/lesson-1.html) to create reproducible reports, which enables mixing of text and code. A reproducible script will contain sections of code in code blocks. A code block starts and ends with backtick symbols in a row, with some infomation about the code between curly brackets, such as `{r chunk-name, echo=FALSE}` (this runs the code, but does not show the text of the code block in the compiled document). The text outside of code blocks is written in <a class='glossary' target='_blank' title='A way to specify formatting, such as headers, paragraphs, lists, bolding, and links.' href='https://psyteachr.github.io/glossary/m#markdown'>markdown</a>, which is a way to specify formatting, such as headers, paragraphs, lists, bolding, and links.

<div class="figure" style="text-align: center">
<img src="images/01/reproducibleScript.png" alt="A reproducible script." width="100%" />
<p class="caption">(\#fig:img-reproducibleScript)A reproducible script.</p>
</div>

If you open up a new RMarkdown file from a template, you will see an example document with several code blocks in it. To create an HTML or PDF report from an R Markdown (Rmd) document, you compile it.  Compiling a document is called <a class='glossary' target='_blank' title='NA' href='https://psyteachr.github.io/glossary/k#knitting'>knit</a> in RStudio. There is a button that looks like a ball of yarn with needles through it that you click on to compile your file into a report. 

<div class="try">
<p>Create a new R Markdown file from the <strong><code>File &gt; New File &gt; R Markdown...</code></strong> menu. Change the title and author, then click the knit button to create an html file.</p>
</div>


### Working Directory

Where should I put all my files? When developing an analysis, you usually want to have all of your scripts and data files in one subtree of your computer's directory structure. Usually there is a single **working directory** where your data and scripts are stored.

Your script should only reference files in three locations, using the appropriate format.

| Where                    | Example |
|--------------------------|---------|
| on the web               | "https://psyteachr.github.io/msc-data-skills/data/disgust_scores.csv" |
| in the working directory | "disgust_scores.csv"  |
| in a subdirectory        | "data/disgust_scores.csv" |

<div class="warning">
<p>Never set or change your working directory in a script.</p>
</div>

If you are working with an R Markdown file, it will automatically use the same directory the .Rmd file is in as the working directory. 

If you are working with R scripts, store your main script file in the top-level directory and manually set your working directory to that location. You will have to reset the working directory each time you open RStudio, unless you create a <a class='glossary' target='_blank' title='A way to organise related files in RStudio' href='https://psyteachr.github.io/glossary/p#project'>project</a> and access the script from the project. 

For instance, if on a Windows machine your data and scripts are in the directory `C:\Carla's_files\thesis2\my_thesis\new_analysis`, you will set your working directory in one of two ways: (1) by going to the `Session` pull down menu in RStudio and choosing `Set Working Directory`, or (2) by typing `setwd("C:\Carla's_files\thesis2\my_thesis\new_analysis")` in the console window.

<div class="danger">
<p>It’s tempting to make your life simple by putting the <code>setwd()</code> command in your script. Don’t do this! Others will not have the same directory tree as you (and when your laptop dies and you get a new one, neither will you).</p>
<p>When manually setting the working directory, always do so by using the <strong><code>Session &gt; Set Working Directory</code></strong> pull-down option or by typing <code>setwd()</code> in the console.</p>
</div>

If your script needs a file in a subdirectory of `new_analysis`, say, `data/questionnaire.csv`, load it in using a <a class='glossary' target='_blank' title='The location of a file in relation to the working directory.' href='https://psyteachr.github.io/glossary/r#relative-path'>relative path</a>:


```r
dat <- read_csv("data/questionnaire.csv")  # right way
```

Do not load it in using an absolute path:


```r
dat <- read_csv("C:/Carla's_files/thesis22/my_thesis/new_analysis/data/questionnaire.csv")   # wrong
```

<div class="info">
<p>Also note the convention of using forward slashes, unlike the Windows-specific convention of using backward slashes. This is to make references to files platform independent.</p>
</div>


## Exercises

Download the first set of [exercises](exercises/01_intro_stub.Rmd) and put it in the project directory you created earlier for today's exercises. See the [answers](exercises/01_intro_answers.Rmd) only after you've attempted all the questions.
