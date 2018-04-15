function [esXECI] = boot_regLS(sampleData)
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
%           iType1      = type of input 
%                           (1 = regression coefficient; 2 = semipartial correlation [requires type2 = 2])
%           iType2      = type of input 
%                           (1 = tolerance of k-th IV;   2 = standard error of k-th IV)
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

   sampleCov = cov(sampleData) ;
   
   Kd = length(sampleCov) ;
   K = Kd - 1 ;
   
   covXX = sampleCov(2:Kd,2:Kd) ;
   covYX = sampleCov(2:Kd, 1) ;
   
   sampleTol = 1./diag( inv( covcorr(covXX) ) );
   
   sdXX = diag(sampleCov(2:Kd,2:Kd)).^0.5 ;
   sdY = sqrt(sampleCov(1,1)) ;
   
   bValues = covXX \ covYX ;
   betaValues = (bValues .* sdXX) / sdY;
   
   srValues = betaValues .* sqrt(sampleTol) ;
   sr2Values = srValues.^2 ;

   RsqValue = 1 - ( det(sampleCov)/det(covXX) ) / sampleCov(1,1);
   
   
%% Combine like-minded outputs --------------------------------------------

    esXECI = zeros(5,1) ;                                 % All effect size point estimates
    
    esXECI(1) = bValues(K) ;
    esXECI(2) = betaValues(K) ;
    esXECI(3) = srValues(K) ;
    esXECI(4) = sr2Values(K) ;
    esXECI(5) = RsqValue ;
  
return
  
