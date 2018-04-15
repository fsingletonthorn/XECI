function [esXECI, ciXECI, tsXECI, varXECI] = xeci_dep2g(meanGrp1, meanGrp2, sdGrp1, sdGrp2, ...
                                        sampleCorr, nSize, ciSize, iType, displayOut, nDecs)
%
% XECI_DEP2G calculates effect sizes and CIs for two dependent group designs
%
%
%   INPUT: (one of the following three options)
% 
%       ONE OF...
% 
%           meanGrp1   = first mean in pair
%           meanGrp2   = second mean in pair
%           sdGrp1     = first SD in pair
%           sdGrp2     = second SD pair
%           sampleCorr = observed correlation between paired scores
% 
%       OR...
% 
%           meanGrp1   = first mean in pair
%           meanGrp2   = second mean in pair
%           sdGrp1     = first SD in pair
%           sdGrp2     = second SD pair
%           tValue     = observed t statistic value
% 
%       OR...
% 
%           tValue     = observed t statistic value
%           sampleCorr = observed correlation between paired scores
% 
%       PLUS...
% 
%           nSize      = sample size
%           ciSize     = confidence interval size (between 0 and 100)
%           iType      = input type {1 or 2 or 3} 
%           displayOut = display output               (1 = yes, 0 = no)
%           nDecs      = number of displayed decimals (default = 4)
% 
% 
%   OUTPUT:      
%           esXECI = (7 X 1) vector of point estimates of effect sizes 
%                     Raw mean difference
%                     Hedges' g (Individual Change)
%                     Unbiased g (Individual Change)
%                     Glass' delta (Group Difference)
%                     Unbiased delta (Group Difference)
%                     Dunlap et al's d (Group Difference)
%                     Bonett's delta (Group Difference)
%                     
%
%           ciXECI = (10 X 2) matrix of lower and upper bound CI estimates
%                     Raw mean difference
%                     Noncentrality Parameters
%                     Hedges' g (Individual Change)
%                     Unbiased g (Individual Change)
%                     Noncentral (Individual Change)
%                     Glass' delta (Group Difference)
%                     Unbiased delta (Group Difference)
%                     Dunlap et al's d (Group Difference)
%                     Bonett's delta (Group Difference)
%                     Noncentral (Group Difference)
%                     
%
%           tsXECI = (4 X 1) vector of t test results
%                     t statistic value
%                     Degrees of freedom
%                     Obtained P value
%                     Sample Correlation
%                     Unbiased Correlation
%                     Hedges' c(m) bias weight
%
%
%           vgXECI = (9 X 2) vector of estimated variances
%                     pooled variance ~ var_dd
%                     g1B ~ d1B   (Viechtbauer, 2007, Eqs. 23 & 24) ] for individual change
%                     g1U ~ d1U   (Viechtbauer, 2007, Eqs. 25 & 26) ] for individual change
%                     g1L1 ~ d1L1 (Viechtbauer, 2007, Eqs. 28 & 29) ] for individual change
%                     g1L2 ~ d1L2 (Viechtbauer, 2007, Eqs. 30 & 31) ] for individual change
%                     g2B ~ d2B   (Viechtbauer, 2007, Eqs. 34 & 35) ] for group differences
%                     g2U ~ d2U   (Viechtbauer, 2007, Eqs. 36 & 37) ] for group differences 
%                     g2L1 ~ d2L1 (Viechtbauer, 2007, Eqs. 39 & 40) ] for group differences
%                     g2L2 ~ d2L2 (Viechtbauer, 2007, Eqs. 41 & 42) ] for group differences
%
% 
% 
%  Notes:   (1) If Option 2 input type is used, then...
%                 -  'm1' input argument replaced by 't'
%                 -  'm2' input argument replaced by 'n1'
%                 -  'sd1' input argument replaced by 'n2'
%                 -  'sd2' input argument replaced by 'ci'
%                 -  ...and all remaining input arguments are ignored
%
%           (2) 'ci' is a percentage value (e.g., use '95' for 95% CI)
%
%           (3) Viechtbauer (2007) uses 'd' and 'g' to indicate the biased and unbiased standardised 
%               mean differences respectively, which is the opposite to that used elsewhere. All
%               calculations below use the more typical nomenclature of 'g' and 'unbaised g' for the 
%               biased and unbiased estimates respectively (carried over to variance estimates also).
%
%
% See also ncp_t
%

