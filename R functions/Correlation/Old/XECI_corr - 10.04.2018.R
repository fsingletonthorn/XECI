# library(spssstatistics) # "spssstatistics" not necessary for the current function moment - BUT this has output testing below, be warned, not final version of the function!!

XECI_corr <-
  function(sampleR,
           nSize,
           nullRho = 0,
           ciSize = 95,
           nPartialR = 0) {
    # XECI_corr calculates effect sizes and CI for Pearson zero-order and
    # partial correlations, and CI for Spearman rank-order correlation (if
    # Spearman correlation entered as input value). If nPartialR > 0, 
    # partial correlations are reported
    
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
    # Pearson, J. W. (2009). Computation of hypergeometric functions (Masters dissertation, University of Oxford).!
  }

# OUTPUT setting ####
spsspkg.StartProcedure("XECI output")
spsspivottable.Display(t(as.data.frame(output[1:3])), title = "Findings for statistical tests", collabels = "Value")
spsspivottable.Display(t(as.data.frame(output[c(4, 6)])), title = "Correlation coefficents", collabels = "Value")
spsspivottable.Display(
  t(as.data.frame(output[c(5, 7, 8, 9)])),
  title = "Confidence intervals",
  collabels = c("Lower limit", "Upper limit")
)
spsspkg.EndProcedure()
