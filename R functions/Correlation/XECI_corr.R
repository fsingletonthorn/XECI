XECI_corr <-
  function(sampleR,
           nSize,
           nullRho = 0,
           ciSize = 95,
           partial = FALSE,
           nPartialR = 0) {
    # XECI_corr calculates effect sizes and CI for Pearson zero-order and
    # partial correlations. If Partial = TRUE, nPartial must be specified 
    # for meaningful results. 
    
    # Dependencies ####
    # Requires XECI_rho_cdf, XECI_ncp_rho, hypergeomF, is.wholeNumber
    
    # Argument specifications ####
    # sampleR    = observed correlation value
    # nSize      = sample size
    # ciSize     = confidence interval size
    # nullRho    = null hypothesised rho value
    # partial    = 1 if partial correlation provided, 0 if not 
    # nPartialR  = number of partialled variables
    
    # Output specifications ####
    # t test results
    # "Observed t value"= tVal
    # "Degrees of freedom" = df.tVal
    # "Obtained p value" = pVal.tTest
    # Point estimates
    # "partial correlation"= sampleR
    # "Unbiased Fisher\'s r to z" = unbiasedR
    # Confidence intervals
    # "Fisher\'s r to z CI" = fisher.RToZ.CI
    # "Unbiased Fisher\'s r to z CI" = unbiased.RToZ.CI
    # "Exact (sample) CI" = exactSample.CI
    # "Exact (unbiased) CI" = unbiasedExact.CI
    
    # VERSION HISTORY ####
    # 01.04.2018 - FST creates function - Only Fisher's r to z CI are calculated
    # 08.04.2018 - FST updates function with other functionality - does not account for partial correlations yet
    # 22.04.2018 - FST updates function with other functionality - accounts for partial correlations,  does not account for spearman correlation
    
    # Package from which functions were adapted for use in this function: ####
    #
    #
    
    # Input check ####
    # if partial does not equal 1, set npartialR to 0
    if(partial == FALSE){ nPartialR <- 0}
    # setting up a error message 
    stopCheck<-0
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
    # Check if nPartialR is a whole number equal or greater than 0
    if (((nPartialR <0) | !is.wholeNumber(nPartialR))) {
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
    SE <- 1 / sqrt(nSize- nPartialR - 3) 
    
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
    unbiasedR <- sampleR * hypergeomF(0.5, 0.5, (nSize-1-nPartialR)/2, 1 - sampleR^2)
  
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
    exactSample.CI <- 1
    exactSample.CI[1]  <- XECI_ncp_rho(sampleR, nSize-nPartialR, nPartialR, probCI[1])
    exactSample.CI[2]  <- XECI_ncp_rho(sampleR, nSize-nPartialR, nPartialR, probCI[2])
    # Exact (population) CI ####
    unbiasedExact.CI <- 1
    unbiasedExact.CI[1]  <- XECI_ncp_rho(unbiasedR, nSize-nPartialR, nPartialR, probCI[1])
    unbiasedExact.CI[2]  <- XECI_ncp_rho(unbiasedR, nSize-nPartialR, nPartialR, probCI[2])
    
    # output
    
    tTestOutput<-list("Observed t value" = tVal,
                      "Degrees of freedom" = df.tVal,
                      "Obtained p value" = pVal.tTest)
    pointEstimateOutput<-list("Sample correlation" = sampleR,
                              "Unbiased R" = unbiasedR)
    CIsOutput<-list("Fisher\'s r to z CI, sample r" = fisher.RToZ.CI,
                    "Fisher\'s r to z CI, unbiased r" = unbiased.RToZ.CI,
                    "Exact CI, sample r" = exactSample.CI,
                    "Exact CI, unbiased r" = unbiasedExact.CI)

    
    output <- list(tTestOutput,pointEstimateOutput,CIsOutput)
    return(output)
    
  #References####
    # Olkin, I., & Pratt, J. W. (1958). Unbiased Estimation of Certain Correlation Coefficients. The Annals of Mathematical Statistics, 29(1), 201-211.  Retrieved from http://www.jstor.org.ezp.lib.unimelb.edu.au/stable/2237306
    # Pearson, J. W. (2009). Computation of hypergeometric functions (Masters dissertation, University of Oxford).
  }