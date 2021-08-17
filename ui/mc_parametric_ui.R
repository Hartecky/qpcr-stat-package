mc.parametric <- tabPanel(
  'Parametric',
  titlePanel("Parametric tests for comparing means between samples"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        't.test.type',
        'T-test type',
        choices = c(`One Sample` = "onesample",
                    `Two Samples` = "twosamples")
      ),
      tags$hr(),
      helpText("Select variable"),
      uiOutput('select.variable.mcp1'),
      uiOutput('select.variable.mcp2'),
      tags$hr(),
      strong("T-TEST PARAM OPTIONS"),
      helpText("Choose option below when comparing one sample"),
      numericInput('mu', 'Mean to compare with', 0),
      
      selectInput(
        'par_ttest',
        'Paired',
        choices = c(Paired = 'Paired',
                    `Non-paired` = 'Non-paired')
      ),
      selectInput(
        'alternative_ttest_p',
        'Alternative',
        choices = c(
          Less = "greater",
          Greater = "less",
          `Two Sided` = "two.sided"
        )
      ),
      numericInput(
        'alpha_testt',
        'Significance level',
        value = 0.05,
        step = 0.01
      ),
      submitButton()
    ),
    
    mainPanel(verbatimTextOutput('means_param_output'))
  )
)