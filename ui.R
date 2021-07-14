# ------------------------------------------------------------------------------
# AMPLISTAT SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# USER INTERFACE COMPONENTS
# ------------------------------------------------------------------------------

library(tidyverse)
library(shiny)
library(plotly)
library(splines)
library(shinythemes)
library(shinyWidgets)
library(reshape2)
library(FSA)
library(rcompanion)
library(rsconnect)
library(shinydashboard)

# HOME LINUX SOURCE FILES ------------------------------------------------------
# OPERATORS FUNCTIONS
# source('/home/hartek/AmpliStat/operators/configure_lod_set.R')
# source('/home/hartek/AmpliStat/operators/preprocessing_lod_data.R')
# source('/home/hartek/AmpliStat/operators/melt_data.R')
# 
# PLOTTING FUNCTIONS
# source('/home/hartek/AmpliStat/plots/generate_lod_plot.R')
# source('/home/hartek/AmpliStat/plots/fluorescence_plot.R')

# WORK OFFICE SOURCE FILES -----------------------------------------------------
source('operators/configure_lod_set.R', chdir = T)
source('operators/preprocessing_lod_data.R')
source('operators/melt_data.R')
source('operators/diff_curve_calc.R')
source('operators/assumptions.R')
source('operators/anova.R')

# PLOTTING FUNCTIONS
source('plots/base_plot.R')
source('plots/fluorescence_plot.R')
source('plots/generate_lod_plot.R')

