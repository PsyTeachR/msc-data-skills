# change wd
setwd(rstudioapi::getActiveProject())
setwd("book")

# render a chapter or the whole book
browseURL(bookdown::preview_chapter("07-func.Rmd"))
bookdown::render_book("index.Rmd")




# knit all exercise and answer Rmd files
input <- list.files("exercises", "*.Rmd", full.names = TRUE)
purrr::map(input, rmarkdown::render)

# zip files
f.zip <- list.files("exercises", "*_exercise.Rmd", full.names = TRUE)
d.zip <- list.files("exercises/data", full.names = TRUE)
zipfile <- "exercises/msc-data-skills-exercises.zip"
if (file.exists(zipfile)) file.remove(zipfile)
zip(zipfile, c(f.zip, d.zip))




# copies dir
R.utils::copyDirectory(
  from = "../docs",
  to = "../inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)

unlink("inst/book/.nojekyll")
unlink("inst/book/docs/.nojekyll")
