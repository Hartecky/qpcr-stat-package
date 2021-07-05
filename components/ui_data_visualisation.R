library(shiny)
library(plotly)

select.variables <- sidebarPanel(
  strong("Prepare plots for data visualisation"),
  tags$br(),
  uiOutput('select.var'),
  tags$hr()
  # selectInput('plots', "Select plot",
  #             choices = c("Box plot", "Histogram", "Scatter plot"))
)

view.plot <- mainPanel(tags$hr(),
                       strong("Data Visualisation"),
                       plotlyOutput("data.plot"),
                       width = 12)