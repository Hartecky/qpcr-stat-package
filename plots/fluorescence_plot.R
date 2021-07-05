library(ggplot2)
library(plotly)

fluorescence.plot <- function(melt.data){
  
  hrm.plot <- ggplot(melt.data, aes(Temperature, FluorescenceSignal, col=Sample)) + 
    geom_line(size = 0.75) +
    ggtitle("High Resolution Melt visualisation plot") +
    xlab("Temperature") +
    ylab("Fluorescence Signal") +
    ggtitle("HRM Melting Curves")
  
  ggplotly(hrm.plot)
}
