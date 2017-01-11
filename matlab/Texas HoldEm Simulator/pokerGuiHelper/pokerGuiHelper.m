function handRangeGenerator

global button_down;
global GUI_DATA;
button_down = 0;

Cards = {'A','K','Q','J','T','9','8','7','6','5','4','3','2'};

%% Define sizes for different uicontrols in pixel
gridSize = 13;
nodeWidth = 30; %px
nodeHeight = 30; %px
gridWidth = gridSize*nodeWidth;
gridHeight = gridSize*nodeHeight;

sliderWidth = gridSize*nodeWidth;
sliderHeight = 10;
sliderMargin = 8;

playerPanelWidth = 220;
playerPanelHeight = 40;
playerPanelMargin = 5;
playerPanelStackWidth = 70;
playerPanelStackHeight = playerPanelHeight - 2*playerPanelMargin;
playerPanelICMWidth = 30;
playerPanelICMHeight = playerPanelStackHeight;
playerPanelActionHeight = (playerPanelHeight-2*playerPanelMargin)/2;
playerPanelActionWidth = playerPanelActionHeight;

buttonGroupPlayerWidth = 20;
buttonGroupPlayerHeight = 10*playerPanelHeight + 9*playerPanelMargin;

handInformationPanelWidth = 300;
handInformationPanelHeight = (10*playerPanelHeight+9*playerPanelMargin)/2;

margin = 20;
guiWidth = gridWidth + buttonGroupPlayerWidth + playerPanelWidth + 6*margin + handInformationPanelWidth;
guiHeight = gridHeight + 3*sliderHeight+3*sliderMargin + 2*margin;
gridProbability = zeros(gridSize, gridSize);

%% Create main GUI
%Create main figure
title_gui = 'Hand range generator';
gui = figure('Position', [100 50 guiWidth guiHeight], 'Name', title_gui, 'NumberTitle', 'off', 'Tag', 'gui');
set(gui, 'MenuBar', 'none', 'Resize','Off');
handles.gui = gui;
%guihandles(handles.f_gui);

%% Create file menu
field = 'file_menu';
handles.(field) = uimenu(gui, 'Label', 'File', 'Tag', field);

field = 'file_export_to_workspace';
handles.(field) = uimenu(handles.file_menu, 'Label', 'Export hand range to workspace', 'Tag', field, ...
                    'Callback', @file_export_to_workspace_Callback);
                
%% Create edit menu
field = 'edit_menu';
handles.(field) = uimenu(gui, 'Label', 'Edit', 'Tag', field);

field = 'edit_clear_handrange';
handles.(field) = uimenu(handles.edit_menu, 'Label', 'Clear hand range', 'Tag', field, ...
                    'Callback', @edit_clear_handrange_Callback);
                
%% Create hand range sliders
slider_startY = guiHeight-gridHeight - 2*sliderMargin - margin;
slider_startX = margin;
%Slider for suited hands
field = 'slider_handRange';
handles.(field) = uicontrol('Parent', gui, 'Style', 'slider', ...
                'Position', [slider_startX, slider_startY, sliderWidth, sliderHeight], ...
                'Tag', field, ...
                'Callback',  {@slider_handRange_Callback, 'suited'});

%Slider for offsuited hands
field = 'slider_handRange';
handles.(field) = uicontrol('Parent', gui, 'Style', 'slider', ...
                'Position', [slider_startX, slider_startY-2*sliderMargin, sliderWidth, sliderHeight], ...
                'Tag', field, ...
                'Callback',  {@slider_handRange_Callback, 'offsuited'});

%Slider for pocket pairs
field = 'slider_handRange';
handles.(field) = uicontrol('Parent', gui, 'Style', 'slider', ...
                'Position', [slider_startX, slider_startY-4*sliderMargin, sliderWidth, sliderHeight], ...
                'Tag', field, ...
                'Callback',  {@slider_handRange_Callback, 'pocket'});
            
%% Create radiobuttons for each player to select which handrange
buttongroup_startY = margin/guiHeight;
buttongroup_startX = (gridWidth + 2*margin)/guiWidth;
field_bg = 'buttongroup_player';
handles.(field_bg) = uibuttongroup(...
                  'Position',[buttongroup_startX, buttongroup_startY, buttonGroupPlayerWidth/guiWidth, buttonGroupPlayerHeight/guiHeight],...
                  'SelectionChangedFcn',@buttongroup_player_Callback);
