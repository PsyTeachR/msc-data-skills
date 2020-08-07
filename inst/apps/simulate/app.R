# Libraries ----
library(shiny)
library(shinyjs)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(ggplot2)

# Functions ----
source("R/func.R")

# Define UI ----
source("ui/header.R")
source("ui/sidebar.R")
source("ui/main_tab.R")

ui <- dashboardPage(
  header = header,
  sidebar = sidebar,
  title = "Simulate",
  skin = "purple", # "blue", "black", "purple", "green", "red", "yellow"
  body = dashboardBody(
    useShinyjs(),
    tags$head(
      tags$link(rel = "stylesheet", 
                type = "text/css", 
                href = "custom.css")
    ),
    tabItems(
      main_tab,
      norm_tab,
      binom_tab,
      pois_tab,
      unif_tab
    )
  )
)



# Define server logic ----
server <- function(input, output, session) {
  norm_df <- reactiveVal()
  binom_df <- reactiveVal()
  pois_df <- reactiveVal()
  unif_df <- reactiveVal()
  
  # create uniform sample ----
  observeEvent(input$unif_sample, {
    n <- isolate(input$unif_n) %>% as.integer()
    min <- isolate(input$unif_min) %>% as.double()
    max <- isolate(input$unif_max) %>% as.double()
    
    if (is.na(n) || n < 1) {
      showNotification("The n was not valid; it must be >= 1")
      n <- 1
      updateNumericInput(session, "unif_n", value = n)
    }
    if (is.na(min) || min >= max) {
      showNotification("The min was not valid; it must be < max")
      min <- 0
      updateNumericInput(session, "unif_min", value = min)
    }
    if (is.na(max) || max <= min) {
      showNotification("The max was not valid; it must be > min")
      max <- 1
      updateNumericInput(session, "unif_max", value = max)
    }
    
    new_df <- data.frame( 
      sample = as.integer(input$unif_sample),
      n = n,
      min = min,
      max = max,
      x = runif(n, min, max)
    )
    
    if (!is.null(unif_df())) {
      new_df <- bind_rows(unif_df(), new_df)
    }
    
    unif_df(new_df)
  }, ignoreNULL = TRUE)
  
  observeEvent(input$unif_clear, {
    unif_df(NULL)
  })
  
  # unif_plot ----
  output$unif_plot <- renderPlot({
    plot_unif(unif_df())
  })
  
  # create normal sample ----
  observeEvent(input$norm_sample, {
    n <- isolate(input$norm_n) %>% as.integer()
    mu <- isolate(input$norm_mu) %>% as.double()
    sd <- isolate(input$norm_sd) %>% as.double()
    
    if (is.na(n) || n < 1) {
      showNotification("The n was not valid; it must be >= 1")
      n <- 1
      updateNumericInput(session, "norm_n", value = n)
    }
    if (is.na(mu)) {
      showNotification("The mean was not valid")
      mu <- 0
      updateNumericInput(session, "norm_mu", value = mu)
    }
    if (is.na(sd) || sd < 0) {
      showNotification("The sd was not valid; it must be >= 0")
      sd <- 1
      updateNumericInput(session, "norm_sd", value = sd)
    }
    
    new_df <- data.frame( 
      sample = as.integer(input$norm_sample),
      n = n,
      mu = mu,
      sd = sd,
      x = rnorm(n, mu, sd)
    )
    
    if (!is.null(norm_df())) {
      new_df <- bind_rows(norm_df(), new_df)
    }
    
    norm_df(new_df)
  }, ignoreNULL = TRUE)
  
  observeEvent(input$norm_clear, {
    norm_df(NULL)
  })
  
  # norm_plot ----
  output$norm_plot <- renderPlot({
    plot_norm(norm_df())
  })
  
  # create binomial sample ----
  observeEvent(input$binom_sample, {
    n <- isolate(input$binom_n) %>% as.integer()
    size <- isolate(input$binom_size) %>% as.integer()
    prob <- isolate(input$binom_prob) %>% as.double()
    
    if (is.na(n) || n < 1) {
      showNotification("The n was not valid; it must be >= 1")
      n <- 1
      updateNumericInput(session, "binom_n", value = n)
    }
    if (is.na(size) || size < 1) {
      showNotification("The size was not valid; it must be >= 1")
      size <- 1
      updateNumericInput(session, "binom_size", value = size)
    }
    if (is.na(prob) || prob < 0 || prob > 1) {
      showNotification("The prob was not valid; it must be >= 0 and <= 1")
      prob <- 0.5
      updateNumericInput(session, "binom_prob", value = prob)
    }
    
    new_df <- data.frame( 
      sample = as.integer(input$binom_sample),
      n = n,
      size = size,
      prob = prob,
      x = rbinom(n, size, prob)
    )
    
    if (!is.null(binom_df())) {
      new_df <- bind_rows(binom_df(), new_df)
    }
    
    binom_df(new_df)
  }, ignoreNULL = TRUE)
  
  observeEvent(input$binom_clear, {
    binom_df(NULL)
  })
  
  # binom_plot ----
  output$binom_plot <- renderPlot({
    plot_binom(binom_df())
  })
  
  
  # create poisson sample ----
  observeEvent(input$pois_sample, {
    n <- isolate(input$pois_n) %>% as.integer()
    lambda <- isolate(input$pois_lambda) %>%  as.double()
    
    if (is.na(n) || n < 1) {
      showNotification("The n was not valid; it must be >= 1")
      n <- 1
      updateNumericInput(session, "pois_n", value = n)
    }
    if (is.na(lambda) || lambda < 0) {
      showNotification("The lambda was not valid; it must be >= 0")
      lambda <- 1
      updateNumericInput(session, "pois_lambda", value = lambda)
    }
    
    new_df <- data.frame( 
      sample = as.integer(input$pois_sample),
      n = n,
      lambda = lambda,
      x = rpois(n, lambda)
    )
    
    if (!is.null(pois_df())) {
      new_df <- bind_rows(pois_df(), new_df)
    }
    
    pois_df(new_df)
  }, ignoreNULL = TRUE)
  
  observeEvent(input$pois_clear, {
    pois_df(NULL)
  })
  
  # pois_plot ----
  output$pois_plot <- renderPlot({
    plot_pois(pois_df())
  })
}

# Run the application ----
shinyApp(ui = ui, server = server)

