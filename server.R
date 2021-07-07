# AmpliStat Shiny App 
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.

library(shiny)

# Define server logic 
server <- function(input, output, session) {
    
    # UPLOAD DATA INTO SHINY APPLICATION ---------------------------------------
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
        req(input$file1)
        
        if (input$disp == "head") {
            return(head(data()))
        }
        else {
            return(data())
        }
        
    })
    
    output$contents.stats <- renderPrint({
        req(input$file1)
        
        summary(data())
    })
    
    # IMPORT VARIABLE NAMES INTO SELECT INPUTS ---------------------------------
    output$select.variable <- renderUI({
        selectInput('select.variable', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.assum <- renderUI({
        selectInput('select.variable.assum', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.assum <- renderUI({
        selectInput('select.variable.assum', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.mcp <- renderUI({
        selectInput('select.variable.mcp', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.mcnp <- renderUI({
        selectInput('select.variable.mcnp', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.aovp <- renderUI({
        selectInput('select.variable.mcnp', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.aovnp <- renderUI({
        selectInput('select.variable.mcnp', 'Variable X', choices = names(data()))
    })
    
    # PLOTS --------------------------------------------------------------------
    output$base_plots_output <- renderPlotly({
        req(input$select.variable, input$plot.type)
        
        X <- data()[[input$select.variable]]
        variable <- input$select.variable
        option <- input$plot.type
        
        generate.plot(X, variable, option)
    })
}
