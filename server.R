# ------------------------------------------------------------------------------
# AMPLISTAT SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# SERVER FUNCTIONALITY
# ------------------------------------------------------------------------------

# SERVER LOGIC DEFINITION ------------------------------------------------------
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
    
    # RENDER DATATABLE FOR GIVEN DATA ------------------------------------------
    output$contents <- renderDataTable({
        # Require input file
        req(input$file1)
        
        if (input$disp == "head") {
            return(head(data()))
        }
        else {
            return(data())
        }
    })
    
    # RENDER DATA SUMMARY ------------------------------------------------------
    output$contents.stats <- renderPrint({
        # Require input file
        req(input$file1)
        
        summary(data())
    })
    
    # IMPORT VARIABLE NAMES INTO SELECT INPUTS ---------------------------------
    # DATA VISUALISATION ---------------------
    output$select.variable <- renderUI({
        selectInput('select.variable', 'Variable X', choices = names(data()))
    })
    
    # ASSUMPTIONS TESTING --------------------
    output$select.variable.assum1 <- renderUI({
        selectInput('select.variable.assum1', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.assum2 <- renderUI({
        selectInput('select.variable.assum2', 'Variable Y', choices = names(data()))
    })
    
    # MEANS COMPARISON ----------------------
    output$select.variable.mcp1 <- renderUI({
        selectInput('select.variable.mcp1', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.mcp2 <- renderUI({
        selectInput('select.variable.mcp2', 'Variable Y', choices = names(data()))
    })
    
    output$select.variable.mcnp1 <- renderUI({
        selectInput('select.variable.mcnp1', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.mcnp2 <- renderUI({
        selectInput('select.variable.mcnp2', 'Variable Y', choices = names(data()))
    })
    
    # ANOVA ----------------------------------
    output$select.variable.aovp1 <- renderUI({
        selectInput('select.variable.aovp1', 'Variable X1', choices = names(data()))
    })
    
    output$select.variable.aovp2 <- renderUI({
        selectInput('select.variable.aovp2', 'Variable X2', choices = names(data()))
    })
    
    output$select.variable.aovp3 <- renderUI({
        selectInput('select.variable.aovp3', 'Variable Y', choices = names(data()))
    })
    
    output$select.variable.aovnp1 <- renderUI({
        selectInput('select.variable.aovnp1', 'Variable X', choices = names(data()))
    })
    
    output$select.variable.aovnp2 <- renderUI({
        selectInput('select.variable.aovnp2', 'Variable Y', choices = names(data()))
    })

    # BASE PLOTS ---------------------------------------------------------------
    output$base_plots_output <- renderPlotly({
        
        # Require selected input and specified plot type
        req(input$select.variable, input$plot.type)
        
        X <- data()[[input$select.variable]]
        variable <- input$select.variable
        option <- input$plot.type
        
        # Render slider input if chosen plot type is histogram
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
        
        # Generating plots
        generate.plot(X, variable, option, input$bins)
        })
    
    # ASSUMPTION MESSAGES ------------------------------------------------------
    output$assumptions_messages <- renderPrint({
        # Require option and variables
        req(input$check.assumps, 
            input$select.variable.assum1)
        
        var <- input$select.variable.assum1
        option <- input$check.assumps
        assumptions.messages(option, var)
    })
    
    # ASSUMPTIONS TESTING ------------------------------------------------------
    output$assumptions_output <- renderPrint({
        req(input$select.variable.assum1, 
            input$select.variable.assum2,
            input$check.assumps)
        
        option <- input$check.assumps
        X <- data()[[input$select.variable.assum1]]
        Y <- data()[[input$select.variable.assum2]]
        
        assumptions.testing(X,Y, option)
    })
    
    # ASSUMPS TESTS P-VALUE INTERPRET MESSAGE ----------------------------------
    output$assumptions_interpret <- renderPrint({
        req(input$select.variable.assum1,
            input$select.variable.assum2,
            input$check.assumps)
        
        option <- input$check.assumps
        
        if (option == 'normtest' || option == 'vartest'){
            cat("Decision making:,
        
        p < 0.05 - Reject H0
        p > 0.05 - Fail to reject H0")
        } else {
            return()
        }  
    }) 
    
    # PARAMETRIC MEANS COMPARISON ----------------------------------------------
    output$means_param_output <- renderPrint({
        req(input$t.test.type,
            input$select.variable.mcp1,
            input$select.variable.mcp2,
            input$mu,
            input$par_ttest,
            input$alternative_ttest_p,
            input$alpha_testt)

        X <- data()[[input$select.variable.mcp1]]
        Y <- data()[[input$select.variable.mcp2]]

        
        if (input$t.test.type == 'onesample') {
            t.test(X, 
                   mu = input$mu, 
                   conf.level = input$alpha_testt)
        } else if (input$t.test.type == 'twosamples') {
            if (input$par_ttest == 'Paired') {
                t.test(x = X,
                       y = Y,
                       alternative = input$alternative_ttest_p,
                       paired = TRUE,
                       conf.level = input$alpha_testt
                       )
            } else {
                t.test(x = X,
                       y = Y,
                       alternative = input$alternative_ttest_p,
                       paired = FALSE,
                       conf.level = input$alpha_testt
                )
            }
        }
    })
    
    
    # NON-PARAMETRIC MEANS COMPARISON ------------------------------------------
    output$means_nonparam_output <- renderPrint({
        req(input$mcnp.test.type,
            input$select.variable.mcnp1,
            input$select.variable.mcnp2,
            input$mu_np,
            input$par_wilcox,
            input$alternative_wilcox,
            input$alpha_wilcox)
        
        option <- input$mcnp.test.type
        alt <- input$alternative_wilcox
        alpha <- input$alpha_wilcox
        mu <- input$alpha_wilcox
        pair <- input$par_wilcox
        
        X <- data()[[input$select.variable.mcnp1]]
        Y <- data()[[input$select.variable.mcnp2]]
        
        if (option == 'onesample'){
            wilcox.test(x = X, 
                        y = NULL, 
                        alternative = alt, 
                        mu = mu, 
                        paired = F, 
                        conf.level = alpha)
        } else if (option == 'twosamples') {
            if (pair == 'Paired'){
                wilcox.test(x = X, 
                            y = Y, 
                            alternative = alt, 
                            paired = T, 
                            conf.level = alpha)
            } else if (option == 'Non-paired') {
                wilcox.test(x = X, 
                            y = Y, 
                            alternative = alt, 
                            paired = F, 
                            conf.level = alpha)
            }
        }
        
    })
    
    # PARAMETRIC ANALYSIS OF VARIANCE ------------------------------------------
    output$anova_param_output <- renderPrint({
        req(input$select.variable.aovp1,
            input$select.variable.aovp2,
            input$select.variable.aovp3)

        
        X1 <- data()[[input$select.variable.aovp1]]
        X2 <- data()[[input$select.variable.aovp2]]
        Y <- data()[[input$select.variable.aovp3]]
        option <- input$aovp.test.type
        
        if (option == 'onesample') {
            stopifnot(is.factor(X1))
            
            aov.model <- analysis.of.variance(Y, X1, data())
            
            fit <- aov.model$fitted.model
            model <- aov.model$model
            
            print(aov.model)
            cat('---------------------------------------------\n')
            analysis.posthoc(model, fit) 
        } else if (option == 'twosamples') {
            stopifnot(is.factor(X1),
                      is.factor(X2))
            
            aov.model <- analysis.of.variance.two(Y, X1, X2, data())
            
            fit <- aov.model$fitted.model
            model <- aov.model$model
            
            print(aov.model)
            cat('---------------------------------------------\n')
            analysis.posthoc(model, fit)
        }
    })
    
    # NON-PARAMETRIC ANALYSIS OF VARIANCE --------------------------------------
    output$anova_nonparam_output <- renderPrint({
        req(input$select.variable.aovnp1,
            input$select.variable.aovnp2)
        
        
        X <- data()[[input$select.variable.aovnp1]]
        Y <- data()[[input$select.variable.aovnp2]]
        
        stopifnot(is.factor(X))
        
        model <- kruskal.analysis(Y, X, data())
        cat('---------------------------------------------\n')
        kruskal.posthoc(Y, X, model, data())
        
    })
    # LIMIT OF DETECTION CALCULATION -------------------------------------------
    lod.data <- reactive({

        # Require provided input file with data
        req(input$file1)
        lod.matrix <- data()

        # Check the dimension of the provided data
        names.list <- c('dilution', 'total', 'positive')
        if (names(lod.matrix) == names.list){
            if(dim(lod.matrix)[1]==3 & dim(lod.matrix)[2]==3) {
                
                lod <- lod.operations(lod.matrix)
                
                plot.labs <- prepare.set(lod$model.glm,
                                         lod$X.LOD,
                                         lod$level)

                pred.data <- plot.labs$pred.df
                top.interval <- plot.labs$top.interval
                bottom.interval <- plot.labs$bottom.interval

                # Return calculation results into DataFrame
                lod.data = list(pred.data = pred.data,
                                top.interval = top.interval,
                                bottom.interval = bottom.interval,
                                x.lod = lod$X.LOD,
                                significance = 0.95,
                                logit.value = lod$level,
                                se.lod = lod$log.SE.LOD)
            } else {
            stop('Data provided for LOD calculation is incorrect. 
                Exit code with status 1. 
                
                Provided data is not a 3x3 matrix')}
            } else { 
            stop('Data provided for LOD calculation is incorrect. 
                 Exit code with status 1.
                 
                 Provided data does not have proper column names
                 (dilution, total, positive)')}
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
