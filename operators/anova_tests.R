analysis.of.variance <- function(Y, X, data) {
  
  fit <- aov(Y ~ X, data = data)
  fitted <- anova(fit)
  return(list(fitted.model = fitted,
              model = fit))
}

analysis.of.variance.two <- function(Y, X1, X2, data){
  
  fit <- aov(Y ~ X1 + X2, data = data)
  fitted <- anova(fit)
  return(list(fitted.model = fitted,
              model = fit))
}

analysis.posthoc <- function(model, fitted.model) {
  if (fitted.model$`Pr(>F)`[1] < 0.05) {
    TukeyHSD(model)
  } else {
    return ()
  }
}

kruskal.analysis <- function(Y, X, data){
  model <- kruskal.test(Y ~ X, data)
  print(model)
}

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

anova.test.nonparam <- function(Y, X, data) {
  stopifnot(is.factor(X))
  stopifnot(is.vector(Y) | is.numeric(Y) | length(Y) < 2)
  
  model <- kruskal.analysis(Y, X, data)
  cat('---------------------------------------------\n')
  kruskal.posthoc(Y, X, model, data)
}
