library(ggplot2)
library(plotly)

fluorescence.plot <- function(melt.data){
  
  hrm.plot <- ggplot(melt.data, aes(Temperature, FluorescenceSignal, col=Sample)) + 
    geom_line(size = 0.75) +
    xlab("Temperature") +
    ylab("Fluorescence Signal") +
    ggtitle("HRM Melting Curves")
  
  ggplotly(hrm.plot)
}
