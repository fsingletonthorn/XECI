function ciBoth = transCIxeci(parmEst, parmSE, tCrit, cType)
% Asymmetric confidence intervals for bounded parameters by initial transformation
% of sample ststistic + standard error into unbounded form, then form CI using
% the unbounded expression, followed by inverting back to bounded values.
%  
% INPUT:
%           parmEst = sample estimate of parameter
%           parmSE  = standard error of parameter estimate
%           tCrit   = critical test statistic value (e.g., +1.96)
%           cType   = type of transformation for confidence interval
%                       1 =  < -1, +1  >     [Uses Fisher's r-to-z (inverse hyperbolic function)  "arctanh"] 
%                       2 =  <  0, +1  >     [Uses logistic transformation ]
%                       3 =  <  0, Inf >     [Uses logistic transformation ]
%
% OUTPUT:
%           [ciLB, ciUB] = bounds of confidence interval after transformation
%


   % Check if both critical values have been entered...remove if necessary
   if length(tCrit) > 1
      tCrit = abs(tCrit(1)) ;
   end;

   % If vector of parameter estimates and SEs entered, then duplicate TCRIT
   nR = length(parmEst) ;
   i1 = ones(nR,1) ;
   tCrit = i1 * tCrit ;

   
   % Check if PARMEST and PARMSE are both the same length
   if length(parmEst) ~= length(parmSE)
      
      if length(parmSE) == 1
         parmSE = i1 * parmSE ;
      else
         errorlog('PARMEST and PARMSE are not the same length')
      end ;
      
   end ;

   % Check if SE is zero: return CI = [0, 0] if that is the case
   if parmSE == 0
       ciBoth = [0 0] ;
       return ;
   end ;
   
   
   % Transform sample statistic and critical values into unbounded form
   if cType == 1                                                           % arctanh(z)
      a = (i1 + parmEst) ./ (i1 - parmEst) ;
      b = exp( tCrit .* (2 * parmSE) ./ (i1 - parmEst.^2) ) ;
      
   elseif cType == 2                                                       % logistic(z)
      a = (i1 ./ parmEst) - i1 ;
      b = exp( -tCrit .* parmSE ./ (parmEst.*(i1 - parmEst)) ) ;
      
   elseif cType == 3                                                       % 
      a = parmEst ;
      b = exp( tCrit .* parmSE ./ parmEst ) ;
   end ;
      
   
   % Invert resultant unbounded CI into its bounded form
   if cType == 1                                                           % tanh(z)
      ciLB = ((a./b) - i1) ./ ((a./b) + i1) ;
      ciUB = ((a.*b) - i1) ./ ((a.*b) + i1) ;
      
   elseif cType == 2                                                       % 
      ciLB = i1 ./ (i1 + (a./b) ) ;
      ciUB = i1 ./ (i1 + (a.*b) ) ;
      
   elseif cType == 3
      ciLB = a ./ b ;
      ciUB = a .* b ;
   end ;


   ciBoth = [ciLB ciUB] ;
   
return
