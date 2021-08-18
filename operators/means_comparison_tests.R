compare.means.param <- function(test.type, X, Y, mu, alternative, paired, confidence){
  check.alpha(confidence)
  if (test.type == 'onesample') {
    # one sample test
    stopifnot(is.vector(X) | is.numeric(X) | is.numeric(mu))
    t.test(x = X, 
           mu = mu,
           conf.level = confidence,
           alternative = alternative)
  } else if (test.type == 'twosamples' & paired == 'Paired') {

    # two sample paired test 
    stopifnot(is.vector(X) | is.numeric(X) | length(X) < 2)
    stopifnot(is.vector(Y) | is.numeric(Y) | length(X) < 2)
    stopifnot(length(X) != length(Y))
    t.test(x = X,
           y = Y,
           alternative = alternative,
           paired = TRUE,
           conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Non-paired') {

    # two sample non-paired test
    stopifnot(is.vector(X) | is.numeric(X) | length(X) < 2)
    stopifnot(is.vector(Y) | is.numeric(Y) | length(X) < 2)
    stopifnot(length(X) != length(Y))
    t.test(x = X,
           y = Y,
           alternative = alternative,
           paired = FALSE,
           conf.level = confidence)
  }
}

compare.means.nonparam <- function(test.type, X, Y, mu, alternative, paired, confidence){
  check.alpha(confidence)
  if (test.type == 'onesample') {
    # one sample wilcox test
    stopifnot(is.vector(X) | is.numeric(X) | is.numeric(mu))
    wilcox.test(X,
                mu = mu,
                alternative = alternative,
                conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Paired') {
    # two samples wilcox paired test
    stopifnot(is.vector(X) | is.numeric(X) | length(X) < 2)
    stopifnot(is.vector(Y) | is.numeric(Y) | length(X) < 2)
    wilcox.test(x = X,
                y = Y,
                alternative = alternative,
                paired = TRUE,
                conf.level = confidence)
  } else if (test.type == 'twosamples' & paired == 'Non-paired') {
    # two samples wilcox non-paired test
    stopifnot(is.vector(X) | is.numeric(X) | length(X) < 2)
    stopifnot(is.vector(Y) | is.numeric(Y) | length(X) < 2)
    wilcox.test(x = X,
                y = Y,
                alternative = alternative,
                paired = FALSE,
                conf.level = confidence)
  }
}




