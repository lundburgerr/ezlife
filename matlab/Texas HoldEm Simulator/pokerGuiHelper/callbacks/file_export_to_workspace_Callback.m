function file_export_to_workspace_Callback(hObject, eventdata)
    gui = ancestor(hObject, 'figure');
    gui_data = guidata(gui);
    assignin('base', 'handRange', gui_data.gridProbability);
%     delete(hObject);
end

