function [esXECI, ciXECI, tsXECI] = xeci_regLS3(coeff, sampleRsq, toleranceIV, nSize, nIVars, ...
                                           sdYvar, sdXvar, corrXY, iType1, iType2, ciSize, displayOut)
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
%           ciXECI = (26 X 2) matrix of  lower and upper bound CI estimates of effect sizes
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
%        Revision:    2 Apr 2015 ~   Removed all NCP-based intervals
%
% 


%% Initialise output arguments

   esXECI = [] ;
   ciXECI = [] ;
   tsXECI = [] ;

   
%% Initial check of input arguments ---------------------------------------
    if nargin == 1
       tmp = coeff ;
       coeff = tmp(1) ;
       sampleRsq = tmp(2) ;
       toleranceIV = tmp(3) ;
       nSize = tmp(4) ;
       nIVars = tmp(5) ;
       sdYvar = tmp(6) ;
       sdXvar = tmp(7) ;
       corrXY = tmp(8) ;
       iType1 = tmp(9) ;
       iType2 = tmp(10) ;
       ciSize = tmp(11) ;
       displayOut = tmp(12) ;
       
    elseif nargin < 12
       error('xeci:reg:TooFewInputs','Requires at least 12 input arguments.') ;
    end
    
    
% Generates Dialog Box error messages for input errors 

    if (sampleRsq  <  -1) || (sampleRsq > 1)
        errordlg('Sample R-squared value is < -1 or > +1 ', ...
                 'Input Entry Error' ) ;
        return
    end
 
    if (nSize <= 0)
       errordlg('Sample size is less than or equals 0 ', ...
                'Input Entry Error' ) ;
       return
    end
 
    if (nIVars <= 1)
       errordlg('Number of IVs is less than 1 ', ...
                'Input Entry Error' ) ;
       return
    end
 
    if (toleranceIV <= 0)
       errordlg('Standard error value less than or equals 0 ', ...
                'Input Entry Error' ) ;
       return
    end
 
    if (sdYvar <= 0)
       errordlg('SD of dependent variable is less than 0 ', ...
                'Input Entry Error' ) ;
       return
    end
 
    if (sdXvar <= 0)
       errordlg('SD of independent variable is less than 0 ', ...
                'Input Entry Error' ) ;
       return
    end
    
    if (ciSize <= 0 || ciSize >= 100)
       errordlg('Confidence interval value < 0 or > 100 ', ...
                'Input Entry Error' ) ;
       return
    end
   
 
    
%% Some preliminary calculations used throughout the remainder of the function 

    % Adjustment of CI width indicated by decimal number
    if (ciSize > 0 && ciSize < 1)
        ciSize = ciSize * 100 ;
    end

    df = nSize - nIVars - 1 ;
    alpha = 1 - ciSize/100 ;

    
    % Determine values for TOL, SE, B, SB, SR and SR-sq of k-th IV 
    % based on type of input values
    
    if iType1 == 2 && iType2 ~= 2
        error('xeci:reg:IncorrectCI',...
              'Semipartial correlation as input requires SE of b coefficient as input') ;
    end

    % Tolerance of k-th IV as input for 3rd argument
    
    if iType2 == 1
        seReg = (sdYvar / sdXvar) * sqrt( (1-sampleRsq) / (toleranceIV * df) ) ;
    end


    % Standard error of k-th IV as input for 3rd argument
    
    if iType2 == 2
        seReg = toleranceIV ;
        toleranceIV = (sdYvar^2*(sampleRsq - 1)) / (seReg^2 * sdXvar^2 * (nIVars - nSize + 1)) ;

        if toleranceIV > 1.0
            error('xeci:reg:IncorrectCI', ...
                  'Tolerance value derived from input data is > 1.0') ;
        end
    end


    % Regression coefficient of k-th IV as input for 1st argument
    
    if iType1 == 1
        bCoeff = coeff ;                                                    % unstandardized regression coefficient
        sbCoeff = bCoeff * sdXvar / sdYvar ;                                % standardized regression coefficient
        srCoeff = sbCoeff * sqrt(toleranceIV) ;                             % semipartial correlation
        srSq = srCoeff^2 ;                                                  % squared semipartial correlation
    end

    % Semipartial correlation of k-th IV as input for 1st argument
    
    if iType1 == 2
        srCoeff = coeff ;                                                   % semipartial correlation
        srSq = srCoeff^2 ;                                                  % squared semipartial correlation
        sbCoeff = srCoeff / sqrt(toleranceIV) ;                             % standardized regression coefficient
        bCoeff = sbCoeff * sdYvar / sdXvar ;                                % unstandardized regression coefficient
    end
   
   
