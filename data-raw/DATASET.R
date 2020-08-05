## code to prepare `DATASET` dataset goes here

library(tidyverse)
library(faux)
faux::faux_options(verbose = FALSE)

# function for creating dataset descriptions in Roxygen
make_dataset <- function(dataname, title, desc, vardesc = list(), filetype = "csv", source = NULL, write = TRUE) {
  
  # read data and save to data directory
  datafile <- paste0("data-raw/", dataname, ".", filetype)
  if (filetype == "csv") {
    data <- readr::read_csv(datafile, col_types = readr::cols())
  } else if (filetype == "xls") {
    data <- readxl::read_xls(datafile)
  }
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
                       name = title, description = gsub("\n", " ", desc), 
                       license = "CC-BY 4.0")
  readr::write_file(cb, paste0("data-raw/", dataname, ".json"))

  # create Roxygen description
  itemdesc <- vardesc$description
  items <- paste0("#'    \\item{", names(itemdesc), "}{", itemdesc, "}")
  
  if (is.null(source)) source <- sprintf("https://psyteachr.github.io/msc-data-skills/data/%s.%s", dataname, filetype)
  
  s <- sprintf("# %s ----\n#' %s\n#'\n#' %s\n#'\n#' @format A data frame with %d rows and %d variables:\n#' \\describe{\n%s\n#' }\n#' @source \\url{%s}\n\"%s\"\n\n",
               dataname, title, 
               gsub("\n+", "\n#'\n#' ", desc), 
               nrow(data), ncol(data),
               paste(items, collapse = "\n"),
               source, dataname
  )
  if (!isFALSE(write)) write(s, paste0("R/data_", dataname, ".R"))
  invisible(s)
}

# country_codes ----
ccodes <- read_csv("https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")
write_csv(ccodes, "data-raw/country_codes.csv")

vardesc <- list(
  description = list(
    "name" = "Full country name",
    "alpha-2" = "2-character country code",
    "alpha-3" = "3-character country code",
    "country-code" = "3-digit country code",
    "iso_3166-2" = "ISO code",
    "region" = "World region",
    "sub-region" = "Sub-region",
    "intermediate-region" = "Intermediate region",
    "region-code" = "World region code",
    "sub-region-code" = "Sub-region code",
    "intermediate-region-code" = "Intermediate region code"
  )
)

make_dataset("country_codes", 
             "Country Codes", 
             "Multiple country, subregion, and region codes for 249 countries.\nFrom https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes", vardesc, source = "https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv")

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


# EMBU_mother ----
vardesc <- list(
  description = list(
    id = "A unique ID for each questionnaire completion",
    r1 = "It happened that my mother was sour or angry with me without letting me know the cause",
    e1 = "My mother praised me",
    p1 = "It happened that I wished my mother would worry less about what I was doing",
    r2 = "It happened that my mother gave me more corporal punishment than I deserved",
    p2 = "When I came home, I then had to account for what I had been doing, to my mother",
    e2 = "I think that my mother tried to make my adolescence stimulating, interesting and instructive (for instance by giving me good books, arranging for me to go on camps, taking me to clubs)",
    r3 = "My mother criticized me and told me how lazy and useless I was in front of others",
    p3 = "It happened that my mother forbade me to do things other children were allowed to do because she was afraid that something might happen to me",
    no_subscale = "My mother tried to spur me to become the best",
    p4 = "My mother would look sad or in some other way show that I had behaved badly so that I got real feelings of guilt",
    p5 = "I think that my mother's anxiety that something might happen to me was exaggerated",
    e3 = "If things went badly for me, I then felt that my mother tried to comfort and encourage me",
    r4 = "I was treated as the ‘black sheep' or ‘scapegoat' of the family",
    e4 = "My mother showed with words and gestures that he liked me",
    r5 = "I felt that my mother liked my brother(s) and/or sister(s) more than she liked me",
    r6 = "My mother treated me in such a way that I felt ashamed",
    p6 = "I was allowed to go where I liked without my mother caring too much",
    p7 = "I felt that my mother interfered with everything I did",
    e5 = "I felt that warmth and tenderness existed between me and my mother",
    p8 = "My mother put decisive limits for what I was and was not allowed to do, to which she then adhered rigorously",
    r7 = "My mother would punish me hard, even for triffles (small offenses)",
    p9 = "My mother wanted to decide how I should be dressed or how I should look",
    e6 = "I felt that my mother was proud when I succeeded in something I had undertaken"
  )
)
make_dataset("EMBU_mother", "Parental Attachment (Mothers)", 
             "Items starting with r, p and e are for the rejection (r), overprotection (p), and emotional warmth (e) subscales.\nArrindell et al. (1999). The development of a short form of the EMBU: Its appraisal with students in Greece, Guatemala, Hungary and Italy. Personality and Individual Differences, 27, 613-628.", vardesc)

