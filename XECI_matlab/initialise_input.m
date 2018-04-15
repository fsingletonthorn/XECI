function [handles] = initialise_input(handles)
% Initally set all static text and edit boxes in the GUI to be invisible
% before selection of the analysis in main drop-down menu. Makes not change
% to the existing content of the static text boxes ot the edit boxed.
%
%  Version 6th October 2015
%

    set (handles.hst_pg1,  'Visible', 'off') ;
    set (handles.heb_pg1,  'Visible', 'off') ;

    set (handles.hst_pg5,  'Visible', 'off') ;
    set (handles.heb_pg5,  'Visible', 'off') ;
    
    set (handles.hd1,      'Visible', 'off') ;
    set (handles.hd2,      'Visible', 'off') ;
    set (handles.hd3,      'Visible', 'off') ;
    set (handles.hd4,      'Visible', 'off') ;    
    
    set (handles.bg1,      'Visible', 'off') ;
    set (handles.bg2,      'Visible', 'off') ;
    set (handles.bg3,      'Visible', 'off') ;
    
    
return    

