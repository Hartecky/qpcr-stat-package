# Checks range of provided alpha value

# Parameters: 
# alpha: value provided by user

# Returns TRUE if alpha is [0,1] and 
# returns message when it is not

check.alpha <- function(alpha){
  if (alpha > 1 | alpha < 0) {
    stop("Confidence level must be a single number between 0 and 1")
  } else {
    return (TRUE)
  }
}