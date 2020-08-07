##
## This is a Shiny web application. You can run the application by clicking
## the 'Run App' button above.
##
## Find out more about building applications with Shiny here:
##
##    http://shiny.rstudio.com/
##

library("shiny")
library("dplyr")
library("ggplot2")
source("funfact.R")

my_design <- list(ivs = c(A = 2L),
                  n_item = 1L,
                  between_subj = c("A", "B"))

## sim_norm(my_design, 12, gen_pop(my_design, 12))
## trial_lists(my_design, 12)
## design_formula(my_design, 12L, lme4_format = TRUE)

parms <- gen_pop(my_design, n_subj = 12)

mu <- 800
max_eff <- 200
max_sig <- 100
n_subj <- 12

parms$fixed[] <- c(mu, 1)
parms$err_var <- 1

resample <- function() {
  dat <- sim_norm(my_design, n_subj, parms, verbose = TRUE) %>%
    arrange(A, subj_id) %>%
    mutate(a_eff = fix_y - 800,
           subj_id = row_number(),
           A = factor(A),
           X = ifelse(A == "A1", 0, 1)) %>%
    rename(Y_orig = Y)
}

ui <- fluidPage(
  
  ## Application title
  titlePanel("General Linear Model"),
  withMathJax(),
  
  ## Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
                 plotOutput("distPlot", width = "200px", height = "200px"),
                 sliderInput("eff",
                             "Effect size:",
                             min = -(max_eff / 2),
                             max = (max_eff / 2),
                             value = max_eff / 4,
                             step = 5),
                 sliderInput("sigma",
                             "Sigma:",
                             min = 0,
                             max = max_sig,
                             value = max_sig / 2,
                             step = 5),
                 actionButton("resamp", "New Sample")
    ),
    
    ## Show a plot of the generated distribution
    mainPanel(width = 9,
      tabsetPanel(
        tabPanel("t-test",
                 fluidRow(column(width = 5, uiOutput("tstat"), tableOutput("ttbl")),
                          column(width = 7, verbatimTextOutput("ttest")))),
        tabPanel("regression",
                 fluidRow(column(width = 5, 
                                 selectInput("pred", label = "Coding of X",
                                             choices = list("Dummy (A1=0, A2=1)" = 1L,
                                                            "Deviation (A1=-.5, A2=.5)" = 2L,
                                                            "Sum (A1=-1, A2=1)" = 3L),
                                             selected = 1L),
                                 uiOutput("reg"),
                                 tableOutput("regtbl")),
                          column(width = 7, verbatimTextOutput("lm")))),
        tabPanel("ANOVA", 
                 fluidRow(
                   column(width = 5,
                          uiOutput("glm"), tableOutput("dmx")),
                   column(width = 7,
                          uiOutput("sumsq"), verbatimTextOutput("aov"))
                 )
        )
      )
    )
  )
)

