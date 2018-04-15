function DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, ...
                     tsNumbers, tsProb1, tsProb2, tsInteger, ...
                     esXECI, ciXECI, tsXECI, handles)
%        
%  Utility function to format output values after calculating effect size 
%  statistics by using the appropriate indicator values entered in esPanel, 
%  ciPanel and tsPanel
%
%
%  INPUT:
%       ciSize = width of confidence interval (> 0 and < 100)
%
%       esPanel = row indicator numbers for point estimates in ES vector
%       ciPanel = row indicator numbers for interval estimates in CI matrix
%       tsPanel = row indicator numbers for statistical results in TS vector
%
%       tsNumbers = indicator of static and text boxes for Panel 4
%
%       tsProb1 = [q X 1] vector indicating row number of any P value in TSXECI
%       tsProb2 = [q X 1] vector indicating the text box number in HEB_EB4
%
%       tsInteger = [r X 1] vector indicating row in tsXECI of any integer
%
%       esXECI = (k X 1) vector of point estimates of effect sizes
%       ciXECI = (m X 2) matrix of interval estimates of effect sizes
%       tsXECI = (p X 1) vector of associated test statistic values 
%
%
%  OUTPUT:
%       [null]
%
%
%   See also XECIm GUI structure file
%

%
%  VERSION HISTORY
%       Created:    17 Jun 2011
%

    esPanelRows = length(esPanel);
    ciPanelRows = length(ciPanel);
    ciPanelRows2 = 2*ciPanelRows;

    if mod(ciSize,1) == 0;
        formatt1 = '%2.0f';
    else
        formatt1 = '%3.1f';
    end

    set (handles.hd3, 'String', horzcat( num2str(ciSize,formatt1), ...
        '% Confidence Interval') );
     
    set_results( handles.heb_pg2(1:esPanelRows,1),    '%9.4f', esXECI(esPanel,1) );
    set_results( handles.heb_pg3(1:2:ciPanelRows2,1), '%9.4f', ciXECI(ciPanel,1) );
    set_results( handles.heb_pg3(2:2:ciPanelRows2,1), '%9.4f', ciXECI(ciPanel,2) );
    set_results( handles.heb_pg4(tsNumbers,1),        '%9.4f', tsXECI(tsPanel) );

    for i = 1:length(tsProb1);
       
        if (tsXECI(tsProb1(i)) < .0001)
            set (handles.heb_pg4(tsProb2(i),1), 'String', '< .0001');
            
        elseif (tsXECI(tsProb1(i)) > .9999)
            set (handles.heb_pg4(tsProb2(i),1), 'String', '> .9999');
            
        else
            set (handles.heb_pg4(tsProb2(i),1), 'String', ...
                sprintf(  '%9.4f', tsXECI(tsProb1(i)) ));
        end
    end
    
    
    % Used, typically, for displaying df values as integers
    for i = 1:length(tsInteger)
        set (handles.heb_pg4(tsInteger(i), 1), 'String', ...
            num2str( tsXECI( tsInteger(i) ) ) );
    end

return
