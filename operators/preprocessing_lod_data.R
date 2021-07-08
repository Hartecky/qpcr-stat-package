# LOD - Limit of Detection
# This file contains scripts, which are preparing data
# and logit model to calculate limit of detection of
# qPCR reaction and plot it with significance of 95%

# LOD (Limit of detection) calculation script includes:
# 1. Dataframe preparation
# 2. Logistic regression model
# 3. Calculating logit value based on significance level
# 4. Calculating limit of detection (LOD) value
# 5. Calculating confidence intervals

# Matrix with difference between total and positive samples
define.freq <- function(dataframe) {
  attach(dataframe)
  total.diff <- total - positive
  
  Y <- cbind(positive, total.diff)
  
  
  detach(dataframe)
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


# Calculates se values for LOD
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

# LOD Operations 
lod.operations <- function(dataframe){
  Y <- define.freq(dataframe)
  model.glm <- fit.model(Y, dataframe)
  level <- logit.value(alpha = 0.95)
  X.LOD <- LOD(model.glm, level)
  log.SE.LOD <- se.computations(model.glm, X.LOD)
  
  return(list(model.glm = model.glm,
              X.LOD = X.LOD,
              level = level,
              log.SE.LOD = log.SE.LOD))
}
