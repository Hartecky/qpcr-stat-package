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
              "outliers")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))
