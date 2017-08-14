function varargout = fm_equivfig(varargin)
% FM_EQUIVFIG graphical user interface for the network equivalent
%             function.
%
%see lso the function FM_EQUIV and FM_BUSFIG
%
%Author:    Federico Milano
%Update:    02-Apr-2008
%Version:   0.1
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2016 Federico Milano

global Theme Settings EQUIV File Path Fig Bus

equivalent_methods = { ...
    'Thevenin equivalent', ...
    'Dynamic equivalent'};

bus_selection_methods = { ...
    'Voltage level', ...
    'Area', ...
    'Region', ...
    'Voltage threshold', ...
    'Custom bus list'};

if ~autorun('Network Equivalent',1)
  return
end

if nargin

  ht = findobj(gcf,'Tag','MsgText');

  switch varargin{1}

   case 'run'

    if EQUIV.bus_selection == 4 && isempty(EQUIV.custom_file)
      fm_disp('A bus list file must be defined.',2)
      return
    end
    check = fm_equiv;
    if check
      set(ht,'String','Equivalencing procedure completed.')
      fm_disp('Equivalencing procedure completed.')
    else
      set(ht,'String','Equivalencing procedure failed.')
      fm_disp('Equivalencing procedure failed.',2)
    end
    hdl = findobj(gcf,'Tag','OpenMatlab');
    set(hdl,'Enable','On');

   case 'setdata'

    % adjusting voltage edit box
    hdl = findobj(gcf,'Tag','EditVoltage');
    value = str2num(get(hdl,'String'));
    kv = getkv_bus(Bus,0,0);
    idx = find(kv == value);
    if isempty(idx)
      [a,b] = min(abs(kv-value));
      set(hdl,'String',num2str(kv(b(1))))
      EQUIV.bus_voltage = kv(b(1));
    end

    % adjusting area edit box
    hdl = findobj(gcf,'Tag','EditArea');
    value = str2num(get(hdl,'String'));
    as = getarea_bus(Bus,0,0);
    idx = find(as == value);
    if isempty(idx)
      [a,b] = min(abs(as-value));
      set(hdl,'String',num2str(as(b(1))))
      EQUIV.area_num = as(b(1));
    end

    % adjusting region edit box
    hdl = findobj(gcf,'Tag','EditRegion');
    value = str2num(get(hdl,'String'));
    as = getregion_bus(Bus,0,0);
    idx = find(as == value);
    if isempty(idx)
      [a,b] = min(abs(as-value));
      set(hdl,'String',num2str(as(b(1))))
      EQUIV.region_num = as(b(1));
    end

    hdl = findobj(gcf,'Tag','OpenMatlab');
    set(hdl,'Enable','Off');

   case 'clearbuslist'

    EQUIV.custom_file = '';
    EQUIV.custom_path = '';
    set(ht,'String','Clear bus list file')
    hdl = findobj(gcf,'Tag','edit_bus_list');
    set(hdl,'String','<No bus list>')

   case 'setbuslist'

    fileformat = Settings.format;
    if ishandle(Fig.dir)
      set(Fig.dir,'Name','Load Data File')
      hdl = findobj(Fig.dir,'Tag','Pushbutton1');
      set(hdl,'String','Load','Callback','fm_dirset openfile')
      hdl = findobj(Fig.dir,'Tag','Listbox2');
      set(hdl,'Max',0,'ButtonDownFcn','fm_dirset openfile','Value',1)
      hdl = findobj(Fig.dir,'Tag','PopupMenu1');
      set(hdl,'Enbale','inactive','Value',length(get(hdl,'String')))
      hdl = findobj(Fig.dir,'Tag','Pushbutton3');
      set(hdl,'Callback','fm_dirset cancel','String','Cancel')
    else
      fm_dir(3)
    end
    uiwait(Fig.dir);
    Settings.format = fileformat;

    if ~Path.temp
      if isempty(EQUIV.custom_file)
        set(ht,'String','No file set. No bus list file.')
      else
        set(ht,'String',['No file set. Current bus list file <',EQUIV.custom_file,'>'])
      end
    else
      EQUIV.custom_file = File.temp;
      EQUIV.custom_path = Path.temp;
      set(ht,'String',['Set custom bus list <',File.temp,'>'])
      hdl = findobj(gcf,'Tag','edit_bus_list');
      set(hdl,'String',File.temp)
    end

   case 'equivalent'

    value = get(gcbo,'Value');
    set(ht,'String',['Equivalencing method: ',equivalent_methods{value}])
    EQUIV.equivalent_method = value;

   case 'gentypepv'

    hdl = findobj(Fig.equiv,'Tag','GenTypePQ');
    switch get(gcbo,'Checked')
     case 'on'
      set(gcbo,'Checked','off')
      EQUIV.gentype = 2;
      set(hdl,'Checked','on');
     case 'off'
      set(gcbo,'Checked','on')
      EQUIV.gentype = 1;
      set(hdl,'Checked','off');
    end

   case 'gentypepq'

    hdl = findobj(Fig.equiv,'Tag','GenTypePV');
    switch get(gcbo,'Checked')
     case 'on'
      set(gcbo,'Checked','off')
      EQUIV.gentype = 1;
      set(hdl,'Checked','on');
     case 'off'
      set(gcbo,'Checked','on')
      EQUIV.gentype = 2;
      set(hdl,'Checked','off');
    end

   case 'checkdepth'

    value = get(gcbo,'Value');
    if value
      set(findobj(gcf,'Tag','EditDepth'),'Enable','On')
      set(findobj(gcf,'Tag','TextDepth'),'Enable','On')
      EQUIV.bus_depth = get(findobj(gcf,'Tag','EditDepth'),'Value')-1;
    else
      set(findobj(gcf,'Tag','EditDepth'),'Enable','Off')
      set(findobj(gcf,'Tag','TextDepth'),'Enable','Off')
      EQUIV.bus_depth = 0;
    end

   case 'bus'

    value = get(findobj(Fig.equiv,'Tag','popupmenu3'),'Value');
    EQUIV.bus_selection = value;

    switch value
     case 1 % voltage level
      set(findobj(gcf,'Tag','EditVoltage'),'Enable','On')
      set(findobj(gcf,'Tag','EditArea'),'Enable','Off')
      set(findobj(gcf,'Tag','EditRegion'),'Enable','Off')
      set(findobj(gcf,'Tag','edit_bus_list'),'Enable','Off')
      set(findobj(gcf,'Tag','buttonbus'),'Enable','Off')
      hdl = findobj(gcf,'Tag','TextVoltage');
      set(hdl,'String','Bus Voltage Threshold [kV]','Enable','On')
      set(findobj(gcf,'Tag','TextArea'),'Enable','Off')
      set(findobj(gcf,'Tag','TextRegion'),'Enable','Off')
     case 2 % area
      set(findobj(gcf,'Tag','EditVoltage'),'Enable','Off')
      set(findobj(gcf,'Tag','EditArea'),'Enable','On')
      set(findobj(gcf,'Tag','EditRegion'),'Enable','Off')
      set(findobj(gcf,'Tag','edit_bus_list'),'Enable','Off')
      set(findobj(gcf,'Tag','buttonbus'),'Enable','Off')
      set(findobj(gcf,'Tag','TextVoltage'),'Enable','Off')
      set(findobj(gcf,'Tag','TextArea'),'Enable','On')
      set(findobj(gcf,'Tag','TextRegion'),'Enable','Off')
     case 3 % region
      set(findobj(gcf,'Tag','EditVoltage'),'Enable','Off')
      set(findobj(gcf,'Tag','EditArea'),'Enable','Off')
      set(findobj(gcf,'Tag','EditRegion'),'Enable','On')
      set(findobj(gcf,'Tag','edit_bus_list'),'Enable','Off')
      set(findobj(gcf,'Tag','buttonbus'),'Enable','Off')
      set(findobj(gcf,'Tag','TextVoltage'),'Enable','Off')
      set(findobj(gcf,'Tag','TextArea'),'Enable','Off')
      set(findobj(gcf,'Tag','TextRegion'),'Enable','On')
     case 4 % threshold
      set(findobj(gcf,'Tag','EditVoltage'),'Enable','On')
      set(findobj(gcf,'Tag','EditArea'),'Enable','Off')
      set(findobj(gcf,'Tag','EditRegion'),'Enable','Off')
      set(findobj(gcf,'Tag','edit_bus_list'),'Enable','Off')
      set(findobj(gcf,'Tag','buttonbus'),'Enable','Off')
      hdl = findobj(gcf,'Tag','TextVoltage');
      set(hdl,'String','Bus Voltage Threshold [kV]','Enable','On')
      set(findobj(gcf,'Tag','TextArea'),'Enable','Off')
      set(findobj(gcf,'Tag','TextRegion'),'Enable','Off')
     case 5 % custom bus list
      set(findobj(gcf,'Tag','EditVoltage'),'Enable','Off')
      set(findobj(gcf,'Tag','EditArea'),'Enable','Off')
      set(findobj(gcf,'Tag','EditRegion'),'Enable','Off')
      set(findobj(gcf,'Tag','edit_bus_list'),'Enable','Inactive')
      set(findobj(gcf,'Tag','buttonbus'),'Enable','On')
      set(findobj(gcf,'Tag','TextVoltage'),'Enable','Off')
      set(findobj(gcf,'Tag','TextArea'),'Enable','Off')
      set(findobj(gcf,'Tag','TextRegion'),'Enable','Off')
    end

   case 'busvoltage'

    lasterr('');
    try
      [value,ok] = str2num(get(gcbo,'String'));
      if ok
        EQUIV.bus_voltage = value;
        set(ht,'String',['Bus voltage: ',num2str(value)])
      else
        set(ht,'String',['<',get(gcbo,'String'),'> is not a valid voltage value!'])
        set(gcbo,'String',num2str(EQUIV.bus_voltage))
      end
    catch
      set(ht,'String',lasterr)
      set(gcbo,'String',num2str(EQUIV.bus_voltage))
    end

   case 'area'

    lasterr('');
    try
      [value,ok] = str2num(get(gcbo,'String'));
      if ok && round(value) > 0
        EQUIV.area_num = round(value);
        set(ht,'String',['Area id: ', num2str(EQUIV.area_num)])
        set(gcbo,'String',num2str(EQUIV.area_num))
      else
        set(ht,'String',['<',get(gcbo,'String'),'> is not a valid area number!'])
        set(gcbo,'String',num2str(EQUIV.area_num))
      end
    catch
      set(ht,'String',lasterr)
      set(gcbo,'String',num2str(EQUIV.area_num))
    end

   case 'region'

    lasterr('');
    try
      [value,ok] = str2num(get(gcbo,'String'));
      if ok && round(value) > 0
        EQUIV.region_num = round(value);
        set(ht,'String',['Region id: ', num2str(EQUIV.region_num)])
        set(gcbo,'String',num2str(EQUIV.region_num))
      else
        set(ht,'String',['<',get(gcbo,'String'),'> is not a valid region number!'])
        set(gcbo,'String',num2str(EQUIV.region_num))
      end
    catch
      set(ht,'String',lasterr)
      set(gcbo,'String',num2str(EQUIV.region_num))
    end

   case 'busdepth'

    EQUIV.bus_depth = get(gcbo,'Value')-1;

   case 'view'

    filedata = strrep(File.data,'(mdl)','');
    switch varargin{2}
     case 'mfile'
      filename = [Path.data,filedata,'.m'];
     case 'finalmfile'
      filename = [Path.data,filedata,'_equiv.m'];
     case 'buslist'
      if isempty(EQUIV.custom_file)
        cd(Path.data)
        a = dir([filedata,'.lst']);
        if ~isempty(a)
          listfile = [Path.data,a.name];
        end
        cd(Path.local)
      else
        listfile = [EQUIV.custom_path,EQUIV.custom_file];
      end
      filename = listfile;
     otherwise
      set(ht,'String','Unknown file...')
    end

    fm_text(13,filename)

   case 'createlist'

    cd(Path.data)
    filedata = strrep(File.data,'(mdl)','');
    b = dir([filedata,'.lst']);
    if isempty(b)
      bdate = '0';
    else
      bdate = b.date;
    end
    uiwait(fm_busfig)
    a = dir([filedata,'.lst']);
    if ~isempty(a) && isempty(EQUIV.custom_file)
      if a.date ~= bdate
        EQUIV.custom_file = a.name;
        EQUIV.custom_path = Path.data;
        hdl = findobj(Fig.equiv,'Tag','edit_bus_list');
        set(hdl,'String',a.name)
      end
    end
    cd(Path.local)
    set(ht,'String','Editing bus list completed.')

   otherwise

    set(ht,'String','Unknown command...')

  end

  return

