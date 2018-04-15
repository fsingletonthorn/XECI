function [esXECI, ciXECI, tsXECI, varXECI] = xeci_ind2g(meanGrp1, meanGrp2, ...
                   sdGrp1, sdGrp2, nSizeGrp1, nSizeGrp2, ciSize, displayOut, nDecs)
               %
% XECI_IND2G calculates effect sizes and CIs for two independent group designs
%
%
%   INPUT: Choose between one of two input types:
% 
%       EITHER: [at least 7 arguments for iTYPE == 1]
%
%           meanGrp1   = sample mean for group 1
%           meanGrp2   = sample mean for group 2
%           sdGrp1     = sample SD for group 1
%           sdGrp2     = sample SD for group 2
%           nSizeGrp1  = sample size for group 1
%           nSizeGrp2  = sample size for group 2
%           ciSize     = confidence interval size                     (*1)
%           displayOut = display output {1 = yes, 0 = no}             (*2)
%           nDecs      = number of decimal places in displayed output
%
%       OR: [5 arguments for iType == 2]
%
%           tValue     = observed t statistic value   [ = meanGrp1 ]
%           nSizeGrp1  = sample size for group 1      [ = meanGrp2 ]
%           nSizeGrp2  = sample size for group 2      [ = sdGrp1 ]
%           ciSize     = confidence interval size     [ = sdGrp2 ]    (*1)
%           displayOut = display output               [ = nSizeGrp1 ] (*2)
%
% 
% OUTPUT:
%           esXECI   = (6 X 1) vector of point estimates of effect sizes 
%                        Raw Difference                               (*3)
%                        Hedges' g                                    (*4)
%                        Unbiased g                                   (*4)
%                        Glass' delta                                 (*3)
%                        Unbiased delta                               (*3)
%                        Bonett's delta                               (*3)
%
%           ciXECI = (10 X 2) matrix of  lower and upper bound CI estimates
%                        Raw Difference                               (*3)
%                        Hedges' g                                    (*4)
%                        Unbiased g                                   (*4)
%                        Glass' delta                                 (*3)
%                        Unbiased delta                               (*3)
%                        Bonett's delta                               (*3)
%                        Standardized NCP
%                        Satterthwaite Noncentral
%                        Non-centrality Parameters
%                        Satterthwaite Non-C Parms
%
%           tsXECI   = (7 X 1) vector of t test results
%                        Observed t value
%                        Degrees of freedom
%                        Obtained P value
%                        Hedges' c(m) bias weight
%                        Satterthwaite t value
%                        Satterthwaite df
%                        Satterthwaite P value
%
%           vgXECI = (4 X 1) vector of variance estimates
%                        Pooled variance
%                        g (Viechtbauer, 2007, Eq. 28)
%                        d (Viechtbauer, 2007, Eq. 29)
%                        delta (Bonett, 2008)
% 
%  Notes:   (*1) CI argument is a percentage value (e.g., use '95' for 95% CI)
%
%           (*2) Argument DPO provides formated output to screen (1 = YES or 0 = NO)
%
%           (*3) If only 5 arguments are entered, indicating only t values are known, then 
%                RAW DIFFERENCE, GLASS' DELTA and UNBIASED DELTA cannot be calculated, 
%                and these cells are given NaN values
%
%           (*4) Viechtbauer (2007) uses 'd' and 'g' to indicate the biased and unbiased standardised 
%                mean differences respectively, which is the opposite to that used elsewhere. All
%                calculations below use the more typical nomenclature of 'g' and 'unbaised g' for the 
%                biased and unbiased estimates respectively (carried over to variance estimates also).
%
%
% See also ncp_t
%

%
%   VERSION HISTORY
%       Created:    12 Jul 2008 
%       Revision:   14 Jul 2008 ~  Changed calculations for variances of g 
%                                       and d estimates based on Viechtbauer (2007) 
%       Revision:   15 Nov 2009 ~  Added vgXECI as an output option
%       Revision:   29 Jun 2011 ~  Added Bonett's delta & Satterthwaite estimates to 
%                                       the output & formatted file
%
%


