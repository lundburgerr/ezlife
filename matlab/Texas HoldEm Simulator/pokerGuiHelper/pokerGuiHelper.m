function handRangeGenerator

%% Define sizes for different uicontrols in pixel (Gui Object Sizes)
GOS.gridSize = 13;
GOS.nodeWidth = 30; %px
GOS.nodeHeight = 30; %px
GOS.gridWidth = GOS.gridSize*GOS.nodeWidth;
GOS.gridHeight = GOS.gridSize*GOS.nodeHeight;

GOS.sliderWidth = GOS.gridSize*GOS.nodeWidth;
GOS.sliderHeight = 10;
GOS.sliderMargin = 8;

GOS.tableViewPanelWidth = 200;
GOS.tableViewPanelHeight = 250;

GOS.handRangeButtonsPanelWidth = 200;
GOS.handRangeButtonsPanelHeight = 150;

GOS.playerPanelWidth = 220;
GOS.playerPanelHeight = 40;
GOS.playerPanelMargin = 5;
GOS.playerPanelStackWidth = 70;
GOS.playerPanelStackHeight = GOS.playerPanelHeight - 2*GOS.playerPanelMargin;
GOS.playerPanelICMWidth = 30;
GOS.playerPanelICMHeight = GOS.playerPanelStackHeight;
GOS.playerPanelActionHeight = (GOS.playerPanelHeight-2*GOS.playerPanelMargin)/2;
GOS.playerPanelActionWidth = GOS.playerPanelActionHeight;

GOS.buttonGroupPlayerWidth = 20;
GOS.buttonGroupPlayerHeight = 10*GOS.playerPanelHeight + 9*GOS.playerPanelMargin;

GOS.handInformationPanelWidth = 300;
GOS.handInformationPanelHeight = (10*GOS.playerPanelHeight+9*GOS.playerPanelMargin)/2;

GOS.tournamentInfoPanelWidth = 300;
GOS.tournamentInfoPanelHeight = 100;

GOS.streetActionPanelWidth = 300;
GOS.streetActionPanelHeight = 300;

GOS.margin = 20;
GOS.guiWidth = GOS.gridWidth + GOS.tableViewPanelWidth + GOS.buttonGroupPlayerWidth + ...
            GOS.playerPanelWidth + 7*GOS.margin + GOS.handInformationPanelWidth + GOS.tournamentInfoPanelWidth;
GOS.guiHeight = GOS.gridHeight + 3*GOS.sliderHeight+3*GOS.sliderMargin + 2*GOS.margin;

%% Set initial values for gridProbability
gridProbability = zeros(GOS.gridSize, GOS.gridSize);

%% Create main GUI
%Create main figure
title_gui = 'Hand range generator';
gui = figure('Position', [100 50 GOS.guiWidth GOS.guiHeight], 'Name', title_gui, 'NumberTitle', 'off', 'Tag', 'gui');
set(gui, 'MenuBar', 'none', 'Resize','Off');
handles.gui = gui;
%guihandles(handles.f_gui);

%Create file menu
field = 'file_menu';
handles.(field) = uimenu(gui, 'Label', 'File', 'Tag', field);

field = 'file_export_to_workspace';
handles.(field) = uimenu(handles.file_menu, 'Label', 'Export hand range to workspace', 'Tag', field, ...
                    'Callback', @file_export_to_workspace_Callback);
                
%Create edit menu
field = 'edit_menu';
handles.(field) = uimenu(gui, 'Label', 'Edit', 'Tag', field);

field = 'edit_clear_handrange';
handles.(field) = uimenu(handles.edit_menu, 'Label', 'Clear hand range', 'Tag', field, ...
                    'Callback', @edit_clear_handrange_Callback);

%% Fill in GUI Objects
%Create card grid
handles = fill_card_grid(handles, gridProbability, GOS);
            
%Create panel containing information on table
handles = fill_tournament_info(handles, GOS);

%Create panel containing various preset choices for handrange selection
handles = fill_hand_range_selection(handles, GOS);
            
%Create radiobuttons for each player to select which handrange
handles = fill_player_selection_radio_buttons(handles, GOS);
       
%Create panels for each player
handles = fill_player_panels(handles, GOS);

%Create hand information for hero
handles = fill_hero_hand_information(handles, GOS);

