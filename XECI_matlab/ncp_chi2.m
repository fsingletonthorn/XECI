function ncpValue = ncp_chi2(chiValue, df, critProb)
%
% NCP_CHI2 finds the noncentrality parameter for given input values of 
% chiValue, df, and critProb
%
%
% INPUT:  
%       chiValue = chi-square value (scalar or k X 1 vector)
%       df = degrees of freedom (scalar or k X 1 vector)
%       critProb = probability value for CDF (scalar or k X 1 vector)
%
%
% OUTPUT: 
%       ncp = non-centrality parameter value (scalar or k X 1 vector)
%       {b1 = value of root function at solution}
%       {c1 = exit flag: 
%              1 = converged 
%             -1 = terminated beforehand
%             -6 = change of sign of fucntion nto detected}
%       {d1 = output structure containing
%             output.algorithm
%             output.funcCount
%             output.interval_iterations
%             output.iterations
%             output.exit message}
%
% Notes: (1) If any non-scalar x2, v, or p are used, then each must be 
%            k X 1 conformable
%        (2) If any scalar {x2, v, p} mixed with k X 1 vector {x2, v, p}, 
%            then k X 1 vector of duplicated scalar values created by 
%            MATLAB DISTCHCK function
%        (3) IF FZERO fails with c1 = -1, then NCP = NaN
%
%
% See also xeci_sem
%

%
% VERSION HISTORY
%     Created:    11 Jul 2008
%



    if nargin < 3
        error('XECI:ncp_chi2:TooFewInputs','Requires three input arguments.');
    end

    [errorcode, chiValue, df, critProb] = distchck(3, chiValue, df, critProb);

    if errorcode > 0
        error('XECI:ncp_chi2:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end

    ncpValue(1:length(chiValue)) = 0;

    for i = 1:length(chiValue)
        
        if chi2cdf(chiValue(i), df(i)) < critProb(i)
            ncpValue(i) = 0;

        else
            z = mosch(chiValue(i), df(i), critProb(i));
            if z == 0
                z = 0.25;
            end

            for j = 1:20
                ncp0 = [0 z] * (1.25^j);
                q = sign( ncx2cdf(chiValue(i), df(i), ncp0) - critProb(i) );
                if sum(q) == 0
                    break;
                end
            end


            [ncp2, ~, c1, ~] = fzero( @(ncp1)(ncx2cdf(chiValue(i), df(i), ...
                                      ncp1) - critProb(i)), ncp0 );

            if c1 == -1
                ncpValue(i) = 0.0 / 0.0;
            elseif c1 ~= 1;
                ncpValue(i) = ncp0;
            else
                ncpValue(i) = ncp2;
            end

        end
    end

return
   

function ncpValue = mosch(chiValue, df, critProb)
% MOSCH(x2,v,p): Moschopoulos approximation for chi-square non-centrality parameter
% --- where x2 = chi-square value, v = degrees of freedom, & p = requested P value

%
% INPUT:  chiValue = chi-square value (scalar or k X 1 vector)
%         df = degrees of freedom (scalar or k X 1 vector)
%         critProb = probability value for CDF (scalar or k X 1 vector)
%
% OUTPUT: ncp = approximate non-centrality parameter value  
%               (scalar or k X 1 vector)
%
% Notes: (1) If any non-scalar x2, v, or p are used, then each must be 
%            k X 1 conformable
%        (2) If any scalar {x2, v, p} mixed with k X 1 vector {x2, v, p}, 
%            then k X 1 vector of duplicated scalar values created by 
%            MATLAB DISTCHCK function
%        (3) IF approximation NCP < 0, then recoded to 0
%
% Initial version:      11 Jul 2008 
% Revised version 1:    none
%

% Prelimiary checking of input arguments

    if nargin < 3
        error('XECI:mosch:TooFewInputs','Requires three input arguments.');
    end

    if chiValue < 0
        error('XECI:mosch:IncorrectX2','Chi-square value is negative.');
    elseif df <= 0
        error('XECI:mosch:IncorrectDF','Degrees of freedom less than or equal to zero.');
    elseif (critProb < 0 || critProb > 1)
        error('XECI:mosch:IncorrectP','P value is negative or greater than 1.');
    end

    [errorcode, chiValue, df, critProb] = distchck(3, chiValue, df, critProb);

    if errorcode > 0
        error('XECI:mosch:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end

    % Start calculations
    k1 =   df +     chiValue - df;
    k2 = 2*df +  4*(chiValue - df);
    k3 = 8*df + 24*(chiValue - df);

    b = (k2 ./ (2*k1)) - (k3 ./ (4*k2));

    h = 1 - ( (k1.*k3) ./ (3*k2.^2) );

    mean = 1 + (h ./ k1) .* k2 .* (h-1) ./ (2*k1);
    var = h.^2 .* k2 ./ (k1.^2);

    if var >= 0
        off = norminv(critProb,0,1) .* var.^0.5;
    else
        off = 0;
    end

    n = mean - off;

    if n >= 0
        x = k1 .* n.^(1./h) - b;
    else
        x = 0;
    end

    ncpValue = x - df;

    % Return 0 if the estimated NCP is less than 0.

    k = (ncpValue < 0);

    if any(k(:))
        ncpValue(k) = 0;
    end

return
