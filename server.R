# ------------------------------------------------------------------------------
# qPCR SHINY APP
# DASHBOARD FOR STATISTICAL ANALYSIS OF QPCR DATA
# SERVER FUNCTIONALITY
# ------------------------------------------------------------------------------

# SERVER LOGIC DEFINITION ------------------------------------------------------
server <- function(input, output, session) {
    
    # UPLOAD DATA INTO SHINY APPLICATION ---------------------------------------
    
    # Reactive uploaded dataframe into app, which can be used by other functions
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
    # Render whole dataset table or head. 
    # Dependent on input$disp variable
    
    output$contents <- renderDataTable({
        
        # requirements from app
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
        
        # requirements from app
        req(input$file1)
        
        # view data summary
        summary(data())
    })
    
    # IMPORT VARIABLE NAMES INTO SELECT INPUTS ---------------------------------
    
    # DATA VISUALISATION  PANEL 
    output$select.variable <- renderUI({
        selectInput('select.variable', 'Variable X', choices = names(data()))
    })
    
    # ASSUMPTIONS TESTING PANEL
    # VARIABLE X
    output$select.variable.assum1 <- renderUI({
        selectInput('select.variable.assum1', 'Variable X', choices = names(data()))
    })
    
    # VARIABLE Y
    output$select.variable.assum2 <- renderUI({
        selectInput('select.variable.assum2', 'Variable Y', choices = names(data()))
    })
    
    # MEANS COMPARISON PARAMETRIC PANEL
    # VARIABLE X
    output$select.variable.mcp1 <- renderUI({
        selectInput('select.variable.mcp1', 'Variable X', choices = names(data()))
    })
    
    # VARIABLE Y
    output$select.variable.mcp2 <- renderUI({
        selectInput('select.variable.mcp2', 'Variable Y', choices = names(data()))
    })
    
    # MEANS COMPARISON NONPARAMETRIC PANEL
    # VARIABLE X
    output$select.variable.mcnp1 <- renderUI({
        selectInput('select.variable.mcnp1', 'Variable X', choices = names(data()))
    })
    
    # VARIABLE Y
    output$select.variable.mcnp2 <- renderUI({
        selectInput('select.variable.mcnp2', 'Variable Y', choices = names(data()))
    })
    
    # ANALYSIS OF VARIANCE PARAMETRIC PANEL
    # VARIABLE X1
    output$select.variable.aovp1 <- renderUI({
        selectInput('select.variable.aovp1', 'Variable X1', choices = names(data()))
    })
    
    # VARIABLE X2
    output$select.variable.aovp2 <- renderUI({
        selectInput('select.variable.aovp2', 'Variable X2', choices = names(data()))
    })
    
    # VARIABLE Y
    output$select.variable.aovp3 <- renderUI({
        selectInput('select.variable.aovp3', 'Variable Y', choices = names(data()))
    })
    
    # ANALYSIS OF VARIANCE NONPARAMETRIC PANEL
    # VARIABLE X
    output$select.variable.aovnp1 <- renderUI({
        selectInput('select.variable.aovnp1', 'Variable X', choices = names(data()))
    })
    
    # VARIABLE Y
    output$select.variable.aovnp2 <- renderUI({
        selectInput('select.variable.aovnp2', 'Variable Y', choices = names(data()))
    })
    
    # SELECTION OF THE REFERENCE CURVE
    output$ref.curve <- renderUI({
        selectInput('ref.curve', 'Reference curve', choices = c(2:length(data())-1))
    })

    # BASE PLOTS ---------------------------------------------------------------
    output$base_plots_output <- renderPlotly({
        
        # requirements from app
        req(input$select.variable, 
            input$plot.type)
        
        X <- data()[[input$select.variable]]
        variable <- input$select.variable
        option <- input$plot.type
        
        # Render bins slider for histogram plot
        if (option == 'histogram'){
            output$hist.slider <- renderUI({
                sliderInput("bins",
                            "Number of bins:",
                            min = 1,
                            max = 50,
                            value = 30, 
                            width = '100%')
                
            })
        # Render nothing for other options
        } else if (option != 'histogram'){
                output$hist.slider <- renderUI({ })
            }
        
        # wrapped plotting function
        generate.plot(X, variable, option, input$bins)
        
        })
    
    # ASSUMPTION MESSAGES ------------------------------------------------------
    output$assumptions_messages <- renderPrint({
        
        # requirements from app
        req(input$check.assumps, 
            input$select.variable.assum1)
        
        var <- input$select.variable.assum1
        option <- input$check.assumps
        
        # wrapped helpers function
        assumptions.messages(option, var)
    })
    
    # ASSUMPTIONS TESTING ------------------------------------------------------
    output$assumptions_output <- renderPrint({
        
        # requirements from app
        req(input$select.variable.assum1, 
            input$select.variable.assum2,
            input$check.assumps)
        
        option <- input$check.assumps
        X <- data()[[input$select.variable.assum1]]
        Y <- data()[[input$select.variable.assum2]]
        
        # wrapped assumption testing function
        assumptions.testing(X,Y, option)
    })
    
    # ASSUMPS TESTS P-VALUE INTERPRET MESSAGE ----------------------------------
    output$assumptions_interpret <- renderPrint({
        
        # requirements from app
        req(input$select.variable.assum1,
            input$select.variable.assum2,
            input$check.assumps)
        
        option <- input$check.assumps
        
        # wrapped helpers function
        decision.making.messages(option)
    }) 
    
    # PARAMETRIC MEANS COMPARISON ----------------------------------------------
    output$means_param_output <- renderPrint({
        
        # requirements from app
        req(input$t.test.type,
            input$select.variable.mcp1,
            input$select.variable.mcp2,
            input$mu,
            input$par_ttest,
            input$alternative_ttest_p,
            input$alpha_testt)

        X <- data()[[input$select.variable.mcp1]]
        Y <- data()[[input$select.variable.mcp2]]

        # wrapped parametric means comparison function
        compare.means.param(test.type = input$t.test.type,
                            X = X,
                            Y = Y,
                            mu = input$mu,
                            alternative = input$alternative_ttest_p,
                            paired = input$par_ttest,
                            confidence = input$alpha_testt)
    })
    
    
    # NON-PARAMETRIC MEANS COMPARISON ------------------------------------------
    output$means_nonparam_output <- renderPrint({
        
        # requirements from app
        req(input$mcnp.test.type,
            input$select.variable.mcnp1,
            input$select.variable.mcnp2,
            input$mu_np,
            input$par_wilcox,
            input$alternative_wilcox,
            input$alpha_wilcox)

        X <- data()[[input$select.variable.mcnp1]]
        Y <- data()[[input$select.variable.mcnp2]]
        
        # wrapped nonparametric means comparison function
        compare.means.nonparam(test.type = input$mcnp.test.type,
                               X = X,
                               Y = Y,
                               mu = input$mu_np,
                               alternative = input$alternative_wilcox,
                               paired = input$par_wilcox,
                               confidence = input$alpha_wilcox)
    })
    
    # PARAMETRIC ANALYSIS OF VARIANCE ------------------------------------------
    output$anova_param_output <- renderPrint({
        
        # requirements from app
        req(input$select.variable.aovp1,
            input$select.variable.aovp2,
            input$select.variable.aovp3)

        X1 <- data()[[input$select.variable.aovp1]]
        X2 <- data()[[input$select.variable.aovp2]]
        Y <- data()[[input$select.variable.aovp3]]
        option <- input$aovp.test.type
        
        # wrapped parametric anova function
        anova.test.param(input$aovp.test.type, Y, X1, X2, data())
    })
    
    # NON-PARAMETRIC ANALYSIS OF VARIANCE --------------------------------------
    output$anova_nonparam_output <- renderPrint({
        
        # requirements from app
        req(input$select.variable.aovnp1,
            input$select.variable.aovnp2)
        
        
        X <- data()[[input$select.variable.aovnp1]]
        Y <- data()[[input$select.variable.aovnp2]]
        
        # wrapped nonparametric anova function
        anova.test.nonparam(Y, X, data())
    })
    # LIMIT OF DETECTION CALCULATION -------------------------------------------
    
    # Reactive data for Limit of Detection calculation
    # This reactive contains whole dataset and additionals preparation
    lod.data <- reactive({
        
        # requirements from app
        req(input$file1)
        
        # call uploaded dataset from app
        lod.matrix <- data()
        
        # check dataset for errors
        lod.error.message(lod.matrix)
        
        # prepare dataset from lod.matrix matrix
        lod <- lod.operations(lod.matrix)
        
        # prepare lod set and labs for ggplot visualisation
        plot.labs <- prepare.set(lod$model.glm,
                                 lod$X.LOD,
                                 lod$level)
        
        pred.data <- plot.labs$pred.df
        top.interval <- plot.labs$top.interval
        bottom.interval <- plot.labs$bottom.interval
        
        # merge data from dataset and lod set
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
        
        # requirements from app
        req(input$file1, lod.data())

        # Render interactive plot with calculated LOD
        lod.plot(data = data(),
                 pred.data = lod.data()$pred.data, 
                 top.interval = lod.data()$top.interval, 
                 bottom.interval = lod.data()$bottom.interval, 
                 X.LOD = lod.data()$x.lod)
    })
    
    # LIMIT OF DETECTION STATISTICS --------------------------------------------
    output$lod_stats_output <- renderPrint({
        
        # requirements from app
        req(input$file1, lod.data())
        
        # Return calculated lod paramaters into app
        data.frame(significance = lod.data()$significance,
                   logit.value = lod.data()$logit.value,
                   lod.value = lod.data()$x.lod,
                   se.lod.value = lod.data()$se.lod)
    })
    
    # FLUORESCENCE DATA PREPARATION --------------------------------------------
    
    # Reactive data for fluorescence plot
    # This reactive contains data prepared for fluorescence visualization
    # the application assumes that the first column will contain temperature values 
    pcr.data <- reactive({
        
        # requirements from app
        req(input$file1)
        
        # call uploaded dataset from app
        pcr.tmp <- data()
        
        if(colnames(pcr.tmp)[1]=="Temperature"){
            
            # prepare dataset for ggplot2 visualisation
            pcr.melt = melting.data(dataframe = pcr.tmp, id_variables = "Temperature")
        } else {
            # wrapped helpers function
            fluorescence.error.message(data())
        }
    })
    
    # Reactive data for difference fluorescence plot
    # This reactive contains data prepared for difference fluorescence visualization
    # The application assumes that the first column will contain temperature values 
    diff.data <- reactive({
        
        # requirements from app
        req(input$file1,
            input$ref.curve)
        
        # call uploaded dataset from app
        diff.tmp <- data()

        # Calculates the difference between curves, based on 
        # reference curve provided by user
        if(colnames(diff.tmp)[1]=="Temperature"){
            new.data <- diff.calc(diff.tmp, as.integer(input$ref.curve))
            melt.data <- melting.data(dataframe = new.data,
                                      id_variables = "Temperature")
        } else {
            # wrapped helpers function
            fluorescence.error.message(data())
        }
        
    })
    
    # Renders raw fluorescence curves
    output$qpcr_plot_output <- renderPlotly({
        
        # requirements from app
        req(input$file1)
        
        # Plot data
        fluorescence.plot(pcr.data())
    })
    
    # Renders subtracted fluorescence curves
    output$qpcr_diff_output <- renderPlotly({
        
        # requirements from app
        req(input$file1,
            input$ref.curve)
        
        # Plot data
        fluorescence.plot(diff.data())
    })
    
}
