aov.parametric <- tabPanel(
  'Parametric',
  titlePanel("Parametric tests for analysis of variance"),
  sidebarLayout(
    sidebarPanel(
      strong("ANOVA test"),
      
      selectInput(
        'aovp.test.type',
        'Test type',
        choices = c(`One Sample` = "onesample",
                    `Two Samples` = "twosamples")
      ),
      tags$hr(),
      
      helpText("Categorical X1 variable"),
      uiOutput('select.variable.aovp1'),
      helpText("Categorical X2 variable"),
      uiOutput('select.variable.aovp2'),
      helpText("Dependent Y variable"),
      uiOutput('select.variable.aovp3'),
      
      tags$hr(),
      submitButton()
    ),
    mainPanel(verbatimTextOutput('anova_param_output'),
              width = 8)
  )
)