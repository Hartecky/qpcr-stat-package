# qPCR Shiny App
# Data upload UI components

data.upload <- tabPanel(
  strong('Data Upload'),
  titlePanel('Uploading Files'),
  tags$hr(),
  
  # Side Panel Menu with options
  sidebarLayout(
    sidebarPanel(
      
      # Loading data from file
      fileInput(
        'file1',
        'Choose CSV file',
        multiple = T,
        accept = c("text/csv",
                   "text/comma-separated-values,text/plain",
                   ".csv")
      ),
      
      # Header declaration
      checkboxInput("header", "Header", TRUE),
      
      # Observations separator
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
      
      # Decimal separator
      selectInput(
        "dec",
        "Decimal",
        choices = c(Dot = '.', Comma = ","),
        selected = '.'
      ),
      
      # String as factor declaration
      tags$hr(),
      checkboxInput('string', "Strings as factor", TRUE),
      tags$hr(),
      
      # Output view option
      selectInput(
        "disp",
        "Display",
        choices = c(Head = "head",
                    All = "all"),
        selected = "head"
      ),
      submitButton("Update view", icon("refresh"))
    ),
    
    # Main panel, where uploaded data are shown in a DataTable
    mainPanel(
      dataTableOutput("contents"),
      verbatimTextOutput('contents.stats'),
      width = 8
    )
  )
)