function es = sempower(x,h_null,h_alt,alpha,df,ngrps,itype,dpo)
% SEMFIT calculates a range of fit statistics for structural equation models 
%
% INPUT:    x = Defined sample size (itype = 1) / Defined power (itype = 0)
%           h_null = Null hypothesised RMSEA value
%           h_alt = Alternative hypothesised RMSEA value
%           alpha = Defined alpha level for analysis
%           df = Degrees of freedom
%           ngrps = Number of groups
%           itype = Ananlysi type (1 = Power / 0 = Sample size)
%           dpo = display output (1 = yes, 0 = no)

% 
% OUTPUT:   es = (6 x 1) vector of input argument values + 'y'(= Power estimate / Sample size estimate) 
%                [Null RMSEA; ALT RMSEA; alpha; df; ngrps; y]'
%

%  Notes:   Adapted from SAS algorithm in MacCallum, Browne & Sugawara (1996).
%             Psychological Methods, pp. 
%
%
% Initial version:      21 Jul 2008 
% Revised version 1:    none
%

%  Initial check of input arguments

    if (nargin ~= 8)
        error('M_Files:semfit:TooFewInputs','Requires 8 input arguments.');
    end

    if itype == 1
        if (x < 1)
            error('MyFunctions:semfit:IncorrectN','Defined sample size is not > 0');
        end
    elseif itype == 0
        if (x <= 0)
            error('MyFunctions:semfit:IncorrectPower','Defined power value < 0');
        elseif (x >= 1)
            error('MyFunctions:semfit:IncorrectPower','Defined power value > 1');
        end
    end

    if (df < 1)
        error('MyFunctions:semfit:IncorrectDF','Degrees of freedom are less than one.');
    end


% Some initial calculations
    if (itype == 1);
        nsize0 = x;
    elseif (itype == 0);
        power0 = x;
    end
   
   
% For power, given sample size  (ITYPE = 1)
    if (itype == 1)
        
        ncp0 = (nsize0 - ngrps) * df * h_null*h_null / ngrps;
        ncp1 = (nsize0 - ngrps) * df * h_alt*h_alt / ngrps;

        if (h_null < h_alt)
            cval = ncx2inv(1-alpha, df, ncp0);
            power1 = 1 - ncx2cdf(cval, df, ncp1);
        elseif (h_null > h_alt)
            cval = ncx2inv(alpha, df, ncp0);
            power1 = ncx2cdf(cval, df, ncp1);
        end

    end

      
   
% For sample size, given power  (ITYPE = 0)
    if (itype == 0)
        
        nsize = 0;
        power1 = 0;
        ic = 0;

        % Find suitable initial sample size
        while (power1 < power0)                                   
            
            ic = ic + 1;
            
            if (ic > 100)
                error('M_Files:semfit:InitialN','Search for initial sample size failed.');
            end
            
            nsize = nsize + 100;
            ncp0 = (nsize - ngrps) * df * h_null*h_null / ngrps;
            ncp1 = (nsize - ngrps) * df * h_alt*h_alt / ngrps;
            
            if (h_null < h_alt)
                cval = ncx2inv(1-alpha, df, ncp0);
                power1 = 1 - ncx2cdf(cval, df, ncp1);
            elseif (h_null > h_alt)
                cval = ncx2inv(alpha, df, ncp0);
                power1 = ncx2cdf(cval, df, ncp1);
            end
            
        end

        nsize1 = nsize;                                          
        intv = 200;
        pdiff = power1 - power0;

        ic = 0;
        idir = -1;

        % Use simple bisection to find final required sample size
        while pdiff > .0001
            
            ic = ic + 1;
            
            if (ic > 100)
                error('M_Files:semfit:BisectionFAIL','Bisection search for required sample size failed.');
            end

            intv = 0.5 * intv;
            nsize1 = nsize1 + ( idir * intv * 0.5 );
            ncp0 = (nsize1 - ngrps) * df * h_null*h_null / ngrps;
            ncp1 = (nsize1 - ngrps) * df * h_alt*h_alt / ngrps;

            if (h_null < h_alt)
                cval = ncx2inv(1-alpha, df, ncp0);
                power1 = 1 - ncx2cdf(cval, df, ncp1);
            elseif (h_null > h_alt)
                cval = ncx2inv(alpha, df, ncp0);
                power1 = ncx2cdf(cval, df, ncp1);
            end

            pdiff = abs(power1 - power0);
            
            if ( power1 < power0)
                idir = 1;
            else
                idir = -1;
            end
        end

    end


    % Combine like-minded outputs
    if (itype == 1)
        y = power1;
    elseif (itype == 0)
        y = nsize1;
    end

    es = zeros(7,1);
    es(1) = h_null;
    es(2) = h_alt;
    es(3) = alpha;
    es(4) = df;
    es(5) = ngrps;
    es(6) = x;
    es(7) = y;

    if (dpo == 1)
        
        disp(blanks(3)');
        str = [' SEM Power Analysis';' ------------------'];
        disp(str);

        es_d1 = char('   RMSEA Null Value:          ', ...
                     '   RMSEA Alternative Value:   ', ...
                     '   Alpha level defined:       ');
        es_d2 = char('   Degress of freedom:        ', ...
                     '   Number of groups:          ');
                 
        disp( horzcat(es_d1, num2str(es(1:3),'%6.3f')) );
        disp( horzcat(es_d2, num2str(es(4:5),'%10.0f')) );

        str0 = '  ---------------------------------';

        if (itype == 1)
            lbl0 = '   Proposed sample size:      ';
            lbl1 = '   Estimated power:           ';
            dc0 = '%10.0f';
            dc1 = '%10.4f';
            
        elseif (itype == 0)
            lbl0 = '   Requested power level:     ';
            lbl1 = '   Estimated sample size:     ';
            dc0 = '%10.2f';
            dc1 = '%10.0f';
        end

        disp(blanks(1)');
        disp( horzcat(lbl0,num2str(es(6),dc0)) );
        disp(blanks(1)');

        disp(str0);
        disp( horzcat(lbl1,num2str(es(7),dc1)) );
        disp(str0);

        disp(blanks(2)');

    end
   
return
   
   

   


