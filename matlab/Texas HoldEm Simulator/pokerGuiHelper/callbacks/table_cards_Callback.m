function table_cards_Callback(hObject, eventdata)
gui = ancestor(hObject, 'figure');
gui_data = guidata(gui);
pokerTable = gui_data.pokerTable;

cardString = get(hObject, 'String');
cards = mapCardsText2Num(cardString);
pokerTable.updateTableCards('reset', 1, 'add', cards);



