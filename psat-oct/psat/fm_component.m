function fig = fm_component(varargin)
% FM_COMPONENT create GUI for UDM browser
%
% FM_COMPONENT()
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    12-Feb-2003
%Update:    15-Sep-2003
%Version:   1.0.2
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2016 Federico Milano

global Settings Path Theme Fig

if nargin
  if ~exist('Fig'), Fig.comp = -1, end
  if ~ishandle(Fig.comp)
    Fig.comp = findobj(get(0,'Children'),'FileName','fm_component');
  end
  switch varargin{1}

   case 'cbdown'

    pos = get(Fig.comp,'CurrentPoint');
    if pos(1) > 0.100 && pos(2) > 0.083 && pos(1) < 0.447 && pos(2) < 0.375
      if strcmp(get(Fig.comp,'SelectionType'),'open'),
        fm_about
      end
    end

   case 'cbmotion'

    if Settings.hostver >= 7.01
      pointer = 'hand';
    else
      pointer = 'crosshair';
    end

    pos = get(Fig.comp,'CurrentPoint');
    if pos(1) > 0.100 && pos(2) > 0.083 && pos(1) < 0.447 && pos(2) < 0.375
      set(Fig.comp,'Pointer',pointer);
    else
      set(Fig.comp,'Pointer','arrow');
    end

   case 'load'

    values = get(gcbo,'Value');
    set(gcbo,'Value',values(end))
    if strcmp(get(Fig.comp,'SelectionType'),'open'),
      fm_comp cload,
    end

  end
  return
end

h0 = figure('Units','normalized', ...
  'Color',Theme.color01, ...
  'Colormap',[], ...
  'CreateFcn','Fig.comp=gcf;', ...
  'DeleteFcn','Fig.comp=0;', ...
  'FileName','fm_component', ...
  'MenuBar','none', ...
  'Name','Component Browser', ...
  'NumberTitle','off', ...
  'PaperPosition',[18 180 576 432], ...
  'PaperUnits','points', ...
  'Position',sizefig(0.3195,0.4619), ...
  'Resize','on', ...
  'ToolBar','none', ...
  'WindowButtonDownFcn','fm_component cbdown', ...
  'WindowButtonMotionFcn','fm_component cbmotion');

% Menu
h1 = uimenu('Parent',h0, ...
  'Label','File', ...
  'Tag','MenuFile');
h2 = uimenu('Parent',h1, ...
  'Callback','fm_make, fm_new', ...
  'Label','New Component', ...
  'Tag','FileOpen', ...
  'Accelerator','n');
h2 = uimenu('Parent',h1, ...
  'Callback','close(gcf)', ...
  'Label','Close', ...
  'Tag','FileClos', ...
  'Accelerator','x');

h1 = uimenu('Parent',h0, ...
  'Label','Edit', ...
  'Tag','MenuFile');
h2 = uimenu('Parent',h1, ...
  'Callback','fm_comp cload', ...
  'Label', 'Load', ...
  'Tag','Editload', ...
  'Accelerator','l');
h2 = uimenu('Parent',h1, ...
  'Callback','fm_comp cbuild', ...
  'Label', 'Build', ...
  'Tag','Editbuil', ...
  'Accelerator','b');
h2 = uimenu('Parent',h1, ...
  'Callback','fm_comp cinstall', ...
  'Label', 'Install', ...
  'Tag','Editinst', ...
  'Accelerator','i');
h2 = uimenu('Parent',h1, ...
  'Callback','fm_comp cuninstall', ...
  'Label', 'Uninstall', ...
  'Tag','Editunin','Accelerator','u');

% Component Browser picture
h1 = axes('Parent',h0, ...
  'Box','on', ...
  'CameraUpVector',[0 1 0], ...
  'CameraUpVectorMode','manual', ...
  'Color',Theme.color04, ...
  'ColorOrder',Settings.color, ...
  'Layer','top', ...
  'Position',[0.100 0.083 0.347 0.292], ...
  'Tag','Axes1', ...
  'XColor',Theme.color03, ...
  'XLim',[0.5 111.5], ...
  'XLimMode','manual', ...
  'XTickMode','manual', ...
  'YColor',Theme.color03, ...
  'YDir','reverse', ...
  'YLim',[0.5 92.5], ...
  'YLimMode','manual', ...
  'YTickMode','manual', ...
  'ZColor',Theme.color05);
