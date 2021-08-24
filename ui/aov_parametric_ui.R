# qPCR Shiny App
# Parametric anova UI components

aov.parametric <- tabPanel(
  'Parametric',
  titlePanel("Parametric tests for analysis of variance"),
  
  # Sidebar panel with options
  sidebarLayout(
    sidebarPanel(
      strong("ANOVA test"),
      
      # Selection of test type
      selectInput(
        'aovp.test.type',
        'Test type',
        choices = c(`One Sample` = "onesample",
                    `Two Samples` = "twosamples")
      ),
      tags$hr(),
      
      # Variable selection
      helpText("Categorical X1 variable"),
      uiOutput('select.variable.aovp1'),
      helpText("Categorical X2 variable"),
      uiOutput('select.variable.aovp2'),
      helpText("Dependent Y variable"),
      uiOutput('select.variable.aovp3'),
      
      tags$hr(),
      submitButton()
    ),
    
    # Main panel where results are printed
    mainPanel(verbatimTextOutput('anova_param_output'),
              width = 8)
  )
)