library(shiny)
library(plotly)

data_views <- sidebarLayout(
  
  # Layout for chosing variables
  sidebarPanel(
    strong("Data Visualisation panel"),
    tags$br(),
    tags$br(),
    # uiOutput for variables avalaible in dataframe
    uiOutput('data.variables'),
    
    tags$hr(),
    
    # Select Input for the type of plot
    
    selectInput('plot.types', 'Choose plot type',
                choices = c('Histogram',
                            'Boxplot',
                            'Scatter plot'))),
  
  # Layout for plotting results
  mainPanel(
    strong("Plots"),
    tags$hr(),
    plotOutput('plot.vis'),
    tags$hr(),
    textOutput('text.out')
  ))
