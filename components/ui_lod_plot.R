library(shiny)
library(plotly)
# lod.plotting.data <- plotlyOutput("lod.plot")
# lod.values.data <- verbatimTextOutput("lod.stats")

lod.plotting <- mainPanel(
  tags$hr(),
  strong("Limit of detection plot"),
  plotlyOutput("lod.plot"),
  tags$hr(),
  strong("Limit of Detection summary statistics"),
  verbatimTextOutput("lod.stats"), 
  width = 12
)