%
%   VERSION HISTORY
%       Created:    12 Jul 2008 
%       Revision:   14 Jul 2008 ~   Changed calculations for variances of g 
%                                   and d estimates based on Viechtbauer (2007) 
%       Revision:   14 Nov 2009 ~   Added vgXECI as an output option
%
%       Revision:    1 Oct 2015 ~   Removed unbiased correlation estimates
% 


%%  -------------------------------------------- Initialise output arguments
    
    esXECI = [];
    ciXECI = [];
    tsXECI = [];
    varXECI = [];


%% ------------------------------------------------ Checking input arguments
    
    if nargin < 6
        error('XECI_dep2g:TooFewInputs','Requires at least 6 input arguments.');
    end

    if nargin == 6  || nargin == 7
        displayOut = nSize;
        iType = sampleCorr;
        tValue = meanGrp1;
        sampleCorr = meanGrp2;
        nSize = sdGrp1;
        ciSize = sdGrp2;
        nDecs = 4 ;
    end

    if (iType ~= 1 && iType ~= 2 && iType ~= 3)
        error('XECI_dep2g:IncorrectInputType','Last argument should be 1 or 2 or 3.');
    end


    if (displayOut ~= 1 && displayOut ~= 0)
        error('XECI_dep2g:IncorrectDPO','Display output flag not equal to 0 or 1.');
    end


    % Generates Dialog Box error messages for input errors

    if nargin >= 9
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


    if iType ~= 2
        if ((sampleCorr <= -1) || (sampleCorr >= +1))
            errordlg('Sample correlation value is < -1 or > +1 ', ...
                     'Input Entry Error' ); 
            return
        end
    end

    if nSize <= 0
        errordlg('Sample size is less than or equals 0 ', ...
                 'Input Entry Error' ); 
        return
    end

    if (ciSize <= 0) || (ciSize >= 100)
        errordlg('Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' ); 
        return
    end

    if nargin == 8
       displayOut = 0 ;
       nDecs = 4 ;
    end ;
    
    if nargin == 9
       nDecs = 4 ;
    end ;


%% ------------------------------------------------ Preliminary calculations
    
    if iType == 2
        tValue = sampleCorr;
        varGrp1 = sdGrp1*sdGrp1;
        varGrp2 = sdGrp2*sdGrp2;
        sd = nSize * (meanGrp1 - meanGrp2)*(meanGrp1 - meanGrp2)/(tValue*tValue);
        sampleCorr = (varGrp1 + varGrp2 - sd)/(2 * sdGrp1 * sdGrp2);

        if sampleCorr <= -1
            errordlg( ' Correlation estimated from means, SDs and t value < -1 ', 'Input Entry Error' ); return;

        elseif sampleCorr >= 1
            errordlg( ' Correlation estimated from means, SDs and t value > 1 ', 'Input Entry Error' ); return;
        end

    end

    df = nSize - 1;
    df2 = df - 2;

    sqrtNsize = sqrt(nSize);

    probCI = [((100 + ciSize)/200) ((100 - ciSize)/200)];                   % P values for CI bounds

    tCritical = tinv(1 - probCI, df);                                       % lower and upper bound t values
    zCritical = norminv(1 - probCI,0,1);                                    % lower and upper bound z values


    % Hedges' bias adjustment weight used in calculating d from g

    if nSize > 100
        jCorrection = 1 - (3 / (4 * nSize - 9));
    else
        jCorrection = exp(gammaln(df / 2)) ./ ...
            ( sqrt(df / 2) * exp(gammaln((df - 1) / 2)) );
    end

    if iType == 3
        meanDiff = NaN;
        ciMeanDiff = [NaN NaN];
    end


    % Olkin & Pratt unbiased estimate of r

    unbiasedR = sampleCorr * ...
        hypergeomF(0.5, 0.5, (df-1)/2, 1-sampleCorr^2);


    % Used below in calculating variances for group difference cases

    sampleR_adj = 2 * (1 - sampleCorr);
    unbiasedR_adj = 2 * (1 - unbiasedR);



