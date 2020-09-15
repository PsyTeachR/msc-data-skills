# experimentum_quests ----
#' Experimentum Project Questionnaires
#'
#' Data from a demo questionnaire on Experimentum <https://debruine.github.io/experimentum/>. Subjects are asked questions about dogs to test the different questionnaire response types.
#'
#' Questions 
#'
#' * current: 	Do you own a dog? (yes/no)  
#' * past: Have you ever owned a dog? (yes/no)  
#' * name: What is the best name for a dog? (free short text)  
#' * good: How good are dogs? (1=pretty good:7=very good)  
#' * country: What country do borzois come from?  
#' * good_borzoi: How good are borzois? (0=pretty good:100=very good)  
#' * text: Write some text about dogs. (free long text)  
#' * time: What time is it? (time)
#'
#' @format A data frame with 191 rows and 13 variables:
#' \describe{
#'    \item{session_id}{The unique session ID assigned each time a user starts a project}
#'    \item{project_id}{The unique ID for the project (a collection of questionnaires and/or experiments}
#'    \item{quest_id}{The unique ID for the questionnaire}
#'    \item{user_id}{The unique ID for the user (subject/participant)}
#'    \item{user_sex}{The user's sex/gender (male, female, nonbinary, na)}
#'    \item{user_status}{The user's status (test, guest, registered, student,res, super, admin)}
#'    \item{user_age}{The user's age in years; calculated from birthdate}
#'    \item{q_name}{The name of the question}
#'    \item{q_id}{The unique ID of the question in the questionnaire}
#'    \item{order}{The order the trial was shown in (for experiments with randomised order)}
#'    \item{dv}{The response}
#'    \item{starttime}{The timestamp of the questionnaire start}
#'    \item{endtime}{The timestamp of the questionnaire submission}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/experimentum_quests.csv}
"experimentum_quests"


