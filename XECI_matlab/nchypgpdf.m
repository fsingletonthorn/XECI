function dValue = nchypgpdf(x, n1, m1, nSize, theta)
%
% NCHYPGPDF calculates the density for a non-central hypergeometric PDF
%  
%
% INPUT:  
%       x     = number of items being observed in sample
%       n1    = sample size being selected from population without replacement
%       m1    = number of different possible items in populations
%       nSize = population size from which sampling without replacement is being performed
%       theta = population odds ratio (equivalent to noncentrality parameter)
% 
%
% OUTPUT: 
%       dValue = observed probability value
%
%
% NB:
% (1) If PSI = 1, then it calculates the central hypergeometric CDF.
%
% (2) If a 2 x 2 contingency table comprising cell structure
%        ---------
%        | a | b |
%        ---------
%        | c | d |
%        ---------
% then:  
%        n1    = a + b
%        m1    = a + c
%        nSize =  a + b + c + d
%        psi   = (a * d)/(b * c)
%
% Based on R algorithm by Liao & Rosen (2001). American Statistician. 55: 366-369.
%
% See also xeci_xtab, ncp_hypg
% 


    n2 = nSize - n1 ;
    u = min(n1, m1) ;
    v = max(0, (m1-n2)) ;
    
    prob = zeros(u+v, 1) ;
    r1 = zeros(u+v, 1) ;

    for i = 1:(u-v+1)
        prob(i) = 1 ;
        r1(i) = 0 ;
    end
    
    shift = 1 - v ;

    m0 = hmode(n1, m1, nSize, theta) ;
    
    if (m0 < u)
        r2 = 1;
        for i = (m0+1):u
            r1(i) = (n1-i+1) * (m1-i+1) / i / (n2-m1+i) * theta ;
            r2 = r2 * r1(i) ;
            prob(i+shift) = r2 ;
        end
    end
    
    if (m0 > v)
        r2 = 1;
        for i = m0:-1:(v+1)
            r1(i) = 1 / ((n1-i+1) * (m1-i+1) / i / (n2-m1+i) * theta) ;
            r2 = r2*r1(i) ;
            prob(i+shift-1) = r2 ;
        end
    end
    
    sump = 0;
    for i = 1:(u-v+1)
        sump = sump + prob(i) ;
    end
    
    for i = 1:(u-v+1)
        prob(i) = prob(i) / sump ;
    end
    
    dValue = prob(x+shift) ;

return
     
function z = hmode(n1, m1, nSize, theta)
      
    n2 = nSize - n1 ;

    u = min(n1, m1) ;
    v = max(0, (m1-n2)) ;

    a = theta - 1;
    b = -((m1+n1+2) * theta + n2 - m1) ;
    c = theta * (n1+1) * (m1+1) ;

    if (b >= 0)
        q = b + sqrt(b*b - 4*a*c) ;
    else
        q = b - sqrt(b*b - 4*a*c) ;
    end

    q = (-q / 2) ;
    z0 = fix(c / q) ;

    if ( (u >= z0) && (z0 >= v) )
        z = z0;
    else
        z = fix(q / a) ;
    end

return
