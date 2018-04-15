# RUN whole .R file first (XECI_corr is dependent on functions that are in this file)
XECI_corr <-
  function(sampleR,
           nSize,
           nullRho = 0,
           ciSize = 95,
           nPartialR = 0) {
    # XECI_corr calculates effect sizes and CI for Pearson zero-order and
    # partial correlations, and CI for Spearman rank-order correlation (if
    # Spearman correlation entered as input value)
    
    # Dependencies ####
    # Requires XECI_rho_cdf, XECI_ncp_rho, hypergeomF, is.wholeNumber
    
    # Argument specifications ####
    # sampleR    = observed correlation value
    # nSize      = sample size
    # ciSize     = confidence interval size
    # nullRho    = null hypothesised rho value
    # nPartialR  = number of partialled variables
    
    # Output specifications ####
    # t test results
    # "Observed t value"= tVal
    # "Degrees of freedom" = df.tVal
    # "Obtained p value" = pVal.tTest
    # "partial correlation"= sampleR
    # "Fisher\'s_r_to_z_CI" = fisher.RToZ.CI
    # "Unbiased Fisher\'s r to z" = unbiasedR
    # "Unbiased Fisher\'s r to z CI" = unbiased.RToZ.CI
    # "Exact (sample) CI" = exactSample.CI
    # "Exact (unbiased) CI" = unbiasedExact.CI
    
     # The following have been copied from XECI (01.04.2018) IGNORE THIS: 
    #       esXECI = (2 X 1) vector of point estimates of effect sizes
    #                    Sample correlation (zero-order or partial)
    #                    Olkin & Pratt's unbiased estimate
    #
    #       ciXECI = (8 X 3) matrix of lower and upper bound CI estimates
    #                    Large-sample Pearson
    #                    Large-sample Olkin & Pratt's unbiased estimate
    #                    Large-sample Spearman
    #                    Exact for Pearson correlation
    #                    Exact for unbiased estimate of Pearson
    #
    #         tStat = t statistic value
    #         df = Degrees of freedom
    #         p = Obtained P value
    #         nullRho.p = Null-rho P value
    #
    #       varXECI = (9 X 2) vector of estimated variances
    #                    Large sample variance
    #                    Olkin & Pratt variance
    #
    
    # VERSION HISTORY ####
    # 01.04.2018 - FST creates function - Only Fisher's r to z CI are calculated
    # 08.04.2018 - FST updates function with other functionality - does not account for partial correlations yet
    #
    
    # Package from which functions were adapted for use in this function: ####
    #
    #
    
    # Input check ####
    # setting up a error message 
        errorMessage<-0
    # Check if sampleR is a number from -1 to 1
    if ((sampleR > 1) | (sampleR < -1) | !is.numeric(sampleR)) {
      warning("Sample r must be a number between -1 and +1, inclusive")
      stopCheck<-1
    }
    # Check if nSize is a whole number above 0 # REQUIRES is.wholeNumber function
    if ((nSize < 1) | !is.wholeNumber(nSize)) {
     warning("Sample size must be a whole number above 0")
      stopCheck<-1
    }
    # Check if CISize is a number between 1-99
    if ((ciSize <= 0) | (ciSize >= 100) | !is.numeric(ciSize)) {
      warning("Confidence interval width must be a number between 0 and 100, non-inclusive")
      stopCheck<-1
    }
    # Check if nullRho is a number between -1 to 1
    if ((nullRho > 1) | (nullRho < -1) | !is.numeric(nullRho)) {
      warning("Null Rho must be a number between -1 and +1, inclusive")
      stopCheck<-1
    }
    # Check if nPartialR is a whole number above 0 # USES is.wholeNumber function ~!!~
    if (((nPartialR < 0) | !is.wholeNumber(nPartialR))) {
      warning("The number of partialled variables must be a whole number above 0")
      stopCheck<-1
    }
        # stopping the program if there are any warnings
    if(stopCheck == 1) {
      stop("Input error")
      }
    
    # Calculations ####
    # setting up functions - fishers r to z and z to r 
    fisher.r2z <-
      function(sampleR) {
        0.5 * (log(1 + sampleR) - log(1 - sampleR))
      }
    fisher.z2r <- function(z) {
      ((exp(2 * z)) - 1) / ((exp(2 * z)) + 1)
    }
    #### preliminary calculations
    
    #calculating standard error
    SE <- 1 / sqrt(nSize - 3)
    
    # P values for defining CI bounds
    probCI = c(((100+ciSize)/200), ((100-ciSize)/200))
    
    # calculating critical zs for rejection area
    zCritical <-  -qnorm(probCI)
    
    # t test
    # calculating t statistic
    tVal <- (sampleR * sqrt(nSize - 2)) / sqrt(1 - (sampleR ^ 2))
    # calculating df
    df.tVal <- nSize - 2
    # calculating p value
    pVal.tTest <- 2 * pt(tVal, df.tVal, lower.tail = FALSE)
    
    # Olkin and Pratt's (1958) unique minimum variance unbiased estimator of rho, uses Hypergeometric function of Pearson, J. W. (2009). 
    unbiasedR <- sampleR * hypergeomF(0.5, 0.5, (nSize-1)/2, 1 - sampleR^2)
  
    #### Confidence intervals ####
    
    # Fisher's r to z CI  for sample r ####
    #transforming r to z
    z <- fisher.r2z(sampleR)
    # calculating CI
    CI.Z <- z + zCritical * SE
    # Converting back to r
    fisher.RToZ.CI <- fisher.z2r(CI.Z)
    
    # Unbiased r CI using Fisher r to z CIs####
    #transforming r to z
    z.unbiasedR <- fisher.r2z(unbiasedR)
    # calculating CI
    CI.Z.UnbiasedR <-  z.unbiasedR + zCritical * SE
    # Converting back to r
    unbiased.RToZ.CI <- fisher.z2r(CI.Z.UnbiasedR)
    
    # Exact (sample) CI ####
    exactSample.CI[1]  <- XECI_ncp_rho(sampleR, nSize, nPartialR, probCI[1])
    exactSample.CI[2]  <- XECI_ncp_rho(sampleR, nSize, nPartialR, probCI[2])
    # Exact (population) CI ####
    unbiasedExact.CI[1]  <- XECI_ncp_rho(unbiasedR, nSize, nPartialR, probCI[1])
    unbiasedExact.CI[2]  <- XECI_ncp_rho(unbiasedR, nSize, nPartialR, probCI[2])
    
    # output
    output <- list(
      "Observed t value" = tVal,
      "Degrees of freedom" = df.tVal,
      "Obtained p value" = pVal.tTest,
      "partial correlation" = sampleR,
      "Fisher\'s_r_to_z_CI" = fisher.RToZ.CI,
      "Unbiased Fisher\'s r to z" = unbiasedR,
      "Unbiased Fisher\'s r to z CI" = unbiased.RToZ.CI,
      "Exact (sample) CI" = exactSample.CI,
      "Exact (unbiased) CI" = unbiasedExact.CI
    )
    return(output)
    
  #References####
    # Olkin, I., & Pratt, J. W. (1958). Unbiased Estimation of Certain Correlation Coefficients. The Annals of Mathematical Statistics, 29(1), 201-211.  Retrieved from http://www.jstor.org.ezp.lib.unimelb.edu.au/stable/2237306
    # Pearson, J. W. (2009). Computation of hypergeometric functions (Masters dissertation, University of Oxford).
  }