%Create hand information for villains
handles = fill_villains_hand_information(handles, GOS);

%Tournament information panel
handles = fill_tournament_information(handles, GOS);

%Street action panel
handles = fill_street_action_view(handles, GOS);


%% Save guidata
gui_data.GOS = GOS;
gui_data.gridProbability = gridProbability;
gui_data.handles = handles;
gui_data.button_down = 0;
gui_data.addOrSubtract = 1;
guidata(handles.gui, gui_data);

end

%% Fill GUI with GUI-objects
function [handles, gridProbability] = fill_card_grid(handles, gridProbability, GOS)    
    Cards = {'A','K','Q','J','T','9','8','7','6','5','4','3','2'};
    for ii = 1:GOS.gridSize %Run over columns
        for jj = 1:GOS.gridSize %Run over rows
            field = sprintf('hand_field_%dx%d', jj, ii);
            position = [(ii-1)*GOS.nodeWidth+GOS.margin, GOS.guiHeight-GOS.margin-jj*GOS.nodeHeight, GOS.nodeWidth, GOS.nodeHeight];
            if jj>ii
                hand = sprintf('%s%ss\n(%.2f)', Cards{ii}, Cards{jj}, gridProbability(jj,ii));
            elseif jj==ii
                hand = sprintf('%s%s\n(%.2f)', Cards{ii}, Cards{jj}, gridProbability(jj,ii));
            else
                hand = sprintf('%s%so\n(%.2f)', Cards{jj}, Cards{ii}, gridProbability(jj,ii));
            end
            handles.(field) = uicontrol('Parent', handles.gui, 'Style', 'text', ...
                    'Position', position, ...
                    'enable', 'inactive', ...
                    'String', hand, 'Tag', field, ...
                    'FontSize', 7, ...
                    'BackgroundColor', 'white', ...
                    'ButtonDownFcn', @ButtonDownFcn_Callback);
            %set(handles.(field), 'ButtonDownFcn', @ButtonDownFcn_Callback);
            %guihandles(handles.(field));
        end
    end

    %% Create hand range sliders
    slider_startY = GOS.guiHeight-GOS.gridHeight - 2*GOS.sliderMargin - GOS.margin;
    slider_startX = GOS.margin;
    %Slider for suited hands
    field = 'slider_handRange';
    handles.(field) = uicontrol('Parent', handles.gui, 'Style', 'slider', ...
                    'Position', [slider_startX, slider_startY, GOS.sliderWidth, GOS.sliderHeight], ...
                    'Tag', field, ...
                    'Callback',  {@slider_handRange_Callback, 'suited'});

    %Slider for offsuited hands
    field = 'slider_handRange';
    handles.(field) = uicontrol('Parent', handles.gui, 'Style', 'slider', ...
                    'Position', [slider_startX, slider_startY-2*GOS.sliderMargin, GOS.sliderWidth, GOS.sliderHeight], ...
                    'Tag', field, ...
                    'Callback',  {@slider_handRange_Callback, 'offsuited'});

    %Slider for pocket pairs
    field = 'slider_handRange';
    handles.(field) = uicontrol('Parent', handles.gui, 'Style', 'slider', ...
                    'Position', [slider_startX, slider_startY-4*GOS.sliderMargin, GOS.sliderWidth, GOS.sliderHeight], ...
                    'Tag', field, ...
                    'Callback',  {@slider_handRange_Callback, 'pocket'});
                
    %Set callbacks for button down on grid
    set(handles.gui,'ButtonDownFcn',@ButtonDownFcn_Callback);
end

function handles = fill_tournament_info(handles, GOS)
    panel_startX = (GOS.gridWidth + 2*GOS.margin)/GOS.guiWidth;
    panel_startY = (GOS.guiHeight - GOS.tableViewPanelHeight - 0.5*GOS.margin)/GOS.guiHeight;
    field_panel = 'tableViewPanel';
    handles.(field_panel) = uipanel('FontSize',8,...
        'Title', 'Table view', 'Tag', field_panel, ...
        'Position',[panel_startX, panel_startY, GOS.tableViewPanelWidth/GOS.guiWidth, GOS.tableViewPanelHeight/GOS.guiHeight]);
end

