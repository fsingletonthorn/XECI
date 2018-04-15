function [esXECI, ciXECI, tsXECI, d] = xeci_xtab(cell_A, cell_B, ...
                                              cell_C, cell_D, ...
                                              ciSize, iType, displayOut, nDecs)
%
% XECI_XTAB calculates effect sizes and CIs for 2 x 2 contingency tables
%
%   INPUT:
%       
%           cell_A = Cell A frequency value
%           cell_B = Cell B frequency value
%           cell_C = Cell C frequency value
%           cell_D = Cell D frequency value
%           ciSize = confidence interval size               (*1)
%           iType  = flag for determining kind of analysis
%                      (1 = odds ratio; 2 = risk ratio; 3 = inter-rater)
%           displayout = display output {1 = yes, 0 = no}   (*2)
%           nDecs       = number of displayed decimals (default = 4)
%
%
% 
%   OUTPUT:   
% 
%           esXECI   = (3 X 1) vector of point estimates of effect sizes 
%
%             IF ITYPE  1:   Unadjusted odds ratio 
%                            Gart +0.5-adjusted
%                            Agresti independent-smoothed
%                            
%             IF ITYPE  2:   Unadjusted risk ratio 
%                            Agresti +1-smoothed
%                            
%             IF ITYPE  3:   Cohen's kappa
%                            Observed agreement
%                            Prevalance & bias adjusted kappa (PABAK)
%                            
%
%           ciXECI = (7 X 2) matrix of  lower and upper bound CI estimates of effect sizes
%
%             IF ITYPE  1:   Unadjusted odds ratio 
%                            Gart +0.5-adjusted
%                            Agresti independent-smoothed
%                            Cornfield Exact
%                            Cornfield mid-P
%                            Baptista-Pike Exact
%                            Baptista-Pike mid-P
%                            
%             IF ITYPE  2:   Unadjusted risk ratio 
%                            Agresti +1-smoothed
%                            
%             IF ITYPE  3:   Cohen's kappa
%                            Agreement (score-based)
%                            PABAK (score-based)
%                            Agreement (exact Clopper-Pearson)
%                            PABAK (exact Clopper-Pearson)
%
%
%           tsXECI   = (3 X 1) vector of t test results
%
%             IF ITYPE  1/2: Pearson chi-sq value
%                            Pearson chi-sq P value
%                            Cont.-corrected chi-sq value
%                            Cont.-corrected P value
%                            1-sided Fisher exact P value
%                            2-sided Fisher exact P value
%                            1-sided mid-P value
%                            2-sided mid-P value
%                            
%             IF ITYPE  3:   Bias-adjusted kappa (pi)
%                            Chance agreement
%                            Prevalence index
%                            Bias index
% 
%
%  Notes:   (*1) CI argument is cell_A percentage value (e.g., use '95' for 95% CI)
%
%           (*2) Argument DPO provides formated output to screen (1 = YES or 0 = NO)
%
%
% See also ncp_hypg, nchypgpdf, nchypgcdf
%

%
%   VERSION HISTORY
%       Created:    13 Sep 2008 
%       Revision:   30 Jun 2011 ~   added 1-sided P values  
%
%

%% --------------------------------------------- Initialise output arguments
    esXECI  = [] ;
    ciXECI  = [] ;
    tsXECI  = [] ;


