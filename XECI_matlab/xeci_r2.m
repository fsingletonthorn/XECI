function [esXECI, ciXECI, tsXECI] = xeci_r2(sampleRsq, nVars, nSize, ...
                                    nullRho_sq, ciSize, iType, displayOut, nDecs)
%                                
% XECI_R2 calculates effect sizes and CIs for R-sq in multiple regression
%
%   INPUT: Choose between one of two input types:
%       EITHER:
%           sampleR_sq = Observed R-sq (itype = 1)
%       OR
%                      = Observed F value (itype = 2)  
% 
%       PLUS
% 
%           nVars = number of independent variables in regression model
%           nSize  = total sample size
%           nullRho_sq = Null-hypothesised non-zero population rho-sq value (or zero)
%           ciSize = confidence interval size                   (*1)
%           iType = flag for determining input in RSQ (1 = R-sq; 2 = F value)
%           displayOut  = display output {1 = yes, 0 = no}      (*2)
%           nDecs       = number of displayed decimals (default = 4)
%
%
% 
%   OUTPUT:
%           esXECI = (3 X 1) vector of point estimates of effect sizes 
%                             Observed R-squared / Eqa-squared
%                             Unbiased R-sq (Olkin-Pratt)
%                             Multiple R
%                             Omega-squared
%
%           ciXECI = (7 X 2) matrix of lower and upper bound CI estimates
%                             Large sample R-sq (Alf-Graf)
%                             Eta-squared (fixed)
%                             R-squared (random)
%                             Unbiased R-sq (Olkin-Pratt)
%                             Multiple R
%                             Omega-squared
%                             Noncentrality parameters
%
%           tsXECI = (6 X 1) vector of test static results
%                             Observed F value for H0: rho-sq = 0
%                             df1
%                             df2
%                             Obtained P value
%                             Observed F value for H0: rho-sq > 0
%                             Null rho-sq df1
%                             Null rho-sq df2
%                             P value (null rho-sq)
%
%  Notes:   (*1) CI argument is a percentage value (e.g., use '95' for 95% CI)
%
%           (*2) Argument DPO provides formated output to screen (1 = YES or 0 = NO)
%
%
% See also ncp_f, hypergeomF, rho2cdf 
%

%
%   VERSION HISTORY
%       Created:    12 Jul 2008 
%       Revision:   14 Jul 2008 ~   Unbiased estimators now use O-P if 
%                                   N < 50 && nv < 10, otherwise Olkin-Pratt 
%                                   7-term closed form 
%
% 

%% Initialise output arguments

    esXECI = [];
    ciXECI = [];
    tsXECI = [];
   

%% ------------------------------------------------ Checking input arguments

    if nargin < 6
        error('xeci_r2:TooFewInputs', 'Requires at least 6 input arguments.');
    end
    
    if (displayOut ~= 1 && displayOut ~= 0)
        error('xeci_r2:IncorrectDPO', 'Display output flag not equal to 0 or 1.');
    end

    if (iType ~= 1 && iType ~= 2)
        error('xeci_r2:IncorrectITYPE', 'iType flag not equal to 1 or 2.');
    end

    if (nVars <= 0)
        errordlg('Number of IVs is less than 1 ', ...
                 'Input Entry Error' );
        return
    end

    if (nSize <= 1)
        errordlg('Sample size is less than or equal to 1 ', ...
                 'Input Entry Error' );
        return
    end

    if (nSize < nVars)
        errordlg('Sample size is less than number of IVs ', ...
                 'Input Entry Error' );
        return
    end

    if (ciSize <= 0 || ciSize >= 100)
        errordlg('Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' );
        return
    end
    
    % Default number of decimal places displayed
    if nargin == 7
       nDecs = 4 ;
    end ;

    % No output displayed
    if nargin == 6
       displayOut = 0 ;
    end ;
    
    
    
    % Observed R-sq input
    if iType == 1

        if (sampleRsq < 0 || sampleRsq > 1)
            errordlg('Observed R-sq is less than 0 or greater than 1 ', ...
                     'Input Entry Error' );
            return
        end

        sampleR2 = sampleRsq;
        r2Tilde = sampleR2 / (1 - sampleR2);
        fValue = r2Tilde * ((nSize - nVars - 1)/nVars);

    % Observed F value input
    elseif iType == 2                                                       

        if (sampleRsq < 0)
            errordlg('Observed F statistic is negative ', ...
                     'Input Entry Error' );
            return
        end

        fValue = sampleRsq;
        sampleR2 = (fValue * nVars) / ((fValue * nVars) + (nSize - nVars - 1));

    end
   
   
%% ------------------------------------------------ Preliminary calculations   

    if (ciSize > 0 && ciSize < 1)
        ciSize = ciSize * 100;
    end

    df1 = nVars;
    df2 = nSize - nVars - 1;

    probCI = [((100 + ciSize) / 200) ((100 - ciSize) / 200)];              % P values for defining CI bounds

   

