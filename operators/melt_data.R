# Function which is preparing provided dataframe to 
# converted long format dataframe for ggplot2 function
# Parameters:
# dataframe       - dataframe to be converted
# id_variables    - ID of the variable name
melting.data = function(dataframe, id_variables){
  df = melt(data = dataframe, id.vars = id_variables)
  colnames(df) = c("Temperature", "Sample", "FluorescenceSignal")
  return(df)
}