%% ------------------------------------------------ Calculating effect sizes

    % Gibbons et al's rationale (called individual change/repeated measures
    % in Morris & DeShon & notated as delta_RM; called delta_D in Viechtbauer)

    if iType ~= 3
        meanDiff = meanGrp1 - meanGrp2;                                     % Raw mean change

        varPooled = sdGrp1*sdGrp1 + sdGrp2*sdGrp2 ...
                    - 2*sdGrp1*sdGrp2*sampleCorr;                           % Variance of the change scores

        ciMeanDiff = meanDiff + (tCritical * (sqrt(varPooled)/sqrtNsize));  % CI for raw difference

        gHedges_change = meanDiff / sqrt(varPooled);                        % Hedges' g for standardized individual change
        dCohen_change = gHedges_change * jCorrection;                       % Unbiased g for standardized individual change

        if iType == 1
            tValue = gHedges_change * sqrtNsize;                            % Observed t statistic
        end

    else
        gHedges_change = tValue / sqrtNsize;                                % Hedges' g for standardized individual change

        dCohen_change = gHedges_change * jCorrection;                       % Unbiased g for standardized individual change
    end


    % Morris & DeShon's rationale (called group difference
    % in Morris & DeShon & notated as delta_IG; called delta_D2 in Viechtbauer)

    if iType ~= 3
        sdPooledGrp1 = sdGrp1;                                              % Uses SD of pre-treatment or control group
        gHedges_diff = meanDiff / sdPooledGrp1;                             % Hedges' g for standardized group difference
        dCohen_diff = gHedges_diff * jCorrection;                           % Unbiased g for standardized group difference
    else
        gHedges_diff = NaN;
        dCohen_diff = NaN;
    end

    dDunlap_diff = tValue * sqrt( 2 * (1 - sampleCorr) / nSize);            % Dunlap et al.'s homogeneity approximation of d for group differences

    if iType ~= 3
        stdError = sqrt(sdGrp1^2 + sdGrp2^2 - (2 * sampleCorr * sdGrp1 * sdGrp2))/sqrt(nSize);
    else
        stdError = NaN ;
    end ;