function handles = fill_hand_range_selection(handles, GOS)
    panel_startX = (GOS.gridWidth + 2*GOS.margin)/GOS.guiWidth;
    panel_startY = (GOS.guiHeight - GOS.handRangeButtonsPanelHeight - GOS.tableViewPanelHeight - 1*GOS.margin)/GOS.guiHeight;
    field_panel = 'handRangeButtonsPanel';
    handles.(field_panel) = uipanel('FontSize',8,...
        'Title', 'Hand range selection', 'Tag', field_panel, ...
        'Position',[panel_startX, panel_startY, GOS.handRangeButtonsPanelWidth/GOS.guiWidth, GOS.handRangeButtonsPanelHeight/GOS.guiHeight]);
end

function handles = fill_player_selection_radio_buttons(handles, GOS)
    buttongroup_startY = GOS.margin/GOS.guiHeight;
    buttongroup_startX = (GOS.gridWidth + GOS.tableViewPanelWidth + 3*GOS.margin)/GOS.guiWidth;
    field_bg = 'buttongroup_player';
    handles.(field_bg) = uibuttongroup('Tag', field_bg, ...
        'Position',[buttongroup_startX, buttongroup_startY, GOS.buttonGroupPlayerWidth/GOS.guiWidth, GOS.buttonGroupPlayerHeight/GOS.guiHeight],...
        'SelectionChangedFcn',@buttongroup_player_Callback);
    for p = 1:10
        field = sprintf('radiobutton_player%d', p);
        handles.(field) = uicontrol(handles.(field_bg),'Style', 'radiobutton',...
            'Tag', field, 'Position', ...
            [0, GOS.buttonGroupPlayerHeight-(p-1/4)*(GOS.playerPanelHeight)-(p-1)*GOS.playerPanelMargin, GOS.buttonGroupPlayerWidth, GOS.buttonGroupPlayerWidth]...
            );
    end
end

function handles = fill_player_panels(handles, GOS)
    panel_startY = (GOS.guiHeight - 3*GOS.margin)/GOS.guiHeight;
    panel_startX = (GOS.gridWidth + GOS.tableViewPanelWidth + 3*GOS.margin + GOS.buttonGroupPlayerWidth)/GOS.guiWidth;
    panel_deltaY = (GOS.playerPanelHeight+GOS.playerPanelMargin)/GOS.guiHeight;

    for p = 1:10
        field_panel = sprintf('panel_player%d', p);
        handles.(field_panel) = uipanel('FontSize',8,...
                     'Tag', field_panel, ...
                     'Position',[panel_startX, panel_startY-(p-1)*panel_deltaY, ...
                                GOS.playerPanelWidth/GOS.guiWidth, GOS.playerPanelHeight/GOS.guiHeight]);

        %Field with stack sizes
        field = sprintf('stack_player%d', p);
        handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'edit', ...
            'Position', [0, GOS.playerPanelHeight-GOS.playerPanelStackHeight-GOS.playerPanelMargin, ...
                        GOS.playerPanelStackWidth, GOS.playerPanelStackHeight], ...
            'String', '1500');

        %Field with chips put in the pot for player
        field = sprintf('chipsPlayed_player%d', p);
        handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'edit', ...
            'Position', [GOS.playerPanelStackWidth+GOS.playerPanelMargin, GOS.playerPanelHeight-GOS.playerPanelStackHeight-GOS.playerPanelMargin, ...
                        GOS.playerPanelStackWidth, GOS.playerPanelStackHeight], ...
            'String', '0');

        %Action buttons
        field = sprintf('raiseButton_player%d', p);
        handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'pushbutton', ...
            'Position', [2*GOS.playerPanelStackWidth+2*GOS.playerPanelMargin, GOS.playerPanelHeight-GOS.playerPanelMargin-GOS.playerPanelActionHeight, ...
                        GOS.playerPanelActionWidth, GOS.playerPanelActionHeight], ...
            'BackgroundColor', 'Red', ...
            'String', 'R');
        field = sprintf('callButton_player%d', p);
        handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'pushbutton', ...
            'Position', [2*GOS.playerPanelStackWidth+2*GOS.playerPanelMargin, GOS.playerPanelHeight-GOS.playerPanelMargin-2*GOS.playerPanelActionHeight, ...
                        GOS.playerPanelActionWidth, GOS.playerPanelActionHeight], ...
            'BackgroundColor', 'Green', ...
            'String', 'C');
        field = sprintf('foldButton_player%d', p);
        handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'pushbutton', ...
            'Position', [2*GOS.playerPanelStackWidth+2*GOS.playerPanelMargin+GOS.playerPanelActionWidth, GOS.playerPanelHeight-GOS.playerPanelMargin-1.5*GOS.playerPanelActionHeight, ...
                        GOS.playerPanelActionWidth, GOS.playerPanelActionHeight], ...
            'BackgroundColor', 'yellow', ...
            'String', 'F');

        %Field with ICM for player
        field = sprintf('chipsPlayed_player%d', p);
        position = [2*GOS.playerPanelStackWidth+3*GOS.playerPanelMargin+2*GOS.playerPanelActionWidth, GOS.playerPanelHeight-GOS.playerPanelICMHeight-GOS.playerPanelMargin, ...
                    GOS.playerPanelICMWidth, GOS.playerPanelICMHeight];
        handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'text', ...
            'Position', position, ...
            'BackgroundColor', 'white', ...
            'String', '0%');
    end
