#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic 
shinyServer(function(input, output) {

    # STATISTICS ANALYSIS ----------------------------------------------------

    data <- reactive({
        file1 <- input$file1
        if (is.null(file1)) {
            return()
        }
        data = read.table(
            file = file1$datapath,
            header = input$header,
            sep = input$sep,
            dec = input$dec,
            stringsAsFactors = input$string
        )
    })
    
    
    lod.data <- reactive({
        req(input$file1)
        lod.matrix <- data()

        if(dim(lod.matrix)[1]==3 & dim(lod.matrix)[2]==3) {
            Y = define.freq(lod.matrix)
            model.glm <- fit.model(Y, lod.matrix)

            level = logit.value(0.95)
            X.LOD <- LOD(model.glm, level)
            log.SE.LOD <- se.computations(model.glm, X.LOD)

            plot.labs <- prepare.set(model.glm, X.LOD, level)
            pred.data <- plot.labs$pred.df
            top.interval <- plot.labs$top.interval
            bottom.interval <- plot.labs$bottom.interval

            lod.data = list(
                pred.data = pred.data,
                top.interval = top.interval,
                bottom.interval = bottom.interval,
                x.lod = X.LOD,
                significance = 0.95,
                logit.value = level,
                se.lod = log.SE.LOD
            )
            
        } else {
            return()
        }
    })
    output$contents <- renderDataTable({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, head of that data file by default,
        # or all rows if selected, will be shown.
        req(input$file1)

        head(data())
    })

    output$stats <- renderPrint({
        req(input$file1)

        summary(data())
    })
    
    # LOD ANALYSIS ------------------------------------------------------------
    
    # Load data and perform LOD calculations
    # then return plot with calculated LOD value
    output$lod.plot <- renderPlotly({
        req(input$file1, lod.data())

        lod.plot(data = data(),
                 pred.data = lod.data()$pred.data, 
                 top.interval = lod.data()$top.interval, 
                 bottom.interval = lod.data()$bottom.interval, 
                 X.LOD = lod.data()$x.lod)
 
    })
    
    output$lod.stats <- renderPrint({
        req(input$file1, lod.data())
        
        data.frame(significance = lod.data()$significance,
                   logit.value = lod.data()$logit.value,
                   lod.value = lod.data()$x.lod,
                   se.lod.value = lod.data()$se.lod)
    })
})