end

if ishandle(Fig.cpf), figure(Fig.cpf), return, end

h1 = figure(...
    'Units','normalized',...
    'Color',Theme.color01, ...
    'Colormap',[], ...
    'MenuBar','none',...
    'Name','Network Equivalents',...
    'NumberTitle','off',...
    'PaperPosition',[18 180 576 432], ...
    'Position',sizefig(0.525,0.55),...
    'Resize','on', ...
    'Toolbar','none', ...
    'FileName','fm_equivfig',...
    'CreateFcn','Fig.equiv = gcf;', ...
    'DeleteFcn','Fig.equiv = -1;');
fm_set colormap

% Menu File/Open
hm = uimenu('Parent',h1, ...
            'Label','File', ...
            'Tag','MenuFile');

hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig setdata', ...
            'Label', 'Set Optpow File', ...
            'Tag','OpenData', ...
            'Accelerator','s');
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig setbuslist', ...
            'Label', 'Set Bus List', ...
            'Tag','OpenLF', ...
            'Accelerator','b');
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig clearbuslist', ...
            'Label', 'Clear Bus List', ...
            'Tag','OpenLF', ...
            'Accelerator','r');
hs = uimenu('Parent',hm, ...
            'Callback','close(gcf)', ...
            'Label', 'Exit', ...
            'Tag','OpenLF', ...
            'Separator','on', ...
            'Accelerator','q');

