# AmpliStat Shiny App
# Dashboard for statistical analysis for qPCR data
library(shiny)
library(plotly)
library(shinythemes)
library(shinyWidgets)
library(outliers)
# HOME LINUX -------------------------------------------------------------------
# Components scripts
# source('/home/hartek/AmpliStat/components/ui_data_upload.R')
# source('/home/hartek/AmpliStat/components/ui_lod_plot.R')
# source('/home/hartek/AmpliStat/components/ui_fluorescence_plot.R')
# 
# # Operators scripts
# source('/home/hartek/AmpliStat/operators/configure_lod_set.R')
# source('/home/hartek/AmpliStat/operators/preprocessing_lod_data.R')
# source('/home/hartek/AmpliStat/operators/melt_data.R')
# 
# # Plots
# source('/home/hartek/AmpliStat/plots/generate_lod_plot.R')
# source('/home/hartek/AmpliStat/plots/fluorescence_plot.R')

# WORK OFFICE ------------------------------------------------------------------
# OPERATORS FUNCTIONS
source('/Users/Bartek/Desktop/AmpliStat/operators/configure_lod_set.R')
source('/Users/Bartek/Desktop/AmpliStat/operators/preprocessing_lod_data.R')
source('/Users/Bartek/Desktop/AmpliStat/operators/melt_data.R')
source('/Users/Bartek/Desktop/AmpliStat/operators/diff_curve_calc.R')
source('/Users/Bartek/Desktop/AmpliStat/operators/assumptions.R')

# PLOTTING FUNCTIONS
source('/Users/Bartek/Desktop/AmpliStat/plots/base_plot.R')
source('/Users/Bartek/Desktop/AmpliStat/plots/fluorescence_plot.R')
source('/Users/Bartek/Desktop/AmpliStat/plots/generate_lod_plot.R')

ui <- fluidPage(
  theme = shinytheme("darkly"),
  navbarPage(
  'AmpliStat',
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
                verbatimTextOutput('contents.stats')))),
  
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
  navbarMenu('Means Comparison',
             tabPanel('Parametric',
                      titlePanel("Parametric tests for comparing means between samples"),
                      sidebarLayout(
                        sidebarPanel(
                          strong("Choose T-test type"),
                          selectInput('t.test.type',
                                      'T-test type',
                                      choices = c("One sample",
                                                  "Two samples")),
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable.mcp'),
                          tags$hr(),
                          strong("T-TEST PARAM OPTIONS")
                        ),
                        mainPanel(verbatimTextOutput('means_param_output'))
                      )),
             tabPanel('Non-parametric',
                      titlePanel("Non-parametric tests for comparing means between samples"),
                      sidebarLayout(
                        sidebarPanel(
                          strong('Choose test type'),
                          selectInput('mcnp.test.type',
                                      'Test type',
                                      choices = c("One sample",
                                                  "Two samples")),
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable.mcnp'),
                          tags$hr(),
                          strong("T-TEST NON PARAM OPTIONS")
                        ),
                        mainPanel(verbatimTextOutput('means_nonparam_output'))
                      ))),
  navbarMenu('ANOVA',
             tabPanel('Parametric',
                      titlePanel("Parametric tests for analysis of variance"),
                      sidebarLayout(
                        sidebarPanel(
                          strong("Choose test type"),
                          selectInput('aovp.test.type',
                                      'Test type',
                                      choices = c("One sample",
                                                  "Two samples")),
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable.aovp'),
                          tags$hr(),
                          strong("ANOVA PARAM OPTIONS")
                        ),
                        mainPanel(verbatimTextOutput('anova_param_output'))
                      )),
             tabPanel('Non-parametric',
                      titlePanel("Non-parametric tests for analysis of variance"),
                      sidebarLayout(
                        sidebarPanel(
                          strong("Choose test type"),
                          selectInput('aovnp.test.type',
                                      'Test type',
                                      choices = c("One sample",
                                                  "Two samples")),
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable.aovnp'),
                          tags$hr(),
                          strong("ANOVA NON PARAM OPTIONS")
                        ),
                        mainPanel(verbatimTextOutput('anova_nonparam_output'))
                      ))),
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
  
  navbarMenu('HRM',
             tabPanel('Fluorescence Visualisation',
                      titlePanel("qPCR Fluorescence plot visualisation"),
                      tags$hr(),
                      mainPanel(plotlyOutput('qpcr_plot_output'),
                                width = 12)),
             
             tabPanel('Labeling genotypes',
                      titlePanel("Label and set genotypes"),
                      tags$hr()),
             
             tabPanel('Diff curves calculation',
                      titlePanel('Calculate differences between HRM curves'),
                      tags$hr()))
  ))


