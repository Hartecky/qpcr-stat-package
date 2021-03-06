# Visualizing fluorescence curves from qPCR machine
# On X-axis temperature of reaction is located and 
# On Y-axis fluorescence signal is located
# The plot is shown in interactive version via plotly

# Parameters:
# melt.data   - dataframe generated by melting function from 
# melt_data.R script, which uses function melt() from reshape2
# package
fluorescence.plot <- function(melt.data){
  
  hrm.plot <- ggplot(melt.data, aes(Temperature, FluorescenceSignal, col=Sample)) + 
    geom_line(size = 0.75) +
    ggtitle("High Resolution Melt visualisation plot") +
    xlab("Temperature") +
    ylab("Fluorescence Signal") +
    ggtitle("HRM Melting Curves")
  
  ggplotly(hrm.plot)
}
