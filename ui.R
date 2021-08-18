# ------------------------------------------------------------------------------
# AMPLISTAT SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# USER INTERFACE COMPONENTS
# ------------------------------------------------------------------------------

# SET WORKING DIRECTORY --------------------------------------------------------
CURRENT.PATH <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(CURRENT.PATH)

# NECESSARY LIBRIARIES ---------------------------------------------------------
source('packages.R')

# USER INTERFACE COMPONENTS ----------------------------------------------------
source('ui/aov_nonparametric_ui.R')
source('ui/aov_parametric_ui.R')
source('ui/assumptions_ui.R')
source('ui/data_upload_ui.R')
source('ui/data_vis_ui.R')
source('ui/hrm_ui.R')
source('ui/lod_ui.R')
source('ui/mc_nonparametric_ui.R')
source('ui/mc_parametric_ui.R')

# LOGS FILES
source('log_messages/log_messages.R')

# OPERATORS SOURCE FILES -----------------------------------------------------
source('operators/configure_lod_set.R')
source('operators/preprocessing_lod_data.R')
source('operators/melt_data.R')
source('operators/diff_curve_calc.R')
source('operators/assumptions.R')
source('operators/anova_tests.R')
source('operators/means_comparison_tests.R')

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
