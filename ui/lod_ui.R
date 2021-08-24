# qPCR Shiny App
# LOD UI components

lod.ui <- tabPanel(
  'LOD',
  titlePanel("Limit of detection calculation"),
  tags$hr(),
  
  # Main panel where LOD plot is shown and LOD calculation 
  # statistics are summarized and printed
  mainPanel(
    strong("Limit of Detection plot"),
    plotlyOutput('lod_plots_output'),
    tags$hr(),
    strong("LOD Summary"),
    verbatimTextOutput('lod_stats_output'),
    width = 12
  )
)