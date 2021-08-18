compare.means.param <- function(test.type, X, Y, mu, alternative, paired, confidence){
  
  if (test.type == 'onesample') {
    # check parameters conditions
    stopifnot(is.vector(X) | is.numeric(X) | is.numeric(mu))
    alpha_conditions(confidence)
    # one sample test
    t.test(x = X, 
           mu = mu,
           conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Paired') {
    # two sample paired test 
    t.test(x = X,
           y = Y,
           alternative = alternative,
           paired = TRUE,
           conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Non-paired') {
    # two sample non-paired test
    t.test(x = X,
           y = Y,
           alternative = alternative,
           paired = FALSE,
           conf.level = confidence)
  }
}

compare.means.nonparam <- function(test.type, X, Y, mu, alternative, paired, confidence){
  
  if (test.type == 'onesample') {
    # one sample wilcox test
    wilcox.test(X,
                mu = mu,
                alternative = alternative,
                conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Paired') {
    # two samples wilcox paired test
    wilcox.test(x = X,
                y = Y,
                alternative = alternative,
                paired = TRUE,
                conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Non-paired') {
    # two samples wilcox non-paired test
    wilcox.test(x = X,
                y = Y,
                alternative = alternative,
                paired = FALSE,
                conf.level = confidence)
  }
}