%% ------------------------------------------------ Effect size calculations

%     r2Ezekiel = adj_r2_e(sampleR2, nSize, nVars);                          % Ezekial/Wherry estimator (adjusted R-sq in SAS, SPSS, Stata, etc)
%     r2Pratt   = adj_r2_p(sampleR2, nSize, nVars);                          % Pratt estimator cited in Claudy (1978)

    if nSize < 50 && nVars < 10
        r2Unbiased = adj_r2_u(sampleR2, nSize, nVars);                     % Olkin-Pratt unbiased estimator
    else
        r2Unbiased = adj_r2_c(sampleR2, nSize, nVars);                     % Closed-form Olkin-Pratt unbiased estimator using first 7 terms
    end
   
    omegaSq = sampleR2 - ( (df1/df2) * (1 - sampleR2) ) ;                  % Omega-squared
    

   
%% --------------------------------------------------------- Test statistics 
   
    pValue = 1 - fcdf(fValue, df1, df2) ;                                  % Obtained P value for observed f statistic

    exactProb = rho2cdf(sampleR2, nVars, nSize, nullRho_sq, 2);            % Calculcate non-zero null hypothesised rho-sq value
    exactProb(1) = 1 - exactProb(1);
   

%% --------------------------------------- Confidence intervals calculations

    ciExact    = ncp_rho2(sampleR2,            nVars, nSize, probCI);      % Random scores confidence intervals (Lee, 1971)
    ciUnbiased = ncp_rho2(max([0 r2Unbiased]), nVars, nSize, probCI);

    ciAlfGraf  = agr2(sampleR2, nSize, probCI);                            % Large-sample R-squared (Alf-Graf)

    ciNCP      = ncp_f(fValue, df1, df2, probCI); 
    tmp1       = ciNCP ./ (ciNCP + nSize);
    ciEtaSq    = [ max([0, tmp1(1)]) min([1 tmp1(2)]) ] ;                  % Fixed scores confidence interval (Eta-squared)
    
    tmp2       = tmp1 - ( (df1/df2) * (1 - tmp1) ) ;
    ciOmega    = [ max([0, tmp2(1)]) min([1 tmp2(2)]) ] ;                  % Fixed scores confidence interval (Omega-squared)                  
   

%% --------------------------------------------- Combine like-minded outputs

    % All effect size point estimates
    esXECI = zeros(4,1);
    esXECI(1) = sampleR2;
    esXECI(2) = r2Unbiased;
    esXECI(3) = sqrt(sampleR2);
    esXECI(4) = omegaSq ;


    % All effect size interval estimates   
    ciXECI = zeros(7,2);
    ciXECI(1,1:2) = ciAlfGraf;
    ciXECI(2,1:2) = ciEtaSq;
    ciXECI(3,1:2) = ciExact;
    ciXECI(4,1:2) = ciUnbiased;
    ciXECI(5,1:2) = sqrt(ciExact);
    ciXECI(6,1:2) = ciOmega ;
    ciXECI(7,1:2) = ciNCP ;


    % All relevant test statistic values   
    tsXECI = zeros(8,1);
    tsXECI(1) = fValue;
    tsXECI(2) = df1;
    tsXECI(3) = df2;
    tsXECI(4) = pValue;
    tsXECI(5) = exactProb(2);
    tsXECI(6) = exactProb(3);
    tsXECI(7) = exactProb(4);
    tsXECI(8) = exactProb(1);

   

