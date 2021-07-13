packages <- c("shiny",
              "ggplot2",
              "plotly",
              "shinythemes",
              "shinyWidgets",
              "outliers",
              "reshape2")

installed_packages <- packages %in% rownames(installed.packages())

if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

invisible(lapply(packages, library, character.only = TRUE))