hm = uimenu('Parent',h1, ...
            'Label','Edit', ...
            'Tag','MenuFile');

hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig view mfile', ...
            'Label', 'View original data', ...
            'Tag','OpenOrigMatlab', ...
            'Accelerator','m');
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig view buslist', ...
            'Label', 'View bus list', ...
            'Tag','OpenData', ...
            'Accelerator','l');
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig view finalmfile', ...
            'Label', 'View equivalent data', ...
            'Enable', 'off', ...
            'Tag','OpenMatlab', ...
            'Accelerator','1');

hm = uimenu('Parent',h1, ...
            'Label','Options', ...
            'Tag','MenuFile');

hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig createlist', ...
            'Label', 'Create custom bus list', ...
            'Tag','OpenData', ...
            'Accelerator','c');
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig gentypepv', ...
            'Label', 'Use PV equiv. gen.', ...
            'Tag','GenTypePV');
if EQUIV.gentype == 1
  set(hs,'Checked','on')
end
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig gentypepq', ...
            'Label', 'Use PQ equiv. gen.', ...
            'Tag','GenTypePQ');
if EQUIV.gentype == 2
  set(hs,'Checked','on')
end
hs = uimenu('Parent',hm, ...
            'Callback','fm_equivfig stopisland', ...
            'Label', 'Stop if the internal network is not interconnected', ...
            'Tag','ComputeSI', ...
            'Checked', 'Off', ...
            'Accelerator','n');

