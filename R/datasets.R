
# country_codes ----
#' Country Codes
#'
#' Multiple country, subregion, and region codes for 249 countries.
#'
#' From https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes
#'
#' @format A data frame with 249 rows and 11 variables:
#' \describe{
#'    \item{name}{Full country name}
#'    \item{alpha-2}{2-character country code}
#'    \item{alpha-3}{3-character country code}
#'    \item{country-code}{3-digit country code}
#'    \item{iso_3166-2}{ISO code}
#'    \item{region}{World region}
#'    \item{sub-region}{Sub-region}
#'    \item{intermediate-region}{Intermediate region}
#'    \item{region-code}{World region code}
#'    \item{sub-region-code}{Sub-region code}
#'    \item{intermediate-region-code}{Intermediate region code}
#' }
#' @source \url{https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv}
"country_codes"


# disgust ----
#' Three Domain Disgust Questionnaire (items)
#'
#' A dataset containing responses to the 21 items in the Three Domain Disgust Questionnaire (Tybur et al.)
#'
#' @format A data frame with 20000 rows and 24 variables:
#' \describe{
#'    \item{id}{Each questionnaire completion's unique ID}
#'    \item{user_id}{Each participant's unique ID}
#'    \item{date}{Date of completion (YYY-mm-dd)}
#'    \item{moral1}{Shoplifting a candy bar from a convenience store}
#'    \item{moral2}{Stealing from a neighbor}
#'    \item{moral3}{A student cheating to get good grades}
#'    \item{moral4}{Deceiving a friend}
#'    \item{moral5}{Forging someone's signature on a legal document}
#'    \item{moral6}{Cutting to the front of a line to purchase the last few tickets to a show}
#'    \item{moral7}{Intentionally lying during a business transaction}
#'    \item{sexual1}{Hearing two strangers having sex}
#'    \item{sexual2}{Performing oral sex}
#'    \item{sexual3}{Watching a pornographic video}
#'    \item{sexual4}{Finding out that someone you don't like has sexual fantasies about you}
#'    \item{sexual5}{Bringing someone you just met back to your room to have sex}
#'    \item{sexual6}{A stranger of the opposite sex intentionally rubbing your thigh in an elevator}
#'    \item{sexual7}{Having anal sex with someone of the opposite sex}
#'    \item{pathogen1}{Stepping on dog poop}
#'    \item{pathogen2}{Sitting next to someone who has red sores on their arm}
#'    \item{pathogen3}{Shaking hands with a stranger who has sweaty palms}
#'    \item{pathogen4}{Seeing some mold on old leftovers in your refrigerator}
#'    \item{pathogen5}{Standing close to a person who has body odor}
#'    \item{pathogen6}{Seeing a cockroach run across the floor}
#'    \item{pathogen7}{Accidentally touching a person's bloody cut}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/disgust.csv}
"disgust"


# disgust_cors ----
#' Three Domain Disgust Questionnaire (correlations)
#'
#' Correlations among questions on the Three Domain Disgust Questionnaire (Tybur et al.)
#'
#' @format A data frame with 441 rows and 3 variables:
#' \describe{
#'    \item{V1}{The first correalted item}
#'    \item{V2}{The second correlated item}
#'    \item{r}{The Pearson's correlation between the first and second item}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/disgust_cors.csv}
"disgust_cors"


# disgust_scores ----
#' Three Domain Disgust Questionnaire (scores)
#'
#' A dataset containing subscale scores for to the Three Domain Disgust Questionnaire (Tybur et al.)
#'
#' @format A data frame with 20000 rows and 6 variables:
#' \describe{
#'    \item{id}{Each questionnaire completion's unique ID}
#'    \item{user_id}{Each participant's unique ID}
#'    \item{date}{Date of completion (YYY-mm-dd)}
#'    \item{moral}{The mean value for the 7 moral items}
#'    \item{pathogen}{The mean value for the 7 sexual items}
#'    \item{pathogen}{The mean value for the 7 pathogen items}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/disgust_scores.csv}
"disgust_scores"


