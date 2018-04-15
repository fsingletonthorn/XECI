function [esXECI, ciXECI, tsXECI, varXECI] = xeci_corr(sampleR, nSize, ...
                                                       nPartialR, nullRho, ciSize, displayOut, nDecs)
% 
% XECI_CORR calculates effect sizes and CIs for Pearson zero-order and 
% partial correlations, and CI for Spearman rank-order correlation (if 
% Spearman correlation entered as input value)
%
%
%   INPUT:  
%       sampleR    = observed correlation value (scalar or k X 1 vector)
%       nSize      = sample size (scalar or k X 1 vector)
%       nPartialR  = number of partialled variables (scalar or k X 1 vector)
%       nullRho    = null hypothesised rho value
%       ciSize     = confidence interval size
%       displayOut = display output (1 = yes, 0 = no)
%       nDecs      = number of displayed decimals (default = 4)
%
%
%   OUTPUT:
%       esXECI = (2 X 1) vector of point estimates of effect sizes 
%                    Sample correlation (zero-order or partial)
%                    Olkin & Pratt's unbiased estimate
%
%       ciXECI = (8 X 3) matrix of lower and upper bound CI estimates
%                    Large-sample Pearson
%                    Large-sample Olkin & Pratt's unbiased estimate
%                    Large-sample Spearman 
%                    Exact for Pearson correlation
%                    Exact for unbiased estimate of Pearson
%
%       tsXECI = (3 X 1) vector of t test results
%                    t statistic value
%                    Degrees of freedom
%                    Obtained P value
%                    Null-rho P value
%
%       varXECI = (9 X 2) vector of estimated variances
%                    Large sample variance
%                    Olkin & Pratt variance
%
% Notes: (1) If any non-scalar t, nu, or p are used, then each must be 
%            k X 1 conformable
%        (2) If any scalar {t, nu, p} mixed with k X 1 vector {t, nu, p}, 
%            then k X 1 vector of duplicated scalar values created by 
%            MATLAB DISTCHCK function
%        (3) IF FZERO fails with c1 = -1, then RHO = NaN
%
%
% See also rhocdf, ncp_rho
%

%
% VERSION HISTORY
%     Created:    11 Jul 2008 
%                 13 Mar 2015:   Changed cPearson / cSperman to sePearson / seSperman
%
%


