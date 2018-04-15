function ncpValue = ncp_rho(rValue, nSize, nPartialVars, critProb)
%
% NCP_RHO calculates the population Pearson (partial) correlation value for
% given rValue, nSize, nPartialVars, and critProb using the Pearson correlation
% distribution function
%
%
% INPUT:  
%       rValue = observed correlation value (scalar or k X 1 vector)
%       nSize = sample size (scalar or k X 1 vector)
%       nPartialVars = number of partialed variables (default = 0)
%       critProb = requested probability value for CDF (scalar or k X 1 vector)
%
%
% OUTPUT: 
%       ncpValue = population pearson correlation values for given P value (scalar or k X 1 vector)
%       {b1 = value of root function at solution}
%       {c1 = exit flag: 
%             1 = converged 
%            -1 = terminated beforehand
%            -6 = change of sign of fucntion nto detected}
%       {d1 = output structure containing
%             output.algorithm
%             output.funcCount
%             output.interval_iterations
%             output.iterations
%             output.exit message}
%
% Notes: (1) If any non-scalar t, nu, or p are used, then each must be 
%            k X 1 conformable
%        (2) If any scalar {t, nu, p} mixed with k X 1 vector {t, nu, p}, 
%            then k X 1 vector of duplicated scalar values created by 
%            MATLAB DISTCHCK function
%        (3) IF FZERO fails with c1 = -1, then NCP = NaN
%
%
% See also xeci_corr
%

%
% VERSION HISTORY
%     Created:    20 Nov 2009 
%
%


    if nargin < 4
        error('XECI:ncp_rho:TooFewInputs', 'Requires four input arguments.');
    end

    if (rValue < -1 || rValue > 1)
        error('XECI:ncp_rho:IncorrectR', 'Observed correlation value is not > -1 and < 1.');
    elseif (nSize < 1)
        error('XECI:ncp_rho:IncorrectN', 'Sample size is less than one.');
    elseif (nPartialVars < 0)
        error('XECI:ncp_rho:IncorrectPV', 'Number of partial variables is less than zerp.');
    elseif (critProb <= 0)
        error('XECI:ncp_rho:IncorrectP', 'Requested P value < 0.');
    elseif (critProb >= 1)
        error('XECI:ncp_rho:IncorrectP', 'Requested P value > 1.');
    end

    [errorcode, rValue, nSize, nPartialVars, critProb] = ...
        distchck(4,rValue,nSize,nPartialVars,critProb);
    
    if errorcode > 0
        error('XECI:ncp_rho:InputSizeMismatch', 'Requires non-scalar arguments to match in size.');
    end;

    ncpValue(1:length(rValue)) = 0 ;
    
    for i = 1:length(rValue)
        limits = 0.99999999;
        
        [ncp2, ~, c1, ~] = fzero(@(ncp1) ...
            (rhocdf(rValue(i), nSize(i) - nPartialVars(i), ncp1) - critProb(i)),[-limits, limits]);
        
        if c1 == -1
            ncpValue(i) = 0.0/0.0;
        elseif c1 ~= 1;
            ncpValue(i) = ncp0;
        else
            ncpValue(i) = ncp2;
        end
    end
 
return
   

