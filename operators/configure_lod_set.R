# Function which is preparing data for plotting
# Limit of Detection (LOD) curve. It predicts values of 
# LOD for three given molecules concentration and then 
# estimates the minimal value of genomes per qPCR reaction,
# which investigated diagnostic kit will be able to capture

# Parameters:
# model   - GLM model object
# x.lod   - calculated LOD value
# alpha   - significance level
prepare.set <- function(model, x.lod, alpha) {
  
  dil <- 10^seq(-1,1,0.01)

  pred.data <- predict(model,
                       newdata = data.frame(dilution = dil),
                       type="response")
  
  pred.df <- data.frame(pred = pred.data,
                        dil = dil)
  
  top.interval <- data.frame(a = seq(0.1, x.lod, by = x.lod/nrow(pred.df)),
                             b = seq(0.95, 0.95))
  
  bottom.interval = data.frame(a = c(x.lod, x.lod),
                               b = c(0.95, 0))
  
  return(list(pred.data = pred.data, 
              pred.df = pred.df, 
              top.interval= top.interval, 
              bottom.interval = bottom.interval))
}
