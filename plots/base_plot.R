
hist.plot <- function(x, bins){
  gg.hist <- ggplot() +
    geom_histogram(aes(x), bins = bins) +
    ggtitle("Histogram plot") +
    xlab("Distribution series") +
    ylab("Count")
  
  ggplotly(gg.hist)
}

box.plot <- function(x, var){
  gg.box <- ggplot() +
    geom_boxplot(aes(y = x)) +
    ggtitle("Boxplot") +
    xlab(paste0("Variable: ", var)) +
    ylab("Counts")
  
  ggplotly(gg.box)
}

scatter.plot <- function(x, var){
  gg.scatter <- qplot(x = seq_along(x),
                      y = x, 
                      xlab = paste0("Variable ", var, " index"),
                      ylab = "Value", 
                      main = "Scatter plot")

  ggplotly(gg.scatter)
}

generate.plot <- function(x, var, plot.option, bins){
  if (plot.option == 'histogram') {
    hist.plot(x, bins)
  } else if (plot.option == 'boxplt') {
    box.plot(x, var)
  } else if (plot.option == 'scatter') {
    scatter.plot(x, var)
  }
}
