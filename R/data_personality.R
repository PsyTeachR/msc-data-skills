# personality ----
#' 5-Factor Personality Items
#'
#' Archival data from the Face Research Lab of a 5-factor personality questionnaire. Each question is labelled with the domain (Op = openness, Co = conscientiousness, Ex = extroversion, Ag = agreeableness, and Ne = neuroticism) and the question number. Participants rate each statement on a Likert scale from 0 (Never) to 6 (Always). Questions with REV have already been reverse-coded (0 = Always, 6 = Never). 
#'
#' Instructions: A number of statements which people have used to describe themselves are given below. Read each statement and then click on of the seven options to indicate how frequently this statement applies to you. There are no right or wrong answers. Do not spend too much time on any one statement, but give the answer which seems to describe how you generally feel or behave.
#'
#' @format A data frame with 15000 rows and 43 variables:
#' \describe{
#'    \item{user_id}{Each participant's unique ID}
#'    \item{date}{The date this questionnaire was completed}
#'    \item{Op1}{Tend to vote for conservative political candidates (REV)}
#'    \item{Ne1}{Have frequent mood swings (FWD)}
#'    \item{Ne2}{Am not easily bothered by things (REV)}
#'    \item{Op2}{Believe in the importance of art (FWD)}
#'    \item{Ex1}{Am the life of the party (FWD)}
#'    \item{Ex2}{Am skilled in handling social situations (FWD)}
#'    \item{Co1}{Am always prepared (FWD)}
#'    \item{Co2}{Make plans and stick to them (FWD)}
#'    \item{Ne3}{Dislike myself (FWD)}
#'    \item{Ag1}{Respect others (FWD)}
#'    \item{Ag2}{Insult people (REV)}
#'    \item{Ne4}{Seldom feel blue (REV)}
#'    \item{Ex3}{Don't like to draw attention to myself (REV)}
#'    \item{Co3}{Carry out my plans (FWD)}
#'    \item{Op3}{Am not interested in abstract ideas (REV)}
#'    \item{Ex4}{Make friends easily (FWD)}
#'    \item{Op4}{Tend to vote for liberal political candidates (FWD)}
#'    \item{Ex5}{Know how to captivate people (FWD)}
#'    \item{Ag3}{Believe that others have good intentions (FWD)}
#'    \item{Co4}{Do just enough work to get by (REV)}
#'    \item{Co5}{Find it difficult to get down to work (REV)}
#'    \item{Ne5}{Panic easily (FWD)}
#'    \item{Op5}{Avoid philosophical discussions (REV)}
#'    \item{Ag4}{Accept people as they are (FWD)}
#'    \item{Op6}{Do not enjoy going to art museums (REV)}
#'    \item{Co6}{Pay attention to details (FWD)}
#'    \item{Ex6}{Keep in the background (REV)}
#'    \item{Ne6}{Feel comfortable with myself (REV)}
#'    \item{Co7}{Waste my time (REV)}
#'    \item{Ag5}{Get back at others (REV)}
#'    \item{Co8}{Get chores done right away (FWD)}
#'    \item{Ex7}{Don't talk a lot (REV)}
#'    \item{Ne7}{Am often down in the dumps (FWD)}
#'    \item{Co9}{Shirk my duties (REV)}
#'    \item{Op7}{Do not like art (REV)}
#'    \item{Ne8}{Often feel blue (FWD)}
#'    \item{Ag6}{Cut others to pieces (REV)}
#'    \item{Ag7}{Have a good word for everyone (FWD)}
#'    \item{Co10}{Don't see things through (REV)}
#'    \item{Ex8}{Feel comfortable around people (FWD)}
#'    \item{Ex9}{Have little to say (REV)}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/personality.csv}
"personality"


