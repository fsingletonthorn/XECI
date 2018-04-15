function [esXECI, ciXECI, tsXECI] = xeci_regCov(sampleCov, nSize, ciSize, displayOut)
% XECI_REG calculates CIs for unstandardized and standardized regression coefficients, plus
% semipartial corrrelations, and improvement in R-sq coefficients (i.e., squared semipartial coefficients)
%
%   INPUT:
%
%       EITHER:
%           coeff       = unstandardised regression coefficient for IV (type1 = 1)
%       OR:
%                         semipartial correlation coefficient (type1 = 2)
%       PLUS:
%           sampleRsq   = observed R-squared for overall regression model
% 
%       EITHER:
%           toleranceIV = tolerance       (if iType2 = 1) 
%       OR
%                         standard error  (if iType2 = 2)
%       PLUS:
%           nSize       = sample size
%           nIVars      = number of IVs
%           sdYvar      = sample standard deviation of DV
%           sdXvar      = sample standard deviation of focal IV
%           corrXY      = correlation between DV and focal IV
%           iType1      = type of input 
%                           (1 = regression coefficient; 2 = semipartial correlation [requires type2 = 2])
%           iType2      = type of input 
%                           (1 = tolerance of k-th IV;   2 = standard error of k-th IV)
%           ciSize      = confidence interval size            (*1)
%           displayOut  = display output {1 = yes, 0 = no}    (*2)
%
%
% 
%   OUTPUT:
%           esXECI = (4 X 1) vector of point estimates of effect sizes 
%                       Unstandardised b coefficient
%                       Beta coefficient
%                       Semipartial r
%                       Squared semipartial r
%
%           ciXECI = (22 X 2) matrix of  lower and upper bound CI estimates of effect sizes
%                       Large sample b coefficient                                                (1)
%                       Std. regression coefficient (N t-based)                                   (2)
%                       Std. regression coefficient (N z-based)                                   (3)
%                       Std. regression coefficient (N t-based unbiased)                          (4)
%                       Std. regression coefficient (N-3 t-based)                                 (5)
%                       Std. regression coefficient (N-3 z-based)                                 (6)
%                       Std. regression coefficient (N-3 t-based unbiased)                        (7)
%                       Std. regression coefficient (df t-based)                                  (8)
%                       Std. regression coefficient (df z-based)                                  (9)
%                       Std. regression coefficient (df t-based unbiased)                        (10)
%                       Semipartial  (df Aloe-Becker t-based: Symmetric)                         (11)
%                       Semipartial  (df Aloe-Becker-Unbiased t-based: Symmetric)                (12)
%                       Semipartial  (N Aloe-Becker z-based: Symmetric)                          (13)
%                       Semipartial  (df Aloe-Becker-Unbiased z-based: Symmetric)                (14)
%                       Semipartial  (df Aloe-Becker t-based: Arctanh)                           (15)
%                       Semipartial  (df Aloe-Becker-Unbiased t-based: Arctanh)                  (16)
%                       Semipartial  (N Aloe-Becker z-based: Arctanh)                            (17)
%                       Semipartial  (df Aloe-Becker-Unbiased z-based: Arctanh)                  (18)
%                       Sq. semipartial  (df Aloe-Becker t-based: Symmetric)                     (19)
%                       Sq. semipartial  (df Aloe-Becker-Unbiased t-based: Symmetric)            (20)
%                       Sq. semipartial  (N Aloe-Becker z-based: Symmetric)                      (21)
%                       Sq. semipartial  (df Aloe-Becker-Unbiased z-based: Symmetric)            (22)
%                       Sq. semipartial  (df Aloe-Becker t-based: Arctanh)                       (23)
%                       Sq. semipartial  (df Aloe-Becker-Unbiased t-based: Arctanh)              (24)
%                       Sq. semipartial  (N Aloe-Becker z-based: Arctanh)                        (25)
%                       Sq. semipartial  (df Aloe-Becker-Unbiased z-based: Arctanh)              (26)
%
%
%           tsXECI = (19 X 1) vector of t test results:
%                       Observed t value                                                          (1)
%                       Standard error of b coefficient                                           (2)
%                       Degrees of freedom                                                        (3)
%                       Obtained P value                                                          (4)
%                       Tolerance of IV (unadjusted)                                              (5)
%                       Tolerance of IV (unbaised)                                                (6)
%                       Observed R-sq value                                                       (7)
%                       Unbiased R-sq value                                                       (8) 
%                       Squared semipartial correlation                                           (9)
%                       Standard error for beta (large-sample N)                                 (10)
%                       Standard error for beta (large-sample N unbiased)                        (11)
%                       Standard error for beta (large-sample N-3)                               (12)
%                       Standard error for beta (large-sample N-3 unbiased)                      (13)
%                       Standard error for beta (large-sample df)                                (14)
%                       Standard error for beta (large-sample df unbiased )                      (15)
%                       Standard error for sr (large-sample df)                                  (16)
%                       Standard error for sr (large-sample df unbiased)                         (17)
%                       Standard error for sr (large-sample N)                                   (18)
%                       Standard error for sr (large-sample N unbiased)                          (19)
%
%
%
%
%  Notes:   (*1) CI argument is a percentage value (e.g., use '95' for 95% CI)
%
%           (*2) Argument DPO provides formated output to screen (1 = YES or 0 = NO)
%
%
% See also ncp_t, hypergeomF
%

