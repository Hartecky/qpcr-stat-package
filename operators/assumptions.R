# Script which is testing assumptions to make first
# overview of the given data.
# - testing normality distribution with shapiro.wilk test
# - testing if variance between groups are equal with bartlett test
# - testing if provided data has outliers with Q-Dixon test if vector has
#   less than 30 observations, or based on Z-score standarization if vector
#   has more than 30 observations
# Parameters:
# X         - vector of data selected by user via shinyapp
# Y         - factor variable (groups for bartlett test)
# option    - test name selected from input by user via shinyapp
assumptions.testing <- function(X, Y, option) {
  if (option == 'normtest') {
    stopifnot(is.numeric(X))
    
    shapiro.test(X)
    
  } else if (option == 'vartest') {
    stopifnot(is.factor(Y))
    
    bartlett.test(X, Y)
    
  } else if (option == 'outliers') {
    if (length(X) < 30) {
      cat('Testing the lowest value\n')
      print(dixon.test(X))
      
      cat('\nTesting the highest value\n')
      print(dixon.test(X, opposite = TRUE))
      
    } else if (length(X) > 30) {
      z.score <- scale(X)
      outliers.index <- which(abs(z.score) > 3)
      if (length(outliers.index > 1)) {
        cat('Outlier values indexes:\n', outliers.index)
      } else {
        cat('No outliers were observed')
      }
    }
  }
}
