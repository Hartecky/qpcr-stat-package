# Processes multiple column dataframe into 3 column labeled dataframe
# with melt function. This dataframe conversion better suits for 
# generating plots in ggplot2 package
# 
# Returns converted dataframe

melting.data = function(dataframe, id_variables){
  df = melt(data = dataframe, id.vars = id_variables)
  colnames(df) = c("Temperature", "Sample", "FluorescenceSignal")
  return(df)
}
