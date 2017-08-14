function fig = fm_setting(varargin)
% FM_SETTING create GUI for general settings
%
% HDL = FM_SETTING()
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2016 Federico Milano

global Settings Theme Fig

if nargin
  switch varargin{1}
   case 'tstep'

    if isempty(str2num(get(gcbo,'String')))
      set(gcbo,'String',num2str(Settings.tstep));
      fm_disp('Time step cannot be empty.',2)
    else
      oldtstep = Settings.tstep;
      Settings.tstep = str2num(get(gcbo,'String'));
      if Settings.tstep == 0
        Settings.tstep = oldtstep;
        set(gcbo,'String',num2str(Settings.tstep));
        fm_disp('Time step cannot be zero.',2)
      elseif Settings.tstep < 0
        Settings.tstep = oldtstep;
        set(gcbo,'String',num2str(Settings.tstep));
        fm_disp('Time step cannot be negative.',2)
      end
      fm_disp(['Time step set to ',num2str(Settings.tstep),' s'])
    end

   case 'deltadelta'

    if isempty(str2num(get(gcbo,'String')))
      set(gcbo,'String',num2str(Settings.deltadelta));
      fm_disp('Max delta diff. cannot be empty.',2)
    else
      olddiff = Settings.deltadelta;
      Settings.deltadelta = str2num(get(gcbo,'String'));
      if Settings.deltadelta == 0
        Settings.deltadelta = olddiff;
        set(gcbo,'String',num2str(Settings.deltadelta));
        fm_disp('Max delta diff. cannot be zero.',2)
      elseif Settings.deltadelta < 0
        Settings.deltadelta = olddiff;
        set(gcbo,'String',num2str(Settings.deltadelta));
        fm_disp('Max delta diff. cannot be negative.',2)
      end
      fm_disp(['Max delta diff. set to ',num2str(Settings.deltadelta),' s'])
    end

   case 'checkdelta'

    Settings.checkdelta = get(gcbo,'Value');
    hdl = findobj(gcf,'Tag','EditTextDelta');
    if Settings.checkdelta
      set(hdl,'Enable','on');
    else
      set(hdl,'Enable','off');
    end

   case 'simulink'

    Settings.simtd = get(gcbo,'Value');

   case 'forcepq'

    Settings.forcepq = get(gcbo,'Value');
    if Settings.pq2z
      hdl = findobj(gcf,'Tag','CheckboxPQ2Z');
      set(hdl,'Value',0)
      Settings.pq2z = 0;
      if ~Settings.pq2z && Settings.init
        global PQ
        PQ = noshunt_pq(PQ);
        fm_call('i');
      end
    end

   case 'pq2z'

    Settings.pq2z = get(gcbo,'Value');
    if Settings.forcepq
      hdl = findobj(gcf,'Tag','CheckboxForcePQ');
      set(hdl,'Value',0)
      Settings.forcepq = 0;
    end
    if ~Settings.pq2z && Settings.init
      global PQ
      PQ = noshunt_pq(PQ);
      fm_call('i');
    end

   case 'fixt'

    Settings.fixt = get(gcbo,'Value');
    hdl = findobj(gcf,'Tag','EditTextTimeStep');
    if Settings.fixt
      set(hdl,'Enable','on');
    else
      set(hdl,'Enable','off');
    end

   case 'setplot'

    Settings.plot = get(gcbo,'Value');
    hdlvar = findobj(gcbf,'Tag','PopupMenu2');
    if Settings.plot
      set(hdlvar,'Enable','on');
      set(hdlvar,'Value',1);
      Settings.plottype = 1;
    else
      set(hdlvar,'Enable','off');
    end

  end
  return
end

if ishandle(Fig.setting), figure(Fig.setting), return, end

methods = {'Backward Euler'; ...
           'Trapezoidal Rule'};
plottype = {'State Variables'; ...
            'Node Voltages'; ...
            'Node Phases'; ...
            'Active Power'; ...
            'Reactive Power'};
pfsolver = {'NR method', ...
            'XB fast decoupled', ...
            'BX fast decoupled', ...
            'Runge-Kutta method', ...
            'Iwamoto method', ...
            'Simple robust method'};

N = 10.75;
D = (N+3)*0.039+0.0244;
d1 = 1.1*1/(2*N+3);
d2 = 1.2*d1;

