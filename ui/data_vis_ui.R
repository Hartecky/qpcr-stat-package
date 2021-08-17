data.vis <- tabPanel(
  'Data Visualisation',
  titlePanel("Data Visualisation Panel"),
  tags$hr(),
  sidebarLayout(
    sidebarPanel(
      strong('Select variable'),
      tags$hr(),
      uiOutput('select.variable'),
      tags$hr(),
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
    mainPanel(
      plotlyOutput('base_plots_output'),
      uiOutput('hist.slider'),
      width = 8
    )
  )
)