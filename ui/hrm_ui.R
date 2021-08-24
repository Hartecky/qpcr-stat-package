# qPCR Shiny App
# HRM UI components

hrm.ui <- tabPanel(
  'Fluorescence Visualisation',
  titlePanel("qPCR Fluorescence plot visualisation"),
  tags$hr(),
  
  # Sidebar panel options
  sidebarLayout(
    sidebarPanel(
      
      # Reference curve selection
      strong("Choose reference curve"),
      uiOutput('ref.curve'),
      tags$hr(),
      submitButton()
    ),
    
    # Main panel where created plots are shown
    mainPanel(
      plotlyOutput('qpcr_plot_output'),
      plotlyOutput('qpcr_diff_output'),
      width = 8
    )
  )
)