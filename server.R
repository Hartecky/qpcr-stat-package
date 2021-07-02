# AmpliStat Shiny App 
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.


library(shiny)

# Define server logic 
shinyServer(function(input, output) {

    # Loading data into application --------------------------------------------

    data <- reactive({ file1 <- input$file1
    
    if (is.null(file1)) {
        return()
        }
    
    data = read.table(file = file1$datapath,
                      header = input$header,
                      sep = input$sep,
                      dec = input$dec,
                      stringsAsFactors = input$string)
    })
    
    # Processing data for LOD calculation --------------------------------------
    lod.data <- reactive({
        
        # Require provided input file with data
        req(input$file1)
        lod.matrix <- data()

        # Check the dimension of the provided data
        if(dim(lod.matrix)[1]==3 & dim(lod.matrix)[2]==3) {
            
            Y = define.freq(lod.matrix)
            
            # Prepare logistic model
            model.glm <- fit.model(Y, 
                                   lod.matrix)
            
            # Calculate predictions at 95% significance level
            level = logit.value(0.95)
            
            X.LOD <- LOD(model.glm, 
                         level)
            
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
                stop("Data provided for LOD calculation is incorrect. Exit code with status 1")
            }
        })
    
    # Render overview of the data ----------------------------------------------
    output$contents <- renderDataTable({
        
        # Require provided input file with data
        req(input$file1)
        
        # Return overview of the data with head
        head(data())
    })
    
    # Render summary statistics of the provided data ---------------------------
    output$stats <- renderPrint({
        
        # Require provided input file with data
        req(input$file1)
        
        # Return summary statistics in a verbatim text output
        summary(data())
    })
    
    # Limit of detection plot --------------------------------------------------
    output$lod.plot <- renderPlotly({
        
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
    
    # Print Limit of detection summary statistics ------------------------------
    output$lod.stats <- renderPrint({
        
        # Require provided input file with data
        req(input$file1, lod.data())
        
        # Return a dataframe with calculated values
        data.frame(significance = lod.data()$significance,
                   logit.value = lod.data()$logit.value,
                   lod.value = lod.data()$x.lod,
                   se.lod.value = lod.data()$se.lod)
    })
    
    # Print message about performed analysis -----------------------------------
    output$lod.msg <- renderPrint({

        req(input$file1, lod.data())

        return("Data provided for LOD calculation is correct. Exit code with status 0")
    })
    
    # FLUORESCENCE
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
    
    output$pcr.plot <- renderPlotly({
        # Require provided input file with data
        req(input$file1)
        
        # Return overview of the data with head
        fluorescence.plot(pcr.data())
    })
    
})

