sidebar <- dashboardSidebar(
  # https://fontawesome.com/icons?d=gallery&m=free
  sidebarMenu(
    menuItem("Home", tabName = "main_tab", icon = icon("home")),
    menuItem("Uniform", tabName = "unif_tab", icon = icon("grip-lines")),
    menuItem("Binomial", tabName = "binom_tab", icon = icon("hand-peace")),
    menuItem("Normal", tabName = "norm_tab", icon = icon("star")),
    menuItem("Poisson", tabName = "pois_tab", icon = icon("fish")),
    menuItem("Data Skills Course", href = "https://psyteachr.github.io/msc-data-skills/", icon = icon("chalkboard-teacher")),
    menuItem("App Code on Github", href = "https://github.com/debruine/shiny/tree/master/simulate", icon = icon("github"))
  )
)

