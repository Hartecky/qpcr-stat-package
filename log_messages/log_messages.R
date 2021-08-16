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
