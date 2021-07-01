# LOD - Limit of Detection
# This file contains scripts, which are preparing data
# and logit model to calculate limit of detection of
# qPCR reaction and plot it with significance of 95%

define.freq <- function(dataframe) {
  attach(dataframe)
  total.diff <- total - positive
  
  Y <- cbind(positive, total.diff)
  
  return(Y)
}


# Logistic regression model
fit.model <- function(Y, data) {
  model <- glm(Y ~ dilution,
               family = binomial(link = logit),
               data = data)
}


# Calculates logarithm of logit
logit.value <- function(alpha) {
  logit.LOD <- log(alpha / (1 - alpha))
  return(logit.LOD)
}


# Calculates LOD value based on model and logit logarithm
LOD <- function(mod, log.val) {
  tmp <- as.vector((log.val - coef(mod)[1]) / coef(mod)[2])
  return(tmp)
}


# Calculates LOD value of a model and LOD
se.computations <- function(model, xlod) {
  
  co <- model$coef
  model.sum <- summary(model)
  SE.co <- model.sum$coef[, 2]
  COV.co <- model.sum$cov.scaled[1, 2]
  
  # compute SE
  
  SE.LOD <- abs(xlod) * sqrt((SE.co[1] / co[1]) ^ 2 +
                               (SE.co[2] / co[2]) ^ 2 -
                               2 * (COV.co / (co[1] * co[2])))
  
  log.SE.LOD <- log10(SE.LOD)
  
  return(log.SE.LOD)
  
}

# Defining confidence intervals
define.intervals <- function(x.lod, log.se.lod) {
  bottom <- x.lod - (1.96 * log.se.lod)
  top <- x.lod + (1.96 * log.se.lod)
  
  results <- list(bottom = bottom,
                  top = top)
  
  return(results)
}
