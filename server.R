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
    
    # RENDER DATATABLE AND SUMMARY STATISTICS FOR GIVEN DATA -------------------
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
        
        # Require selected input and specified plot type
        req(input$select.variable, input$plot.type)
        
        X <- data()[[input$select.variable]]
        variable <- input$select.variable
        option <- input$plot.type
        
        if (option == 'histogram'){
            output$hist.slider <- renderUI({
                sliderInput("bins",
                            "Number of bins:",
                            min = 1,
                            max = 50,
                            value = 30, 
                            width = '100%')
                
            })
        } else if (option != 'histogram'){
                output$hist.slider <- renderUI({ })
            }
        
        generate.plot(X, variable, option, input$bins)
        })
    
    # LIMIT OF DETECTION CALCULATION -------------------------------------------
    lod.data <- reactive({

        # Require provided input file with data
        req(input$file1)
        lod.matrix <- data()

        # Check the dimension of the provided data
        if(dim(lod.matrix)[1]==3 & dim(lod.matrix)[2]==3) {

            # Calculate differences between total and positives samples
            Y = define.freq(lod.matrix)

            # Prepare logistic model
            model.glm <- fit.model(Y, lod.matrix)

            # Predict values at 95% significance level
            level = logit.value(0.95)

            X.LOD <- LOD(model.glm, level)

            log.SE.LOD <- se.computations(model.glm,
                                          X.LOD)

            plot.labs <- prepare.set(model.glm,
                                     X.LOD,
                                     level)
            
            pred.data <- plot.labs$pred.df
            top.interval <- plot.labs$top.interval
            bottom.interval <- plot.labs$bottom.interval

            # Return calculation results into DataFrame
            lod.data = list(pred.data = pred.data,
                            top.interval = top.interval,
                            bottom.interval = bottom.interval,
                            x.lod = X.LOD,
                            significance = 0.95,
                            logit.value = level,
                            se.lod = log.SE.LOD)
        } else {
            # If data is not a 3x3 matrix with specified column
            # names, then stop running this function and return
            # warning info
            stop("Data provided for LOD calculation is incorrect. Exit code with status 1.
            
                 Example data for LOD calculation:
                 
                 dilution;total;positive
                 6;8;4
                 12;8;8
                 24;8;8")
        }
    })
    
    # LIMIT OD DETECTION PLOT --------------------------------------------------
    output$lod_plots_output <- renderPlotly({
        
        # Require provided input file with data, and also
        # require calculated coefficients from LOD calculations
        req(input$file1, lod.data())
        
        # Return Limit of Detection interactive plot with pointed values
        lod.plot(data = data(),
                 pred.data = lod.data()$pred.data, 
                 top.interval = lod.data()$top.interval, 
                 bottom.interval = lod.data()$bottom.interval, 
                 X.LOD = lod.data()$x.lod)
    })
    
    # LIMIT OF DETECTION STATISTICS --------------------------------------------
    output$lod_stats_output <- renderPrint({
        
        # Require provided input file with data
        req(input$file1, lod.data())
        
        # Return a dataframe with calculated values
        data.frame(significance = lod.data()$significance,
                   logit.value = lod.data()$logit.value,
                   lod.value = lod.data()$x.lod,
                   se.lod.value = lod.data()$se.lod)
    })
    
    # FLUORESCENCE DATA PREPARATION --------------------------------------------
    pcr.data <- reactive({
        
        req(input$file1)
        
        pcr.tmp <- data()
        
        if(colnames(pcr.tmp)[1]=="Temperature"){
            pcr.melt = melting.data(dataframe = pcr.tmp, id_variables = "Temperature")
        } else {
            stop("
                 Data provided for qPCR fluorescence visualisation is incorrect. Exit code with status 1.
                 Common problems:
                 - First column is not the 'Temperature' column;
                 - incorrect separators for values or digits;
                 - undeclared header;
                 - wrong first column name
                 
                 Example of the correct data:
                 
                 Temperature; 1; 2; 3
                 79,99; 89,38; 89,39; 89,54
                 80,00; 89,34; 89,35; 89,50
                 80,01; 89,30; 89,31; 89,46
                 80,02; 89,25; 89,27; 89,42
                 ")
        }
    })
    
    output$qpcr_plot_output <- renderPlotly({
        # Require provided input file with data
        req(input$file1)
        
        # Return overview of the data with head
        fluorescence.plot(pcr.data())
    })
}