h0 = figure('Color',Theme.color01, ...
            'Units', 'normalized', ...
            'ColorMap', [], ...
            'CreateFcn','Fig.setting = gcf;', ...
            'DeleteFcn','Fig.setting = -1;', ...
            'FileName','fm_setting', ...
            'MenuBar','none', ...
            'Name','General Settings', ...
            'NumberTitle','off', ...
            'PaperPosition',[18 180 576 432], ...
            'PaperType','A4', ...
            'PaperUnits','points', ...
            'Position',sizefig(0.55,D), ...
            'RendererMode','manual', ...
            'Tag','Settings', ...
            'ToolBar','none', ...
            'UserData',Settings);

% Menu File
h1 = uimenu('Parent',h0, ...
            'Label','File', ...
            'Tag','MenuFile');
h2 = uimenu('Parent',h1, ...
            'Callback','close(gcf);', ...
            'Label','Save and Exit', ...
            'Tag','OTV', ...
            'Accelerator','s');
h2 = uimenu('Parent',h1, ...
            'Callback','Settings = get(gcf,''UserData''); close(gcf);', ...
            'Label','Discard and Exit', ...
            'Tag','NetSett', ...
            'Accelerator','x', ...
            'Separator','on');

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'ForegroundColor',Theme.color03, ...
               'Position',[0.038 d1 0.92 1-2*d1], ...
               'Style','frame', ...
               'Tag','Frame1');

d3 = 0.95*d1;

% Left-hand checkboxes
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.distrsw = get(gcbo,''Value'');', ...
               'Position',[0.078  5*d3  0.43  d2], ...
               'String','Use Distributed Slack Bus', ...
               'Style','checkbox', ...
               'Tag','Checkbox6', ...
               'Value',Settings.distrsw);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.static = get(gcbo,''Value'');', ...
               'Position',[0.078  6.5*d3  0.43  d2], ...
               'String','Discard Dynamic Comp.', ...
               'Style','checkbox', ...
               'Tag','Checkbox5', ...
               'Value',Settings.static);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_setting checkdelta', ...
               'Position',[0.078  18.5*d3  0.43  d2], ...
               'String','Stop TDs at max delta', ...
               'Style','checkbox', ...
               'Tag','Checkbox5', ...
               'Value',Settings.checkdelta);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.showlf = get(gcbo,''Value'');', ...
               'Position',[0.078  11*d3  0.43  d2], ...
               'String','Show Power Flow Results', ...
               'Style','checkbox', ...
               'Tag','Checkbox4', ...
               'Value',Settings.showlf);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.conv = get(gcbo,''Value'');', ...
               'Position',[0.078  9.5*d3  0.43  d2], ...
               'String','Check Component Bases', ...
               'Style','checkbox', ...
               'Tag','Checkbox3', ...
               'Value',Settings.conv);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_setting setplot', ...
               'Position',[0.078  14*d3  0.43  d2], ...
               'String','Plot during Simulation', ...
               'Style','checkbox', ...
               'Tag','Checkbox2', ...
               'Value',Settings.plot);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_setting simulink', ...
               'Position',[0.078  15.5*d3  0.43  d2], ...
               'String','Update Simulink during TD', ...
               'Style','checkbox', ...
               'Tag','CheckboxSimulink', ...
               'Value',Settings.simtd);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.coi = get(gcbo,''Value'');', ...
               'Position',[0.078  17*d3  0.43  d2], ...
               'String','Use Center of Inertia _coi(COI)', ...
               'Style','checkbox', ...
               'Tag','CheckboxCOI', ...
               'Value',Settings.coi);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.status = get(gcbo,''Value'');', ...
               'Position',[0.078  12.5*d3  0.43  d2], ...
               'String','Show Iteration Status', ...
               'Style','checkbox', ...
               'Tag','Checkbox1', ...
               'Value',Settings.status);
% VS computations: 'Callback', 'fm_setting setvscomp'
h1 = uicontrol('Parent',h0, ...
                'Units', 'normalized', ...
                'BackgroundColor',Theme.color02, ...
                'Callback','fm_setting forcepq', ...
                'Position',[0.078  8*d3  0.43  d2], ...
                'String','Force constant PQ loads', ...
                'Style','checkbox', ...
                'Tag','CheckboxForcePQ', ...
                'Value',Settings.forcepq);
if Settings.pq2z && Settings.forcepq
  set(h1,'Value',0)
  Settings.forcepq = 0;
end
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_setting pq2z', ...
               'Position',[0.078  3.5*d3  0.43  d2], ...
               'String','Convert PQ bus to Z', ...
               'Style','checkbox', ...
               'Tag','CheckboxPQ2Z', ...
               'Value',Settings.pq2z);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.pv2pq = get(gcbo,''Value'');', ...
               'Position',[0.078  2*d3  0.43  d2], ...
               'String','Check PV reactive limits', ...
               'Style','checkbox', ...
               'Tag','Checkbox9', ...
               'Value',Settings.pv2pq);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','fm_setting fixt', ...
               'Position',[0.078  20*d3  0.43  d2], ...
               'String','Fixed time step', ...
               'Style','checkbox', ...
               'Tag','Checkbox8', ...
               'Value',Settings.fixt);