%% ---------------------------------------- Initial check of input arguments
   

    if nargin < 6
        error( 'XECI_xtabs:TooFewInputs', ' Requires at least 6 input arguments ') ;
    end

    if (displayOut ~= 1 && displayOut ~= 0)
        error( 'XECI_xtabs:IncorrectDPO', ' Display output flag not equal to 0 or 1 ') ;
    end

    if (iType ~= 1 && iType ~= 2 && iType ~= 3)
        error( 'XECI_xtabs:IncorrectITYPE', ' iType flag not equal to 1 or 2 or 3 ') ;
    end


    % Generates Dialog Box error messages for input errors
    if (cell_A  <  0)
        errordlg( ' Input value for Cell A is < 0 ', 'Input Entry Error' ) ; 
        return
    end

    if (cell_B  <  0)
        errordlg( ' Input value for Cell B is < 0 ', 'Input Entry Error' ) ; 
        return
    end

    if (cell_C  <  0)
        errordlg( ' Input value for Cell C is < 0 ', 'Input Entry Error' ) ; 
        return
    end

    if (cell_D  <  0)
        errordlg( ' Input value for Cell D is < 0 ', 'Input Entry Error' ) ; 
        return
    end

    if (ciSize <= 0 || ciSize >= 100)
        errordlg( ' Confidence interval value < 0 or > 100 ', 'Input Entry Error' ) ; 
        return
    end

    % Default number of decimal places displayed in output
    if nargin == 7
       nDecs = 4 ;
    end ;
    
    if nargin == 6
       displayOut = 0 ;
    end ;
   
%% -- Preliminary calculations used throughout the remainder of the function   

    zeroCell = 0 ;
    alpha = (100 - ciSize)/100 ;
    nSize = cell_A + cell_B + cell_C + cell_D ;
    nSizeSq = nSize * nSize ;

    probCI = [((100 + ciSize) / 200) ((100 - ciSize) / 200)] ;               % P values for defining CI bounds

    nRows1 = cell_A + cell_B ;
    nRows2 = cell_C + cell_D ;
    nCols1 = cell_A + cell_C ;
    nCols2 = cell_B + cell_D ;

    phi = (cell_A*cell_D - cell_B*cell_C) / ...
           sqrt(nRows1*nRows2*nCols1*nCols2) ;

    chisqValue = nSize * phi^2 ;
    yatesValue = ( nSize * (abs(cell_A*cell_D - cell_B*cell_C) - ...
                     0.5*nSize)^2 ) / (nRows1*nRows2*nCols1*nCols2) ;

    probValue = 1 - chi2cdf(chisqValue, 1) ;
    probYates = 1 - chi2cdf(yatesValue, 1) ;

    zValues = norminv(probCI, 0, 1) ;
    
    zSq = zValues(1)^2 ;

    if ((cell_A == 0) || (cell_B == 0) || (cell_C == 0) || (cell_D == 0))
        zeroCell = 1 ;
    end

    %
    % Exact and Mid-P test statistics
    %
    exactProbs = exactTests(cell_A, cell_B, cell_C, cell_D) ;
    

