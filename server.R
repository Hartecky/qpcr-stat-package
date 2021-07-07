# AmpliStat Shiny App 
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.

library(shiny)

# Define server logic 
server <- function(input, output, session) {
    
    #options(shiny.maxRequestSize = 60 * 1024 ^ 2)
    data <- reactive({
        file1 <- input$file1
        if (is.null(file1)) {
            return()
        }
        data = read.csv(
            file = file1$datapath,
            header = input$header,
            sep = input$sep,
            dec = input$dec,
            stringsAsFactors = input$string
        )
    })
    
    output$contents <- renderDataTable({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, head of that data file by default,
        # or all rows if selected, will be shown.
        
        req(input$file1)
        
        if (input$disp == "head") {
            return(head(data()))
        }
        else {
            return(data())
        }
        
    })
    
    output$select.variable <- renderUI({
        selectInput('select.variable', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.assum <- renderUI({
        selectInput('select.variable.assum', 'Variable X', choices = names(data()))
    })
    
    output$base_plots_output <- renderPlot({
        req(input$select.variable)
        
        X <- data()[[input$select.variable]]
        hist(X)
    })
}
