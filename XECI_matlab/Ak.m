function ak = Ak(k, n1, n, rho)
% Lee (1972, Page 178)

    numerator   = (0.5*n + k - 1)^2 * rho^2 ;
    denominator = k * (0.5*n1 + k - 1) ;
    
    ak = (numerator / denominator) ;
    
return