%% Initialise output arguments

    esXECI = [];
    ciXECI = [];
    tsXECI = [];
    varXECI = [];


    %% ----------------------------------------Initial check of input arguments
    if nargin < 5
        error('XECI_corr:IncorrectInputs','Requires at least five input arguments.');
    end

    if (displayOut ~= 1 && displayOut ~= 0)
        error('XECI_corr:IncorrectDPO','Display output flag not equal to 0 or 1.');
    end

    [errorcode, sampleR, nSize, nPartialR] = distchck(3,sampleR,nSize,nPartialR);

    if errorcode > 0
        error('XECI_corr:InputSizeMismatch','Requires non-scalar arguments to match in size.');
    end


    % Generates Dialog Box error messages for input errors

    if (sampleR  <  -1) || (sampleR > 1)
        errordlg( 'Sample correlation value is < -1 or > +1 ', ...
                 'Input Entry Error' ); 
        return

    elseif (nSize  <  1)
        errordlg( 'Sample size is less than or equals 0 ', ...
                 'Input Entry Error' ); 
        return

    elseif (nPartialR  <  0) || (nPartialR > nSize)
        errordlg( 'Number of partialled variables < 0 or > N ', ...
                 'Input Entry Error' ); 
        return

    elseif (nullRho  <  -1) || (nullRho > 1)
        errordlg( 'Null hypothesised correlation value is < -1 or > +1 ', ...
                 'Input Entry Error' ); 
        return
    end

    if (ciSize <= 0 || ciSize >= 100)
        errordlg( 'Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' ); 
        return
    end
    
    % Default number of decimal places displayed
    if nargin == 6
       nDecs = 4 ;
    end ;

    % No output displayed
    if nargin == 5
       displayOut = 0 ;
    end ;


    

    %% ------------------------------------------------Preliminary calculations

    nSizeP = nSize - nPartialR;
    nSizeP1 = nSize - nPartialR - 1;

    probCI = [((100+ciSize)/200) ((100-ciSize)/200)];                       % P values for defining CI bounds

    zCritical = norminv(1 - probCI, 0, 1);                                  % Cricial Z statistics values for CI



    %% ------------------------------------------------Effect size calculations

    unbiasedR = sampleR * ...                                               % Olkin & Pratt unbiased estimate of r
                hypergeomF(0.5, 0.5, (nSizeP1-1)/2, 1 - sampleR^2);



    %% ---------------------------------------Confidence intervals calculations

    seSampleR = sqrt(1/(nSizeP - 3));

    ciSampleR  = tanh(atanh(sampleR)   + zCritical * seSampleR );           % Large sample Fisher r-to-z confidence intervals 
    ciUnbiased = tanh(atanh(unbiasedR) + zCritical * seSampleR );           % for sample correlation and unbiased correlation
    
    ciExact = ncp_rho(sampleR, nSizeP, nPartialR, probCI);                  % Exact confidence interval for sample correlation

    ciExactUnb = ncp_rho(unbiasedR, nSizeP, nPartialR, probCI);             % Exact confidence interval for unbiased correlation

    logCorr = 0.5*(log(1 + sampleR) - log(1 - sampleR));

    sePearson = (1 * zCritical) ./ sqrt(nSize - 3);
    seSpearman = (sqrt(1 + sampleR^2/2) .* zCritical) ./ sqrt(nSize - 3);

    pearson_L = logCorr + sePearson;

    spearman_L = logCorr + seSpearman;

    ciPearson = (exp(2*pearson_L) - 1) ./ (exp(2*pearson_L) + 1);

    ciSpearman = (exp(2*spearman_L) - 1) ./ (exp(2*spearman_L) + 1);


    %% ---------------------------------------------------------Test statistics

    df = nSizeP1 - 1;
    tValue = sampleR * sqrt(df/ (1 - sampleR^2));

    tProb = 2 * (1 - tcdf(abs(tValue), df));

    exactProb = rhocdf(sampleR, nSize-nPartialR, nullRho);



    %% ---------------------------------------------Combine like-minded outputs

    % All effect size point estimates
    esXECI = zeros(2,1);
    esXECI(1) = sampleR;
    esXECI(2) = unbiasedR;

    % All effect size interval estimates
    ciXECI = zeros(6,2);
    ciXECI(1,1:2) = ciSampleR;
    ciXECI(2,1:2) = ciUnbiased;
    ciXECI(3,1:2) = ciExact;
    ciXECI(4,1:2) = ciExactUnb;
    ciXECI(5,1:2) = ciPearson;
    ciXECI(6,1:2) = ciSpearman;

    % All relevant test statistic values
    tsXECI = zeros(4,1);
    tsXECI(1) = tValue;
    tsXECI(2) = df;
    tsXECI(3) = tProb;
    tsXECI(4) = exactProb;

    % All relevant variance estimates
    varXECI = zeros(2,1);
    varXECI(2) = seSampleR^2;



    %% ------------------------------------------If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;

        disp(blanks(3)');
        
        if nPartialR == 0
            str = [...
                ' Estimates of Effect Sizes for Pearson Correlation'; ...
                ' ================================================='];
        elseif nPartialR > 0
            str = [...
                ' Estimates of Effect Sizes for Partial Correlation'; ...
                ' ================================================='];
        end
        disp(str);
        disp(blanks(2)');

        label_esXECI = char(...
            '   Sample correlation:     ', ...
            '   Partial correlation:    ', ...
            '   Unbiased estimate:      ');

        label_ciXECI = char(...
            '   Large sample (r-to-z):  ', ...
            '   Large sample unbiased:  ', ...
            '   Exact:                  ', ...
            '   Exact unbiased:         ', ...
            '   Fisher-based Pearson:   ', ...
            '   Fisher-based Spearman:  ');

        label_tsXECI = char(...
            '   Observed t value:       ', ...
            '   Degrees of freedom:     ', ...
            '   P value:                ', ...
            '   P value [Rho <= r]:     ');

        nRows = length(ciXECI);
        c1 = char(40*ones(nRows,1));     % (
        c2 = char(44*ones(nRows,1));     % ,
        c3 = char(32*ones(nRows,1));     % space
        c4 = char(41*ones(nRows,1));     % )


        str = [...
            ' Point Estimates'; ...
            ' ---------------'];
        disp(str);
        if nPartialR == 0
            na = [1 3] ;
        else
            na = [2 3] ;
        end

        disp( horzcat( label_esXECI(na,:), num2str(esXECI, strDecs)) ) ;
        disp(blanks(1)');


        if (mod(ciSize,1) == 0)
            str = [' ' num2str(ciSize,'%6.0f') '% Confidence Intervals';' ------------------------'];
        else
            str = [' ' num2str(ciSize,'%6.1f') '% Confidence Intervals';' --------------------------'];
        end

        disp( horzcat(str));
        disp( horzcat( label_ciXECI, c1, num2str(ciXECI(:,1), strDecs), ...
                                 c2, c3, num2str(ciXECI(:,2), strDecs), c4) ) ;
        disp(blanks(1)');


        str = [...
            ' Test Statistics Results'; ...
            ' -----------------------'];
        disp(str);
        
        nc = [1:4] ;
        str_tsXECI = mixed2str(tsXECI(nc), [0 1 2 2], 10, nDecs) ;        

        disp( horzcat( label_tsXECI, str_tsXECI )) ;
        disp(blanks(1)') ;

    end
    %% ---------------------------------------------------------End of function

return