%
%   VERSION HISTORY
%        Created:    12 Jul 2010 
%        Revision:   18 Aug 2010 ~   adjusted sr2 using 4 different estimators 
%        Revision:   14 Jul 2011 ~   closed-form Olkin-Pratt using first 7 
%                                      terms of expansion
%                                ~   MBESS form of confidence intervals based 
%                                      on df in denominator rather than N
%        Revision:    6 Dec 2013 ~   Removed textbook large-sample Beta SE and
%                                      CI, and replaced with Yuan-Chan ;
%                                      Removed Aloe-Becker Z version of CI
%
% 


%% Initialise output arguments

   esXECI = [] ;
   ciXECI = [] ;
   tsXECI = [] ;
   

%% Initial check of input arguments ---------------------------------------
    if nargin < 3
       error('xeci:reg:TooFewInputs','Requires at least 3 input arguments.') ;
    end

    if nargin == 3
       displayOut = 0 ;
    end ;
    
% Generates Dialog Box error messages for input errors 
 
    if (nSize <= 0)
       errordlg('Sample size is less than or equals 0 ', ...
                'Input Entry Error' ) ;
       return
    end
    
    if (ciSize <= 0 || ciSize >= 100)
       errordlg('Confidence interval value < 0 or > 100 ', ...
                'Input Entry Error' ) ;
       return
    end
    
    nVars = length(sampleCov) ;
    nIVars = nVars - 1;
    
    yCov = sampleCov(2:nVars,1) ;
    
    xCov = sampleCov(2:nVars,2:nVars);
    xCorr = covcorr(xCov) ;
    
    sampleCorr = covcorr(sampleCov) ;
    xSDs = sqrt(diag(xCov)) ;
    ySD = sqrt(sampleCov(1,1)) ;
    
    
 
    
%% Some preliminary calculations used throughout the remainder of the function 

    % Adjustment of CI width indicated by decimal number
    if (ciSize > 0 && ciSize < 1)
        ciSize = ciSize * 100 ;
    end

    df = nSize - nIVars - 1 ;
    alpha = 1 - ciSize/100 ;

    pci = [((100-ciSize)/200) ((100+ciSize)/200)] ;                         % P values for defining CI bounds
    tci = tinv(pci, df) ;                                                   % critical t values for lower and upper bound 
    
    zci = norminv(pci,0,1) ;
    
    tci1side = tinv( ciSize/100, df) ;                                      % critical t values for 1-sided interval
    zci1side = norminv( ciSize/100, 0, 1) ;                                 % critical z values for 1-sided interval
    
    tci1side = tci1side .* [-1 1] ;
    zci1side = zci1side .* [-1 1] ;
    
    
    % Calculate all coefficients based on full sample covariance matrix
    
    bCoeffs = inv(xCov) * yCov ;                                           %#ok<*MINV>
    tolCoeffs = 1 ./ diag(inv(xCorr)) ;
    sbCoeffs = bCoeffs .* xSDs ./ ySD ;
    
    srCoeffs = sbCoeffs .* sqrt(tolCoeffs) ;
    srSqs = srCoeffs.^2 ;
    
    sampleRsq = 1 - (det(sampleCorr) / det(sampleCorr(2:nVars,2:nVars))) ;
    
    seBCoeffs = (ySD ./ xSDs) .* sqrt( (1-sampleRsq) ./ (tolCoeffs .* df) ) ;

    tValues = bCoeffs ./ seBCoeffs ;                                              % Null hypothesised t value for k-th IV
    pValues = 2 * (1 - tcdf(abs(tValues), df)) ;                                  % Observed 2-tailed P value for observed pooled variance t statistic
    
    
    
    % Extract relevant coefficients for k-th IV from previous results
    
    bCoeff = bCoeffs(nIVars) ;
    sbCoeff = sbCoeffs(nIVars) ;
    srCoeff = srCoeffs(nIVars) ;
    srSq = srSqs(nIVars) ;
    toleranceIV = tolCoeffs(nIVars) ;
    
    sdYvar = ySD ;
    sdXvar = xSDs(nIVars) ;
    corrXY = sampleCorr(nVars,1) ;
    
    tValue = tValues(nIVars) ;
    pValue = pValues(nIVars) ;

    seReg = seBCoeffs(nIVars) ;
    
    % Calculate ASYMCOV for SAMPLECOV under normality assumotions
    
    kpMat = ktrans(nVars) ;
    
    vecCovN = vech(sampleCov) ;                                        % Non-duplicated elements of SAMPLECOV
    asymCovN = 2 * kpMat' *kron(sampleCov, sampleCov) * kpMat ;        % Normal-theory asymptotic covariance matrix

    
    % Calculate Jacobians for Beta and Semipartial Correlation
    
    adimat_derivclass('opt_derivclass') ;                              % Initialise automatic differentiation functions
    g_vC = createFullGradients(vech(sampleCorr)) ;
  
    [JbetaN, ~] = g_betaCalc(g_vC, vecCovN) ;
    [JsrN,   ~] = g_srCalc(g_vC, vecCovN) ;
                       
                       

