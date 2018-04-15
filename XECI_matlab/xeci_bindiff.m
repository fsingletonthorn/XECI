function [esXECI, ciXECI, tsXECI, varXECI] = xeci_bindiff(sampleP1, nTrials1, ...
                                                          sampleP2, nTrials2, ...
                                                          nullDiff, ...
                                                          ciSize, iType1, iType2, ...
                                                          displayOut, nDecs)
%
% XECI_BINDIFF calculates various effect sizes and CIs for a difference in proportions
% 
%
%   INPUT: 
%       
%     IF Itype2 == 1 (Independent)
%
%           sampleP1 = sample proportion for Grp 1        (if iType1 = 1)
%           sampleP2 = sample proportion for Grp 2        (if iType1 = 1)
%   Or:
%                    = number of successes for Grp 1      (if iType1 = 2)
%                    = number of successes for Grp 2      (if iType1 = 2)
%
%   Plus:
%           nTrials1 = number of trials for Grp 1
%           nTrials2 = number of trials for Grp 2
%
%     IF Itype2 == 2 (Dependent)
%
%           sampleP1 = postive at both time points
%           sampleP2 = positive at T1 & negative at T2
%           nTrials1 = negative at T1 & positive at T2
%           nTrials2 = negative at both time points
%   
%
%     FOR BOTH Itype2s
%
%           nullDiff = null hypothesised difference 
%           ciSize   = confidence interval size                     (*1)
%
%           iType1     = (1 is sample proportion, or 2 is for number of successes)
%           iType2     = (1 if independent proportions, or 2 if dependent proportions) 
%           displayOut = display output {1 = yes, 0 = no [default]}         (*2)
%           nDecs      = Number of decimlas in results for DISPLAYOUT.
%
%
% 
% OUTPUT:
%           esXECI   = (5 X 1) vector of point estimates of effect sizes 
%                             * ML estimate
%                             * Agresti-Coull +2 estimate
%                             * Wilson mid-point estimate
%                             * No. successes (X)
%                             * No. trials (N)
%
%           ciXECI = (7 X 2) matrix of interval estimates of effect sizes
%                             * Large-sample Wald
%                             * Large-sample Wilson 
%                             * Agresti-Coull z-sq
%                             * Agresti-Coull +2
%                             * Mid-P
%                             * Blaker 
%                             * Clopper-Pearson Exact
% 
%           tsXECI   = (7 X 1) vector of test statistics and probabilities
%                             * Exact 2-sided P
%                             * Exact 1-sided P(pi >= p)
%                             * Exact 1-sided P(pi <= p)
%                             * 1-sided Mid-P(pi >= p)
%                             * Large sample z statistic
%                             * Large sample z-based P
%                             * 2-sided opposite X value
% 
%
%
%
%  Notes:   (*1) CI argument is a percentage value (e.g., use '95' for 95% CI)
%           (*2) Argument displayOut provides formated output to screen 
%                   (1 = YES or 0 = NO)
%
%
% See also XECIm, 
%

%
% VERSION HISTORY
%       Created:    04 Dec 2009 
%       Revision:   09 Jul 2011 ~ Reformatted input / output
%                               ~ Incorporated p2sided.m into file 
%                                 as an additional function
%
%

