library(shiny)
library(plotly)

pcr.plotting <- mainPanel(tags$hr(),
                          strong("qPCR fluorescence data visualisation"),
                          plotlyOutput("pcr.plot"),
                          width = 12
)