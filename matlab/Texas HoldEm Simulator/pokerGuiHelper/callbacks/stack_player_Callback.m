function stack_player_Callback(hObject, eventdata, p)
gui = ancestor(hObject, 'figure');
gui_data = guidata(gui);

%Update stack
stack_string = get(hObject, 'String');
stack = str2double(stack_string);
gui_data.pp_handles(p).setStack(stack);