%% ---------------- Variance calculations [*** = recommended by Viechtbauer]

    % 2 dependent case for delta_D which corresponds to individual change
    % (Viechtbauer, 2007, Tables 1)

    var_g1B = (df * (1 + (nSize * gHedges_change * gHedges_change))) / ...
        (df2 * nSize) - ...
        (gHedges_change * gHedges_change) / ...
        (jCorrection * jCorrection);                                        % Variance for g (Viechtbauer, 2007, Eq. 23)

    var_d1B = (jCorrection * jCorrection * df * ...
        (1 + (nSize * dCohen_change * dCohen_change))) / ...
        (df2 * nSize) - ...
        (dCohen_change * dCohen_change);                                    % Variance for d (Viechtbauer, 2007, Eq. 24)

    var_g1U = (1 / (nSize * jCorrection * jCorrection)) + ...
        (1 - (df2/(df * jCorrection * jCorrection))) * ...
        (gHedges_change * gHedges_change);                                  % Variance for g (Viechtbauer, 2007, Eq. 25)

    var_d1U = (1 / nSize) + ...
        (1-(df2/(df * jCorrection * jCorrection))) * ...
        (dCohen_change * dCohen_change);                                    % Variance for d (Viechtbauer, 2007, Eq. 26)

    var_g1L1 = (1 / nSize) + ...
        ((gHedges_change * gHedges_change) / (2*df));                       % Variance for g (Viechtbauer, 2007, Eq. 28) (*** dL1)

    var_d1L1 = (1 / nSize) + ...
        ((dCohen_change * dCohen_change) / (2*df));                         % Variance for d (Viechtbauer, 2007, Eq. 29)

    var_g1L2 = (1 / nSize) + ...
        ((gHedges_change * gHedges_change) / (2*nSize));                    % Variance for g (Viechtbauer, 2007, Eq. 30)

    var_d1L2 = (1 / nSize) + ...
        ((dCohen_change * dCohen_change) / (2*nSize));                      % Variance for d (Viechtbauer, 2007, Eq. 31)


    % 2 dependent case for delta_D2 which corresponds to group differences
    % (Viechtbauer, 2007, Tables 2)

    var_g2B = (df * (sampleR_adj + ...
        (nSize * gHedges_diff * gHedges_diff))) / ...
        (df2 * nSize) - ...
        (gHedges_diff * gHedges_diff) / ...
        (jCorrection * jCorrection);                                        % Variance for g (Viechtbauer, 2007, Eq. 34)

    var_d2B = (jCorrection * jCorrection * df * ...
        (sampleR_adj + (nSize * dCohen_diff * dCohen_diff))) / ...
        (df2 * nSize) - ...
        (dCohen_diff * dCohen_diff);                                        % Variance for d (Viechtbauer, 2007, Eq. 35)

    var_g2U = (unbiasedR_adj / (nSize * jCorrection * jCorrection)) + ...
        (1 - (df2 / (df * jCorrection * jCorrection))) * ...
        (gHedges_diff * gHedges_diff);                                      % Variance for g (Viechtbauer, 2007, Eq. 36)

    var_d2U = (unbiasedR_adj / nSize) + ...
        (1 - (df2 / (df * jCorrection * jCorrection))) * ...
        (dCohen_diff * dCohen_diff);                                        % Variance for d (Viechtbauer, 2007, Eq. 37)

    var_g2L1 = (sampleR_adj / nSize) + ...
        ((gHedges_diff * gHedges_diff) / (2 * df));                         % Variance for g (Viechtbauer, 2007, Eq. 39)

    var_d2L1 = (sampleR_adj / nSize) + ...
        ((dCohen_diff * dCohen_diff) / (2 * df));                           % Variance for d (Viechtbauer, 2007, Eq. 40) *** gL1 < 1

    var_g2L2 = (sampleR_adj / nSize) + ...
        ((gHedges_diff * gHedges_diff) / (2 * nSize));                      % Variance for g (Viechtbauer, 2007, Eq. 41) *** dL2 > 1

    var_d2L2 = (sampleR_adj / nSize) + ...
        ((dCohen_diff * dCohen_diff) / (2 * nSize));                        % Variance for d (Viechtbauer, 2007, Eq. 42)

    var_dd = (sampleR_adj / nSize) + ...
        ((dDunlap_diff * dDunlap_diff) / (2 * nSize));                      % Variance estimate of Dunlap's d based on Viechtbauer, 2007, Eq. 41 / 42)


    % Bonett separate variance standardizer
    if iType < 3
        sampleCov = diag([sdGrp1 sdGrp2]).^2;
        sampleCov(2,1) = sdGrp1 * sampleCorr * sdGrp2;
        sampleCov(1,2) = sdGrp1 * sampleCorr * sdGrp2;

        [tmp1, tmp2, ~, tmp4] = ...
            xeci_lincon( [meanGrp1 meanGrp2], sampleCov, nSize, ...
            [1 -1], ciSize, 2, 0, nDecs);

        dBonett   = tmp1(2);
        ciBonett  = tmp2(2,:);
        varBonett = tmp4(3);
    else
        dBonett   = NaN;
        ciBonett  = [NaN NaN];
        varBonett = NaN;
    end


