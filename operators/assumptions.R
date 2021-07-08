assumptions.testing <- function(X,Y,option){
  if (option == 'normtest'){
    shapiro.test(X)
  } else if (option == 'vartest'){
    bartlett.test(X, Y)
  } else if (option == 'outliers') {
    z.score <- scale(X)
    outliers.index <- which(abs(z.score)>3)
    
    if (length(outliers.index>1)){
      cat("Outlier indexes", 
      outliers.index)
    } else {
      cat("Data does not have outliers")
    }

  }
}

assumptions.messages <- function(option, variable){
  if (option == 'normtest'){
    cat('
    Distribution normality testing:
    
    H0: Distribution of variable',variable, 'is consistent with normal distribution
    HA: Distribution of variable',variable, 'differs from normal distribution')
    
  } else if (option == 'vartest') {
    cat('
    Variance Homogenity testing:
        
    H0: The variance among each group is equal
    HA: At least one group has a variance that is not equal to the rest')
  } else if (option == 'outliers'){
    cat('
    Outliers detection based on Z-score, which is 
    scaling data to mean 0 and standard deviation 1.
    
    Z-score is calculated by following formula:
    
    Z = (X - mean(X)) / standard_devation(X)
        
    After scaling, every value lower than -3 and hihger than 3
    is an outlier.')
  }
}
