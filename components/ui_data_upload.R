import_data <- sidebarLayout(
  sidebarPanel(
    fileInput(
      "file1",
      "Choose CSV File",
      multiple = TRUE,
      accept = c("text/csv",
                 "text/comma-separated-values,text/plain",
                 ".csv")
    ),
    
    
    checkboxInput("header", "Header", TRUE),
    
    
    selectInput(
      "sep",
      "Separator",
      choices = c(
        Comma = ",",
        Semicolon = ";",
        Tab = "\t"
      ),
      selected = ","
    ),
    radioButtons(
      "dec",
      "Decimal",
      choices = c(Dot = '.',
                  Comma = ","),
      selected = '.'
    ),
    tags$hr(),
    checkboxInput('string', "Strings as factor", TRUE),
    
    tags$hr(),
    
    submitButton("Update view", icon("bar-chart-o"))
  ),
  
  mainPanel(dataTableOutput("contents"),
            verbatimTextOutput("stats"))
)
