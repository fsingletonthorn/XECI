function [esXECI, ciXECI, tsXECI] = xeci_sem(chiSq, dfValue, nSize, nGroups, ciSize, ...
                                             nullRMSEA, nVorP, displayOut, nDecs, ...
                                             meanModel, mlECVI, iType1, iType2)
% 
% XECI_SEM calculates a range of fit statistics for structural equation models 
%
%   INPUT:    
%       chiSq      = model chi-square value (itype1 = 1) or
%                    discrepancy function value (itype1 = 0)
%       dfValue    = degrees of freedom
%       nSize      = total sample size over all groups
%       nGroups    = number of groups
%       ciSize     = confidence interval size
%       nullRMSEA  = null hypothesised non-zero RMSEA value
%       nVorP      = #variables in each group (if itype2 = 0) or
%                    #model parameters (if itype2 = 1)
%       displayOut = display output {1 = yes, 0 = no}
%       nDecs       = number of displayed decimals (default = 4)
%
%    [OPTIONAL]
%       meanModel  = mean structure model (1 = yes / 0 = no)
%       mlECVI     = ML ECVI measures (1 = yes / 0 = no)
%       iType1     = input type for 'chiSq' argument (1 or 0)
%       iType2     = input type for 'nVorP' argument (1 = #parameters / 0 = #variables)
%
% 
%   OUTPUT:   
%       esXECI = (6 X 1) vector of point estimates of fit statistics 
%                   [popDisc; popDisc*n; RMSEA; Gamma1; Gamma2; ECVI]'
%
%       ciXECI = (6 X 2) matrix of  lower and upper bound CI estimates of effect sizes
%            [popDisc; popDisc*n; RMSEA; Gamma1; Gamma2; ECVI]'
%
%       tsXECI = (12 X 1) vector of model fit statistics
%            [chiSq; df; P exact fit; P approx fit; P not-approx. fit; Total N; Grps; 
%             Null Approx RMSEA; No. Vars; No. Parms; No. Data Points; Mean Structure]
%
%  Notes:   (1) 'ci' is a percentage value (e.g., use '95' for 95% CI)
%           (2) If ITYPE2 = 1 and GRP > 1, then 'nvp = (grp X 1) vector
%
%
% See also ncp_chi2
%

%
%   VERSION HISTORY
%       Created:    13 Jul 2008 
%
% 




%%  -------------------------------------------- Initialise output arguments
    
    esXECI = [];
    ciXECI = [];
    tsXECI = [];


%% ------------------------------------------------ Checking input arguments

    %  Initial check of input arguments
    if (nargin < 7)
        error('M_Files:semfit:TooFewInputs','Requires at least 7 input arguments.');
    end

    if nargin == 7
        displayOut = 0 ;
        nDecs = 4 ;
        meanModel = 0;
        mlECVI = 0;
        iType1 = 1;
        iType2 = 0;

    elseif nargin == 8
        nDecs = 4 ;
        meanModel = 0;
        mlECVI = 0;
        iType1 = 1;
        iType2 = 0;

    elseif nargin == 9
        meanModel = 0;
        mlECVI = 0;
        iType1 = 1;
        iType2 = 0;

    elseif nargin == 10
        mlECVI = 0;
        iType1 = 1;
        iType2 = 0;

    elseif nargin == 11
        iType1 = 1;
        iType2 = 0;

    elseif nargin == 12
        iType2 = 0;
    end ;

    if (meanModel ~= 0 && meanModel ~= 1)
        error('XECI_sem:IncorrectM','Mean structure indicator not equal to 0 or 1.');
    end

    if (iType1 ~= 0 && iType1 ~= 1)
        error('XECI_sem:IncorrectTYPE1','X2 input indicator not equal to 0 or 1.');
    end

    if (iType2 ~= 0 && iType2 ~= 1)
        error('XECI_sem:IncorrectTYEP2','NVP input indicator not equal to 0 or 1.');
    end


    % Generates Dialog Box error messages for input errors

    if (chiSq < 0)
        errordlg('Chi-square value is negative.', ...
                 'Input Entry Error' ); 
        return

    elseif (dfValue < 1)
        errordlg('Degrees of freedom are less than one.', ...
                 'Input Entry Error' ); 
        return

    elseif (nSize < 1)
        errordlg('Sample size is less than one.', ...
                 'Input Entry Error' ); 
        return

    elseif (nGroups < 1)
        errordlg('Number of groups is less than one.', ...
                 'Input Entry Error' ); 
        return

    elseif (ciSize <= 0 || ciSize >= 100)
        errordlg('Confidence interval value < 0 or > 100.', ...
                 'Input Entry Error' ); 
        return

    elseif (nullRMSEA <= 0)
        errordlg('Null hypothesised approximate fit is zero or negative.', ...
                 'Input Entry Error' ); 
        return

    elseif (nVorP < 1)
        errordlg('Number of variables / parameters is less than 1.', ...
                 'Input Entry Error' ); 
        return
    end


%% ------------------------------------------------ Preliminary calculations

    nSizeGrp = nSize - nGroups;

    if iType1 == 0                                                          % Calculate chi-sq if sample discrpeancy value provided
        chiSq = chiSq * nSizeGrp;
    end

    if meanModel == 1
        nMeans = nGroups * nVorP;                                           % Total number of sample means
    else
        nMeans = 0;
    end

    if iType2 == 1;            % # parameters
        nParameters = nVorP;                                                % Number of freely estimated model parameters
        prmStar = dfValue + nParameters;                                    % Total number of non-redundant data values used in model

    elseif iType2 == 0;        % # variables
        prmStar = (nGroups * (nVorP * (nVorP+1)/2)) + nMeans;               % Total number of non-redundant data values used in model
        nParameters = prmStar - dfValue;                                    % Number of freely estimated model parameters
    end

    if iType2 == 1;                                                         % # parameters
        if meanModel == 1
            nVars = (2 * sqrt((9 * nGroups^2) / 4 + ...
                2 * prmStar * nGroups) - 3 * nGroups) / (2 * nGroups);
        else
            nVars = (2 * sqrt(nGroups^2 / 4 + 2 * prmStar * nGroups) - ...
                nGroups) / (2*nGroups);
        end
    end

    if iType2 == 0;                                                         % # variables
        nVars = nGroups * nVorP;
    end

    probCI = [((100+ciSize) / 200) ((100-ciSize) / 200)];                   % P values for CI bounds

    probExact = 1 - chi2cdf(chiSq, dfValue);                                % Prob of exact fit

    probNotApprox = ncx2cdf(chiSq, dfValue, ...
        (nSize * dfValue * nullRMSEA.^2) / nGroups);                        % Prob of not-appoximate fit

    probApprox = 1 - probNotApprox;                                         % Prob of approximate fit


    % Get non-centrality parameter values for chosen CI width
    if chiSq > dfValue
        modelNCP = chiSq - dfValue;                                         % Model estimated noncentrality parameter
    else
        modelNCP = 0;
    end

    ncpCI = ncp_chi2(chiSq, dfValue, probCI);                               % CI for noncentrality parameter


%% ------------------------------------------------ Calculating effect sizes

    popDisc = modelNCP / nSizeGrp;                                          % Population discrepancy estimate
    rmsea = sqrt(modelNCP / (dfValue*nSize)) * sqrt(nGroups);               % RMSEA point estimate
    
    gamma1 = nVars / ((2 * modelNCP/nSize * nGroups) + nVars);              % Gamma 1 point estimate
    gamma2 = 1 - ((prmStar / dfValue) * (1 - gamma1));                      % Gamma 2 point estimate
    
    ecvi = (modelNCP + dfValue + (2*nParameters)) / nSize;                  % ECVI point estimate
    
    mcdonald = exp(-0.5 * popDisc);                                         % McDonald's NCP Index point estimate


%% ---------------------------------------------------- Confidence intervals

    popDisc_CI = ncpCI / nSizeGrp;                                          % CI for Population discrepancy estimate
    rmsea_CI = sqrt(ncpCI / (dfValue * nSize)) * sqrt(nGroups);             % CI for RMSEA

    gamma1_CI = nVars./((2 * ncpCI / nSize * nGroups) + nVars);             % CI for Gamma 1
    gamma2_CI = 1 - ((prmStar / dfValue) * (1 - gamma1_CI));                % CI for Gamma 2
    
    ecvi_CI = (ncpCI + dfValue + (2 * nParameters)) / nSize;                % CI for ECVI

    mcdonald_CI = exp(-0.5*popDisc_CI);                                     % CI for McDonald's NCP Index


    % If ML-ECVI to be estimated also

    if (mlECVI == 1)
        nSize2 = nSize - nVars - 1;
        chiSqML = nSize2 * chiSq / nSizeGrp;

        ncpCI_ML = ncp_chi2(chiSqML, dfValue, probCI);                      % CI for noncentrality parameter under ML-ECVI

        ecviML = (chiSq / nSizeGrp) + (2 * nParameters / nSize2);
        ecviML_CI = (ncpCI_ML + dfValue + (2* nParameters)) / nSize2;
        
    else
        ncpCI_ML = [NaN NaN];
        ecviML = NaN;
        ecviML_CI = [NaN NaN];
    end


%% --------------------------------------------- Combine like-minded outputs

    esXECI = zeros(7,1);
    esXECI(1) = popDisc;
    esXECI(2) = mcdonald;
    esXECI(3) = rmsea;
    esXECI(4) = gamma1;
    esXECI(5) = gamma2;
    esXECI(6) = ecvi;
    esXECI(7) = ecviML;

    ciXECI = zeros(9,2);
    ciXECI(1,1:2) = popDisc_CI;
    ciXECI(2,1:2) = sortrows(mcdonald_CI')';
    ciXECI(3,1:2) = rmsea_CI;
    ciXECI(4,1:2) = sortrows(gamma1_CI')';
    ciXECI(5,1:2) = sortrows(gamma2_CI')';
    ciXECI(6,1:2) = ecvi_CI;
    ciXECI(7,1:2) = ecviML_CI;
    ciXECI(8,1:2) = ncpCI;
    ciXECI(9,1:2) = ncpCI_ML;

    tsXECI = zeros(12,1);
    tsXECI(1) = chiSq;
    tsXECI(2) = dfValue;
    tsXECI(3) = probExact;
    tsXECI(4) = probApprox;
    tsXECI(5) = probNotApprox;
    tsXECI(6) = nSize;
    tsXECI(7) = nGroups;
    tsXECI(8) = nullRMSEA;
    tsXECI(9) = nVars;
    tsXECI(10) = nParameters;
    tsXECI(11) = prmStar;
    tsXECI(12) = meanModel;



%% ------------------------------------------ If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs,0), 'f'] ;
        
        disp(blanks(3)');
        
        str = [...
            ' Structural Equation Modelling Measures of Fit'; ...
            ' ============================================='];
        
        disp(str);
        disp(blanks(2)');

        label_esXECI = char(...
            '   Population discrepancy:          ', ...
            '   McDonald''s NCP:                 ', ...
            '   RMSEA:                           ', ...
            '   Population GFI (Gamma 1):        ', ...
            '   Population AGFI (Gamma 1):       ', ...
            '   ECVI:                            ', ...
            '   ML-ECVI (Transformed AIC):       ');

        label_ciXECI = char(...
            '   Population discrepancy:          ', ...
            '   McDonald''s NCP:                 ', ...
            '   RMSEA:                           ', ...
            '   Population GFI (Gamma 1):        ', ...
            '   Population AGFI (Gamma 1):       ', ...
            '   ECVI:                            ', ...
            '   ML-ECVI (Transformed AIC):       ', ...
            '   Noncentrality parameters:        ', ...
            '   Noncentrality parameters (ML):   ');

        label_tsXECI = char(...
            '   Observed Chi-square:              ', ...
            '   Degrees of freedom:               ', ...
            '   Exact fit P value:                ', ...
            '   Approx. fit P value (accept):     ', ...
            '   Approx. fit P value (reject):     ', ...
            '   Total sample size:                ', ...
            '   Number of groups:                 ', ...
            '   Null hypothesised RMSEA value:    ', ...
            '   Number of variables:              ', ...
            '   Freely est. parameters:           ', ...
            '   Non-redundant covs (& means):     ', ...
            '   Mean structured model:            ');


        nr = length(ciXECI);
        c1 = char(40*ones(nr,1));     % (
        c2 = char(44*ones(nr,1));     % ,
        c3 = char(32*ones(nr,1));     % space
        c4 = char(41*ones(nr,1));     % )


        str = [...
            ' Fit Statistics'; ...
            ' --------------'];
        disp(str);
        
        if mlECVI == 1
            na = 1:7;
        else
            na = 1:6;
        end

        disp( horzcat(label_esXECI(na,:), num2str(esXECI(na,1), strDecs)) ) ;
        disp(blanks(1)');


        if (mod(ciSize,1) == 0)
            str = [...
                ' ' num2str(ciSize,'%6.0f') ...
                '% Confidence Intervals'; ...
                ' ------------------------'];
        else
            str = [...
                ' ' num2str(ciSize,'%6.1f') ...
                '% Confidence Intervals'; ...
                ' --------------------------'];
        end
        
        disp( horzcat(str)) ;
        
        if mlECVI == 1
            nb = [1:5 7 9];
        else
            nb = [1:6 8];
        end
        
        disp( horzcat( label_ciXECI(nb,:), c1(nb), num2str(ciXECI(nb,1), strDecs), ...
                                   c2(nb), c3(nb), num2str(ciXECI(nb,2), strDecs), ...
                                   c4(nb)) ) ;
         
        disp(blanks(1)');


        str = [...
            ' Results for Tests of Model Fit'; ...
            ' ------------------------------'];
        
        disp(str);

        nc = [1:12] ;
        str_tsXECI = mixed2str(tsXECI(nc), [0 1 0 0 0 1 1 0 1 1 1 1], 10, nDecs) ;

        if tsXECI(12) == 1
            str_tsXECI(12,1:10) = 'Yes       ';
        else
            str_tsXECI(12,1:10) = 'No        ';
        end
        
        disp( horzcat( label_tsXECI, str_tsXECI )) ;
        
        disp(blanks(2)');

    end

return
   
   

   


