mc.nonparametric <- tabPanel(
  'Non-parametric',
  titlePanel("Non-parametric tests for comparing means between samples"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        'mcnp.test.type',
        'Test type',
        choices = c(`One Sample` = "onesample",
                    `Two Samples` = "twosamples")
      ),
      tags$hr(),
      
      uiOutput('select.variable.mcnp1'),
      uiOutput('select.variable.mcnp2'),
      tags$hr(),
      
      strong("T-TEST NON-PARAM OPTIONS"),
      helpText("Choose option below when comparing one sample"),
      numericInput('mu_np', 'Mean to compare with', 0),
      
      selectInput(
        'par_wilcox',
        'Paired',
        choices = c(Paired = 'Paired',
                    `Non-paired` = 'Non-paired')
      ),
      selectInput(
        'alternative_wilcox',
        'Alternative',
        choices = c(
          Less = "greater",
          Greater = "less",
          `Two Sided` = "two.sided"
        )
      ),
      numericInput(
        'alpha_wilcox',
        'Significance level',
        value = 0.05,
        step = 0.01
      ),
      submitButton()
    ),
    mainPanel(verbatimTextOutput('means_nonparam_output'))
  )
)