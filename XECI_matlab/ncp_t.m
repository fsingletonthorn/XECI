function ncpValue = ncp_t(tValue, df, critProb)
%
% NCP_T calculates the noncentrality parameter for given tValue, df,  
% & critical P value using the noncentral t distribution
%
%
% INPUT:  
%       tValue = t statistic value (scalar or k X 1 vector)
%       df = degrees of freedom (scalar or k X 1 vector)
%       critProb = critical probability value for CDF (scalar or k X 1 vector)
%
%
% OUTPUT: 
%       ncpValue = noncentrality parameter value (scalar or k X 1 vector)
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
% See also xeci_dep2g, xeci_ind2g, xeci_lincon, xeci_reg
%


%
% VERSION HISTORY
%     Created:    11 Jul 2008 
%
%

    global tfail0;
    if nargin < 3
        error('XECI:ncp_t:TooFewInputs','Requires three input arguments.');
    end;
    
    [errorcode, tValue, df, critProb] = distchck(3,tValue,df,critProb);
    
    if errorcode > 0
        error('XECI:ncp_t:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end

    % Begin calculations
    ncpValue(1:length(tValue)) = 0;
    not_ok = 1;
    
    tfail0 = [tValue; df; critProb];
    
    for i = 1:length(tValue)
        for j = 1:20
            if tValue(i) > 0;
                ncp1 = tValue + [-1 1]*1.5^j;
            else
                ncp1 = tValue - [-1 1]*1.5^j;
            end
            q = sign( nctcdf(tValue(i), df(i), ncp1) - critProb(i));
            if sum(q) == 0
                not_ok = 0;
                break;
            end
        end
        
        if not_ok == 1
            if tValue(i) > 0
                ncp1 = [-50 50];
            else
                ncp1 = [50 -50];
            end
        end
        
        tfail0 = [ tfail0; ncp1];                                           %#ok<AGROW>
        
        try
            [ncp2, ~, c1, ~]=fzero(@(ncp1) ...
                (nctcdf(tValue(i), df(i), ncp1) - critProb(i)), ncp1);
            
        catch exceptObj;                                                    %#ok<NASGU>
            ncpValue = [-9999 -9999];
            return
        end
        
        if c1 == -1
            ncpValue(i) = 0.0/0.0;
        elseif c1 ~= 1;
            ncpValue(i) = ncp0;
        else
            ncpValue(i) = ncp2;
        end
    end

return
   

