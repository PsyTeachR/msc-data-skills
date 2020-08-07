#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("The F Distribution"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("df_n",
                     "Numerator df:",
                     min = 1,
                     max = 10,
                     value = 4),
         sliderInput("df_d",
                     "Denominator df:",
                     min = 4,
                     max = 40,
                     value = 20),
         sliderInput("alpha",
                     "Alpha level",
                     min = .01, max = .10, value = .05, step = .01),
         sliderInput("f_obs",
                     "Observed F ratio",
                     min = .5, max = 10, value = 1, step = .1)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot"),
         textOutput("crit"),
         textOutput("pval")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
     cutoff <- qf(input$alpha, input$df_n, input$df_d, lower.tail = FALSE)

     ggplot(tibble::tibble(x = c(0L, 10L)), aes(x)) +
       stat_function(fun = df, args = list(df1 = input$df_n, df2 = input$df_d)) +
       geom_vline(xintercept = cutoff, color = 'red', linetype = 2L) +
       geom_vline(xintercept = input$f_obs, color = 'blue') +
       coord_cartesian(ylim = c(0, 1)) +
       labs(x = "F ratio", y = "density")
   })
   
   output$crit <- renderText({
     cutoff <- qf(input$alpha, input$df_n, input$df_d, lower.tail = FALSE)
     paste0("Critical F-ratio (shown by red line): ", round(cutoff, 3))
   })
   
   output$pval <- renderText({
     pval <- pf(input$f_obs, input$df_n, input$df_d, lower.tail = FALSE)
     paste0("p value: ",
            ifelse(round(pval < .001), "< .001",
                   sprintf("%0.3f", pval)))
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

