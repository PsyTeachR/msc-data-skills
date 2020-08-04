#' Open the Data Skills book
#'
#' @return NULL
#' @export
#'
book <- function() {
  file <- system.file("book", "index.html", package = "dataskills")
  utils::browseURL(file, browser = )
}