%% For Odds Ratio (ITYPE = 1) ==========================================================================================

    if (iType == 1)

        if (zeroCell == 0)
            oddsRatio = (cell_A * cell_D) / (cell_B * cell_C) ;
            oddsRatio_SE = sqrt( (1/cell_A) +  (1/cell_B) +  ...
                (1/cell_C) +  (1/cell_D) ) ;
            oddsRatio_CI = exp(log(oddsRatio) - (zValues .* oddsRatio_SE)) ;
        else
            oddsRatio = NaN ;
            oddsRatio_CI = [NaN NaN] ;
        end

        %
        % --- 0.5 adjustment added to each cell for CI
        %

        a05 = 0.5 ;
        oddsRatio_Plus05 = ((cell_A+a05)*(cell_D+a05)) / ((cell_B+a05)*(cell_C+a05)) ;
        oddsRatio_Plus05SE = sqrt( 1/(cell_A+a05) +  1/(cell_B+a05) +  1/(cell_C+a05) +  1/(cell_D+a05) ) ;
        oddsRatio_Plus05CI = exp(log(oddsRatio_Plus05) - (zValues * oddsRatio_Plus05SE)) ;

        %
        % --- Agresti (1999) independence smoothing adjustment added to each cell for CI
        %

        c1 = 2 * nRows1 * nCols1 / nSizeSq ;          % Smoothing cell values
        c2 = 2 * nRows1 * nCols2 / nSizeSq ;
        c3 = 2 * nRows2 * nCols1 / nSizeSq ;
        c4 = 2 * nRows2 * nCols2 / nSizeSq ;

        oddsRatioSmooth = ((cell_A + c1) * (cell_D + c4)) / ((cell_B + c2) * (cell_C + c3)) ;

        oddsRatio_SmoothSE = sqrt( 1/(cell_A+c1) +  1/(cell_B+c2) +  1/(cell_C+c3) +  1/(cell_D+c4) ) ;
        oddsRatio_SmoothCI = exp(log(oddsRatioSmooth) - (zValues * oddsRatio_SmoothSE)) ;

        %
        % --- Cornfield Exact Confidence Intervals
        %

        pci1 = (alpha/2.0)       + 0.000000001 ;
        pci2 = (1.0 - alpha/2.0) - 0.000000001 ;

        oddsRatio_ExactCI = [0 NaN] ;

        if (cell_A > 0) && (cell_D > 0)
            oddsRatio_ExactCI(1) = ncp_hypg(cell_A-1, nRows1, nCols1, nSize, pci1, 1) ;
        end

        if (cell_B > 0) && (cell_C > 0)
            oddsRatio_ExactCI(2) = ncp_hypg(cell_A,   nRows1, nCols1, nSize, pci2, 1) ;
        end

        %
        % --- Cornfield Exact Mid-P Confidence Intervals
        %

        oddsRatio_MidpCI = [0 NaN] ;

        if (cell_A > 0) && (cell_D > 0)
            oddsRatio_MidpCI(1) = ncp_hypg(cell_A-1,  nRows1, nCols1, nSize, pci1, 2) ;
        end

        if (cell_A > 0) && (cell_B > 0) && (cell_C > 0)
            oddsRatio_MidpCI(2) = ncp_hypg(cell_A-1,  nRows1, nCols1, nSize, pci2, 2) ;
        end
        

        %
        % --- Baptista-Pike Confidence Intervals
        %
        oddsRatio_BPCI     = bpCIs(cell_A, cell_B, cell_C, cell_D, ciSize, 0) ;

        %
        % --- Baptista-Pike Mid-P Confidence Intervals
        %

        oddsRatio_BPMidpCI = bpCIs(cell_A, cell_B, cell_C, cell_D, ciSize, 1) ;
        
    end

   
%% For Risk Ratio (ITYPE = 2) ==========================================================================================

    if (iType == 2)
        
    
        % Katz logit interval
        [rrKatz, rrKatz_SE, rrKatz_CI] = riskRatioCI(cell_A, nRows1, cell_C, nRows2, zValues, 1, 0, 0, 0, 0) ;

        % Walter +0.5 logit interval
        [rrWalt, rrWalt_SE, rrWalt_CI] = riskRatioCI(cell_A, nRows1, cell_C, nRows2, zValues, 1, 0.5, 0.5, 0.5, 0.5) ;

        % Agresti & Caffo adjust of +1 to each cell
        [rr_AC,  rrAC_SE,   rrAC_CI]   = riskRatioCI(cell_A, nRows1, cell_C, nRows2, zValues, 1, 1, 2, 1, 2) ;

        % Inverse hyperbolic sine
        [rrIHS1, rrIHS1_SE, rrIHS1_CI] = riskRatioCI(cell_A, nRows1, cell_C, nRows2, zValues, 2, 0, 0, 0, 0) ;

        % Inverse hyperbolic sine [0.0, 0.2, 0.0, 0.8]
        [rrIHS2, rrIHS2_SE, rrIHS2_CI] = riskRatioCI(cell_A, nRows1, cell_C, nRows2, zValues, 2, 0, 0.2, 0, 0.8) ;
        
    end ;
        
    
