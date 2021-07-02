# # AmpliStat Shiny App 
# # Dashboard for statistical analysis for qPCR data
# 
# library(shiny)
# 
# # Components scripts
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
# 
# # Define UI for application
# shinyUI(fluidPage(
#   
#   # App title
#   titlePanel("AmpliStat Software"),
#   
#   # Main panel with options
#   tabsetPanel(
#               tabPanel("Loading Data", import_data),
# 
#               tabPanel("Data Visualisation",
#                        tabPanel("Histogram")),
#               tabPanel("Boxplots"),
# 
#               tabPanel("Distribution Normality"),
#               tabPanel("Variance Homogenity"),
#               tabPanel("Outliers detection"),
# 
#               tabPanel("Parametric"),
#               tabPanel("Non-parametric"),
# 
#               tabPanel("Parametric"),
#               tabPanel("Non-parametric"),
# 
#               tabPanel("LOD"),
# 
#               tabPanel("Fluorescence plot"),
#               tabPanel("Labeling genotypes"),
#               tabPanel("Reference curve"))))

navbarPage("AmpliStat",
           tabPanel("Loading Data",
                    import_data),
           
           tabPanel("Data Visualisation",
                    tabsetPanel(
                                tabPanel("Histogram"),
                                tabPanel("Boxplot"))),
           
           tabPanel("Assumptions",
                    tabsetPanel(
                                tabPanel("Distribution Normality"),
                                tabPanel("Variance Homogenity"),
                                tabPanel("Outliers detection"))),
           
           tabPanel("Means Comparison",
                    tabsetPanel(
                                tabPanel("Parametric"),
                                tabPanel("Non-parametric"))),
           
           tabPanel("ANOVA",
                    tabsetPanel(
                                tabPanel("Parametric"),
                                tabPanel("Non-parametrix"))),
           
           tabPanel("Limit of Detection",
                    lod.plotting,
                    lod.msg),
           
           tabPanel("High Resolution Melt",
                    tabsetPanel(
                                tabPanel("Fluorescence plot",
                                         pcr.plotting),
                                tabPanel("Labeling genotypes"),
                                tabPanel("Difference plot")))
)