end

function handles = fill_hero_hand_information(handles, GOS)
panel_startX = (GOS.gridWidth + GOS.tableViewPanelWidth + 4*GOS.margin + GOS.buttonGroupPlayerWidth + GOS.playerPanelWidth)/GOS.guiWidth;
panel_startY = (GOS.guiHeight - GOS.handInformationPanelHeight - 0.5*GOS.margin)/GOS.guiHeight;
field_panel = 'heroHandInformation';
handles.(field_panel) = uipanel('FontSize',8,...
    'Title', 'Hero hand information', 'Tag', field_panel, ...
    'Position',[panel_startX, panel_startY, GOS.handInformationPanelWidth/GOS.guiWidth, GOS.handInformationPanelHeight/GOS.guiHeight]);
end

function handles = fill_villains_hand_information(handles, GOS)
    panel_startX = (GOS.gridWidth + GOS.tableViewPanelWidth + 4*GOS.margin + GOS.buttonGroupPlayerWidth +GOS. playerPanelWidth)/GOS.guiWidth;
    panel_startY = (GOS.guiHeight - 2*GOS.handInformationPanelHeight - 1*GOS.margin)/GOS.guiHeight;
    field_panel = 'villainsHandInformation';
    handles.(field_panel) = uipanel('FontSize',8,...
        'Title', 'Villains hand information', 'Tag', field_panel, ...
        'Position',[panel_startX, panel_startY, GOS.handInformationPanelWidth/GOS.guiWidth, GOS.handInformationPanelHeight/GOS.guiHeight]);
end

function handles = fill_tournament_information(handles, GOS)
    panel_startX = (GOS.gridWidth + GOS.tableViewPanelWidth + 5*GOS.margin + GOS.buttonGroupPlayerWidth + GOS.playerPanelWidth + GOS.handInformationPanelWidth)/GOS.guiWidth;
    panel_startY = (GOS.guiHeight - GOS.tournamentInfoPanelHeight - 0.5*GOS.margin)/GOS.guiHeight;
    field_panel = 'tournamentInformationPanel';
    handles.(field_panel) = uipanel('FontSize',8,...
        'Title', 'Tournament information', 'Tag', field_panel, ...
        'Position',[panel_startX, panel_startY, GOS.tournamentInfoPanelWidth/GOS.guiWidth, GOS.tournamentInfoPanelHeight/GOS.guiHeight]);
end

function handles = fill_street_action_view(handles, GOS)
    panel_startX = (GOS.gridWidth + GOS.tableViewPanelWidth + 5*GOS.margin + GOS.buttonGroupPlayerWidth + GOS.playerPanelWidth + GOS.handInformationPanelWidth)/GOS.guiWidth;
    panel_startY = (GOS.guiHeight - GOS.tournamentInfoPanelHeight - GOS.streetActionPanelHeight - 1*GOS.margin)/GOS.guiHeight;
    field_panel = 'streetActionViewPanel';
    handles.(field_panel) = uipanel('FontSize',8,...
        'Title', 'Street action view', 'Tag', field_panel, ...
        'Position',[panel_startX, panel_startY, GOS.streetActionPanelWidth/GOS.guiWidth, GOS.streetActionPanelHeight/GOS.guiHeight]);
end



