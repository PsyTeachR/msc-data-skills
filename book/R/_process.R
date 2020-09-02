# change wd if needed
in_proj_dir <- grep("msc-data-skills$", getwd())
if (length(in_proj_dir) == 1) setwd("book")
in_book_dir <- grep("book$", getwd())
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


# render a chapter or the whole book
browseURL(bookdown::preview_chapter("09-glm.Rmd"))
browseURL(bookdown::preview_chapter("02-data.Rmd"))
bookdown::render_book("index.Rmd")

# copies dir
file.copy(
  from = "../docs",
  to = "../inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)

unlink("inst/book/.nojekyll")
