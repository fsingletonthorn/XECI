xeci_lincon <-
  function(sampleMeans,
           sampleVars,
           nSize,
           contrastCoef,
           ciSize,
           iType,
           nOrder = 0,
           sampleCorr,
           userMSE,
           userDF,
           rescale
  ) {
    # insert description of function here E.g., "XECI_corr calculates effect sizes
    # and CIs for Pearson zero-order and... etc."
    #  Notes: (1) 'ci' is a percentage value (e.g., use '95' for 95% CI)
    #         (2) For raw data, first column contains unique indentifier
    #             for all B/S levels as a single vector; second (and
    #             subsequent) columns contain DV or W/S scores
    
    
    # Dependencies ####
    # list dependencies here
    
    # Argument specifications ####
    # sampleMeans = vector of cell means
    # sampleVars = k-dimensional row vector of cell sample variances for contrast
    #              OR 
    #              (k X k) variance-covariance matrix for within subjects designs
    #              OR
    #              nGroups-stacked (t X t) variance-covariance matrices for mixed subjects designs
    #              (where t = number of within-subject levels)
    # nSize = (nGroups X 1) vector for sample sizes for B/S designs (iType = 1)
    #         scalar for sample size of W/S designs (iType = 2)
    #         (nGroup X 1) vector of B/S group sample sizes for mixed designs (iType = 3,4)
    # contrastCoef = If iType <= 2: k-dimensional vector of cell contrast coefficients
    #              OR
    #             If iType = 3: j-dimensional vector of B/S contrast coefficients (j = k / nTimes)
    #              OR
    #             If iType = 4: either
    #                      (i)  i-dimensional vector of W/S contrast coefficients (i = k / nGroups)
    #                      (ii) (2 X i*j) matrix of mixed interaction contrast coefficients, with
    #                              1st row containing set of W/S coefficients, and
    #                              2nd row containing set of B/S coefficients.
    #                              (if row lengths unequal, end fill with NaNs)
    # ciSize = confidence interval size (provide a percentage value e.g., "95")
    # iType = design type, 1 = between-subjects contrast; 
    #                      2 = within-subjects contrast; 
    #                      3 = mixed design B/S contrast
    #                      4 = mixed design W/S contrast (includes mixed interaction)
    # nOrder  =  mean difference scaling value for contrast coefficients
    #                         0 = mean difference [default]
    #                         1 = order-1 for 2-way interaction, 
    #                         2 = order-2 for 3-way interaction, etc
    # sampleR = vector or matrix of residual within-subjects correlations 
    # userMSE = user-specified mean square error value
    # userDF = user-specified degrees of freedom for mean square error
    # rescale = scalar indicator for normalised rescaling (1 = YES [default], 0 = NO)
    
    # Output specifications ####
    # t test results
    # "Observed t value"= tVal
    # "Degrees of freedom" = df.tVal
    # etc. 
    
    # Version history ####
    # Provide updates here in format:
    # YYYY.MM.DD
    # 2011.10.20 - Matlab version created by PD
    # 2018.06.03 - FST adapts function from 2011.10.20 matlab version to R
    
    # Functions adapted for use in this function: ####
    # MBESS's conf.limits.nct 
    #
  
    # Input check #### 
    # # setting up warning messages - note that stopCheck acts as a binary to stop the program if there are any warnings
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
    
    #### etc. 
    
    # stopping the program if there are any warnings
    if(stopCheck == 1) {
      stop("Input error")
    }
    
    #### Calculations ####
    
    # Caclulating the rejection area (per tail)
    rejectionArea <- (1 - (ciSize / 100)) / 2
    
    ## functions #
    # set up quasi-anonymous function functions used (e.g., Fisher's r to z transform)
    
    
    ## Statistical tests results #
    # calculate test statistic, degrees of freedom, p value, etc. 
    
    
    ## calculate other statistics of interest
    
    
    # output ####
    ## Specify output and prepare for output as a list 
    # e.g., 
    output <- list(
      "Observed t value" = tVal,
      "Degrees of freedom" = df.tVal,
      "Obtained p value" = pVal.tTest,
      ### etc.,
    )
    return(output)
    # References ####
    # Smith & Smith (2018) Example paper title. Journal of Examples, 18, 271-279. doi:10.3102/10769986018003271
  }
  }



