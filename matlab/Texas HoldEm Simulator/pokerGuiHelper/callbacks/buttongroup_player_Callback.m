function buttongroup_player_Callback(hObject, eventdata)
    gui = ancestor(hObject, 'figure');
    gui_data = guidata(gui);
    gui_data.selectedPlayer = eventdata.NewValue.UserData;
    guidata(gui, gui_data);
    
    gui_data.pp_handles(gui_data.selectedPlayer).viewPlayerHandRange();
end

