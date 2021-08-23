# Prints messages and error logs of the assumptions operations
assumptions.messages <- function(option, variable) {
  if (option == 'normtest') {
    
    cat('Distribution normality testing:\n
        H0: Distribution of variable', variable, 'is consistent with normal distribution
        HA: Distribution of variable', variable, 'differs from normal distribution \n')
    
  } else if (option == 'vartest') {
    cat('Variance Homogenity testing:\n
        H0: The variance among each group is equal
        HA: At least one group has a variance that is not equal to the rest\n')
    
  } else if (option == 'outliers') {
    
    cat('Outliers detection based two methods:\n
        Dixon test:
        Testing lowest and highest value from loaded data at 
        the same time to test if these values are an outliers
        
        - - - - -
        
        The other way for outliers detection for large datasets is 
        based on Z-score, by scalling data to new set with mean 0
        and standard deviation 1. After scalling, if the absolute 
        value X > 3, then this value is considered as outlier\n')
  }
}

# Prints help about making decision after performed test
decision.making.messages <- function(option){
  if (option == 'normtest') {
    cat('Decision making based on p-value\n
        
        When p < 0.05 - Reject H0 and accept alternative, 
        distribution of variable is from normal distribution.\n
        Whenp > 0.05 - Fail to reject H0 - distribution of 
        variable is not from normal distribution\n')
  } else if (option == 'vartest') {
    cat('Decision making based on p-value\n
        
        When p < 0.05 - Reject H0 and accept alternative,
        variances are equal among groups.\n
        When p > 0.05 - Fail to reject H0 - variances among
        groups are not equal\n')
  }
}

# Prints error messages for LOD panel, if given data is not 3x3 matrix
# with specified header 
lod.error.message <- function(data) {
  
  names.list <- c('dilution', 'total', 'positive')
  
  if(dim(data)[1]==3 & dim(data)[2]==3 & identical(names.list, names(data))) {
    return()
  } else {
    stop("
    Dataset provided for LOD calculation is incorrect. 
    Provided data is not a 3x3 matrix with column names 
    set respectively as 'dilution', 'total', 'positive'.
    
    Example dataset for LOD calculation is attached in the 
    AmpliStat/datasets directory")
  }
}

# Prints error message for fluorescence data 
fluorescence.error.message <- function(data) {
  stop("
  Data provided for qPCR fluorescence visualisation is incorrect. Exit code with status 1.
  Common problems:
  - First column is not the 'Temperature' column;
  - incorrect separators for values or digits;
  - undeclared header;
  - wrong first column name
  
  Example dataset for fluorescence plot visualisation is attached
  in the AmpliStat/datasets directory")
}