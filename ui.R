# AmpliStat Shiny App 
# Dashboard for statistical analysis for qPCR data

library(shiny)

# Components scripts
source('/Users/Bartek/Desktop/AmpliStat/components/ui_data_upload.R')
source('/Users/Bartek/Desktop/AmpliStat/components/ui_lod_plot.R')
source('/Users/Bartek/Desktop/AmpliStat/components/ui_fluorescence_plot.R')

# Operators scripts
source('/Users/Bartek/Desktop/AmpliStat/operators/configure_lod_set.R')
source('/Users/Bartek/Desktop/AmpliStat/operators/preprocessing_lod_data.R')
source('/Users/Bartek/Desktop/AmpliStat/operators/melt_data.R')

# Plots
source('/Users/Bartek/Desktop/AmpliStat/plots/generate_lod_plot.R')
source('/Users/Bartek/Desktop/AmpliStat/plots/fluorescence_plot.R')

# Define UI for application
shinyUI(fluidPage(
  
  # App title
  titlePanel("AmpliStat Software"),
  
  # Main panel with options
  tabsetPanel(tabPanel("Loading Data", import_data),
              tabPanel("Variance Homogenity"),
              tabPanel("Outliers"),
              tabPanel("Data Visualisation"),
              tabPanel("Means comparison"),
              tabPanel("Analysis of Variance"),
              tabPanel("Calculating Limit of Detection", 
                       lod.plotting, 
                       lod.msg),
              tabPanel("Fluorescence Visualisation", 
                       pcr.plotting),
              tabPanel("Labeling Data"),
              tabPanel("Diff Plots"))))
