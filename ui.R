# ------------------------------------------------------------------------------
# AMPLISTAT SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# USER INTERFACE COMPONENTS
# ------------------------------------------------------------------------------

# NECESSARY LIBRIARIES ---------------------------------------------------------
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
library(outliers)

# SET WORKING DIRECTORY --------------------------------------------------------
CURRENT.PATH <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(CURRENT.PATH)

# USER INTERFACE COMPONENTS ----------------------------------------------------
source('ui/data.upload.R')
source('ui/data.vis.R')
source('ui/assumptions.ui.R')
source('ui/mc.parametric.ui.R')
source('ui/mc.nonparametric.ui.R')
source('ui/aov.parametric.ui.R')
source('ui/aov.nonparametric.ui.R')
source('ui/lod.ui.R')
source('ui/hrm.ui.R')

# LOGS FILES
source('log_messages/log_messages.R')

# OPERATORS SOURCE FILES -----------------------------------------------------
source('operators/configure_lod_set.R')
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
    
    # DATA UPLOAD UI PANEL -----------------------------------------------------
    data.upload,
    
    # DATA VISUALISATION PANEL -------------------------------------------------
    data.vis,
    
    # ASSUMPTIONS TESTING PANEL ------------------------------------------------
    assumptions,
    
    # MEANS COMPARISON MENU ----------------------------------------------------
    navbarMenu('Means Comparison',
               
               # PARAMETRIC TESTS ----------------------------------------------
               mc.parametric,
               
               # NON-PARAMETRIC TESTS ------------------------------------------
               mc.nonparametric),
    
    # ANALYSIS OF VARIANCE PANEL -----------------------------------------------
    navbarMenu('ANOVA',
               
               # PARAMETRIC TESTS ----------------------------------------------
               aov.parametric,
               
               # NON-PARAMETRIC TESTS ------------------------------------------
               aov.nonparametric),
    
    # LIMIT OF DETECTION PANEL -------------------------------------------------
    lod.ui,
    
    # HIGH RESOLUTION MELT MENU ------------------------------------------------
    navbarMenu('HRM',
               
               # MELTING CURVES VISUALISATION ----------------------------------
               hrm.ui)
  )
)
