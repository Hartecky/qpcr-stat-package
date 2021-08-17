compare.means.param <- function(test.type, X, Y, mu, alternative, paired, confidence){
  print(paired)
  if (test.type == 'onesample') {
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
