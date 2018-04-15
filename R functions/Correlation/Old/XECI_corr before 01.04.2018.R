XECI_corr <-
  function(sampleR,
           nSize,
           nullRho = 0,
           ciSize = 95,
           nPartialR = NaN) {
    # XECI_corr calculates effect sizes and CIs for Pearson zero-order and
    # partial correlations, and CI for Spearman rank-order correlation (if
    # Spearman correlation entered as input value)
    
    # Dependencies ####
    # move these to seperate functions in the package
    
    # function that checks  if argument is a whole number
    is.wholeNumber <- function(x, tol = .Machine$double.eps ^ 0.5) {
      if (!is.numeric(x)) {
        return(FALSE)
      }
      abs(x - round(x)) < tol
    }
    
    # Argument specifications ####
    # sampleR    = observed correlation value
    # nSize      = sample size
    # ciSize     = confidence interval size
    # nullRho    = null hypothesised rho value
    # nPartialR  = number of partialled variables
    
    # Output specifications ####
    #t test results
    # "Observed t value"= tVal
    # "Degrees of freedom" = df.tVal
    # "Obtained p value" = pVal.tTest
    # "partial correlation"= sampleR
    # "Fisher\'s_r_to_z_CIs" = fisher.RToZ.CIs
    # "Unbiased Fisher\'s r to z" = unbiasedR
    # "Unbiased Fisher\'s r to z CIs" = unbiased.RToZ.CIs
    # "Exact (sample) CIs" = exactSample.CIs
    # "Exact (unbiased) CIs" = unbiasedExact.CIs
    
     # The following have been copied from XECI (01.04.2018): 
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
    # 01.04.2018 - FST creates function - Only Fisher's r to z cis are calculated, 
    
    # Functions adapted for use in this function: ####
    #
    #
    
    # Input check ####
    # Check if sampleR is a number from -1 to 1
    if ((sampleR > 1) | (sampleR < -1) | !is.numeric(sampleR)) {
      warning("Sample r must be a number between -1 and +1, inclusive")
    }
    # Check if nSize is a whole number above 0 # REQUIRES is.wholeNumber function
    if ((nSize < 1) | !is.wholeNumber(nSize)) {
      warning("Sample size must be a whole number above 0")
    }
    # Check if CISize is a number between 1-99
    if ((ciSize <= 0) | (ciSize >= 100) | !is.numeric(ciSize)) {
      warning("Confidence interval width must be a number between 0 and 100, non-inclusive")
    }
    # Check if nullRho is a number between -1 to 1
    if ((nullRho > 1) | (nullRho < -1) | !is.numeric(nullRho)) {
      warning("Null Rho must be a number between -1 and +1, inclusive")
    }
    # Check if nPartialR is a whole number above 0 # REQUIRES is.wholeNumber function
    if ((!is.nan(nPartialR)) &
        ((nPartialR < 1) | !is.wholeNumber(nPartialR))) {
      warning("The number of partialled variables must be a whole number above 0")
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
    
    # Caclulating the rejection area (per tail)
    rejectionArea <- (1 - (ciSize / 100)) / 2
    
    # calculating critical z for rejection area
    zCritical <-  -qnorm(rejectionArea)
    
    # t test
    # calculating t statistic
    tVal <- (sampleR * sqrt(nSize - 2)) / sqrt(1 - (sampleR ^ 2))
    # calculating df
    df.tVal <- nSize - 2
    # calculating p value
    pVal.tTest <- 2 * pt(tVal, df.tVal, lower.tail = FALSE)
    
    # Olkin and Pratt's (1958) unique minimum variance unbiased estimator of rho
    unbiasedR <- sampleR ## FIX THIS LATER
    
    # Fisher's r to z CIs ####
    
    #calculating standard error
    SE <- 1 / sqrt(nSize - 3)
    #transforming r to z
    z <- fisher.r2z(sampleR)
    # calculating CIs
    upperBound <- z + zCritical * SE
    lowerBound <- z - zCritical * SE
    CIsZ <- c(lowerBound, upperBound)
    fisher.RToZ.CIs <- fisher.z2r(CIsZ)
    
    #  THE FOLLOWING NEED TO BE FIXED: ####
    
    # Unbiased r CIs ####
    unbiased.RToZ.CIs <- fisher.RToZ.CIs ## THIS NEEDS TO BE FIXED
    
    # Exact (sample) CIs ####
    exactSample.CIs  <- fisher.RToZ.CIs ## THIS NEEDS TO BE FIXED
    
    # Exact (population) CIs ####
    unbiasedExact.CIs  <- fisher.RToZ.CIs ## THIS NEEDS TO BE FIXED
    
    # output
    output <- list(
      "Observed t value" = tVal,
      "Degrees of freedom" = df.tVal,
      "Obtained p value" = pVal.tTest,
      "partial correlation" = sampleR,
      "Fisher\'s_r_to_z_CIs" = fisher.RToZ.CIs,
      "Unbiased Fisher\'s r to z" = unbiasedR,
      "Unbiased Fisher\'s r to z CIs" = unbiased.RToZ.CIs,
      "Exact (sample) CIs" = exactSample.CIs,
      "Exact (unbiased) CIs" = unbiasedExact.CIs
    )
    return(output)
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
