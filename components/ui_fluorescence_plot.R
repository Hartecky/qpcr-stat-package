library(shiny)
library(plotly)

pcr.plotting <- mainPanel(tags$hr(),
                          strong("qPCR fluorescence data visualisation"),
                          plotlyOutput("pcr.plot"),
                          width = 12
)

pcr.msg <- mainPanel(
  tags$hr(),
  strong("Analysis info"),
  verbatimTextOutput("pcr.msg")
)