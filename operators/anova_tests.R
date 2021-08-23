# This script contains functions which are performing means comparison
# between groups :
# One factor ANOVA
# Two factor ANOVA
# TukeyHS PostHoc test
# Non-parametric Kruskal-Wallis test

# Fits one factor ANOVA, and returns fitted model
# Parameters:
# Y     - dependent factor
# X     - independent factor
# data  - dataframe
analysis.of.variance <- function(Y, X, data) {
  
  fit <- aov(Y ~ X, data = data)
  fitted <- anova(fit)
  return(list(fitted.model = fitted,
              model = fit))
}

# Fits two factor ANOVA, and returns fitted model
# Parameters:
# Y     - dependent variable
# X1    - first independent factor
# X2    - second independent factor
# data  - dataframe
analysis.of.variance.two <- function(Y, X1, X2, data){
  
  fit <- aov(Y ~ X1 + X2, data = data)
  fitted <- anova(fit)
  return(list(fitted.model = fitted,
              model = fit))
}

# Performs TukeyHSD post-hoc test if provided model indicates that
# one of the provided variables is significant
# Parameters:
# model           - anova results model
# fitted.model    - fitted anova model
analysis.posthoc <- function(model, fitted.model) {
  if (fitted.model$`Pr(>F)`[1] < 0.05) {
    TukeyHSD(model)
  } else {
    return ()
  }
}

# Performs one factor non-parametric means comparison between groups
# Parameters:
# Y     - dependent variable
# X     - independent factor
# data  - dataframe
kruskal.analysis <- function(Y, X, data){
  model <- kruskal.test(Y ~ X, data)
  print(model)
}

# Performs Duncan non-parametric post-hoc test if model indicates that
# dependent variable is significant. Returns letter designations for groups
# Parameters:
# Y     - dependent variable
# X     - independent variable
# model - kruskal-wallis model
# data  - dataframe
kruskal.posthoc <- function(Y, X, model, data){
  if (model$p.value < 0.05){
    DT <- dunnTest(Y ~ X, data = data)
    print(DT)
    PT <- DT$res
    cldList(P.adj ~ Comparison,
            data = PT,
            threshold = 0.05)
  } else {
    return()
  }
}

# Wrapped function which is testing variables properties and 
# performing desired parametric tests via shiny app
# Parameters:
# option    - option provided from user by input
# Y         - dependent variable
# X1        - first independent factor
# X2        - second independent factor
# data      - dataframe
anova.test.param <- function(option, Y, X1, X2, data){
  if (option == 'onesample'){
    stopifnot(is.factor(X1))
    stopifnot(is.vector(Y) | is.numeric(Y) | length(Y) < 2)
    
    aov.model <- analysis.of.variance(Y, X1, data)
    
    fit <- aov.model$fitted.model
    model <- aov.model$model
    
    print(aov.model)
    cat('---------------------------------------------\n')
    analysis.posthoc(model, fit)
  } else if (option == 'twosamples') {
    stopifnot(is.factor(X1) | is.factor(X2))
    stopifnot(is.vector(Y) | is.numeric(Y) | length(Y) < 2)
    
    aov.model <- analysis.of.variance.two(Y, X1, X2, data())

    fit <- aov.model$fitted.model
    model <- aov.model$model

    print(aov.model)
    cat('---------------------------------------------\n')
    analysis.posthoc(model, fit)
  }
}

# Wrapped function which is testing variables properties and 
# performing desired non-parametric test via shiny app
# Parameters:
# option    - option provided from user by input
# Y         - dependent variable
# X1        - first independent factor
# X2        - second independent factor
# data      - dataframe
anova.test.nonparam <- function(Y, X, data) {
  stopifnot(is.factor(X))
  stopifnot(is.vector(Y) | is.numeric(Y) | length(Y) < 2)
  
  model <- kruskal.analysis(Y, X, data)
  cat('---------------------------------------------\n')
  kruskal.posthoc(Y, X, model, data)
}
