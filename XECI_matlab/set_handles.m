function hnd =  set_handles(handStruct, propType)
%
% Utility function sequentially identifies the handle number of a particular
% property type in the objects listed in a handles structure
%
%
%   INPUT:
%       handStruct = handle structure in XECIm
%       propType = propoerty type in requested handle structure
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
%     Created:    12 Dec 2009 
%

    j = size(handStruct, 1) ;
    hnd = zeros(j,1) ;

    for i = 1:j
        hnd(i,1) = findobj(propType, deblank(handStruct(i,:)) ) ;
    end
   
return    
