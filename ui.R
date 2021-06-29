# AmpliStat Shiny App 
# UI for application

# Components scripts
source('/Users/Bartek/Desktop/hrm-vis/AmpliStat/components/ui_data_upload.R')
source('/Users/Bartek/Desktop/hrm-vis/AmpliStat/components/ui_lod_plot.R')

# Operators scripts
source('/Users/Bartek/Desktop/hrm-vis/AmpliStat/operators/configure_lod_set.R')
source('/Users/Bartek/Desktop/hrm-vis/AmpliStat/operators/preprocessing_lod_data.R')

# Plots
source('/Users/Bartek/Desktop/hrm-vis/AmpliStat/plots/generate_lod_plot.R')

library(shiny)

# Define UI for application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("AmpliStat Software"),
    
            tabsetPanel(
              
                tabPanel("Loading Data", import_data),
                tabPanel("Variance Homogenity"),
                tabPanel("Outliers"),
                tabPanel("Data Visualisation"),
                tabPanel("Means comparison"),
                tabPanel("Analysis of Variance"),

                     #tabPanel("Loading Data", lod.loading.data),
                     tabPanel("Calculating Limit of Detection", 
                              lod.plotting),

                     tabPanel("Fluorescence Visualisation"),
                     tabPanel("Labeling Data"),
                     tabPanel("Diff Plots"))))
