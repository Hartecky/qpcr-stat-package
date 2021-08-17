hrm.ui <- tabPanel(
  'Fluorescence Visualisation',
  titlePanel("qPCR Fluorescence plot visualisation"),
  tags$hr(),
  sidebarLayout(
    sidebarPanel(
      strong("Choose reference curve"),
      uiOutput('ref.curve'),
      tags$hr(),
      submitButton()
    ),
    mainPanel(
      plotlyOutput('qpcr_plot_output'),
      plotlyOutput('qpcr_diff_output'),
      width = 8
    )
  )
)