%% Initialise output arguments

    esXECI = [];
    ciXECI = [];
    tsXECI = [];
    varXECI = [];

   
%% ---------------------------------------- Initial check of input arguments

    if nargin < 4
        error('XECI_ind2g:TooFewInputs','Requires at least 4 input arguments.');

    elseif (nargin ~= 5 && nargin ~= 6 && nargin ~= 7 && nargin ~= 8 && nargin ~= 9)
        error('XECI_ind2g:TooFewInputs','Requires either 5, 6, 7, or 9 input arguments.');

    end
    
    
    % When entering only 4 or 5 arguments
    
    if nargin == 4
        tValue_pooled = meanGrp1 ;
        nSizeGrp1     = meanGrp2 ;
        nSizeGrp2     = sdGrp1 ;
        ciSize        = sdGrp2 ;
        displayOut    = 0 ;
        nDecs         = 4 ;
    
    elseif nargin == 5                                                          
        tValue_pooled = meanGrp1 ;
        nSizeGrp1     = meanGrp2 ;
        nSizeGrp2     = sdGrp1 ;
        ciSize        = sdGrp2 ;
        displayOut    = nSizeGrp1 ;
        nDecs         = 4 ;
        
    elseif nargin == 6                                                          
        tValue_pooled = meanGrp1 ;
        nSizeGrp1     = meanGrp2 ;
        nSizeGrp2     = sdGrp1 ;
        ciSize        = sdGrp2 ;
        displayOut    = nSizeGrp1 ;
        nDecs         = nSizeGrp2 ;
    end

    if nargin >= 8
        if (displayOut ~= 1 && displayOut ~= 0)
            error('XECI_ind2g:IncorrectDPO','Display output flag not equal to 0 or 1.');
        end
    end


    % Generates Dialog Box error messages for input errors

    if nargin >= 7
        if (sdGrp1 <= 0)
            errordlg('Std dev for Group 1 is zero or negative ', ...
                     'Input Entry Error' ); 
            return
        elseif (sdGrp1 <= 0)
            errordlg('Std dev for Group 2 is zero or negative ', ...
                     'Input Entry Error' ); 
            return
        end
    end

    if (nSizeGrp1 <= 0)
        errordlg('Sample size for Group 1 is zero or negative ', ...
                 'Input Entry Error' ); 
        return
    end

    if (nSizeGrp2 <= 0)
        errordlg('Sample size for Group 2 is zero or negative ', ...
                 'Input Entry Error' ); 
        return
    end

    if (ciSize <= 0 || ciSize >= 100)
        errordlg('Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' ); 
        return
    end
   
    if nargin == 7
       displayOut = 0 ;
       nDecs = 4 ; 
    end ;
    
    if nargin == 8
       nDecs = 4 ;
    end ;
   
%% ------------------------------------------------ Preliminary calculations

    nSize = nSizeGrp1 + nSizeGrp2;
    df = nSize - 2;

    dfTwo = 2 * df;

    nTilde = (nSizeGrp1 * nSizeGrp2) / nSize;
    nTilde_sqrt = sqrt(nTilde);

    varGrp1 = sdGrp1 * sdGrp1;
    varGrp2 = sdGrp2 * sdGrp2;

    if (ciSize > 0 && ciSize < 1)
        ciSize = ciSize * 100;
    end

    probCI = [((100+ciSize)/200) ((100-ciSize)/200)];                       % P values for defining CI bounds

    tCritical = tinv(1 - probCI,df);                                        % lower and upper bound t values
    zCritical = norminv(1 - probCI, 0, 1);                                  % lower and upper bound z values


    % Hedges' bias adjustment weight used in calculating d from g

    if nSize > 100
        jCorrection = 1 - (3 / (4 * nSize - 9));
    else
        jCorrection = exp(gammaln(df / 2)) ./ ...
            ( sqrt(df / 2) * exp(gammaln((df - 1) / 2)) );
    end

   
