lod.ui <- tabPanel(
  'LOD',
  titlePanel("Limit of detection calculation"),
  tags$hr(),
  mainPanel(
    strong("Limit of Detection plot"),
    plotlyOutput('lod_plots_output'),
    tags$hr(),
    strong("LOD Summary"),
    verbatimTextOutput('lod_stats_output'),
    width = 12
  )
)