%% ----------------------------------------Initial check of input arguments

    if nargin ~= 8 && nargin ~= 9 && nargin ~= 10
        error('XECI_binom:TooFewInputs','Requires at least 8 input arguments.') ;
    end

    if (displayOut ~= 1 && displayOut ~= 0)
        error('XECI_binom:IncorrectDPO','Display output flag not equal to 0 or 1.') ;
    end


    % Generates Dialog Box error messages for input errors

    if (iType1 == 1 && (sampleP1  <  0 || sampleP1 > 1))
        errordlg('Sample proportion for Grp 1 is not between 0 and 1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (iType1 == 1 && (sampleP2  <  0 || sampleP2 > 1))
        errordlg('Sample proportion for Grp 2 is not between 0 and 1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (nullDiff  <  -1 || nullDiff > 1)
        errordlg('Null-hypothesised difference is not between -1 and +1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (nTrials1  <  1)
        errordlg('Input value for Grp 1 sample size less than  1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (nTrials2  <  1)
        errordlg('Input value for Grp 2 sample size less than  1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (ciSize <= 0 || ciSize >= 100)
        errordlg( 'Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' ) ; 
        return
    end

    if nargin == 9
       nDecs = 4 ;
    end ;
    
    if nargin == 8
       displayOut = 0 ;
       nDecs      = 4 ;
    end ;

    
    %% ------------------------------------------------Preliminary calculations

    % Independent proportions
    if iType2 == 1
        
        if iType1 == 1
            nSuccess1 = floor(sampleP1 * nTrials1 + 0.5) ;
            nSuccess2 = floor(sampleP2 * nTrials2 + 0.5) ;

        elseif iType1 == 2
            nSuccess1 = sampleP1 ;
            nSuccess2 = sampleP2 ;

            sampleP1  = nSuccess1 / nTrials1 ;
            sampleP2  = nSuccess2 / nTrials2 ;
        end ;

        % Assumes Treatments in Rows and Outcomes in Columns
        a = nSuccess1 ;
        b = nTrials1  - nSuccess1 ;
        c = nSuccess2 ;
        d = nTrials2 -  nSuccess2 ;
    
        m = a + b ;
        n = c + d ;
        r = a + c ;
        s = b + d ; 
        
        propDiff = sampleP1 - sampleP2 ;
        
        nSize    = nTrials1 + nTrials2 ;
        
    % Dependent proportions
    elseif iType2 == 2
        
        e = sampleP1 ;
        f = nTrials1 ;
        g = sampleP2 ;
        h = nTrials2 ;
        
        nSize    = e + f + g + h ;
 
        sampleP1 = (e + f) / nSize ;
        sampleP2 = (e + g) / nSize;
        
        propDiff = (f - g) / nSize; 

    end ;
        
    probCI    = [((100+ciSize)/200) ((100-ciSize)/200)] ;                   % P values for defining CI bounds
    zCritical = -1 * norminv(probCI, 0, 1) ;



    
    %% ------------------------------- Calculations for Independent Proportions

    if iType2 == 1
       
        % Wald SE with no continuity correction
        tmp1   = sampleP1 * (1 - sampleP1) / nTrials1 ;
        tmp2   = sampleP2 * (1 - sampleP2) / nTrials2 ;
        seWald = sqrt(tmp1 + tmp2) ;

        % Wald SE with continuity correction
        WaldCC = 0.5 * ( (1/nTrials1) + (1/nTrials2) ) ;
        
        % Wald SE with Agresti-Caffo +2 adjustment
        tmp1     = (a + 1) / (m + 2) ;
        tmp2     = (c + 1) / (n + 2) ;
        pDiffAC  = tmp1 - tmp2 ;
        tmp3     = tmp1 * (1 - tmp1) / (m + 2) ;
        tmp4     = tmp2 * (1 - tmp2) / (n + 2) ;
        seWaldAC = sqrt(tmp3 + tmp4) ;
        
        % Score SE
        tmp1 = (sampleP1 * nullDiff) * (1 - (sampleP1 * nullDiff)) / nTrials1 ;
        tmp2 = (sampleP2 * nullDiff) * (1 - (sampleP2 * nullDiff)) / nTrials2 ;
       
        seScore = sqrt(tmp1 + tmp2) ;
        
        % P values
        chisqValue = nSize * ( (a*d - b*c) / sqrt(m*n*r*s) )^2 ;
        probValue  = 1 - chi2cdf(chisqValue, 1) ;

        chiRight   = probValue/2 ;
        chiLeft    = 1 - chiRight ;
        
        yatesValue = ( nSize * (abs(a*d - b*c) - ...
                         0.5*nSize)^2 ) / (m*n*r*s) ;
        probYates  = 1 - chi2cdf(yatesValue, 1) ;
        
        yatesRight = probYates/2 ;
        yatesLeft  = 1 - yatesRight ;
            
        
        % Confidence intervals
        
        ciWald_0 = propDiff + (zCritical * seWald) ;                    % Newcombe (1998)  Method 1
        ciWald_1 = propDiff + ( (zCritical * seWald) + ...
                   [-WaldCC WaldCC] ) ;                                 % Newcombe (1998)  Method 2
        
        ciWald_2 = transCIxeci(propDiff, seWald, zCritical(2), 1) ;     % Browne transformation of Newcombe Method 1
        
        ciWaldAC = pDiffAC + (zCritical * seWaldAC) ;                   % Agresti & Caffo (2001)
        
        ciScore_0 = newcombe98b(a, m, c, n, ciSize, 0) ;                % Hybrid score, no continuity correction
        ciScore_1 = newcombe98b(a, m, c, n, ciSize, 1) ;                % Hybrid score, with continuity correction
        
        ciScoreMN = mnCI(a, m, c, n, ciSize) ;                          % Miettinen-Nurminen (1985)
        
        ciWaldMA  = MAZW4CI(a, m, c, n, ciSize) ;                       % Martin Andres et al. (2012)
        
        
        ciWald_0  = ciLimits(ciWald_0) ; 
        ciWald_1  = ciLimits(ciWald_1) ; 
        ciWald_2  = ciLimits(ciWald_2) ; 
        ciWaldAC  = ciLimits(ciWaldAC) ; 
        ciScore_0 = ciLimits(ciScore_0) ; 
        ciScore_1 = ciLimits(ciScore_1) ; 
        ciScoreMN = ciLimits(ciScoreMN) ; 
        ciWaldMA  = ciLimits(ciWaldMA) ; 
        
    end ;
       
    
    %% --------------------------------- Calculations for Dependent Proportions
    if iType2 == 2
       
        % Wald SE
        tmp1     = f / nSize ;
        tmp2     = g / nSize ;
        
        seWald   = sqrt( (tmp1 + tmp2 - (tmp1 - tmp2)^2) / nSize ) ;
        
        % Agresti-Min SE
        tmp3     = nSize + 2 ;
        tmp1     = (f + 0.5) / tmp3 ;
        tmp2     = (g + 0.5) / tmp3 ;
        
        pDiff_AM = (tmp1 - tmp2) ;
        seWaldAM = sqrt( (tmp1 + tmp2 - (tmp1 - tmp2)^2) / tmp3 ) ;

        % Bonett-Price Laplace SE
        tmp1     = (f + 1) / (nSize + 2) ;
        tmp2     = (g + 1) / (nSize + 2) ;
        tmp3     = nSize + 2 ;
        
        pDiff_BPL = tmp1 - tmp2 ;
        seBPL    = sqrt( (tmp1 + tmp2 - (tmp1 - tmp2)^2)/ tmp3 ) ;
       
        
        % Confidence intervals
        ciWald_0  = propDiff + (zCritical * seWald) ;                   % Newcombe (1998)  Method 1
        ciWald_1  = transCIxeci(propDiff, seWald, zCritical(2), 1) ;    % Browne transformation of Newcombe Method 1
        
        ciWaldAM  = pDiff_AM + (zCritical * seWaldAM) ;                 % Agresti & Min (2005)

        ciWaldBPL = pDiff_BPL + (zCritical * seBPL) ;                   % Agresti & Min (2005)
       
        ciScoreN  = newcombe98c(e, f, g, h, ciSize) ;                   % Newcombe (1998c) Hybrid Score 
        
        ciTango   = tango(f, g, nSize, ciSize) ;                        % Tango (1998) asymptotic score 
        
        
        % Test statistics
        chi_McN   = (f - g)^2 / (f + g) ;
        p_McNemar = 1 - chi2cdf(chi_McN, 1) ;
        
        p_midP    = midP_McNemar(f, g) ;
        
       
    end ;

%     %% ---------------------------------------------------------Test statistics
% 
%     % Exact test
%     probRight = binocdf(nTrials - nSuccess, nTrials, 1-nullPi) ;             % One-sided P(pi >= p)
%     probLeft  = binocdf(nSuccess, nTrials,  nullPi) ;                        % One-sided P(pi <= p)
% 
%     [probExact, tmp] = prob2sided(nSuccess, nTrials, nullPi) ;               % Two-sided exact test
% 
%     if isempty(tmp(tmp ~= nSuccess))
%         nSuccess_Opposite = NaN ;
%     else
%         nSuccess_Opposite = tmp(tmp ~= nSuccess) ;
%     end
%     
%     % Mid-P test
%     midProb = binopdf(nSuccess, nTrials, nullPi)/2 + ...
%                       (binocdf(nTrials-nSuccess-1, nTrials, 1-nullPi)) ;    % One-sided mid-P for P(pi >= p)
% 
%    % Asymptotic tests with and without continuity correction
%    ccValue = (1 / (2*nTrials)) ;
%     
%    numerator = (sampleP - nullPi) ;
%    
%    if sampleP >= nullPi
%       numContC = numerator - ccValue ;
%    else
%       numContC = numerator + ccValue ;
%    end ;
%    
%    seWald    = sqrt(varWald) ;
%    seScore   = sqrt(varScore) ;
%    
%    if CC == 1
%       zWald  = numContC  / seWald ;
%       zScore = numContC  / seScore ;
% 
%       pWald  = 2*(1 - normcdf(abs(zWald),  0, 1)) ;                         % Wald test corrected
%       pScore = 2*(1 - normcdf(abs(zScore), 0, 1)) ;                         % Score test corrected
%    
%    else
%       zWald  = numerator / seWald ;
%       zScore = numerator / seScore ;
% 
%       pWald  = 2*(1 - normcdf(abs(zWald),  0, 1)) ;                         % Wald test uncorrected
%       pScore = 2*(1 - normcdf(abs(zScore), 0, 1)) ;                         % Score test uncorrected
%    end ;

    
    
    %% ---------------------------------------------Combine like-minded outputs

    % All effect size point estimates for both independent and dependent differences
    esXECI = zeros(3,1) ;
    esXECI(1) = sampleP1 ;
    esXECI(2) = sampleP2 ;
    esXECI(3) = propDiff ;

    if iType2 == 1
        esXECI(4) = pDiffAC ;
    end ;

    % All effect size interval estimates
    
    if iType2 == 1                                  % Independent differences
        ciXECI = zeros(7,2) ;
        ciXECI(1,1:2) = ciWald_0 ;
        ciXECI(2,1:2) = ciWald_1 ;
        ciXECI(3,1:2) = ciWald_2 ;
        ciXECI(4,1:2) = ciWaldAC ;
        ciXECI(5,1:2) = ciScore_0 ;
        ciXECI(6,1:2) = ciScore_1 ;
        ciXECI(7,1:2) = ciScoreMN ;
        ciXECI(8,1:2) = ciWaldMA ;
    end ;
    
    if iType2 == 2                                  % Dependent differences
        ciXECI = zeros(6,2) ;
        ciXECI(1,1:2) = ciWald_0 ;
        ciXECI(2,1:2) = ciWald_1 ;
        ciXECI(3,1:2) = ciWaldAM ;
        ciXECI(4,1:2) = ciWaldBPL ;
        ciXECI(5,1:2) = ciScoreN ;
        ciXECI(6,1:2) = ciTango ;
    end ;



    % All relevant test statistic values
    if iType2 == 1                                  % Independent differences
        tsXECI = zeros(8,1) ;
        tsXECI(1) = chisqValue ;
        tsXECI(2) = probValue ;
        tsXECI(3) = chiRight ;
        tsXECI(4) = chiLeft ;
        tsXECI(5) = yatesValue ;
        tsXECI(6) = probYates ;
        tsXECI(7) = yatesRight ;
        tsXECI(8) = yatesLeft ;
    end ;
    
    if iType2 == 2                                  % Dependent differences
        tsXECI = zeros(3,1) ;
        tsXECI(1) = chi_McN ;
        tsXECI(2) = p_McNemar ;
        tsXECI(3) = p_midP ;
    end ;    

    
    % All relevant standard errors 
    
    
    if iType2 == 1                                  % independent differences
        varXECI = zeros(3,1) ;
        varXECI(1) = seWald ;
        varXECI(2) = seWaldAC ;
        varXECI(3) = seScore ;
    end ;
    
    
    if iType2 == 2                                  % Dependent differences
        varXECI = zeros(3,1) ;
        varXECI(1) = seWald ;
        varXECI(2) = seWaldAM ;
        varXECI(3) = seBPL ;
    end ;


%% ------------------------------------------If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;
        
        disp(blanks(3)') ;

        if iType2 == 1

            headingMain = [...
                ' Estimates of Effect Sizes for Difference in Independent Proportions' ; ...
                ' ==================================================================='] ;

            disp(headingMain) ;
            disp(blanks(2)') ;

            label_esXECI = char(...
                '   Sample P for Grp 1:            ', ...
                '   Sample P for Grp 2:            ', ...
                '   Difference in proportions:     ', ...
                '   Agresti-Caffo difference:      ') ;
            
            label_ciXECI = char(...
                '   Large sample Wald:             ', ...
                '   Continuity-Correct Wald:       ', ...
                '   Asymmetric Wald:               ', ...
                '   Agresti-Caffo:                 ', ...
                '   Hybrid Score:                  ', ...
                '   Continuity-corrected Score:    ', ...
                '   Miettinen-Nurminen:            ', ...
                '   Martin-Andres Wald:            ') ;

            label_tsXECI = char(...
                '   Chi-sq value:                  ', ...
                '   Obs P value:                   ', ...
                '   1-sided greater:               ', ...
                '   1-sided less:                  ', ...
                '   Yates'' chi-sq:                 ', ...
                '   Corrected P value:             ', ...
                '   1-sided greater:               ', ...
                '   1-sided less:                  ') ;

            label_varXECI = char(...
                '   Large-sample Wald:             ', ...
                '   Agresti-Caffo +4:              ', ...
                '   Large-sample score:            ') ;

            nRows = length(ciXECI) ;
            c1 = char(40 * ones(nRows, 1)) ;     % (
            c2 = char(44 * ones(nRows, 1)) ;     % ,
            c3 = char(32 * ones(nRows, 1)) ;     % space
            c4 = char(41 * ones(nRows, 1)) ;     % )


            headingEffects = [...
                ' Point Estimates' ; ...
                ' ---------------'] ;

            disp(headingEffects) ;
            str_esXECI = mixed2str(esXECI, [0 0 0 0], 10, nDecs) ;
            disp( horzcat(label_esXECI, str_esXECI ) ) ;
            disp(blanks(1)') ;


            if (mod(ciSize,1) == 0)
                headingInterval = [' ' num2str(ciSize, '%6.0f') ...
                    '% Confidence Intervals' ; ' ------------------------'] ;
            else
                headingInterval = [' ' num2str(ciSize, '%6.1f') ...
                    '% Confidence Intervals' ; ' --------------------------'] ;
            end

            disp( horzcat(headingInterval)) ;
            disp( horzcat( label_ciXECI, c1, num2str(ciXECI(:,1), strDecs), ...
                                         c2, c3, num2str(ciXECI(:,2), strDecs), c4) ) ;
            disp(blanks(1)') ;

            nc = [ 1 2 3 4 5 6 7 8] ;
            headingStats = [...
                ' Test Statistics Results' ; ...
                ' -----------------------'] ;
            disp(headingStats) ;
            str_tsXECI = mixed2str(tsXECI, [0 2 2 2 0 2 2 2], 10, nDecs) ;

            disp( horzcat(label_tsXECI(nc,:), str_tsXECI) ) ;

            disp(blanks(1)') ;


            headingSEs = [...
                ' Standard Error Estimates' ; ...
                ' ------------------------'] ;
            disp(headingSEs) ;
            str_varXECI = num2str(varXECI, strDecs) ;
            disp( horzcat(label_varXECI, str_varXECI ) ) ;
            
        end ;


        if iType2 == 2

            headingMain = [...
                ' Estimates of Effect Sizes for Difference in Dependent Proportions' ; ...
                ' ================================================================='] ;

            disp(headingMain) ;
            disp(blanks(2)') ;

            label_esXECI = char(...
                '   Sample P for Grp 1:            ', ...
                '   Sample P for Grp 2:            ', ...
                '   Difference in proportions:     ') ;
            
            label_ciXECI = char(...
                '   Large sample Wald:             ', ...
                '   Asymmetric Wald:               ', ...
                '   Agresti-Min:                   ', ...
                '   Bonett-Price score:            ', ...
                '   Newcombe hybrid score:         ', ...
                '   Tango asymptotic score:        ') ;
            
            label_tsXECI = char(...
                '   McNemar chi-sq value:          ', ...
                '   Obs P value:                   ', ...
                '   McNemar mid-P value:           ') ;

            label_varXECI = char(...
                '   Large-sample Wald:             ', ...
                '   Agresti-Min:                   ', ...
                '   Bonett-Price Laplace:          ') ;

            nRows = length(ciXECI) ;
            c1 = char(40 * ones(nRows, 1)) ;     % (
            c2 = char(44 * ones(nRows, 1)) ;     % ,
            c3 = char(32 * ones(nRows, 1)) ;     % space
            c4 = char(41 * ones(nRows, 1)) ;     % )


            headingEffects = [...
                ' Point Estimates' ; ...
                ' ---------------'] ;

            disp(headingEffects) ;
            str_esXECI = mixed2str(esXECI, [0 0 0], 10, nDecs) ;
            disp( horzcat(label_esXECI, str_esXECI ) ) ;
            disp(blanks(1)') ;


            if (mod(ciSize,1) == 0)
                headingInterval = [' ' num2str(ciSize, '%6.0f') ...
                    '% Confidence Intervals' ; ' ------------------------'] ;
            else
                headingInterval = [' ' num2str(ciSize, '%6.1f') ...
                    '% Confidence Intervals' ; ' --------------------------'] ;
            end

            disp( horzcat(headingInterval)) ;
            disp( horzcat( label_ciXECI, c1, num2str(ciXECI(:,1), strDecs), ...
                                         c2, c3, num2str(ciXECI(:,2), strDecs), c4) ) ;
            disp(blanks(1)') ;

            nc = [ 1 2 3] ;
            headingStats = [...
                ' Test Statistics Results' ; ...
                ' -----------------------'] ;
            disp(headingStats) ;
            str_tsXECI = mixed2str(tsXECI, [0 2 2], 10, nDecs) ;

            disp( horzcat(label_tsXECI(nc,:), str_tsXECI) ) ;

            disp(blanks(1)') ;


            headingSEs = [...
                ' Standard Error Estimates' ; ...
                ' ------------------------'] ;
            disp(headingSEs) ;
            str_varXECI = num2str(varXECI, strDecs) ;
            disp( horzcat(label_varXECI, str_varXECI ) ) ;
            
        end ;
        
        disp(blanks(2)') ;
 
    end ;
%% ---------------------------------------------------------End of function   
   
return


%% -------------------------------------Sub-functions used in main function



function [ciBounds] = newcombe98b(a, m, b, n, reqCI, cc) 
% Calculates hybrid score confidence interval for difference between
% independent proportions, with option of continuity correction.
%
%   INPUT:
%           a     = Number of successes in first group
%           m     = Number of trials in first group
%           b     = Number of successes in first group
%           n     = Number of trials in first group
%           reqCI = Required confidence interval size (default == 95)
%           cc    = continuity correction: 1 = yes (default), 0 = no
%
%   OUTPUT
%           ciBounds = lower and upper bounds of confidence interval
%
%   Ref: Newcombe (1998b), Statistics in Medicine, vol. 17, pp. 873-890
%
%   Notation follows that used in Newcombe, with reference also to 
%   formulas in Newcombe (1998a), vol 17, pp. 857-872
%

    % Create defaults if number of input arguments < 6
    if nargin == 4
        reqCI = 95 ;
        cc    = 1 ;
    elseif nargin == 5
        cc    = 1 ;
    end ;

    % Calculate critical z statistic for confidence interval
    alpha = (100 - reqCI) / 100 ;
    z = norminv( 1 - alpha/2, 0, 1) ;

    % Calculate sample proportions of each group
    p1 = a / m ;
    p2 = b / n ;

    % Calculate difference in proportions
    pDiff = p1 - p2 ;

    
    % Continuity correction (Method 11, p. 876)
    if cc == 1
        
        l(1) = ( 2*m*p1 + z^2 - 1 - z * sqrt(z^2 - 2 - (1/m ) + ...     % (1998a) Method 4(L)
                 4*p1*(m*(1-p1) + 1)) ) / (2 * (m + z^2)) ;

        u(1) = ( 2*m*p1 + z^2 + 1 + z * sqrt(z^2 + 2 - (1/m ) + ...     % (1998a) Method 4(U)
                 4*p1*(m*(1-p1) - 1)) ) / (2 * (m + z^2)) ;

        l(2) = ( 2*n*p2 + z^2 - 1 - z * sqrt(z^2 - 2 - (1/n ) + ...     % (1998a) Method 4(L) 
                 4*p2*(n*(1-p2) + 1)) ) / (2 * (n + z^2)) ;

        u(2) = ( 2*n*p2 + z^2 + 1 + z * sqrt(z^2 + 2 - (1/n ) + ...     % (1998a) Method 4(U)
                 4*p2*(n*(1-p2) - 1)) ) / (2 * (n + z^2)) ;    
    
    % No continuity correction (Method 10, p. 876)
    else

        l(1) = (2*m*p1 + z^2 - ...                                      % (1998a) Method 3(L)
                sqrt(4*m*p1*z^2 - 4*m*p1^2*z^2 + z^4)) / ... 
                (2*(m + z^2)) ;
            
        u(1) = (2*m*p1 + z^2 + ...                                      % (1998a) Method 3(U)
                sqrt(4*m*p1*z^2 - 4*m*p1^2*z^2 + z^4)) / ...            
                (2*(m + z^2)) ;

        l(2) = (2*n*p2 + z^2 - ...                                      % (1998a) Method 3(L)
                sqrt(4*n*p2*z^2 - 4*n*p2^2*z^2 + z^4)) / ...
                (2*(n + z^2)) ;
            
        u(2) = (2*n*p2 + z^2 + ...                                      % (1998a) Method 3(U)
                sqrt(4*n*p2*z^2 - 4*n*p2^2*z^2 + z^4)) / ...
                (2*(n + z^2)) ;

    end ;

    % Calculate delta and epsilon values
    d = sqrt( (a/m -l(1))^2  + (u(2) - b/n)^2) ;
    e = sqrt( (u(1) - a/m)^2  + (b/n - l(2))^2) ;
    
    % Calculate bounds of interval
    lb = pDiff - d ;
    ub = pDiff + e ;
   
    lb = max([-1 lb]) ;
    ub = min([ub 1 ]) ;
    
    ciBounds = [lb ub] ;
   
return


function [ciBounds] = mnCI(a, m, b, n, reqCI)
%  Miettinen-Nurminen confidence interval for difference in proportions
%  from two independent groups.
%
%   INPUT:
%           a     = Number of successes in first group
%           m     = Number of trials in first group
%           b     = Number of successes in first group
%           n     = Number of trials in first group
%           reqCI = Required confidence interval size (default == 95)
%
%   OUTPUT
%           ciBounds = lower and upper bounds of confidence interval
%
%   Ref: Miettinen & Nurminen (1985), Statistics in Medicine, vol. 4, pp. 213-226
%        (called Method 5 in , Statistics in Medicine, vol. 17, pp. 873-890. 
%
%   Adapted from code written by Alan Agresti and available on his website  
%   
%
%

    if nargin == 4
        reqCI = 95 ;
    end ;

    % Sample proportions for each group
    p1 = a / m ;
    p2 = b / n ;
    
    % Critical chi-square value for confidence interval
    critChi2 = chi2inv(reqCI/100, 1) ;
    
    % Difference in 
    pDiff = p1 - p2 ;
    
    
    dp = 1 - pDiff ;
    
    niter1 = 1 ;
    while (niter1 <= 50)
        dp = 0.5 * dp ;
        up2 = pDiff + dp ;
        
        score = z2stat(p1, m, p2, n, up2) ;
        
        if ( score < critChi2)
            pDiff = up2 ;
            niter1 = niter1 + 1 ;
            
            if ( (dp < 0.0000001) || (abs(critChi2 - score) < .000001))
                ul = up2 ;
                break ;
            end ;
        end ;
    end ;

    pDiff = p1 - p2 ;
    dp = 1 + pDiff ;
    
    niter2 = 1 ;
    while (niter2 <= 50)
        dp = 0.5*dp ;
        low2 = pDiff - dp ;
        
        score = z2stat(p1, m, p2, n, low2) ;
    
        if score < critChi2
            pDiff = low2 ;
            niter2 = niter2 + 1 ;

            if((dp < 0.0000001) || (abs(critChi2 - score) < .000001))
                ll = low2 ;
                break ;
            end ;
        end ;
    end ;
    
    
    % Construct confidence interval
    if niter1 == 51 && niter2 == 51
        ciBounds = [NaN NaN] ;
        
    elseif niter1 == 51
        ciBounds = [NaN ub] ;
        
    elseif niter1 == 51
        ciBounds = [lb NaN] ;
        
    else
        ciBounds = [ll ul] ;
    end ;
    
return     


function [fmdiff] = z2stat(p1, m, p2, n, dif)

    diff = p1 - p2 - dif ;
    
    if ( abs(diff) == 0 )
        fmdiff = 0 ;
        
    else
        t = n / m ;
        a = 1 + t ;
        b = -(1+ t + p1 + t*p2 + dif*(t+2)) ;
        c = dif*dif + dif*(2*p1 + t +1) + p1 + t*p2 ;
        d = -p1 * dif * (1 + dif) ;
        v = (b/a/3)^3 - b*c/(6*a*a) + d/a/2 ;
        s = sqrt( (b/a/3)^2 - c/a/3) ;
        
        if v > 0
            u = s ;
        else
            u = -s ;
        end ;
        
        w = ( pi + acos(v / u^3) ) / 3 ;
        p1d = 2 * u * cos(w) - b/a/3 ;
        p2d = p1d - dif ;
        nxy = m + n ;
        var = (p1d * (1 - p1d) / m + p2d * (1 - p2d) / n) * nxy / (nxy - 1) ;
        fmdiff = diff^2/var ;
    end ;
    
return 


function [ciBounds, extras] = newcombe98c(e, f, g, h, reqCI) 
% Calculates hybrid score confidence interval for difference between
% dependent proportions, with a continuity correction for the phi value.
%
%   INPUT:
%           e     = positive at both occasions
%           f     = positive at 1st, negative at 2nd
%           g     = negative at 1st, positive at 2nd
%           h     = negative at both occasions
%           reqCI = Required confidence interval size (default == 95)
%
%   OUTPUT
%           ciBounds = lower and upper bounds of confidence interval
%
%   Ref: Newcombe (1998c), Statistics in Medicine, vol. 17, pp. 2635-2650
%
%   Notation follows that used in Newcombe (1998c), with reference also to 
%   formulas in Newcombe (1998a), Statistics in Medicine, vol 17, pp. 857-872
%

    % Calculate critical z statistic for confidence interval
    alpha = (100 - reqCI) / 100 ;
    z = norminv( 1- alpha/2, 0, 1) ;
    
    % Calculate marginal totals and total sample size.
    r1 = e + f;
    r2 = g + h ;
    c1 = e + g ;
    c2 = f + h ;
    
    n = r1 + r2 ;
    
    % Calculate difference in proportion
    pDiff = (r1 - c1) / n ;
    
    
    tmp1 = 2 * r1 + z^2 ;
    tmp2 = z * sqrt(z^2 + 4 * r1 * r2 / n) ;
    tmp3 = 2 * (n + z^2) ;

    l2 = (tmp1 - tmp2) / tmp3 ;
    u2 = (tmp1 + tmp2) / tmp3 ;

    dl2  = (r1 / n) - l2 ;
    du2  = u2 - (r1 / n) ;


    tmp1 = 2 * c1 + z^2 ;
    tmp2 = z * sqrt(z^2 + 4 * c1 * c2 / n) ;
    tmp3 = 2 * (n + z^2) ;

    l3 = (tmp1 - tmp2) / tmp3 ;
    u3 = (tmp1 + tmp2) / tmp3 ;

    dl3  = (c1 / n) - l3 ;
    du3  = u3 - (c1 / n) ;

    
    if (e * h) > (g * f) 
        tmp1 = (e * h) - (g * f) - n/2 ;
        num = max(0, tmp1) ;
    else
        num = (e * h) - (g * f) ;
    end ;

    den = r1 * r2 * c1 * c2 ;

    if den == 0
        phi = 0 ;
    else
        phi = num / sqrt(den) ;
    end ;
    
    dSQ = dl2^2 - 2 * phi * dl2 * du3 + du3^2 ;
    eSQ = du2^2 - 2 * phi * du2 * dl3 + dl3^2 ;

    delta    = sqrt(dSQ) ;
    episolon = sqrt(eSQ) ;

    lb = pDiff - delta ;
    ub = pDiff + episolon ;
    
    ciBounds = [lb ub] ;
    extras   = [(r1/n) (c1/n) pDiff phi] ;
    
return


function [ciBounds] = tango(f, g, n, reqCI)
% Calculates Tango asymptotic score confidence interval for a 
% difference between dependent proportions,
%
%   INPUT:
%           e     = positive at both occasions
%           f     = positive at 1st, negative at 2nd
%           g     = negative at 1st, positive at 2nd
%           h     = negative at both occasions
%           reqCI = Required confidence interval size (default == 95)
%
%   OUTPUT
%           ciBounds = lower and upper bounds of confidence interval
%
%   Ref: Tango (1998), Statistics in Medicine, vol. 17, pp. 891-908
%
%   Notation follows that used in Newcombe (1998c), with reference also to 
%   formulas in Newcombe (1998a), Statistics in medicine, vol 17, pp. 857-872
%

    % Calculate critical z statistic for confidence interval
    alpha = (100 - reqCI) / 100 ;
    z = norminv( 1- alpha/2, 0, 1) ;
    
   
    % Calculate difference in proportion
    pDiff = (f - g) / n ;
    
    [lb, ~,c1, ~] = fzero(@(delta) scoreTest(f, g, n, delta) - z, [-0.999 pDiff+0.01]) ;
    
    if c1 ~= 1
        lb = -999 ;
    end ;
    
    [ub, ~,c2, ~] = fzero(@(delta) scoreTest(f, g, n, delta) + z, [pDiff-0.01 0.999 ]) ;
    
    if c2 ~= 1
        ub = -999 ;
    end ;
    
    ciBounds = [lb ub] ;
    
return

function [tValue] = scoreTest(n12, n21, N, Delta)

    qDelta = 1 - Delta;
    
    A = 2 * N;
    B = -n12 - n21 + (2*N - n12 + n21) * Delta ;
    C = -n21 * Delta * qDelta ;
    
    p21 = (sqrt(B^2 - 4 * A * C) - B) / (2 * A) ;
    
    num    = n12 - n21 - N*Delta ;
    den    = sqrt( N * (2*p21 + Delta*qDelta) ) ;
    
    tValue =  (num / den) ;
    
return 
    
function [midp] = midP_McNemar(f, g)
% Compute McNemar's test using the "mid-p" variant suggested by:
%  
% M.W. Fagerland, S. Lydersen, P. Laake. 2013. The McNemar test for 
% binary matched-pairs data: Mid-p and asymptotic are better than 
% exact conditional. BMC Medical Research Methodology 13: 91.
% 
% "f" is the count of the first set of discordant observations, 
% and "g" is the count of second set of discordant observations 
% in the 2 x 2 table, which correspond to cells (1,2 and (2,1).
%
% Based on GITHUB R function by Kyle B Gromar at
% https://gist.github.com/kylebgorman/4e3ac8b6b67bccbcff8e
%

    n    = f + g ;
    x    = min([f g]) ;
    p    = 2 * binocdf(x, n, 0.5) ;
    midp = p - binopdf(x, n, 0.5) ;
 
return


function [ciBounds, hValues] = MAZW4CI(a, m, b, n, reqCI)
%  Martín Andrés et al (2012) ZE4 confidence interval for 
%  difference in proportions for two independent groups
%
%   INPUT:
%           a     = Number of successes in first group
%           m     = Number of trials in first group
%           b     = Number of successes in first group
%           n     = Number of trials in first group
%           reqCI = Required confidence interval size (default == 95)
%
%   OUTPUT
%           ciBounds = lower and upper bounds of confidence interval
%
%   Martin Andres et al. (2012), J. Applied Stats, vol 39, pp. 1423-1435
%   using Equations 3 (Wald CI method) with Equation 13 as the adjuster.
%
%   Version 16 Nov 2015


    probCI    = [((100+reqCI)/200) ((100-reqCI)/200)] ;
    zCritical = -1 * norminv(probCI, 0, 1) ;
       
    zSqCrit = zCritical(2)^2 ;
    
    p1 = a / m ;
    p2 = b / n ;
    
    % Choose appropriate H1 and H2 values for increment adjustment
    % using Equation 13 in Martin Andres et al (2012)
        
    if (p2 - p1) >= 0
        if p1 == 0
            i1 = 1 ;
        else
            i1 = 0 ;
        end ;
        h1 = zSqCrit*(1 + 2*i1) / 4 ;
        if p2 == 1
            i2 = 1 ;
        else
            i2 = 0 ;
        end ;
        h2 = zSqCrit*(1 + 2*i2) / 4 ;
    else
        if p1 == 1
            s1 = 1 ;
        else
            s1 = 0 ;
        end ;
        h1 = zSqCrit*(1 + 2*s1) / 4 ;
        if p2 == 0 
            s2 = 1 ;
        else
            s2 = 0 ;
        end ;
        h2 = zSqCrit*(1 + 2*s2) / 4 ;
    end ;

    
    % Recalculate if p1 or p2 == 0, or p1 or p2 == 1
    if p1 == 0 
        h1 = zSqCrit/ 4 ;
    end ;
    
    if p2 == 0
        h2 = zSqCrit/ 4 ;
    end ;
        
    if p1 == 1
        h1 = zSqCrit/ 4 ;
    end ;
        
    if p2 == 1
        h2 = zSqCrit/ 4 ;
    end ;
    

    % Recalculate the number of successes and number of trials 
    ah1 = a + h1 ;
    bh1 = b + h1 ;
    
    nh1 = m + (2*h1) ;
    nh2 = n + (2*h2) ;
    
    % Recalculate the difference in proportions
    ph1 = ah1 / nh1 ;
    ph2 = bh1 / nh2 ;
    
    
    % Calculate Wald SE in usual way with adjusted counts
    tmp1   = ph1 * (1 - ph1) / nh1 ;
    tmp2   = ph2 * (1 - ph2) / nh2 ;
    
    se = sqrt(tmp1 + tmp2) ;
    
    ciBounds = (ph1-ph2) + (zCritical * se) ;
    
    hValues  = [h1 h2] ;
    
return
    
       
function [ci] = ciLimits(ci0)

    ci(1) = max( [-1 ci0(1)] ) ;
    ci(2) = min( [ 1 ci0(2)] ) ;
    
return




%% ----------------------------------------------------End of sub-functions
