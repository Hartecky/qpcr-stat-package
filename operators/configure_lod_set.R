# Processes results from lod logit model into a dataframe
# used in generating LOD plot
#
# Predicts results from a fitted LOD logit model and limit
# of detection value for given significance level. Also 
# defines top and bottom interval
# 
# Returns:
# 1. predicted data
# 2. dataframe with dilution curve and predicted data
# 3. bottom and top interval of a LOD value for given
#    significance level
#    
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