if strcmp(Settings.platform,'MAC')
  dm = 0.01;
  aligntxt = 'center';
else
  dm = 0;
  aligntxt = 'left';
end


% Right-hand side
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings.beep = get(gcbo,''Value'');', ...
               'Position',[0.558     4*d1  0.356    d2], ...
               'String','Acoustic Signal', ...
               'Style','radiobutton', ...
               'Tag','RadioButton1', ...
               'Value',Settings.beep);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color04, ...
               'Callback','fm_setting tstep', ...
               'ForegroundColor',Theme.color05, ...
               'FontName',Theme.font01, ...
               'HorizontalAlignment',aligntxt, ...
               'Position',[0.558    18*d1   0.356   d2], ...
               'String',num2str(Settings.tstep), ...
               'Style','edit', ...
               'Tag','EditTextTimeStep');
if Settings.fixt
  set(h1,'Enable','on');
else
  set(h1,'Enable','off');
end
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'HorizontalAlignment','left', ...
               'Position',[0.558   19.25*d1  0.294  d2], ...
               'String','Time step [s]', ...
               'Style','text', ...
               'Tag','StaticText13');

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color04, ...
               'Callback','fm_setting deltadelta', ...
               'ForegroundColor',Theme.color05, ...
               'FontName',Theme.font01, ...
               'HorizontalAlignment',aligntxt, ...
               'Position',[0.558    15*d1   0.356   d2], ...
               'String',num2str(Settings.deltadelta), ...
               'Style','edit', ...
               'Tag','EditTextDelta');
if Settings.checkdelta
  set(h1,'Enable','on');
else
  set(h1,'Enable','off');
end
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'HorizontalAlignment','left', ...
               'Position',[0.558   16.25*d1  0.294  d2], ...
               'String','Max delta diff [deg.]', ...
               'Style','text', ...
               'Tag','StaticText13');


h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color04, ...
               'Callback','Settings.pfsolver = get(gcbo,''Value'');', ...
               'ForegroundColor',Theme.color05, ...
               'Position',[0.558    12*d1   0.356   d2], ...
               'String',pfsolver, ...
               'Style','popupmenu', ...
               'Tag','PopupMenu3', ...
               'Value',Settings.pfsolver);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'HitTest','off', ...
               'HorizontalAlignment','left', ...
               'Position',[0.558   13.25*d1    0.3   0.8*d2], ...
               'String','Power Flow Solver', ...
               'Style','text', ...
               'Tag','StaticText15');

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color04, ...
               'Callback','Settings.method = get(gcbo,''Value'');', ...
               'ForegroundColor',Theme.color05, ...
               'Position',[0.558    9*d1   0.356   d2], ...
               'String',methods, ...
               'Style','popupmenu', ...
               'Tag','PopupMenu1', ...
               'Value',Settings.method);
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'HitTest','off', ...
               'HorizontalAlignment','left', ...
               'ListboxTop',0, ...
               'Position',[0.558   10.25*d1  0.294  0.8*d2], ...
               'String','Integration Method', ...
               'Style','text', ...
               'Tag','StaticText12');

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color04, ...
               'Callback','Settings.plottype = get(gcbo,''Value'');', ...
               'ForegroundColor',Theme.color05, ...
               'Position',[0.558     6*d1  0.356    d2], ...
               'String',plottype, ...
               'Style','popupmenu', ...
               'Tag','PopupMenu2', ...
               'Value',Settings.plottype);
if Settings.plot
  set(h1,'Enable','On');
else
  set(h1,'Enable','Off');
end
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'HitTest','off', ...
               'HorizontalAlignment','left', ...
               'Position',[0.558   7.25*d1    0.3   0.8*d2], ...
               'String','Plotting Variables', ...
               'Style','text', ...
               'Tag','StaticText11');

if strcmp(Settings.platform,'MAC')
  d2 = 1.35*d2;
end

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color03, ...
               'Callback','close(gcf);', ...
               'FontWeight','bold', ...
               'ForegroundColor',Theme.color09, ...
               'Position',[0.558     2*d1    0.16   d2], ...
               'String','OK', ...
               'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color02, ...
               'Callback','Settings = get(gcf,''UserData''); close(gcf);', ...
               'Position',[0.754     2*d1   0.16  d2], ...
               'String','Cancel', ...
               'Tag','Pushbutton5');

if nargout > 0, fig = h0; end