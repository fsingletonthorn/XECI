function [probValue, nSuccess_Opposite, probsCover] = prob2sided(testValue, nSize, nullProp)
%  Calculates two-sided exact P value for binomial test of a proportion
%
%  INPUT:
%       testValue = observed number of successful outcomes
%       nSize     = total number of trials
%       nullProp  = null hypothesisied population proportion
% 
%  OUTPUT:
%       probValue = 2-sided probability
%       nSuccess_Opposite = opposite extreme number of successful trials
%       probsCover =  (1) 1-sided probability value >= observed successful trials
%                     (2) 1-sided probability value <= observed successful trials
%                     (3) probability of observed successful trials
%                     (4) probability of opposite extreme number of successful trials
% 
%

    if nullProp == 0.5
        probGreater = binocdf(nSize-testValue, nSize, 1 - nullProp);         % P(X >= x)
        probLesser  = binocdf(testValue, nSize, nullProp);                   % P(X <= x)

        probValue = min( [ 2*min([probGreater; probLesser]) 1] );

        if testValue/nSize >= 0.5
            nSuccess_Opposite = [(nSize - testValue) testValue];
        else
            nSuccess_Opposite = [testValue (nSize - testValue)];
        end
        
        probExtreme = binopdf(nSuccess_Opposite, nSize, nullProp) ;
        probsCover = [probGreater; probLesser; probExtreme'] ;
        return
    end

    nullValue = nSize * nullProp;
    densityNull = binopdf(testValue, nSize, nullProp);
    
    probGreater = binocdf(nSize - testValue, nSize, 1 - nullProp) ;
    probLesser  = binocdf(testValue, nSize, nullProp) ;
    
    % Originally testValue >= nullValue, but does not works correctly when testValue < nullValue
    
%     testValue
%     nullValue
    
    if testValue >= nullValue
        probRight = binocdf(nSize - testValue, nSize, 1 - nullProp);       % P(X >= x)
        
        if nSize < 500;
            j = 0;
        else
            j = nullValue - 500;
        end
        
        x1 = floor(nullValue):-1:j;
        pp = binopdf(x1, nSize, nullProp);

        k0 = (pp <= densityNull);
        if sum(k0) == 0
            probLeft = 0;
            nSuccess_Opposite = [0 testValue];
        else
            k = find(k0, 1);
            probLeft = binocdf(x1(k), nSize, nullProp);                    % P(X <= Opposite tail)
            nSuccess_Opposite = [testValue x1(k)];
        end
        
    else
        probLeft = binocdf(testValue, nSize, nullProp);                    % P(X <= x)
        
        if nSize < 500;
            j = nSize - 1;
        else
            j = testValue + 501;
        end
        
        x1 = testValue+1:j;
        pp = binopdf(nSize - x1, nSize, 1 - nullProp);

        k0 = (pp <= densityNull);
        if sum(k0) == 0
            probRight = 0;
            nSuccess_Opposite = [testValue nSize];
        else
            k = find(k0, 1);
            probRight = binocdf(nSize - x1(k), nSize, 1-nullProp);         % P(X >= Opposite tail)
            nSuccess_Opposite = [testValue x1(k)];
        end
    end

    if isempty(nSuccess_Opposite(nSuccess_Opposite ~= testValue))           % When nSuccess_Opposite EQ nSuccess because p EQ p0
        nSuccess_Opposite = testValue + 1;
    end

    
    probValue   = min([(probRight + probLeft) 1]);
    probExtreme = binopdf(nSuccess_Opposite, nSize, nullProp) ;

    probsCover = [probGreater; probLesser; probExtreme'] ;
    
return