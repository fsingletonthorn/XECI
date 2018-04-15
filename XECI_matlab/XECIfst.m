function fig_hdl = XECIfst
% XECIm
%--------------------------------------------------------------------------
% File name:               XECIm.m            
% Originally Generated on: 19-Sep-2012 20:59:54          
% Description :            This function creates the graphical user-interface for XECI and 
%                          enables input data to be entered and results to be displayed in
%                          the interface window.
%--------------------------------------------------------------------------
% This version is signed off for final time on 1st October 2015 and NOT to be further changed 
%

% Line  712:   generate_labels
% Line  785:   pm1_Callback               [Corresponds to the CHOOSE KIND OF ANALYSIS... drop-down menu)
% 
% Line  820:   bg1_SelectionChangeFcn     [Corresponds to the TYPE OF INPUT Sub-Panel & radio buttons)
% Line  853:   bg2_SelectionChangeFcn     [Corresponds to the OPTIONS Sub-Panel & radio buttons)
%
% Line  922:   cb1_Callback
% Line  947:   cb2_Callback
% Line  973:   cb3_Callback
% Line  991:   cb4_Callback
% Line 1010:   cb5_Callback
% Line 1024:   cb6_Callback
% Line 1038:   cb7_Callback
%
% Line 1986:   tb1_Callback               [Corresponds to the CALCULATE button in the user-interface)
% Line 2736:   pb1_Callback               [Corresponds to the RESET button in the user-interface)
% 
% Line 2825    setup_panel_layout         [Correpsonds to layout of GUI according to selections in PM1, BG1, BG2, CB1 to CB7


%% --------------------------------------- FIGURE Creation Start -------------------------(End is line 685)------------- 
%--------------------------------------------------------------------------
   handles.XECI = figure('Tag', 'XECI',      'Units', 'pixels', 'Position', [50 100 705 605], ...
      'Name', 'XECI', 'MenuBar', 'none', 'NumberTitle', 'off', 'Resize', 'on', 'Color',  ....
      get(0,'DefaultUicontrolBackgroundColor'));
   

   % --- BUTTON GROUPS ----------------------------------------------------
   handles.bg1 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'bg1', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [ 10 494 130  86], 'FontSize',  9, ...       
      'FontUnits', 'pixels', 'FontWeight', 'bold', 'Title', 'Type of Input', 'SelectionChangeFcn', @bg1_SelectionChangeFcn);
%       'TooltipString', ' This panel is for controlling different kinds of input for an analysis ', ...

   handles.bg2 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'bg2', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [160 494 130  86], 'FontSize',  9, ...       
      'FontUnits', 'pixels', 'FontWeight', 'bold', 'Title', 'Options', 'SelectionChangeFcn', @bg2_SelectionChangeFcn);
%       'TooltipString', ' This panel is for choosing different options for an analysis ', ...

   handles.bg3 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'bg3', 'UserData', [], 'Units', 'pixels', 'Position',         [710 505 220  75], 'FontSize',  9, ...       
      'FontUnits', 'pixels', 'FontWeight', 'bold', 'Title', 'Extra Input for Linear Contrasts');
%       'TooltipString', ' This panel is for choosing different options for linear contrasts ', ...

  
   % --- PANELS -----------------------------------------------------------
   handles.pg1 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'pg1', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [ 10 219 280 226], 'FontSize', 10, ...  
      'FontUnits', 'points', 'FontWeight', 'bold', 'Title', 'Input Data');
%       'TooltipString', ' This panel is used for providing input on which calcualtions are made ', ...

%    handles.pg2 = uibuttongroup( 'Parent', handles.XECI, ...
%       'Tag', 'pg2', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [300 310 400 185], 'FontSize', 10, ...       
%       'FontUnits', 'points', 'FontWeight', 'bold', 'BackgroundColor', [1 0.949 0.867], 'Title', 'Point Estimates');
%       'TooltipString', ' This panel is used for providing point estimates of various effect sizes ', ...  

   handles.pg2 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'pg2', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [300 330 400 185], 'FontSize', 10, ...       
      'FontUnits', 'points', 'FontWeight', 'bold', 'BackgroundColor', [1 0.949 0.867], 'Title', 'Point Estimates');

%    handles.pg3 = uipanel(   'Parent', handles.XECI, ...
   handles.pg3 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'pg3', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [300  10 400 290], 'FontSize', 10, ...       
      'FontUnits', 'pixels', 'FontWeight', 'bold', 'BackgroundColor', [1 0.949 0.867], 'Title', 'Interval Estimates');
%       'TooltipString', ' This panel is used for providing interval estimates of various effect sizes ', ...

   handles.pg4 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'pg4', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position', [ 10  10 280 205], 'FontSize', 10, ...       
      'FontUnits', 'pixels', 'FontWeight', 'bold', 'BackgroundColor', [0.937 0.867 0.867], ...
      'Title', 'Findings of Statistical Test');
%       'TooltipString', ' This panel is used for providing findings of various statistical tests ', ...

   handles.pg5 = uibuttongroup( 'Parent', handles.XECI, ...
      'Tag', 'pg5', 'UserData', zeros(1,0), 'Units', 'pixels', 'Position',         [710  10 220 485], 'FontSize', 10, ...       
      'FontUnits', 'pixels', 'FontWeight', 'bold', 'Title', 'Linear Contrast Input Data');
