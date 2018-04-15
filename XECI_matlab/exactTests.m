function [exactProbs] = exactTests(cell_A, cell_B, cell_C, cell_D)

    exactProbs = zeros(5,1) ;
    
%     if or >= 1
%        table2x2 = [cell_A cell_B; cell_C cell_D] ;
%     else
%        table2x2 = [cell_B cell_A; cell_D cell_C] ;
%     end ;

   table2x2 = [cell_A cell_B; cell_C cell_D] ;

   [~, both, ~]  = fishertest( table2x2, 'tail', 'both' ) ;

   [~, left, ~ ] = fishertest( table2x2, 'tail', 'left' ) 
   [~, right, ~] = fishertest( table2x2, 'tail', 'right' ) 

   tmp        = 0.5*(left - right + 1) ;
   
   mipd1sided = min( [tmp (1-tmp)] ) ;

   mipd2sided = 2 * mipd1sided ;

   exactProbs(1) = right ;
   exactProbs(2) = both ;
   exactProbs(3) = mipd1sided ;
   exactProbs(4) = mipd2sided ;
   exactProbs(5) = left ;
    
return