h2 = uipanel(...
    'Parent',h1,...
    'Units','normalized',...
    'FontSize',10,...
    'BackgroundColor', Theme.color01, ...
    'Title',{  'Main Settings' },...
    'Tag','uipanel1',...
    'Clipping','on',...
    'Position',[0.075154     0.15957     0.38497     0.80053]);

h8 = uipanel(...
    'Parent',h1,...
    'Units','normalized',...
    'FontSize',10,...
    'BackgroundColor', Theme.color01, ...
    'Title',{  'Advanced Settings' },...
    'Tag','uipanel2',...
    'Clipping','on',...
    'Position',[0.53528     0.15957     0.38497     0.80053]);

ht = uicontrol( ...
    'Parent',h2, ...
    'Units','normalized', ...
    'BackgroundColor', Theme.color01, ...
    'Enable', 'inactive', ...
    'HorizontalAlignment','left', ...
    'Position',[0.1 0.9 0.8 0.05], ...
    'String',['Equivalent method'], ...
    'Style','text', ...
    'Tag','Text1');

h3 = uicontrol(...
    'Parent',h2,...
    'Units','normalized',...
    'Callback','fm_equivfig equivalent',...
    'BackgroundColor', Theme.color01, ...
    'FontSize',10,...
    'Position',[0.1 0.8 0.8 0.085],...
    'String',equivalent_methods,...
    'Style','popupmenu',...
    'Value',EQUIV.equivalent_method,...
    'Tag','equivalent_popup');

