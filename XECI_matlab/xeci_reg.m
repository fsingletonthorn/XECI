function [esXECI, ciXECI, tsXECI] = xeci_reg(coeff, sampleRsq, toleranceIV, nSize, nIVars, ...
                                           sdYvar, sdXvar, corrXY, iType1, iType2, ciSize, displayOut, nDecs)
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
%           nDecs       = number of displayed decimals (default = 4)
%
%
% 
%   OUTPUT:
%           esXECI = (5 X 1) vector of point estimates of effect sizes 
%                       Unstandardised b coefficient
%                       Beta coefficient
%                       Semipartial correlation
%                       Squared semipartial correlation (improvement in R-squared)
%                       Squared partial correlation
%
%           ciXECI = (6 X 2) matrix of  lower and upper bound CI estimates of effect sizes
%                       Large sample b coefficient                                                (1)
%                       Std. regression coefficient (N-3 t-based)                                 (2)
%                       Semipartial  (df Aloe-Becker t-based: Symmetric)                          (3)
%                       Sq. semipartial  (df Aloe-Becker t-based: Symmetric)                      (4)
%                       Semipartial  (df Aloe-Becker t-based: Asymmetric)                         (5)
%                       Sq. semipartial  (df Aloe-Becker t-based: Asymmetric)                     (6)
%
%           tsXECI = (8 X 1) vector of t test results:
%                       Observed t value                                                          (1)
%                       Standard error of b coefficient                                           (2)
%                       Degrees of freedom                                                        (3)
%                       Obtained P value                                                          (4)
%                       Tolerance of IV (unadjusted)                                              (5)
%                       Unbiased R-sq value                                                       (6) 
%                       Standard error for beta (large-sample N-3)                                (7)
%                       Standard error for sr (large-sample df)                                   (8)
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
       nDecs = tmp(13) ;
       
    elseif nargin == 12
       nDecs = 4 ;
       
    elseif nargin < 13
       error('xeci:reg:TooFewInputs','Requires at least 13 input arguments.') ;
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


    % Regression coefficient of IV as input for 1st argument
    
    if iType1 == 1
        bCoeff = coeff ;                                                    % unstandardized regression coefficient
        sbCoeff = bCoeff * sdXvar / sdYvar ;                                % standardized regression coefficient
        srCoeff = sbCoeff * sqrt(toleranceIV) ;                             % semipartial correlation
        srSq = srCoeff^2 ;                                                  % squared semipartial correlation
        prSq = srSq ./ (1 - (sampleRsq - srSq)) ;                           % squared partial correlation
    end

    % Semipartial correlation of IV as input for 1st argument
    
    if iType1 == 2
        srCoeff = coeff ;                                                   % semipartial correlation
        srSq = srCoeff^2 ;                                                  % squared semipartial correlation
        sbCoeff = srCoeff / sqrt(toleranceIV) ;                             % standardized regression coefficient
        bCoeff = sbCoeff * sdYvar / sdXvar ;                                % unstandardized regression coefficient
        prSq = srSq ./ (1 - (sampleRsq - srSq)) ;                           % squared partial correlation
    end


    % Unbiased R-squared
    
    if nSize < 50 && nIVars < 10
        unbiasedRsq = adjRsqU(sampleRsq, nSize, nIVars) ;                   % Olkin-Pratt unbiased estimator
    else
        unbiasedRsq = adjRsqC(sampleRsq, nSize, nIVars) ;                   % Closed-form Olkin-Pratt estimator
    end
    
   
%%  Calculate CI interval width and null hypothesised p value for k-th IV    

    pci = [((100-ciSize)/200) ((100+ciSize)/200)] ;                         % Critical P values for defining CI bounds
    tci = tinv(pci, df) ;                                                   % critical t values for lower and upper bound 

    tValue = bCoeff / seReg ;                                               % Null hypothesised t value for IV
    pValue = 2 * (1 - tcdf(abs(tValue), df)) ;                              % Observed 2-tailed P value for IV 


   
%% Large-sample SE for standardized regression coefficient (Yuan & Chan, 2011, N-3 adjustment version)
    
    covXY = corrXY * sdYvar * sdXvar ;
    iCxx = (1/toleranceIV) / sdXvar^2 ;
    
    stdErrBeta = seBeta(bCoeff, sdXvar^2, sdYvar^2, sampleRsq, iCxx, covXY, nSize-3) ;

   
%% Large-sample SE for semipartial correlation (Adj. Aloe & Becker, 2012; Dudgeon, 2015)
  
    stdErrSR   = srStdError(sampleRsq, sampleRsq-srSq, df) ;

   
