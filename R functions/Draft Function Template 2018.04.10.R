XECI_function <- ## replace function with function name (e.g., XECI_corr for correlation.)
  function(requiredInput,
           requiredInput,
           nullValue = 0,
           ciSize = 95,
           optionalInput = NaN) { ## optional inputs input as NaNs
    # insert description of function here E.g., "XECI_corr calculates effect sizes
    # and CIs for Pearson zero-order and... etc."
    
    # Dependencies ####
    # list dependencies here
    
    # Argument specifications ####
    # Specify all input arguments here
    # e.g.,:
    # sampleR    = observed correlation value
    # nSize      = sample size
    # ciSize     = confidence interval size
    # etc. 
    
    # Output specifications ####
    # Specify output here - can just be copy pasted from "output" below
    # e.g.:
    # t test results
    # "Observed t value"= tVal
    # "Degrees of freedom" = df.tVal
    # etc. 
    
    # Version history ####
    # Provide updates here in format:
    # DD.MM.YYYY - Initials
    # e.g., 
    # 01.04.2018 - PD
    
    # Functions adapted for use in this function: ####
    # # Provide source for any issues 
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
  }