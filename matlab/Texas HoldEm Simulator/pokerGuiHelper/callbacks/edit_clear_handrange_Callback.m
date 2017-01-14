function edit_clear_handrange_Callback(hObject, eventdata)
    gui = ancestor(hObject, 'figure');
    gui_data = guidata();
    handles = gui_data.handles;
    square_size = gui_data.GOS.gridSize;
    for nx = 1:square_size
        for ny = 1:square_size
            gui_data.gridProbability(ny, nx) = 0;
            field = sprintf('hand_field_%dx%d', ny, nx);
            set(handles.(field), 'BackgroundColor', [1, 1, 1]);
            text_string = get(handles.(field), 'String');
            text_string(2,:) = sprintf('(%.2f)', 0.00);
            set(handles.(field), 'String', text_string);
        end
    end
    
    guidata(gui, gui_data);
end

