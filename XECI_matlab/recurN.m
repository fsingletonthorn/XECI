function ap = recurN(a, j)

    if j == 0
        ap = 1 ;
    elseif j == 1
        ap = a ;
    else
        a0 =  double(a + (1:j-1)) ;
        ap = prod(a0, 'double') ;
    end ;
    
return 