## Define server logic required to draw a histogram
server <- function(input, output, session) {

  rv <- reactiveValues(dat = resample(), ss_a = 0, ss_err = 0,
                       cf = c(0, 0), res = rep(0, nrow(resample())))

  mv <- reactive({
    c(mu + max_eff / 2 * rv$dat$a_eff + max_sig * rv$dat$err,
      mu + (- max_eff / 2) * rv$dat$a_eff + max_sig * rv$dat$err)
  })
  
  newdat <- reactive({
    new_a <- input$eff * rv$dat$a_eff
    new_err <- input$sigma * rv$dat$err
    rv$dat$X <- case_when(input$pred == 2L ~ ifelse(rv$dat$A == "A1", -.5, .5),
                          input$pred == 3L ~ ifelse(rv$dat$A == "A1", -1, 1),
                          TRUE ~ ifelse(rv$dat$A == "A1", 0, 1))
    rv$dat$Y <- mu + new_a + new_err
    rv$dat 
  })

  observeEvent(input$resamp, {
    rv$dat = resample()
  })
  
  output$distPlot <- renderPlot({
    ggplot(newdat(), aes(A, Y)) +
      geom_point(alpha = .2, size = 4) +
      stat_summary(geom = "point", size = 8, shape = 3L, fun.y = mean,
                   color = "red") +
      coord_cartesian(ylim = c(min(mv()), max(mv())))
  }, width = 200, height = 200)

  ## t-test
  output$tstat <- renderUI({

    A1 <- newdat() %>% filter(A == "A1") %>% pull(Y) %>% mean()
    A2 <- newdat() %>% filter(A == "A2") %>% pull(Y) %>% mean()
    s_1 <- newdat() %>% filter(A == "A1") %>% pull(Y) %>% sd()
    s_2 <- newdat() %>% filter(A == "A2") %>% pull(Y) %>% sd()
    Ns <- nrow(newdat()) / 2
    num <- A1 - A2
    denom <- sqrt((s_1^2 / Ns) + (s_2^2 / Ns))
    
    withMathJax(
      paste0("$$t = ",
             "\\frac{\\bar{Y}_{A1}-\\bar{Y}_{A2}}{",
             "\\sqrt{\\left(\\frac{s_{A1}^2}{N_1} + \\frac{s_{A2}^2}{N_2}\\right)}",
             "}$$"),
      paste0("$$= \\frac{", round(A1, 1), "-", round(A2, 1), "}", # numerator
             "{\\sqrt{\\left(", # denominator starts here
             "\\frac{", round(s_1^2, 1), "}{", Ns, "} + \\frac{", 
             round(s_2^2, 1), "}{", Ns, "}",
             "\\right)", 
             "}}$$"),
      paste0("$$= \\frac{", round(num, 1), "}", # numerator
             "{", round(denom, 1), "}",
             " = ", round(num / denom, 4),
             "$$")
    )
  })
  
  output$ttbl <- renderTable({
    newdat() %>% select(i = subj_id, A, Y)
  })
  
  output$ttest <- renderPrint({
    cat("> t.test(Y ~ A, dat, var.equal = TRUE)\n")
    newdat() %>%
      t.test(Y ~ A, ., var.equal = TRUE) 
  })
  
  ## regression panel
  output$lm <- renderPrint({
    cat("> summary(lm(Y ~ X, dat))\n")
    mod <- lm(Y ~ X, newdat())
    rv$cf <- as.numeric(coef(mod))
    rv$res <- residuals(mod)
    summary(mod)
  })
  
  output$reg <- renderUI({
    withMathJax(
      paste0("$$Y_i = \\beta_0 + \\beta_1 X_i + e_i$$"),
      paste0("$$Y_i = ", round(rv$cf[1], 1), "+", round(rv$cf[2], 1), " X_i + e_i$$")
    )
  })
  
  output$regtbl <- renderTable({
    newdat() %>% 
      mutate(b0 = round(rv$cf[1], 1),
             b1 = round(rv$cf[2], 1),
             err = rv$res) %>%
      select(i = subj_id, Y, b0, b1, X, err)
  })
  
  ## ANOVA panel
  output$aov <- renderPrint({
    cat("> summary(aov(Y ~ A, dat))\n")
    summary(aov(Y ~ A, newdat()))
  })
  
  output$glm <- renderUI({
    mu_hat <- newdat() %>% pull(Y) %>% mean()
    A1 <- newdat() %>% filter(A == "A1") %>% pull(Y) %>% mean()
    A2 <- newdat() %>% filter(A == "A2") %>% pull(Y) %>% mean()
    withMathJax(
      paste0("$$Y_i = \\mu + A_i + e_i$$"),
      paste0("$$e_i \\sim N(0, \\sigma^2)$$"),
      paste0("$$\\hat{\\mu} = \\bar{Y} = ", round(mu_hat, 1) , "$$"),
      paste0("$$\\hat{A}_1 = \\bar{Y}_{A1} - \\hat{\\mu} = ",
             round(A1, 1), " - ", round(mu_hat, 1), " = ",
             round(A1 - mu_hat, 1), "$$"),
      paste0("$$\\hat{A}_2 = \\bar{Y}_{A2} - \\hat{\\mu} = ",
             round(A2, 1), " - ", round(mu_hat, 1), " = ",
             round(A2 - mu_hat, 1), "$$")
    )
  })
  
  output$sumsq <- renderUI({
    withMathJax(
      paste0("$$SS_{total} = SS_{A} + SS_{error}$$"),
      paste0("$$", round(rv$ss_a + rv$ss_err, 1), " = ",
             round(rv$ss_a, 1), " + ", round(rv$ss_err), "$$"),
      ##paste0("$$SS_{A} = ", round(rv$ss_a, 1), "; ",
      ##       "SS_{err} = ", round(rv$ss_err, 1), "$$"),
      paste0("$$MS_{A} = \\frac{SS_{A}}{df_{A}} = \\frac{", 
             round(rv$ss_a, 1), "}{1} = ", round(rv$ss_a, 1), "$$"),
      paste0("$$MS_{err} = \\frac{SS_{err}}{df_{err}} = \\frac{", 
             round(rv$ss_err, 1), "}{", nrow(newdat()) - 2L,
             "} = ", round(rv$ss_err / (nrow(newdat()) - 2L), 1), "$$"),
      paste0("$$F(1, ", nrow(newdat()) - 2L, ") = ",
             "\\frac{MS_{A}}{MS_{error}} = \\frac{",
             round(rv$ss_a, 1), "}{", 
             round(rv$ss_err / (nrow(newdat()) - 2L), 1),
             "} = ",
             if (near(rv$ss_err, 0)) {
               if (near(rv$ss_a, 0)) "NaN" else "+\\infty" 
             } else {
                round(rv$ss_a / (rv$ss_err / (nrow(newdat()) - 2L)), 3)
             },
             "$$")
    )
  })
  
  output$dmx <- renderTable({
    dmx <- newdat() %>%
      mutate(mu = mean(Y)) %>%
      group_by(A) %>%
      mutate(A_eff = mean(Y) - mu,
             err = Y - mu - A_eff) %>%
      ungroup() %>%
      arrange(A, subj_id) %>%
      select(i = subj_id, A, Y, mu, A_eff, err)
    rv$ss_a <- sum(dmx$A_eff^2)
    rv$ss_err <- sum(dmx$err^2)
    dmx
  })
}

## Run the application 
shinyApp(ui = ui, server = server)

