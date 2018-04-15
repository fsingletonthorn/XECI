function [handles] = initialise_output(handles)
% Re-initialise static text and edit boxes for output panels in the GUI
% after a change is made in CB1 to CB6, but does not make any change
% to any existing input in Panel 1 or in Panel 5 (when LINCON is selected)
%
%  Version 6th October 2015
%

    set (handles.hst_pg2,  'Visible', 'off');
    set (handles.hst_pg2,  'String', '' );

    set (handles.heb_pg2,  'Visible', 'off');
    set (handles.heb_pg2,  'String',  '');

    set (handles.hst_pg3,  'Visible', 'off');
    set (handles.hst_pg3,  'String', '' );

    set (handles.heb_pg3,  'Visible', 'off');
    set (handles.heb_pg3,  'String',  '');

    set (handles.hst_pg4,  'Visible', 'off');
    set (handles.hst_pg4,  'String', '' );

    set (handles.heb_pg4,  'Visible', 'off');
    set (handles.heb_pg4,  'String',  '');

    set (handles.hst_pg5,  'Visible', 'off');
    set (handles.hst_pg5,  'String', '' );
    
    set (handles.heb_pg5,  'Visible', 'off');
    set (handles.heb_pg5,  'String',  '');
    
return    