%% ---------------------------------------------------- Confidence intervals

    tProb = 2 * (1 - tcdf(abs(tValue), df));                                % Observed P value

    ciHedges_change = gHedges_change + (zCritical * sqrt(var_g1L1));        % CI for Hedges' g for standardized change      (*** dL1)
    ciCohen_change  = dCohen_change  + (zCritical * sqrt(var_d1L1));        % CI for Unbiased g for standardized change

    if abs(gHedges_change) < 1
        ciHedges_diff = gHedges_diff + (zCritical * sqrt(var_g2L1));        % CI for Hedges' g for standardized difference  (*** gL1)
        ciCohen_diff  = dCohen_diff  + (zCritical * sqrt(var_d2L1));        % CI for Unbiased g for standardized difference
    else
        ciHedges_diff = gHedges_diff + (zCritical * sqrt(var_g2L2));        % CI for Hedges' g for standardized difference  (*** dL2)
        ciCohen_diff  = dCohen_diff  + (zCritical * sqrt(var_d2L2));        % CI for Unbiased g for standardized difference
    end

    ciDunlap_diff  = dDunlap_diff + (zCritical * sqrt(var_dd));             % CI for Dunlap et al's d standardised estimate of group differences

    ciNCPs         = ncp_t(tValue, df, probCI);                             % CI for noncentrality parameter
    ciExact_change = ciNCPs / sqrtNsize;                                    % CI for standardized noncentrality parameter for standardized change
    ciExact_diff   = ciExact_change * sqrt(unbiasedR_adj);                  % CI for standardized noncentrality parameter for standardized difference


%% --------------------------------------------- Combine like-minded outputs

    % All effect size point estimates
    esXECI = zeros(6,1);
    esXECI(1) = meanDiff;
    esXECI(2) = gHedges_change;
    esXECI(3) = dCohen_change;
    esXECI(4) = gHedges_diff;
    esXECI(5) = dCohen_diff;
    esXECI(6) = dDunlap_diff;
    esXECI(7) = dBonett;


    % All effect size interval estimates
    ciXECI = zeros(10,2);
    ciXECI(1,1:2) = ciMeanDiff;
    ciXECI(2,1:2) = ciHedges_change;
    ciXECI(3,1:2) = ciCohen_change;
    ciXECI(4,1:2) = ciExact_change;
    ciXECI(5,1:2) = ciHedges_diff;
    ciXECI(6,1:2) = ciCohen_diff;
    ciXECI(7,1:2) = ciDunlap_diff;
    ciXECI(8,1:2) = ciExact_diff;
    ciXECI(9,1:2) = ciBonett;
    ciXECI(10,1:2) = ciNCPs;


    % All relevant test statistic values
    tsXECI = zeros(7,1);
    tsXECI(1) = tValue;
    tsXECI(2) = df;
    tsXECI(3) = tProb;
    tsXECI(4) = sampleCorr;
    tsXECI(5) = unbiasedR;
    tsXECI(6) = jCorrection;
    tsXECI(7) = stdError;


    % All relevant variance estimates
    if nargout == 4
        if iType < 3
            varXECI = zeros(10,2);
            varXECI(1,1) = varPooled;
            varXECI(1,2) = var_dd;
            varXECI(2,1) = var_g1B;
            varXECI(2,2) = var_d1B;
            varXECI(3,1) = var_g1U;
            varXECI(3,2) = var_d1U;
            varXECI(4,1) = var_g1L1;
            varXECI(4,2) = var_d1L1;
            varXECI(5,1) = var_g1L2;
            varXECI(5,2) = var_d1L2;

            varXECI(6,1) = var_g2B;
            varXECI(6,2) = var_d2B;
            varXECI(7,1) = var_g2U;
            varXECI(7,2) = var_d2U;
            varXECI(8,1) = var_g2L1;
            varXECI(8,2) = var_d2L1;
            varXECI(9,1) = var_g2L2;
            varXECI(9,2) = var_d2L2;
            varXECI(10,1) = varBonett;
        else
            varXECI = NaN;
        end
    end


