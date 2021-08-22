browseURL(
  xfun::in_dir("book", bookdown::render_book())
)

# copies dir
R.utils::copyDirectory(
  from = "docs",
  to = "inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)

unlink("inst/book/docs/.nojekyll")