%% Unbiased estimates of overall R-sq

    if nSize < 50 && nIVars < 10
        r2_u = adj_r2_u(sampleRsq, nSize, nIVars) ;                         % Olkin-Pratt unbiased estimator
    else
        r2_u = adj_r2_c(sampleRsq, nSize, nIVars) ;                         % Closed-form Olkin-Pratt unbiased estimator using first 7 expansion terms
    end

   
%% Shrunken estimates of tolerance and corresponding signal:noise ratios 
% associated with regression of k-th IV on all remaining IVs

    r2k = 1 - toleranceIV ;

    if nSize < 50 && nIVars < 10
        tol_u = 1 - adj_r2_u(r2k, nSize, nIVars-1) ;                        % Olkin-Pratt unbiased estimator
    else
        tol_u = 1 - adj_r2_c(r2k, nSize, nIVars-1) ;                        % Closed-form Olkin-Pratt unbiased estimator using first 7 expansion terms
    end
   

   
%% Large-sample SE for semipartial correlation (Aloe & Becker, 2012)
  
%     varSR =  JsrN * asymCovN * JsrN' ;
%     varSR = varSR(nIVars,nIVars) ;
%     
%     seSRdf = sqrt(varSR / df) ;
%     seSRdf_u = srStdError(r2_u, r2_u-srSq, df) ;
% 
%     seSRn = sqrt(varSR / nSize) ;                                     % Temporary for EPM paper
%     seSRn_u = srStdError(r2_u, r2_u-srSq, nSize) ;                % Temporary for EPM paper
%     
%     if isnan(seSRdf_u)
%        seSRdf_u = seSRdf ;
%     end ;
%     
%     if isnan(seSRn_u)
%        seSRn_u = seSRn ;
%     end ;

   
%% Large-sample SE for standardized regression coefficient (Yuan & Chan, 2011)
    
%     varBeta = JbetaN * asymCovN * JbetaN' ;
%     varBeta = varBeta(nIVars,nIVars) ;
% 
%     covXY = corrXY * sdYvar * sdXvar ;
%     
%     iCxx = (1/toleranceIV) / sdXvar^2 ;
%     
%     seBN3 = sqrt(varBeta / (nSize - 3)) ;                                          % Yuan-Chan SE for standardized regression coefficient using N-3
%     
%     seBdf = sqrt(varBeta / df) ;                                                   % Yuan-Chan SE for standardized regression coefficient using DF
%     
%     seBN3_u = seBeta(sbCoeff, sdXvar^2, sdYvar^2, r2_u, iCxx, covXY, nSize-3) ;  % Unbiased Yuan-Chan SE for standardized regression coefficient using N-3
%     
%     seBdf_u = seBeta(sbCoeff, sdXvar^2, sdYvar^2, r2_u, iCxx, covXY, df) ;       % Unbiased Yuan-Chan SE for standardized regression coefficient using DF
%     
%     if isnan(seBN3_u)
%        seBN3_u = seBN3 ;
%     end ;
%     
%     if isnan(seBdf_u)
%        seBdf_u = seBdf ;
%     end ;

   
%% Final calculations -----------------------------------------------------


%% Large-sample SE for semipartial correlation (Aloe & Becker, 2012)
  
    varSR =  JsrN * asymCovN * JsrN' ;
    varSR = varSR(nIVars,nIVars) ;

    seSRdf   = sqrt(varSR / df) ;
    seSRdf_u = srStdError(r2_u, r2_u-srSq, df) ;

    seSRn = sqrt(varSR / nSize) ;
    seSRn_u = srStdError(r2_u, r2_u-srSq, nSize) ;
    
    if isnan(seSRdf_u)
       seSRdf_u = seSRdf ;
    end ;
    
    if isnan(seSRn_u)
       seSRn_u = seSRn ;
    end ;

   
%% Large-sample SE for standardized regression coefficient (Yuan & Chan, 2011)
    
    varBeta = JbetaN * asymCovN * JbetaN' ;
    varBeta = varBeta(nIVars,nIVars) ;

    covXY = corrXY * sdYvar * sdXvar ;
    
    iCxx = (1/toleranceIV) / sdXvar^2 ;
    
    seBN    = sqrt(varBeta / nSize)  ;                                               % Yuan-Chan SE for standardized regression coefficient using N-3
    seBN_u  = seBeta(bCoeff, sdXvar^2, sdYvar^2, r2_u, iCxx, covXY, nSize) ;        % Unbiased Yuan-Chan SE for standardized regression coefficient using N-3
    
    seBN3   = sqrt(varBeta / (nSize-3))  ;                                           % Yuan-Chan SE for standardized regression coefficient using N-3
    seBN3_u = seBeta(bCoeff, sdXvar^2, sdYvar^2, r2_u, iCxx, covXY, nSize-3) ;      % Unbiased Yuan-Chan SE for standardized regression coefficient using N-3
    
    seBdf   = sqrt(varBeta / df) ;                                                   % Yuan-Chan SE for standardized regression coefficient using DF
    seBdf_u = seBeta(bCoeff, sdXvar^2, sdYvar^2, r2_u, iCxx, covXY, df) ;           % Unbiased Yuan-Chan SE for standardized regression coefficient using DF
    
    if isnan(seBN3_u)
       seBN3_u = seBN3 ;
    end ;
    
    if isnan(seBdf_u)
       seBdf_u = seBdf ;
    end ;
   
