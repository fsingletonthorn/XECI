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