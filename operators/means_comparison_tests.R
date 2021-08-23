# This script contains functions which are performing means comparison
# - T-test for one sample
# - T-test for dependent / nondependent samples
# - Wilcox test for one sample
# - Wilcox test for dependent / non dependent Kruskal test

# Decides which parametric t-test should be performed, bases on
# selected option by user via shinyapp 
# Parameters:
# test.type     - option to select if test should be for one or two samples
# X             - vector of observations
# Y             - vector of observations
# mu            - mean to compare with (only for one sample test)
# alternative   - alternative hypothesis option
# paired        - a logical indicating whether you want a paired t-test.
# confidence    - confidence level of the interval
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


# Decides which non-parametric wilcox test should be performed, bases on
# selected option by user via shinyapp 
# Parameters:
# test.type     - option to select if test should be for one or two samples
# X             - vector of observations
# Y             - vector of observations
# mu            - mean to compare with (only for one sample test)
# alternative   - alternative hypothesis option
# paired        - a logical indicating whether you want a paired t-test.
# confidence    - confidence level of the interval
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




