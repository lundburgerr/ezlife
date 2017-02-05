function table_pot_size_Callback(hObject, eventdata)
gui = ancestor(hObject, 'figure');
gui_data = guidata(gui);
pokerTable = gui_data.pokerTable;

potStr = get(hObject, 'String');
pot = str2double(potStr);
if ~isnan(pot)
    pokerTable.updatePotSize('reset', 1, 'add', pot);
end
