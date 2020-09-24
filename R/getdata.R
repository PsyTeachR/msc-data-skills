#' Create data directory
#' 
#' Save the data files used in this class to a directory
#'
#' @param dir The name of the directory to save the data in (default "data")
#'
#' @return A list of the paths of the new data files
#' @export
#' 
getdata <- function(dir = "data") {
  if (!dir.exists(dir)) {
    dir.create(dir)
    message("New directory created")
  }
  
  from_dir <- system.file("book/data", package = "dataskills")
  files <- list.files(from_dir, full.names = TRUE)
  
  zips <- grep("zip$", files)
  from <- setdiff(files, files[zips])
  
  x <- lapply(from, file.copy, to = dir)
  
  message("Data saved into ", dir)
  list.files(dir, full.names = TRUE)
}