%% ------------------------------------------ If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs, 0), 'f'] ;
        
        disp(blanks(3)');
        
        headingMain = [...
            ' Estimates of Effect Sizes for R-sq Statistic'; ...
            ' ============================================'];
        
        disp(headingMain);
        disp(blanks(2)');

        label_esXECI = char(...
            '   Observed R-sq (Eta-sq):     ', ...
            '   Unbiased R-sq (O-P):        ', ...
            '   Multiple R:                 ', ...
            '   Omega-squared:              ');

        label_ciXECI = char(...
            '   Large sample R-sq:          ', ...
            '   Eta-sq (fixed):             ', ...
            '   R-sq (random):              ', ...
            '   Unbiased R-sq (O-P):        ', ...
            '   Multiple R:                 ', ...
            '   Omega-sq (fixed):           ', ...
            '   Noncentrality Parameters:    ');

        label_tsXECI = char(...
            '   F value (Null Rho-Sq = 0)   ', ...
            '   df1:                        ', ...
            '   df2:                        ', ...
            '   P value:                    ', ...
            '   F value (Null Rho-Sq > 0):  ', ...
            '   Null rho-sq df1:            ', ...
            '   Null rho-sq df2:            ', ...
            '   P value [RhoSq <= Rsq]:     ');

        nRows = length(ciXECI);
        c1 = char(40 * ones(nRows, 1));     % (
        c2 = char(44 * ones(nRows, 1));     % ,
        c3 = char(32 * ones(nRows, 1));     % space
        c4 = char(41 * ones(nRows, 1));     % )


        headingEffects = [...
            ' Point Estimates'; ...
            ' ---------------'];
        
        disp(headingEffects);
        
        str_esXECI = num2str(esXECI, strDecs);
        disp( horzcat(label_esXECI, str_esXECI ) );
        disp(blanks(1)');


        if (mod(ciSize,1) == 0)
            headingInterval = [' ' num2str(ciSize,'%6.0f') ...
                '% Confidence Intervals'; ...
                ' ------------------------'];
        else
            headingInterval = [' ' num2str(ciSize,'%6.1f') ...
                '% Confidence Intervals'; ...
                ' --------------------------'];
        end
        
        disp( horzcat(headingInterval));
        disp( horzcat( label_ciXECI, c1, num2str(ciXECI(:,1), strDecs), ...
                                 c2, c3, num2str(ciXECI(:,2), strDecs), c4) ) ;
        disp(blanks(1)');


        headingStats = [...
            ' Test Statistics Results'; ...
            ' -----------------------'];
        
        disp(headingStats);
        str_tsXECI = mixed2str(tsXECI, [0 1 1 2 0 0 1 2], 10, nDecs) ;

        
        if nullRho_sq == 0
            disp( horzcat(label_tsXECI(1:4,:), str_tsXECI(1:4,:) ));
        else
            disp( horzcat(label_tsXECI, str_tsXECI ));
        end
        
        disp(blanks(2)');

    end
    
%% --------------------------------------------------------- End of function   
   
return
   
%% -------------------------------------Sub-functions used in main function
function adjustedRsq = adj_r2_e(sampleRsq, nSize, nVars)
% R2_P calculates Ezekiel/Wherry skrinkage estimator for R-sq (Ezekiel, 1930)

    df = nSize - nVars - 1;
    n1 = nSize - 1;
    tol = 1 - sampleRsq;
    adjustedRsq = 1 - ((n1/df) * tol);

return


function adjustedRsq = adj_r2_p(sampleRsq, nSize, nVars)
% R2_P calculates Pratt's skrinkage estimator of R-sq (cited in Claudy, 1978)

    n23 = nSize - nVars - 2.3;
    n3 = nSize - 3;
    df = nSize - nVars - 1;
    tol = 1 - sampleRsq;

    tmp1 = n3 / df * tol;
    tmp2 = 2 * tol / n23;

    adjustedRsq = 1 - tmp1*(1 + tmp2);

return


function adjustedRsq = adj_r2_u(sampleRsq, nSize, nVars)
% R2_OP calculates Olkin-Pratt (1958) unbiased estimator of R-sq 
% using hypergeometric function

    n3 = nSize - 3;
    df = nSize - nVars - 1;
    nk1 = nSize - nVars + 1;
    tol = 1 - sampleRsq;

    tmp1 = n3 / df * tol;
    tmp2 = hypergeomF(1, 1, nk1/2, tol);

    adjustedRsq = 1 - tmp1*tmp2;

return


function adjustedRsq = adj_r2_c(sampleRsq, nSize, nVars)
% R2_C calculates closed form unbiased estimate of R-sq using first 7 terms 
% in hypergeometric function of Olkin-Pratt (1958) unbiased estimator

    n3 = nSize - 3;
    df = nSize - nVars - 1;
    tol = 1 - sampleRsq;

    nk1 = nSize - nVars + 1;
    nk3 = nSize - nVars + 3;
    nk5 = nSize - nVars + 5;
    nk7 = nSize - nVars + 7;
    nk9 = nSize - nVars + 9;
    nk11 = nSize - nVars + 11;

    tmp0 = n3 / df * tol;

    tmp1 = (    2 * tol)   / nk1;
    tmp2 = (    8 * tol^2) / (nk1 * nk3);
    tmp3 = (   48 * tol^3) / (nk1 * nk3 * nk5);
    tmp4 = (  384 * tol^4) / (nk1 * nk3 * nk5 * nk7);
    tmp5 = ( 3840 * tol^5) / (nk1 * nk3 * nk5 * nk7 * nk9);
    tmp6 = (46080 * tol^6) / (nk1 * nk3 * nk5 * nk7 * nk9 * nk11);

    adjustedRsq = 1 - tmp0*(1 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6);
   
return 


function r2ci = agr2(sampleRsq, nSize, ciSize)
% Computes large sample CI using Alf-Graf method

    v = ( 4 * sampleRsq * (1-sampleRsq)^2 ) / nSize;

    z = -norminv( ciSize, 0, 1);

    r2ci = sampleRsq + (z.*sqrt(v));
   
return

%% ----------------------------------------------------End of sub-functions