%       'TooltipString', ' This panel is used for providing additonal input for linear contrasts ', ...

  
   % --- RADIO BUTTONS ----------------------------------------------------
   handles.rb1 = uicontrol( 'Parent', handles.bg1, ...
      'Tag', 'rb1', 'UserData', zeros(1,0), 'Style', 'radiobutton', 'Units', 'pixels', 'Position', [ 6 46 110 23], ...  
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Radio Button'}, 'Callback', @rb1_Callback);

   handles.rb2 = uicontrol( 'Parent', handles.bg1, ...
      'Tag', 'rb2', 'UserData', zeros(1,0), 'Style', 'radiobutton', 'Units', 'pixels', 'Position', [ 6 26 110 23], ...  
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Radio Button'}, 'Callback', @rb2_Callback);

   handles.rb3 = uicontrol( 'Parent', handles.bg1, ...
      'Tag', 'rb3', 'UserData', zeros(1,0), 'Style', 'radiobutton', 'Units', 'pixels', 'Position', [ 6  6 110 23], ...  
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Radio Button'}, 'Callback', @rb3_Callback);

   handles.rb4 = uicontrol( 'Parent', handles.bg2, ...
      'Tag', 'rb4', 'UserData', [], 'Style', 'radiobutton', 'Units', 'pixels', 'Position',         [ 9 43 100 23], ...  
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Radio Button'}, 'Callback', @rb4_Callback);

   handles.rb5 = uicontrol( 'Parent', handles.bg2, ...
      'Tag', 'rb5', 'UserData', [], 'Style', 'radiobutton', 'Units', 'pixels', 'Position',         [ 9 23 100 23], ...  
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Radio Button'}, 'Callback', @rb5_Callback);

%  
%  This radio button for BUTTON GROUP 2 is not currently used, but has been set up for future possible use.
%
%    handles.rb6 = uicontrol( 'Parent', handles.bg2, ...
%       'Tag', 'rb6', 'UserData', [], 'Style', 'radiobutton', 'Units', 'pixels', 'Position',         [ 9  3 100 23], ...  
%       'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Radio Button'}, 'Callback', @rb6_Callback);

  
   % --- CHECKBOXES -------------------------------------------------------
   handles.cb1 = uicontrol( 'Parent', handles.bg2, ...
      'Tag', 'cb1', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [ 10 48 110 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb1_Callback);

   handles.cb2 = uicontrol( 'Parent', handles.bg2, ...
      'Tag', 'cb2', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [ 10 28 110 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb2_Callback);

   handles.cb3 = uicontrol( 'Parent', handles.bg2, ...
      'Tag', 'cb3', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [ 10  8 110 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb3_Callback);

   handles.cb4 = uicontrol( 'Parent', handles.bg3, ...
      'Tag', 'cb4', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [ 20 35  90 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb4_Callback);

   handles.cb5 = uicontrol( 'Parent', handles.bg3, ...
      'Tag', 'cb5', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [120 35  90 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb5_Callback);

   handles.cb6 = uicontrol( 'Parent', handles.bg3, ...
      'Tag', 'cb6', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [ 20 10  90 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb6_Callback);

   handles.cb7 = uicontrol( 'Parent', handles.bg3, ...
      'Tag', 'cb7', 'UserData', zeros(1,0), 'Style', 'checkbox', 'Units', 'pixels', 'Position',   [120 10  90 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'String', {'Check Box'}, 'Callback', @cb7_Callback);


   % --- STATIC TEXTS -----------------------------------------------------

   % Heading Boxes
   
   handles.cname = uicontrol(   'Parent', handles.XECI, ...
      'Tag', 'cname', 'UserData', [], 'Style', 'text', 'Units', 'pixels', 'Position',        [331 575 370 25], ...             
      'FontName', 'Arial Narrow', 'FontSize', 16, 'FontUnits', 'pixels', 'FontWeight', 'bold', ...
      'ForegroundColor', [1 0 0], 'String', 'XECI Estimates Confidence Intervals');

   handles.hd1 = uicontrol( 'Parent', handles.XECI, ...
      'Tag', 'hd1', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position',  [331 550 370 20], ...             
      'FontSize', 12, 'FontUnits', 'pixels', 'FontWeight', 'bold', ...
      'String', 'Head1', 'HorizontalAlignment', 'center');

   handles.hd2 = uicontrol( 'Parent', handles.XECI, ...
      'Tag', 'hd2', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position',  [331 525 370 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'FontWeight', 'bold',  ...
      'ForegroundColor', [1 0 0], 'String', 'Head2', 'HorizontalAlignment', 'center');

   handles.hd3 = uicontrol( 'Parent', handles.XECI, ...
      'Tag', 'hd3', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position',  [500 300 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'FontWeight', 'bold', 'BackgroundColor', [1 0.949 0.867], ...
      'ForegroundColor', [0 0 1], 'String', 'Head4', 'HorizontalAlignment', 'center');

   handles.st_l = uicontrol(    'Parent', handles.pg3, ...
      'Tag', 'st_l', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [202 252 80 20], ...
      'FontAngle', 'italic', 'FontSize',  8, 'FontUnits', 'pixels', 'FontWeight', 'bold', ...
      'BackgroundColor', [1 0.949 0.867], 'String', 'Lower Limit');

   handles.st_u = uicontrol(    'Parent', handles.pg3, ...
      'Tag', 'st_u', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [302 252 80 20], ...
      'FontAngle', 'italic', 'FontSize',  8, 'FontUnits', 'pixels', 'FontWeight', 'bold', ...
      'BackgroundColor', [1 0.949 0.867], 'String', 'Upper Limit');

   
   % Data Input Boxes
   
   handles.st1_1 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_1', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 183 180 20], ...      
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');
   
   handles.st1_2 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_2', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 161 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_3 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_3', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 139 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_4 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_4', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 117 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_5 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_5', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  95 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_6 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_6', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  73 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_7 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_7', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  51 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_8 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_8', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  29 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   handles.st1_9 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'st1_9', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10   7 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', {'Static Text'}, 'HorizontalAlignment', 'left');

   
   % Effect Size Label Boxes

   handles.st2_1 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_1', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 139 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');
   
   handles.st2_2 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_2', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 117 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st2_3 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_3', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  95 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st2_4 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_4', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  73 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st2_5 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_5', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  51 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st2_6 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_6', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  29 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st2_7 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'st2_7', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10   7 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   
   % Confidence Interval Label Boxes

   handles.st3_01 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_01', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 231 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_02 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_02', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 209 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_03 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_03', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 187 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_04 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_04', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 165 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_05 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_05', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 143 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_06 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_06', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 121 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_07 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_07', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  99 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_08 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_08', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  77 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_09 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_09', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  55 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_10 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_10', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  33 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st3_11 = uicontrol(  'Parent', handles.pg3, ...
      'Tag', 'st3_11', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  11 180 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 0.949 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');
   
   
   % Test Statistic Label Boxes

   handles.st4_1 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_1', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 165 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_2 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_2', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 143 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_3 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_3', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 121 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_4 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_4', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  99 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_5 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_5', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  77 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_6 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_6', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  55 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_7 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_7', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  33 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   handles.st4_8 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'st4_8', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10  11 165 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [0.937 0.867 0.867], 'String', {'Static Text'}, ...
      'HorizontalAlignment', 'left');

   
   % Linear Contrast Label Boxes

   handles.st5_1 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_1', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 435 200 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

   handles.st5_2 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_2', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 365 200 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

   handles.st5_3 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_3', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 285 200 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

   handles.st5_4 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_4', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 215 200 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

   handles.st5_5 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_5', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [10 135 200 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

   handles.st5_6 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_6', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [20 110  50 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

   handles.st5_7 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'st5_7', 'UserData', zeros(1,0), 'Style', 'text', 'Units', 'pixels', 'Position', [20  80  50 20], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'String', 'Static Text', 'HorizontalAlignment', 'left');

  
   % --- PUSHBUTTONS -------------------------------------
   handles.pb1 = uicontrol( 'Parent', handles.XECI, ...
      'Tag', 'pb1', 'UserData', [], 'Style', 'pushbutton', 'Units', 'pixels', 'Position', [180 449 90 40], ...          
      'FontSize', 10, 'FontUnits', 'pixels', 'FontWeight', 'bold', 'BackgroundColor', [0    , 0.67  , 1], ...
      'String', 'Reset All', 'Callback', @pb1_Callback);

   handles.HelpButton = uicontrol(  'Parent', handles.XECI, ...
      'Tag', 'Help', 'UserData', zeros(1,0), 'Style', 'pushbutton', 'Units', 'pixels', ...
      'Position', [297 580 25 25], 'FontSize', 10, 'FontUnits', 'pixels', 'FontWeight', 'bold', ...                     
      'BackgroundColor', [0.702 0.78 1], 'String', '?', 'TooltipString', 'click on button for Help', ...
      'Callback', @HelpButton_Callback);

  
%    'BackgroundColor', [1 0.7 0],
   
   % --- TOGGLE BUTTONS ---------------------------------------------------
   handles.tb1 = uicontrol( 'Parent', handles.XECI, 'Tag', 'tb1', 'UserData', [], 'Style', 'pushbutton', ...
      'Units', 'pixels', 'Position', [30 448 90 40], 'FontSize', 10, 'FontUnits', 'pixels', ...                         
      'FontWeight', 'bold',  'String', 'Enter data...', 'BackgroundColor', [1    , 0    , 0],...
      'Callback', @tb1_Callback, 'CreateFcn', @tb1_CreateFcn);

  
%    % --- EDIT TEXTS -------------------------------------------------------

   % Data Output Boxes 
   
   handles.eb1_1 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_1', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185 188 75 20], ...      
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_1_Callback, ...
      'CreateFcn', @eb1_1_CreateFcn, 'KeyPressFcn', @eb1_1_KeyPressFcn);
   
   handles.eb1_2 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_2', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185 166 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_2_Callback, ...
      'CreateFcn', @eb1_2_CreateFcn, 'KeyPressFcn', @eb1_2_KeyPressFcn);

   handles.eb1_3 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_3', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185 143 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_3_Callback, ...
      'CreateFcn', @eb1_3_CreateFcn, 'KeyPressFcn', @eb1_3_KeyPressFcn);

   handles.eb1_4 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_4', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185 121 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_4_Callback, ...
      'CreateFcn', @eb1_4_CreateFcn, 'KeyPressFcn', @eb1_4_KeyPressFcn);

   handles.eb1_5 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_5', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185  99 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_5_Callback, ...
      'CreateFcn', @eb1_5_CreateFcn, 'KeyPressFcn', @eb1_5_KeyPressFcn);

   handles.eb1_6 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_6', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185  77 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_6_Callback, ...
      'CreateFcn', @eb1_6_CreateFcn, 'KeyPressFcn', @eb1_6_KeyPressFcn);

   handles.eb1_7 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_7', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185  55 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_7_Callback, ...
      'CreateFcn', @eb1_7_CreateFcn, 'KeyPressFcn', @eb1_7_KeyPressFcn);

   handles.eb1_8 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_8', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185  33 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_8_Callback, ...
      'CreateFcn', @eb1_8_CreateFcn, 'KeyPressFcn', @eb1_8_KeyPressFcn);

   handles.eb1_9 = uicontrol(   'Parent', handles.pg1, ...
      'Tag', 'eb1_9', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels','Position',  [185  11 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb1_9_Callback, ...
      'CreateFcn', @eb1_9_CreateFcn, 'KeyPressFcn', @eb1_9_KeyPressFcn);


   % Effect Size Output Boxes 
   
   handles.eb2_1 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_1', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253 143 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_1_Callback, ...
      'CreateFcn', @eb2_1_CreateFcn);

   handles.eb2_2 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_2', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253 121 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_2_Callback, ...
      'CreateFcn', @eb2_2_CreateFcn);

   handles.eb2_3 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_3', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253  99 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_3_Callback, ...
      'CreateFcn', @eb2_3_CreateFcn);

   handles.eb2_4 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_4', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253  77 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_4_Callback, ...
      'CreateFcn', @eb2_4_CreateFcn);

   handles.eb2_5 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_5', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253  55 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_5_Callback, ...
      'CreateFcn', @eb2_5_CreateFcn);

   handles.eb2_6 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_6', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253  33 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_6_Callback, ...
      'CreateFcn', @eb2_6_CreateFcn);

   handles.eb2_7 = uicontrol(   'Parent', handles.pg2, ...
      'Tag', 'eb2_7', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [253  11 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb2_7_Callback, ...
      'CreateFcn', @eb2_7_CreateFcn);


   % Confidence Interval Output Boxes 

   handles.eb3_01a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_01a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205 231 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_01a_Callback, ...
      'CreateFcn', @eb3_01a_CreateFcn);

   handles.eb3_01b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_01b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305 231 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_01b_Callback, ...
      'CreateFcn', @eb3_01b_CreateFcn);

   handles.eb3_02a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_02a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205 209 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_02a_Callback, ...
      'CreateFcn', @eb3_02a_CreateFcn);

   handles.eb3_02b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_02b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305 209 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_02b_Callback, ...
      'CreateFcn', @eb3_02b_CreateFcn);

   handles.eb3_03a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_03a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205 187 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_03a_Callback, ...
      'CreateFcn', @eb3_03a_CreateFcn);

   handles.eb3_03b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_03b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305 187 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_03b_Callback, ...
      'CreateFcn', @eb3_03b_CreateFcn);

   handles.eb3_04a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_04a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205 165 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_04a_Callback, ...
      'CreateFcn', @eb3_04a_CreateFcn);

   handles.eb3_04b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_04b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305 165 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_04b_Callback, ...
      'CreateFcn', @eb3_04b_CreateFcn);

   handles.eb3_05a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_05a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205 143 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_05a_Callback, ...
      'CreateFcn', @eb3_05a_CreateFcn);

   handles.eb3_05b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_05b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305 143 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_05b_Callback, ...
      'CreateFcn', @eb3_05b_CreateFcn);

   handles.eb3_06a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_06a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205 121 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_06a_Callback, ...
      'CreateFcn', @eb3_06a_CreateFcn);

   handles.eb3_06b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_06b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305 121 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_06b_Callback, ...
      'CreateFcn', @eb3_06b_CreateFcn);

   handles.eb3_07a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_07a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205  99 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_07a_Callback, ...
      'CreateFcn', @eb3_07a_CreateFcn);

   handles.eb3_07b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_07b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305  99 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_07b_Callback, ...
      'CreateFcn', @eb3_07b_CreateFcn);

   handles.eb3_08a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_08a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205  77 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_08a_Callback, ...
      'CreateFcn', @eb3_08a_CreateFcn);

   handles.eb3_08b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_08b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305  77 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_08b_Callback, ...
      'CreateFcn', @eb3_08b_CreateFcn);

   handles.eb3_09a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_09a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205  55 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_09a_Callback, ...
      'CreateFcn', @eb3_09a_CreateFcn);

   handles.eb3_09b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_09b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305  55 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_09b_Callback, ...
      'CreateFcn', @eb3_09b_CreateFcn);

   handles.eb3_10a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_10a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205  33 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_10a_Callback, ...
      'CreateFcn', @eb3_10a_CreateFcn);

   handles.eb3_10b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_10b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305  33 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_10b_Callback, ...
      'CreateFcn', @eb3_10b_CreateFcn);

   handles.eb3_11a = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_11a', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [205  11 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_11a_Callback, ...
      'CreateFcn', @eb3_11a_CreateFcn);

   handles.eb3_11b = uicontrol( 'Parent', handles.pg3, ...
      'Tag', 'eb3_11b', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [305  11 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb3_11b_Callback, ...
      'CreateFcn', @eb3_11b_CreateFcn);


   % Significance Test Output Boxes 

   handles.eb4_1 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_1', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185 165 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_1_Callback, ...
      'CreateFcn', @eb4_1_CreateFcn);

   handles.eb4_2 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_2', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185 143 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_2_Callback, ...
      'CreateFcn', @eb4_2_CreateFcn);

   handles.eb4_3 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_3', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185 121 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_3_Callback, ...
      'CreateFcn', @eb4_3_CreateFcn);

   handles.eb4_4 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_4', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185  99 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_4_Callback, ...
      'CreateFcn', @eb4_4_CreateFcn);

   handles.eb4_5 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_5', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185  77 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_5_Callback, ...
      'CreateFcn', @eb4_5_CreateFcn);

   handles.eb4_6 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_6', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185  55 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_6_Callback, ...
      'CreateFcn', @eb4_6_CreateFcn);

   handles.eb4_7 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_7', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185  33 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_7_Callback, ...
      'CreateFcn', @eb4_7_CreateFcn);

   handles.eb4_8 = uicontrol(   'Parent', handles.pg4, ...
      'Tag', 'eb4_8', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [185  11 75 20], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'Callback', @eb4_8_Callback, ...
      'CreateFcn', @eb4_8_CreateFcn);

   
   % Linear Contrast Output Boxes

   handles.eb5_1 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'eb5_1', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [ 10 405 200 30], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'HorizontalAlignment', 'left', ...
      'Callback', @eb5_1_Callback, 'CreateFcn', @eb5_1_CreateFcn, 'KeyPressFcn', @eb5_1_KeyPressFcn);

   handles.eb5_2 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'eb5_2', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [ 10 325 200 40], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'HorizontalAlignment', 'left', ...
      'Max', 2, 'Callback', @eb5_2_Callback, 'CreateFcn', @eb5_2_CreateFcn, 'KeyPressFcn', @eb5_2_KeyPressFcn);

   handles.eb5_3 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'eb5_3', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [ 10 255 200 30], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'HorizontalAlignment', 'left', ...
      'Callback', @eb5_3_Callback, 'CreateFcn', @eb5_3_CreateFcn, 'KeyPressFcn', @eb5_3_KeyPressFcn);

   handles.eb5_4 = uicontrol(   'Parent', handles.pg5, ...
      'Tag', 'eb5_4', 'UserData', zeros(1,0), 'Style', 'edit', 'Units', 'pixels', 'Position', [ 10 175 200 40], ...
      'FontSize', 9, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', '', 'HorizontalAlignment', 'left', ...
      'Max', 2, 'Callback', @eb5_4_Callback, 'CreateFcn', @eb5_4_CreateFcn, 'KeyPressFcn', @eb5_4_KeyPressFcn);

  
   % --- POPUP MENU -------------------------------------
   handles.pm1 = uicontrol( 'Parent', handles.XECI, ...           % Main drop-down menu
      'Tag', 'pm1', 'UserData', [], 'Style', 'popupmenu', 'Units', 'pixels', 'Position', [11 585 280 20], ...           
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], ...
      'TooltipString', ' Select the desired kind of analysis ', ...
      'String', {'Choose kind of analysis...',  ...
      '   2x2 Contingency Table',               ...
      '   Correlations','   R-squared',         ...
      '   Regression Effects',                  ...
      '   Ind. 2 Group Difference',             ...
      '   Dep. 2 Group Difference',             ...
      '   Linear  Contrasts',                   ...
      '   Binomial Proportion',                 ...
      '   SEM Fit Statistics'}, ...
      'Callback', @pm1_Callback, 'CreateFcn', @pm1_CreateFcn, 'KeyPressFcn', @pm1_KeyPressFcn);

   handles.pm2 = uicontrol( 'Parent', handles.pg5, ...           % B/S order-number drop-down menu in Panel 5
      'Tag', 'pm2', 'UserData', [], 'Style', 'popupmenu', 'Units', 'pixels', 'Position', [100 110  40 25], ... 
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', {'  0','  1','  2','  3','  4'}, ...
      'TooltipString', ' Select the order-number for the between-subjects contrast effect ', ...
      'Callback', @pm2_Callback, 'CreateFcn', @pm2_CreateFcn);

   handles.pm3 = uicontrol( 'Parent', handles.pg5, ...           % W/S order-number drop-down menu in Panel 5
      'Tag', 'pm3', 'UserData', [], 'Style', 'popupmenu', 'Units', 'pixels', 'Position', [100  80  40 25], ...
      'FontSize', 10, 'FontUnits', 'pixels', 'BackgroundColor', [1 1 1], 'String', {'  0','  1','  2','  3','  4'}, ...
      'TooltipString', ' Select the order-number for the within-subjects contrast effect ', ...
      'Callback', @pm3_Callback, 'CreateFcn', @pm3_CreateFcn);

% --------------------------------------- FIGURE Creation End -------------------------(Start is line 31)--------------   
   

