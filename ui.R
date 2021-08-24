# ------------------------------------------------------------------------------
# qPCR SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# USER INTERFACE COMPONENTS
# ------------------------------------------------------------------------------

# SET WORKING DIRECTORY --------------------------------------------------------
CURRENT.PATH <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(CURRENT.PATH)

# NECESSARY LIBRIARIES ---------------------------------------------------------
source('packages.R')

# UI FOR WHOLE APPLICATION -----------------------------------------------------
ui <- fluidPage(
  theme = shinytheme("darkly"),
  navbarPage(
    'qPCR Stat',
    
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
