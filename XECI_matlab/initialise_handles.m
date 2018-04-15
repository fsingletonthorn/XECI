function [handles] = initialise_handles(handles)
% Initally set all static text and edit boxes in the GUI to be invisible
% before selection of the analysis in main drop-down menu
%
%  Version 6th October 2015
%

    set ( handles.hst_pg1, 'Visible', 'off');
    set ( handles.heb_pg1, 'Visible', 'off');

    set ( handles.hst_pg2, 'Visible', 'off');
    set ( handles.heb_pg2, 'Visible', 'off');

    set ( handles.hst_pg3, 'Visible', 'off');
    set ( handles.heb_pg3, 'Visible', 'off');

    set ( handles.hst_pg4, 'Visible', 'off');
    set ( handles.heb_pg4, 'Visible', 'off');

    set ( handles.hst_pg5, 'Visible', 'off');
    set ( handles.heb_pg5, 'Visible', 'off');
      
    set (handles.hd1,      'Visible', 'off');
    set (handles.hd2,      'Visible', 'off');
    set (handles.hd3,      'Visible', 'off');
    set (handles.hd4,      'Visible', 'off');
       
    set (handles.hst_pg1,  'String',  '' );
    set (handles.hst_pg2,  'String',  '' );
    set (handles.hst_pg3,  'String',  '' );
    set (handles.hst_pg4,  'String',  '' );
    set (handles.hst_pg5,  'String',  '' );
      
    set (handles.heb_pg1,  'String',  '');
    set (handles.heb_pg2,  'String',  '');
    set (handles.heb_pg3,  'String',  '');
    set (handles.heb_pg4,  'String',  '');
    set (handles.heb_pg5,  'String',  '');
      
    set (handles.hd1,      'String',  '');
    set (handles.hd2,      'String',  '');
    set (handles.hd3,      'String',  '');
    set (handles.hd4,      'String',  '');
    
return    