%% ------------------------------------------------ Calculating effect sizes   

    % Input Type = A
    
    if nargin >= 7

        meanDiff = meanGrp1 - meanGrp2;                                     % Raw mean difference

        varPooled = ( ((nSizeGrp1 - 1) * varGrp1) + ...
            ((nSizeGrp2 - 1) * varGrp2) ) / df;                             % Pooled variance
        sdPooled = sqrt(varPooled);                                         % Pooled SD

        gHedges = meanDiff / sdPooled;                                      % Hedges' g (called 'd_2' in Viechtbauer, 2007)
        gHedges_unbiased = gHedges * jCorrection;                           % Unbiased g (called 'g_2' in Viechtbauer, 2007)

        dGlass = meanDiff / sdGrp1;                                         % Glass' delta
        dGlass_unbiased = dGlass * jCorrection;                             % Unbiased delta

        ciMean = meanDiff + (tCritical * (sdPooled / nTilde_sqrt));         % CI for raw difference

        tValue_pooled = gHedges * nTilde_sqrt;                              % Observed t statistic (pooled)
        stdError = sdPooled / nTilde_sqrt;

    % Input Type = B

    elseif nargin >= 4 && nargin <= 6 

        meanDiff = NaN;

        gHedges = tValue_pooled / nTilde_sqrt;                              % Hedges' g (called 'd_2' in Viechtbauer, 2007)
        gHedges_unbiased = gHedges * jCorrection;                           % Unbiased g (called 'g_2' in Viechtbauer, 2007)

        dGlass = NaN;
        dGlass_unbiased = NaN;

        ciMean = [NaN NaN];
    end

    tProb_pooled = 2 * (1 - tcdf(abs(tValue_pooled),df));                   % Observed P value for pooled variance t statistic

   
%% ---------------------------- Separate variance (Satterthwaite correction)

    if nargin > 7
        varSeparate = (varGrp1 / nSizeGrp1) + ...
                        (varGrp2 / nSizeGrp2);

        sdtError_Sep = sqrt(varSeparate);

        tmp1 = varSeparate^2;
        tmp2 = (varGrp1 / nSizeGrp1 )^2 / (nSizeGrp1-1);
        tmp3 = (varGrp2 / nSizeGrp2 )^2 / (nSizeGrp2-1);

        dfSeparate = tmp1 / (tmp2 + tmp3);

        tValue_separate = meanDiff / sdtError_Sep;

        tProb_separate = 2 * (1 - tcdf(abs(tValue_separate), dfSeparate));  % Observed P value for separate variance t statistic

    else
        dfSeparate = NaN;
        tValue_separate = NaN;
        tProb_separate = NaN;

    end
      
   
%% --------------------------------------------------- Variance calculations

    % see Viechtbauer, 2007, Table 1 for details

    gHedges_sq = gHedges * gHedges;
    gHedges_unbiased_sq = gHedges_unbiased * gHedges_unbiased;

    var_gL1 = (1 / nTilde) + (gHedges_sq / dfTwo);                          % Variance for g (Viechtbauer, 2007, Eq. 28)
    var_dL1 = (1 / nTilde) + (gHedges_unbiased_sq / dfTwo);                 % Variance for d (Viechtbauer, 2007, Eq. 29)

    if (nargin >= 7)
        sGlass_sq = dGlass * dGlass;
        sGlass_unbiased_sq = dGlass_unbiased * dGlass_unbiased;
        var_sL1 = (1 / nTilde) + (sGlass_sq / dfTwo);                       % Generalised for Glass' delta from (Viechtbauer, 2007, Eq. 28)
        var_suL1 = (1 / nTilde) + (sGlass_unbiased_sq / dfTwo);             % Generalised for unbiased delta from (Viechtbauer, 2007, Eq. 29)
    end


    % Bonett's separate variance standardizer
    
    if nargin >= 7
        [tmp1, tmp2, ~, tmp4] = ...
            xeci_lincon( [meanGrp1 meanGrp2], [varGrp1 varGrp2], ...
                         [nSizeGrp1 nSizeGrp2], [1 -1], ciSize, 1, 0, nDecs);

        dBonett   = tmp1(2);
        ciBonett  = tmp2(2,:);
        varBonett = tmp4(3);

    else
        dBonett = NaN;
        ciBonett = [NaN NaN];
        varBonett = NaN;

    end
      

   
