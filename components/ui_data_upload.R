library(shiny)

import_data <- sidebarLayout(
  
  # Layout for sidebar data upload options ---------------------------------------
  sidebarPanel(
    
    # File input widget
    fileInput("file1",
              "Choose CSV File",
              multiple = TRUE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
    
    # Checkbox to include header or not
    checkboxInput("header",
                  "Header", 
                  TRUE),
    
    # Variables separator input
    selectInput("sep",
                "Separator",
                choices = c(Comma = ",",
                            Semicolon = ";",
                            Tab = "\t"),
                selected = ","),
    
    # Digits separator input
    selectInput("dec",
                "Decimal",
                choices = c(Dot = '.',
                            Comma = ","),
                selected = '.'),
    
    # Specicify if strings in data are factors
    tags$hr(),
    checkboxInput('string', 
                  "Strings as factor", 
                  TRUE),
    
    # Update data button
    tags$hr(),
    submitButton("Update view", 
                 icon("bar-chart-o"))
  ),
  # Layout for mainpanel outputs -----------------------------------------------
  mainPanel(dataTableOutput("contents"),
            verbatimTextOutput("stats"))
)
