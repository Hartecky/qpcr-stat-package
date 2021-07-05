library(ggplot2)
library(plotly)

hist.plot <- function(data, x){
  bins <- seq(10,50)
  
  gg.hist <- ggplot() +
    geom_histogram(data = data, aes(x), bins = 25) +
    ggtitle("Histogram plot") +
    xlab("Distribution series") +
    ylab("Count")
  
  ggplotly(gg.hist)
}
