# function for testing whether all entered numbers are numerics. Returns "TRUE" if all arguments are numerics, else returns false.
is.allNumeric <- function(...){
  argument <- list(...)
  sapply(argument, is.numeric)
}