%%  Calculate CI interval width and null hypothesised p value for k-th IV    

    pci = [((100-ciSize)/200) ((100+ciSize)/200)] ;                         % P values for defining CI bounds
    tci = tinv(pci, df) ;                                                   % critical t values for lower and upper bound 

    t = bCoeff / seReg ;                                                    % Null hypothesised t value for k-th IV
    p = 2 * (1 - tcdf(abs(t), df)) ;                                        % Observed 2-tailed P value for observed pooled variance t statistic


   
%% Large-sample SE for semipartial correlation (Aloe & Becker, 2012)
  
    seSRdf   = srStdError(sampleRsq, sampleRsq-srSq, df) ;

   
%% Large-sample SE for standardized regression coefficient (Yuan & Chan, 2011)
    
    covXY = corrXY * sdYvar * sdXvar ;
    
    iCxx = (1/toleranceIV) / sdXvar^2 ;
    
    seBN3   = seBeta(bCoeff, sdXvar^2, sdYvar^2, sampleRsq, iCxx, covXY, nSize-3) ;   % Yuan-Chan SE for standardized regression coefficient using N-3

   
%% Final calculations -----------------------------------------------------


    bci_ls = bCoeff + (tci * seReg) ;                                         % CI for unstandardized regression coefficient (large sample)

    betaci_N3   = sbCoeff + (tci * seBN3) ;                                   % CI for standardized regression coefficient (large sample)
    

    % Large-sample semipartial---Aloe & Becker (2012)
    srci_lst    = srCoeff + (tci * seSRdf) ;                                  % CI for semipartial correlation (Aloe-Becker)

    
    % CI for squared semipartial correlation
    if p < alpha
        sr2ci_lst    = sort(srci_lst.^2) ;
        
    else
       
        tmp1 = srCoeff + (tci * seSRdf) ;
        sr2ci_lst    = [0 max(tmp1.^2)] ;
        
    end

   
