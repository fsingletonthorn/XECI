function ncpValue = ncp_f(fValue, df1, df2, critProb)
%
% NCP_F calculates the noncentrality parameter for given fValue, df1 & df2,  
% & critical P value using the noncentral F distribution
%
%
% INPUT:  
%       fValue = f statistic value (scalar or k X 1 vector)
%       df1 = degrees of freedom (scalar or k X 1 vector)
%       df2 = degrees of freedom (scalar or k X 1 vector)
%       critProb = probability value for CDF (scalar or k X 1 vector)
%
%
% OUTPUT: 
%       ncpValue = noncentrality parameter value (scalar or k X 1 vector)
%       {b1 = value of root function at solution}
%       {c1 = exit flag: 
%             1 = converged 
%            -1 = terminated beforehand
%            -6 = change of sign of fucntion not detected}
%       {d1 = output structure containing
%             output.algorithm
%             output.funcCount
%             output.interval_iterations
%             output.iterations
%             output.exit message}
%
% Notes: (1) If any non-scalar f, v1, v2, or p are used, then each must be 
%            k X 1 conformable
%        (2) If any scalar {f, v1, v2, p} is mixed with k X 1 vector of any
%            {f, v1, v2, p}, then k X 1 vector of duplicated scalar values 
%            created by MATLAB DISTCHCK function
%        (3) IF FZERO fails with c1 = -1, then NCP = NaN
%
%
% See also xeci_r2
%

%
% VERSION HISTORY
%     Created:    11 Jul 2008 
%
%

    % Preliminary checking of input arguments
    if nargin < 4
        error('XECI:ncp_f:TooFewInputs','Requires three input arguments.');
    end
    
    if (fValue < 0)
        error('XECI:ncp_f:IncorrectF','F statistic value is negative.');
    elseif (df1 < 1)
        error('XECI:ncp_f:IncorrectV1','Numerator degrees of freedom are less than one.');
    elseif (df1 < 1)
        error('XECI:ncp_f:IncorrectV2','Denominator degrees of freedom are less than one.');
    elseif (critProb <= 0)
        error('XECI:ncp_f:IncorrectP','Requested P value < 0.');
    elseif (critProb >= 1)
        error('XECI:ncp_f:IncorrectP','Requested P value > 0.');
    end
    
    [errorcode, fValue, df1, df2, critProb] = distchck(4,fValue,df1,df2,critProb);
    
    if errorcode > 0
        error('XECI:ncp_f:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end

    
    % Begin calculations
    ncpValue(1:length(fValue)) = 0;
    
    for i = 1:length(fValue)
        
        if fcdf(fValue(i),df1(i),df2(i)) < critProb(i);
            ncpValue(i) = 0;
        else
            ncp0 = [0 100];
            for j = 10:50:710
                q = sign( ncfcdf(fValue(i), df1(i), df2(i), ncp0) - critProb(i) );
                if sum(q) == 0
                    break;
                end
                ncp0(2) = ncp0(2) + j;
            end
            
            [ncp2, ~,c1, ~]=fzero(@(ncp1) ...
                (ncfcdf(fValue(i), df1(i), df2(i), ncp1) - critProb(i)), ncp0);
            
            if c1 == -1
                ncpValue(i) = 0.0/0.0;
            elseif c1 ~= 1;
                ncpValue(i) = ncp0;
            else
                ncpValue(i) = ncp2;
            end
        end
    end

return;


% function [ncp0] = startNCP(f, df1, df2) 