%% --------------------------------------- Generate labels for user-interface ------------------------------------------


   % Generate all static text and edit box handles
   handles = generate_labels(handles) ;

   % Initially set Figure at smaller position...this will change for Linear Contrasts option
   set (gcf, 'Position', [50 100 705 605]);              % Makes right-hand panel not visible                           
   
   % Save handles structure
   guidata(handles.XECI, handles);
   

  
%% --------------------------------------- PULL-DOWN Menu Created ------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
   function pm1_CreateFcn(hObject, eventdata, ~)                           %#ok<INUSD>
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end ;
      set (hObject, 'String', {'Choose kind of analysis...',   ...
                              '   Contingency Table',          ...         % PM02
                              '   Correlation',                ...         % PM03
                              '   R-squared / Eta-Squared',    ...         % PM04
                              '   Regression Effects',         ...         % PM05
                              '   Ind. 2 Group Difference',    ...         % PM06
                              '   Dep. 2 Group Difference',    ...         % PM07
                              '   Linear Contrast',            ...         % PM08
                              '   Binomial Proportion',        ...         % PM09
                              '   SEM Fit Statistics'});                   % PM10
   end 

%--------------------------------------------------------------------------
   function pm1_KeyPressFcn(hObject, ~)                                    %#ok<INUSD>

   end

%--------------------------------------------------------------------------
   function pm2_Callback(hObject, ~)
      pm2 = get(hObject, 'Value');
      set (handles.pm2, 'Value', pm2);
      set (hObject, 'BackgroundColor', [1    , 1    , 0.7]);
      guidata(hObject, handles)
   end

%--------------------------------------------------------------------------
   function pm2_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
      set (hObject, 'String', {'  0', '  1', '  2', '  3', '  4'});
   end

%--------------------------------------------------------------------------
   function pm3_Callback(hObject, ~)
      pm3 = get(hObject, 'Value');
      set (handles.pm3, 'Value', pm3);
      set (hObject, 'BackgroundColor', [1    , 1    , 0.7]);
      guidata(hObject, handles)
   end

%--------------------------------------------------------------------------
   function pm3_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
      set (hObject, 'String', {'  0', '  1', '  2', '  3', '  4'});
   end


%% --------------------------------------- PULL-DOWN Menu Callback -----------------------------------------------------
%  Provides the initial set-up of user-interface in the MATLAB XECI window based on users' selection of 
%  one of the nine possible statistical analyses available through the pull-down menu.  
%
%  This initial selection can then be subsequently modified by using RB1, RB2, and CB1 to CB7 to change
%  the default set-up provided by this PM1_CALLBACK function.
%-----------------------------------------------------------------------------------------------------------------------
   function pm1_Callback(hObject, ~)

      initialise_handles(handles) ;

      handles = set_default_setup(handles) ;

      % Now choose kind of analysis from the main drop-down menu and start accordingly
      pm1 = get(hObject, 'Value');

      % Default interface set display with 5th panel hidden
      gcfPosition = get(gcf, 'Position');
      set (gcf, 'Position', [gcfPosition(1:2) 705 605]);          % Revert to smaller window size                       


      % Initial Set-up for Menu Selection after first opening or after reset button is pressed
      handles = setup_panel_layout(handles, pm1) ;
                                       
      
      % Final initialisation of initial selection
      set (handles.pm1, 'Value', pm1);
      
      set_tooltips(handles);
      guidata(hObject, handles)
      
   end  



%% --------------------------------------- BUTTON GRP 1 Selection Change -----------------------------------------------
%  Activated if there is change made to the current active button in the TYPE OF INPUT radio button panel.
% 
%  The resultant change to other panels may, or may not, depend upon the current active check-box in the 
%  OPTIONS check-box panel.
%
%-----------------------------------------------------------------------------------------------------------------------
   function bg1_SelectionChangeFcn(hObject, ~)
   %
   % NB: PM2 and PM3 have no handle value to be extracted here and are therefore excluded.
   %     Value for CB6 is not required or used, and is therefore excluded.
   %
       
      pm1 = get(handles.pm1, 'Value');

      
      set (handles.tb1,      'BackgroundColor', [1    , 0    , 0]);           % Red
      set (handles.tb1,      'String', 'Enter data...');
      set (handles.tb1,      'Value', 0);
      
      initialise_output(handles) ;      

      handles = setup_panel_layout(handles, pm1) ;

      set_tooltips(handles);
      guidata(hObject, handles)
   end



%% --------------------------------------- BUTTON GRP 2 Selection Change -----------------------------------------------
%  Activated if there is change, or addition, made to the current active radio button or check box in 
%  the OPTIONS check-box panel.
% 
%  The resultant change to other panels may, or may not, depend upon the current active check-box in
%  the OPTIONS check-box panel.
% 
%  These changes do not depend up the current value of PM2, PM3, CH1, CH2, CH3, or CH6.
%  
%--------------------------------------------------------------------------
   function bg2_SelectionChangeFcn(hObject, ~)
   %
   % NB: PM2 and PM3 have no handle value to be extracted here and are therefore excluded.
   %     Value for CB1 to CB3 and CB6 are not required or used, and are therefore excluded.
   %
       
      pm1 = get(handles.pm1, 'Value');
      
      set (handles.tb1,      'BackgroundColor', [1    , 0    , 0]);           % Red
      set (handles.tb1,      'String', 'Enter data...');
      set (handles.tb1,      'Value', 0);
      
      initialise_output(handles) ;      

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)
      
   end



%% --------------------------------------- RADIO-BUTTON Callbacks ------------------------------------------------------

%--------------------------------------------------------------------------
   function rb1_Callback(hObject, ~)                                       %#ok<INUSD>
      
   end

%--------------------------------------------------------------------------
   function rb2_Callback(hObject, ~)                                       %#ok<INUSD>

   end

%--------------------------------------------------------------------------
   function rb3_Callback(hObject, ~)                                       %#ok<INUSD>

   end

%--------------------------------------------------------------------------
   function rb4_Callback(hObject, ~)                                       %#ok<INUSD>

   end

%--------------------------------------------------------------------------
   function rb5_Callback(hObject, ~)                                       %#ok<INUSD>

   end

%--------------------------------------------------------------------------
%
%  Not currently used, but set up to be available, for any future extensions.
%
%    function rb6_Callback(hObject, ~)                                       %#ok<INUSD>
% 
%    end

%--------------------------------------------------------------------------
   function HelpButton_Callback(hObject, ~)                                %#ok<INUSD>
       HelpPath = which('xeci_main.html');
       web(HelpPath); 
   end


 
%% --------------------------------------- CHECK-BOXES Callbacks -------------------------------------------------------

%--------------------------------------------------------------------------
   function cb1_Callback(hObject, ~)

      pm1 = get(handles.pm1, 'Value');
      
      initialise_output(handles) ;
      
      % Set TB1 to appropriate colour setting, if EB1 is empty or contains data
      tmp = get(handles.eb1_1, 'UserData') ;     
      if isempty(tmp)
         set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
         set (handles.tb1, 'String', 'Enter data...');
         set (handles.tb1, 'Value', 0);
      else
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value',            0);
      end ;

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)
   end

%--------------------------------------------------------------------------
   function cb2_Callback(hObject, ~)

      pm1 = get(handles.pm1, 'Value');
      
      initialise_output(handles) ;
      
      % Set TB1 to appropriate colour setting, if EB1 is empty or contains data
      tmp = get(handles.eb1_1, 'UserData') ;     
      if isempty(tmp)
         set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
         set (handles.tb1, 'String', 'Enter data...');
         set (handles.tb1, 'Value', 0);
      else
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value',            0);
      end ;

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)
      
    end

%--------------------------------------------------------------------------
   function cb3_Callback(hObject, ~)

      pm1 = get(handles.pm1, 'Value');
      
      initialise_output(handles) ;
      
      set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
      set (handles.tb1, 'String', 'Calculate...');
      set (handles.tb1, 'Value',            0);

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)
      
    end

%--------------------------------------------------------------------------
   function cb4_Callback(hObject, ~)

      pm1 = get(handles.pm1, 'Value');
      
      initialise_output(handles) ;

      set (handles.pm2, 'BackgroundColor', [1    , 1    , 1]);
      set (handles.pm2, 'Value',            1 );

      set (handles.pm3, 'BackgroundColor', [1    , 1    , 1]);
      set (handles.pm3, 'Value',            1 );

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)
      
    end

%--------------------------------------------------------------------------
   function cb5_Callback(hObject, ~)

      pm1 = get(handles.pm1, 'Value');
      
      initialise_output(handles) ;

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)

   end

%--------------------------------------------------------------------------
   function cb6_Callback(hObject, ~)
      
      pm1 = get(handles.pm1, 'Value');
      
      initialise_output(handles) ;

      handles = setup_panel_layout(handles, pm1) ;
      
      set_tooltips(handles);
      guidata(hObject, handles)

   end

%--------------------------------------------------------------------------
   function cb7_Callback(hObject, ~)
   % No specific actions are required here, beyond signifying if CB7 is ticked or not ticked 
   % and this callback makes no changes to any of the specifications in PM1, RB1, RB2, or
   % CB1 to CB6.
   %
      
      set_tooltips(handles);
      guidata(hObject, handles)
      
    end



 %% -------------------------------------- EDIT BOX Callbacks -----------------------------------------------------------
 
 %--------------------------------------------------------------------------
   function eb1_1_Callback(hObject, ~)
      eb01 = str2double(get(hObject, 'String'));
      set (handles.eb1_1, 'UserData', eb01);
      guidata(hObject, handles)
   end

%--------------------------------------------------------------------------
   function eb1_1_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
   end

%--------------------------------------------------------------------------
   function eb1_1_KeyPressFcn(hObject, eventdata)
      s01 = get(hObject, 'TooltipString');
      
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s01, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only',' Key Press Error ');
      end
   end

%--------------------------------------------------------------------------
   function eb1_2_Callback(hObject, ~)
      eb02 = str2double(get(hObject, 'String'));
      set (handles.eb1_2, 'UserData', eb02);
      guidata(hObject, handles)
   end

%--------------------------------------------------------------------------
   function eb1_2_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
   end

