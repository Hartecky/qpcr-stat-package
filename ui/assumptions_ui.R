# qPCR Shiny App
# Testing Assumptions UI components

assumptions <- tabPanel(
  'Assumptions',
  titlePanel("Check assumptions panel"),
  tags$hr(),
  
  # Sidebar panel with options
  sidebarLayout(
    sidebarPanel(
      strong("Select variable"),
      tags$hr(),
      
      # Variables selection
      uiOutput('select.variable.assum1'),
      tags$hr(),
      uiOutput('select.variable.assum2'),
      tags$hr(),
      
      # Assumption tests option
      selectInput(
        'check.assumps',
        'Choose analysis',
        choices = c(
          `Distribution normality` = 'normtest',
          `Variance Homogenity` = 'vartest',
          `Outliers Detection` = 'outliers'
        )
      ),
      submitButton()
    ),
    
    # Main panel, where tests results are printed
    mainPanel(
      verbatimTextOutput('assumptions_messages'),
      tags$hr(),
      verbatimTextOutput('assumptions_output'),
      tags$hr(),
      verbatimTextOutput('assumptions_interpret')
    )
  )
)