%% For Inter-rater Reliability (ITYPE = 3) =============================================================================

    if (iType == 3)
        rowP = nRows1 / nSize ;
        colP = nCols1 / nSize ;

        agree = (cell_A + cell_D)/nSize ;
        chance = (nCols1 * nRows1 + nCols2 * nRows2) / nSizeSq ;

        kappa = (agree - chance) / (1 - chance) ;

        kappaSE = sqrt((agree * (1-agree) / (1-chance)^2 + 2*(1-agree) * ...
            (2*agree * chance - ((cell_A * (rowP + colP) + ...
            cell_D * (2 - rowP - colP)) / nSize)) / ...
            (1 - chance)^3 + ((1-agree)^2) * ((cell_A * ...
            (rowP + colP)^2 + cell_B * (-rowP + 1 + colP)^2 + ...
            cell_C *(1+rowP - colP)^2 + cell_D * ...
            (2-rowP-colP)^2)/nSize-4*chance^2) / (1-chance)^4)/nSize) ;

        kappaCI = kappa - (zValues * kappaSE) ;

        prevIndex = (cell_A - cell_D) / nSize ;
        biasIndex = (cell_B - cell_C) / nSize ;
        
        %
        % --- Bias-adjusted Kappa (BAK) 
        %       Byrt, Bishop & Carlin (1993)
        %
        temp0 = ( (nCols1 + nRows1)^2 + (nCols2 + nRows2)^2 ) / (4*nSizeSq) ;
        BAKappa = (agree - temp0) / (1 - temp0) ;
        
        %
        % --- Prevalance and Bias-adjusted Kappa (PABAK) 
        %       Byrt, Bishop & Carlin (1993)
        %
        PABAKappa = 2 * agree - 1 ;

        
%  Confidence intervals...
        %
        % --- Prevalance and Bias-adjusted Kappa Score-based CI
        %
        PABAKappa_SE = zValues .* sqrt(((PABAKappa * (1-PABAKappa)) + ...
                        ((zValues(1)^2) / (4*nSize))) / nSize) ;
        
        PABAKappaCI = (PABAKappa + ((zValues(1)^2)/(2*nSize)) - ...
                        PABAKappa_SE) / (1 + ((zValues(1)^2) / nSize)) ;
        
        %
        % --- Observed agreement Clopper-Pearson CI
        %
        agreeCI_Exact = [NaN NaN] ;

        if ( (cell_A ~= nSize) && (cell_B ~= nSize) && ...
             (cell_C ~= nSize) && (cell_D ~= nSize) )
         
            tmp1 = nSize + 1-cell_A - cell_D ;
            tmp2 = cell_A + cell_D ;
            
            tmp3 = cell_A + cell_D + 1 ;
            tmp4 = nSize - cell_A- cell_D ;
            
            agreeCI_Exact(1) = 1 - betainv(probCI(1),tmp1, tmp2 ) ;
            agreeCI_Exact(2) = betainv(probCI(1), tmp3 , tmp4) ;

        end
        
        %
        % --- Prevalance and Bias-adjusted Kappa Clopper-Pearson CI
        %
        pabakCI_Exact = (2 * agreeCI_Exact) - 1 ;
        
        %
        % --- Observed agreement Score-based CI
        %
        agreeScoreSE = zValues .* sqrt(((agree * (1-agree)) + ...
                        ((zValues(1)^2) / (4*nSize))) / nSize) ;

        agreeCI_Score = (agree + ((zValues(1)^2)/(2*nSize)) - ...
                         agreeScoreSE) / (1 + ((zValues(1)^2)/nSize)) ;

    end
   