# EMBU_mother ----
#' Parental Attachment (Mothers)
#'
#' Items starting with r, p and e are for the rejection (r), overprotection (p), and emotional warmth (e) subscales.
#'
#' Arrindell et al. (1999). The development of a short form of the EMBU: Its appraisal with students in Greece, Guatemala, Hungary and Italy. Personality and Individual Differences, 27, 613-628.
#'
#' @format A data frame with 142 rows and 24 variables:
#' \describe{
#'    \item{id}{A unique ID for each questionnaire completion}
#'    \item{r1}{It happened that my mother was sour or angry with me without letting me know the cause}
#'    \item{e1}{My mother praised me}
#'    \item{p1}{It happened that I wished my mother would worry less about what I was doing}
#'    \item{r2}{It happened that my mother gave me more corporal punishment than I deserved}
#'    \item{p2}{When I came home, I then had to account for what I had been doing, to my mother}
#'    \item{e2}{I think that my mother tried to make my adolescence stimulating, interesting and instructive (for instance by giving me good books, arranging for me to go on camps, taking me to clubs)}
#'    \item{r3}{My mother criticized me and told me how lazy and useless I was in front of others}
#'    \item{p3}{It happened that my mother forbade me to do things other children were allowed to do because she was afraid that something might happen to me}
#'    \item{no_subscale}{My mother tried to spur me to become the best}
#'    \item{p4}{My mother would look sad or in some other way show that I had behaved badly so that I got real feelings of guilt}
#'    \item{p5}{I think that my mother's anxiety that something might happen to me was exaggerated}
#'    \item{e3}{If things went badly for me, I then felt that my mother tried to comfort and encourage me}
#'    \item{r4}{I was treated as the ‘black sheep' or ‘scapegoat' of the family}
#'    \item{e4}{My mother showed with words and gestures that he liked me}
#'    \item{r5}{I felt that my mother liked my brother(s) and/or sister(s) more than she liked me}
#'    \item{r6}{My mother treated me in such a way that I felt ashamed}
#'    \item{p6}{I was allowed to go where I liked without my mother caring too much}
#'    \item{p7}{I felt that my mother interfered with everything I did}
#'    \item{e5}{I felt that warmth and tenderness existed between me and my mother}
#'    \item{p8}{My mother put decisive limits for what I was and was not allowed to do, to which she then adhered rigorously}
#'    \item{r7}{My mother would punish me hard, even for triffles (small offenses)}
#'    \item{p9}{My mother wanted to decide how I should be dressed or how I should look}
#'    \item{e6}{I felt that my mother was proud when I succeeded in something I had undertaken}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/EMBU_mother.csv}
"EMBU_mother"


# eq_data ----
#' Empathizing Quotient
#'
#' Reverse coded (Q#R) questions coded and strongly disagree = 2, slightly disagree = 1, else = 0. The other questions are coded as strongly agree = 2, slightly agree = 1, else = 0.
#'
#' Wakabayashi, A., Baron-Cohen, S., Wheelwright, S., Goldenfeld, N., Delaney, J., Fine, D., Smith, R., & Weil, L. (2006). Development of short forms of the Empathy Quotient (EQ-Short) and the Systemizing Quotient (SQ-Short). Personality and Individual Differences, 41(5), 929–940. https://doi.org/10.1016/j.paid.2006.03.017
#'
#' @format A data frame with 7689 rows and 28 variables:
#' \describe{
#'    \item{user_id}{Each participant's unique ID}
#'    \item{sex}{The participant's sex}
#'    \item{age}{The participant's age in years}
#'    \item{id}{Each questionnaire completion's unique ID}
#'    \item{starttime}{The time the questionnaire was started (yyyy-MM-dd HH:mm:ss)}
#'    \item{endtime}{The time the questionnaire was completed (yyyy-MM-dd HH:mm:ss)}
#'    \item{Q01}{I can easily tell if someone else wants to enter a conversation.}
#'    \item{Q02}{I really enjoy caring for other people.}
#'    \item{Q03R}{I find it hard to know what to do in a social situation.}
#'    \item{Q04R}{I often find it difficult to judge if something is rude or polite.}
#'    \item{Q05R}{In a conversation, I tend to focus on my own thoughts rather than on what my listener might be thinking.}
#'    \item{Q06}{I can pick up quickly if someone says one thing but means another.}
#'    \item{Q07R}{It is hard for me to see why some things upset people so much.}
#'    \item{Q08}{I find it easy to put myself in somebody else's shoes.}
#'    \item{Q09}{I am good at predicting how someone will feel.}
#'    \item{Q10}{I am quick to spot when someone in a group is feeling awkward or uncomfortable.}
#'    \item{Q11R}{I can't always see why someone should have felt offended by a remark.}
#'    \item{Q12}{I don't tend to find social situations confusing.}
#'    \item{Q13}{Other people tell me I am good at understanding how they are feeling and what they are thinking.}
#'    \item{Q14}{I can easily tell if someone else is interested or bored with what I am saying.}
#'    \item{Q15}{Friends usually talk to me about their problems as they say that I am very understanding.}
#'    \item{Q16}{I can sense if I am intruding, even if the other person doesn't tell me.}
#'    \item{Q17R}{Other people often say that I am insensitive, though I don't always see why.}
#'    \item{Q18}{I can tune into how someone else feels rapidly and intuitively.}
#'    \item{Q19}{I can easily work out what another person might want to talk about.}
#'    \item{Q20}{I can tell if someone is masking their true emotion.}
#'    \item{Q21}{I am good at predicting what someone will do.}
#'    \item{Q22}{I tend to get emotionally involved with a friend's problems.}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/eq_data.csv}
"eq_data"


