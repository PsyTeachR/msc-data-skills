# change wd if needed
in_proj_dir <- grep("msc-data-skills$", getwd())
if (length(in_proj_dir) == 1) setwd("inst/book")
in_book_dir <- grep("inst/book$", getwd())
if (length(in_book_dir) == 0) stop("fix working directory")

# knit all exercise and answer Rmd files
input <- list.files("exercises", "*.Rmd", full.names = TRUE)
purrr::map(input, rmarkdown::render)

# zip files
f.zip <- list.files("exercises", "*_exercise.Rmd", full.names = TRUE)
d.zip <- list.files("exercises/data", full.names = TRUE)
zipfile <- "exercises/msc-data-skills-exercises.zip"
if (file.exists(zipfile)) file.remove(zipfile)
zip(zipfile, c(f.zip, d.zip))

bookdown::render_book("index.Rmd")