% ============================================== Combine like-minded outputs

    % Odds Ratio
    if (iType == 1)
        esXECI = zeros(3,1) ;
        esXECI(1) = oddsRatio ;
        esXECI(2) = oddsRatio_Plus05 ;
        esXECI(3) = oddsRatioSmooth ;

        ciXECI = zeros(5,2) ;
        ciXECI(1,1:2) = oddsRatio_CI ;
        ciXECI(2,1:2) = oddsRatio_Plus05CI ;
        ciXECI(3,1:2) = oddsRatio_SmoothCI ;
        ciXECI(4,1:2) = oddsRatio_ExactCI ;
        ciXECI(5,1:2) = oddsRatio_MidpCI ;
        ciXECI(6,1:2) = oddsRatio_BPCI ;
        ciXECI(7,1:2) = oddsRatio_BPMidpCI ;
        

        tsXECI = zeros(10,1) ;
        tsXECI(1)   = chisqValue ;
        tsXECI(2)   = probValue ;
        tsXECI(3)   = yatesValue ;
        tsXECI(4)   = probYates ;
        tsXECI(5:9) = exactProbs ;
        tsXECI(10)   = 1 ;                       % for degrees of freedom
    end

    % Relative Risk
    if (iType == 2)
        esXECI = zeros(2,1) ;
        esXECI(1) = rrKatz ;
        esXECI(2) = rrWalt ;
        esXECI(3) = rr_AC ;
        esXECI(4) = rrIHS2 ;

        ciXECI = zeros(3,2) ;
        ciXECI(1,1:2) = rrKatz_CI ;
        ciXECI(2,1:2) = rrWalt_CI ;
        ciXECI(3,1:2) = rrAC_CI ;
        ciXECI(4,1:2) = rrIHS1_CI ;
        ciXECI(5,1:2) = rrIHS2_CI ;

        tsXECI = zeros(10,1) ;
        tsXECI(1)   = chisqValue ;
        tsXECI(2)   = probValue ;
        tsXECI(3)   = yatesValue ;
        tsXECI(4)   = probYates ;
        tsXECI(5:9) = exactProbs ;
        tsXECI(10)   = 1 ;                       % for degrees of freedom
    end

    % Inter-rater reliability
    if (iType == 3)
        esXECI = zeros(3,1) ;
        esXECI(1) = kappa ;                     % Cohen's kappa
        esXECI(2) = BAKappa ;                   % Bias-adjusted agreement
        esXECI(3) = PABAKappa ;                 % PABAK kappa
        esXECI(4) = agree ;                     % Obserevd agreement

        ciXECI = zeros(5,2) ;
        ciXECI(1,1:2) = kappaCI ;               % Cohen's kappa
        ciXECI(2,1:2) = agreeCI_Score ;         % Agreement score-based
        ciXECI(3,1:2) = agreeCI_Exact ;         % Agreement Clopper-Pearson
        ciXECI(4,1:2) = PABAKappaCI ;           % PABAK score-based
        ciXECI(5,1:2) = pabakCI_Exact ;         % PABAK Clopper-Pearson

        tsXECI = zeros(3,1) ;
        tsXECI(1) = chance ;                    % Chance agreement
        tsXECI(2) = prevIndex ;
        tsXECI(3) = biasIndex ;
    end


    % If output display is requested...

    if displayOut == 1
        
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;
        
        disp(blanks(3)') ;
        
        if iType == 1
            str = [...
                ' Estimates of Effect Sizes for Odds Ratio' ; ...
                ' ========================================'] ;
        elseif iType == 2
            str = [...
                ' Estimates of Effect Sizes for Relative Risk Ratio' ;  ...
                ' ================================================='] ;
        elseif iType == 3
            str = [...
                ' Estimates of Inter-Rater Reliability' ; ...
                ' ===================================='] ;
        end
        
        disp(str) ;
        disp(blanks(2)') ;

        if iType == 1
            label_esXECI = char(...
                '   Unadjusted odds ratio:               ', ...
                '   Gart +0.5-adjusted:                  ', ...
                '   Agresti ind.-smoothed:               ') ;
            
        elseif iType == 2
            label_esXECI = char(...
                '   Unadjusted risk ratio:               ', ...
                '   Walter +0.5-adjusted:                ', ...
                '   Agresti +1-smoothed:                 ', ...
                '   Inv sinh [0, 0.2, 0, 0.8]:           ') ;
            
        elseif iType == 3
            label_esXECI = char(...
                '   Cohen''s kappa:                      ', ...
                '   Bias-adjusted kappa:                 ', ...
                '   Prevalance & bias adjusted kappa:    ', ...
                '   Observed agreement:                  ') ;
        end


        if iType == 1
            label_ciXECI = char(...
                '   Woolf unadjusted:                    ', ...
                '   Gart +0.5-adjusted:                  ', ...
                '   Agresti ind.-smoothed:               ', ...
                '   Cornfield Exact:                     ', ...
                '   Cornfield mid-P:                     ', ...
                '   Baptista-Pike:                       ', ...
                '   Baptista-Pike mid-P:                 ') ;
        
        elseif iType == 2
            label_ciXECI = char(...
                '   Katz unadjusted:                     ', ...
                '   Walter +0.5-adjusted:                ', ...
                '   Agresti-Caffo +1:                    ', ...
                '   Inv. hyperbolic sine:                ', ...
                '   Inv sinh [0, 0.2, 0, 0.8]:           ') ;
        
        elseif iType == 3
            label_ciXECI = char(...
                '   Cohen''s kappa:                      ', ...
                '   Agreement (Score-based):             ', ...
                '   Agreement (Exact Clopper-Pearson):   ', ...
                '   PABAK (Score-based):                 ', ...
                '   PABA kappa (Exact Clopper-Pearson):  ') ;
        end


        if iType < 3
            label_tsXECI = char(...
                '   Pearson chi-sq value:                ', ...
                '   Pearson chi-sq P value:              ', ...
                '   Cont.-corrected chi-sq value:        ', ...
                '   Cont.-corrected P value:             ', ...
                '   1-sided exact P (right):             ', ...
                '   1-sided exact P (left):              ', ...
                '   2-sided exact P:                     ', ...
                '   1-sided mid-P value:                 ', ...
                '   2-sided mid-P value:                 ', ...
                '   Degrees of freedom:                  ') ;

        else
            label_tsXECI = char(...
                '   Chance agreement:                    ', ...
                '   Prevalence index:                    ', ...
                '   Bias index:                          ') ;
        end

        nr = length(ciXECI) ;
        c1 = char(40*ones(nr,1)) ;     % (
        c2 = char(44*ones(nr,1)) ;     % ,
        c3 = char(32*ones(nr,1)) ;     % space
        c4 = char(41*ones(nr,1)) ;     % )


        str = [...
            ' Point Estimates' ; ...
            ' ---------------'] ;
        
        disp(str) ;
        disp( horzcat(label_esXECI, num2str(esXECI, strDecs) ) ) ;
        disp(blanks(1)') ;


        if (mod(ciSize,1) == 0)
            str = [' ' num2str(ciSize,'%6.0f') ...
                '% Confidence Intervals' ; ...
                ' ------------------------'] ;
        else
            str = [' ' num2str(ciSize,'%6.1f') ...
                '% Confidence Intervals' ; ...
                ' --------------------------'] ;
        end
        
        disp( horzcat(str)) ;
        disp( horzcat( label_ciXECI, c1, num2str(ciXECI(:,1), strDecs), ...
                                 c2, c3, num2str(ciXECI(:,2), strDecs), c4) ) ;
        disp(blanks(1)') ;


        if iType < 3
            str = [...
                ' Test Statistics Results' ; ...
                ' -----------------------'] ;
        else
            str = [...
                ' Agreement Adjustment Indices' ; ...
                ' ----------------------------'] ;
        end
        disp(str) ;
        
        
        if iType < 3
           nc = [1:10] ;
           str_tsXECI = mixed2str(tsXECI(nc), [0 2 0 2 2 2 2 2 2 1], 10, nDecs) ;
        else
           nc = [1:3] ;
           str_tsXECI = mixed2str(tsXECI(nc), [0 0 0], 10, nDecs) ;
        end
        
        disp( horzcat( label_tsXECI(nc,:), str_tsXECI(nc,:) )) ;
        disp(blanks(1)') ;
        
        disp(blanks(2)') ;

    end
   
return


function [exactProbs] = exactTests(cell_A, cell_B, cell_C, cell_D)

    exactProbs = zeros(5,1) ;
    
    table2x2 = [cell_A cell_B; cell_C cell_D] ;
    
    [~, left, ~ ] = fishertest( table2x2, 'tail', 'left' ) ;
    [~, right, ~] = fishertest( table2x2, 'tail', 'right' ) ;
    [~, both, ~]  = fishertest( table2x2, 'tail', 'both' ) ;
    
    tmp        = 0.5*(left - right + 1) ;
    mipd1sided = min( [tmp (1-tmp)] ) ;
    mipd2sided = 2 * mipd1sided ;
    
    exactProbs(1) = left ;
    exactProbs(2) = right ;
    exactProbs(3) = both ;
    exactProbs(4) = mipd1sided ;
    exactProbs(5) = mipd2sided ;
    
return
    

function [ciBounds] = bpCIs(a, b, c, d, reqCI, iType)
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
    errCrit = 1e-06 ;
    errStep = 1e-06 ;
    
    maxIter = 5000 ;

    minOR = 1e-12 ;
    maxOR = 1e+12 ;
    
    
    % One zero in either A or D; or two diagonal zerosin A and D
    if ( a == 0 && b ~= 0 && c ~= 0 && d ~= 0) || ...
       ( d == 0 && a ~= 0 && b ~= 0 && c ~= 0) || ...
       ( a == 0 && d == 0 && b ~= 0 && c ~= 0)
   
        lowerB = 0 ;
        upperB = bisectBP(minOR, maxOR, a, b, c, d, alpha, iType, errCrit, errStep, maxIter) ;
   
    % One zero in either B or C; or two diagonal zeros in B and C 
    elseif ( b == 0 && a ~= 0 && c ~= 0 && d ~= 0) || ...
		   ( c == 0 && a ~= 0 && b ~= 0 && d ~= 0) || ...
		   ( b == 0 && c == 0 && a ~= 0 && d ~= 0)
        
        lowerB = bisectBP(minOR, maxOR, a, b, c, d, alpha, iType, errCrit, errStep, maxIter) ;
        upperB = NaN ;
        
    % Two row zeros OR two column zeros OR three or four zeros    
    elseif ( a == 0 && c == 0) || ( b == 0 && d == 0) || ...
		   ( a == 0 && b == 0) || ( c == 0 && d == 0)
        
        lowerB = 0 ;
        upperB = NaN ;
        
    % No zeroes in any cells    
    elseif (a ~= 0 && b ~= 0 && c ~= 0 && d ~= 0)

        OR = (a * d) / (b * c) ;
        
        lowerB = bisectBP(minOR, OR,    a, b, c, d, alpha, iType, errCrit, errStep, maxIter) ;
        upperB = bisectBP(OR,    maxOR, a, b, c, d, alpha, iType, errCrit, errStep, maxIter) ;
    end ;

    % Confidence interval estimates
    ciBounds = [lowerB upperB] ;


return



function pValue = bpPvalue(a, b, c, d, theta, iType)
% Calculate probability value for Baptista-Pike algorithm
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
%           pValue = probability value
%
%

    n1p = a + b ;
    n2p = c + d ;
    
    np1 = a + c ;
    
    n = a + b + c + d ;

    A = max( [0, np1-n2p] ) ;
    B = min( [np1, n1p] ) ;

    pValue = 0 ;

    prob = nchypgpdf(a, n1p, np1, n, theta);

    for i = A:B
        tmp1 = nchypgpdf(i, n1p, np1, n, theta) ;

        if tmp1 <= prob
            pValue = pValue + tmp1 ;
        end ;
    end ;  
                
    if iType == 1
        pValue = pValue - .5*prob ;
    end ;

return


function bound = bisectBP(A, B, a, b, c, d, alpha, iType, errCrit, errStep, maxIters)

    halfAB = (A + B) / 2 ;
    errFun = abs( bpPvalue(a, b, c, d, halfAB, iType) - alpha ) ;
    
    iter = 1 ;
    while errFun > errCrit
        
        valueA  = bpPvalue(a, b, c, d, A,      iType) - alpha ;
        valueAB = bpPvalue(a, b, c, d, halfAB, iType) - alpha ;

        tmp0 = valueA * valueAB ;
        
        if tmp0 < 0 
            B = halfAB ;
        else
            A = halfAB ;          
        end ;
        
        oldAB  = halfAB ;
        halfAB = (A + B) / 2 ; 
        
        errFun = abs( bpPvalue(a, b, c, d, halfAB, iType) - alpha ) ;
       
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

function [phi, rrSE, rrCI] = riskRatioCI(a, m, b, n, zCrit, iType, adjA, adjM, adjB, adjN)
%   Generic function for calculating confidence intervals for risk ratios
%
%   INPUT:
%           a     = Grp 1 successes
%           m     = Grp 1 trials
%           b     = Grp 2 successes
%           n     = Grp 3 trials
%           zCrit = critical z values for interval
%           iType = type (1 = logit, 2 = inverse hyperbolic sine)
%           adjA  = adjustment to Grp 1 successes
%           adjM  = adjustment to Grp 1 trials
%           adjB  = adjustment to Grp 2 successes
%           adjN  = adjustment to Grp 2 trials
%
%   OUTPUT:
%           phi   = estimated risk ratio
%           rrCI  = risk ratio large sample confidence interval
%           rrSE  = risk ratio standard error


    if nargin == 5
        adjA = 0 ;
        adjM = 0 ;
        B = 0 ;
        adjN = 0 ;
        iType = 1 ;
    end ;
    
    if iType == 1           % Logit interval
        A = a + adjA ;
        M = m + adjM ;
        B = b + adjB ;
        N = n + adjN ;
        
    elseif iType == 2       % Inverse hyperbolic sine interval
        
        A1 = a + adjA ;
        M1 = m + adjA + adjM ;
        B1 = b + adjA ;
        N1 = n + adjA + adjM ;
        
        A2 = a + adjB ;
        M2 = m + adjB + adjN ;
        B2 = b + adjB ;
        N2 = n + adjB + adjN ;
        
    end ;
    
    zSq = zCrit(1)^2 ;
    
    if iType == 1           % Logit interval
        
        if (A == M) && (B == N)  
            
            phi = (A / M) / (B / N) ;
            rrSE = 0 ;
            rrCI = [1 1] ;
        
        elseif A ~= 0 && B ~= 0
            
            phi = (A / M) / (B / N) ;
            rrSE = sqrt( 1/A + 1/B - 1/M - 1/N ) ;
            rrCI = exp(log(phi) - (zCrit .* rrSE)) ;
        
        else
            phi  = NaN ;
            rrSE = NaN ;
            rrCI = [NaN NaN] ;
        end ;

    elseif iType == 2       % Inverse hyperbolic sine interval
            
        phi = (A1 / M1) / (B1 / N1) ;
        
        if (A1 == M1) && (B1 == N1)  
%             display('   1st IF') ;
            rrSE = 0 ;
            rrCI = [1 1] ;
            
        elseif A2 == 0
%             display('   2nd IF') ;
            rrSE = 0.5*zCrit(1) * sqrt( 1/zSq    + 1/B2 - 1/M2 - 1/N2 ) ;
            rrCI = exp( log(phi) + [-2*asinh(rrSE) 2*asinh(rrSE)] ) ;
            
        elseif B2 == 0
%             display('   3rd IF') ;
            rrSE = 0.5*zCrit(1) * sqrt( 1/A2 + 1/zSq    - 1/M2 - 1/N2 ) ;
            rrCI = exp( log(phi) + [-2*asinh(rrSE) 2*asinh(rrSE)] ) ;

        else
%             display('   4th IF') ;
            rrSE = 0.5*zCrit(1) * sqrt( 1/A2 + 1/B2 - 1/M2 - 1/N2 ) ;
            rrCI = exp( log(phi) + [-2*asinh(rrSE) 2*asinh(rrSE)] ) ;
        end ;
 
    end ;
        
return
        