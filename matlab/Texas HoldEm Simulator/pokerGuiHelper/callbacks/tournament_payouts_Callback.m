function tournament_payouts_Callback(hObject, eventdata)
gui = ancestor(hObject, 'figure');
gui_data = guidata(gui);

%Loop over all ICM boxes
payouts_strings = regexp(hObject.String, '\s*,*\s*', 'split');
payouts = str2double(payouts_strings);
stacks = zeros(1,10);
for p = 1:10
    stacks(p) = gui_data.pp_handles(p).getStack();
end

for p = 1:10
    icm_player = icm(payouts, stacks, p);
    if isnan(icm_player)
        icm_player = 0;
    end
    gui_data.pp_handles(p).setIcm(icm_player);
%     field_icm = sprintf('ICM_player%d', p);
%     
%     text = sprintf('%.1f%%', icm_player*100);
%     set(handles.(field_icm), 'String', text);
end