%% ---------------------------------------------------- Confidence intervals
   
    ciHedges = gHedges + (zCritical * sqrt(var_gL1));                       % CI for Hedges' g CI (Viechtbauer, 2007, Table 3: dL1z interval)
    ciHedges_unbiased = gHedges_unbiased + (zCritical * sqrt(var_dL1));     % CI for Unbiased g (Viechtbauer, 2007, Table 3: gL1z interval)

    if nargin >= 7
        ciGlass = dGlass + (zCritical * sqrt(var_sL1));                     % CI for Glass' delta
        ciGlass_unbiased = dGlass_unbiased + (zCritical * sqrt(var_suL1));  % CI for Unbiased delta
    else
        ciGlass = [NaN NaN];
        ciGlass_unbiased = [NaN NaN];
    end

    ciNCPs_pooled = ncp_t(tValue_pooled, df, probCI);                       % CI for homoscedastic noncentrality parameter
    ciExact_pooled = ciNCPs_pooled / nTilde_sqrt;                           % CI for standardized homoscedastic noncentrality parameter

    if nargin >= 7
        ciNCPs_separate = ncp_t(tValue_separate, dfSeparate, probCI);       % CI for heteroscedastic noncentrality parameter
        ciExact_separate = ciNCPs_separate / nTilde_sqrt;                   % CI for standardized heteroscedastic noncentrality parameter

    else
        ciNCPs_separate = [NaN NaN];
        ciExact_separate = [NaN NaN];

    end
   

%% --------------------------------------------- Combine like-minded outputs

    % All effect size point estimates
    
    esXECI = zeros(6,1);
    esXECI(1) = meanDiff;
    esXECI(2) = gHedges;
    esXECI(3) = gHedges_unbiased;
    esXECI(4) = dGlass;
    esXECI(5) = dGlass_unbiased;
    esXECI(6) = dBonett;


    % All effect size interval estimates
    
    ciXECI = zeros(10,2);
    ciXECI(1,1:2) = ciMean;
    ciXECI(2,1:2) = ciHedges;
    ciXECI(3,1:2) = ciHedges_unbiased;
    ciXECI(4,1:2) = ciGlass;
    ciXECI(5,1:2) = ciGlass_unbiased;
    ciXECI(6,1:2) = ciBonett;
    ciXECI(7,1:2) = ciExact_pooled;
    ciXECI(8,1:2) = ciExact_separate;
    ciXECI(9,1:2) = ciNCPs_pooled;
    ciXECI(10,1:2) = ciNCPs_separate;


    % All relevant test statistic values
    
    tsXECI = zeros(9,1);
    tsXECI(1) = tValue_pooled;
    tsXECI(2) = df;
    tsXECI(3) = tProb_pooled;
    tsXECI(4) = jCorrection;
    tsXECI(5) = tValue_separate;
    tsXECI(6) = dfSeparate;
    tsXECI(7) = tProb_separate;

    if (nargin >= 7)
        tsXECI(8) = stdError;
        tsXECI(9) = sdtError_Sep;
    end


    % All relevant variance estimates
    
    if nargout == 4
        varXECI = zeros(4,1);
        if  (nargin >= 7)
            varXECI(1) = varPooled;
            varXECI(2) = var_gL1;
            varXECI(3) = var_dL1;
            varXECI(4) = varBonett;
        end
    end

   

