## code to prepare `DATASET` dataset goes here

# clear datasets file
write("", "R/datasets.R", append = FALSE)
faux::faux_options(verbose = FALSE)

# function for creating dataset descriptions in Roxygen
make_dataset <- function(dataname, title, desc, vardesc = list(), filetype = "csv", write = "R/datasets.R") {
  
  # read data and save to data directory
  data <- readr::read_csv(paste0("data-raw/", dataname, ".", filetype), col_types = cols())
  # this is awkward, but devtools::document won't work unless the saved data has the name you intend to use for it
  dat <- list()
  dat[[dataname]] <- data
  list2env(dat, envir = environment())
  e <- paste0("usethis::use_data(", dataname, ", overwrite = TRUE)")
  eval(parse(text = e))
  
  # save(data, file = paste0("data/", dataname, ".rda"), 
  #      compress = "bzip2", version = 2)
  
  # make codebook and save
  cb <- faux::codebook(data, vardesc = vardesc, 
                       author = "Lisa DeBruine",
                       name = title, description = desc, 
                       license = "CC-BY 4.0")
  readr::write_file(cb, paste0("data-raw/", dataname, ".json"))

  # create Roxygen description
  itemdesc <- vardesc$description
  items <- paste0("#'    \\item{", names(itemdesc), "}{", itemdesc, "}")
  
  s <- sprintf("#' %s\n#'\n#' %s\n#'\n#' @format A data frame with %d rows and %d variables:\n#' \\describe{\n%s\n#' }\n#' @source \\url{https://psyteachr.github.io/msc-data-skills/data/%s.%s}\n\"%s\"\n\n",
               title, desc, 
               nrow(data), ncol(data),
               paste(items, collapse = "\n"),
               dataname, filetype, dataname
  )
  if (!isFALSE(write)) write(s, write, append = TRUE)
  invisible(s)
}


# disgust ----
vardesc <- list(
  description = list(
    id = "Each questionnaire completion's unique ID",
    user_id = "Each participant's unique ID",
    date = "Date of completion (YYY-mm-dd)",
    moral1 =  "Shoplifting a candy bar from a convenience store",
    moral2 =  "Stealing from a neighbor",
    moral3 =  "A student cheating to get good grades",
    moral4 =  "Deceiving a friend",
    moral5 =  "Forging someone's signature on a legal document",
    moral6 =  "Cutting to the front of a line to purchase the last few tickets to a show",
    moral7 =  "Intentionally lying during a business transaction",
    sexual1 =  "Hearing two strangers having sex",
    sexual2 =  "Performing oral sex",
    sexual3 =  "Watching a pornographic video",
    sexual4 =  "Finding out that someone you don't like has sexual fantasies about you",
    sexual5 =  "Bringing someone you just met back to your room to have sex",
    sexual6 =  "A stranger of the opposite sex intentionally rubbing your thigh in an elevator",
    sexual7 =  "Having anal sex with someone of the opposite sex",
    pathogen1 =  "Stepping on dog poop",
    pathogen2 =  "Sitting next to someone who has red sores on their arm",
    pathogen3 =  "Shaking hands with a stranger who has sweaty palms",
    pathogen4 =  "Seeing some mold on old leftovers in your refrigerator",
    pathogen5 =  "Standing close to a person who has body odor",
    pathogen6 =  "Seeing a cockroach run across the floor",
    pathogen7 =  "Accidentally touching a person's bloody cut"
  )
)

make_dataset("disgust", 
             "Three Domain Disgust Questionnaire (items)", 
             "A dataset containing responses to the 21 items in the Three Domain Disgust Questionnaire (Tybur et al.)", vardesc)


# disgust_cors ----
vardesc <- list(
  description = list(
    V1 = "The first correalted item",
    V2 = "The second correlated item",
    r = "The Pearson's correlation between the first and second item"
  )
)

make_dataset("disgust_cors", 
             "Three Domain Disgust Questionnaire (correlations)", 
             "Correlations among questions on the Three Domain Disgust Questionnaire (Tybur et al.)", vardesc)

# disgust_scores ----
vardesc <- list(
  description = list(
    id = "Each questionnaire completion's unique ID",
    user_id = "Each participant's unique ID",
    date = "Date of completion (YYY-mm-dd)",
    moral = "The mean value for the 7 moral items",
    pathogen = "The mean value for the 7 sexual items",
    pathogen = "The mean value for the 7 pathogen items"
  ),
  minValue = list(moral = 0, pathogen = 0, sexual = 0),
  maxValue = list(moral = 6, pathogen = 6, sexual = 6)
)
make_dataset("disgust_scores", "Three Domain Disgust Questionnaire (scores)", 
             "A dataset containing subscale scores for to the Three Domain Disgust Questionnaire (Tybur et al.)", vardesc)

# eye_descriptions ----
vardesc <- list(
  description = list(
    user_id = "Each participant's unique ID",
    sex = "The participant's sex",
    age = "The participant's age in years"
  )
)
tt <- paste0("The description for face ", 1:47)
names(tt) <- paste0("t", 1:47)
vardesc$description <- c(vardesc$description, tt)

make_dataset("eye_descriptions", "Descriptions of Eyes", 
             "Participant's written descriptions of the eyes of 47 people", vardesc)

