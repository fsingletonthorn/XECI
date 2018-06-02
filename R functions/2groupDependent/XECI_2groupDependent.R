XECI_function <- ## replace function with function name (e.g., XECI_corr for correlation.)
  function(mean1,
           mean2,
           sd1,
           sd2,
           sampleR,
           nsize,
           ciSize = 95) { ## optional inputs input as NaNs
    # insert description of function here E.g., "XECI_corr calculates effect sizes
    # and CIs for Pearson zero-order and... etc."
    
    # Dependencies ####
    # list dependencies here
    
    # Argument specifications ####
    # mean1 = mean group 1
    # mean2 = mean group 2
    # sd1   = standard deviation group 1
    # sd2,  = standard deviation group 2
    # sampleR  = sample pearson correlation 
    # n     = sample size
    # ciSize = confidence interval width (%)
    
    # Output specifications ####
    # Specify output here - can just be copy pasted from "output" below

    # Version history ####
    # YYYY.MM.DD
    # 2018.06.02 - FST
    
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
    # Check if means are numbers
    if (!is.numeric(mean2) | !is.numeric(mean1)) {
      warning("Sample means must be numbers")
      stopCheck<-1
    }
    # Check if standard deviations are numbers
    if (!is.numeric(sd1) | !is.numeric(sd2)) {
      warning("Standard deviations must be numbers")
      stopCheck<-1
    }
    # Check if standard deviations are numbers
    if (!is.numeric(ciSize) | (ciSize <= 0) | (ciSize >= 100)) {
      warning("CI size must be a number between 0 and 100 (exclusive)")
      stopCheck<-1
    }
    
    # stopping the program if there are any warnings
    if(stopCheck == 1) {
      stop("Input error")
    }
    
    #### Calculations ####
    
    # Caclulating the rejection area (per tail)
    rejectionAreas <- c(((1 - (ciSize / 100)) / 2),( 1-(1 - (ciSize / 100)) / 2) )
  
    # degrees of freedom
    df <- nSize - 1
    # df2 used below
    df2 <- df - 2
    
    # Sqrt n
    sqrtNSize = sqrt(nSize)
    
    # critical values
    tCrit = -qt(rejectionAreas, df)
    zCrit = -qnorm(rejectionAreas,0,1)

    # Bias corrections ####
    # Hedges bias adjustment weight from Gibbons, Hedeker & Davis (1993) equation 7, p. 274  
    jCorrection <- exp(lgamma(df/2)) / (sqrt(df/2)*exp(lgamma((df-1)/2)) )
    
    # Olkin & Pratt unbiased estimate of r
    unbiasedR <- sampleR * hypergeomF(.5, .5, ((df-1)/2),  1-sampleR^2)

    # Used below in calculating variances for group difference cases
    sampleRAdj <- 2 *(1-sampleR)
    unbiasedRAdj<- 2*(1-unbiasedR)
    
    # Gibbons et al's rationale (called individual change/repeated measures
    # in Morris & DeShon & notated as delta_RM; called delta_D in Viechtbauer)
    # Raw mean difference ####
    meanDiff <- mean1 - mean2
    var <- sd1 * sd1 + sd2*sd2 - 2*sd1 * sd2 * sampleR
    
    # mean difference CIs ####
    ciMeanDiff <- meanDiff + (tCrit * (sqrt(var)/sqrtNsize))
    
    # Biased hedges g ####
    hedgesGChange = meanDiff / sqrt(var)
    # Hedges correction applied to g
    cohenDChange = hedgesGChange * jCorrection
    
    # Hedges' g for standardized group difference
    sdPooledGrp1 = sdGrp1;                                              
    hedgesGDiff = meanDiff / sdPooledGrp1;                            
    cohenDDiff = hedgesGDiff * jCorrection; 
    
    # t test ####
    tVal <- hedgesGChange * sqrt(nSize)
    pVal <- 2 * pt(abs(tVal), df, lower.tail = FALSE)
  
    #### Variance calculations ####
    #[*** = recommended by Viechtbauer, 2007] 
    # 2 dependent case for delta_D which corresponds to individual change
    # (Viechtbauer, 2007, Table 1)
    
    var_g1B = (df * (1 + (nSize * hedgesGChange * hedgesGChange))) / ...
    (df2 * nSize) - ...
    (hedgesGChange * hedgesGChange) / ...
    (jCorrection * jCorrection);                                        # Variance for g (Viechtbauer, 2007, Eq. 23)
    
    var_d1B = (jCorrection * jCorrection * df * ...
               (1 + (nSize * dCohen_change * dCohen_change))) / ...
    (df2 * nSize) - ...
    (dCohen_change * dCohen_change);                                    # Variance for d (Viechtbauer, 2007, Eq. 24)
    
    var_g1U = (1 / (nSize * jCorrection * jCorrection)) + ...
    (1 - (df2/(df * jCorrection * jCorrection))) * ...
    (hedgesGChange * hedgesGChange);                                  # Variance for g (Viechtbauer, 2007, Eq. 25)
    
    var_d1U = (1 / nSize) + ...
    (1-(df2/(df * jCorrection * jCorrection))) * ...
    (dCohen_change * dCohen_change);                                    # Variance for d (Viechtbauer, 2007, Eq. 26)
    
    var_g1L1 = (1 / nSize) + ...
    ((hedgesGChange * hedgesGChange) / (2*df));                       # Variance for g (Viechtbauer, 2007, Eq. 28) (*** dL1)
    
    var_d1L1 = (1 / nSize) + ...
    ((dCohen_change * dCohen_change) / (2*df));                         # Variance for d (Viechtbauer, 2007, Eq. 29)
    
    var_g1L2 = (1 / nSize) + ...
    ((hedgesGChange * hedgesGChange) / (2*nSize));                    # Variance for g (Viechtbauer, 2007, Eq. 30)
    
    var_d1L2 = (1 / nSize) + ...
    ((dCohen_change * dCohen_change) / (2*nSize));                      # Variance for d (Viechtbauer, 2007, Eq. 31)
    
    
    # 2 dependent case for delta_D2 which corresponds to group differences
    # (Viechtbauer, 2007, Table 2)
    
    var_g2B = (df * (sampleR_adj + (nSize * hedgesGDiff * hedgesGDiff))) / 
          (df2 * nSize) - (hedgesGDiff * hedgesGDiff) / (jCorrection * jCorrection)                                        # Variance for g (Viechtbauer, 2007, Eq. 34)
    
    var_d2B = (jCorrection * jCorrection * df * ...
               (sampleR_adj + (nSize * cohenDDiff * cohenDDiff))) / ...
    (df2 * nSize) - ...
    (cohenDDiff * cohenDDiff);                                        # Variance for d (Viechtbauer, 2007, Eq. 35)
    
    var_g2U = (unbiasedR_adj / (nSize * jCorrection * jCorrection)) + ...
    (1 - (df2 / (df * jCorrection * jCorrection))) * ...
    (hedgesGDiff * hedgesGDiff);                                      # Variance for g (Viechtbauer, 2007, Eq. 36)
    
    var_d2U = (unbiasedR_adj / nSize) + ...
    (1 - (df2 / (df * jCorrection * jCorrection))) * ...
    (cohenDDiff * cohenDDiff);                                        # Variance for d (Viechtbauer, 2007, Eq. 37)
    
    var_g2L1 = (sampleR_adj / nSize) + ...
    ((hedgesGDiff * hedgesGDiff) / (2 * df));                         # Variance for g (Viechtbauer, 2007, Eq. 39)
    
    var_d2L1 = (sampleR_adj / nSize) + ...
    ((cohenDDiff * cohenDDiff) / (2 * df));                           # Variance for d (Viechtbauer, 2007, Eq. 40) *** gL1 < 1
    
    var_g2L2 = (sampleR_adj / nSize) + ...
    ((hedgesGDiff * hedgesGDiff) / (2 * nSize));                      # Variance for g (Viechtbauer, 2007, Eq. 41) *** dL2 > 1
    
    var_d2L2 = (sampleR_adj / nSize) + ...
    ((cohenDDiff * cohenDDiff) / (2 * nSize));                        # Variance for d (Viechtbauer, 2007, Eq. 42)
    
    var_dd = (sampleR_adj / nSize) + ...
    ((dDunlap_diff * dDunlap_diff) / (2 * nSize));                      # Variance estimate of Dunlap's d based on Viechtbauer, 2007, Eq. 41 / 42)


    # Bonett separate variance standardizer
    # specifying covaraince matrix 
        sampleCov <- diag(c(sd1^2, sd2^2))
        sampleCov[2,1] <- sd1 * sampleR * sd2
        sampleCov[1,2] <- sd1 * sampleR * sd2

        tmp <- xeci_lincon(c(meanGrp1, meanGrp2), sampleCov, nSize, c(1, -1), ciSize, 2, 0, nDecs)

        dBonett   = tmp1(2);
        ciBonett  = tmp2(2,:);
        varBonett = tmp4(3);
    else
        dBonett   = NaN;
        ciBonett  = [NaN NaN];
        varBonett = NaN;
    end



    
    
    
    # output ####
    ## Specify output and prepare for output as a list 
    # e.g., 
    tTest <- list(
      "Observed t value" = tVal,
      "Degrees of freedom" = df,
      "Obtained p value" = pVal)
    
    output <- list(
      "t-test results" = tTest,
    )
      
      # References #### 
      # Gibbons, R. D., Hedeker, D. R., & Davis, J. M. (1993). Estimation of Effect Size From a Series of Experiments Involving Paired Comparisons. Journal of Educational Statistics, 18, 271-279. doi:10.3102/10769986018003271
      # Viechtbauer, W. (2007). Approximate Confidence Intervals for Standardized Effect Sizes in the Two-Independent and Two-Dependent Samples Design. Journal of Educational and Behavioral Statistics, 32(1), 39-60. doi:10.3102/1076998606298034
    )
    return(output)
  }