h6 = uicontrol(...
    'Parent',h2,...
    'BackgroundColor', Theme.color01, ...
    'Units','normalized',...
    'Callback','fm_equivfig run',...
    'FontSize',10,...
    'Position',[0.1 0.05 0.35 0.125],...
    'String',{  'Start' }, ...
    'Tag','pushbutton2', ...
    'CreateFcn', 'set(gcbo,''Position'',[0.1 0.05 0.35 0.125])' );

h6 = uicontrol(...
    'Parent',h2,...
    'BackgroundColor', Theme.color01, ...
    'Units','normalized',...
    'Callback','close(gcf)',...
    'FontSize',10,...
    'Position',[0.55 0.05 0.35 0.125], ...
    'String',{  'Close' }, ...
    'Tag','pushbutton3', ...
    'CreateFcn', 'set(gcbo,''Position'',[0.55 0.05 0.35 0.125])');

ht = uicontrol( ...
    'Parent',h2, ...
    'Units','normalized', ...
    'BackgroundColor', Theme.color01, ...
    'Enable', 'inactive', ...
    'HorizontalAlignment','left', ...
    'Position',[0.1 0.7  0.8  0.05], ...
    'String',['Bus selection'], ...
    'Style','text', ...
    'Tag','BusSelText');

h7 = uicontrol(...
    'Parent',h2,...
    'Units','normalized',...
    'Callback','fm_equivfig bus',...
    'BackgroundColor', Theme.color01, ...
    'FontSize',10,...
    'Position',[0.1 0.6 0.8 0.085],...
    'String',bus_selection_methods, ...
    'Style','popupmenu',...
    'Value',EQUIV.bus_selection,...
    'Tag','popupmenu3');

h7 = uicontrol(...
    'Parent',h2,...
    'Units','normalized',...
    'Callback','fm_equivfig checkdepth',...
    'BackgroundColor', Theme.color01, ...
    'FontSize',10,...
    'Position',[0.1 0.3 0.8 0.085],...
    'String',bus_selection_methods, ...
    'Style','checkbox',...
    'CreateFcn', 'set(gcbo,''Position'',[0.1 0.3 0.8 0.085])', ...
    'Value',EQUIV.bus_depth,...
    'String','Use bus depth', ...
    'Tag','checkbox1');

% -----------------------------------------------------------------
% Set bus list
% -----------------------------------------------------------------

h11 = uicontrol(...
    'Parent',h8,...
    'Units','normalized',...
    'BackgroundColor', Theme.color01, ...
    'Callback','fm_equivfig setbuslist',...
    'FontSize',10,...
    'Position',[0.1 0.85 0.8 0.085+0.02],...
    'String',{  'Set custom bus list' },...
    'Enable','Off', ...
    'Tag','buttonbus');

h12 = uicontrol(...
    'Parent',h2,...
    'Units','normalized',...
    'Callback','',...
    'FontSize',10,...
    'ForegroundColor', [0.8 0 0], ...
    'BackgroundColor', [1 1 1], ...
    'Position',[0.1 0.45 0.8 0.085],...
    'String',{  '<No bus list>' },...
    'FontName','Curier', ...
    'Style','edit',...
    'Enable','Off',...
    'Tag','edit_bus_list');

if ~isempty(EQUIV.custom_path)
  set(h12,'String',{EQUIV.custom_file})
end

% -----------------------------------------------------------------
% Area
% -----------------------------------------------------------------

ht = uicontrol( ...
    'Parent',h8, ...
    'Units','normalized', ...
    'CreateFcn','', ...
    'BackgroundColor', Theme.color01, ...
    'Enable', 'inactive', ...
    'HorizontalAlignment','left', ...
    'Position',[0.1 0.75 0.8 0.05], ...
    'String','Area number', ...
    'Enable','Off', ...
    'Style','text', ...
    'Tag','TextArea');

h13 = uicontrol(...
    'Parent',h8,...
    'Units','normalized',...
    'HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],...
    'FontName','Curier', ...
    'Callback','fm_equivfig area',...
    'FontSize',10,...
    'Position',[0.1 0.65 0.8 0.085],...
    'Enable','Off', ...
    'String',num2str(EQUIV.area_num),...
    'Style','edit',...
    'Tag','EditArea',...
    'CreateFcn', '' );