# UI FOR WHOLE APPLICATION -----------------------------------------------------
ui <- fluidPage(
  theme = shinytheme("darkly"),
  navbarPage(
  'AmpliStat',
  
  # DATA UPLOAD UI PANEL -------------------------------------------------------
  tabPanel(
    strong('Data Upload'),
    titlePanel('Uploading Files'),
    tags$hr(),
    
    sidebarLayout(
      sidebarPanel(
        fileInput(
          'file1',
          'Choose CSV file',
          multiple = T,
          accept = c("text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")),
        checkboxInput("header", "Header", TRUE),
        selectInput("sep",
                     "Separator",
                     choices = c(Comma = ",",
                                 Semicolon = ";",
                                 Tab = "\t"),
                     selected = ","
                     ),
        selectInput("dec",
                     "Decimal",
                     choices = c(Dot = '.',Comma = ","),
                     selected = '.'),
        tags$hr(),
        checkboxInput('string', "Strings as factor", TRUE),
        tags$hr(),
        
        selectInput("disp",
                     "Display",
                     choices = c(Head = "head",
                                 All = "all"),
                     selected = "head"),
        submitButton("Update view", icon("refresh"))),
      
      mainPanel(dataTableOutput("contents"),
                verbatimTextOutput('contents.stats'),
                width = 8))),
  
  # DATA VISUALISATION PANEL ---------------------------------------------------
  tabPanel(
    'Data Visualisation', 
    titlePanel("Data Visualisation Panel"),
    tags$hr(),
    sidebarLayout(
      sidebarPanel(
        strong('Select variable'),
        tags$hr(),
        uiOutput('select.variable'),
        tags$hr(),
        selectInput('plot.type',
                    'Choose plot type',
                    choices = c(Histogram = 'histogram',
                                Boxplot = 'boxplt',
                                Scatter = 'scatter')),
        submitButton()),
      mainPanel(plotlyOutput('base_plots_output'),
                uiOutput('hist.slider'),
                width = 8)
    )),
  
  # ASSUMPTIONS TESTING PANEL --------------------------------------------------
  tabPanel(
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
        selectInput('check.assumps',
                    'Choose analysis',
                    choices = c(`Distribution normality` = 'normtest',
                                `Variance Homogenity` = 'vartest',
                                `Outliers Detection` = 'outliers')),
        submitButton()),
      mainPanel(verbatimTextOutput('assumptions_messages'),
                tags$hr(),
                verbatimTextOutput('assumptions_output'),
                tags$hr(),
                verbatimTextOutput('assumptions_interpret'))
      )),
  
  # MEANS COMPARISON MENU ------------------------------------------------------
  navbarMenu('Means Comparison',
             
             # PARAMETRIC TESTS ------------------------------------------------
             tabPanel('Parametric',
                      titlePanel("Parametric tests for comparing means between samples"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput('t.test.type',
                                      'T-test type',
                                      choices = c(`One Sample` = "onesample",
                                                  `Two Samples` = "twosamples")),
                          tags$hr(),
                          helpText("Select variable"),
                          uiOutput('select.variable.mcp1'),
                          uiOutput('select.variable.mcp2'),
                          tags$hr(),
                          strong("T-TEST PARAM OPTIONS"),
                          helpText("Choose option below when comparing one sample"),
                          numericInput('mu', 'Mean to compare with', 0),
                          
                          selectInput('par_ttest', 
                                      'Paired',
                                      choices = c(Paired = 'Paired',
                                                  `Non-paired` = 'Non-paired')),
                          selectInput('alternative_ttest_p',
                                      'Alternative',
                                      choices = c(Less = "greater",
                                                  Greater = "less",
                                                  `Two Sided` = "two.sided")),
                          numericInput('alpha_testt',
                                       'Significance level',
                                       value = 0.05,
                                       step = 0.01),
                          submitButton()),
                        
                        mainPanel(verbatimTextOutput('means_param_output'))
                      )),
             
             # NON-PARAMETRIC TESTS --------------------------------------------
             tabPanel('Non-parametric',
                      titlePanel("Non-parametric tests for comparing means between samples"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput('mcnp.test.type',
                                      'Test type',
                                      choices = c(`One Sample` = "onesample",
                                                  `Two Samples` = "twosamples")),
                          tags$hr(),

                          uiOutput('select.variable.mcnp1'),
                          uiOutput('select.variable.mcnp2'),
                          tags$hr(),
                          
                          strong("T-TEST NON-PARAM OPTIONS"),
                          helpText("Choose option below when comparing one sample"),
                          numericInput('mu_np', 'Mean to compare with', 0),
                         
                          selectInput('par_wilcox', 
                                      'Paired',
                                      choices = c(Paired = 'Paired',
                                                  `Non-paired` = 'Non-paired')),
                          selectInput('alternative_wilcox',
                                      'Alternative',
                                      choices = c(Less = "greater",
                                                  Greater = "less",
                                                  `Two Sided` = "two.sided")),
                          numericInput('alpha_wilcox',
                                       'Significance level',
                                       value = 0.05,
                                       step = 0.01),
                          submitButton()
                        ),
                        mainPanel(verbatimTextOutput('means_nonparam_output'))
                      ))),
  
  # ANALYSIS OF VARIANCE PANEL -------------------------------------------------
  navbarMenu('ANOVA',
             
             # PARAMETRIC TESTS ------------------------------------------------
             tabPanel('Parametric',
                      titlePanel("Parametric tests for analysis of variance"),
                      sidebarLayout(
                        sidebarPanel(
                          strong("ANOVA test"),
                          
                          selectInput('aovp.test.type',
                                      'Test type',
                                      choices = c(`One Sample` = "onesample",
                                                  `Two Samples` = "twosamples")),
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
                      )),
             
             # NON-PARAMETRIC TESTS --------------------------------------------
             tabPanel('Non-parametric',
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
                      ))),
  
  # LIMIT OF DETECTION PANEL ---------------------------------------------------
  tabPanel('LOD',
           titlePanel("Limit of detection calculation"),
           tags$hr(),
           mainPanel(
             strong("Limit of Detection plot"),
             plotlyOutput('lod_plots_output'),
             tags$hr(),
             strong("LOD Summary"),
             verbatimTextOutput('lod_stats_output'),
             width = 12
           )),
  
  # HIGH RESOLUTION MELT MENU --------------------------------------------------
  navbarMenu('HRM',
             
             # MELTING CURVES VISUALISATION ------------------------------------
             tabPanel('Fluorescence Visualisation',
                      titlePanel("qPCR Fluorescence plot visualisation"),
                      tags$hr(),
                      mainPanel(plotlyOutput('qpcr_plot_output'),
                                width = 12)),
             
             # LABELING GENOTYPES PANEL ----------------------------------------
             tabPanel('Labeling genotypes',
                      titlePanel("Label and set genotypes"),
                      tags$hr()),
             
             # DIFFERENCE PLOTS CALCULATION ------------------------------------
             tabPanel('Diff curves calculation',
                      titlePanel('Calculate differences between HRM curves'),
                      tags$hr()))
  ))


