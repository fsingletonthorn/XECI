function rho2Value = ncp_rho2(sampleRsq, nVars, nSize, critProb, r2ci)
%
% NCP_RHO2 calculates the population R-squared value for given sampleRsq, 
% nVars, nSize, and critProb using the Lee approximation to the squared
% multiple correlation coefficient distribution function
%
%
% INPUT: 
%       sampleRsq = observed R-sq value (scalar or k X 1 vector)
%       nVars = number of IVs in regression model
%       nSize = sample size (scalar or k X 1 vector)
%       critProb = requested probability value for CDF (scalar or k X 1 vector)
%       r2ci = optional RHO2 starting values 
%
%
% OUTPUT: 
%       rho2Value = population R-squared values (scalar or k X 1 vector)
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
%       Created:    29 Aug 2008 
%       Revised:    02 Sep 2010 Added R2search function to find better starting
%                                   values for FZERO function
%

%
% Initial version:      29 Aug 2008 
% Revised version 1:    
%                   
%

    if nargin < 4
        error('M_Files:ncp_r2:TooFewInputs','Requires four or five input arguments.');
    end
    
    if nargin == 4
        ncpst = [0,0.999999999999];
    else
        ncpst = r2ci;
    end
    
    if (sampleRsq < 0 || sampleRsq > 1)
        error('MyFunctions:ncp_r2:IncorrectR2','Observed R-squared value is not > 0 and < 1.');
    elseif (nSize < 1)
        error('MyFunctions:ncp_r2:IncorrectN','Sample size is less than one.');
    elseif (nVars < 1)
        error('MyFunctions:ncp_r2:IncorrectIV','Number of IVs is less than one.');
    elseif (critProb <= 0)
        error('MyFunctions:ncp_r2:IncorrectP','Requested P value < 0.');
    elseif (critProb >= 1)
        error('MyFunctions:ncp_r2:IncorrectP','Requested P value > 1.');
    end

    [errorcode, sampleRsq, nSize, nVars, critProb, ncpst] = ...
                      distchck(5, sampleRsq, nSize, nVars, critProb, ncpst);
                  
    if errorcode > 0
        error('M_Files:ncptcdf:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end

    rho2Value(1:length(sampleRsq)) = 0;
    
    for i = 1:length(sampleRsq)
        if (rho2cdf(sampleRsq(i), nVars(i), nSize(i), 0, 1) < critProb(i))
            rho2Value(i) = 0;
        else
            if nargin == 5
                ncp0 = r2search(sampleRsq(i), nVars(i), nSize(i), ...
                                ncpst(i), critProb(i));
            else
                ncp0 = ncpst;
            end
            [ncp2, ~, c1, ~] = fzero(@(ncp1)(rho2cdf(sampleRsq(i), nVars(i), ...
                               nSize(i), ncp1, 1) - critProb(i)), ncp0);
                           
            if c1 == -1
                rho2Value(i) = 0.0/0.0;
            elseif c1 ~= 1;
                rho2Value(i) = ncp0;
            else
                rho2Value(i) = ncp2;
            end
        end
    end

return


function ncpst = r2search(r2, iv, n, ncp, p)

    for i = 0:0.025:1
        ncp0 = ncp - i;
        ncp1 = ncp + i;
        p0 = rho2cdf(r2, iv, n, max([0 ncp0]), 1) - p;
        p1 = rho2cdf(r2, iv, n, min([ncp1 1]), 1) - p;
        q = sign([p0 p1]);

        if sum(q) == 0;
            ncpst = [ncp0 ncp1];
            return;
        end
    end

    ncpst = [0 0.9999999];

return

      
