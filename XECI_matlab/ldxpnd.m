function y = ldxpnd(x)
% LDXPND is a utility function that expands a vector of non-duplicated 
% off-diagonal elements of symmetric matrix X into a full symmetric matrix 
% Y with diagonal zeros
%
% See also XECI_LINCON
%

    m = (sqrt(8*length(x)+1)+1)/2;
    y = zeros(m,m);
    k = 0;

    for i = 2:m
        for j = 1:i-1
            k = k+1;
            y(i,j) = x(k);
            y(j,i) = x(k);
        end
    end
          
return
