assumptions.testing <- function(X, Y, option) {
  if (option == 'normtest') {
    stopifnot(is.numeric(X))
    
    shapiro.test(X)
    
  } else if (option == 'vartest') {
    stopifnot(is.factor(Y))
    stopifnot(is.numeric(X))
    
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
