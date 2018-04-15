# is.wholeNumber checks whether a number is an integer (is.integer does not do this).
is.wholeNumber <- function(x, tol = .Machine$double.eps^0.5){
  if(!is.numeric(x)){return(FALSE)}
  abs(x - round(x)) < tol
}