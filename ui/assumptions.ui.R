assumptions <- tabPanel(
  'Assumptions',
  titlePanel("Check assumptions panel"),
  tags$hr(),
  sidebarLayout(
    sidebarPanel(
      strong("Select variable"),
      tags$hr(),
      uiOutput('select.variable.assum1'),
      tags$hr(),
      uiOutput('select.variable.assum2'),
      tags$hr(),
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
    mainPanel(
      verbatimTextOutput('assumptions_messages'),
      tags$hr(),
      verbatimTextOutput('assumptions_output'),
      tags$hr(),
      verbatimTextOutput('assumptions_interpret')
    )
  )
)