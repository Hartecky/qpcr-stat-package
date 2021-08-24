# ------------------------------------------------------------------------------
# qPCR SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# LOADING ADDITIONAL PACKAGES AND SCRIPT FILES
# ------------------------------------------------------------------------------

# Packages names
packages <- c("shiny",
              "plotly",
              "splines",
              "shinythemes",
              "shinyWidgets",
              "reshape2",
              "FSA",
              "rcompanion",
              "rsconnect",
              "shinydashboard",
              "outliers",
              "rsconnect")

# Additional source file names
additional.files <- c("ui/aov_nonparametric_ui.R",
                      "ui/aov_parametric_ui.R",
                      "ui/assumptions_ui.R",
                      "ui/data_upload_ui.R",
                      "ui/data_vis_ui.R",
                      "ui/hrm_ui.R",
                      "ui/lod_ui.R",
                      "ui/mc_nonparametric_ui.R",
                      "ui/mc_parametric_ui.R",
                      
                      "log_messages/log_messages.R",
                      
                      "operators/configure_lod_set.R",
                      "operators/preprocessing_lod_data.R",
                      "operators/melt_data.R",
                      "operators/diff_curve_calc.R",
                      "operators/assumptions.R",
                      "operators/anova_tests.R",
                      "operators/means_comparison_tests.R",
                      
                      "plots/base_plot.R",
                      "plots/fluorescence_plot.R",
                      "plots/generate_lod_plot.R",
                      
                      "condition_validation.R")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# Source files loading
invisible(lapply(additional.files, source))