h2 = image('Parent',h1, ...
  'CData',imread([Path.images,'comp_wind.jpg'],'jpg'), ...
  'Tag','Axes1Image1', ...
  'XData',[1 111], ...
  'YData',[1 92]);

% Push buttons for general purposes
h1 = uicontrol('Parent',h0, ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color03, ...
  'Callback','fm_make, fm_new', ...
  'FontWeight','bold', ...
  'ForegroundColor',Theme.color09, ...
  'Position',[0.540 0.239 0.361 0.102], ...
  'String','New Component', ...
  'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'Callback','close(gcf);', ...
  'Position',[0.540 0.107 0.361 0.102], ...
  'String','Close', ...
  'Tag','Pushbutton2');

% Frame and static text for the component browser
h1 = uicontrol('Parent',h0, ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'ForegroundColor',Theme.color03, ...
  'Position',[0.100 0.410 0.800 0.509], ...
  'Style','frame', ...
  'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'FontName',Theme.font01, ...
  'FontSize',14, ...
  'ForegroundColor',Theme.color05, ...
  'HorizontalAlignment','left', ...
  'Position',[0.151 0.812 0.580 0.075], ...
  'String','Component Browser', ...
  'Style','text', ...
  'Tag','StaticText1');

% Component listbox and UIContextMenu
h1 = uicontrol('Parent',h0, ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color03, ...
  'Callback','fm_component load', ...
  'CreateFcn','fm_comp clist', ...
  'FontName',Theme.font01, ...
  'ForegroundColor',Theme.color06, ...
  'Position',[0.145 0.450 0.55 0.343], ...
  'Max', 201, ...
  'String',cell(0,1), ...
  'Style','listbox', ...
  'Tag','Listbox1', ...
  'UIContextMenu',uicontextmenu, ...
  'Value',1);
h2 = get(h1,'UIContextMenu');
h3 = uimenu('Parent',h2, ...
  'Callback','fm_comp cload', ...
  'Label', 'Load', ...
  'Tag','Cload');
h3 = uimenu('Parent',h2, ...
  'Callback','fm_comp cbuild', ...
  'Label', 'Build', ...
  'Tag','Cbuil');
h3 = uimenu('Parent',h2, ...
  'Callback','fm_comp cinstall', ...
  'Label', 'Install', ...
  'Tag','Cinst');
h3 = uimenu('Parent',h2, ...
  'Callback','fm_comp cuninstall', ...
  'Label', 'Uninstall', ...
  'Tag','Cunin');

% Push button for operation on the components
h1 = uicontrol('Parent',h0, ...
  'CData',fm_mat('comp_load'), ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'Callback','fm_comp cload', ...
  'Position',[0.75 0.7074 0.0930 0.0858], ...
  'TooltipString','Load', ...
  'Tag','Pushbutton3');
h1 = uicontrol('Parent',h0, ...
  'CData',fm_mat('comp_build'), ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'Callback','fm_comp cbuild', ...
  'Position',[0.75 0.6216 0.0930 0.0858], ...
  'TooltipString','Build', ...
  'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
  'CData',fm_mat('comp_install'), ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'Callback','fm_comp cinstall', ...
  'Position',[0.75 0.5358 0.0930 0.0858], ...
  'TooltipString','Install', ...
  'Tag','Pushbutton5');
h1 = uicontrol('Parent',h0, ...
  'CData',fm_mat('comp_uninstall'), ...
  'Units','normalized', ...
  'BackgroundColor',Theme.color02, ...
  'Callback','fm_comp cuninstall', ...
  'Position',[0.75 0.450 0.0930 0.0858], ...
  'TooltipString','Uninstall', ...
  'Tag','Pushbutton6');

if nargout > 0, fig = h0; end