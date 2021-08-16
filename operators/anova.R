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
