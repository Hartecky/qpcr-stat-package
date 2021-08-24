# qPCR Shiny App
# Data Visualisation UI components

data.vis <- tabPanel(
  'Data Visualisation',
  titlePanel("Data Visualisation Panel"),
  tags$hr(),
  
  # Sidebar panel with options
  sidebarLayout(
    sidebarPanel(
      strong('Select variable'),
      tags$hr(),
      
      # Variable selection
      uiOutput('select.variable'),
      tags$hr(),
      
      # Plot type options
      selectInput(
        'plot.type',
        'Choose plot type',
        choices = c(
          Histogram = 'histogram',
          Boxplot = 'boxplt',
          Scatter = 'scatter'
        )
      ),
      submitButton()
    ),
    
    # Main panel, where chosen plot is shown
    mainPanel(
      plotlyOutput('base_plots_output'),
      uiOutput('hist.slider'),
      width = 8
    )
  )
)