##################################################################################
#################################OTHER FUNCTIONS##################################
##################################################################################
XECI_ncp_rho <- function(sampleR, nSize, nPartialR, critProb) {
  # XECI_ncp_rho calculates the population Pearson (partial) correlation value for
  # given sampleR, nSize, nPartialR, and critProb using the Pearson correlation
  # distribution function
  
  # INPUT:  
  #       sampleR = observed correlation value
  #       nSize = sample size 
  #       nPartialR = number of partialed variables
  #       critProb = requested probability value for CDF
  #
  # OUTPUT: 
  #       ncpValue = population pearson correlation values for given P value
  #
  # Notes: (1) In order to be able to deal with multiple inputs, we must emulate the
  #            MATLAB DISTCHCK function. For the moment, this function does not accept non-scalar vectors as input
  
  # VERSION HISTORY
  #     Matlab version created 2009.11.20 - PD
  #     R version created 2018.04.08 - FST
  
  
  # Error check
  if(any(sampleR < -1 | sampleR > 1))
    stop('XECI:ncp_rho:IncorrectR', 'Observed correlation value is not > -1 and < 1.')
  if(any(nSize < 1))
    stop('XECI:ncp_rho:IncorrectN', 'Sample size is less than one.')
  if(any(nPartialR < 0))
    stop('XECI:ncp_rho:IncorrectPV', 'Number of partial variables is less than zerp.')
  if(any(critProb <= 0))
    stop('XECI:ncp_rho:IncorrectP', 'Requested P value < 0.')
  if(any(critProb >= 1))
    stop('XECI:ncp_rho:IncorrectP', 'Requested P value > 1.')
  
  # setting up output vector
  ncpValue <- rep(0,length(sampleR)) 
  
  # setting up limits of CI
  limits <- 0.99999999
  for(i in 1:length(sampleR)){
    # setting up a temporary function that is equal to "rhocdf([inputs][i]) - critProb[i]"
    f<- function(nullRho){
      XECI_rho_cdf(sampleR[i], nSize[i]-nPartialR[i], nullRho) - critProb[i] }
    ncpValue[i]<-uniroot(f, lower= - limits, upper = limits)$root
  }
  ncpValue
  return(ncpValue)
}



