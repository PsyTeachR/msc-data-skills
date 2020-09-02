#' Open the Data Skills book
#'
#' @return NULL
#' @export
#' @import tidyverse
#'
book <- function() {
  file <- system.file("book", "index.html", package = "dataskills")
  utils::browseURL(file)
}