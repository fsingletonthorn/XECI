function [output] = nchypgrnd(nDraws, n1, m1, nSize, theta)
% NCHYPGRND generates data for a non-central hypergeometric PDF
%  
%
% INPUT:  
%       nDraws = number of draws to make from distribution
%       n1     = sample size of group 1
%       m1     = number of positive outcomes in both groups
%       nSize  = 
%       theta  = population odds ratio (equivalent to noncentrality parameter)
% 
%
% OUTPUT: 
%       output = observed probability value
%
%
% NB:
% (1) If THETA = 1, then it calculates the central hypergeometric CDF.
%
% (2) If a 2 x 2 contingency table comprising cell structure
%        ---------
%        | a | b |
%        ---------
%        | c | d |
%        ---------
% then:  
%        n1 = a + b
%        n2 = c + d
%        m1 = a + c
%        theta = (a * d)/(b * c)
%
% Based on R algorithm by Liao & Rosen (2001). American Statistician. 55: 366-369.
%
% See also xeci_xtab, ncp_hypg
% 
    
    % Calculate sample size of second group
    n2 = nSize - n1 ;

    % check parameters
    if (n1 < 0 || n2 < 0) 
       error('nchypergrnd:negative', 'Value of n1 or n2 negative') ;
    end ;
    
    if (m1 < 0) || (m1 > (n1 + n2)) 
       error('nchypergrnd:range', 'Value of m1 is out of range') ;
    end ;
    
    if theta <= 0
       error('nchypergrnd:oddsratio', 'Value of odds ratio is negative') ;
    end ;

    
    % upper and lower limits for density evaluation
    ll = max( [0  (m1-n2)] ) ;
    uu = min( [n1 m1] ) ;

    % get density and other parameters
    mode = mode_compute(n1, n2, m1, theta, ll, uu) ;
    
    pi = zeros( m1+1, 1 ) ;
    
    for j = 0:m1
        pi(j+1) = nchypgpdf(j, n1, m1, nSize, theta) ;
    end ;

    output = zeros(1,nDraws) ;

    for i = 1:nDraws
        output(i) = single_draw(ll, uu, mode, pi) ;
    end
  
return

%
% AUXILIARY FUNCTIONS
%  

function [mode] = mode_compute(n1, n2, m1, theta, ll, uu)

      a = theta - 1 ;
      b = -( (m1+n1+2)*theta + n2-m1 ) ;
      c = theta*(n1+1)*(m1+1) ;
      q = b + sign(b)*sqrt(b*b-4*a*c) ;
      q = -q/2 ;
                         
      if (uu >= fix(c/q) && fix(c/q) >= ll) 
          
          mode = fix(c/q) ;
      else
          
          mode = fix(q/a) ;

      end ;
      
return 

  
function [iVal] = sample_low_to_high(lowerEnd, ran, pi, shift, uu)  
      
    for i = lowerEnd:uu

        if (ran <= pi(i+shift)) 
            iVal = i ;
            return ;
        end ;
        ran = ran - pi(i+shift) ;
        
    end ;                                

return


function  [iVal] = sample_high_to_low(upperEnd, ran, pi, shift, ll)
        
    for i = upperEnd:ll

        if(ran <= pi(i+shift)) 
            iVal = i ;
            return ;
        end ;
        ran = ran - pi(i+shift) ;
        
    end ;
      
return
    

function [rndNo] = single_draw(ll, uu, mode, pi) 
    
    ran = unifrnd(0, 1) ;
    shift = 1-ll ;

    if mode == ll ;
        rndNo = sample_low_to_high(ll, ran, pi, shift, uu) ;
        return ;
    end ;

    if (mode == uu) 
        rndNo = sample_high_to_low(uu, ran, pi, shift, ll) ;
        return ;
    end ;

    if ran < pi(mode+shift)
        rndNo = mode ;
        return ;
    end ;

    ran = ran - pi(mode+shift) ;
    lower = mode - 1 ;
    upper = mode + 1 ;
      

    rndNo = -99 ;
    
    while (rndNo < 0)
        
        if (pi(upper + shift) >= pi(lower + shift))

            if (ran < pi(upper+shift)) 
                rndNo = upper ;
                break ;
            end ;
        
            ran = ran - pi(upper+shift) ;
            if (upper == uu) 
                rndNo = sample.high.to.low(lower, ran, pi, shift, uu) ;
                break ;
            end ;
            
            upper = upper + 1 ;                           

        else 
        
            if (ran < pi(lower+shift)) 
                rndNo = lower ;
                break ;
            end
            ran = ran - pi(lower+shift) ;
        
            if (lower == ll) 
                rndNo = sample.low.to.high(upper, ran, pi, shift, ll) ;
                break;
            end ;
            
            lower = lower - 1 ;
            
        end ;
        
    end ;
return
