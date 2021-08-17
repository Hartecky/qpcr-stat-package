aov.nonparametric <- tabPanel(
  'Non-parametric',
  titlePanel("Non-parametric tests for analysis of variance"),
  sidebarLayout(
    sidebarPanel(
      tags$hr(),
      helpText("Categorical X1 variable"),
      uiOutput('select.variable.aovnp1'),
      helpText("Categorical Y variable"),
      uiOutput('select.variable.aovnp2'),
      
      tags$hr(),
      submitButton()
    ),
    mainPanel(verbatimTextOutput('anova_nonparam_output'))
  )
)