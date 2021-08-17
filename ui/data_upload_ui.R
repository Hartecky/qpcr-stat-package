data.upload <- tabPanel(
  strong('Data Upload'),
  titlePanel('Uploading Files'),
  tags$hr(),
  
  sidebarLayout(
    sidebarPanel(
      fileInput(
        'file1',
        'Choose CSV file',
        multiple = T,
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
      selectInput(
        "dec",
        "Decimal",
        choices = c(Dot = '.', Comma = ","),
        selected = '.'
      ),
      tags$hr(),
      checkboxInput('string', "Strings as factor", TRUE),
      tags$hr(),
      
      selectInput(
        "disp",
        "Display",
        choices = c(Head = "head",
                    All = "all"),
        selected = "head"
      ),
      submitButton("Update view", icon("refresh"))
    ),
    
    mainPanel(
      dataTableOutput("contents"),
      verbatimTextOutput('contents.stats'),
      width = 8
    )
  )
)