# AmpliStat Shiny App
# Dashboard for statistical analysis for qPCR data
library(tidyverse)
library(shiny)
library(plotly)
library(splines)

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

ui <- fluidPage(navbarPage(
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
          multiple = F,
          accept = c("text/csv",
                     "text/comma-separated-values,text/plain",
                     ".csv")
        ),
        
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),
        
        # Input: Select separator ----
        radioButtons(
          "sep",
          "Separator",
          choices = c(
            Comma = ",",
            Semicolon = ";",
            Tab = "\t"
          ),
          selected = ","
        ),
        radioButtons(
          "dec",
          "Decimal",
          choices = c(Dot = '.',
                      Comma = ","
          ),
          selected = '.'
        ),
        tags$hr(),
        checkboxInput('string', "Strings as factor", TRUE),
        # Horizontal line ----
        tags$hr(),
        
        # Input: Select number of rows to display ----
        radioButtons(
          "disp",
          "Display",
          choices = c(Head = "head",
                      All = "all"),
          selected = "head"
        ),
        submitButton("Update view", icon("refresh"))
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(# Output: Data file ----
                tableOutput("contents"))
        )
      ),
  
  tabPanel(
    'Data Visualisation', 
    titlePanel("Data Visualisation Panel"),
    tags$hr(),
    sidebarLayout(
      sidebarPanel(
        strong('Select variable'),
        uiOutput('select.variable'),
        tags$hr(),
        selectInput('plot.type',
                    'Choose plot type',
                    choices = c('Histogram',
                                'Boxplot',
                                'Scatter plot')),
        submitButton()
      ),
      mainPanel(plotOutput('base_plots_output'))
    )),
  
  tabPanel(
    'Assumptions', 
    titlePanel("Check assumptions Panel"),
    tags$hr(),
    sidebarLayout(
      sidebarPanel(
        strong('Select variable'),
        uiOutput('select.variable'),
        tags$hr(),
        selectInput('check.assumps',
                    'Choose analysis',
                    choices = c('Distribution normality',
                                'Variance Homogenity',
                                'Outliers detection')),
        submitButton()
      ),
      mainPanel(verbatimTextOutput('assumps_output'))
    )),
  
  navbarMenu('Means Comparison',
             tabPanel('Parametric',
                      titlePanel("Parametric tests for comparing means between samples"),
                      sidebarLayout(
                        sidebarPanel(
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable'),
                          tags$hr(),
                          strong("T-TEST PARAM OPTIONS")
                        ),
                        mainPanel(verbatimTextOutput('means_param_output'))
                      )),
             tabPanel('Non-parametric',
                      titlePanel("Non-parametric tests for comparing means between samples"),
                      sidebarLayout(
                        sidebarPanel(
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable'),
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
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable'),
                          tags$hr(),
                          strong("ANOVA PARAM OPTIONS")
                        ),
                        mainPanel(verbatimTextOutput('anova_param_output'))
                      )),
             tabPanel('Non-parametric',
                      titlePanel("Non-parametric tests for analysis of variance"),
                      sidebarLayout(
                        sidebarPanel(
                          tags$hr(),
                          strong("Select variable"),
                          uiOutput('select.variable'),
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
             verbatimTextOutput('lod_stats_output')
           )),
  
  navbarMenu('HRM',
             tabPanel('Fluorescence Visualisation',
                      titlePanel("qPCR Fluorescence plot visualisation"),
                      tags$hr(),
                      mainPanel(plotlyOutput('qpcr_plot_output'),
                                width = 12)),

             tabPanel('Labeling genotypes',
                      titlePanel("Label and set genotypes",
                                 tags$hr())),

             tabPanel('Diff curves calculation',
                      titlePanel('Calculate differences between HRM curves')))
))




