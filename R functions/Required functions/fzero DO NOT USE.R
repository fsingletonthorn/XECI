fzero <- function(f, x, ..., maxiter = 100, tol = .Machine$double.eps^(1/2)) {
 # Function from 
   if (!is.numeric(x) || length(x) > 2)
    stop("Argument 'x' must be a scalar or a vector of length 2.")
  
  err <- try(fun <- match.fun(f), silent = TRUE)
  if (class(err) == "try-error") {
    stop("Argument function 'f' not known in parent environment.")
  } else {
    f <- function(x) fun(x, ...)
  }
  
  zin <- NULL
  if (length(x) == 2) {
    if (x[1] <= x[2]) {
      a <- x[1]; b <- x[2]
    } else {
      warning("Left endpoint bigger than right one: exchanged points.")
      a <- x[2]; b <- x[1]
    }
    zin <- .zeroin(f, a, b, maxiter = maxiter, tol = tol)
    
  } else {  # try to get b
    a <- x; fa <- f(a)
    if (fa == 0) return(list(x = a, fval = fa))
    if (a == 0) {
      aa <- 1
    } else {
      aa <- a
    }
    bb <- c(0.9*aa, 1.1*aa, aa-1, aa+1, 0.5*aa, 1.5*aa,
            -aa, 2*aa, -10*aa, 10*aa)
    for (b in bb) {
      fb <- f(b)
      if (fb == 0) return(list(x = b, fval = fb))
      if (sign(fa) * sign(fb) < 0) {
        zin <- .zeroin(f, a, b, maxiter = maxiter, tol = tol)
        break
      }
    }
  }
  
  if (is.null(zin)) {
    warning("No interval w/ function 'f' changing sign was found.")
    return(list(x = NA, fval = NA))
  } else {
    x1 <- zin$bra[1]; x2 <- zin$bra[2]
    f1 <- zin$ket[1]; f2 <- zin$ket[2]
    x0 <- sum(zin$bra)/2; f0 <- f(x0)
    if (f0 < f1 && f0 < f2) {
      return(list(x = x0, fval = f0))
    } else if (f1 <= f2) {
      return(list(x = x1, fval = f1))
    } else {
      return(list(x = x2, fval = f2))
    }
  }
}
