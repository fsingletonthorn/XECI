function [esXECI, ciXECI, tsXECI, varXECI] = xeci_binom(sampleP, nTrials, ...
                                                        nullPi, ciSize, iType, ...
                                                        CC, displayOut, nDecs)
%
% XECI_BINOM calculates various effect sizes and CIs for a sample proportion
% 
%
%   INPUT: 
%       
%   Either:
%           sampleP = sample proportion         (if iType = 1)
%   Or:
%           number of successes                 (if iType = 2)
%   Plus:
%           nTrials = number of trials in the sample
%           nullPi = hypothesised population proportion
%           ciSize = confidence interval size                     (*1)
%
%           iType      = (1 is for sample proportion, or 2 is for number of successes)
%
%   Optional input:
%
%           CC         = continuity corection to P values (1 is YES, 0 = NO [default])
%           displayOut = display output {1 = YES, 0 = NO [default]}         (*2)
%           nDecs      = Number of decimals in results for DISPLAYOUT.
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
%                             * Continuity-corrected Wald 
%                             * Large-sample Wilson 
%                             * Continuity-corrected Wilson 
%                             * Agresti-Coull z-sq
%                             * Agresti-Coull +2
%                             * Mid-P
%                             * Blaker 
%                             * Clopper-Pearson Exact
%                             * Likelihood
%                             * Logistic
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

    if nargin ~= 6 && nargin ~= 7 && nargin ~= 8
        error('XECI_binom:TooFewInputs','Requires at least 5 input arguments.') ;
    end

    if (displayOut ~= 1 && displayOut ~= 0)
        error('XECI_binom:IncorrectDPO','Display output flag not equal to 0 or 1.') ;
    end


    % Generates Dialog Box error messages for input errors

    if (iType == 1 && (sampleP  <  0 || sampleP > 1))
        errordlg('Sample proportion is not between 0 and 1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (iType == 2 && sampleP < 0)
        errordlg('Sample count is less than 0.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (iType == 2 && sampleP > nTrials)
        errordlg('Sample count exceeds sample size.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (nullPi  <  0 || nullPi > 1)
        errordlg('Population proportion is not between 0 and 1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (nTrials  <  1)
        errordlg('Input value for sample size less than  1.', ...
                 'Input Entry Error' ) ; 
        return

    elseif (ciSize <= 0 || ciSize >= 100)
        errordlg( 'Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' ) ; 
        return
    end

    if nargin == 7
       nDecs = 4 ;
    end ;

    if nargin == 6
       CC = 0 ;
       nDecs = 4 ;
    end ;
    
    if nargin == 5
       CC = 0 ;
       displayOut = 0 ;
       nDecs      = 4 ;
    end ;

    %% ------------------------------------------------Preliminary calculations

    if iType == 1
        nSuccess = floor(sampleP*nTrials + 0.5) ;

    elseif iType == 2
        nSuccess = sampleP ;
        sampleP  = nSuccess / nTrials ;
    end

    probCI    = [((100+ciSize)/200) ((100-ciSize)/200)] ;                   % P values for defining CI bounds
    zCritical = -1 * norminv(probCI, 0, 1) ;



    %% --------------------------------------------Large-sample standard errors

    varWald  = (sampleP * (1-sampleP) / nTrials) ;                          % Large-sample Wald variance
    varScore = (nullPi  * (1-nullPi)  / nTrials) ;                          % Large-sample Score variance

    
    %% ---------------------------------------Confidence intervals calculations
 
    % Large-sample Wald interval
    ciWald   = sampleP + (zCritical * sqrt(varWald)) ; 
    

    % Large-sample Wald interval (logistic-transformed)
    ciWald_L = transCIxeci(sampleP, sqrt(varWald), zCritical(2), 2) ;                  
    
 
    % Large-sample Continuity-Corrected Wald interval
    ciWaldCC(1) = ciWald(1) - (1 / (2*nTrials)) ;
    ciWaldCC(2) = ciWald(2) + (1 / (2*nTrials)) ;


    % Agresti-Coull +Zsq interval
    nSuccessZsq = nSuccess + (zCritical(2)*zCritical(2) / 2) ;              
    nTrialsZsq  = nTrials + (zCritical(2) * zCritical(2)) ;
    samplePZsq  = nSuccessZsq / nTrialsZsq ;
    varZsq      = (samplePZsq * (1-samplePZsq) / nTrialsZsq) ;
    ciZsq       = samplePZsq + (zCritical * sqrt(varZsq)) ;

    
    % Wilson score interval
    tmp1 = ((2 * sampleP * nTrials) + zCritical(2)^2) ;
    denominator = 2 * ( nTrials + (zCritical(2) * zCritical(2)) ) ;
    
    tmp2 = zCritical.^2 + ( 4 * nTrials * sampleP * (1 - sampleP) ) ;
     
    numerator = tmp1 + ( zCritical .* sqrt(tmp2) ) ;
    
    ciWilson = numerator ./ denominator ;

    
    % Wilson continuity-corrected score interval
    tmp1 = ((2 * sampleP * nTrials) + zCritical(2)^2) ;
    denominator = 2 * ( nTrials + (zCritical(2) * zCritical(2)) ) ;
    
    tmp2 = zCritical(2)^2 + [-2 +2] ;
    tmp3 = (-1/nTrials) + 4 * sampleP * (nTrials * (1 - sampleP) + [+1 -1]) ;
       
    numerator = tmp1 + [-1 +1] + zCritical .* sqrt( tmp2 + tmp3 ) ;
    
    ciWilsonCC = numerator ./ denominator ;    
    
    
    % Agresti-Coull +4 Interval
    nSuccessPlus2 = nSuccess + 2 ;                                           
    nTrialsPlus4  = nTrials + 4 ;
    samplePlus2   = nSuccessPlus2 / nTrialsPlus4 ;
    varPlus2      = (samplePlus2 * (1-samplePlus2) / nTrialsPlus4) ;
    ciPlus2       = samplePlus2 + (zCritical * sqrt(varPlus2)) ;

   
   % ARCSIN transformed confidence interval
   
   pTilde = (nSuccess + 0.375) / (nTrials + 0.75 ) ;
   ciARCSIN = sin( asin(sqrt(pTilde)) + (0.5*zCritical/sqrt(nTrials)) ).^2 ;
    
    %% -------------------------------Ensure all intervals are bounded by [0,1]

    ciWald     = [ max(ciWald(1),    0) min(ciWald(2),    1) ] ;
    ciWaldCC   = [ max(ciWaldCC(1),  0) min(ciWaldCC(2),  1) ] ;
    ciWilson   = [ max(ciWilson(1),  0) min(ciWilson(2),  1) ] ;
    ciWilsonCC = [ max(ciWilsonCC(1),0) min(ciWilsonCC(2),1) ] ;
    ciZsq      = [ max(ciZsq(1),     0) min(ciZsq(2),     1) ] ;
    ciPlus2    = [ max(ciPlus2(1),   0) min(ciPlus2(2),   1) ] ;
    ciARCSIN   = [ max(ciARCSIN(1),  0) min(ciARCSIN(2),  1) ] ;

    
    %% ------------------------------------------------Clopper-Pearson exact CI
    if nSuccess == 0 ;
        lowExact = 0 ;
    else
        [lowExact, ~, ~, ~] = fzero(@(ncp1)(binocdf(nSuccess-1, nTrials, ...
            ncp1) - probCI(1)), [0 1]) ;
    end

    if nSuccess == nTrials ;
        upExsact = 1 ;
    else
        [upExsact, ~, ~, ~] = fzero(@(ncp1)(binocdf(nSuccess, nTrials, ...
                                      ncp1) - probCI(2)), [0 1]) ;
    end

    ciExact = [lowExact upExsact] ;


    %% ----------------------------------------------------------------Mid-P C
    nTS_1 = nTrials - nSuccess - 1 ;

    if nSuccess == 0 ;
        lowExact = 0 ;
    else
        [lowExact, ~, ~, ~] = fzero(@(ncp1)(binopdf(nSuccess, nTrials, ...
                                      ncp1)/2 + binocdf(nTS_1, nTrials,1 - ncp1) - probCI(2)), [0 1]) ;
    end

    if nSuccess == nTrials ;
        upExsact = 1 ;
    else
        [upExsact, ~, ~, ~] = fzero(@(ncp1)(binopdf(nSuccess, nTrials, ...
                                      ncp1)/2 + binocdf(nTS_1, nTrials,1 - ncp1) - probCI(1)), [0 1]) ;
    end

    ciMidP = [lowExact upExsact] ;


    %% ------------------------------------------------------------------Blaker
    ciLLhood = binomLikeCIs(nSuccess, nTrials, ciSize) ;
    

    %% ------------------------------------------------------------------Blaker
    ciBlaker = blakerCI(nSuccess, nTrials, ciSize) ;
    

    %% ---------------------------------------------------------Test statistics

    % Exact test
    probRight = binocdf(nTrials - nSuccess, nTrials, 1-nullPi) ;             % One-sided P(pi >= p)
    probLeft  = binocdf(nSuccess, nTrials,  nullPi) ;                        % One-sided P(pi <= p)

    [probExact, tmp] = prob2sided(nSuccess, nTrials, nullPi) ;               % Two-sided exact test

    if isempty(tmp(tmp ~= nSuccess))
        nSuccess_Opposite = NaN ;
    else
        nSuccess_Opposite = tmp(tmp ~= nSuccess) ;
    end
    
    % Mid-P test
    midProb = binopdf(nSuccess, nTrials, nullPi)/2 + ...
                      (binocdf(nTrials-nSuccess-1, nTrials, 1-nullPi)) ;    % One-sided mid-P for P(pi >= p)

   
   % Asymptotic tests with and without continuity correction
   ccValue = (1 / (2*nTrials)) ;
    
   numerator = (sampleP - nullPi) ;
   
   if sampleP >= nullPi
      numContC = numerator - ccValue ;
   else
      numContC = numerator + ccValue ;
   end ;
   
   seWald    = sqrt(varWald) ;
   seScore   = sqrt(varScore) ;
   
   if CC == 1
      zWald  = numContC  / seWald ;
      zScore = numContC  / seScore ;

      pWald  = 2*(1 - normcdf(abs(zWald),  0, 1)) ;                         % Wald test corrected
      pScore = 2*(1 - normcdf(abs(zScore), 0, 1)) ;                         % Score test corrected
   
   else
      zWald  = numerator / seWald ;
      zScore = numerator / seScore ;

      pWald  = 2*(1 - normcdf(abs(zWald),  0, 1)) ;                         % Wald test uncorrected
      pScore = 2*(1 - normcdf(abs(zScore), 0, 1)) ;                         % Score test uncorrected
   end ;


   
    %% ---------------------------------------------Combine like-minded outputs

    % All effect size point estimates
    esXECI = zeros(5,1) ;
    esXECI(1) = sampleP ;
    esXECI(2) = samplePlus2 ;
    esXECI(3) = samplePZsq ;
    esXECI(4) = nSuccess ;
    esXECI(5) = nTrials ;


    % All effect size interval estimates
    ciXECI = zeros(10,2) ;
    ciXECI( 1,1:2) = ciWald ;
    ciXECI( 2,1:2) = ciWaldCC ;
    ciXECI( 3,1:2) = ciWilson ;
    ciXECI( 4,1:2) = ciWilsonCC ;
    ciXECI( 5,1:2) = ciZsq ;
    ciXECI( 6,1:2) = ciPlus2 ;
    ciXECI( 7,1:2) = ciMidP ;
    ciXECI( 8,1:2) = ciBlaker ;
    ciXECI( 9,1:2) = ciExact ;
    ciXECI(10,1:2) = ciLLhood ;
    ciXECI(11,1:2) = ciWald_L ;
    ciXECI(12,1:2) = ciARCSIN ;
    

    % All relevant test statistic values
    tsXECI = zeros(9,1) ;
    tsXECI(1) = probExact ;
    tsXECI(2) = probRight ;
    tsXECI(3) = probLeft ;
    tsXECI(4) = midProb ;
    tsXECI(5) = zWald ;
    tsXECI(6) = pWald ;
    tsXECI(7) = nSuccess_Opposite ;
    tsXECI(8) = zScore ;
    tsXECI(9) = pScore ;

    % All relevant variance estimates
    varXECI = zeros(4,1) ;
    varXECI(1) = seWald ;
    varXECI(2) = seScore ;
    varXECI(3) = sqrt(varZsq) ;
    varXECI(4) = sqrt(varPlus2) ;
   


%% ------------------------------------------If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;

        disp(blanks(3)') ;

        headingMain = [...
            ' Estimates of Effect Sizes for Single Proportions' ; ...
            ' ================================================'] ;
        
        disp(headingMain) ;
        disp(blanks(2)') ;

        label_esXECI = char(...
            '   ML proportion:              ', ...
            '   Agresti-Coull +2:           ', ...
            '   Wilson mid-point:           ', ...
            '   No. successes:              ', ...
            '   No. trials:                 ') ;

        label_ciXECI = char(...
            '   Wald (large sample):        ', ...
            '   Wald (cont.-corrected):     ', ...
            '   Wilson score:               ', ...
            '   Wilson (cont.-corrected):   ', ...
            '   Agresti-Coull (Zsq):        ', ...
            '   Agresti-Coull (+2):         ', ...
            '   Mid-P:                      ', ...
            '   Blaker exact:               ', ...
            '   Clopper-Pearson Exact:      ', ...
            '   Likelihood:                 ', ...
            '   Logistic Wald:              ', ...
            '   Anscombe Arcsine:           ') ;
         
        label_tsXECI = char(...
            '   Exact Pr(p''<=Pi || Pi>=p):  ', ...
            '   Exact Pr(Pi >= p):          ', ...
            '   Exact Pr(Pi <= p):          ', ...
            '   Mid-Pr(Pi >= P):            ', ...
            '   Wald z test value:          ', ...
            '   Wald P value:               ', ...
            '   Opposite extreme no. (p''): ', ...
            '   Score z test value:         ', ...
            '   Score P value:              ', ...
            '   Exact Pr(p<=Pi || Pi>=p''):  ') ;

        label_varXECI = char(...
            '   Large-sample Wald:          ', ...
            '   Large-sample score:         ', ...
            '   Agresti-Coull z-sq:         ', ...
            '   Agresti-Coull +4:           ') ;

        nRows = length(ciXECI) ;
        c1 = char(40 * ones(nRows, 1)) ;     % (
        c2 = char(44 * ones(nRows, 1)) ;     % ,
        c3 = char(32 * ones(nRows, 1)) ;     % space
        c4 = char(41 * ones(nRows, 1)) ;     % )


        headingEffects = [...
            ' Point Estimates' ; ...
            ' ---------------'] ;
        
        disp(headingEffects) ;
        str_esXECI = mixed2str(esXECI, [0 0 0 1 1], 10, nDecs) ;
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

        if tsXECI(9) < esXECI(4)
           nc = [ 1 2 3 4 5 6 7 8 9] ;
        else
           nc = [10 2 3 4 5 6 7 8 9] ;
        end ;

        headingStats = [...
            ' Test Statistics Results' ; ...
            ' -----------------------'] ;
        disp(headingStats) ;
        str_tsXECI = mixed2str(tsXECI, [2 2 2 2 0 2 1 0 2], 10, nDecs) ;

        disp( horzcat(label_tsXECI(nc,:), str_tsXECI) ) ;
        
        if tsXECI(9) == esXECI(5)
           disp(blanks(1)') ;
           disp('   NB: Upper tail of 2-sided exact P value is empty') ;
        elseif tsXECI(9) == 0
           disp(blanks(1)') ;
           disp('   NB: Lower tail of 2-sided exact P value is empty') ;
        end ;
        disp(blanks(1)') ;

        
        headingSEs = [...
            ' Standard Error Estimates' ; ...
            ' ------------------------'] ;
        disp(headingSEs) ;
        str_varXECI = num2str(varXECI, strDecs) ;
        disp( horzcat(label_varXECI, str_varXECI ) ) ;
         
        if CC == 1
           disp(blanks(1)') ;
           disp('   NB: Continuity correction for large-sample results') ;
        end ;

        disp(blanks(2)') ;
 
    end
%% ---------------------------------------------------------End of function   
   
return


%% -------------------------------------Sub-functions used in main function
function [probValue, nSuccess_Opposite, probsCover] = prob2sided(testValue, nSize, nullProp)
%  Calculates two-sided exact P value for binomial test of a proportion
%
%  INPUT:
%       testValue = observed number of successful outcomes
%       nSize     = total number of trials
%       nullProp  = null hypothesisied population proportion
% 
%  OUTPUT:
%       probValue = 2-sided probability
%       nSuccess_Opposite = opposite extreme number of successful trials
%       probsCover =  (1) 1-sided probability value >= observed successful trials
%                     (2) 1-sided probability value <= observed successful trials
%                     (3) probability of observed successful trials
%                     (4) probability of opposite extreme number of successful trials
% 
%       See Fleiss et al (2003) Statistical methods for rates and proportions,
%           Section 2.7.2 (pp. 39-40).  Also Stata procedure BITESTI with DETAIL option.
%

    if nullProp == 0.5
        probGreater = binocdf(nSize-testValue, nSize, 1 - nullProp) ;         % P(X >= x)
        probLesser  = binocdf(testValue, nSize, nullProp) ;                   % P(X <= x)

        probValue = min( [ 2*min([probGreater ; probLesser]) 1] ) ;

        if testValue/nSize >= 0.5
            nSuccess_Opposite = [(nSize - testValue) testValue] ;
        else
            nSuccess_Opposite = [testValue (nSize - testValue)] ;
        end
        
        probExtreme = binopdf(nSuccess_Opposite, nSize, nullProp) ;
        probsCover = [probGreater ; probLesser ; probExtreme'] ;
        return
    end

    nullValue = nSize * nullProp ;
    densityNull = binopdf(testValue, nSize, nullProp) ;
    
    probGreater = binocdf(nSize - testValue, nSize, 1 - nullProp) ;
    probLesser  = binocdf(testValue, nSize, nullProp) ;
    
    if testValue >= nullValue
        probRight = binocdf(nSize - testValue, nSize, 1 - nullProp) ;       % P(X >= x)
        
        if nSize < 500 ;
            j = 0 ;
        else
            j = nullValue - 500 ;
        end
        
        x1 = floor(nullValue):-1:j ;
        pp = binopdf(x1, nSize, nullProp) ;

        k0 = (pp <= densityNull) ;
        if sum(k0) == 0
            probLeft = 0 ;
            nSuccess_Opposite = [0 testValue] ;
        else
            k = find(k0, 1) ;
            probLeft = binocdf(x1(k), nSize, nullProp) ;                    % P(X <= Opposite tail)
            nSuccess_Opposite = [testValue x1(k)] ;
        end
        
    else
        probLeft = binocdf(testValue, nSize, nullProp) ;                    % P(X <= x)
        
        if nSize < 500 ;
            j = nSize - 1 ;
        else
            j = testValue + 501 ;
        end
        
        x1 = testValue+1:j ;
        pp = binopdf(nSize - x1, nSize, 1 - nullProp) ;

        k0 = (pp <= densityNull) ;
        if sum(k0) == 0
            probRight = 0 ;
            nSuccess_Opposite = [testValue nSize] ;
        else
            k = find(k0, 1) ;
            probRight = binocdf(nSize - x1(k), nSize, 1-nullProp) ;         % P(X >= Opposite tail)
            nSuccess_Opposite = [testValue x1(k)] ;
        end
    end

    if isempty(nSuccess_Opposite(nSuccess_Opposite ~= testValue))           % When nSuccess_Opposite EQ nSuccess because p EQ p0
        nSuccess_Opposite = testValue + 1 ;
    end

    
    probValue   = min([(probRight + probLeft) 1]) ;
    probExtreme = binopdf(nSuccess_Opposite, nSize, nullProp) ;

    probsCover = [probGreater ; probLesser ; probExtreme'] ;
    
return


function [bCI] = blakerCI(x, n, reqCI, tol)
% Calculates Blaker confidenc einterval for binomial proportion based on
% S-code provided in Blaker (2000) Candian Journal of Statistics, vol 28,
% pp 783-798
%
%  INPUT:
%        x     = observed number of successes
%        n     = number of trials
%        reqCI = requested size of confidence interval ( 0 < reqCI < 100)
%        tol   = tolerance used in ACCEPTBIN function
%  
%  OUTPUT:
%        bCI   = bounds of the confidenc einterval
%

   ciLevel = reqCI / 100 ;

   if nargin == 3
      tol = 1e-05 ;
   end ;
   
   lower = 0 ;
   upper = 1 ;
   
   c1 = 0 ;
   c2 = 0 ;

   % Search grid for improving the starting point of the
   % ACCEPTBIN function for lower and upper interval bounds
   tol0 = [1e-07; 5e-07; 1e-06; 5e-06; 1e-05; 5e-05;   ...
           1e-04; 5e-04; 1e-03; 5e-03; 1e-02; 1.5e-02; ...
           2e-02; 2.5e-02; 3e-02; 3.5e-02; 4e-02; 4.5e-02; ...
           5e-02; 5.5e-02; 1e-01] ;

   if x ~= 0
      lower = betainv( (1-ciLevel)/2, x, n-x+1) ;
      
      lowtol = lower + tol0 ;
      jj = 0 ;
      for j = 1:length(tol0) ;
         if ( acceptbin99(x, n, lowtol(j)) < (1 - ciLevel) )
            jj = jj + 1;
            continue ;
         else
            break ;
         end ;
      end ;

      lower = lowtol(jj) ;
      while (acceptbin99(x, n, lower + tol) < (1 - ciLevel))
         lower = lower + tol ;
         c1 = c1 + 1 ;
         if c1 > 5000; 
            lower = NaN; 
            break; 
         end ;
      end ;
   end ;
   
   if x ~= n
      upper = betainv(1 - (1-ciLevel)/2, x+1, n-x) ;
      
      uptol = upper - tol0 ;
      jj = 0 ;
      for j = 1:length(tol0) ;
         if ( acceptbin99(x, n, uptol(j)) < (1 - ciLevel) )
            jj = jj + 1;
            continue ;
         else
            break ;
         end ;
      end ;      
      
      upper = uptol(jj) ;
      while (acceptbin99(x, n, upper - tol) < (1 - ciLevel))
         upper = upper - tol ;
         c2 = c2 + 1 ;
         if c2 > 5000; 
            upper = NaN ;
            break; 
         end ;
      end ;
   end ;
   
   bCI  = ([lower upper]) ;
   
return 

% Uses the INVBINO function rather than the default BINOINV function
% as the latter is much slower due to the slower default BINOPDF function 
function [y] = acceptbin99(x, n, p)

   p1 = 1 - binocdf(x - 1, n, p) ;
   a1 = p1 + binocdf(invbino(p1, n, p) - 1, n, p) ;

   p2 = binocdf(x, n, p) ;
   a2 = p2 + 1 - binocdf(invbino(1 - p2, n, p), n, p) ;

   y = min( [a1 a2], [], 2) ;
   
return
  

% This PDF function is faster than the default MATLAB version, 
% but not necessarily have the same level of accuracy (it appears 
% to be accurate to at least 6 decimal places, which is sufficient 
% for this purpose.
function pdf = pdfbino(x, n, p)
   
   z   = gammaln(n+1) - gammaln(x+1) - gammaln(n-x+1) + x.*log(p) + (n-x).*log(1-p);
   pdf = exp (z);
   
return


function inv = invbino(x, n, p)
   
   if x == 0
      inv = 0 ;
   elseif x == 1
      inv = n ;
   else
      inv = 0;
      cdf = pdfbino (inv, n, p) ;
      while (cdf < x )
         inv = inv + 1;
         cdf = cdf + pdfbino (inv, n, p);
      end ;
   end ;
   
return 

 
function [ciBounds] = binomLikeCIs(r, n, reqCI)
% Calculate exact and mid-P confidence intervals 
% according to the Baptista-Pike algorithm
%
%   INPUT:
%           a     = A cell of 2 x 2 table
%           b     = B cell of 2 x 2 table
%           c     = C cell of 2 x 2 table
%           d     = D cell of 2 x 2 table
%           theta = odds ratio value
%           iType = indicator for Exact or Mid-P value
%                   (0 = exact, 1 = mid-p)
%
%   OUTPUT:
%           ciBounds = bounds of the confidence interval
%
%
    alpha = (100 - reqCI) / 100 ;
    errCrit = 1e-08 ;
    errStep = 1e-08 ;
    
    maxIter = 5000 ;
    zValue   = norminv(1 - alpha/2, 0, 1) ;

    minTheta = 1e-12 ;
    maxTheta = 1.0 ;
    
    p = r / n ;
    
    if r == 0
        zCrit = r * 1      + (n-r) * log(1 - p) - zValue^2/2 ;
    elseif r == n
        zCrit = r * log(p) + (n-r) * 1          - zValue^2/2 ;
    else
        zCrit = r * log(p) + (n-r) * log(1 - p) - zValue^2/2 ;
    end ;

    if r == 0
        loTheta  = 0 ;
        maxTheta = 0.5 ; 
        upTheta = bisectTheta(p, maxTheta, r, n, zCrit, errCrit, errStep, maxIter) ;

    elseif r == n
        minTheta = 0.5 ;
        loTheta = bisectTheta(minTheta, p, r, n, zCrit, errCrit, errStep, maxIter) ;
        upTheta = 1 ;
        
    else
        loTheta = bisectTheta(minTheta, p, r, n, zCrit, errCrit, errStep, maxIter) ;
        upTheta = bisectTheta(p, maxTheta, r, n, zCrit, errCrit, errStep, maxIter) ;
    end ;

    % Confidence interval estimates
    ciBounds = [loTheta upTheta] ;

return


function logLik = likelihoodB(p, r, n)

    if r == 0
        logLik = r * 1 + (n-r) * log(1 - p) ;
    elseif r == n
        logLik = r * log(p) + (n-r) * 1 ;
    else 
        logLik = r * log(p) + (n-r) * log(1 - p) ;
    end ;
    
return


function [bound, iter] = bisectTheta(A, B, r, n, zCrit, errCrit, errStep, maxIters)

    halfAB = (A + B) / 2 ;
    
    errFun = abs( likelihoodB(halfAB, r, n) - zCrit ) ;
    
    iter = 1 ;
    while errFun > errCrit
        
        valueA  = likelihoodB(A,      r, n) - zCrit ;
        valueAB = likelihoodB(halfAB, r, n) - zCrit ;

        tmp0 = valueA * valueAB ;
        
        if tmp0 < 0 
            B = halfAB ;
        else
            A = halfAB ;          
        end ;
        
        oldAB  = halfAB ;
        halfAB = (A + B) / 2 ;
        
        errFun = abs( likelihoodB(halfAB, r, n) - zCrit ) ;
       
        if abs(oldAB - halfAB) < errStep
            break ;
        end ;
        
        iter = iter + 1 ;
        
        if iter > maxIters ;
            break ;
        end ;
        
    end
    
    if iter < maxIters
        bound = halfAB ;
    else
        bound = NaN ;
    end ;
    
return

%% ----------------------------------------------------End of sub-functions
