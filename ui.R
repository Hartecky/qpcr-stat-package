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
          multiple = T,
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
    ))
))


