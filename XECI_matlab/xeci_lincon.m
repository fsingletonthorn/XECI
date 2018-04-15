function [esXECI, ciXECI, tsXECI, varXECI] = xeci_lincon(...
                    sampleMeans, sampleVars, nSize, contrastCoef, ...
                    ciSize, iType, displayOut, nDecs, nOrder, ...
                    sampleCorr, userMSE, userDF, rescale)
%                 
% XECI_LINCON calculates estimates of effect sizes and CIs for a user-defined 
% linear contrast of cell means obtained from ANOVA designs, where k is the 
% total number of cell means in the linear contrast being calculated.
%
%
%   INPUT: [7 required input arguments {plus 5 optional arguments}]
%           
%       sampleMeans  =  k-dimensional row vector of cell sample means for contrast 
%
%       sampleVars   =  k-dimensional row vector of cell sample variances for contrast
%                         OR 
%                       (k X k) variance-covariance matrix for within subjects designs
%                         OR
%                       nGroups-stacked (t X t) variance-covariance matrices for mixed subjects designs
%                         (where t = number of within-subject levels)
%
%       nSize        =  - (nGroups X 1) vector for sample sizes for B/S designs (iType = 1)
%                       - scalar for sample size of W/S designs (iType = 2)
%                       - (nGroup X 1) vector of B/S group sample sizes for mixed designs (iType = 3,4)
%
%       contrastCoef =  If iType <= 2: k-dimensional vector of cell contrast coefficients
%                        OR
%                       If iType = 3: j-dimensional vector of B/S contrast coefficients (j = k / nTimes)
%                        OR
%                       If iType = 4: either
%                                (i)  i-dimensional vector of W/S contrast coefficients (i = k / nGroups)
%                                (ii) (2 X i*j) matrix of mixed interaction contrast coefficients, with
%                                        1st row containing set of W/S coefficients, and
%                                        2nd row containing set of B/S coefficients.
%                                        (if row lengths unequal, end fill with NaNs)
%
%       ciSize       =  confidence interval size (between 0 and 100)
%
%       iType        =  design type 
%                         1 = between-subjects contrast; 
%                         2 = within-subjects contrast; 
%                         3 = mixed design B/S contrast
%                         4 = mixed design W/S contrast (includes mixed interaction)
%                                     
%
%       displayOut   =  display output 
%                         1 = yes
%                         0 = no
%
%       {nOrder      =  mean difference scaling value for contrast coefficients
%                         0 = mean difference [default]
%                         1 = order-1 for 2-way interaction, 
%                         2 = order-2 for 3-way interaction, etc}
%
%       {sampleCorr  =  vector or matrix of residual within-subjects correlations}
%       {userMSE     =  user-specified mean square error value}
%       {usedDF      =  user-specified degrees of freedom for mean square error}
%       {rescale     =  scalar indicator for normalised rescaling (1 = YES [default], 0 = NO)}
% 
% 
% 
%   OUTPUT:
%       esXECI = (3 X 1) vector of point estimates of effect sizes 
%                   [Raw Difference; 
%                    Bonett's delta (separate); 
%                    Bird's delta' (pooled)
%                    Hedges' g for individual change]      [for W/S designs only]
%                          
%       ciXECI = (5 X 2) matrix of  lower and upper bound CI estimates of effect sizes
%                   [Raw Difference; 
%                    Bonett's delta (separate); 
%                    Bird's delta' (pooled)
%                    Bird's delta* (separate)      [for B/S designs only]
%                    Noncentral (Algina-Keselman)
%                    Noncentrality parameters ]
%
%       tsXECI = (5 X 1) vector of t test results
%                   [t statistic value
%                    degrees of freedom
%                    obtained P value
%                    F value for contrast]
%
%       varXECI = (5 x 1) vector of variance parameter estimates
%                   [Bonett standardizer (separate) 
%                    Bird standardizer (pooled)
%                    Variance (delta)
%                    Variance (delta')
%                    Mean square error
%                    SE for t statistic value]
% 

%  Notes:   (1)   'ci' is a percentage value (e.g., use '95' for 95% CI)
%           (2)   For raw data, first column contains unique indentifier
%                 for all B/S levels as a single vector; second (and
%                 subsequent) columns contain DV or W/S scores
% 
%
%
%
% See also ncp_t
%

%
%   VERSION HISTORY
%       Created:    12 Jul 2008 
%       Revision:   18 Dec 2009:   * Added Algina-Keselman (2003) noncentral standardised interval
%                                  * Included additional error checks for consistency of input arguments
%       Revision:   20 Oct 2011:   * Added MSE calculation function
%                                  * Added Bird(2002) standardised confidence intervals
%


%% Initialise output arguments

    esXECI  = [] ;
    ciXECI  = [] ;
    tsXECI  = [] ;
    varXECI = [] ;


%% ------------------------------------ Checking input arguments are correct

    if nargin < 7 || nargin > 13
        error('XECI:lincon',' Input arguments are at least 7, and up to 13.');
    end


    % Check to ensure conformability of means, variances, and coefficients

    tmp0 = length(sampleMeans);
    tmp1 = length(sampleVars);

    if isvector(contrastCoef) && iType <= 2
        tmp2 = length(contrastCoef);
    end


    if iType == 1 && (tmp0 ~= tmp1)
        errordlg('Number of means & number of variances are not the same ', ...
                 'Input Entry Error' ); 
        return
    end


    if isvector(contrastCoef) && iType <= 2
        if(tmp0 ~= tmp2)
            errordlg('Number of means & number of contrasts are not the same ', ...
                     'Input Entry Error' ); 
            return

        elseif (tmp1 ~= tmp2)
            errordlg('Number of variances & number of contrasts are not the same ', ...
                     'Input Entry Error' ); 
            return
        end
    end


    % Check to ensure SampleVars vector and SampleCorr matrix are both not 
    % empty if summary statistics input

    if nargin >= 11 && isempty(sampleVars) && isempty(sampleCorr)
        error('XECI:lincon', ...
            ' Both SampleVars vector and SampleCorr matrix are empty ');
    end


    % If iType equals 3 or 4, then dimension of nSize equals number of B/S groups

    if iType >=3 && isscalar(nSize)
        errordlg('Number of sample size values does not equal number of B/S groups ', ...
                 'Input Entry Error' ); 
        return
    end


    % If any of SampleMeans, SampleVars, ContrastCoefficients, or nSize are 
    % in column vector form, then reshape to row vector

    if isvector(sampleMeans) && iscolumn(sampleMeans)
        sampleMeans = reshape(sampleMeans',1,[]);

    elseif isrow(sampleMeans) == 0
        error('XECI:lincon', ...
            ' Sample means are not in row vector form ');
    end


    if isvector(sampleVars) && iscolumn(sampleVars)
        sampleVars = reshape(sampleVars',1,[]);

    elseif isrow(sampleVars) == 0 && iType == 1
        error('XECI:lincon', ...
            ' Sample variances are not in row vector form for B/S design ');
    end


    if isvector(contrastCoef) && iscolumn(contrastCoef)
        contrastCoef = reshape(contrastCoef',1,[]);

    elseif isrow(contrastCoef) == 0 && iType <= 3
        error('XECI:lincon', ...
            ' Contrast coefficients are not in row vector form ');

    elseif isrow(contrastCoef) == 0 && iType == 4 && size(contrastCoef,1) ~= 2
        error('XECI:lincon', ...
            ' Contrast coefficients are not in correct form for iType = 4 ');
    end


    if isvector(nSize) && iscolumn(nSize)
        nSize = reshape(nSize',1,[]);

    elseif isrow(nSize) == 0
        error('XECI:lincon', ...
            ' Group sample sizes are not in row vector form ');
    end


    % Checks for inadmissible input values

    if iType == 1
        tmp = sampleVars;
    else
        tmp = diag(sampleVars);
    end

    if sum(tmp <= 0 ) ~= 0
        errordlg('At least one variance is negative or equals zero ', ...
                 'Input Entry Error' ); 
        return
    end

    if sum(nSize <= 0) ~= 0
        errordlg('At least one sample size is negative or equals zero ', ...
                 'Input Entry Error' ); 
        return
    end

    if sum(contrastCoef(~isnan(contrastCoef))) ~= 0
        errordlg('Contrast coefficients do not sum to zero ', ...
                 'Input Entry Error' ); 
        return
    else

    end

    if (ciSize <= 0) || (ciSize >= 100)
        errordlg('Confidence interval value < 0 or > 100 ', ...
                 'Input Entry Error' ); 
        return
    end



%% Fill in empty options if nargin < 13 -----------------------------------

    % If sampleCorr is vector of lower-diagonal values, re-form into covariance matrix

    if nargin >= 10 && isvector(sampleCorr)
        sampleCorr = xpnd(sampleCorr);
    end
    
    if nargin == 6
       displayOut = 0 ;
       nDecs = 4 ;
       nOrder = 0;
       rescale = 1;
       userMSE = [];
       userDF = [];
       
    elseif nargin == 7
       nDecs = 4 ;
       nOrder = 0;
       rescale = 1;
       userMSE = [];
       userDF = [];
       
    end;

    
    if nargin == 8
        if iType == 4 && size(contrastCoef,1) == 2
            nOrder = [0; 0];
            rescale = [1; 1];
        else
            nOrder = 0;
            rescale = 1;
        end

        if iType == 1
            sampleCorr = [];
        end

        userMSE = [];
        userDF = [];

    elseif nargin == 9
        if iType == 1
            sampleCorr = [];
        end
        userMSE = [];
        userDF = [];
        if iType == 4 && size(contrastCoef,1) == 2
            rescale = [1; 1];
        else
            rescale = 1;
        end

    elseif nargin == 10
        userMSE = [];
        userDF = [];
        if iType == 4 && size(contrastCoef,1) == 2
            rescale = [1; 1];
        else
            rescale = 1;
        end

    elseif nargin == 11
        userDF = [];
        if iType == 4 && size(contrastCoef,1) == 2
            rescale = [1; 1];
        else
            rescale = 1;
        end

    elseif nargin == 12
        if iType == 4 && size(contrastCoef,1) == 2
            rescale = [1; 1];
        else
            rescale = 1;
        end

    end


    % Transpose nOrder vector if input as row
    if isrow(nOrder)
        nOrder = nOrder';
    end

   
%    if iType ~= 1
%       if nargin >= 9
%          tmp = sampleCorr;
%       else
%          tmp = sampleVars;
%       end
%          
%       if sum (eig(tmp) == 0) > 0
%          errordlg('W/S covariance matrix is not definite ', 'Input Entry Error' );
%       end
%    end
   

%% ------------------------------------------------ Preliminary calculations

    nCells = length(sampleMeans);                                           % Number of cells in the design

    if iType == 2
        nGroups = 1;
    else
        nGroups = length(nSize);                                            % Number of levels of B/S component
    end

    if iType == 1
        nTimes = 1;
    else
        nTimes = nCells / nGroups;                                          % Number of levels of W/S component
    end

    if size(contrastCoef,1) == 1                                            % Identifier for W/S contrast in iType = 4
        mixedWS = 1;
    else
        mixedWS = 0;
    end




    % Initialise internal contrast matrices for BS and WS
    contrastBS = [];
    contrastWS = [];


    % Check ContrastCoef is conformable with SampleMeans, and restructure 
    % if necessary

    if iType <= 2                                                           % Contrasts for B/S and W/S designs
        nContrasts = length(contrastCoef);

    elseif iType == 3;                                                      % Mixed design B/S contrasts
        contrastBS = contrastCoef;
        contrastCoef = kron( contrastBS, ones(1, nTimes) );
        nContrasts = length(contrastCoef);

    elseif iType == 4 && mixedWS == 1                                       % Mixed design W/S contrasts

        contrastWS = contrastCoef;
        contrastCoef = kron( ones(1, nGroups), contrastWS );
        nContrasts = length(contrastCoef);

    else                                                                    % Mixed design interaction contrast
        contrastWS = (isnan(contrastCoef(1,:)) == 0);
        contrastBS = (isnan(contrastCoef(2,:)) == 0);

        contrastWS = contrastCoef(1, contrastWS);
        contrastBS = contrastCoef(2, contrastBS);

        nContrasts = length(contrastWS) * length(contrastBS);

        contrastCoef = contrastWS' * contrastBS;
        contrastCoef = reshape(contrastCoef, 1, nContrasts);

    end



    % Adjust contrast coefficients for ORDER of contrast using default 
    % main difference scaling

    if mixedWS == 0                                                         % Mixed design with interaction contrast

        if rescale == 1
            contrastWSr = 2 * contrastWS / sum(abs(contrastWS));
            contrastBSr = 2 * contrastBS / sum(abs(contrastBS));
        else
            contrastWSr = contrastWS;
            contrastBSr = contrastBS;
        end

        order = 2 .^ nOrder;

        scaledCoef = (contrastWSr * order(1))' * (contrastBSr * order(2));
        scaledCoef = reshape(scaledCoef, 1, nContrasts);

    else                                                                    % All other designs & contrasts

        if rescale == 1
            scaledCoef = 2 * contrastCoef / sum(abs(contrastCoef));
        else
            scaledCoef = contrastCoef;
        end

        order = 2^nOrder;

        scaledCoef = scaledCoef * order;

    end


    % Calculate critical values from z and t distributions for CIs

    if isempty(userDF)
        df1 = sum(nSize) - nGroups;
    else
        df1 = userDF;
    end

    probCI = [((100 + ciSize)/200) ((100 - ciSize)/200)];                   % P values for defining CI bounds

    zCritical = norminv(1 - probCI, 0, 1);                                  % Lower and upper bound critical z values

    tCritical = tinv(1 - probCI, df1);                                      % Lower and tpper bound critical t values


    % Check if sampleVars is of matrix form for ITYPE > 1 
    % (i.e., covariance matrix)

    if iType > 1 && isvector(sampleVars) == 0

        if size(sampleVars, 1) == size(sampleVars, 2)                       % sampleVars contains symmetric W/S covariance matrix

            sampleCorr = sampleVars;
            sampleVars = diag(sampleCorr)';

        else                                                                % sampleVars contains stacked W/S covariance matrices
            tmp1 = repmat(sampleVars', nGroups, 1);
            tmp2 = kron( eye(nGroups), ones(nTimes, nTimes) );
            sampleCorr = tmp1 .* tmp2;
            sampleVars = diag(sampleCorr)';
        end

        if sum (eig(sampleCorr) == 0) > 0
            errordlg('W/S covariance matrix is not definite ', ...
                     'Input Entry Error' ); 
            return
        end

    end



    varDiagM = diag(sampleVars);                                            % Diagonal matrix of variances created from vector of variances
    sdDiagM = sqrt(varDiagM);


    % Create covariance matrix of sample means to use in Bonett (2008) Eq 18

    if iType == 1                                                           % For B/S designs:  Copy diagonal sampleVars into covMeans matrix
        covMeans0 = varDiagM;

    elseif iType >= 2                                                       % For W/S and MIXED designs

        if isvector(sampleCorr) == 0
            if sum(diag(sampleCorr)~=1) == 0
                covMeans0 = sdDiagM * sampleCorr * sdDiagM;                 % Within-subject correlation matrix as input
            else
                covMeans0 = sampleCorr;                                     % Within-subject covariance matrix as input
            end

        elseif max(size(sampleCorr)) == nContrasts * (nContrasts-1) / 2
            sampleCorr = ldxpnd(sampleCorr) + eye(nContrasts);              % Converts input vector of off-digonal correlations into matrix
            covMeans0 = sdDiagM * sampleCorr * sdDiagM;                     % Within-subject covariance matrix

        else
            error('XECI:lincon', ...
                  'Number of off-diagonal correlations is incorrect.');
        end

    end


    % Re-adjust nSize to be comformable with length of contrastCoef vector

    if iType == 1
        if isscalar(nSize)
            nSize = nSize * ones(1, nContrasts);

        elseif length(nSize) < nContrasts
            nSize = kron(ones(1, nGroups), nSize);
        end

    elseif iType == 2
        if isscalar(nSize)
            nSize = nSize * ones(1, nContrasts);
        end

    elseif iType >= 3
        if length(nSize) < nContrasts
            nSize = kron(nSize, ones(1, nTimes));
        end

    end


    % Calculate mean square error value 
    % (contrastCoef, covMeans, iType, nSize, nDF, nGroups)

    if isempty(userMSE)
        
        % B/S or mixed B/S contrasts
        if iType == 1 || iType == 3                                         

            iContrasts = ones(1, nContrasts);
            meanSqError = calcMSE(iContrasts, covMeans0, iType, ...
                                    nSize, df1, nGroups);

        % W/S contrasts
        elseif iType == 2                                                   

            meanSqError = calcMSE(contrastCoef, covMeans0, iType, ...
                                    nSize, df1, nGroups);

        % Mixed within & interaction contrasts
        elseif iType == 4                                                   

            contrastMixed = kron( ones(1, nGroups), contrastWS );
            meanSqError = calcMSE(contrastMixed, covMeans0, iType, ...
                                    nSize, df1, nGroups);

        end

    else

        meanSqError = userMSE;

    end
   

%% ------------------------------------------------Calculating effect sizes   

    % Compute standardized contrast effects

    meanContrast = sum(sampleMeans .* scaledCoef);                          % Raw contrast effect

    sdSeparate = sqrt( mean(sampleVars) );                                  % Standardizer for contrast [Bonett, 2008]

    if iType == 2
        sdPooled = sdSeparate;                                              % Separate variances standardiser for W/S  [Bird, 2004]
    else
        sdPooled = sqrt( sum( (nSize - 1) .* sampleVars ) / ...
                        (sum(nSize) - nContrasts) );                        % Pooled variances standardiser for B/S and Mixed [Bird, 2004]
    end

    dBonett = meanContrast / sdSeparate;
    dBird = meanContrast / sdPooled;
    dBirdSep = dBonett;

    if iType == 2 || iType == 4                                             % Standardised individual change estimate W/S contrasts
        sdIndvChange = sqrt( contrastCoef * covMeans0 * contrastCoef' );
        dIndvChange = meanContrast / sdIndvChange;
    else
        sdIndvChange = NaN;
        dIndvChange = NaN;
    end
   

   
%% ------------------------------------- Test statistics for linear contrast

    scaledCoefSQ_n = scaledCoef * diag(1./nSize) * scaledCoef';

    stdError = sqrt( meanSqError * scaledCoefSQ_n );                        % For raw difference in linear contrast

    tValue = meanContrast / stdError;                                       % Observed t value for linear contrast

    probValue = 2 * (1 - tcdf(abs(tValue), df1));                           % Obtained p value for test statistic

    if (iType == 1) || (iType == 3)
        stdErrorSep = sqrt( sum(scaledCoef.^2 .* sampleVars ./ nSize) );
        tValueSep = meanContrast / stdErrorSep;
        temp = (scaledCoef.^2 .* sampleVars ./ nSize).^2;
        dfSep = stdErrorSep^4 / sum( temp ./ (nSize - 1) );
        probValueSep = 2 * (1 - tcdf(abs(tValueSep), dfSep));               % Obtained p value for test statistic under separate variances

    else
        stdErrorSep = NaN;
        tValueSep = NaN;
        dfSep = NaN;
        probValueSep = NaN;

    end

    ssContrast = meanContrast^2 / scaledCoefSQ_n;

   
%% ---------------------------- Calculating variance of standardized effects   
   
    % Compute appropriate variance of dBonett(delta-hat)
    % using Equation 18 in Bonett (2008)

    mult2 = 2;

    covVars0 = mult2 * diag(sampleVars.^2);

    if (iType > 1)
        for i = 2:nContrasts;
            for j = 1:i-1
                covVars0(i,j) =  mult2 * covMeans0(i,j)^2;
                covVars0(j,i) =  mult2 * covMeans0(i,j)^2;
            end
        end
    end

    diagDF = sqrt(diag(1 ./ (nSize - 1)));

    covMeans = diagDF * covMeans0 * diagDF;                                 % Variances & covariances among sample means: equals M matrix in Eq 18, Bonett (2008)

    covVars = diagDF * covVars0 * diagDF;                                   % Variances & covariances among sample variances & covariances: equals V matrix in Eq 18, Bonett (2008)


    % Bonnett-type variance of standardized contrast coefficient
    % (mult4 is the offset referred to above)

    mult4 = 4;

    onesContrasts = ones(nContrasts,1);

    varBonett =  ( dBonett^2 * ...
        (onesContrasts' * covVars * onesContrasts) /...
        (mult4 * nContrasts^2 * sdSeparate^4) ) ...
        + ...
        ( (scaledCoef * covMeans * scaledCoef') / ...
        (sdSeparate * sdSeparate) );


    varBird = stdError^2 / sdPooled^2;
    varBird2 = stdError^2 / sdSeparate^2;
   
   
%% ---------------------------------------------------- Confidence intervals

    % Raw mean contrast confidence interval based on t distribution

    ciMean_Diff = meanContrast + (stdError .* tCritical);


    % Bonett-type separate variance confidence interval for standardized contrast

    ciBonett = dBonett + (sqrt(varBonett) * zCritical);


    % Pooled variance confidence interval for standardized contrast

    ciPooled = dBird + (sqrt(varBird) * tCritical);
    ciBirdSep = dBirdSep + (sqrt(varBird2) * tCritical);


    % Algina-Keselman (2003) non-centrality parameter confidence interval
    % for standardized contrast

    if isfinite(tValue)
        ciNCP = ncp_t(tValue, df1, probCI);                                 % CI for noncentrality parameter
        ciExact = ciNCP * stdError / sdSeparate;                            % CI for standardized noncentrality parameter using separate SD

    else
        ciNCP = [NaN NaN];
        ciExact = [NaN NaN];
    end

   
   
%% --------------------------------------------- Combine like-minded outputs 
      
    % All effect size point estimates
    esXECI = zeros(4,1);
    esXECI(1) = meanContrast;
    esXECI(2) = dBonett;
    esXECI(3) = dBird;
    esXECI(4) = dIndvChange;


    % All effect size interval estimates
    ciXECI = zeros(6,2);
    ciXECI(1,1:2) = ciMean_Diff;
    ciXECI(2,1:2) = ciBonett;
    ciXECI(3,1:2) = ciPooled;
    ciXECI(4,1:2) = ciBirdSep;
    ciXECI(5,1:2) = ciExact;
    ciXECI(6,1:2) = ciNCP;


    % All relevant test statistic values
    tsXECI = zeros(8,1);
    tsXECI(1) = tValue;
    tsXECI(2) = df1;
    tsXECI(3) = probValue;
    tsXECI(4) = tValue^2;
    tsXECI(5) = meanSqError;
    tsXECI(6) = tValueSep;
    tsXECI(7) = dfSep;
    tsXECI(8) = probValueSep;


    % All relevant variance estimates
    varXECI = zeros(8,1);
    varXECI(1) = sdSeparate;
    varXECI(2) = sdPooled;
    varXECI(3) = sdIndvChange;
    varXECI(4) = varBonett;
    varXECI(5) = varBird;
    varXECI(6) = stdError;
    varXECI(7) = stdErrorSep;
    varXECI(8) = ssContrast;

%     covXECI = [covMeans, covVars];
   

   
%% ------------------------------------------If output display is requested

    if displayOut == 1
       
        strDecs = ['%10.', num2str(nDecs, 0), 'f'] ;

        disp(blanks(3)');
        
        headingMain = [...
            ' Estimates of Effect Sizes for Linear Mean Contrasts'; ...
            ' ==================================================='];
        
        disp(headingMain);
        disp(blanks(2)');

        label_esXECI  = char(...
            '   Raw mean difference:        ', ...
            '   Delta (Bonett):             ', ...
            '   Delta'' (Bird):             ', ...
            '   Hedges'' g (Indv. Change):  ');

        label_ciXECI  = char(...
            '   Raw mean difference:        ', ...
            '   Delta (Bonett):             ', ...
            '   Delta'' (Bird):             ', ...
            '   Delta* (separate):          ', ...
            '   Non-central (Algina):       ', ...
            '   Non-centrality parameters:  ');

        label_tsXECI  = char(...
            '   Obs. t value (MSerror):     ', ...
            '   df (MSerror):               ', ...
            '   P value (MSerror):          ', ...
            '   F value for contrast:       ', ...
            '   Mean-square error:          ', ...
            '   Obs. t value (separate):    ', ...
            '   df (separate):    :         ', ...
            '   P value (separate):         ');

        label_varXECI = char(...
            '   Bonett standardizer:        ', ...
            '   MSerror standardiser:       ', ...
            '   Indv. change standardizer:  ', ...
            '   Var(delta):                 ', ...
            '   Var(delta''):               ', ...
            '   SE (MSerror):               ', ...
            '   SE (separate):              ', ...
            '   Contrast SS:                ');

        nRows = length(ciXECI);
        cc1 = char(40*ones(nRows, 1));     % (
        cc2 = char(44*ones(nRows, 1));     % ,
        cc3 = char(32*ones(nRows, 1));     % space
        cc4 = char(41*ones(nRows, 1));     % )


        if iType == 1
           headingCoeffs = [...
               ' Contrast Coefficients For B/S Effects'; ...
               ' -------------------------------------'];
        elseif  iType == 2
           headingCoeffs = [...
               ' Contrast Coefficients For W/S Effects'; ...
               ' -------------------------------------'];
        elseif  iType == 3
           headingCoeffs = [...
               ' Contrast Coefficients For Mixed B/S Effects'; ...
               ' -------------------------------------------'];
        elseif  iType == 4
           headingCoeffs = [...
               ' Contrast Coefficients For Mixed W/S Effects'; ...
               ' -------------------------------------------'];
        end;
        
        disp(headingCoeffs);
        d_ci1 = num2str(contrastCoef,  '%6.2f');
        disp (['   Entered values:             ' d_ci1 ]);
        d_ci2 = num2str(scaledCoef, '%6.2f');
        disp (['   Re-scaled values:           ' d_ci2 ]);
        d_ci3 = num2str(nOrder', '%6.0f');
        disp (['   Order of interaction:       ' d_ci3 ]);
        disp(blanks(1)');



        headingEffects = [...
            ' Point Estimates'; ...
            ' ---------------'];
        
        disp(headingEffects);
        str_esXECI = num2str(esXECI, strDecs);
        
        if iType == 1 || iType == 3
            disp( horzcat(label_esXECI(1:3,:), str_esXECI(1:3,:) ) );
        else
            disp( horzcat(label_esXECI(1:4,:), str_esXECI(1:4,:) ) );
        end
        
        disp(blanks(1)');


        if (mod(ciSize,1) == 0)
            headingInterval = [' ' num2str(ciSize, '%6.0f') ...
                '% Confidence Intervals'; ...
                ' ------------------------'];
        else
            headingInterval = [' ' num2str(ciSize, '%6.1f') ...
                '% Confidence Intervals'; ...
                ' --------------------------'];
        end
        
        disp( horzcat(headingInterval));
        xeci_d = label_ciXECI;
        disp( horzcat( xeci_d, cc1, num2str(ciXECI(:,1), strDecs), ...
                          cc2, cc3, num2str(ciXECI(:,2), strDecs), cc4) ) ;
        disp(blanks(1)');


        headingStats = [...
            ' Test Statistics Results'; ...
            ' -----------------------'];
        
        disp(headingStats);
        str_tsXECI = mixed2str(tsXECI, [0 1 2 0 0 0 0 2], 10, nDecs) ;


        if iType == 1 || iType == 3
            rowNum = 1:8;
        else
            rowNum = 1:5;
        end
        
        disp( horzcat(label_tsXECI(rowNum,:), str_tsXECI(rowNum,:) ) );
        disp(blanks(1)');


        headingVars = [...
            ' Variance Estimates'; ...
            ' ------------------'];
        
        disp(headingVars);
        str_varXECI = num2str(varXECI, '%10.4f');
        
        if iType == 1 || iType == 3
            rowNum = [1 2 4 5 6 7 8];
        else
            rowNum = [1 2 3 4 5 6 8];
        end
        
        disp( horzcat(label_varXECI(rowNum,:), str_varXECI(rowNum,:) ) );
        disp(blanks(2)');

    end
   
%% --------------------------------------------------------- End of function   

return


% -------------------------------------Sub-functions used in main function
function msError = calcMSE(contrastCoef, covMeans, iType, nSize, nDF, nGroups)
% Calculate mean square error based on summary statistics

    % B/S Design (contrastCoef = vector of ones)

    if iType == 1
        if isvector(covMeans) == 0
            covMeans = diag(covMeans)';
        end
        resSSCP = diag(covMeans .* (nSize - 1));
        nScaledCoef = contrastCoef / sqrt(sum(nSize - 1));
        msError = nScaledCoef * resSSCP * nScaledCoef';
    end


    % W/S Design

    if iType == 2
        contrastOrtho = contrastCoef / sqrt(contrastCoef * contrastCoef');
        msError = contrastOrtho * covMeans * contrastOrtho';
    end


    % Mixed design for B/S contrasts

    if iType == 3
        nTimes = length(contrastCoef) / nGroups;
        resSSCP = bsxfun( @times, covMeans, (nSize - 1) ) / nDF;
        nScaledCoef = contrastCoef / sqrt(nTimes);
        msError = nScaledCoef * resSSCP * nScaledCoef';
    end


    % Mixed design for W/S contrasts and for interaction contrasts

    if iType == 4
        resSSCP = bsxfun( @times, covMeans, (nSize - 1) ) / nDF;
        nScaledCoef = contrastCoef / sqrt(contrastCoef * contrastCoef' / nGroups);
        msError = nScaledCoef * resSSCP * nScaledCoef';
    end

return
