# Histogram plotting function
# Parameters:

# x     - vector with observations
# bins  - number of bins for histogram plot 
hist.plot <- function(x, bins){
  gg.hist <- ggplot() +
    geom_histogram(aes(x), bins = bins) +
    ggtitle("Histogram plot") +
    xlab("Distribution series") +
    ylab("Count")
  
  ggplotly(gg.hist)
}

# Boxplot plotting function
# Parameters:

# x     - vector with observations
# var   - variable name
box.plot <- function(x, var){
  gg.box <- ggplot() +
    geom_boxplot(aes(y = x)) +
    ggtitle("Boxplot") +
    xlab(paste0("Variable: ", var)) +
    ylab("Counts")
  
  ggplotly(gg.box)
}

# Scatter plotting function 
# Parameters:

# x     - vector with observations
# var   - variable name
scatter.plot <- function(x, var){
  gg.scatter <- qplot(x = seq_along(x),
                      y = x, 
                      xlab = paste0("Variable ", var, " index"),
                      ylab = "Value", 
                      main = "Scatter plot")

  ggplotly(gg.scatter)
}

# Wrapped plotting function 
# Plots data based on provided option

# Parameters:
# x           - vector of observations to visualise
# var         - variable name
# plot.option - plot name
# bins        - number of bins for histogram

# Returns plot
generate.plot <- function(x, var, plot.option, bins){
  
  # histogram
  if (plot.option == 'histogram') {
    hist.plot(x, bins)
    
  # boxplot
  } else if (plot.option == 'boxplt') {
    box.plot(x, var)
    
  # scatter
  } else if (plot.option == 'scatter') {
    scatter.plot(x, var)
  }
}
