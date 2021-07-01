library(shiny)
library(plotly)

lod.plotting <- mainPanel(
  tags$hr(),
  strong("Limit of detection plot"),
  plotlyOutput("lod.plot"),
  tags$hr(),
  strong("Limit of Detection summary statistics"),
  verbatimTextOutput("lod.stats"), 
  width = 12
)

lod.msg <- mainPanel(
  tags$hr(),
  strong("Analysis info"),
  verbatimTextOutput("lod.msg")
)