# empathizing ----
vardesc <- list(
  description = list(
    user_id = "Each participant's unique ID",
    sex = "The participant's sex",
    age = "The participant's age in years",
    id = "Each questionnaire completion's unique ID",
    starttime = "The time the questionnaire was started (yyyy-MM-dd HH:mm:ss)",
    endtime = "The time the questionnaire was completed (yyyy-MM-dd HH:mm:ss)",
    Q01 = "I can easily tell if someone else wants to enter a conversation.",
    Q02 = "I really enjoy caring for other people.",
    Q03R = "I find it hard to know what to do in a social situation.",
    Q04R = "I often find it difficult to judge if something is rude or polite.",
    Q05R = "In a conversation, I tend to focus on my own thoughts rather than on what my listener might be thinking.",
    Q06 = "I can pick up quickly if someone says one thing but means another.",
    Q07R = "It is hard for me to see why some things upset people so much.",
    Q08 = "I find it easy to put myself in somebody else's shoes.",
    Q09 = "I am good at predicting how someone will feel.",
    Q10 = "I am quick to spot when someone in a group is feeling awkward or uncomfortable.",
    Q11R = "I can't always see why someone should have felt offended by a remark.",
    Q12 = "I don't tend to find social situations confusing.",
    Q13 = "Other people tell me I am good at understanding how they are feeling and what they are thinking.",
    Q14 = "I can easily tell if someone else is interested or bored with what I am saying.",
    Q15 = "Friends usually talk to me about their problems as they say that I am very understanding.",
    Q16 = "I can sense if I am intruding, even if the other person doesn't tell me.",
    Q17R = "Other people often say that I am insensitive, though I don't always see why.",
    Q18 = "I can tune into how someone else feels rapidly and intuitively.",
    Q19 = "I can easily work out what another person might want to talk about.",
    Q20 = "I can tell if someone is masking their true emotion.",
    Q21 = "I am good at predicting what someone will do.",
    Q22 = "I tend to get emotionally involved with a friend's problems."
  )
)

d <- read_csv("data-raw/empathizing.csv") %>%
  gather(q, score, q2663:q2684) %>%
  mutate(label = recode(score, 
                        "1" = "strongly agree", 
                        "2" = "slightly agree", 
                        "3" = "slightly disagree", 
                        "4" = "strongly disagree"),
         rev = q %in% c("q2665", "q2666", "q2667", "q2669", "q2673", "q2679")
         )

nm <- unique(d$q)
rcode <- faux::make_id(length(nm), "Q")
names(rcode) <- nm
d$qname = recode(d$q, !!!rcode)
d$qname = paste0(d$qname, ifelse(d$rev, "R", ""))
unique(d$qname)

data <- select(d, -q, -score, -rev) %>%
  spread(qname, label)

write_csv(data, "data-raw/eq_data.csv")

make_dataset("eq_data", "Empathizing Quotient", 
             "Reverse coded (Q#R) questions coded and strongly disagree = 2, slightly disagree = 1, else = 0. The other questions are coded as strongly agree = 2, slightly agree = 1, else = 0.\nWakabayashi, A., Baron-Cohen, S., Wheelwright, S., Goldenfeld, N., Delaney, J., Fine, D., Smith, R., & Weil, L. (2006). Development of short forms of the Empathy Quotient (EQ-Short) and the Systemizing Quotient (SQ-Short). Personality and Individual Differences, 41(5), 929–940. https://doi.org/10.1016/j.paid.2006.03.017", vardesc)

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

# infmort ----
vardesc <- list(
  description = list(
    Country = "The full country name",
    Year = "The year the statistic was calculated for (yyyy)",
    "Infant mortality rate (probability of dying between birth and age 1 per 1000 live births)" = "Infant mortality rate (the probability of dying between birth and age 1 per 1000 live births) and confidence interval in the format rate [lowCI-highCI]"
  )
)

make_dataset("infmort", "Infant Mortality", 
             "Infant mortality by country and year from the World Health Organisation.", vardesc, source = "https://apps.who.int/gho/data/view.main.182?lang=en")


# matmort ----
vardesc <- list(
  description = list(
    Country = "The full country name",
    "1990" = "Maternal mortality for 1990 (rate [lowCI-highCI])",
    "2000" = "Maternal mortality for 2000 (rate [lowCI-highCI])",
    "2015" = "Maternal mortality for 2015 (rate [lowCI-highCI])"
  )
)

make_dataset("matmort", "Maternal Mortality", 
             "Maternal mortality by country and year from the World Health Organisation.", vardesc, filetype = "xls", source = "https://apps.who.int/gho/data/node.main.15?lang=en")




# systemising ----
vardesc <- list(
  description = list(
    user_id = "Each participant's unique ID",
    sex = "The participant's sex",
    age = "The participant's age in years",
    id = "Each questionnaire completion's unique ID",
    starttime = "The time the questionnaire was started (yyyy-MM-dd HH:mm:ss)",
    endtime = "The time the questionnaire was completed (yyyy-MM-dd HH:mm:ss)"
  )
)

d <- read_csv("data-raw/systemizing.csv") %>%
  gather(q, score, q2616:q2640) %>%
  mutate(label = recode(score, 
                        "1" = "strongly agree", 
                        "2" = "slightly agree", 
                        "3" = "slightly disagree", 
                        "4" = "strongly disagree"),
         rev = q %in% c("q2618","q2619","q2622","q2624","q2625","q2626","q2627","q2630","q2632","q2634","q2635","q2638","q2640")
  )

nm <- unique(d$q)
rcode <- faux::make_id(length(nm), "Q")
names(rcode) <- nm
d$qname = recode(d$q, !!!rcode)
d$qname = paste0(d$qname, ifelse(d$rev, "R", ""))
unique(d$qname)

data <- select(d, -q, -score, -rev) %>%
  spread(qname, label)

write_csv(data, "data-raw/sq_data.csv")

make_dataset("sq_data", "Systemizing Quotient", 
             "Reverse coded (Q#R) questions coded and strongly disagree = 2, slightly disagree = 1, else = 0. The other questions are coded as strongly agree = 2, slightly agree = 1, else = 0.\nWakabayashi, A., Baron-Cohen, S., Wheelwright, S., Goldenfeld, N., Delaney, J., Fine, D., Smith, R., & Weil, L. (2006). Development of short forms of the Empathy Quotient (EQ-Short) and the Systemizing Quotient (SQ-Short). Personality and Individual Differences, 41(5), 929–940. https://doi.org/10.1016/j.paid.2006.03.017", vardesc)



devtools::document()