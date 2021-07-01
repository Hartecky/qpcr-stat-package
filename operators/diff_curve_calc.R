diff.calc <- function(dataframe, ref_index){
  left_index = ref_index - 1
  right_index = ref_index + 1
  data_len = length(dataframe)
  
  diff_data <- dataframe[,c(1:left_index, right_index:data_len, ref_index)]
  
  for (i in names(diff_data)[2:data_len]){
    diff_data[,i] = diff_data[,data_len] - diff_data[,i]
  }
  
  return(diff_data)
}