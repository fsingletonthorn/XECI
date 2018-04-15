function [keyOK, keyNotOK] = KeyPressCompare( key, modifier )
% 
% Utility function that checks each key being pressed in XECI GUI when 
% entering data to assess whether it conforms to input restrictions
%
%
%  INPUT:
%       key = key being pressed
%       modifer = additonal key such as CTL, SHIFT etc, also being pressed 
%
%
%  OUTPUT:
%       keyOK = scalar dichotomous value for 1 = Yes & 0 = No
%       keyNotOK = scalar dichotomous value for 1 = Yes & 0 = No
%
%
%  See also XECIm GUI structure file
%

%
%  VERSION HISTORY
%       Created:    10 Feb 2012
%


% Identifies key presses that can be substituted with BACKSPACE
    stringNotOK = {'leftarrow'; 'rightarrow'; 'uparrow'; 'downarrow'; ...
                   'control'; 'shift'; 'tab'; 'backspace'; 'delete' };

    if sum( strcmp(key, stringNotOK) ) > 0
        keyNotOK = 1;
    elseif strcmp(key, 'equal') && strcmp(modifier, 'shift')
        keyNotOK = 1;
    else
        keyNotOK = 0;
    end

% Identies any key press that is legitimate for numerical input
    stringOK = {'space'; 'return'; 'plus'; 'hyphen'; 'period'};
    if sum( strcmp(key, stringOK) ) > 0 ;
        keyOK = 1;
    elseif isfinite( str2double(key) )
        keyOK = 1;
    elseif strcmp(key, 'v') && strcmp(modifier, 'control')
        keyOK = 2;
    elseif strcmp(key, 'c') && strcmp(modifier, 'control')
        keyOK = 3;
    else
        keyOK = 0;
    end

return