if Settings.hostver < 8.04
  set(h13, 'Behavior',get(0,'defaultuicontrolBehavior'))
end

% -----------------------------------------------------------------
% Region
% -----------------------------------------------------------------

ht = uicontrol( ...
    'Parent',h8, ...
    'Units','normalized', ...
    'BackgroundColor', Theme.color01, ...
    'Enable', 'inactive', ...
    'HorizontalAlignment','left', ...
    'Position',[0.1 0.55 0.8 0.05], ...
    'String','Region number', ...
    'Enable','Off', ...
    'Style','text', ...
    'Tag','TextRegion');

h13 = uicontrol(...
    'Parent',h8,...
    'Units','normalized',...
    'HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],...
    'FontName','Curier', ...
    'Callback','fm_equivfig region',...
    'FontSize',10,...
    'Position',[0.1 0.45 0.8 0.085],...
    'Enable','Off', ...
    'String',num2str(EQUIV.region_num),...
    'Style','edit',...
    'Tag','EditRegion');

% -----------------------------------------------------------------
% Bus voltage
% -----------------------------------------------------------------

ht = uicontrol( ...
    'Parent',h8, ...
    'Units','normalized', ...
    'CreateFcn','', ...
    'BackgroundColor', Theme.color01, ...
    'Enable', 'inactive', ...
    'HorizontalAlignment','left', ...
    'Position',[0.1 0.35 0.8 0.05], ...
    'String','Bus voltage [kV]', ...
    'Style','text', ...
    'Tag','TextVoltage');

h13 = uicontrol(...
    'Parent',h8,...
    'Units','normalized',...
    'HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],...
    'FontName','Curier', ...
    'Callback','fm_equivfig busvoltage',...
    'FontSize',10,...
    'Position',[0.1 0.25 0.8 0.085],...
    'String',num2str(EQUIV.bus_voltage),...
    'Style','edit',...
    'Tag','EditVoltage',...
    'CreateFcn', '' );

if Settings.hostver < 8.04
  set(h13, 'Behavior',get(0,'defaultuicontrolBehavior'))
end

% -----------------------------------------------------------------
% Bus depth
% -----------------------------------------------------------------

ht = uicontrol( ...
    'Parent',h8, ...
    'Units','normalized', ...
    'BackgroundColor', Theme.color01, ...
    'Enable', 'inactive', ...
    'HorizontalAlignment','left', ...
    'Position',[0.1 0.15 0.8 0.05], ...
    'String',['Bus depth'], ...
    'Enable','Off', ...
    'Style','text', ...
    'Tag','TextDepth');

h13 = uicontrol(...
    'Parent',h8,...
    'Units','normalized',...
    'HorizontalAlignment','center', ...
    'BackgroundColor',[1 1 1],...
    'FontName','Curier', ...
    'Callback','fm_equivfig busdepth',...
    'Enable','Off', ...
    'FontSize',10,...
    'Position',[0.1 0.05 0.8 0.085],...
    'String',{'0','1','2','3','4','5','6','7','8','9','10'},...
    'Value', EQUIV.bus_depth , ...
    'Style','popupmenu',...
    'Tag','EditDepth');

% -----------------------------------------------------------------
% Messages
% -----------------------------------------------------------------

h14 = uipanel(...
    'Parent',h1,...
    'Units','normalized',...
    'FontSize',10,...
    'BackgroundColor', Theme.color01, ...
    'Title',{  'Messages' },...
    'Tag','uipanel1',...
    'Clipping','on',...
    'Position', [0.075154    0.031915     0.84509     0.10372]);

h15 = uicontrol( ...
    'Parent',h14, ...
    'Units','normalized', ...
    'Enable', 'inactive', ...
    'FontName','Curier', ...
    'BackgroundColor', Theme.color01, ...
    'ForegroundColor',[0 0 0.8], ...
    'HorizontalAlignment','left', ...
    'Position',[0.02  0.1  0.8  0.8], ...
    'String',['EQUIV GUI version 0.1'], ...
    'Style','text', ...
    'Tag','MsgText');

fm_equivfig bus