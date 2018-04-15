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