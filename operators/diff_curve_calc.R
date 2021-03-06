# Calculates differences between fluorescence curves from qPCR reaction.
# Its purpouse is to distinct genotypes between fluorescence curves from
# High Resolution Melt (HRM) reaction. Differences are calculated based
# on reference curve, which is selected from input by user via shiny app.
# Parameters:
# dataframe     - dataframe containing Temperature values in the first column
#                 samples with a fluorescence signal in the remaining columns
# ref_index     - reference curve selected by user. It is used as reference
#                 to calculate differences between them.
# Returns calculated dataframe with diff calculation
diff.calc <- function(dataframe, ref_index){
  
  
  left_index = ref_index - 1
  right_index = ref_index + 1
  data.len = length(dataframe)
  
  df.tmp <- dataframe[,c(2:data.len)]
  diff.len <- length(df.tmp)
  
  if (ref_index == ncol(df.tmp)) {
    diff.data <- df.tmp
    for (i in names(diff.data)[1:diff.len]){
      diff.data[,i] = diff.data[,diff.len] - diff.data[,i]
    }
    
  } else if (ref_index == 1){
    diff.data <- df.tmp[,c(2:diff.len, 1)]
    for (i in names(diff.data)[1:diff.len]){
      diff.data[,i] = diff.data[,diff.len] - diff.data[,i]
    }
    
  } else {
    diff.data <- df.tmp[,c(1:left_index, right_index:diff.len, ref_index)]
    for (i in names(diff.data)[1:diff.len]){
      diff.data[,i] = diff.data[,diff.len] - diff.data[,i]
    }
    
  }
  
  concat.data <-cbind(dataframe[,1], diff.data)
  colnames(concat.data)[1] = colnames(dataframe)[1]
  
  return(concat.data)
}