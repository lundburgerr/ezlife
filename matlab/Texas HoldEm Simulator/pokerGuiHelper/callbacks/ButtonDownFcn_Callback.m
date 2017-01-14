function ButtonDownFcn_Callback(hObject, eventdata)
    gui = ancestor(hObject, 'figure');
    gui_data = guidata(gui);
    handles = gui_data.handles;
    button_down = gui_data.button_down;

    %Already pushed?
    if button_down
        return;
    end
    button_down = 1;
    
    %% Add callbacks to figure for moving the point
    mousebutton = get(gcf, 'SelectionType');
    if strcmp(mousebutton, 'normal')   %Left click -- Add probability
        gui_data.addOrSubtract = 1;
        %guidata(handles.gui, gui_data);
        set(handles.gui, 'Interruptible', 'off')
        set(handles.gui,'WindowButtonUpFcn',@WindowButtonUpFcn_Callback);
        set(handles.gui,'WindowButtonMotionFcn',@WindowButtonMotionFcn_Callback);
    elseif strcmp(mousebutton, 'alt') %Right click -- Subtract probability
        gui_data.addOrSubtract = -1;
        %guidata(handles.gui, gui_data);
        set(handles.gui, 'Interruptible', 'off')
        set(handles.gui,'WindowButtonUpFcn',@WindowButtonUpFcn_Callback);
        set(handles.gui,'WindowButtonMotionFcn',@WindowButtonMotionFcn_Callback);
    end
    
    gui_data.button_down = button_down;
    guidata(gui, gui_data);
end

