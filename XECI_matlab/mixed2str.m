function num2String = mixed2str(nVector, iType, nNums, nDecs)
%
% Utility function converting numerical vector into a mixed string of 
% integer and numerical values, with numerical formal defined by '%f.d' 
% fixed point display
%
%
% INPUT:
%       nVector = (k X 1) numerical vector
%       iType = (k X 1) indicator vector, whereby 1 = integer, 2 = pValue, 0 = real
%       f = scalar number of displayed values
%       d = scalar number of decimal places
%
%
% OUTPUT:
%       [null]
%
% See also xeci_binom, xeci_corr, xeci_dep2g, xeci_ind2g, xeci_r2, xeci_reg, xeci_xtab 
%
% 

%  Calculate smallest and largest values 

    minDecs = str2num(horzcat('1e-', num2str(nDecs,0))) ;                           %#ok<ST2NM>
    maxDecs = 1 - minDecs ;

%  Create required format for converting numbers
    
    nf = strcat('%',int2str(nNums),'.',int2str(nDecs),'f');
    num2String = num2str(nVector, nf);
    
    strSize = size(num2String) ;
    strEnd = strSize(2) ;
    strStart = strEnd - nDecs - 1 ;

    
    oldString = '.' ;
    newString = ' ' ;
    for i = 1:nDecs
       oldString = [oldString '0'] ;                                                %#ok<*AGROW>
       newString = [newString ' '] ;
    end ;
    
%  If iType = 1, then replace in NUM2STRING any sub-string 
%  OLDSTRING with NEWSTRING
    
    for k = 1:length(nVector)
       % For intergers
       if iType(k) == 1                                     
          num2String(k,:) = strrep(num2String(k,:), oldString, newString);
       
       % For P values
       elseif iType(k) == 2
          if nVector(k) < minDecs
              tmp1 = num2str(minDecs, nf) ;
              tmp2 = strrep(tmp1, '0.', '<.') ;
              num2String(k, strStart:strEnd) = tmp2 ;

          elseif nVector(k) > maxDecs
              tmp1 = num2str(maxDecs, nf) ;
              tmp2 = strrep(tmp1, '0.', '>.') ;
              num2String(k, strStart:strEnd) = tmp2 ;
          end
             
       end
    end

return
