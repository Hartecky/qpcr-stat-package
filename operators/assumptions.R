# Description:
# Function which is deciding which operation should be performed:
# 1. Normality Shapiro-Wilk test
# 2. Variance Bartlett test
# 3. Outliers detection based on Z-score
# 
# Inpus:
# X - numeric vector
# Y - factor variable
# option - string with option name
# 
# Output:
# Returns results of each operation

assumptions.testing <- function(X, Y, option) {
  if (option == 'normtest') {
    stopifnot(is.numeric(X))
    
    shapiro.test(X)
    
  } else if (option == 'vartest') {
    stopifnot(is.factor(Y))
    stopifnot(is.numeric(X))
    
    bartlett.test(X, Y)
  } else if (option == 'outliers') {
    z.score <- scale(X)
    outliers.index <- which(abs(z.score) > 3)
    
    if (length(outliers.index > 1)) {
      cat("Outlier indexes",
          outliers.index)
      
    } else {
      cat("Data does not have outliers")
      
    }
    
  }
}
 
# Prints brief information about performed operation and 
# provides hints for hypotheses testing

assumptions.messages <- function(option, variable) {
  if (option == 'normtest') {
    cat(
      '
    Distribution normality testing:

    H0: Distribution of variable',
      variable,
      'is consistent with normal distribution
    HA: Distribution of variable',
      variable,
      'differs from normal distribution'
    )
    
  } else if (option == 'vartest') {
    cat(
      '
    Variance Homogenity testing:

    H0: The variance among each group is equal
    HA: At least one group has a variance that is not equal to the rest'
    )
    
  } else if (option == 'outliers') {
    cat(
      '
    Outliers detection based on Z-score, which is
    scaling data to mean 0 and standard deviation 1.

    Z-score is calculated by following formula:

    Z = (X - mean(X)) / standard_devation(X)

    After scaling, every value lower than -3 and hihger than 3
    is an outlier.'
    )
  }
}
