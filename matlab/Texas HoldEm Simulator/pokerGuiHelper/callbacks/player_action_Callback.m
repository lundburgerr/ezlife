function player_action_Callback(hObject, eventdata, action, pind)
gui = ancestor(hObject, 'figure');
gui_data = guidata(gui);
handles = gui_data.handles;
pokerTable = gui_data.pokerTable;

field = sprintf('chipsPlayed_player%d', pind);
if action == 2 || action == 0
    betTotalString = get(handles.(field), 'String');
    betTotal = str2double(betTotalString);
elseif action == 1
    betTotal = pokerTable.getToCall();
end
streetAction = PokerStreetAction(action, pokerTable.getCurrentStreet, betTotal);
ok = pokerTable.addPlayerAction(pind, streetAction);

%If valid player and all, we can update bet field. Which is relevant when
%we call
if ok
    set(handles.(field), 'String', betTotal);
else
    %TODO: Reset bet field to old values
end