# eye_descriptions ----
#' Descriptions of Eyes
#'
#' Participant's written descriptions of the eyes of 47 people
#'
#' @format A data frame with 220 rows and 53 variables:
#' \describe{
#'    \item{user_id}{Each participant's unique ID}
#'    \item{sex}{The participant's sex}
#'    \item{age}{The participant's age in years}
#'    \item{t1}{The description for face 1}
#'    \item{t2}{The description for face 2}
#'    \item{t3}{The description for face 3}
#'    \item{t4}{The description for face 4}
#'    \item{t5}{The description for face 5}
#'    \item{t6}{The description for face 6}
#'    \item{t7}{The description for face 7}
#'    \item{t8}{The description for face 8}
#'    \item{t9}{The description for face 9}
#'    \item{t10}{The description for face 10}
#'    \item{t11}{The description for face 11}
#'    \item{t12}{The description for face 12}
#'    \item{t13}{The description for face 13}
#'    \item{t14}{The description for face 14}
#'    \item{t15}{The description for face 15}
#'    \item{t16}{The description for face 16}
#'    \item{t17}{The description for face 17}
#'    \item{t18}{The description for face 18}
#'    \item{t19}{The description for face 19}
#'    \item{t20}{The description for face 20}
#'    \item{t21}{The description for face 21}
#'    \item{t22}{The description for face 22}
#'    \item{t23}{The description for face 23}
#'    \item{t24}{The description for face 24}
#'    \item{t25}{The description for face 25}
#'    \item{t26}{The description for face 26}
#'    \item{t27}{The description for face 27}
#'    \item{t28}{The description for face 28}
#'    \item{t29}{The description for face 29}
#'    \item{t30}{The description for face 30}
#'    \item{t31}{The description for face 31}
#'    \item{t32}{The description for face 32}
#'    \item{t33}{The description for face 33}
#'    \item{t34}{The description for face 34}
#'    \item{t35}{The description for face 35}
#'    \item{t36}{The description for face 36}
#'    \item{t37}{The description for face 37}
#'    \item{t38}{The description for face 38}
#'    \item{t39}{The description for face 39}
#'    \item{t40}{The description for face 40}
#'    \item{t41}{The description for face 41}
#'    \item{t42}{The description for face 42}
#'    \item{t43}{The description for face 43}
#'    \item{t44}{The description for face 44}
#'    \item{t45}{The description for face 45}
#'    \item{t46}{The description for face 46}
#'    \item{t47}{The description for face 47}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/eye_descriptions.csv}
"eye_descriptions"


# infmort ----
#' Infant Mortality
#'
#' Infant mortality by country and year from the World Health Organisation.
#'
#' @format A data frame with 5044 rows and 3 variables:
#' \describe{
#'    \item{Country}{The full country name}
#'    \item{Year}{The year the statistic was calculated for (yyyy)}
#'    \item{Infant mortality rate (probability of dying between birth and age 1 per 1000 live births)}{Infant mortality rate (the probability of dying between birth and age 1 per 1000 live births) and confidence interval in the format rate [lowCI-highCI]}
#' }
#' @source \url{https://apps.who.int/gho/data/view.main.182?lang=en}
"infmort"


# matmort ----
#' Maternal Mortality
#'
#' Maternal mortality by country and year from the World Health Organisation.
#'
#' @format A data frame with 181 rows and 4 variables:
#' \describe{
#'    \item{Country}{The full country name}
#'    \item{1990}{Maternal mortality for 1990 (rate [lowCI-highCI])}
#'    \item{2000}{Maternal mortality for 2000 (rate [lowCI-highCI])}
#'    \item{2015}{Maternal mortality for 2015 (rate [lowCI-highCI])}
#' }
#' @source \url{https://apps.who.int/gho/data/node.main.15?lang=en}
"matmort"


# sq_data ----
#' Systemizing Quotient
#'
#' Reverse coded (Q#R) questions coded and strongly disagree = 2, slightly disagree = 1, else = 0. The other questions are coded as strongly agree = 2, slightly agree = 1, else = 0.
#'
#' Wakabayashi, A., Baron-Cohen, S., Wheelwright, S., Goldenfeld, N., Delaney, J., Fine, D., Smith, R., & Weil, L. (2006). Development of short forms of the Empathy Quotient (EQ-Short) and the Systemizing Quotient (SQ-Short). Personality and Individual Differences, 41(5), 929–940. https://doi.org/10.1016/j.paid.2006.03.017
#'
#' @format A data frame with 4745 rows and 31 variables:
#' \describe{
#'    \item{user_id}{Each participant's unique ID}
#'    \item{sex}{The participant's sex}
#'    \item{age}{The participant's age in years}
#'    \item{id}{Each questionnaire completion's unique ID}
#'    \item{starttime}{The time the questionnaire was started (yyyy-MM-dd HH:mm:ss)}
#'    \item{endtime}{The time the questionnaire was completed (yyyy-MM-dd HH:mm:ss)}
#' }
#' @source \url{https://psyteachr.github.io/msc-data-skills/data/sq_data.csv}
"sq_data"


