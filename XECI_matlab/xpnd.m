function y = xpnd(x)
%
% Utility function expands vector of non-duplicated elements of a symmetric 
% matrix into a (p X p) symmetric matrix, where x contains p*(p+1)/2 elements
%
%
%   INPUT:
%       x = p*(p+1)/2 vector of non-duplicated matrix elements
% 
% 
%   OUTPUT:
%       y = (p X p) symmetric matrix
%
% See also xeci_lincon
%

%
% VERSION HISTORY
%     Created:    15 Jul 2011
%

    m = (sqrt(8*length(x)+1)-1)/2;
    y = zeros(m,m);
    k = 0;
    
    for i = 1:m
        for j = 1:i
            k = k + 1;
            y(i,j) = x(k);
            y(j,i) = x(k);
        end
    end

return
