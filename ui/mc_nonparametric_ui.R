# qPCR Shiny App
# Nonparametic means comparison UI components

mc.nonparametric <- tabPanel(
  'Non-parametric',
  titlePanel("Non-parametric tests for comparing means between samples"),
  
  # Sidebar panel with options
  sidebarLayout(
    sidebarPanel(
      
      # Test type selection
      selectInput(
        'mcnp.test.type',
        'Test type',
        choices = c(`One Sample` = "onesample",
                    `Two Samples` = "twosamples")
      ),
      tags$hr(),
      
      # Variable selection
      uiOutput('select.variable.mcnp1'),
      uiOutput('select.variable.mcnp2'),
      tags$hr(),
      
      strong("T-TEST NON-PARAM OPTIONS"),
      helpText("Choose option below when comparing one sample"),
      
      # Mean to provide for one sample test
      numericInput('mu_np', 'Mean to compare with', 0),
      
      # selection of dependencies between the variables
      selectInput(
        'par_wilcox',
        'Paired',
        choices = c(Paired = 'Paired',
                    `Non-paired` = 'Non-paired')
      ),
      
      # Alternative hypothesis selection
      selectInput(
        'alternative_wilcox',
        'Alternative',
        choices = c(
          Less = "greater",
          Greater = "less",
          `Two Sided` = "two.sided"
        )
      ),
      
      # Significance level selection
      numericInput(
        'alpha_wilcox',
        'Significance level',
        value = 0.05,
        step = 0.01
      ),
      submitButton()
    ),
    
    # Main panel where results are printed
    mainPanel(verbatimTextOutput('means_nonparam_output'))
  )
)