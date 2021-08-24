# qPCR Shiny App
# Parametric means comparison UI components

mc.parametric <- tabPanel(
  'Parametric',
  titlePanel("Parametric tests for comparing means between samples"),
  
  # Sidebar panel with options
  sidebarLayout(
    sidebarPanel(
      
      # selection of the type of test
      selectInput(
        't.test.type',
        'T-test type',
        choices = c(`One Sample` = "onesample",
                    `Two Samples` = "twosamples")
      ),
      
      # Variables selection
      tags$hr(),
      helpText("Select variable"),
      uiOutput('select.variable.mcp1'),
      uiOutput('select.variable.mcp2'),
      tags$hr(),
      strong("T-TEST PARAM OPTIONS"),
      helpText("Choose option below when comparing one sample"),
      
      # Mean to provide for one sample test
      numericInput('mu', 'Mean to compare with', 0),
      
      # selection of dependencies between the variables
      selectInput(
        'par_ttest',
        'Paired',
        choices = c(Paired = 'Paired',
                    `Non-paired` = 'Non-paired')
      ),
      
      # Alternative hypothesis selection
      selectInput(
        'alternative_ttest_p',
        'Alternative',
        choices = c(
          Less = "greater",
          Greater = "less",
          `Two Sided` = "two.sided"
        )
      ),
      
      # significance level selection
      numericInput(
        'alpha_testt',
        'Significance level',
        value = 0.05,
        step = 0.01
      ),
      submitButton()
    ),
    
    # Main panel, where results are printed
    mainPanel(verbatimTextOutput('means_param_output'))
  )
)