function pValue = lee1972(nVars, nSize, R, rho)

    pValue = 0;
    
    R2   = R^2 ;
    rho2 = rho^2 ;
    
    n  = nSize - 1 ;
    n1 = nVars ;
    n2 = n - n1 ;
    
    halfN  = 0.5 * n ;
    halfN1 = 0.5 * n1 ;
    halfN2 = 0.5 * n2 ;
    
    BconsLN = halfN*log(1 - rho) - betaln(0.5*n1, 0.5*n2)

    sumK = 0 ;
    
    for k = 1:100
    
        recN  = log( recurN(halfN, k) );
        
        recN1 = log( recurN(halfN1, k) );
        rho2k = log( rho^(2*k) );
        
        Bicomp = log( betainc(R2, halfN1+k, halfN2) );
        
        denom  = log(recN1) + gammaln(k+1) ; 
        
        termK  = exp(recN + recN + rho2k + Bicomp - denom) ;
        
        if k > 0
            iak     = 1 / (1 - Ak(k, n1, n, rho)) ;
        else
            iak = 1 ;
        end ;
        
        
        
        
    betaln( 0.5*n1, 0.5*n2)^(-1) * (1 - rho)^nhalf ;
    
    iak = Ak(k, nVars, nSize, rho) ;
    


    invBeta = 
    
    betainc(X,Z,W)
    
return     

function iak = Ak(k, n1, n)
% Lee (1972, Page 178)

    numerator   = (0.5*n + k - 1)^2 * rho^2 ;
    denominator = k * (0.5*n1 + k - 1) ;
    
    iak = (numerator / denominator) ;
    
return


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


probr[n_,p_,rho2_,x_]:=
	Block[{a,b,cbeta,k,ck,ssum,prob},
					a=(n-1)/2; b=(n-p-1)/2;
				cbeta=(1-rho2)^a/Beta[1,p/2,b];
				k=0;ck=3;ssum=0.0;
		While[ck>=.0000000000001 ,
					k+=1;
						ck=(((Gamma[a+k]/Gamma[a])^2*rho2^k)/((Gamma[p/2+k]/Gamma[p/2])*
						Gamma[k+1]))*Beta[x,p/2+k,b];
			cp=ck;
			If[cp <.0000000000000001, ck=.00000000000001];
			If[k > 2*p, ck=cp];
				ssum=ssum+ck;];
				prob=(Beta[x,p/2,b]+ssum)*cbeta;
		Return[prob]
		 ]  /; n-p-1>=3