%% Final calculations -----------------------------------------------------


    bci_ls = bCoeff + (tci * seReg) ;                                       % CI for unstandardized regression coefficient (large sample)

    betaci_N    = sbCoeff + (tci * seBN) ;                                    % CI for standardized regression coefficient (large sample)
    betaci_N_z  = sbCoeff + (zci * seBN)  ;
    betaci_N_u  = sbCoeff + (tci * seBN_u)  ;

    betaci_N3   = sbCoeff + (tci * seBN3) ;                                   % CI for standardized regression coefficient (large sample)
    betaci_N3_z = sbCoeff + (zci * seBN3)  ;
    betaci_N3_u = sbCoeff + (tci * seBN3_u)  ;
    
    betaci_df   = sbCoeff + (tci * seBdf) ;                                   % CI for standardized regression coefficient (large sample)
    betaci_df_z = sbCoeff + (zci * seBdf)  ;
    betaci_df_u = sbCoeff + (tci * seBdf_u)  ;
    

    % Large-sample semipartial---Aloe & Becker (2012)
    srci_lst    = srCoeff + (tci * seSRdf) ;                                  % CI for semipartial correlation (Aloe-Becker)
    srci_lst_u  = srCoeff + (tci * seSRdf_u) ;                                % CI for semipartial correlation (Aloe-Becker-Unbiased)
    
    srci_lsnz   = srCoeff + (zci * seSRn) ;                                   % CI for semipartial correlation (Aloe-Becker original)
    srci_lsz_u  = srCoeff + (zci * seSRdf_u) ;                                % CI for semipartial correlation (Aloe-Becker-Unbiased)

    
    % Large-sample semipartial---Aloe & Becker (2012):  ARCTANH transformed
    srci_lstt    = transCIxeci(srCoeff, seSRdf, tci(2), 1) ;                   % CI for semipartial correlation (Aloe-Becker)
    srci_lstt_u  = transCIxeci(srCoeff, seSRdf_u, tci(2), 1) ;                 % CI for semipartial correlation (Aloe-Becker-Unbiased)
    
    srci_lsnzt   = transCIxeci(srCoeff, seSRn, zci(2), 1) ;                    % CI for semipartial correlation (Aloe-Becker original)
    srci_lszt_u  = transCIxeci(srCoeff, seSRdf_u, zci(2), 1) ;                 % CI for semipartial correlation (Aloe-Becker-Unbiased)

    
    % CI for squared semipartial correlation
    if pValue < alpha

        sr2ci_lst    = sort(srci_lst.^2) ;
        sr2ci_lst_u  = sort(srci_lst_u.^2) ;
        sr2ci_lsnz   = sort(srci_lsnz.^2) ;
        sr2ci_lsz_u  = sort(srci_lsz_u.^2) ;

        sr2ci_lstt   = sort(srci_lstt.^2) ;
        sr2ci_lstt_u = sort(srci_lstt_u.^2) ;
        sr2ci_lsnzt  = sort(srci_lsnzt.^2) ;
        sr2ci_lszt_u = sort(srci_lszt_u.^2) ;
        
    else
       
        tmp1 = srCoeff + (tci * seSRdf) ;
        tmp2 = srCoeff + (tci * seSRdf_u) ;
        tmp3 = srCoeff + (zci * seSRn) ; 
        tmp4 = srCoeff + (zci * seSRdf_u) ;
        
        tmp5 = transCIxeci(srCoeff, seSRdf,   tci(2), 1) ;
        tmp6 = transCIxeci(srCoeff, seSRdf_u, tci(2), 1) ;
        tmp7 = transCIxeci(srCoeff, seSRn,    zci(2), 1) ; 
        tmp8 = transCIxeci(srCoeff, seSRdf_u, zci(2), 1) ;
       
        sr2ci_lst    = [0 max(tmp1.^2)] ;
        sr2ci_lst_u  = [0 max(tmp2.^2)] ;
        sr2ci_lsnz   = [0 max(tmp3.^2)] ;
        sr2ci_lsz_u  = [0 max(tmp4.^2)] ;

        sr2ci_lstt   = [0 max(tmp5.^2)] ;
        sr2ci_lstt_u = [0 max(tmp6.^2)] ;
        sr2ci_lsnzt  = [0 max(tmp7.^2)] ;
        sr2ci_lszt_u = [0 max(tmp8.^2)] ;
        
    end
    
   
