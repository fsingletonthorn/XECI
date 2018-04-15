function ncpValue = ncp_hypg(nItems, nSize, popItems, pSize, critProb, iType)
%
% NCP_HYPG calculates the noncentrality parameter for given nItems, nSize, 
% popItems, pSize, and critProb from the noncentral hypergeometric distribution
%
%
% INPUT:  
%       nItems = number of items being observed in sample
%       nSize = sample size being selected from population without replacement
%       popItems = number of different possible items in populations
%       pSize = population size from which sampling without replacement is being performed
%       critProb = probability value for CDF (scalar or k X 1 vector)
%       iType = kind of NCP being requested (1 = exact; 2 = mid-P)
%
%
% OUTPUT: 
%       ncpValue = non-centrality parameter value (scalar or k X 1 vector)
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
% See also xeci_xtab
%

%
% VERSION HISTORY
%     Created:    14 Sep 2008 
%


% Preliminary checking of input arguments

    if nargin ~= 6
        error('XECI:ncp_hypg:TooFewInputs','Requires five input arguments.');
    end

    if (nItems < 0)
        error('XECI:ncp_hypg:IncorrectX','X value is negative.');
    elseif (nSize < 0)
        error('XECI:ncp_hypg:IncorrectN1','N1 value is negative.');
    elseif (popItems < 0)
        error('XECI:ncp_hypg:IncorrectM1','M1 value is negative.');
    elseif (critProb <= 0)
        error('XECI:ncp_hypg:IncorrectP','Requested P value < 0.');
    elseif (critProb >= 1)
        error('XECI:ncp_hypg:IncorrectP','Requested P value > 0.');
    elseif (iType ~= 1 && iType ~= 2)
        error('XECI:ncp_hypg:IncorrectITYPE','Requested ITYPE not equal to 1 or 2.');
    end

    [errorcode, nItems, nSize, popItems, pSize, critProb, iType] = ...
        distchck(6, nItems, nSize, popItems, pSize, critProb, iType);

    if errorcode > 0
        error('XECI:ncp_hypg:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end

    % Begin calculations
    ncpValue(1:length(nItems)) = 0;
    
    for i = 1:length(nItems)
        limits = [0,100000];
        
        if (iType == 1)
            [ncp2, ~, c1, ~] = fzero(@(ncp1) ...
                ( 1-nchypgcdf(nItems(i), nSize(i), popItems(i), pSize(i), ncp1) - ...
                critProb(i)), limits );
            
        elseif (iType == 2)
            [ncp2, ~, c1, ~] = fzero(@(ncp1) ...
                ( (1-nchypgcdf(nItems(i), nSize(i), popItems(i), pSize(i), ncp1) - ...
                0.5*nchypgpdf(nItems(i)+1, nSize(i), popItems(i), pSize(i), ncp1)) - ...
                critProb(i) ), limits );
        end;
        
        if c1 == -1
            ncpValue(i) = 0.0/0.0;
        elseif c1 ~= 1;
            ncpValue(i) = ncp0;
        else
            ncpValue(i) = ncp2;
        end
    end
 
return