XECI_rho_cdf<- function(sampleR, nSize, nullRho) {
  
  #  RHOCDF calculates the CDF of the Pearson sample correlation coefficient
  #  for any given population correlation value nullRHO and sample size
  #
  # INPUT:   
  #       sampleR = sample correlation value
  #       nSize = sample size
  #       nullRho = population correlation value
  #
  # OUTPUT:
  #       probValue = Prob(-1 <= r <= rho)
  #
  # Notes: Uses higher order asymptotic expansion given in Niki & Konishi 
  #        (1984), Communications in Statistics: Simulation & Computing, 
  #        13(2), pp. 169-182
  #
  # See also xeci_corr, ncp_rho
  #
  
  #
  # VERSION HISTORY
  #     Created:    8 Dec 2009 - Matlab version
  #                 2018.04.08 - R version created FST
  
  # Note that X14 and H14 are given in the journal article but are not used in the expansion.
  # They are provided directly below for completeness with the journal content
  #
  #    x14 = x^14 
  #    h14 = x14 -  91*x12 + 3003*x10 - 45045*x08 + 315315*x06 -  945945*x04 +  945945*x02 -  135135  
  
  nSize1 <- nSize - 1  
  
  zValue_r   <- atanh(sampleR) 
  zValue_rho <- atanh(nullRho) 
  
  x = sqrt(nSize1) * ( zValue_r - zValue_rho ) 
  
  x02 = x^2 
  x03 = x^3 
  x04 = x^4 
  x05 = x^5 
  x06 = x^6 
  x07 = x^7 
  x08 = x^8 
  x09 = x^9 
  x10 = x^10 
  x11 = x^11 
  x12 = x^12 
  x13 = x^13 
  x15 = x^15 
  
  H01 = x 
  H02 = x02 -   1 
  H03 = x03 -   3*x 
  H04 = x04 -   6*x02 +    3 
  H05 = x05 -  10*x03 +   15*x 
  H06 = x06 -  15*x04 +   45*x02 -   15 
  H07 = x07 -  21*x05 +  105*x03 -  105*x 
  H08 = x08 -  28*x06 +  210*x04 -  420*x02 +     105 
  H09 = x09 -  36*x07 +  378*x05 -  1260*x03 +    945*x 
  H10 = x10 -  45*x08 +  630*x06 -  3150*x04 +   4725*x02 -     945 
  H11 = x11 -  55*x09 +  990*x07 -  6930*x05 +  17325*x03 -   10395*x 
  H12 = x12 -  66*x10 + 1485*x08 - 13860*x06 +  51975*x04 -   62370*x02 +   10395 
  H13 = x13 -  78*x11 + 2145*x09 - 25740*x07 + 135135*x05 -  270270*x03 +  135135*x 
  H15 = x15 - 105*x13 + 4095*x11 - 75075*x09 + 675675*x07 - 2837835*x05 + 4729725*x03 - 2027025*x 
  
  
  p0 = nullRho   
  p2 = nullRho^2 
  p4 = nullRho^4 
  p6 = nullRho^6 
  p8 = nullRho^8 
  
  
  a1 = p0 / 2 
  
  a2 = H03             / 12    + 
    H01 * (-p2 + 8) /  8 
  
  a3 = H04 * p0            / 24   + 
    H02 * p0 * (p2 + 8) / 16   + 
    p0 * (p2 + 5) /  8 
  
  a4 = H07                             / 288  + 
    H05 * (-5 * p2 + 56)            / 480  + 
    H03 * (-5 * p4 - 16 * p2 + 128) / 128  + 
    H01 * (-9 * p4 -  9 * p2 +  88) /  48 
  
  a5 = H08 * p0                             / 576   + 
    H06 * p0 * ( 5 * p2 + 56)            / 960   + 
    H04 * p0 * (21 * p4 + 56 * p2 + 424) / 768   + 
    H02 * p0 * (45 * p4 + 33 * p2 + 296) / 192   + 
    p0 * ( 3 * p4 +  2 * p2 +  11) /  16 
  
  a6 = H11                                              / 10368    + 
    H09 * (  -5 * p2 +  72)                          / 11520    + 
    H07 * (-175 * p4 - 784 * p2 + 7232)              / 53760    + 
    H05 * (-189 * p6 - 504 * p4 - 1296 * p2 + 10624) /  9216    + 
    H03 * (-105 * p6 -  57 * p4 -  160 * p2 +  1408) /   384    + 
    H01 * ( -75 * p6 +   2 * p4 -   19 * p2 +   384) /   128 
  
  a7 = H12 * p0                                                /  20736     + 
    H10 * p0 * (   5 * p2 +   72)                           /  23040     + 
    H08 * p0 * ( 735 * p4 + 2492 * p2 + 22396)              / 322560     + 
    H06 * p0 * (1485 * p6 + 4320 * p4 +  7464 * p2 + 59840) /  92160     + 
    H04 * p0 * ( 315 * p6 +  151 * p4 +   304 * p2 +  2576) /   1024     + 
    H02 * p0 * ( 945 * p6 -  246 * p4 +   257 * p2 +  2560) /    768     + 
    p0 * (  75 * p6 -   27 * p4 +    13 * p2 +    83) /    123 
  
  a8 = H15                                                                   /  497664   + 
    H13 * (    -5 * p2 +    88)                                           /  414720   + 
    H11 * (  -875 * p4 -  5040 * p2 + 53504)                              / 6451200   + 
    H09 * ( -6615 * p6 - 20160 * p4 - 67608 * p2 + 588352)                / 3870720   + 
    H07 * (-19305 * p8 - 63840 * p6 - 85056 * p4 - 244736 * p2 + 2015232) / 1474560   + 
    H05 * (  -693 * p8 -   345 * p6 -   448 * p4 -   1348 * p2 +   11776) /    2048   + 
    H03 * (-19845 * p8 +  7830 * p6 -  3069 * p4 -   7992 * p2 +   89216) /    9216   +
    H01 * (-11025 * p8 +  8025 * p6 -   375 * p4 -    225 * p2 +   16256) /    3840 
  
  A1 = a1 * nSize1^(-0.5) 
  A2 = a2 * nSize1^(-1.0) 
  A3 = a3 * nSize1^(-1.5) 
  A4 = a4 * nSize1^(-2.0) 
  A5 = a5 * nSize1^(-2.5) 
  A6 = a6 * nSize1^(-3.0) 
  A7 = a7 * nSize1^(-3.5) 
  A8 = a8 * nSize1^(-4.0) 
  
  sumA1toA8 = A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8 
  
  probValue = pnorm(x, 0, 1) - dnorm(x, 0, 1) * sumA1toA8 
  
  return(probValue)
}

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
