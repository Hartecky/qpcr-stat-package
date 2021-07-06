library(ggplot2)
library(plotly)

hist.plot <- function(x){
  bins <- seq(10,50)
  
  gg.hist <- ggplot() +
    geom_histogram(aes(x), bins = 25) +
    ggtitle("Histogram plot") +
    xlab("Distribution series") +
    ylab("Count")
  
  ggplotly(gg.hist)
}