%--------------------------------------------------------------------------
   function eb1_2_KeyPressFcn(hObject, eventdata)
      s02 = get(hObject, 'TooltipString');
      k02 = horzcat(s02, eventdata.Key);
      pm1 = get(handles.pm1, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (pm1 == 8 && str2double(k02) >= 50)
         gcfPosition = get(gcf, 'Position');
         set (gcf, 'Position', [gcfPosition(1:2) 940 605]);              % Makes right-hand panel visible         
      elseif (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s02, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
%          gcfPosition = get(gcf, 'Position');
%          set (gcf, 'Position', [gcfPosition(1:2) 705 605]);              % Makes right-hand panel not visible     
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
   end

%--------------------------------------------------------------------------
   function eb1_3_Callback(hObject, ~)
      eb03 = str2double(get(hObject, 'String'));
      set (handles.eb1_3, 'UserData', eb03);
      guidata(hObject, handles)
   end

%--------------------------------------------------------------------------
   function eb1_3_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
   end

%--------------------------------------------------------------------------
   function eb1_3_KeyPressFcn(hObject, eventdata)
      s03 = get(hObject, 'TooltipString');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s03, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb1_4_Callback(hObject, ~)
      eb04 = str2double(get(hObject, 'String'));
      set (handles.eb1_4, 'UserData', eb04);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb1_4_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb1_4_KeyPressFcn(hObject, eventdata)
      s04 = get(hObject, 'TooltipString');
      k04 = horzcat(s04, eventdata.Key);
      pm1 = get(handles.pm1, 'Value');
      rb1 = get(handles.rb1, 'Value');
      rb2 = get(handles.rb2, 'Value');
      rb3 = get(handles.rb3, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if ((pm1 == 3 && rb1 == 1) && str2double(k04) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif (pm1 == 4 && str2double(k04) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...'); 
         set (handles.pm1, 'UserData', 1);
      elseif ((pm1 == 6 && (rb2 == 1 || rb3 ==1)) && str2double(k04) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...'); 
         set (handles.pm1, 'UserData', 1);
      elseif ((pm1 == 7 && rb3 ==1) && str2double(k04) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...'); 
         set (handles.pm1, 'UserData', 1);
      elseif (pm1 == 9 && str2double(k04) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...'); 
         set (handles.pm1, 'UserData', 1);
      elseif (keyNotOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);          % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s04, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb1_5_Callback(hObject, ~)
      eb05 = str2double(get(hObject, 'String'));
      set (handles.eb1_5, 'UserData', eb05);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb1_5_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb1_5_KeyPressFcn(hObject, eventdata)
      s05 = get(hObject, 'TooltipString');
      k05 = horzcat(s05, eventdata.Key);
      pm1 = get(handles.pm1, 'Value');
      rb2 = get(handles.rb2, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (pm1 == 2 && str2double(k05) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif ((pm1 == 3 && rb2 == 1) && str2double(k05) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif (pm1 == 4 && str2double(k05) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif (keyNotOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);          % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s05, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb1_6_Callback(hObject, ~)
      eb06 = str2double(get(hObject, 'String'));
      set (handles.eb1_6, 'UserData', eb06);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb1_6_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb1_6_KeyPressFcn(hObject, eventdata)
      s06 = get(hObject, 'TooltipString');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s06, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb1_7_Callback(hObject, ~)
      eb07 = str2double(get(hObject, 'String'));
      set (handles.eb1_7, 'UserData', eb07);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb1_7_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb1_7_KeyPressFcn(hObject, eventdata)
      s07 = get(hObject, 'TooltipString');
      k07 = horzcat(s07, eventdata.Key);
      pm1 = get(handles.pm1, 'Value');
      rb3 = get(handles.rb3, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if ((pm1 == 6 && rb3 == 0) && str2double(k07) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif ((pm1 == 7 && rb3 == 0) && str2double(k07) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif (pm1 == 10 && str2double(k07) >= 50) || (keyOK == 2)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.pm1, 'UserData', 1);
      elseif (keyNotOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s07, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb1_8_Callback(hObject, ~)
      eb08 = str2double(get(hObject, 'String'));
      set (handles.eb1_8, 'UserData', eb08);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb1_8_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb1_8_KeyPressFcn(hObject, eventdata)
      s08 = get(hObject, 'TooltipString');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s08, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only',' Key Press Error ');
      end
    end
 
%--------------------------------------------------------------------------
   function eb1_9_Callback(hObject, ~)
      eb09 = str2double(get(hObject, 'String'));
      set (handles.eb1_9, 'UserData', eb09);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb1_9_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb1_9_KeyPressFcn(hObject, eventdata)
      s09 = get(hObject, 'TooltipString');
      k09 = horzcat(s09, eventdata.Key);
      pm1 = get(handles.pm1, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (pm1 == 5 && str2double(k09) >= 50) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (keyNotOK == 1)
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value',            0);
      elseif (keyOK == 1)
         set (hObject,     'TooltipString',  horzcat(s09, eventdata.Key) );
         if ~isempty(get(handles.pm1, 'UserData'))
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb2_1_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb2_2_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb2_3_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb2_4_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb2_5_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb2_6_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb2_7_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end

    end

%--------------------------------------------------------------------------
   function eb3_01a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_01b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_02a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_02b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_03a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_03b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_04a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_04b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_05a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_05b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_06a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_06b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_07a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_07b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_08a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_08b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_09a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_09b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_10a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_10b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_11a_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb3_11b_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_1_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_2_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_3_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_4_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_5_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_6_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_7_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb4_8_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb5_1_Callback(hObject, ~)
      eb51 = str2num(get(hObject, 'String'));                               %#ok<ST2NM>
      db1 = get(handles.eb1_1, 'UserData');
      if isnumeric(eb51) ~= 1
          set (hObject, 'String', 0);
          errordlg('Input must be numeric only','Error');
      end
      if max(size(eb51)) ~= db1
          errordlg('Incorrect number of cell means entered','Error');
      end
      tb1 = get(handles.tb1, 'Value');
      if tb1 == 1
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value', 0);
      end
      set (handles.eb5_1, 'UserData', eb51);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb5_1_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end

    end

%--------------------------------------------------------------------------
   function eb5_1_KeyPressFcn(hObject, eventdata)                          %#ok<INUSL>
      pm1 = get(handles.pm1, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (pm1 == 8) && (keyOK == 1)

         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb5_2_Callback(hObject, ~)
      eb52 = str2num(get(hObject, 'String'));                               %#ok<ST2NM>
      if isnumeric(eb52) ~= 1
          set (hObject, 'String', 0);
          errordlg('Input must be numeric only','Error');
      end
      db1 = get(handles.eb1_1, 'UserData');               % No. of cell means
      rb1 = get(handles.rb1,  'Value');
      rb2 = get(handles.rb2,  'Value');
      rb3 = get(handles.rb3,  'Value');
      rc = size(eb52);
      if rb1 == 1
         if max(rc) ~= db1
            errordlg('Incorrect number of cell variances entered','Error');
         end
      elseif rb2 == 1 || rb3 == 1
         if rc(1) ~= db1 && rc(2) ~= db1
            errordlg('Incorrect number of rows/columns entered in cell covariance matrix','Error');
         end
      end
      tb1 = get(handles.tb1, 'Value');
      if tb1 == 1
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value', 0);
      end
      set (handles.eb5_2, 'UserData', eb52);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb5_2_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb5_2_KeyPressFcn(hObject, eventdata)                          %#ok<INUSL>
      pm1 = get(handles.pm1, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (pm1 == 8) && (keyOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb5_3_Callback(hObject, ~)
      eb53 = str2num(get(hObject, 'String'));                               %#ok<ST2NM>
      if isnumeric(eb53) ~= 1
          set (hObject, 'String', 0);
          errordlg('Input must be numeric only','Error');
      end
      tb1 = get(handles.tb1, 'Value');
      if tb1 == 1
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value', 0);
      end
      set (handles.eb5_3, 'UserData', eb53);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb5_3_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb5_3_KeyPressFcn(hObject, eventdata)                          %#ok<INUSL>
      pm1 = get(handles.pm1, 'Value');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1) || (keyOK == 2)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (pm1 == 8) && (keyOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end

%--------------------------------------------------------------------------
   function eb5_4_Callback(hObject, ~)
      eb54 = str2num(get(hObject, 'String'));                               %#ok<ST2NM>
      if isnumeric(eb54) ~= 1
         set (hObject, 'String', 0);
         errordlg('Input must be numeric only','Error');
      end
      rc = size(eb54);
      db1 = get(handles.eb1_1, 'UserData');
      if prod(rc,1) ~= db1                                                  %#ok<PSIZE>
         errordlg('Incorrect number of contrast weights entered','Error');
      end
      if sum(sum(eb54)) ~= 0
         errordlg('Contrast weights do not sum to zero','Error');
      end
      tb1 = get(handles.tb1, 'Value');
      if tb1 == 1
         set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
         set (handles.tb1, 'String', 'Calculate...');
         set (handles.tb1, 'Value', 0);
      end
      set (handles.eb5_4, 'UserData', eb54);
      guidata(hObject, handles)
    end

%--------------------------------------------------------------------------
   function eb5_4_CreateFcn(hObject, ~)
      if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
          set (hObject,'BackgroundColor','white');
      end
    end

%--------------------------------------------------------------------------
   function eb5_4_KeyPressFcn(hObject, eventdata)                          %#ok<INUSL>
      pm1 =  get(handles.pm1,  'Value');
      eb02 = get(handles.eb1_2, 'UserData');
      [keyOK, keyNotOK] = KeyPressCompare( eventdata.Key, eventdata.Modifier );
      if (keyNotOK == 1)
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.tb1, 'Value',            0);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      elseif (pm1 == 8 && keyOK >= 1)
         if eb02 >= 50
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
            set (handles.pm1, 'UserData', 1);
         end
         if get(handles.pm1, 'UserData') == 1
            set (handles.tb1, 'BackgroundColor', [1    , 1    , 0]);           % Yellow
            set (handles.tb1, 'String', 'Calculate...');
         end
      else
         errordlg('Input must be a numerical value only','KeyPress Error');
      end
    end


%% ------------------------------------ CALCULATE Button Callback Starts --------------(End line is 6136)---------------
%  This fucntion takes the data inputted by users in Panel 1 (and possibly Panel 5) and undertakes the appropriate
%  analysis based on the chosen pull-down menu selection.
%
%  The result are fedd back as output in Panels 2, 3, and 4 by this function also.
%
%  For the DISPLAYXECI function used in each individual callback after calculations, the 
%  following are the input arguments:
%  
%       ciSize = width of confidence interval (> 0 and < 100)
%
%       esPanel = row indicator numbers for point estimates in Panel 2
%       ciPanel = row indicator numbers for interval estimates in Panel 3
%       tsPanel = row indicator numbers for statistical results in Panel 4
%
%       tsNumbers = indicator of static and text boxes for Panel 4
%
%       tsProb1 = [q X 1] vector indicating row number of any P value in TSXECI
%       tsProb2 = [q X 1] vector indicating the text box number in HEB_EB4
%
%       tsInteger = [r X 1] vector indicating row in tsXECI of any integer
%
%       esXECI = (k X 1) vector of point estimates of effect sizes
%       ciXECI = (m X 2) matrix of interval estimates of effect sizes
%       tsXECI = (p X 1) vector of associated test statistic values 
%
%-----------------------------------------------------------------------------------------------------------------------
   function tb1_Callback(hObject, ~)
        
      tb1  = get(hObject,       'Value');
      
      pm1  = get(handles.pm1,   'Value');  
      pm2  = get(handles.pm2,   'Value');
      pm3  = get(handles.pm3,   'Value');
      
      rb1  = get(handles.rb1,   'Value');  
      rb2  = get(handles.rb2,   'Value'); 
      rb3  = get(handles.rb3,   'Value'); 
      rb4  = get(handles.rb4,   'Value'); 
      rb5  = get(handles.rb5,   'Value'); 
      
      cb1  = get(handles.cb1,   'Value');  
      cb2  = get(handles.cb2,   'Value'); 
      cb3  = get(handles.cb3,   'Value'); 
      cb4  = get(handles.cb4,   'Value');  
      cb5  = get(handles.cb5,   'Value'); 
      cb6  = get(handles.cb6,   'Value'); 
      cb7  = get(handles.cb7,   'Value'); 
      
      db1  = get(handles.eb1_1, 'UserData');
      db2  = get(handles.eb1_2, 'UserData'); 
      db3  = get(handles.eb1_3, 'UserData'); 
      db4  = get(handles.eb1_4, 'UserData'); 
      db5  = get(handles.eb1_5, 'UserData'); 
      db6  = get(handles.eb1_6, 'UserData'); 
      db7  = get(handles.eb1_7, 'UserData'); 
      db8  = get(handles.eb1_8, 'UserData'); 
      db9  = get(handles.eb1_9, 'UserData'); 
      db51 = get(handles.eb5_1, 'UserData');
      db52 = get(handles.eb5_2, 'UserData');
      db53 = get(handles.eb5_3, 'UserData');
      db54 = get(handles.eb5_4, 'UserData');
      
      set (handles.hd3,         'Visible', 'on');
      
      set (handles.st_l,        'Visible', 'on');
      set (handles.st_u,        'Visible', 'on');
      
      if tb1 == 1
         set (hObject, 'BackgroundColor',[0    , 1    , 0]);       % Green
         set (hObject, 'String','Completed');
         set (hObject, 'TooltipString',  sprintf(' Press this green toggle button to perform another calculation \n (it will turn back to "red" and say "Calculate...")') );
         
      elseif tb1 ~= 1
         set (hObject, 'BackgroundColor',[1    , 1    , 0]);           % Yellow
         set (hObject, 'String','Calculate...') ;
         set (hObject, 'TooltipString',  sprintf(' Press this yellow toggle button to get output \n (it will change colour to "green" and say "Completed")') ) ;
      end
      
      displayOut = 0;
      nDecs = 4 ;
      

      % 2 x 2 Contingency Table Statistics -------------------------------
      if (pm1 == 2) && (tb1 == 1)
         
         ciSize = db5;
         
         if (cb1 == 1)           % Entered cell values are inverted
            cellA = db2;
            cellB = db1;
            cellC = db4;
            cellD = db3;
         elseif (cb1 == 0)       % Entered cell values as are
            cellA = db1;
            cellB = db2;
            cellC = db3;
            cellD = db4;
         end
         
         if (rb1 == 1)           % Odds Ratio
            iType = 1;
            esPanel   = [1 2 3];
            ciPanel   = [1 2 3 4 5 6 7];
            tsPanel   = [1 2 3 4 5 6 7 8];
            tsNumbers = [1 2 3 4 5 6 7 8];
            
            tsProb1   = [2 4 5 6 7 8];
            tsProb2   = [2 4 5 6 7 8];
            tsInteger = [];
         end
         
         if (rb2 == 1)           % Relative Risk
            iType = 2;
            esPanel   = [1 2];
            ciPanel   = [1 2];
            tsPanel   = [1 2 3 4 5 6 7 8];
            tsNumbers = [1 2 3 4 5 6 7 8];
            
            tsProb1   = [2 4 5 6 7 8];
            tsProb2   = [2 4 5 6 7 8];
            tsInteger = [];
         end
         
         if (rb3 == 1)           %  Inter-rater reliability
            iType = 3;
            esPanel   = [1 2 3 4];
            ciPanel   = [1 2 3 4 5];
            tsPanel   = [1 2 3];
            tsNumbers = [1 2 3];
            
            tsProb1   = [1 2];
            tsProb2   = [1 2] ;
            tsInteger = [];
         end
         
         [es, esci, ts] = xeci_xtab(cellA, cellB, cellC, cellD, ciSize, iType, displayOut, nDecs);
         
         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end
      end



      % Pearson Correlations ---------------------------------------------
      if (pm1 == 3) && (tb1 == 1)
         
         sampleR = db1;
         nSize = db2;

         if (rb1 == 1)           % Pearson Correlation
            nPartialR = 0;
            nullRho = db3;
            ciSize = db4;

            esPanel   = [1 2];
            ciPanel   = [1 2 3 4];
            tsPanel   = [1 2 3 4];
            tsNumbers = [1 2 3 4];

            tsProb1   = [3 4];
            tsProb2   = [3 4];
            tsInteger = (2);
         end

         if (rb2 == 1)           % Partial Correlation
            nullRho = db3;
            nPartialR = db4;
            ciSize = db5;

            esPanel   = [1 2];
            ciPanel   = [1 2 3 4];
            tsPanel   = [1 2 3 4];
            tsNumbers = [1 2 3 4];

            tsProb1   = [3 4];
            tsProb2   = [3 4];
            tsInteger = 2;
         end

         [es, esci, ts, ~] = xeci_corr(sampleR, nSize, nPartialR, nullRho, ciSize, displayOut, nDecs);

         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end

      end



      % R-squared Statistics ---------------------------------------------
      if (pm1 == 4) && (tb1 == 1)
         
         nVars = db2;
         nSize = db3;
         nullRho_sq = db4;
         ciSize = db5;

         if (rb1 == 1)           % Type 1: Observed R squared

            sampleR_sq = db1;
            iType = 1;

            [es, esci, ts] = xeci_r2(sampleR_sq, nVars, nSize, nullRho_sq, ciSize, iType, displayOut, nDecs);

            esPanel   = [1 2 3 4];
            ciPanel   = [1 2 3 4 5 6 7];
            tsPanel   = [1 2 3 4 5 6 7 8];
            tsNumbers = [1 2 3 4 5 6 7 8];

            tsProb1   = [4 8];
            tsProb2   = [4 8];
            tsInteger = [2 3 7];

         end

         if (rb2 == 1)           % Type 2: Observed F value

            observedF = db1;
            iType = 2;

            [es, esci, ts] = xeci_r2(observedF, nVars, nSize, nullRho_sq, ciSize, iType, displayOut, nDecs);

            esPanel   = [1 2 3 4];
            ciPanel   = [1 2 3 4 5 6 7];
            tsPanel   = [1 2 3 4 5 6 7 8];
            tsNumbers = [1 2 3 4 5 6 7 8];

            tsProb1   = [4 8];
            tsProb2   = [4 8];
            tsInteger = [2 3 7];

         end

         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end

      end 



      % Linear Regression ------------------------------------------------
      if (pm1 == 5) && (tb1 == 1)
         
         regCoeff = db1;
         
         sampleRsq = db2;
         toleranceIV = db3;
         nSize  = db4;
         nIVars = db5;
         sdYvar = db6;
         sdXvar = db7;
         corrYX = db8;
         ciSize = db9;

         if (rb1 == 1)           % B coefficient & SE as input (TYPE1 = 1 & TYPE2 = 1
            iType1 = 1;
            iType2 = 2;

         elseif (rb2 == 1)       % B coefficient & Tolerance as input (TYPE1 = 1 & TYPE2 = 2
            iType1 = 1;
            iType2 = 1;

         elseif (rb3 == 1)       % Semipartial correlation & SE as input (TYPE1 = 2 & TYPE2 = 2
            iType1 = 2;
            iType2 = 2;

         end

         [es, esci, ts] = xeci_reg(regCoeff, sampleRsq, toleranceIV, nSize, nIVars, ...
                                  sdYvar, sdXvar, corrYX, iType1, iType2, ciSize, displayOut, nDecs);

         esPanel   = [1 2 3 4];
         ciPanel   = [1 2 3 4 7 12 15 20 23 28];
         tsPanel   = [1 2 3 4 5];
         tsNumbers = [1 2 3 4 5];

         tsProb1   = (4);
         tsProb2   = (4);
         tsInteger = (3);


         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end

      end



      % Two Independent Groups -------------------------------------------
      if (pm1 == 6) && (tb1 == 1)
         if (rb1 == 1)           % Type A

            meanGrp1 = db1;
            meanGrp2 = db2;
            sdGrp1 = db3;
            sdGrp2 = db4;
            nSizeGrp1 = db5;
            nSizeGrp2 = db6;
            ciSize = db7;

            [es, esci, ts, ~] = xeci_ind2g(meanGrp1, meanGrp2, sdGrp1, sdGrp2, nSizeGrp1, nSizeGrp2, ciSize, displayOut, nDecs);

            esPanel   = [1 2 3 4 5 6];
            ciPanel   = [1 2 3 4 5 6 7 8 9 10];
            tsPanel   = [1 2 3 5 6 7 8 9];
            tsNumbers = [1 2 3 4 5 6 7 8];

            tsProb1   = [3 7];
            tsProb2   = [3 6];
            tsInteger = (2);

         elseif (rb2 == 1)       % Type B

            tValue = db1;
            nSizeGrp1 = db2;
            nSizeGrp2 = db3;
            ciSize = db4;

            [es, esci, ts, ~] = xeci_ind2g(tValue, nSizeGrp1, nSizeGrp2, ciSize, displayOut, nDecs);

            esPanel   = [2 3];
            ciPanel   = [2 3 7 9];
            tsPanel   = [1 2 4];
            tsNumbers = [1 2 4];

            tsProb1   = (3);
            tsProb2   = (3);
            tsInteger = (2);

         end

         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end

      end



      %  Two Dependent Groups --------------------------------------------
      if (pm1 == 7) && (tb1 == 1)
         if (rb1 == 1)           % Type 1

            meanGrp1 = db1;
            meanGrp2 = db2;
            sdGrp1 = db3;
            sdGrp2 = db4;
            sampleR = db5;
            nSize = db6;
            ciSize = db7;
            iType = 1;

            [es, esci, ts, ~] = xeci_dep2g(meanGrp1, meanGrp2, sdGrp1, sdGrp2, sampleR, nSize, ciSize, iType, displayOut, nDecs) ;

            if (rb4 == 1)                    % Group Difference
               esPanel   = [1 4 5 6 7];
               ciPanel   = [1 5 6 7 8 9 10];
               tsPanel   = [1 2 3 4 7];
               tsNumbers = [1 2 3 4 5];

            elseif (rb5 == 1)                % Individual Change
               esPanel   = [1 2 3];
               ciPanel   = [1 2 3 4 10];
               tsPanel   = [1 2 4 5 6 7];
               tsNumbers = [1 2 3 4 5 6];
            end

            tsProb1   = (3);
            tsProb2   = (3);
            tsInteger = (2);

         end

         if (rb2 == 1)          % Type 2

            meanGrp1 = db1;
            meanGrp2 = db2;
            sdGrp1 = db3;
            sdGrp2 = db4;
            tValue = db5;
            nSize = db6;
            ciSize = db7;
            iType = 2;

            [es, esci, ts, ~] = xeci_dep2g(meanGrp1, meanGrp2, sdGrp1, sdGrp2, tValue, nSize, ciSize, iType, displayOut, nDecs);

            if (rb4 == 1)                    % Group Difference
               esPanel   = [1 4 5 6 7];
               ciPanel   = [1 5 6 7 8 9 10];
               tsPanel   = [1 2 3 4 7];
               tsNumbers = [1 2 3 4 5];

            elseif (rb5 == 1)                % Individual Change
               esPanel   = [1 2 3];
               ciPanel   = [1 2 3 4 10];
               tsPanel   = [1 2 4 5 6 7];
               tsNumbers = [1 2 3 4 5 6];
            end

            tsProb1   = (3);
            tsProb2   = (3);
            tsInteger = (2);

         end

         if (rb3 == 1)          % Type 3

            tValue = db1;
            sampleR = db2;
            nSize = db3;
            ciSize = db4;
            iType = 3;

            [es, esci, ts, ~] = xeci_dep2g(tValue, sampleR, nSize, ciSize, iType, displayOut, nDecs);

            if (rb4 == 1)                    % Group Difference
               esPanel   = (6);
               ciPanel   = [7 8 10];
               tsPanel   = [1 2 3 4];
               tsNumbers = [1 2 3 4];

            elseif (rb5 == 1)                % Individual Change
               esPanel   = [2 3];
               ciPanel   = [2 3 4 10];
               tsPanel   = [1 2 3 4 6] ;
               tsNumbers = [1 2 3 4 5] ;
            end

            tsProb1   = (3);
            tsProb2   = (3);
            tsInteger = (2);

          end


         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end

      end 



      % Linear mean contrasts --------------------------------------------
      if (pm1 == 8) && (tb1 == 1)
         
         sampleMeans = db51;
         sampleVars = db52;
         nSize = db53;
         contrastCoef = db54;
         ciSize = db2;
         
         sampleCorr = 1;
         userMSE = [];
         userDF = [];
         
         pm2 = pm2 - 1;
         pm3 = pm3 - 1;
         
         % Order of design > 0
         if cb4 == 1;                        
            
            % Mixed design
            if (rb3 == 1)
               nOrder = [pm2; pm3];
               
            else
               nOrder = pm2;
            end
            
            % userMSE & userDF
            if cb5 == 1 && cb6 == 1
               userMSE = db4;
               userDF  = db5;

            % userMSE only
            elseif cb5 == 1 && cb6 == 0         
               userMSE = db4;

            % userDF only
            elseif cb5 == 0 && cb6 == 1
               userDF  = db4;
            end
            
         % Order of design = 0   
         else
            
            if (rb3 == 1)
               nOrder = [0; 0];
               
            else
               nOrder = 0;
            end
            
            % bOTH userMSE & userDF
            if cb5 == 1 && cb6 == 1             
               userMSE = db3;
               userDF  = db4;
            
            % userMSE only
            elseif cb5 == 1 && cb6 == 0         
               userMSE = db3;
            
            % userDF only
            elseif cb5 == 0 && cb6 == 1         
               userDF  = db3;
            end
            
         end
         
         % Rescaling of the contrast coefficients (default = 1)
         if cb7 == 1
            reScale = 0;
         else
            reScale = 1;
         end
         
         % Between-subjects design
         if (rb1 == 1)           
            iType = 1;
            [es, esci, ts, ~] = xeci_lincon(sampleMeans, sampleVars, nSize, contrastCoef, ...
                                            ciSize, iType, displayOut, nDecs, nOrder, ...
                                            sampleCorr, userMSE, userDF, reScale);
                                         
            esPanel   = [1 2 3];
            ciPanel   = [1 2 3 4 5 6];
            tsPanel   = [1 2 3 4 5 6 7 8];
            tsNumbers = [1 2 3 4 5 6 7 8];
            
            tsProb1   = [3 8];
            tsProb2   = [3 8];
            tsInteger = (2);
         end

         % Within-subjects designs
         if (rb2 == 1)       
            iType = 2;
            [es, esci, ts, ~] = xeci_lincon(sampleMeans, sampleVars, nSize, contrastCoef, ...
                                            ciSize, iType, displayOut, nDecs, nOrder, ...
                                            sampleCorr, userMSE, userDF, reScale);
            esPanel   = [1 2 3 4];
            ciPanel   = [1 2 3 4 5 6];
            tsPanel   = [1 2 3 4 5];
            tsNumbers = [1 2 3 4 5];
            
            tsProb1   = (3);
            tsProb2   = (3);
            tsInteger = (2);
         end

         % Mixed designs
         if (rb3 == 1)   
            
            if rb4 == 1
               iType = 3;
               esPanel   = [1 2 3];
            elseif rb5 == 1
               iType = 4;
               esPanel   = [1 2 3 4];
            end
            
            [es, esci, ts, ~] = xeci_lincon(sampleMeans, sampleVars, nSize, contrastCoef, ...
                                            ciSize, iType, displayOut, nDecs, nOrder, ...
                                            sampleCorr, userMSE, userDF, reScale);
            ciPanel   = [1 2 3 4 5 6];
            tsPanel   = [1 2 3 4 5];
            tsNumbers = [1 2 3 4 5];
            tsProb1   = (3);
            tsProb2   = (3);
            tsInteger = (2);
         end

         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end   
      end 



      % Binomial Proportions ---------------------------------------------
      if (pm1 == 9) && (tb1 == 1)
          
         sampleP = db1;
         nTrials = db2;
         nullPi = db3;
         ciSize = db4;
         
         if (rb1 == 1)                 % Sample proportion
            iType = 1;
         elseif (rb2 == 1)             % No of successes
            iType = 2;
         end
         
         if (cb1 == 1)
            contCorr = 1 ;
         else
            contCorr = 0 ;
         end ;
         
         esPanel   = [1 2 3];
         ciPanel   = [1 2 3 4 5 6 7];
         
         if cb2 == 1
            tsPanel   = [1 2 3 4 8 9 7];
            tsNumbers = [1 2 3 4 5 6 7];
            tsProb1   = [1 2 3 8 9];
            tsProb2   = [1 2 3 4 6];
         else
            tsPanel   = [1 2 3 4 5 6 7];
            tsNumbers = [1 2 3 4 5 6 7];
            tsProb1   = [1 2 3 4 6];
            tsProb2   = [1 2 3 4 6];
         end ;
         
         
         tsInteger = (7);
         
         [es, esci, ts, ~] = xeci_binom(sampleP, nTrials, nullPi, ciSize, iType, contCorr, displayOut, nDecs);
         
         % Invert label for 2-sided exact result if opposite extreme is on right
         if ts(7) > es(4)
            set_loops( handles.hst_pg4(1:7,1),    'String', handles.pm09.pg4_labels([2 3 4 5 6 7 8],:) );
            guidata(hObject, handles)
         end ;
         
         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end      
      end 


      % SEM Fit Statistics -----------------------------------------------
      if (tb1 == 1) && (pm1 == 10)
          
         if (rb1 == 1)
            iType1 = 1;                % Chi-sq value
         elseif (rb2 == 1)
            iType1 = 0;                % Discrepancy function value 
         end
         if (cb1 == 1)
            mlECVI = 1;                % ML ECVI = Yes
         else
            mlECVI = 0;
         end
         if (cb2 == 1)
            iType2 = 1;                % No. model parameters   
         else
            iType2 = 0;                % No. observed variables
         end
         if (cb3 == 1)
            meanModel = 1;             % Mean structure model = Yes
         else
            meanModel = 0;
         end
         
         chiSq = db1;
         dfValue = db2;
         nSize = db3;
         nGroups = db4;
         nullRMSEA = db5;
         nVorP = db6;
         ciSize = db7;
         [es, esci, ts ] = xeci_sem(chiSq, dfValue, nSize, nGroups, ciSize, ...
                                  nullRMSEA, nVorP, displayOut, ...
                                  meanModel, mlECVI, iType1, iType2);
         if (cb1 == 1)
            esPanel   = [1 2 3 4 5 6 7];
            ciPanel   = [1 2 3 4 5 6 7 8 9];
         elseif (cb1 == 0)
            esPanel   = [1 2 3 4 5 6];
            ciPanel   = [1 2 3 4 5 6 8];
         end
         
         if (cb2 == 1)
            tsPanel   = [1 2 4 5 9];
            tsNumbers = [1 2 4 5 6];
         elseif (cb2 == 0)
            tsPanel   = [1 2 4 5 10];
            tsNumbers = [1 2 4 5 6];
         end
         
         tsProb1   = [3 4 5];
         tsProb2   = [3 4 5];
         tsInteger = [2 6];
         
         if ~isempty(es)
            DisplayXECI(ciSize, esPanel, ciPanel, tsPanel, tsNumbers, tsProb1, tsProb2, tsInteger, es, esci, ts, handles);
         else
            set (handles.tb1, 'BackgroundColor', [1    , 0    , 0]);           % Red
            set (handles.tb1, 'String', 'Enter Data...');
            set (handles.tb1, 'Value',            0);
         end      
      end 
      
      % Display confidence interval size in main window
      if (tb1 ~= 0)
         
         if (mod(ciSize, 1) == 0)
             str = [' ' num2str(ciSize,'%2.0f') ...
                 '% Confidence Interval'] ;
         else
             str = [' ' num2str(ciSize,'%3.1f') ...
                '% Confidence Interval'] ;
         end
         
         set (handles.hd3,         'Visible', 'on');
         set (handles.hd3,         'String',  str); 
         
      end ;

      % When togglepress = OFF, all output text boxes are cleared ---------
      if (tb1 == 0)                                
         set (handles.heb_pg2, 'String', '' );
         set (handles.heb_pg3, 'String', '' );
         set (handles.heb_pg4, 'String', '' );
      end

   end

 
% ------------------------------------ CALCULATE Button Callback Ends --------------(Start line is 5476)----------------

%-----------------------------------------------------------------------------------------------------------------------
   function tb1_CreateFcn(hObject, ~)                                      %#ok<INUSD>

   end

%% ------------------------------------ RESET Button Callback ----------------------------------------------------------
%
%-----------------------------------------------------------------------------------------------------------------------
   function pb1_Callback(hObject, ~)
       
      gcfPosition = get(gcf, 'Position');

      set (gcf, 'Position', [gcfPosition(1:2) 705 605]);                           

      set (handles.hst_pg1,  'String', '' );
      set (handles.hst_pg2,  'String', '' );
      set (handles.hst_pg3,  'String', '' );
      set (handles.hst_pg4,  'String', '' );
      set (handles.hst_pg5,  'String', '' );

      set (handles.heb_pg1,  'String', '' );
      set (handles.heb_pg2,  'String', '' );
      set (handles.heb_pg3,  'String', '' );
      set (handles.heb_pg4,  'String', '' );
      set (handles.heb_pg5,  'String', '' );

      set (handles.hst_hds,  'String', '' );

      set (handles.pm1,      'Value', 1 );
      set (handles.pm2,      'Value', 1 );
      set (handles.pm3,      'Value', 1 );

      set (handles.rb1,      'Value', 1 );
      set (handles.rb2,      'Value', 0 );
      set (handles.rb3,      'Value', 0 );
      set (handles.rb4,      'Value', 1 );
      set (handles.rb5,      'Value', 0 );

      set (handles.cb1,      'Value', 0 );
      set (handles.cb2,      'Value', 0 );
      set (handles.cb3,      'Value', 0 );
      set (handles.cb4,      'Value', 0 );
      set (handles.cb5,      'Value', 0 );
      set (handles.cb6,      'Value', 0 );
      set (handles.cb7,      'Value', 0 );

      set (handles.heb_pg1,  'UserData', [] );
      set (handles.heb_pg2,  'UserData', [] );
      set (handles.heb_pg3,  'UserData', [] );
      set (handles.heb_pg4,  'UserData', [] );
      set (handles.heb_pg5,  'UserData', [] );

      set (handles.hst_pg1,  'Visible', 'off');
      set (handles.hst_pg2,  'Visible', 'off');
      set (handles.hst_pg3,  'Visible', 'off');
      set (handles.hst_pg4,  'Visible', 'off');
      set (handles.hst_pg5,  'Visible', 'off');

      set (handles.heb_pg1,  'Visible', 'off');
      set (handles.heb_pg2,  'Visible', 'off');
      set (handles.heb_pg3,  'Visible', 'off');
      set (handles.heb_pg4,  'Visible', 'off');
      set (handles.heb_pg5,  'Visible', 'off');

      set (handles.hst_hds,  'Visible', 'off' );

      set (handles.hrb_bg1,  'Visible', 'off' );
      set (handles.hrb_bg2,  'Visible', 'off' );
      set (handles.hcb_bg2,  'Visible', 'off' );
      set (handles.hcb_bg3,  'Visible', 'off' );

      set (handles.st_l,     'Visible', 'off');
      set (handles.st_u,     'Visible', 'off');   

      set (handles.heb_pg1,  'BackgroundColor', [1    , 1    , 1]);
      set (handles.heb_pg5,  'BackgroundColor', [1    , 1    , 1]);

      set (handles.pm2,      'BackgroundColor', [1    , 1    , 1]);
      set (handles.pm3,      'BackgroundColor', [1    , 1    , 1]);

      set (handles.tb1,      'BackgroundColor', [1    , 0    , 0]);           % Red
      set (handles.tb1,      'String', 'Enter data...');
      
      set (handles.tb1,      'Value', 0);
      set (handles.pm1,      'UserData', []);
         
      guidata(hObject, handles)
      
   end

% ------------------------------------ This is the end of the main XECI function ---------------------------------------

%    clc;
   fig_hdl = handles;
  
end



%% Sets up the appropriate set of static text and edit boxed, plus headings, in GUI interface.

function [handles] = setup_panel_layout(handles, pm1)
%
%  There is no request for a value for CB7 as this callback only affects the input  
%  argument set-up for the XECI_LINCON function when it is called in the TB1_CALLBACK 
%  function within the main XECIm function.
%
      
   % Obtain current values of all radio buttons and check boxes to enable the 
   % static text boxes and edit boxes in all panels to be correctly displayed 
   % based on the chosen form of input and any input options.
   
   rb1 = get(handles.rb1, 'Value');
   rb2 = get(handles.rb2, 'Value');
   rb3 = get(handles.rb3, 'Value');
   rb4 = get(handles.rb4, 'Value');
   rb5 = get(handles.rb5, 'Value');

   cb1 = get(handles.cb1, 'Value');
   cb2 = get(handles.cb2, 'Value');
   cb3 = get(handles.cb3, 'Value');
   cb4 = get(handles.cb4, 'Value');
   cb5 = get(handles.cb5, 'Value');
   cb6 = get(handles.cb6, 'Value');

   
   % Initially make static text boxes and edits boxes invisible before activating
   % change---but do not delete any existing data that may be in the input edit boxes.
   
   initialise_input(handles) ;


   % The appropriate layout is now determined based on the kind of analysis chosen
   % by PM1 and the selection of radio buttons and check boxes for that value of PM1.
   
   
   % For 2 x 2 Contingency Tables...handles.pm1 = 2
   if (pm1 == 2)

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on');
      set (handles.hrb_bg1(1:3,1),                    'Visible', 'on');
      set_loops( handles.hrb_bg1(1:3,1),              'String', handles.pm02.bg1_labels(1:3,:) );


      % Odds Ratio radio button
      if rb1 == 1

         % Analysis Heading
         set (handles.hd1,                            'Visible', 'on')
         set (handles.hd1,                            'String', handles.pm02.hd_labels(1,:) );

         if cb1 == 1
            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm02.hd_labels(4,:) );
         end ;

         % Options Panel
         set (handles.bg2,                            'Visible', 'on')
         set (handles.hcb_bg2(1,1),                   'Visible', 'on');
         set_loops(handles.hcb_bg2(1,1),              'String', handles.pm02.bg2_labels(1,:)   );

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:5,1),           'String', handles.pm02.pg1_labels([1 2 3 4 13],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:3,1),           'String', handles.pm02.pg2_labels([1 2 3],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:14,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:7,1),           'String', handles.pm02.pg3_labels([1 2 3 4 5 6 7],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:8,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:8,1),           'String', handles.pm02.pg4_labels([1 2 3 4 5 6 7 8],:) );

         % Reset title of the Findings for Statistical 
         % Tests panel in case existing title is different
         set (handles.pg4,                            'Visible', 'on');
         set (handles.pg4,                            'Title', 'Findings for Statistical Tests');

      % Relative Risk radio button
      elseif rb2 == 1

         % Analysis Heading
         set (handles.hd1,                            'Visible', 'on')
         set (handles.hd1,                            'String', handles.pm02.hd_labels(2,:) );

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:5,1),           'String', handles.pm02.pg1_labels([5 6 7 8 13],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:2,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:2,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:2,1),           'String', handles.pm02.pg2_labels([4 5],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:2,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg3(1:2,1),           'String', handles.pm02.pg3_labels([8 9],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:8,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:8,1),           'String', handles.pm02.pg4_labels([1 2 3 4 5 6 7 8],:) );

         % Reset title of the Findings for Statistical 
         % Tests panel in case existing title is different
         set (handles.pg4,                            'Visible', 'on');
         set (handles.pg4,                            'Title', 'Findings for Statistical Tests');

      % Inter-rater Agreement radio button
      elseif rb3 == 1

         % Analysis Heading
         set (handles.hd1,                            'Visible', 'on')
         set (handles.hd1,                            'String', handles.pm02.hd_labels(3,:) );

         % Options Panel
         set (handles.bg2,                            'Visible', 'off');
         set (handles.hcb_bg2(1,1),                   'Visible', 'off');

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:5,1),           'String', handles.pm02.pg1_labels([9 10 11 12 13],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:4,1),           'String', handles.pm02.pg2_labels([6 7 8 9],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:10,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:5,1),           'String', handles.pm02.pg3_labels([10 11 12 13 14],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:3,1),           'String', handles.pm02.pg4_labels([9 10 11],:) );

         % Reset title of the Findings for Statistical 
         % Tests panel in case existing title is different
         set (handles.pg4,                            'Visible', 'on');
         set (handles.pg4,                            'Title', 'Agreement Correction Indices');
      end ;
      
   end ;


   % For Pearson & Partial Correlations...handles.pm1 = 3
   if (pm1 == 3)

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:2,1),                    'Visible', 'on');
      set_loops(handles.hrb_bg1(1:2,1),               'String', handles.pm03.bg1_labels(1:2,:) );

      % Zero-Order radio button
      if rb1 == 1

         % Analysis Heading
         set (handles.hd1,                            'Visible', 'on')
         set (handles.hd1,                            'String', handles.pm03.hd_labels(1,:) );

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:4,1),           'String', handles.pm03.pg1_labels([1 2 3 5],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:2,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:2,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:2,1),           'String', handles.pm03.pg2_labels([3 2],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg3(1:4,1),           'String', handles.pm03.pg3_labels([1 2 3 4],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:4,1),           'String', handles.pm03.pg4_labels([1 2 3 4],:) );


      % Partial radio button
      elseif rb2 == 1

         % Analysis Heading
         set (handles.hd1,                            'Visible', 'on')
         set (handles.hd1,                            'String', handles.pm03.hd_labels(2,:) );

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:5,1),           'String', handles.pm03.pg1_labels([1 2 3 4 5],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:2,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:2,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:2,1),           'String', handles.pm03.pg2_labels([3 2],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg3(1:4,1),           'String', handles.pm03.pg3_labels([1 2 3 4],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:4,1),           'String', handles.pm03.pg4_labels([1 2 3 4],:) );
      end ;
      
   end ;


   % For R-squared Statistic...handles.pm1 = 4
   if (pm1 == 4)

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm04.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:2,1),                    'Visible', 'on');
      set_loops(handles.hrb_bg1(1:2,1),               'String', handles.pm04.bg1_labels(1:2,:) );

      % Obs. R-sq button
      if rb1 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:5,1),           'String', handles.pm04.pg1_labels([1 2 3 4 6],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:4,1),           'String', handles.pm04.pg2_labels([1 2 3 4],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:14,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:7,1),           'String', handles.pm04.pg3_labels([1 2 3 4 5 6 7],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:8,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:8,1),           'String', handles.pm04.pg4_labels([1 2 3 4 5 6 7 8],:) );

      % Obs. F value radio button
      elseif rb2 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:5,1),           'String', handles.pm04.pg1_labels([5 2 3 4 6],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:4,1),           'String', handles.pm04.pg2_labels([1 2 3 4],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:14,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:7,1),           'String', handles.pm04.pg3_labels([1 2 3 4 5 6 7],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:8,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:8,1),           'String', handles.pm04.pg4_labels([1 2 3 4 5 6 7 8],:) );
      end ;
      
   end ;


   % For Regression Coefficients...handles.pm1 = 5
   if (pm1 == 5)

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm05.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:2,1),                    'Visible', 'on');
      set_loops( handles.hrb_bg1(1:2,1),              'String', handles.pm05.bg1_labels(1:2,:) );


      % Std.Err. radio button
      if rb1 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:9,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:9,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:9,1),           'String', handles.pm05.pg1_labels([1 2 3 4 5 6 7 8 10],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:5,1),           'String', handles.pm05.pg2_labels([1 2 3 4 5],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:12,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:6,1),           'String', handles.pm05.pg3_labels([1 2 3 4 5 6],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:5,1),           'String', handles.pm05.pg4_labels([1 2 3 4 5],:) );

      % Tolerance radio button
      elseif rb2 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:9,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:9,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:9,1),           'String', handles.pm05.pg1_labels([1 2 9 4 5 6 7 8 10],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:5,1),           'String', handles.pm05.pg2_labels([1 2 3 4 5],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:12,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:6,1),           'String', handles.pm05.pg3_labels([1 2 3 4 5 6],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:5,1),           'String', handles.pm05.pg4_labels([1 2 3 4 5],:) );
      end ;
      
   end ;


   % For two independent groups...handles.pm1 = 6
   if (pm1 == 6)

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm06.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:2,1),                    'Visible', 'on');
      set_loops( handles.hrb_bg1(1:2,1),              'String', handles.pm06.bg1_labels(1:2,:) );


      % Means & SDs radio button
      if rb1 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:7,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:7,1),           'String', handles.pm06.pg1_labels([1 2 3 4 5 6 8],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:6,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:6,1),           'String', handles.pm06.pg2_labels([1 2 3 4 5 6],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:10,1),               'Visible', 'on');
         set ( handles.heb_pg3(1:20,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:10,1),          'String', handles.pm06.pg3_labels([1 2 3 4 5 6 7 8 9 10],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:8,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:8,1),           'String', handles.pm06.pg4_labels([1 2 3 5 6 7 8 9],:) );

      % Obs. t Value radio button
      elseif rb2 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:4,1),           'String', handles.pm06.pg1_labels([7 5 6 8],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:2,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:2,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:2,1),           'String', handles.pm06.pg2_labels([2 3],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg3(1:4,1),           'String', handles.pm06.pg3_labels([2 3 7 9],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:3,1),           'String', handles.pm06.pg4_labels([10 11 12],:) );
      end ;

   end ;


   % For two dependent groups...handles.pm1 = 7
   if (pm1 == 7)

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm07.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:3,1),                    'Visible', 'on');
      set_loops(handles.hrb_bg1(1:3,1),               'String', handles.pm07.bg1_labels(1:3,:) );

      % Options Panel
      set (handles.bg2,                               'Visible', 'on')
      set (handles.hrb_bg2(1:2,1),                    'Visible', 'on');
      set_loops(handles.hrb_bg2(1:2,1),               'String', handles.pm07.bg2_labels(1:2,:) );


      % Means, SDs, & r radio button
      if rb1 == 1
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:7,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:7,1),           'String', handles.pm07.pg1_labels([1 2 3 4 5 6 8],:) );

         % Group diff. radio
         if (rb4 == 1)
            % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:5,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:5,1),        'String', handles.pm07.pg2_labels([1 2 3 4 5],:) );

            % Panel 3 (Interval Estimates)
            set ( handles.hst_pg3(1:7,1),             'Visible', 'on');
            set ( handles.heb_pg3(1:14,1),            'Visible', 'on');
            set_loops( handles.hst_pg3(1:7,1),        'String', handles.pm07.pg3_labels([1 2 3 4 5 6 7],:) );

            % Panel 4 (Findings of Statistics Tests)
            set ( handles.hst_pg4(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg4(1:5,1),             'Visible', 'on');
            set_loops( handles.hst_pg4(1:5,1),        'String', handles.pm07.pg4_labels([1 2 3 4 6],:) );

            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm07.hd_labels(2,:) );

         % Ind. Change radio
         elseif (rb5 == 1)
            % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:3,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:3,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:3,1),        'String', handles.pm07.pg2_labels([1 6 7],:) );

            % Panel 3 (Interval Estimates)
            set ( handles.hst_pg3(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg3(1:10,1),            'Visible', 'on');
            set_loops( handles.hst_pg3(1:5,1),        'String', handles.pm07.pg3_labels([1 8 9 6 7],:) );

            % Panel 4 (Findings of Statistics Tests)
            set ( handles.hst_pg4(1:6,1),             'Visible', 'on');
            set ( handles.heb_pg4(1:6,1),             'Visible', 'on');
            set_loops( handles.hst_pg4(1:6,1),        'String', handles.pm07.pg4_labels([1 2 3 4 5 6],:) );

            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm07.hd_labels(3,:) );

         end ;

      % Means, SDs, & t radio button
      elseif rb2 == 1
         
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:7,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:7,1),           'String', handles.pm07.pg1_labels([1 2 3 4 7 6 8],:) );

         % Group diff. radio
         if (rb4 == 1)
            % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:5,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:5,1),        'String', handles.pm07.pg2_labels([1 2 3 4 5],:) );

            % Panel 3 (Interval Estimates)
            set ( handles.hst_pg3(1:7,1),             'Visible', 'on');
            set ( handles.heb_pg3(1:14,1),            'Visible', 'on');
            set_loops( handles.hst_pg3(1:7,1),        'String', handles.pm07.pg3_labels([1 2 3 4 5 6 7],:) );

            % Panel 4 (Findings of Statistics Tests)
            set ( handles.hst_pg4(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg4(1:5,1),             'Visible', 'on');
            set_loops( handles.hst_pg4(1:5,1),        'String', handles.pm07.pg4_labels([1 2 3 4 6],:) );

            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm07.hd_labels(2,:) );

         % Ind. Change radio
         elseif (rb5 == 1)
            % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:3,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:3,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:3,1),        'String', handles.pm07.pg2_labels([1 6 7],:) );

            % Panel 3 (Interval Estimates)
            set ( handles.hst_pg3(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg3(1:10,1),            'Visible', 'on');
            set_loops( handles.hst_pg3(1:5,1),        'String', handles.pm07.pg3_labels([1 8 9 6 7],:) );

            % Panel 4 (Findings of Statistics Tests)
            set ( handles.hst_pg4(1:6,1),             'Visible', 'on');
            set ( handles.heb_pg4(1:6,1),             'Visible', 'on');
            set_loops( handles.hst_pg4(1:6,1),        'String', handles.pm07.pg4_labels([1 2 3 4 5 6],:) );

            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm07.hd_labels(3,:) );
         end ;

      % Obs. t & r radio button
      elseif rb3 == 1
         
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:4,1),           'String', handles.pm07.pg1_labels([7 5 6 8],:) );

         % Group diff. radio
         if (rb4 == 1)
            % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:1,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:1,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:1,1),        'String', handles.pm07.pg2_labels(5,:) );

            % Panel 3 (Interval Estimates)
            set ( handles.hst_pg3(1:3,1),             'Visible', 'on');
            set ( handles.heb_pg3(1:6,1),             'Visible', 'on');
            set_loops( handles.hst_pg3(1:3,1),        'String', handles.pm07.pg3_labels([5 6 7],:) );

            % Panel 4 (Findings of Statistics Tests)
            set ( handles.hst_pg4(1:4,1),             'Visible', 'on');
            set ( handles.heb_pg4(1:4,1),             'Visible', 'on');
            set_loops( handles.hst_pg4(1:4,1),        'String', handles.pm07.pg4_labels([1 2 3 4],:) );

            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm07.hd_labels(2,:) );

         % Ind. Change radio
         elseif (rb5 == 1)
            % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:2,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:2,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:2,1),        'String', handles.pm07.pg2_labels([6 7],:) );

            % Panel 3 (Interval Estimates)
            set ( handles.hst_pg3(1:4,1),             'Visible', 'on');
            set ( handles.heb_pg3(1:8,1),             'Visible', 'on');
            set_loops( handles.hst_pg3(1:4,1),        'String', handles.pm07.pg3_labels([8 9 6 7],:) );

            % Panel 4 (Findings of Statistics Tests)
            set ( handles.hst_pg4(1:5,1),             'Visible', 'on');
            set ( handles.heb_pg4(1:5,1),             'Visible', 'on');
            set_loops( handles.hst_pg4(1:5,1),        'String', handles.pm07.pg4_labels([1 2 3 4 5],:) );

            set (handles.hd2,                         'Visible', 'on')
            set (handles.hd2,                         'String', handles.pm07.hd_labels(3,:) );
         end ;
      end ;
      
   end ;


   % For Linear contrasts...handles.pm1 = 8
   if (pm1 == 8)

      gcfPosition = get(gcf, 'Position');
      set (gcf, 'Position', [gcfPosition(1:2) 940 605]);              % Makes right-hand panel visible   

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm08.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:3,1),                    'Visible', 'on');
      set_loops( handles.hrb_bg1(1:3,1),              'String', handles.pm08.bg1_labels(1:3,:) );

      % Extra Input for Linear Contrasts Panel
      set (handles.bg3,                               'Visible', 'on')
      set (handles.hcb_bg3(1:4,1),                    'Visible', 'on');
      set_loops(handles.hcb_bg3(1:4,1),               'String', handles.pm08.bg3_labels(1:4,:) );



      % Step 1:  Set-up headings for the appropriate radio button in Group 1
      % Between-subjects
      if (rb1 == 1)
         set (handles.bg2,                            'Visible', 'off')
         set (handles.hrb_bg2(1:2,1),                 'Visible', 'off');
         set (handles.hd1,                            'String', handles.pm08.hd_labels(1,:) );
      end ;

      % Within-subjects
      if (rb2 == 1)
         set (handles.bg2,                            'Visible', 'off')
         set (handles.hrb_bg2(1:2,1),                 'Visible', 'off');
         set (handles.hd1,                            'String', handles.pm08.hd_labels(2,:) );
      end ;

      % Mixed-subjects
      if (rb3 == 1)
         set (handles.hd1,                            'String', handles.pm08.hd_labels(3,:) );
         set (handles.bg2,                            'Visible', 'on')
         set (handles.hrb_bg2(1:2,1),                 'Visible', 'on');
         set_loops(handles.hrb_bg2(1:2,1),            'String', handles.pm08.bg2_labels(1:2,:) );
      end ;


      % Step 2:  Set-up order number drop-down menu in Panel 5 if selected
      % Order number check box [Y] 
      if (cb4 == 1)
         % Mixed-subjects radio button [Y]
         if (rb3 == 1)
            if (rb4 == 1)
               set (handles.pm2,                      'Visible', 'on');
               set (handles.pm3,                      'Visible', 'off');
            elseif (rb5 == 1)
               set (handles.pm2,                      'Visible', 'on');
               set (handles.pm3,                      'Visible', 'on');
            end ;
         % B/Subjects or W/Subjects radio button [Y]   
         elseif (rb1 == 1) || (rb2 == 1)
            set (handles.pm2,                         'Visible', 'on');
            set (handles.pm3,                         'Visible', 'off');
         end ;

      elseif (cb4 == 0)
         set (handles.pm2,                            'Visible', 'off');
         set (handles.pm3,                            'Visible', 'off');
      end ;


      % Step 3:  Set-up appropriate Input Data Panel if User MSE &/or User DF
      % User MSE and User DF check boxes [Y]
      if (cb5 == 1 && cb6 == 1)
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:4,1),           'String', handles.pm08.pg1_labels([1 3 4 2],:) );

      % User MSE check box [Y]
      elseif (cb5 == 1 && cb6 == 0)
         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:3,1),           'String', handles.pm08.pg1_labels([1 3 2],:) );

      % User DF check box [Y]
      elseif (cb5 == 0 && cb6 == 1)
         set ( handles.hst_pg1(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:3,1),           'String', handles.pm08.pg1_labels([1 4 2],:) );

      elseif (cb5 == 0 && cb6 == 0)           % MSE / df
         set ( handles.hst_pg1(1:2,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:2,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:2,1),           'String', handles.pm08.pg1_labels([1 2],:) );
      end ;


      % Step 4:  Select appropriate text and edit boxes based on chosen radio button in Group 1
      % Between-subjects
      if (rb1 == 1)
         
         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:3,1),           'String', handles.pm08.pg2_labels([1 2 3],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:12,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:6,1),           'String', handles.pm08.pg3_labels([1 2 3 4 5 6],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:8,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:8,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:8,1),           'String', handles.pm08.pg4_labels([1 2 3 4 5 6 7 8],:) );

         % Order-No. check box [Y]
         if cb4 == 1
            % Panel 5 (Linear Mean Contrasts)
            set ( handles.hst_pg5(1:6,1),             'Visible', 'on');
            set ( handles.heb_pg5(1:4,1),             'Visible', 'on');
            set_loops( handles.hst_pg5(1:6,1),        'String', handles.pm08.pg5_labels([1 2 3 4 6 8],:) );
         else
            % Panel 5 (Linear Mean Contrasts)
            set ( handles.hst_pg5(1:4,1),             'Visible', 'on');
            set ( handles.heb_pg5(1:4,1),             'Visible', 'on');
            set_loops( handles.hst_pg5(1:4,1),        'String', handles.pm08.pg5_labels([1 2 3 4],:) );
         end ;
         
      end ;


      % Within-subjects
      if (rb2 == 1)
         
         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:4,1),           'String', handles.pm08.pg2_labels([1 2 3 4],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:12,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:6,1),           'String', handles.pm08.pg3_labels([1 2 3 4 5 6],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:5,1),           'String', handles.pm08.pg4_labels([1 2 3 4 5],:) );

         % Order-No. check box [Y]
         if cb4 == 1
            % Panel 5 (Linear Mean Contrasts)
            set ( handles.hst_pg5(1:6,1),             'Visible', 'on');
            set ( handles.heb_pg5(1:4,1),             'Visible', 'on');
            set_loops( handles.hst_pg5(1:6,1),        'String', handles.pm08.pg5_labels([1 5 6 4 6 9],:) );
         else
            % Panel 5 (Linear Mean Contrasts)
            set ( handles.hst_pg5(1:4,1),             'Visible', 'on');
            set ( handles.heb_pg5(1:4,1),             'Visible', 'on');
            set_loops( handles.hst_pg5(1:4,1),        'String', handles.pm08.pg5_labels([1 5 6 4],:) );
         end ;
         
      end ;


      % Mixed-subjects
      if (rb3 == 1)

         % B/S Contrast check box [Y]
         if (rb4 == 1)
         % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:3,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:3,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:3,1),        'String', handles.pm08.pg2_labels([1 2 3],:) );
         end ;

         % W/S Contrast check box [Y]
         if (rb5 == 1)
         % Panel 2 (Point Estimates)
            set ( handles.hst_pg2(1:4,1),             'Visible', 'on');
            set ( handles.heb_pg2(1:4,1),             'Visible', 'on');
            set_loops( handles.hst_pg2(1:4,1),        'String', handles.pm08.pg2_labels([1 2 3 4],:) );
         end ;

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:12,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:6,1),           'String', handles.pm08.pg3_labels([1 2 3 4 5 6],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:5,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:5,1),                'Visible', 'on');
         set_loops( handles.hst_pg4(1:5,1),           'String', handles.pm08.pg4_labels([1 2 3 4 5],:) );

         % Order-No. check box [Y]
         if cb4 == 1

            % B/S Contrast check box [Y]
            if (rb4 == 1)
               % Panel 5 (Linear Mean Contrasts)
               set ( handles.hst_pg5(1:6,1),          'Visible', 'on');
               set ( handles.heb_pg5(1:4,1),          'Visible', 'on');
               set_loops( handles.hst_pg5(1:6,1),     'String', handles.pm08.pg5_labels([1 5 3 4 7 8],:) );

            % W/S Contrast check box [Y]
            elseif (rb5 == 1)
               % Panel 5 (Linear Mean Contrasts)
               set ( handles.hst_pg5(1:7,1),          'Visible', 'on');
               set ( handles.heb_pg5(1:4,1),          'Visible', 'on');
               set_loops( handles.hst_pg5(1:7,1),     'String', handles.pm08.pg5_labels([1 5 3 4 7 8 9],:) );
            end ;

         else

            % B/S Contrast check box [Y]
            if (rb4 == 1)
               % Panel 5 (Linear Mean Contrasts)
               set ( handles.hst_pg5(1:4,1),          'Visible', 'on');
               set ( handles.heb_pg5(1:4,1),          'Visible', 'on');
               set_loops( handles.hst_pg5(1:4,1),     'String', handles.pm08.pg5_labels([1 5 3 4],:) );

            % W/S Contrast check box [Y]
            elseif (rb5 == 1)
               % Panel 5 (Linear Mean Contrasts)
               set ( handles.hst_pg5(1:4,1),          'Visible', 'on');
               set ( handles.heb_pg5(1:4,1),          'Visible', 'on');
               set_loops( handles.hst_pg5(1:4,1),     'String', handles.pm08.pg5_labels([1 5 3 4],:) );
            end ;

         end ;
         
      end ;         

   end ;


   % For Proportions...handles.pm1 = 9
   if (pm1 == 9)

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm09.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:2,1),                    'Visible', 'on');
      set_loops( handles.hrb_bg1(1:2,1),              'String', handles.pm09.bg1_labels(1:2,:) );

      % Options Panel
      set (handles.bg2,                               'Visible', 'on')
      set (handles.hcb_bg2(1:2,1),                    'Visible', 'on');
      set_loops(handles.hcb_bg2(1:2,1),               'String', handles.pm09.bg2_labels([1 2],:) );


      if cb1 == 1
         set (handles.hd2,                            'Visible', 'on')
         set (handles.hd2,                            'String', handles.pm09.hd_labels(2,:) );
      else
         set (handles.hd2,                            'Visible', 'off')
         set (handles.hd2,                            'String',  ' ' );
      end ; 

      % Proportions radio button
      if rb1 == 1

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:4,1),           'String', handles.pm09.pg1_labels([1 2 3 5],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:3,1),           'String', handles.pm09.pg2_labels([1 2 3],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:14,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:7,1),           'String', handles.pm09.pg3_labels([1 2 3 4 5 6 7],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:7,1),                'Visible', 'on');

         if cb2 == 1
            set_loops( handles.hst_pg4(1:7,1),        'String', handles.pm09.pg4_labels([1 3 4 5 9 10 8],:) );
         else
            set_loops( handles.hst_pg4(1:7,1),        'String', handles.pm09.pg4_labels([1 3 4 5 6 7 8],:) );
         end ;

      % No. of Cases radio button
      elseif rb2 == 1

         % Panel 1 (Input Data)
         set ( handles.hst_pg1(1:4,1),                'Visible', 'on');
         set ( handles.heb_pg1(1:4,1),                'Visible', 'on');
         set_loops( handles.hst_pg1(1:4,1),           'String', handles.pm09.pg1_labels([4 2 3 5],:) );

         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:3,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:3,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:3,1),           'String', handles.pm09.pg2_labels([1 2 3],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:14,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:7,1),           'String', handles.pm09.pg3_labels([1 2 3 4 5 6 7],:) );

         % Panel 4 (Findings of Statistics Tests)
         set ( handles.hst_pg4(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg4(1:7,1),                'Visible', 'on');

         if cb2 == 1
            set_loops( handles.hst_pg4(1:7,1),        'String', handles.pm09.pg4_labels([1 3 4 5 9 10 8],:) );
         else
            set_loops( handles.hst_pg4(1:7,1),        'String', handles.pm09.pg4_labels([1 3 4 5 6 7 8],:) );
         end ;
         
      end ;
      
   end ;


   % For SEM Fit Statistics...handles.pm1 = 10
   if (pm1 == 10)

      % Analysis Heading
      set (handles.hd1,                               'Visible', 'on')
      set (handles.hd1,                               'String', handles.pm10.hd_labels(1,:) );

      % Type of Input Panel
      set (handles.bg1,                               'Visible', 'on')
      set (handles.hrb_bg1(1:2,1),                    'Visible', 'on');
      set_loops(handles.hrb_bg1(1:2,1),               'String', handles.pm10.bg1_labels(1:2,:) );

      % Options Panel
      set (handles.bg2,                               'Visible', 'on')
      set (handles.hcb_bg2(1:3,1),                    'Visible', 'on');
      set_loops(handles.hcb_bg2(1:3,1),               'String', handles.pm10.bg2_labels(1:3,:) );


      % Chi-square radio button
      if rb1 == 1
         % # Model ParametersI check box [Y}
         if (cb2 == 1)
            % Panel 1 (Input Data)
            set ( handles.hst_pg1(1:7,1),             'Visible', 'on');
            set ( handles.heb_pg1(1:7,1),             'Visible', 'on');
            set_loops( handles.hst_pg1(1:7,1),        'String', handles.pm10.pg1_labels([1 2 3 4 5 8 9],:) );

         elseif (cb2 == 0)
            % Panel 1 (Input Data)
            set ( handles.hst_pg1(1:7,1),             'Visible', 'on');
            set ( handles.heb_pg1(1:7,1),             'Visible', 'on');
            set_loops( handles.hst_pg1(1:7,1),        'String', handles.pm10.pg1_labels([1 2 3 4 5 6 9],:) );
         end ;

      % Disc. function  radio button
      elseif rb2 == 1
         % # Model ParametersI check box [Y}
         if (cb2 == 1)
            % Panel 1 (Input Data)
            set ( handles.hst_pg1(1:7,1),             'Visible', 'on');
            set ( handles.heb_pg1(1:7,1),             'Visible', 'on');
            set_loops( handles.hst_pg1(1:7,1),        'String', handles.pm10.pg1_labels([7 2 3 4 5 8 9],:) );

         elseif (cb2 == 0)
            % Panel 1 (Input Data)
            set ( handles.hst_pg1(1:7,1),             'Visible', 'on');
            set ( handles.heb_pg1(1:7,1),             'Visible', 'on');
            set_loops( handles.hst_pg1(1:7,1),        'String', handles.pm10.pg1_labels([7 2 3 4 5 6 9],:) );
         end ;
         
      end ;

      % ML-ECVI check box [Y}
      if (cb1 == 1)
         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:7,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:7,1),           'String', handles.pm10.pg2_labels([1 2 3 4 5 6 7],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:9,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:18,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:9,1),           'String', handles.pm10.pg3_labels([1 2 3 4 5 6 8 7 9],:) );

      else
         % Panel 2 (Point Estimates)
         set ( handles.hst_pg2(1:6,1),                'Visible', 'on');
         set ( handles.heb_pg2(1:6,1),                'Visible', 'on');
         set_loops( handles.hst_pg2(1:6,1),           'String', handles.pm10.pg2_labels([1 2 3 4 5 6],:) );

         % Panel 3 (Interval Estimates)
         set ( handles.hst_pg3(1:7,1),                'Visible', 'on');
         set ( handles.heb_pg3(1:14,1),               'Visible', 'on');
         set_loops( handles.hst_pg3(1:7,1),           'String', handles.pm10.pg3_labels([1 2 3 4 5 6 7],:) );
         
      end ;

      % Mean-Structure check box [Y}
      if (cb3 == 1)
         set (handles.hd2,                            'Visible', 'on')
         set (handles.hd2,                            'String', handles.pm10.hd_labels(2,:) );
      elseif (cb3 == 0)
         set (handles.hd2,                            'Visible', 'off')
      end ;

      % Panel 4 (Findings of Statistics Tests)
      set ( handles.hst_pg4(1:7,1),                   'Visible', 'on');
      set ( handles.heb_pg4(1:7,1),                   'Visible', 'on');
      set_loops( handles.hst_pg4(1:7,1),              'String', handles.pm10.pg4_labels([1 2 3 4 5 6 7],:) );

   end ;      

end 


%% Initialises only the input components of the GUI interface

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
    
    set (handles.bg1,      'Visible', 'off') ;
    set (handles.bg2,      'Visible', 'off') ;
    set (handles.bg3,      'Visible', 'off') ;
    
    
end 


%% Initialises only the output components of the GUI interface

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
    
end


%% Initialises all components of the GUI interface

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
    
end    




