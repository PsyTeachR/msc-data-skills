## app.R ##
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)

source("R/split_violin.R")
source("R/data_funcs.R")
source("R/plot_funcs.R")

# ui ----
ui <- dashboardPage(
  dashboardHeader(title = "Plot Demo"),
  dashboardSidebar(
    sliderInput("n", "Number of participants", min = 0, max = 1000, step = 10, value = 100),
    sliderInput("group_effect", "Group Main Effect", min = -2, max = 2, step = 0.1, value = 0),
    sliderInput("stim_effect", "Task Main Effect", min = -2, max = 2, step = 0.1, value = 0),
    sliderInput("ixn", "Group x Task Interaction", min = -2, max = 2, step = 0.1, value = 0.5),
    actionButton("rerun", "Re-run Simulation"),
    tags$a(href="https://github.com/debruine/shiny/tree/master/plotdemo", "Shiny App Code on GitHub")
  ),
  dashboardBody(
    p("This app simulates data from two groups on two tasks. You can set the size of the 
       group and task main effects and the group-by-task interaction in the sidebar 
       (in the menu if minimised)."),
    a("Tutorial with code", href="https://debruine.github.io/posts/plot-comparison/"),
    fluidRow(
      box(title="Bar Plot", plotOutput("barplot", height = 250), 
          p("Bars represent means and standard errors"), width = 4),
      box(title="Box Plot", plotOutput("boxplot", height = 250), 
          p("Boxes represent medians and interquartile range"), width = 4),
      box(title="Violin Plot", plotOutput("violin", height = 250), 
          p("Shapes represent distributions, dots are means with 95% CI"), width = 4),
      box(title="Violinbox Plot", plotOutput("violinbox", height = 250), 
          p("A violin plot with a boxplot superimposed"), width = 4),
      box(title="Split Violin Plot", plotOutput("splitviolin", height = 250), 
          p("Each half of the violin is a distribution"), 
          a("Split-violin code", href="https://debruine.github.io/posts/plot-comparison/"), width = 4), 
      box(title="Raincloud Plot", plotOutput("raincloud", height = 250), 
          p("Shapes represent distributions and rain is individual data points"), 
          a("Code from Micah Allen", href="https://micahallen.org/2018/03/15/introducing-raincloud-plots/"), width = 4)
    )
  )
)

server <- function(input, output, session) {
  #addClass(selector = "body", class = "sidebar-collapse")
  
  data <- reactive({
    input$rerun
    
    makeData(input$n, input$group_effect, input$stim_effect, input$ixn)
  })
  
  output$barplot <- renderPlot({
    plot_barplot(data())
  })

  output$boxplot <- renderPlot({
    plot_boxplot(data())
  })
  
  output$violin <- renderPlot({
    plot_violin(data())
  })
  
  output$violinbox <- renderPlot({
    plot_violinbox(data())
  })
  
  output$splitviolin <- renderPlot({
    plot_splitviolin(data())
  })
  
  output$raincloud <- renderPlot({
    plot_raincloud(data())
  })

}

shinyApp(ui, server)