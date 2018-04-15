function probValue = rho2cdf(sampleR_sq, nIndpVars, nSize, nullRho_sq, iType)
% RHO2CDF calculates the probability value for a sample R-sq value, for given
% number of IVs, sample size, and null hypothesised population Rho-sq value
% using the Lee approximation by a noncentral F distribution
%
% INPUT:   
%       sampleRsq = sample r-squared value
%       nVars = number of independent variables
%       nSize = sample size
%       nullRho_sq = population rho-squared value
%       iType = obtained p value (if iType = 1) or
%               [p f df1 df2]    (if iType = 2) 
%
% OUTPUT   
%       probValue = Prob(0 <= r-sq <= rho-sq)
%
% Notes: Uses non-central F distribution approximation proposed by
%        Lee (1971) J. Royal Stats Society (Series B), 33, 117-130
%
%
%
% See also xeci_r2, ncp_rho2
%

%
% VERSION HISTORY
%     Created:    20 Aug 2010 
%


    nSize1 = nSize - 1;
    
    phi1 = phi(nSize1, 1, nIndpVars, nullRho_sq);
    phi2 = phi(nSize1, 2, nIndpVars, nullRho_sq);
    phi3 = phi(nSize1, 3, nIndpVars, nullRho_sq);
    
    sampleF_sq = sampleR_sq / (1 - sampleR_sq);
    nullF_sq = nullRho_sq / (1 - nullRho_sq);
    
    g = (phi2 - sqrt(phi2^2 - phi1 * phi3)) / phi1;
    g_sq = g^2;
    
    df2 = nSize1 - nIndpVars;
    df1 = (phi2 - 2 * nullF_sq * gam(nullRho_sq) * sqrt(nSize1 * df2)) / g_sq;
    
    ncp = nullF_sq * gam(nullRho_sq) * sqrt(nSize1 * df2) / g_sq;
    
    fValue = (sampleF_sq * df2) / (df1 * g);

    if iType == 1
        probValue = ncfcdf(fValue, df1, df2, ncp);
        
    elseif iType == 2
        probValue = zeros(4,1);
        
        probValue(1) = ncfcdf(fValue, df1, df2, ncp);
        probValue(2) = fValue;
        probValue(3) = df1;
        probValue(4) = df2;
        probValue(5) = ncp;
        
    end

return


function x = gam2(rho2)
   x = 1 / (1 - rho2);
return

function y = gam(rho2)
   y = sqrt( gam2(rho2) );
return

function z = phi(n, j, p, rho2)
   z = n * (gam2(rho2)^j - 1) + p;
return
