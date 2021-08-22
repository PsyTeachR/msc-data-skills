# book-specific code to include on every page

embed_youtube <- function(url, width = 560, height = 315, border = 0) {
  sprintf("<iframe width=\"%s\" height=\"%s\" src=\"https://www.youtube.com/embed/%s\" frameborder=\"%s\" allowfullscreen></iframe>",
          width, height, url, border)
}

showtbl <- function(data, n = 6) {
  nm <- utils::capture.output(match.call()$data)
  if (n < nrow(data)) {
    cp <- sprintf("Rows 1-%s from `%s`", n, nm)
  } else {
    n <- nrow(data)
    cp <- sprintf("All rows from `%s`", nm)
  }
  
  data %>%
    ungroup() %>%
    slice(1:n) %>%
    knitr::kable(caption = cp)
}

cat('<a href="https://psyteachr.github.io/reprores/" style="color: red;">Access the most up-to-date version</a>')
