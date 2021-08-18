alpha_conditions <- function(alpha){
  if (alpha > 1 | alpha < 0) {
    stop("Confidence level must be a single number between 0 and 1")
  } else {
    return (TRUE)
  }
}