%% Combine like-minded outputs --------------------------------------------

    esXECI = zeros(4,1) ;                                 % All effect size point estimates
    
    esXECI(1) = bCoeff ;
    esXECI(2) = sbCoeff ;
    esXECI(3) = srCoeff ;
    esXECI(4) = srSq ;
    

    ciXECI = zeros(4,2) ;                                % All effect size interval estimates

    ciXECI( 1,1:2) = bci_ls ;                                               % CI for unstandardized regression coefficient (large sample)
    
    ciXECI( 2,1:2) = betaci_N3 ;                                            % CI for standardized regression coefficient (N-3 t-based)

    ciXECI( 3,1:2) = srci_lst ;                                             % CI for semipartial correlation (df Aloe-Becker t-based: Symmetric)

    ciXECI( 4,1:2) = sr2ci_lst ;                                            % CI for squared semipartial correlation (df Aloe-Becker t-based: Symmetric)

    
    % Temporary for EPM investigation December 2014
    
    
    tsXECI = zeros(9,1) ;                                 % All relevant t test values plus associated P values, statistics, Srd Errors, etc.
    
    tsXECI(1) = t ;
    tsXECI(2) = seReg ;
    tsXECI(3) = df ;
    tsXECI(4) = p ;
    tsXECI(5) = toleranceIV ;
    tsXECI(6) = sampleRsq ;
    tsXECI(7) = sampleRsq - srSq ;
    tsXECI(8) = seBN3 ;
    tsXECI(9) = seSRdf ;


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
            '   Large sample beta coefficient:  ', ...     % Row 2 of ciXECI
            '   Large sample sr (t)             ', ...     % Row 3 of ciXECI
            '   Large sample sr-sq (t)          ') ;       % Row 4 of ciXECI
         
        dl3 = char(...
            '   t value:                        ', ...
            '   Standard error:                 ', ...
            '   Degrees of freedom:             ', ...
            '   Observed P:                     ', ...
            '   Tolerance of IV:                ', ...
            '   Observed R-sq                   ', ...
            '   Interim R-squared               ', ...
            '   Standard error (beta):          ', ...
            '   Standard error (sr):            ') ;

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
        nb = [1:4] ;       
        
        disp( horzcat( xeci_d, c1(nb), num2str(ciXECI(nb,1),'%10.4f'), ...
                       c2(nb), c3(nb), num2str(ciXECI(nb,2),'%10.4f'), ...
                       c4(nb)) ) ;
        disp(blanks(1)') ;


        str = [...
            ' Test Statistics Results' ;...
            ' -----------------------'] ;
        disp(str) ;
        ts_d = dl3 ;
        nc = [1:9] ;
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


function se_SR = srStdError(sampleRsq, reducedRsq, nSize)

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
       se_SR = NaN ;
    else
       se_SR = sqrt(varSR) ;
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


%%% MBESS R syntax
% ci.reg.coef(b.j=0.2970,SE.b.j=0.179288483370685,N=30,s.Y=1,s.X=1,p=2,R2.Y_X=0.389,conf.level=0.95,Noncentral=TRUE)
% ci.src(b.k=0.2216,SE.b.k=0.240,s.Y=1.591,s.X=1.187,N=3000,K=2,R2.Y_X=0.389,R2.k_X.without.j=0.296,conf.level=0.95)

% ci.reg.coef(b.j=0.684027555653777,SE.b.j=0.153761056056567,N=20,s.Y=1.264182642578587,s.X=1.108630994184022,p=4,R2.Y_X=0.769892030264177,conf.level=0.95,Noncentral=TRUE)
% ci.src(b.k=0.684027555653777,SE.b.k=0.153761056056567,s.Y=1.264182642578587,s.X=1.108630994184022,N=20,K=4,R2.Y_X=0.769892030264177,R2.k_X.without.j=0.843710219075327,conf.level=0.95)
% 
% ci.reg.coef(b.j=0.599861225373985,SE.b.j=0.134841491016739,N=20,s.Y=1,s.X=1,p=4,R2.Y_X=0.769892030264177,conf.level=0.95,Noncentral=TRUE)


% ci.reg.coef(b.j=0.54171622,SE.b.j=0.09434913,N=100,s.Y=1.04232006,s.X=1.00933644,p=6,R2.Y_X=0.28320840,conf.level=0.95,Noncentral=TRUE)
% 
% ci.src(b.k=0.54171622,SE.b.k=0.0943491,s.Y=1.04232006,s.X=1.00933644,N=100,K=6,R2.Y_X=0.28320840,R2.k_X.without.j=0.07665401,conf.level=0.95)
% ci.src(b.k=0.54171622,SE.b.k=0.0943491,s.Y=1.04232006,s.X=1.00933644,N=100,K=6,R2.Y_X=0.28320840,R2.k_X.without.j=0.07665401,alpha.lower=0.025,alpha.upper=0.025)
% ci.src(b.k=0.52457392,SE.b.k=0.09136350,s.Y=1.0,s.X=1.0,N=100,K=6,R2.Y_X=0.28320840,R2.k_X.without.j=0.07665401,alpha.lower=0.025,alpha.upper=0.025)
