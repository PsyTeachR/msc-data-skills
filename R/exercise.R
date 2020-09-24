#' Get an exercise
#'
#' @param chapter The chapter that the exercise is for
#' @param filename What filename you want to save (defaults to the name of the chapter)
#' @param answers Whether or not you want the answers
#'
#' @return Saves a file to the working directory (or path from filename)
#' @export
#'
exercise <- function(chapter, filename = NULL, answers = FALSE) {
  tag <- c("intro", "data", "ggplot", "tidyr", "dplyr", "joins", "func", "sim", "glm")
  fname <- sprintf("book/exercises/%02d_%s_%s.Rmd",
                      chapter, tag[chapter],
                      ifelse(answers, "answers", "exercise"))
  f <- system.file(fname, package = "dataskills")
  
  if (f == "") stop("Exercise ", chapter, " doesn't exist")
  
  if (is.null(filename)) {
    filename <- gsub("^book/exercises/", "", fname)
  }
  
  file.copy(f, filename)
  utils::browseURL(filename)
}