# This script includes a set of functions configuring a 3x3 provided matrix 
# into a data frame to derive a detection limit value. 
# GLM model for further LOD calculations is also prepared

# Subtracts total and positives reaction results and binds the
# difference with original positive results into new dataframe

# Parameters:
# dataframe   - provided 3x3 matrix with a dilution, positive results 
#               and total samples 
define.freq <- function(dataframe) {
  attach(dataframe)
  total.diff <- total - positive
  
  Y <- cbind(positive, total.diff)
  
  
  detach(dataframe)
  return(Y)
}

# Fits GLM model to binomial data, using a logit link, and 
# the method finds the model parameters that maximize 
# the above likelihood

# Parameters:
# Y       - dependent variable for GLM model (matrix)
# data    - dataframe
fit.model <- function(Y, data) {
  model <- glm(Y ~ dilution,
               family = binomial(link = logit),
               data = data)
}

# Calculations of LOD value:
# .
# .
# .
# .
logit.value <- function(alpha) {
  logit.LOD <- log(alpha / (1 - alpha))
  return(logit.LOD)
}

LOD <- function(mod, log.val) {
  tmp <- as.vector((log.val - coef(mod)[1]) / coef(mod)[2])
  return(tmp)
}

se.computations <- function(model, xlod) {
  
  co <- model$coef
  model.sum <- summary(model)
  SE.co <- model.sum$coef[, 2]
  COV.co <- model.sum$cov.scaled[1, 2]

  SE.LOD <- abs(xlod) * sqrt((SE.co[1] / co[1]) ^ 2 +
                               (SE.co[2] / co[2]) ^ 2 -
                               2 * (COV.co / (co[1] * co[2])))
  
  log.SE.LOD <- log10(SE.LOD)
  
  return(log.SE.LOD)
  
}

define.intervals <- function(x.lod, log.se.lod) {
  bottom <- x.lod - (1.96 * log.se.lod)
  top <- x.lod + (1.96 * log.se.lod)
  
  results <- list(bottom = bottom,
                  top = top)
  
  return(results)
}

# Wrapped function which is performing all operations one by one

# Parameters:
# dataframe   - 3x3 matrix provided by user
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
