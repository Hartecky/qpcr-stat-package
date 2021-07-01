library(reshape2)

melting.data = function(dataframe, id_variables){
  df = melt(data = dataframe, id.vars = id_variables)
  colnames(df) = c("Temperature", "Sample", "FluorescenceSignal")
  return(df)
}