%% ------------------------------------------ If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;

        disp(blanks(3)');
        
        str = [...
            ' Estimates of Effect Sizes for Two Independent Samples'; ...
            ' ====================================================='];
        
        disp(str);
        disp(blanks(2)');

        label_esXECI = char(...
            '   Mean difference:              ', ...
            '   Hedges'' g:                   ', ...
            '   Unbiased g:                   ', ...
            '   Glasss'' delta:               ', ...
            '   Unbiased delta:               ', ...
            '   Bonett''s delta               ');

        label_ciXECI = char(...
            '   Raw mean:                     ', ...
            '   Hedges'' g:                   ', ...
            '   Unbiased g:                   ', ...
            '   Glass'' delta:                ', ...
            '   Unbiased delta:               ', ...
            '   Bonett''s delta:              ', ...
            '   Non-central:                  ', ...
            '   Satterthwaite NC:             ', ...
            '   Noncentral Parameter Values:  ', ...
            '   Satterthwaite NC Parameters:  ');

        label_tsXECI = char(...
            '   t value:                      ', ...
            '   Degrees of freedom:           ', ...
            '   Observed P:                   ', ...
            '   Value for c(m):               ', ...
            '   Satterthwaite t value:        ', ...
            '   Satterthwaite df:             ', ...
            '   Satterthwaite P value:        ', ...
            '   Standard error (pooled):      ', ...
            '   Standard error (sep.):        ');

        label_varXECI = char(...
            '   Pooled variance:              ', ...
            '   Var_gL1 (Hedges):             ', ...
            '   Var_dL1 (Unbiased Hedges):    ', ...
            '   Var_dhat (Bonett):            ');


        nr = length(ciXECI);
        c1 = char(40*ones(nr,1));     % (
        c2 = char(44*ones(nr,1));     % ,
        c3 = char(32*ones(nr,1));     % space
        c4 = char(41*ones(nr,1));     % )


        str = [...
            ' Point Estimates'; ...
            ' ---------------'];
        disp(str);
        
        if nargin >= 8
            na = 1:6;
        elseif nargin == 5
            na = [2 3];
        end
        
        disp( horzcat(label_esXECI(na,:), num2str(esXECI(na,1), strDecs)) );
        disp(blanks(1)');


        if (mod(ciSize,1) == 0)
            str = [...
                ' ' num2str(ciSize,'%2.0f') ...
                  '% Confidence Intervals'; ...
                ' ------------------------'];
        else
            str = [' ' num2str(ciSize,'%3.1f') ...
                     '% Confidence Intervals'; ...
                ' --------------------------'];
        end
        disp( horzcat(str));
        
        if nargin >= 8
            nb = 1:10;
        elseif nargin == 5
            nb = [2 3 7 9];
        end
        
        disp( horzcat( label_ciXECI(nb,:), c1(nb), num2str(ciXECI(nb,1), strDecs), ...
                                   c2(nb), c3(nb), num2str(ciXECI(nb,2), strDecs), c4(nb)) ) ;
        disp(blanks(1)');


        str = [...
            ' Test Statistics Results'; ...
            ' -----------------------'];
        disp(str);

        str_tsXECI = mixed2str(tsXECI, [0 1 2 0 0 0 2 0 0], 10, nDecs);
        
        if nargin >= 7
            nc = 1:9;
        else
            nc = 1:3;
        end
        
        disp( horzcat(label_tsXECI(nc,:), str_tsXECI(nc,:) ));
        disp(blanks(1)');


        if nargin >= 7 && nargout == 4
            str = [...
                ' Variance Estimates'; ...
                ' ------------------'];
            disp(str);

            str_varXECI = num2str(varXECI, strDecs);
            disp( horzcat(label_varXECI, str_varXECI) );
            disp(blanks(2)');
        end

    end
%% ---------------------------------------------------------End of function   
   
return
   


