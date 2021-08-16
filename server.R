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
        } else {
            data = read.csv(
                file = file1$datapath,
                header = input$header,
                sep = input$sep,
                dec = input$dec,
                stringsAsFactors = input$string
            )
        }
    })
    
    # RENDER DATATABLE FOR GIVEN DATA ------------------------------------------
    output$contents <- renderDataTable({
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
    
    # FLUORESCENCE PLOT -----------------------
    output$ref.curve <- renderUI({
        selectInput('ref.curve', 'Reference curve', choices = c(2:ncol(data())-1))
    })

    # BASE PLOTS ---------------------------------------------------------------
    output$base_plots_output <- renderPlotly({
        
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
    
    # ASSUMPTION MESSAGES ------------------------------------------------------
    output$assumptions_messages <- renderPrint({

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
        
        # TODO
        # if option is norm and var test, then decision making logs
        decision.making.messages(option)
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

        req(input$file1)
        lod.matrix <- data()

        lod.error.message(lod.matrix)

        lod <- lod.operations(lod.matrix)
        
        plot.labs <- prepare.set(lod$model.glm,
                                 lod$X.LOD,
                                 lod$level)
        
        pred.data <- plot.labs$pred.df
        top.interval <- plot.labs$top.interval
        bottom.interval <- plot.labs$bottom.interval

        lod.data = list(
            pred.data = pred.data,
            top.interval = top.interval,
            bottom.interval = bottom.interval,
            x.lod = lod$X.LOD,
            significance = 0.95,
            logit.value = lod$level,
            se.lod = lod$log.SE.LOD
        )
    })
    
    # LIMIT OD DETECTION PLOT --------------------------------------------------
    output$lod_plots_output <- renderPlotly({

        req(input$file1, lod.data())

        lod.plot(data = data(),
                 pred.data = lod.data()$pred.data, 
                 top.interval = lod.data()$top.interval, 
                 bottom.interval = lod.data()$bottom.interval, 
                 X.LOD = lod.data()$x.lod)
    })
    
    # LIMIT OF DETECTION STATISTICS --------------------------------------------
    output$lod_stats_output <- renderPrint({
        
        req(input$file1, lod.data())
        
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
            fluorescence.error.message(data())
        }
    })
    
    diff.data <- reactive({
        req(input$file1,
            input$ref.curve)
        
        diff.tmp <- data()

        if(colnames(diff.tmp)[1]=="Temperature"){
            new.data <- diff.calc(diff.tmp, as.integer(input$ref.curve))
            melt.data <- melting.data(dataframe = new.data, 
                                      id_variables = "Temperature")
        }
    })
    
    output$qpcr_plot_output <- renderPlotly({
        req(input$file1)
        fluorescence.plot(pcr.data())
    })
    
    output$qpcr_diff_output <- renderPlotly({
        req(input$file1,
            input$ref.curve)
        
        fluorescence.plot(diff.data())
    })
    
}
