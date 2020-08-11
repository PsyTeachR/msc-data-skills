# book-specific code to include on every page

embed_youtube <- function(url, width = 560, height = 315, border = 0) {
  sprintf("<iframe width=\"%s\" height=\"%s\" src=\"https://www.youtube.com/embed/%s\" frameborder=\"%s\" allowfullscreen></iframe>",
          width, height, url, border)
}