%% Final calculations -----------------------------------------------------


    % Large-sample b Coefficient
    bCoeff_CI = bCoeff + (tci * seReg) ;

    % Large-sample beta (Yuan-Chan, 2011 N-3 version)
    beta_CI   = sbCoeff + (tci * stdErrBeta) ;
    
    % Large-sample symmetrix semipartial (Aloe & Becker, 2012; Dudgeon, 2015)
    if isnan(stdErrSR)
      sr_CIsym = [NaN NaN] ;
    else
      sr_CIsym = srCoeff + (tci * stdErrSR) ;
    end;
    
    % Large-sample asymmetrix semipartial (Aloe & Becker, 2012; Dudgeon, 2015)
    if isnan(stdErrSR)
      sr_CIasym = [NaN NaN] ;
    else
      sr_CIasym = transCIxeci(srCoeff, stdErrSR,   tci(2), 1) ;
    end;

    % CI for squared semipartial correlation (Dudgeon, 2015)
    if pValue < alpha
        sr2_CIsym  = sr_CIsym.^2 ;
        sr2_CIasym = sr_CIasym.^2 ;
    else
        sr2_CIsym  = [0 sr_CIsym(2)^2] ;
        sr2_CIasym = [0 sr_CIasym(2)^2] ;
    end

   
%% Combine like-minded outputs --------------------------------------------

    esXECI = zeros(5,1) ;                                 % All effect size point estimates
    
    esXECI(1) = bCoeff ;
    esXECI(2) = sbCoeff ;
    esXECI(3) = srCoeff ;
    esXECI(4) = srSq ;
    esXECI(5) = prSq ;
    

    ciXECI = zeros(4,2) ;                                % All effect size interval estimates

    ciXECI( 1,1:2) = bCoeff_CI ;
    ciXECI( 2,1:2) = beta_CI ;
    ciXECI( 3,1:2) = sr_CIsym ;
    ciXECI( 4,1:2) = sr_CIasym ;
    ciXECI( 5,1:2) = sr2_CIsym ;
    ciXECI( 6,1:2) = sr2_CIasym ;

    
    tsXECI = zeros(10,1) ;                               % Associated statistics, p Values, etc

    tsXECI(1)  = tValue ;
    tsXECI(2)  = seReg ;
    tsXECI(3)  = df ;
    tsXECI(4)  = pValue ;
    tsXECI(5)  = toleranceIV ;
    tsXECI(6)  = unbiasedRsq ;
    tsXECI(7)  = stdErrBeta ;
    tsXECI(8)  = stdErrSR ;



    % If output display is requested...

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;
        
        disp(blanks(3)') ;
        str = [...
            ' Estimates of Effect Sizes for Partial Regression Coefficients' ;...
            ' ============================================================='] ;
        disp(str) ;
        disp(blanks(2)') ;

        label_esXECI = char(...
            '   Unstandardised b coefficient:   ', ...
            '   Beta coefficient:               ', ...
            '   Semipartial r:                  ', ...
            '   Squared semipartial r:          ', ...
            '   Squared partial r:              ') ;

        label_ciXECI = char(...
            '   Large sample b coefficient:     ', ...
            '   Large sample beta coefficient:  ', ...
            '   Large sample sr (sym):          ', ...
            '   Large sample sr (asym):         ', ...
            '   Large sample sr-sq (sym):       ', ...
            '   Large sample sr-sq (asym):      ') ;
         
        label_tsXECI = char(...
            '   Observed t value:               ', ...
            '   Standard error:                 ', ...
            '   Degrees of freedom:             ', ...
            '   Obtained P value:               ', ...
            '   Tolerance of IV:                ', ...
            '   Unbiased R-sq                   ', ...
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
        na = 1:5 ;
        disp( horzcat(label_esXECI(na,:), num2str(esXECI(na,1), strDecs)) ) ;
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
        nb = [1:6] ;       
        
        disp( horzcat( label_ciXECI, c1(nb), num2str(ciXECI(nb,1), strDecs), ...
                             c2(nb), c3(nb), num2str(ciXECI(nb,2), strDecs), ...
                             c4(nb)) ) ;
        disp(blanks(1)') ;


        str = [...
            ' Test Statistics Results' ;...
            ' -----------------------'] ;
        disp(str) ;
        nc = [1:8] ;
        str_tsXECI = mixed2str(tsXECI(nc), [0 0 1 2 0 0 0 0], 10, nDecs) ;
        
        disp( horzcat( label_tsXECI, str_tsXECI )) ;
        disp(blanks(1)') ;

    end
   
return



function ar2 = adjRsqC(r2, n, k)
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


function ar2 = adjRsqU(r2, n, k)
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
%  Calculates standard error of semipartial correlation coefficient using
%  adjusted Aloe-Becker (2012) method (where adjustment is in Dudgeon (2015)
%
%  INPUT:   
%           sampleRsq  = overall model R-squared value
%           reducedRsq = interim model R-squared value
%           nSize      = sample size (which is N - K -1 for adjusted ALoe-Becker)
%
%  OUTPUT:
%           se-SR      = standard error of semipartial correlation coefficient
%
%
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
       se_SR = NaN ;                      % Possible for variance estimate to be negative
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


