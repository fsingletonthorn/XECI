function [handles] = set_default_setup(handles)

      set (handles.hst_hds,  'String', '' );
      
      set (handles.hst_hds,  'Visible', 'on' );
      
      set (handles.hrb_bg1,  'Visible', 'off' );
      set (handles.hrb_bg2,  'Visible', 'off' );
      set (handles.hcb_bg2,  'Visible', 'off' );
      set (handles.hcb_bg3,  'Visible', 'off' );
      
      set (handles.bg1,      'Visible', 'off');
      set (handles.bg2,      'Visible', 'off');
      set (handles.bg3,      'Visible', 'off');
      
      set (handles.pm2,      'Visible', 'off');
      set (handles.pm3,      'Visible', 'off');
      
      set (handles.st_l,     'Visible', 'on');
      set (handles.st_u,     'Visible', 'on');   
      
      set (handles.hst_pg2,  'ForegroundColor', [0 0 0]);
      set (handles.hst_pg3,  'ForegroundColor', [0 0 0]);

      set (handles.heb_pg1,  'BackgroundColor', [1 1 1]);
      set (handles.heb_pg5,  'BackgroundColor', [1 1 1]);

      set (handles.heb_pg1,  'TooltipString', '') ;
      set (handles.heb_pg5,  'TooltipString', '') ;

      % Reset any changes in titles, radio buttons and/or call boxes
      set (handles.pg4,      'Title', 'Findings for Statistical Tests');
      
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
      
      set (handles.tb1,      'BackgroundColor', [1    , 0    , 0]);           % Red
      set (handles.tb1,      'String', 'Enter data...');
      set (handles.tb1,      'Value', 0);

end      