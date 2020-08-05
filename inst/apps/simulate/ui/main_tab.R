# main_tab ----
main_tab <- tabItem(
  tabName = "main_tab",
  p("This app will let you explore a few basic distributions that you can sample in R. Generating random samples is a good way to get better intuitions about what data look like."),
  p("Click on a distribution below or in the sidebar to explore the visualisations"),
  tags$ul(
    tags$li(a("Uniform", href="#shiny-tab-unif_tab", "data-toggle" = "tab")),
    tags$li(a("Binomial", href="#shiny-tab-binom_tab", "data-toggle" = "tab")),
    tags$li(a("Normal", href="#shiny-tab-norm_tab", "data-toggle" = "tab")),
    tags$li(a("Poisson", href="#shiny-tab-pois_tab", "data-toggle" = "tab"))
  )
)

# unif_tab ----
unif_tab <- tabItem(
  tabName = "unif_tab",
  p("The uniform distribution is the simplest distribution. All numbers in the range have an equal probability of being sampled. P-values have a uniform distribution under the null hypothesis (i.e., when there is no effect, all numbers between 0 and 1 are equally probable)."),
  #box(title = "Tasks", width = 12,
  tags$ul(
    tags$li("Set n = 1000, min = 0, and max = 1. Plot data by clicking the 'Sample Again' button. Do this 5 times. How much does the distribution change between samples?"),
    tags$li("Clear the samples and plot 5 sets of data with n = 10. Does the distribution change more or less?"),
    tags$li("Set n = 100 and min = 0. Plot data with max of 1, 10, 100, and 1000"), 
    tags$li("Clear the samples and set n = 1, min = 0, and max = 1. Now each sample adds to the overall distribution. How many times do you need to sample to get a value < 0.05 (i.e., in the first bin)?")
  ),
  #    collapsible = TRUE, collapsed = TRUE),
  div(class="func-spec",
      span("runif(n = "),
      numericInput("unif_n", NULL, 100, 1, 1000, 1),
      span(", min = "),
      numericInput("unif_min", NULL, 0, NA, NA, 1),
      span(", max = "),
      numericInput("unif_max", NULL, 1, NA, NA, 1),
      span(")")
  ),
  actionButton("unif_sample", "Sample Again"),
  actionButton("unif_clear", "Clear Samples"),
  plotOutput("unif_plot", height = "500px")
)

# norm_tab ----
norm_tab <- tabItem(
  tabName = "norm_tab",
  p("The normal distribution is useful for modeling continuous data like accuracy over a large number of trials."),
  #box(title = "Tasks", width = 12,
      tags$ul(
        tags$li("Set n = 1000, mean = 0, and sd = 1. Plot data by clicking the 'Sample Again' button. Do this 5 times. How much does the distribution change between samples?"),
        tags$li("Clear the samples and plot 5 sets of data with n = 10. Does the distribution change more or less?"),
        tags$li("Set n = 100 and sd = 1. Plot data with means of -2, -1, 0, 1 and 2."), 
        tags$li("Set n = 100 and mean = 0. Plot data with SDs of 2, 1.5, 1, 0.8, 0.6, 0.4, and 0.2. What happens to the range of the data as SD gets smaller?"), 
        tags$li("Clear the samples and set n = 1. Now each sample adds to the overall distribution. How many times do you need to sample to get a mean that is close to the mean you set?")
      ),
  #    collapsible = TRUE, collapsed = TRUE),
  div(class="func-spec",
      span("rnorm(n = "),
      numericInput("norm_n", NULL, 100, 1, 1000, 1),
      span(", mean = "),
      numericInput("norm_mu", NULL, 0, NA, NA, 1),
      span(", sd = "),
      numericInput("norm_sd", NULL, 1, 0, NA, 0.5),
      span(")")
  ),
  actionButton("norm_sample", "Sample Again"),
  actionButton("norm_clear", "Clear Samples"),
  plotOutput("norm_plot", height = "500px")
)

# binom_tab ----
binom_tab <- tabItem(
  tabName = "binom_tab",
  p("The binomial distribution is useful for modeling data where each trial can have one of two outcomes, like success/failure, yes/no, or head/tails."),
  #box(title = "Tasks", width = 12,
      tags$ul(
        tags$li("Set n = 100, size = 10, and prob = 0.5. Plot data by clicking the 'Sample Again' button. Do this 5 times. How much does the distribution change between samples?"),
        tags$li("Clear the samples and plot 5 sets of data with n = 10. Does the distribution change more or less?"),
        tags$li("Set n = 1000 and prob = 0.5. Plot data with sizes 1 to 10."),
        tags$li("Set n = 1000 and size = 10. Plot data with prob = 0, 0.25, 0.5, 0.75, and 1.0"),
        tags$li("Set n = 1, size = 1, and prob = 0.5 to simulate single coin flips. Each sample adds 1 observation of 1 fair coin flip."),
        tags$li("Set n = 1, size = 10, and prob = 0.5. How many tries does it take to get a trial with 8 or more successes? Can you get 10?"),
        tags$li("Compare n = 10 and size = 1 to n = 1 and size = 10."),
        tags$li("How would you simulate a data set where each of 40 subjects sees 50 pairs of faces and indicates if they are related? The DV here is the number of correct guesses. Simulate data where people are 70% accurate and compare this to data where people are at chance.")
      ),
  #    collapsible = TRUE, collapsed = TRUE),
  div(class="func-spec",
      span("rbinom(n = "),
      numericInput("binom_n", NULL, 100, 1, 1000, 1),
      span(", size = "),
      numericInput("binom_size", NULL, 10, 1, NA, 1),
      span(", prob = "),
      numericInput("binom_prob", NULL, 0.5, 0, 1, 0.1),
      span(")")
  ),
  actionButton("binom_sample", "Sample Again"),
  actionButton("binom_clear", "Clear Samples"),
  plotOutput("binom_plot", height = "500px")
)

# pois_tab ----
pois_tab <- tabItem(
  tabName = "pois_tab",
  p("The poisson distribution is good for modeling the rate of something, like the number of texts you receive per day. Lambda is the average rate."),
  #box(title = "Tasks", width = 12,
      tags$ul(
        tags$li("Set n = 100 and lambda = 5. Plot data by clicking the 'Sample Again' button. Do this 5 times. How much does the distribution change between samples?"),
        tags$li("Clear the samples and plot 5 sets of data with n = 10. Does the distribution change more or less?"),
        tags$li("Set n = 1000. Plot data with lambda ranging from 1 to 10."),
        tags$li("Set n = 1 and lambda = 1. Now each sample adds to the overall distribution. How many times do you need to sample to get an observation where x >= 4 or x >= 5?"),
        tags$li("If the number of pets is poisson-distributed and people on average have 1.4 pets, how would you simuate a data set where you sampled the number of pets from 75 people?")
      ),
     # collapsible = TRUE, collapsed = TRUE),
  div(class="func-spec",
      span("rpois(n = "),
      numericInput("pois_n", NULL, 100, 1, 1000, 1),
      span(", lambda = "),
      numericInput("pois_lambda", NULL, 5, 0, NA, 1),
      span(")")
  ),
  actionButton("pois_sample", "Sample Again"),
  actionButton("pois_clear", "Clear Samples"),
  plotOutput("pois_plot", height = "500px")
)