%% ------------------------------------------ If output display is requested

    if (displayOut == 1)
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;

        disp(blanks(3)');
        
        headingMain = [...
            ' Estimates of Effect Sizes for Two Dependent Samples'; ...
            ' ==================================================='];
        disp(headingMain);
        disp(blanks(2)');

        label_esXECI = char(...
            '   Mean difference:             ', ...
            '   Hedges'' g (Indv. Change):   ', ...
            '   Unbiased g (Indv. Change):   ', ...
            '   Glass'' delta (Grp Diff):    ', ...
            '   Unbiased delta (Grp Diff):   ', ...
            '   Dunlap''s d (Grp Diff):      ', ...
            '   Bonett''s delta (Grp Diff):  ');

        label_ciXECI = char(...
            '   Raw mean:                    ', ...
            '   Hedges'' g (Indv. Change):   ', ...
            '   Unbiased g (Indv. Change):   ', ...
            '   Noncentral (Indv. Change):   ', ...
            '   Glass'' delta (Grp Diff.):   ', ...
            '   Unbiased delta (Grp Diff.):  ', ...
            '   Dunlap''s d (Grp Diff.):     ', ...
            '   Noncentral (Grp Diff.):      ', ...
            '   Bonett''s delta (Grp Diff.): ', ...
            '   Noncentrality Parameters:    ');

        label_tsXECI = char(...
            '   t value:                     ', ...
            '   Degrees of freedom:          ', ...
            '   Obtained P:                  ', ...
            '   Sample Correlation:          ', ...
            '   Unbiased Correlation:        ', ...
            '   Value for c(m):              ', ...
            '   Standard error:              ');

        label_varXECI = char(...
            '   Pooled var / Var_dd:        ', ...
            '   Var_1B (g/d):               ', ...
            '   Var_1U (g/d):               ', ...
            '   Var_1L1 (g/d)               ', ...
            '   Var_1L2 (g/d):              ', ...
            '   Var_2B (g/d):               ', ...
            '   Var_2U (g/d):               ', ...
            '   Var_2L1 (g/d):              ', ...
            '   Var_2L2 (g/d):              ', ...
            '   Var_dhat:                   ');


        nRows = length(ciXECI);
        c1 = char(40 * ones(nRows, 1));     % (
        c2 = char(44 * ones(nRows, 1));     % ,
        c3 = char(32 * ones(nRows, 1));     % space
        c4 = char(41 * ones(nRows, 1));     % )


        headingEffects = [...
            ' Point Estimates'; ...
            ' ---------------'];
        disp(headingEffects);
        
        if iType == 3
            nEffects = [2 3 6];
        else
            nEffects = 1:7;
        end
        
        disp( horzcat(label_esXECI(nEffects,:), ...
            num2str(esXECI(nEffects,1), strDecs)) );
        disp(blanks(1)');


        if (mod(ciSize,1) == 0)
            headingInterval = [' ' num2str(ciSize,'%6.0f') ...
                '% Confidence Intervals'; ' ------------------------'];
        else
            headingInterval = [' ' num2str(ciSize,'%6.1f') ...
                '% Confidence Intervals'; ' --------------------------'];
        end
        
        disp( horzcat(headingInterval));

        if iType == 3
            nIntervals = [2:4 7 8 10];
        else
            nIntervals = 1:10;
        end
        
        disp( horzcat( label_ciXECI(nIntervals,:), c1(nIntervals), ...
                            num2str(ciXECI(nIntervals,1), strDecs), c2(nIntervals), ...
            c3(nIntervals), num2str(ciXECI(nIntervals,2), strDecs), ...
            c4(nIntervals)) ) ;
        disp(blanks(1)');


        headingStats = [...
            ' Test Statistics Results'; ...
            ' -----------------------'];
        disp(headingStats);

        str_tsXECI = mixed2str(tsXECI, [0 1 2 0 0 0 0], 10, nDecs);
        
        if (iType == 3)
            nStatistics = 1:6;
        else
            nStatistics = 1:7;
        end
        
        disp( horzcat(label_tsXECI(nStatistics,:), str_tsXECI(nStatistics,:) ));
        disp(blanks(1)');


        if iType < 3 && nargout == 4
            headingVar = [...
                ' Variance Estimates'; ...
                ' ------------------'];

            disp(headingVar);
            str_varXECI = num2str(varXECI, strDecs);
            disp( horzcat(label_varXECI, str_varXECI ) );
            disp(blanks(2)');
        end

    end
    
return
