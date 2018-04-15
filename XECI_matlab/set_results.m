function  set_results(handleNo, fmt, esValue)
%
% Utility function sequentially replaces the property in the handle list  
% HANDLENO with a set of new string values in ESVALUE using format in FMT
%
%
%   INPUT:
%       handleNo = a (q X 1) numeric vector of handles indicator values
%       fmt = format applied to output of results
%       esValue = a (q X 1) vector of estimates to be displayed 
%
%
%   OUTPUT:
%       [null]
%
%
% See also XECIm
%

%
% VERSION HISTORY
%     Created:    1 Aug 2008 
%


    j = length(handleNo);
    
    for i = 1:j
        set ( handleNo(i,1), 'String', sprintf(fmt, esValue(i,:)) );
    end
      
return   