for p = 1:10
    field = sprintf('radiobutton_player%d', p);
    handles.(field) = uicontrol(handles.(field_bg),'Style', 'radiobutton',...
                    'Position', ...
                    [0, buttonGroupPlayerHeight-(p-1/4)*(playerPanelHeight)-(p-1)*playerPanelMargin, buttonGroupPlayerWidth, buttonGroupPlayerWidth]...
                    );
end
            
%% Create panels for each player
panel_startY = (guiHeight - 3*margin)/guiHeight;
panel_startX = (gridWidth + 2*margin + buttonGroupPlayerWidth)/guiWidth;
panel_deltaY = (playerPanelHeight+playerPanelMargin)/guiHeight;

for p = 1:10
    field_panel = sprintf('panel_player%d', p);
    handles.(field_panel) = uipanel('FontSize',8,...
                 'Tag', field, ...
                 'Position',[panel_startX, panel_startY-(p-1)*panel_deltaY, playerPanelWidth/guiWidth, playerPanelHeight/guiHeight]);

    %Field with stack sizes
    field = sprintf('stack_player%d', p);
    handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'edit', ...
        'Position', [0, playerPanelHeight-playerPanelStackHeight-playerPanelMargin, playerPanelStackWidth, playerPanelStackHeight], ...
        'String', '1500');

    %Field with chips put in the pot for player
    field = sprintf('chipsPlayed_player%d', p);
    handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'edit', ...
        'Position', [playerPanelStackWidth+playerPanelMargin, playerPanelHeight-playerPanelStackHeight-playerPanelMargin, playerPanelStackWidth, playerPanelStackHeight], ...
        'String', '0');

    %Action buttons
    field = sprintf('raiseButton_player%d', p);
    handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'pushbutton', ...
        'Position', [2*playerPanelStackWidth+2*playerPanelMargin, playerPanelHeight-playerPanelMargin-playerPanelActionHeight, playerPanelActionWidth, playerPanelActionHeight], ...
        'BackgroundColor', 'Red', ...
        'String', 'R');
    field = sprintf('callButton_player%d', p);
    handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'pushbutton', ...
        'Position', [2*playerPanelStackWidth+2*playerPanelMargin, playerPanelHeight-playerPanelMargin-2*playerPanelActionHeight, playerPanelActionWidth, playerPanelActionHeight], ...
        'BackgroundColor', 'Green', ...
        'String', 'C');
    field = sprintf('foldButton_player%d', p);
    handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'pushbutton', ...
        'Position', [2*playerPanelStackWidth+2*playerPanelMargin+playerPanelActionWidth, playerPanelHeight-playerPanelMargin-1.5*playerPanelActionHeight, playerPanelActionWidth, playerPanelActionHeight], ...
        'BackgroundColor', 'yellow', ...
        'String', 'F');

    %Field with ICM for player
    field = sprintf('chipsPlayed_player%d', p);
    position = [2*playerPanelStackWidth+3*playerPanelMargin+2*playerPanelActionWidth, playerPanelHeight-playerPanelICMHeight-playerPanelMargin, playerPanelICMWidth, playerPanelICMHeight];
    handles.(field) = uicontrol('Parent', handles.(field_panel), 'Style', 'text', ...
        'Position', position, ...
        'BackgroundColor', 'white', ...
        'String', '0%');
end

%% Create hand information for hero
panel_startX = (gridWidth + 3*margin + buttonGroupPlayerWidth + playerPanelWidth)/guiWidth;
panel_startY = (guiHeight - handInformationPanelHeight - 0.5*margin)/guiHeight;
field_panel = sprintf('panel_player%d', p);
handles.(field_panel) = uipanel('FontSize',8,...
    'Title', 'Hero hand information', 'Tag', field, ...
    'Position',[panel_startX, panel_startY, handInformationPanelWidth/guiWidth, handInformationPanelHeight/guiHeight]);

%% Create hand information for villains
panel_startX = (gridWidth + 3*margin + buttonGroupPlayerWidth + playerPanelWidth)/guiWidth;
panel_startY = (guiHeight - 2*handInformationPanelHeight - 1*margin)/guiHeight;
field_panel = sprintf('panel_player%d', p);
handles.(field_panel) = uipanel('FontSize',8,...
    'Title', 'Villains hand information', 'Tag', field, ...
    'Position',[panel_startX, panel_startY, handInformationPanelWidth/guiWidth, handInformationPanelHeight/guiHeight]);

%% Street action view


