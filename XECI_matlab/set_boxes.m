function  set_boxes(npg1, npg2, npg3, npg4, npg5, spg5, handles)
%
% Utility function uses the row numbers contained in the vectors NPG1, NPG2,
% NPG3 and NPG4 to make visible the appropriate number of edit text boxes 
% in the GUI for each kind of selected analysis, and to specify appropriate
% label descriptions for each text box in its corresponding static text box
%
%
%   INPUT:
%       npg1 = static & edit text boxes to use in Panel 1 (Input Data)
%       npg2 = static & edit text boxes to use in Panel 2 (Point Estimates)
%       npg3 = static & edit text boxes to use in Panel 3 (Interval Estimates)
%       npg4 = static & edit text boxes to use in Panel 4 (Statistical Results)
%       npg5 = edit text boxes to use in Panel 5 (Linear Contrasts)
%       spg5 = static text boxes to use in Panel 5 (Linear Contrasts)
%
%
%   OUTPUT:
%       [null]
%
%
% See also XECIm
%

%
% VERSION HISTORY
%     Created:    28 Dec 2012 
%

% Initialise function by setting all static & edit boxes off

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


% Now apply current changes specified in npg1, npg2, npg3, npg4 
%   (and npg5 if requested)

    rpg1 = length(npg1);
    rpg2 = length(npg2);
    rpg3 = length(npg3);
    dpg3 = 2*rpg3;
    rpg4 = length(npg4);
    rpg5 = length(npg5);
    dpg5 = length(spg5);

    set ( handles.hst_pg1(1:rpg1,1), 'Visible', 'on');
    set ( handles.heb_pg1(1:rpg1,1), 'Visible', 'on');

    set ( handles.hst_pg2(1:rpg2,1), 'Visible', 'on');
    set ( handles.heb_pg2(1:rpg2,1), 'Visible', 'on');

    set ( handles.hst_pg3(1:rpg3,1), 'Visible', 'on');
    set ( handles.heb_pg3(1:dpg3,1), 'Visible', 'on');

    set ( handles.hst_pg4(1:rpg4,1), 'Visible', 'on');
    set ( handles.heb_pg4(1:rpg4,1), 'Visible', 'on');

    if rpg5 > 0
        set ( handles.hst_pg5(1:dpg5,1), 'Visible', 'on');
        set ( handles.heb_pg5(1:rpg5,1), 'Visible', 'on');
    end

    set_loops( handles.hst_pg1(1:rpg1,1), 'String', handles.pg1_labels(npg1,:) );
    set_loops( handles.hst_pg2(1:rpg2,1), 'String', handles.pg2_labels(npg2,:) );
    set_loops( handles.hst_pg3(1:rpg3,1), 'String', handles.pg3_labels(npg3,:) );
    set_loops( handles.hst_pg4(1:rpg4,1), 'String', handles.pg4_labels(npg4,:) );

    if rpg5 > 0
        set_loops( handles.hst_pg5(1:dpg5,1), 'String', handles.pg5_labels(spg5,:) );
    end


return