%% Combine like-minded outputs --------------------------------------------

    esXECI = zeros(4,1) ;                                 % All effect size point estimates
    
    esXECI(1) = bCoeff ;
    esXECI(2) = sbCoeff ;
    esXECI(3) = srCoeff ;
    esXECI(4) = srSq ;
    

    ciXECI = zeros(26,2) ;                                % All effect size interval estimates

    ciXECI( 1,1:2) = bci_ls ;                                               % CI for unstandardized regression coefficient (large sample)
    
    ciXECI( 2,1:2) = betaci_N ;                                             % CI for standardized regression coefficient (N t-based)
    ciXECI( 3,1:2) = betaci_N_z ;                                           % CI for standardized regression coefficient (N z-based)
    ciXECI( 4,1:2) = betaci_N_u ;                                           % CI for standardized regression coefficient (N t-based unbiased)
    ciXECI( 5,1:2) = betaci_N3 ;                                            % CI for standardized regression coefficient (N-3 t-based)
    ciXECI( 6,1:2) = betaci_N3_z ;                                          % CI for standardized regression coefficient (N-3 z-based)
    ciXECI( 7,1:2) = betaci_N3_u ;                                          % CI for standardized regression coefficient (N-3 t-based unbiased)
    ciXECI( 8,1:2) = betaci_df ;                                            % CI for standardized regression coefficient (df t-based)
    ciXECI( 9,1:2) = betaci_df_z ;                                          % CI for standardized regression coefficient (df z-based)
    ciXECI(10,1:2) = betaci_df_u ;                                          % CI for standardized regression coefficient (df t-based unbiased)

    ciXECI(11,1:2) = srci_lst ;                                             % CI for semipartial correlation (df Aloe-Becker t-based: Symmetric)
    ciXECI(12,1:2) = srci_lst_u ;                                           % CI for semipartial correlation (df Aloe-Becker-Unbiased t-based: Symmetric)
    ciXECI(13,1:2) = srci_lsnz ;                                            % CI for semipartial correlation (N Aloe-Becker z-based: Symmetric)
    ciXECI(14,1:2) = srci_lsz_u ;                                           % CI for semipartial correlation (df Aloe-Becker-Unbiased z-based: Symmetric)

    ciXECI(15,1:2) = srci_lstt ;                                            % CI for semipartial correlation (df Aloe-Becker t-based: Arctanh)
    ciXECI(16,1:2) = srci_lstt_u ;                                          % CI for semipartial correlation (df Aloe-Becker-Unbiased t-based: Arctanh)
    ciXECI(17,1:2) = srci_lsnzt ;                                           % CI for semipartial correlation (N Aloe-Becker z-based: Arctanh)
    ciXECI(18,1:2) = srci_lszt_u ;                                          % CI for semipartial correlation (df Aloe-Becker-Unbiased z-based: Arctanh)

    ciXECI(19,1:2) = sr2ci_lst ;                                            % CI for squared semipartial correlation (df Aloe-Becker t-based: Symmetric)
    ciXECI(20,1:2) = sr2ci_lst_u ;                                          % CI for squared semipartial correlation (df Aloe-Becker-Unbiased t-based: Symmetric)
    ciXECI(21,1:2) = sr2ci_lsnz ;                                           % CI for squared semipartial correlation (N Aloe-Becker z-based: Symmetric)
    ciXECI(22,1:2) = sr2ci_lsz_u ;                                          % CI for squared semipartial correlation (df Aloe-Becker-Unbiased z-based: Symmetric)

    ciXECI(23,1:2) = sr2ci_lstt ;                                           % CI for squared semipartial correlation (df Aloe-Becker t-based: Arctanh)
    ciXECI(24,1:2) = sr2ci_lstt_u ;                                         % CI for squared semipartial correlation (df Aloe-Becker-Unbiased t-based: Arctanh)
    ciXECI(25,1:2) = sr2ci_lsnzt ;                                          % CI for squared semipartial correlation (N Aloe-Becker z-based: Arctanh)
    ciXECI(26,1:2) = sr2ci_lszt_u ;                                         % CI for squared semipartial correlation (df Aloe-Becker-Unbiased z-based: Arctanh)

    
    % Temporary for EPM investigation December 2014
    
    
    tsXECI = zeros(19,1) ;                                 % All relevant t test values plus associated P values, statistics, Srd Errors, etc.
    
    tsXECI(1) = tValue ;
    tsXECI(2) = seReg ;
    tsXECI(3) = df ;
    tsXECI(4) = pValue ;
    tsXECI(5) = toleranceIV ;
    tsXECI(6) = tol_u ;
    tsXECI(7) = sampleRsq ;
    tsXECI(8) = r2_u ;
    tsXECI(9) = sampleRsq - srSq ;
    tsXECI(10) = seBN ;
    tsXECI(11) = seBN_u ;
    tsXECI(12) = seBN3 ;
    tsXECI(13) = seBN3_u ;
    tsXECI(14) = seBdf ;
    tsXECI(15) = seBdf_u ;
    tsXECI(16) = seSRdf ;
    tsXECI(17) = seSRdf_u ;
    tsXECI(18) = seSRn ;
    tsXECI(19) = seSRn_u ;



    % If output display is requested...

    if displayOut == 1
        
        disp(blanks(3)') ;
        str = [...
            ' Estimates of Effect Sizes for Partial Regression Coefficients' ;...
            ' ============================================================='] ;
        disp(str) ;
        disp(blanks(2)') ;

        dl1 = char(...
            '   Unstandardised b coefficient:   ', ...
            '   Beta coefficient:               ', ...
            '   Semipartial r:                  ', ...
            '   Squared semipartial r:          ') ;

        dl2 = char(...
            '   Large sample b coefficient:     ', ...     % Row 1 of ciXECI
            '   Noncentral b coefficient:       ', ...     % Row 2 of ciXECI
            '   Large sample beta coefficient:  ', ...     % Row 3 of ciXECI
            '   Large sample beta (unbiased):   ', ...     % Row 22 of ciXECI
            '   Noncentral beta coefficient:    ', ...     % Row 4 of ciXECI
            '   Noncentral beta (Unbiased):     ', ...     % Row 5 of ciXECI
            '   Noncentral beta (MBESS):        ', ...     % Row 7 of ciXECI
            '   Large sample sr (t-A)           ', ...     % Row 12 of ciXECI
            '   Large sample sr (t)             ', ...     % Row 14 of ciXECI
            '   Large sample sr (t-u-A)         ', ...     % Row 13 of ciXECI
            '   Large sample sr (t-u)           ', ...     % Row 15 of ciXECI
            '   Noncentral sr:                  ', ...     % Row 8 of ciXECI
            '   Noncentral sr (Unbiased):       ', ...     % Row 9 of ciXECI
            '   Noncentral sr (MBESS):          ', ...     % Row 10 of ciXECI
            '   Large sample sr-sq (t)          ', ...     % Row 18 of ciXECI
            '   Large sample sr-sq (t-Unbiased):', ...     % Row 19 of ciXECI
            '   Noncentrality Parameters:       ') ;       % Row 20 of ciXECI
         
        dl3 = char(...
            '   t value:                        ', ...
            '   Standard error:                 ', ...
            '   Degrees of freedom:             ', ...
            '   Observed P:                     ', ...
            '   Tolerance of IV:                ', ...
            '   Observed R-sq                   ', ...
            '   Interim R-squared               ', ...
            '   Standard error (beta):          ', ...
            '   Standard error (sr):            ', ...
            '   Standard error (Unbiased sr):   ') ;

        nr = length(ciXECI) ;
        c1 = char(40*ones(nr,1)) ;    % (
        c2 = char(44*ones(nr,1)) ;    % ,
        c3 = char(32*ones(nr,1)) ;    % space
        c4 = char(41*ones(nr,1)) ;    % )


        str = [...
            ' Point Estimates' ;...
            ' ---------------'] ;
        disp(str) ;
        es_d = dl1 ;
        na = 1:4 ;
        disp( horzcat(es_d(na,:),num2str(esXECI(na,1),'%10.4f')) ) ;
        disp(blanks(1)') ;

        if (mod(ciSize,1) == 0)
            str = [' ' num2str(ciSize,'%6.0f') ...
                '% Confidence Intervals' ;...
                ' ------------------------'] ;
        else
            str = [' ' num2str(ciSize,'%6.1f') ...
                '% Confidence Intervals' ;...
                ' --------------------------'] ;
        end
        
        disp( horzcat(str)) ;
        xeci_d = dl2 ;
        nb = [1:3 22 4 5 7 12 14 13 15 8 9 10 18:20] ;       
        
        disp( horzcat( xeci_d, c1(nb), num2str(ciXECI(nb,1),'%10.4f'), ...
                       c2(nb), c3(nb), num2str(ciXECI(nb,2),'%10.4f'), ...
                       c4(nb)) ) ;
        disp(blanks(1)') ;


        str = [...
            ' Test Statistics Results' ;...
            ' -----------------------'] ;
        disp(str) ;
        ts_d = dl3 ;
        nc = [1:5 7 9 12:14] ;
        d_ts = mixed2str(tsXECI(nc), [0 0 1 0 0 0 0 0 0 0], 10, 4, '.0000','     ') ;
        v = size(d_ts) ;
        w = v(2) ;
        z = w - 6 + 1 ;
        if tsXECI(4) < .0001
            d_ts(4,z:w) = '<.0001' ;
        end
        disp( horzcat(ts_d,d_ts )) ;
        disp(blanks(1)') ;

    end
   
return
   

function ar2 = adj_r2_c(r2, n, k)
% R2_C calculates closed form unbiased estimate of R-sq using first 7 terms in hypergeometric function of Olkin-Pratt (1958) unbiased estimator

    n3 = n - 3 ;
    df = n - k - 1 ;
    tol = 1 - r2 ;

    nk1 = n - k + 1 ;
    nk3 = n - k + 3 ;
    nk5 = n - k + 5 ;
    nk7 = n - k + 7 ;
    nk9 = n - k + 9 ;
    nk11 = n - k + 11 ;

    tmp0 = n3 / df * tol ;

    tmp1 = (    2 * tol)   / nk1 ;
    tmp2 = (    8 * tol^2) / (nk1 * nk3) ;
    tmp3 = (   48 * tol^3) / (nk1 * nk3 * nk5) ;
    tmp4 = (  384 * tol^4) / (nk1 * nk3 * nk5 * nk7) ;
    tmp5 = ( 3840 * tol^5) / (nk1 * nk3 * nk5 * nk7 * nk9) ;
    tmp6 = (46080 * tol^6) / (nk1 * nk3 * nk5 * nk7 * nk9 * nk11) ;

    ar2 = 1 - tmp0*(1 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6) ;
    
return 


function ar2 = adj_r2_u(r2, n, k)
% R2_OP calculates Olkin-Pratt (1958) unbiased estimator of R-sq using hypergeometric function

    n3 = n - 3 ;
    df = n - k - 1 ;
    nk1 = n - k + 1 ;
    tol = 1 - r2 ;

    tmp1 = n3 / df * tol ;
    tmp2 = hypergeomF(1, 1, nk1/2, tol) ;

    ar2 = 1 - tmp1*tmp2 ;

return


function se = srStdError(sampleRsq, reducedRsq, nSize)

   % Large-sample SE for semipartial correlation (Aloe & Becker, 2012)
   
    r2f = sampleRsq ;
    r2r = reducedRsq ;
    sr2 = sampleRsq - reducedRsq ;

    cr2f = 1 - r2f ;
    cr2r = 1 - r2r ;

    rf = sqrt(r2f) ;
    rr = sqrt(r2r) ;
    rs = sqrt(r2r / r2f) ;
    
    varSR =  (r2f*cr2f^2 + r2r*cr2r^2 - 2*rf*rr * ...
                (0.5*(2*rs - rf*rr) * (1 - r2f - r2r - rs^2) + rs^3)) / ...
                (nSize*sr2) ;
             
    if varSR <= 0
       se = NaN ;
    else
       se = sqrt(varSR) ;
    end;
    
return


function se_B = seBeta(bCoeff, varX, varY, Rsq, invCxx, covXY, nSize)
%  Calculates standard error of standardized regression coefficient using
%  Yuan-Chan (2011) method
%
%  INPUT:   
%           bCoeff = standardized regression coefficient
%           varX = variance of independent variable
%           varY = variance of dependent variable
%           Rsq = sample R-squared value
%           invRxx = diagonal element of inverse of covariance matrix for IVs
%                    (equivalent to VIF)
%           covXY = covariance between IV and DV 
%           nSize = sample size
%
%  OUTPUT:
%           seB = standard error of standardized regression coefficient
%
%

   varPY = varY .* Rsq ;
   
   varE = varY - varPY ;

   tmp1 = (varX .* invCxx .* varE) ./ (nSize .* varY) ;
   tmp2 = bCoeff.^2 .* ((varX .* varPY) - (varX .* varE) - covXY.^2) ;
   tmp3 = nSize .* varY.^2 ;
   
   varB = tmp1 + (tmp2 ./ tmp3) ;
   
   if varB < 0
      se_B = NaN ;
   else
      se_B = sqrt(varB) ;
   end 
   
return




%% ----- Functions for calculating coefficients and Jacobians --------------


function [g_y, y]= g_zxpnd(g_x, x)
   
   
   m= (sqrt(8* length(x)+ 1)- 1)/ 2; 
   y= zeros(m, m); 
   g_y= g_zeros(size(y));
   k= 1; 
   
   for i= 1: m
      for j= 1: i
         g_tmp_x_00000= g_x(k);
         tmp_x_00000= x(k);
         g_y(i, j)= g_tmp_x_00000;
         y(i, j)= tmp_x_00000; 
         g_tmp_x_00001= g_x(k);
         tmp_x_00001= x(k);
         g_y(j, i)= g_tmp_x_00001;
         y(j, i)= tmp_x_00001; 
         tmp_zxpnd_00000= k+ 1; 
         % Update detected: k= some_expression(k,...)
         k= tmp_zxpnd_00000;
      end; 
   end; 
   
return;



%% ----- Partial derivatives for effect sizes Normal method ----------------


function [g_betaValue, betaValue]= g_betaCalc(g_vCov, vCov)
% Calculate standardized regression coefficients for VCOV
   
   [g_vCov, vCov]= g_zxpnd(g_vCov, vCov) ; 
   Kd= length(vCov) ; 
   
   tmp_betaCalc_00000= 2: Kd;
   tmp_betaCalc_00001= 2: Kd;
   g_tmp_vCov_00000= g_vCov(tmp_betaCalc_00000, tmp_betaCalc_00001) ;
   tmp_vCov_00000= vCov(tmp_betaCalc_00000, tmp_betaCalc_00001) ;
   g_tmp_diag_00000= call(@diag, g_tmp_vCov_00000) ;
   tmp_diag_00000= diag(tmp_vCov_00000) ;
   g_tmp_vCov_00001= g_vCov(1, 1) ;
   tmp_vCov_00001= vCov(1, 1) ;
   tmp_betaCalc_00002= tmp_diag_00000/ tmp_vCov_00001 ;
   g_tmp_betaCalc_00002= (tmp_vCov_00001' \ (g_tmp_diag_00000' - g_tmp_vCov_00001' ...
                         * tmp_betaCalc_00002' ))' ;
   g_tmp_betaCalc_00003= 0.5.* tmp_betaCalc_00002.^ (0.5- 1).* g_tmp_betaCalc_00002 ;
   tmp_betaCalc_00003= tmp_betaCalc_00002.^ 0.5;
   g_tmp_diag_00001= call(@diag, g_tmp_betaCalc_00003) ;
   tmp_diag_00001= diag(tmp_betaCalc_00003) ;
   tmp_betaCalc_00004= 2: Kd;
   tmp_betaCalc_00005= 2: Kd;
   g_tmp_vCov_00002= g_vCov(tmp_betaCalc_00004, tmp_betaCalc_00005) ;
   tmp_vCov_00002= vCov(tmp_betaCalc_00004, tmp_betaCalc_00005) ;
   tmp_inv_00000= inv(tmp_vCov_00002) ;
   g_tmp_inv_00000= tmp_inv_00000* (-g_tmp_vCov_00002* tmp_inv_00000) ;
   tmp_betaCalc_00006= 2: Kd;
   g_tmp_vCov_00003= g_vCov(tmp_betaCalc_00006, 1) ;
   tmp_vCov_00003= vCov(tmp_betaCalc_00006, 1) ;
   g_betaValue= g_tmp_diag_00001* tmp_inv_00000* tmp_vCov_00003+ tmp_diag_00001* ...
                g_tmp_inv_00000* tmp_vCov_00003+ tmp_diag_00001* tmp_inv_00000* ...
                g_tmp_vCov_00003 ;
   
   betaValue= tmp_diag_00001* tmp_inv_00000* tmp_vCov_00003 ; 
   g_betaValue = [g_betaValue{:}] ;
   
return


function [g_srValue, srValue]= g_srCalc(g_vCov, vCov)
% Calculates semipartial correlations for VCOV
   
   [g_vCov, vCov]= g_zxpnd(g_vCov, vCov) ; 
   K= length(vCov) ; 
   
   tmp_srCalc_00000= 2: K;
   tmp_srCalc_00001= 2: K;
   g_tmp_vCov_00000= g_vCov(tmp_srCalc_00000, tmp_srCalc_00001) ;
   tmp_vCov_00000= vCov(tmp_srCalc_00000, tmp_srCalc_00001) ;
   tmp_inv_00000= inv(tmp_vCov_00000) ;
   g_tmp_inv_00000= tmp_inv_00000* (-g_tmp_vCov_00000* tmp_inv_00000) ;
   g_tmp_diag_00000= call(@diag, g_tmp_inv_00000) ;
   tmp_diag_00000= diag(tmp_inv_00000) ;
   tmp_srCalc_00007= -0.5.* tmp_diag_00000.^ (-0.5- 1) ;
   % Ensure, that derivative of 0.^0 is 0 and not NaN.
   tmp_srCalc_00007(tmp_diag_00000== 0& -0.5== 0)= 0 ; 
   g_tmp_srCalc_00002= tmp_srCalc_00007.* g_tmp_diag_00000 ;
   tmp_srCalc_00002= tmp_diag_00000.^ -0.5;
   g_tmp_diag_00001= call(@diag, g_tmp_srCalc_00002) ;
   tmp_diag_00001= diag(tmp_srCalc_00002) ;
   tmp_srCalc_00003= 2: K;
   tmp_srCalc_00004= 2: K;
   g_tmp_vCov_00001= g_vCov(tmp_srCalc_00003, tmp_srCalc_00004) ;
   tmp_vCov_00001= vCov(tmp_srCalc_00003, tmp_srCalc_00004) ;
   tmp_inv_00001= inv(tmp_vCov_00001) ;
   g_tmp_inv_00001= tmp_inv_00001* (-g_tmp_vCov_00001* tmp_inv_00001) ;
   tmp_srCalc_00005= 2: K;
   g_tmp_vCov_00002= g_vCov(tmp_srCalc_00005, 1) ;
   tmp_vCov_00002= vCov(tmp_srCalc_00005, 1) ;
   g_tmp_srCalc_00006= g_tmp_diag_00001* tmp_inv_00001* tmp_vCov_00002+ ...
                       tmp_diag_00001* g_tmp_inv_00001* tmp_vCov_00002+ ...
                       tmp_diag_00001* tmp_inv_00001* g_tmp_vCov_00002 ;
   tmp_srCalc_00006= tmp_diag_00001* tmp_inv_00001* tmp_vCov_00002 ;
   g_tmp_vCov_00003= g_vCov(1, 1) ;
   tmp_vCov_00003= vCov(1, 1) ;
   tmp_sqrt_00000= sqrt(tmp_vCov_00003) ;
   g_tmp_sqrt_00000= g_tmp_vCov_00003./ (2.* tmp_sqrt_00000) ;
   g_srValue= (g_tmp_srCalc_00006.* tmp_sqrt_00000- tmp_srCalc_00006.* ...
               g_tmp_sqrt_00000)./ tmp_sqrt_00000.^ 2 ;
   
   srValue= tmp_srCalc_00006./ tmp_sqrt_00000 ; 
   g_srValue = [g_srValue{:}] ;
   
return  