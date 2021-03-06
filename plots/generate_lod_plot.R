# Function which is generating plot with dilution curve
# with marked points with limit of detection values
# Parameters: 

# data            - raw original dataset
# pred.data       - processed dataset for LOD calculation
# top.interval    - top interval data for plotting lines
# bottom.interval - bottom interval data plotting lines
# X.LOD           - calculated LOD (Limit of Detection) value
lod.plot <- function(data, pred.data, top.interval, bottom.interval, X.LOD){
  
  dil <- 10^seq(-1,1,0.01)
  
  p <- ggplot() +
    geom_line(data = pred.data, aes(dil, pred)) +
    geom_point(data = data, aes(dilution, positive/total)) +
    
    geom_line(data = top.interval, aes(a,b), linetype="dashed") +
    geom_line(data= bottom.interval, aes(a,b), linetype="dashed") +
    
    geom_text(aes(x = 1, 
                  y = 0.93,
                  label = "95%")) +
    
    geom_text(aes(x = X.LOD, 
                  y = 0.00,
                  label = round(X.LOD, digits = 2))) +
    
    ylim(c(0,1)) +
    xlim(c(-5,24)) +
    
    ggtitle("Positive results obtained in the Real Time PCR reaction") +
    ylab("Percentage of positive results") +
    xlab("The concentration of the standard (DNA/2 uL)")
  
  ggplotly(p)
  
}

