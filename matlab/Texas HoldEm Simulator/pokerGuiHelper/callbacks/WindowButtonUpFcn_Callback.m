function WindowButtonUpFcn_Callback(hObject, eventdata)
    gui = ancestor(hObject, 'figure');
    gui_data = guidata(gui);
    handles = gui_data.handles;
    
    set(handles.gui, 'Interruptible', 'on')
    set(handles.gui,'WindowButtonUpFcn','');
    set(handles.gui,'WindowButtonMotionFcn','');
    gui_data.button_down = 0;
    
    guidata(gui, gui_data);
end

