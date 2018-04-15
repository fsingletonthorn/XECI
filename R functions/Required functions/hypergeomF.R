hypergeomF <- function(a, b, c, z) {
  # Computes the confluent hypergeometric function 2F1(a,b;c;z) using the Taylor
  # series method (b) of Section 4. of Pearson (2009). Code addapted from 
  # Pearson, J. W. (2009). Computation of hypergeometric functions (Masters dissertation, University of Oxford).
  #
  # Input:   ar=Re(a)                                                       
  #          ai=Im(a)                                                       
  #          br=Re(b)                                                       
  #          bi=Im(b)                                                        
  #          cr=Re(c)                                                        
  #          ci=Im(c)                                                        
  #          zr=Re(z)                                                        
  #          zi=Im(z)                              
  #  Output: h=Computed value of 2F1(a,b;c;z)                             
  #  Compute a,b,c,z in terms of ar,ai,br,bi,cr,ci,zr,zi
  # a=ar+ai*1i;
  # b=br+bi*1i;
  # c=cr+ci*1i;
  # z=zr+zi*1i;
  #
  # Set tolerance
  tol <- 10e-12
  
  # Initialise r(j) as detailed in Section 4.2
  r = rep(0,2)
  
  r[1] = a * b / c
  
  r[2] = (a + 1) * (b + 1) / 2 / (c + 1)
  
  
  # Initialise A(j) as detailed in Section 4.2
  A = rep(0,2)
  
  A[1] = 1 + z * r[1]
  
  A[2] = A[1] + z ^ 2 * a * b / c * r[2]
  
  for(j in 3:1000) {
  # Update r(j) and A(j) in terms of previous values
  r[j] = (a + j - 1) * (b + j - 1) / j / (c + j - 1)
  A[j] = A[j - 1] + (A[j - 1] - A[j - 2]) * r[j] * z
  
  # If stopping criterion is satisfied, terminate computation
  if(abs((A[j] - A[j - 1]) / abs(A[j - 1])) < tol &&
    abs(A[j - 1] - A[j - 2]) / abs(A[j - 2]) < tol)
  break()
  # If 1000 terms have been computed before stopping criterion has been
  # satisfied, state this
  if (j == 1000){
    warning('1000 terms computed for hypergeometric function, function failed to reach tolerence')
  }
  }
  # Return sum as solution (i.e., final "A" value calculated)
  h = A[length(A)]
  return(h)
}