# qPCR Shiny App
# Nonparametric anova UI components

aov.nonparametric <- tabPanel(
  'Non-parametric',
  titlePanel("Non-parametric tests for analysis of variance"),
  
  # Sidebar panel with options
  sidebarLayout(
    sidebarPanel(
      tags$hr(),
      
      # Variable selection
      helpText("Categorical X1 variable"),
      uiOutput('select.variable.aovnp1'),
      helpText("Categorical Y variable"),
      uiOutput('select.variable.aovnp2'),
      
      tags$hr(),
      submitButton()
    ),
    
    # Main panel where results are printed
    mainPanel(verbatimTextOutput('anova_nonparam_output'))
  )
)