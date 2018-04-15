function  set_loops(handleNo, strLabel, newLabel)
%
% Utility function sequentially replaces the existing property strLabel 
%  in the handle list with a set of new string values in newLabel
%
%
%   INPUT:
%       handleNo = a (q X 1) numeric vector of handles indicator values
%       strLabel = a (q X 1) string vector of replacement values 
%       newLabel = property in the handles structure to be replaced
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
        set ( handleNo(i,1), strLabel, newLabel(i,:) );
    end
      
return 