%% Create card grid
for ii = 1:gridSize %Run over columns
    for jj = 1:gridSize %Run over rows
        field = sprintf('hand_field_%dx%d', jj, ii);
        position = [(ii-1)*nodeWidth+margin, guiHeight-margin-jj*nodeHeight, nodeWidth, nodeHeight];
        if jj>ii
            hand = sprintf('%s%ss\n(%.2f)', Cards{ii}, Cards{jj}, gridProbability(jj,ii));
        elseif jj==ii
            hand = sprintf('%s%s\n(%.2f)', Cards{ii}, Cards{jj}, gridProbability(jj,ii));
        else
            hand = sprintf('%s%so\n(%.2f)', Cards{jj}, Cards{ii}, gridProbability(jj,ii));
        end
        handles.(field) = uicontrol('Parent', gui, 'Style', 'text', ...
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

%Save guidata
gui_data.guiWidth = guiWidth;
gui_data.guiHeight = guiHeight;
gui_data.gridSize = gridSize;
gui_data.nodeWidth = nodeWidth; %px
gui_data.nodeHeight = nodeHeight; %px
gui_data.margin = margin;
gui_data.gridProbability = gridProbability;
gui_data.handles = handles;
GUI_DATA = gui_data;

%Set callbacks
set(gui,'ButtonDownFcn',@ButtonDownFcn_Callback);

end


function ButtonDownFcn_Callback(hObject, eventdata)
    global button_down;
    global GUI_DATA;

    %Already pushed?
    if button_down
        return;
    end
    button_down = 1;
    
    %Get GUI handles
    %gui_data = guidata(hObject);
    handles = GUI_DATA.handles;
    
    %% Add callbacks to figure for moving the point
    mousebutton = get(gcf, 'SelectionType');
    if strcmp(mousebutton, 'normal')   %Left click -- Add probability
        GUI_DATA.addOrSubtract = 1;
        %guidata(handles.gui, gui_data);
        set(handles.gui, 'Interruptible', 'off')
        set(handles.gui,'WindowButtonUpFcn',@WindowButtonUpFcn_Callback);
        set(handles.gui,'WindowButtonMotionFcn',@WindowButtonMotionFcn_Callback);
    elseif strcmp(mousebutton, 'alt') %Right click -- Subtract probability
        GUI_DATA.addOrSubtract = -1;
        %guidata(handles.gui, gui_data);
        set(handles.gui, 'Interruptible', 'off')
        set(handles.gui,'WindowButtonUpFcn',@WindowButtonUpFcn_Callback);
        set(handles.gui,'WindowButtonMotionFcn',@WindowButtonMotionFcn_Callback);
    end
end

%Remove callbacks for moving
function WindowButtonUpFcn_Callback(hObject, eventdata)
    global button_down;
    global GUI_DATA;

    handles = GUI_DATA.handles;
    set(handles.gui, 'Interruptible', 'on')
    set(handles.gui,'WindowButtonUpFcn','');
    set(handles.gui,'WindowButtonMotionFcn','');
    button_down = 0;
end

%Add or subtract 
function WindowButtonMotionFcn_Callback(hObject, eventdata)
    persistent delay_last_change;
    global GUI_DATA;
    handles = GUI_DATA.handles;
    addOrSubtract = GUI_DATA.addOrSubtract;

    %Initialize persistent variable
    if isempty(delay_last_change)
        delay_last_change = clock();
    end
    
    if etime(clock(), delay_last_change) < 0.02
        return;
    end
    
    %Get current grid point
    C = hObject.CurrentPoint; %hObject.SelectionType
    jj = floor((GUI_DATA.guiHeight-GUI_DATA.margin-C(2))/GUI_DATA.nodeWidth) + 1; %Which row?
    ii = floor((C(1)-GUI_DATA.margin)/GUI_DATA.nodeWidth) + 1;                    %Which column?
    
    %Add/Subtract probability to current grid point
    if( ii >= 1 && ii <= GUI_DATA.gridSize && ...
            jj >= 1 && jj <= GUI_DATA.gridSize)
%         GUI_DATA.gridProbability(jj, ii) = GUI_DATA.gridProbability(jj, ii) + addOrSubtract*0.05;
%         GUI_DATA.gridProbability(jj, ii) = min(GUI_DATA.gridProbability(jj, ii), 1);
%         GUI_DATA.gridProbability(jj, ii) = max(GUI_DATA.gridProbability(jj, ii), 0);
        
        %% TODO Move nearby points
        %Create distance matrix from center
        square_size = 3;
        fall_off_constant = 1; %The higher the faster
        middle_ind = floor(square_size/2)+1;
        distance_matrix = zeros(square_size);
        for nx = 1:square_size
            for ny = 1:square_size
                if ii == jj
                    if nx == ny
                        distance_matrix(ny,nx) = sqrt((middle_ind-nx)^2 + (middle_ind-ny)^2)^fall_off_constant;
                    else
                        distance_matrix(ny,nx) = inf;
                    end
                elseif ii > jj
                    if ii+nx > jj+ny
                        distance_matrix(ny,nx) = sqrt((middle_ind-nx)^2 + (middle_ind-ny)^2)^fall_off_constant;
                    else
                        distance_matrix(ny,nx) = inf;
                    end
                elseif ii < jj
                    if ii+nx < jj+ny
                        distance_matrix(ny,nx) = sqrt((middle_ind-nx)^2 + (middle_ind-ny)^2)^fall_off_constant;
                    else
                        distance_matrix(ny,nx) = inf;
                    end
                end
            end
        end
        
        %Create gaussian distr. matrix relative to middle
        exp_mat = exp(-(distance_matrix));
        
        %Move surrounding points in a logarithmic fashion
        dp = 0.05; %change in probability at middle
        dp_mat = dp*exp_mat;
        for nx = -floor(square_size/2):floor(square_size/2)
            if ii+nx < 1 || ii+nx > GUI_DATA.gridSize, continue; end
            for ny = -floor(square_size/2):floor(square_size/2)
                if jj+ny < 1 || jj+ny > GUI_DATA.gridSize, continue; end
                dp_ind_y = ny + floor(square_size/2) + 1;
                dp_ind_x = nx + floor(square_size/2) + 1;
                GUI_DATA.gridProbability(jj+ny, ii+nx) = GUI_DATA.gridProbability(jj+ny, ii+nx) + addOrSubtract*dp_mat(dp_ind_y, dp_ind_x);
                GUI_DATA.gridProbability(jj+ny, ii+nx) = min(GUI_DATA.gridProbability(jj+ny, ii+nx), 1);
                GUI_DATA.gridProbability(jj+ny, ii+nx) = max(GUI_DATA.gridProbability(jj+ny, ii+nx), 0);
                
                field = sprintf('hand_field_%dx%d', jj+ny, ii+nx);
                inverted_green = [1 0.4 0.9];
                set(handles.(field), 'BackgroundColor', [1, 1, 1] - inverted_green*GUI_DATA.gridProbability(jj+ny, ii+nx))
                text_string = get(handles.(field), 'String');
                text_string(2,:) = sprintf('(%.2f)', GUI_DATA.gridProbability(jj+ny, ii+nx));
                set(handles.(field), 'String', text_string);
            end
        end
        
        delay_last_change = clock();
    end
end

function file_export_to_workspace_Callback(hObject, eventdata)
    global GUI_DATA;
%     handRange = [];
%     for ii = 1:GUI_DATA.gridSize %Run over columns
%         for jj = 1:GUI_DATA.gridSize %Run over rows
%             if jj>ii
% %                 hand = sprintf('%s%ss\n(%.2f)', Cards{ii}, Cards{jj}, gridProbability(jj,ii));
%             elseif jj==ii
% %                 hand = sprintf('%s%s\n(%.2f)', Cards{ii}, Cards{jj}, gridProbability(jj,ii));
%             else
% %                 hand = sprintf('%s%so\n(%.2f)', Cards{jj}, Cards{ii}, gridProbability(jj,ii));
%             end
%             handles.(field) = uicontrol('Parent', gui, 'Style', 'text', ...
%                 'Position', position, ...
%                 'enable', 'inactive', ...
%                 'String', hand, 'Tag', field, ...
%                 'ButtonDownFcn', @ButtonDownFcn_Callback);
%             %set(handles.(field), 'ButtonDownFcn', @ButtonDownFcn_Callback);
%             %guihandles(handles.(field));
%         end
%     end
    assignin('base', 'handRange', GUI_DATA.gridProbability);
    delete(hObject);
end

function edit_clear_handrange_Callback(hObject, eventdata)
    global GUI_DATA;
    handles = GUI_DATA.handles;
    square_size = 13;
    for nx = 1:square_size
        for ny = 1:square_size
            GUI_DATA.gridProbability(ny, nx) = 0;
            field = sprintf('hand_field_%dx%d', ny, nx);
            set(handles.(field), 'BackgroundColor', [1, 1, 1]);
            text_string = get(handles.(field), 'String');
            text_string(2,:) = sprintf('(%.2f)', 0.00);
            set(handles.(field), 'String', text_string);
        end
    end
end

function slider_handRange_Callback(hObject, eventdata, type)
%TODO: Finish this function, use Sklansky-karlson hand rankings
    disp(type);
end

function buttongroup_player_Callback(hObject, eventdata)
%TODO: Finish this function, show handrange for selected player
    eventdata
end


