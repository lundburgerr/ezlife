function slider_handRange_Callback(hObject, eventdata, type)
%TODO: Finish this function, use Sklansky-karlson hand rankings
persistent valOld;
persistent valOldS;
persistent valOldO;
persistent valOldPP;
if isempty(valOld), valOld = 0; end
if isempty(valOldS), valOldS = 0; end
if isempty(valOldO), valOldO = 0; end
if isempty(valOldPP), valOldPP = 0; end

gui = ancestor(hObject, 'figure');
gui_data = guidata(gui);
pokerPlayer = gui_data.pp_handles(gui_data.selectedPlayer);
handRange = pokerPlayer.getHandRange();
handRangeOld = handRange;
handles = gui_data.handles;


sklanskyHR = [[1, 1]; [2, 2]; [1, 2]; [3, 3]; [2, 1]; [4, 4]; [1, 3]; [5, 5]; [3, 1]; [6, 6]; [1, 4]; [7, 7]; [1, 5]; [4, 1]; [8, 8]; [9, 9]; [5, 1]; [1, 6]; [10, 10]; [1, 7]; [2, 3]; [11, 11]; [6, 1]; [1, 8]; [2, 4]; [1, 10]; [7, 1]; [1, 9]; [1, 11]; [12, 12]; [2, 5]; [8, 1]; [1, 12]; [3, 2]; [1, 13]; [10, 1]; [9, 1]; [11, 1]; [4, 2]; [3, 4]; [12, 1]; [13, 13]; [2, 6]; [13, 1]; [5, 2]; [3, 5]; [2, 7]; [2, 8]; [4, 5]; [6, 2]; [2, 9]; [4, 3]; [3, 6]; [2, 10]; [7, 2]; [2, 11]; [5, 3]; [8, 2]; [2, 12]; [2, 13]; [3, 7]; [9, 2]; [4, 6]; [10, 2]; [6, 3]; [5, 4]; [11, 2]; [3, 8]; [5, 6]; [3, 9]; [12, 2]; [4, 7]; [3, 10]; [13, 2]; [7, 3]; [3, 11]; [6, 4]; [3, 12]; [5, 7]; [4, 8]; [8, 3]; [3, 13]; [9, 3]; [6, 7]; [10, 3]; [7, 4]; [6, 5]; [4, 9]; [5, 8]; [4, 10]; [11, 3]; [4, 11]; [8, 4]; [12, 3]; [6, 8]; [7, 5]; [4, 12]; [5, 9]; [13, 3]; [4, 13]; [7, 8]; [9, 4]; [7, 6]; [8, 5]; [6, 9]; [10, 4]; [5, 10]; [5, 11]; [7, 9]; [11, 4]; [9, 5]; [8, 6]; [5, 12]; [8, 9]; [6, 10]; [12, 4]; [5, 13]; [8, 7]; [7, 10]; [9, 6]; [10, 5]; [13, 4]; [8, 10]; [6, 11]; [11, 5]; [9, 10]; [9, 7]; [6, 12]; [7, 11]; [10, 6]; [12, 5]; [9, 8]; [6, 13]; [8, 11]; [10, 11]; [13, 5]; [10, 7]; [9, 11]; [7, 12]; [11, 6]; [10, 8]; [7, 13]; [8, 12]; [12, 6]; [10, 9]; [10, 12]; [9, 12]; [11, 7]; [13, 6]; [11, 12]; [11, 8]; [8, 13]; [11, 10]; [11, 9]; [10, 13]; [9, 13]; [12, 7]; [11, 13]; [13, 7]; [12, 8]; [12, 10]; [12, 9]; [12, 13]; [12, 11]; [13, 8]; [13, 10]; [13, 9]; [13, 11]; [13, 12]];
sklanskyOrdering = 1:169;

ppSklanskyHR = [[1, 1]; [2, 2]; [3, 3]; [4, 4]; [5, 5]; [6, 6]; [7, 7]; [8, 8]; [9, 9]; [10, 10]; [11, 11]; [12, 12]; [13, 13]];
ppOrdering = [1, 2, 4, 6, 8, 10, 12, 15, 16, 19, 22, 30, 42];

suitedSklanskyHR = [[1, 2]; [1, 3]; [1, 4]; [1, 5]; [1, 6]; [1, 7]; [2, 3]; [1, 8]; [2, 4]; [1, 10]; [1, 9]; [1, 11]; [2, 5]; [1, 12]; [1, 13]; [3, 4]; [2, 6]; [3, 5]; [2, 7]; [2, 8]; [4, 5]; [2, 9]; [3, 6]; [2, 10]; [2, 11]; [2, 12]; [2, 13]; [3, 7]; [4, 6]; [3, 8]; [5, 6]; [3, 9]; [4, 7]; [3, 10]; [3, 11]; [3, 12]; [5, 7]; [4, 8]; [3, 13]; [6, 7]; [4, 9]; [5, 8]; [4, 10]; [4, 11]; [6, 8]; [4, 12]; [5, 9]; [4, 13]; [7, 8]; [6, 9]; [5, 10]; [5, 11]; [7, 9]; [5, 12]; [8, 9]; [6, 10]; [5, 13]; [7, 10]; [8, 10]; [6, 11]; [9, 10]; [6, 12]; [7, 11]; [6, 13]; [8, 11]; [10, 11]; [9, 11]; [7, 12]; [7, 13]; [8, 12]; [10, 12]; [9, 12]; [11, 12]; [8, 13]; [10, 13]; [9, 13]; [11, 13]; [12, 13]];
sOrdering = [3, 7, 11, 13, 18, 20, 21, 24, 25, 26, 28, 29, 31, 33, 35, 40, 43, 46, 47, 48, 49, 51, 53, 54, 56, 59, 60, 61, 63, 68, 69, 70, 72, 73, 76, 78, 79, 80, 82, 84, 88, 89, 90, 92, 95, 97, 98, 100, 101, 105, 107, 108, 109, 113, 114, 115, 117, 119, 123, 124, 126, 128, 129, 133, 134, 135, 138, 139, 142, 143, 146, 147, 150, 152, 155, 156, 158, 163];

offsuitedSklanskyHR = [[2, 1]; [3, 1]; [4, 1]; [5, 1]; [6, 1]; [7, 1]; [8, 1]; [3, 2]; [10, 1]; [9, 1]; [11, 1]; [4, 2]; [12, 1]; [13, 1]; [5, 2]; [6, 2]; [4, 3]; [7, 2]; [5, 3]; [8, 2]; [9, 2]; [10, 2]; [6, 3]; [5, 4]; [11, 2]; [12, 2]; [13, 2]; [7, 3]; [6, 4]; [8, 3]; [9, 3]; [10, 3]; [7, 4]; [6, 5]; [11, 3]; [8, 4]; [12, 3]; [7, 5]; [13, 3]; [9, 4]; [7, 6]; [8, 5]; [10, 4]; [11, 4]; [9, 5]; [8, 6]; [12, 4]; [8, 7]; [9, 6]; [10, 5]; [13, 4]; [11, 5]; [9, 7]; [10, 6]; [12, 5]; [9, 8]; [13, 5]; [10, 7]; [11, 6]; [10, 8]; [12, 6]; [10, 9]; [11, 7]; [13, 6]; [11, 8]; [11, 10]; [11, 9]; [12, 7]; [13, 7]; [12, 8]; [12, 10]; [12, 9]; [12, 11]; [13, 8]; [13, 10]; [13, 9]; [13, 11]; [13, 12]];
oOrdering = [5, 9, 14, 17, 23, 27, 32, 34, 36, 37, 38, 39, 41, 44, 45, 50, 52, 55, 57, 58, 62, 64, 65, 66, 67, 71, 74, 75, 77, 81, 83, 85, 86, 87, 91, 93, 94, 96, 99, 102, 103, 104, 106, 110, 111, 112, 116, 118, 120, 121, 122, 125, 127, 130, 131, 132, 136, 137, 140, 141, 144, 145, 148, 149, 151, 153, 154, 157, 159, 160, 161, 162, 164, 165, 166, 167, 168, 169];

%Move all all sliders to have atleast the same ordering as all hands
%sklansky

moveAll = 0;
valIdx = get(eventdata.Source, 'Value');
valAll = handles.slider_handRange.Value;
step = 1; %Is it an increase or decrease
switch type
    case 'all'
%         hands = sklanskyHR(sklanskyOrdering<=valAll, :);
        if valIdx < valOld, step = -1; end
        if step == 1
            hands = [suitedSklanskyHR(sOrdering<=valOldS, :); sklanskyHR(sklanskyOrdering<=valAll, :); ...
                offsuitedSklanskyHR(oOrdering<=valOldO, :); ppSklanskyHR(ppOrdering<=valOldPP, :)];
        elseif step == -1
            hands = sklanskyHR(sklanskyOrdering<=valAll, :);
        end
        moveAll = 1;
        valOld = valAll;
        
    case 'suited'
        if valIdx > 0, val = sOrdering(valIdx); else val = 0; end
        if val < valAll
            valIdx = find(sOrdering >= valAll, 1, 'first');
            val = sOrdering(valIdx);
            set(handles.slider_handRange_suited, 'Value', valIdx);
        end
        hands = [suitedSklanskyHR(sOrdering<=val, :); sklanskyHR(sklanskyOrdering<=valAll, :); ...
                offsuitedSklanskyHR(oOrdering<=valOldO, :); ppSklanskyHR(ppOrdering<=valOldPP, :)];
        if val < valOldS, step = -1; end
        valOldS = val;
        
    case 'offsuited'
        val = oOrdering(valIdx);
        if val < valAll
            valIdx = find(oOrdering >= valAll, 1, 'first');
            val = oOrdering(valIdx);
            set(handles.slider_handRange_offsuited, 'Value', valIdx);
        end
        hands = [suitedSklanskyHR(sOrdering<=valOldS, :); sklanskyHR(sklanskyOrdering<=valAll, :); ...
                offsuitedSklanskyHR(oOrdering<=val, :); ppSklanskyHR(ppOrdering<=valOldPP, :)];
        if val < valOldO, step = -1; end
        valOldO = val;
        
    case 'pocket'
        val = ppOrdering(valIdx);
        if val < valAll
            valIdx = find(ppOrdering < valAll, 1, 'last');
            val = ppOrdering(valIdx);
            set(handles.slider_handRange_pocket, 'Value', valIdx);
        end
        hands = [suitedSklanskyHR(sOrdering<=valOldS, :); sklanskyHR(sklanskyOrdering<=valAll, :); ...
                offsuitedSklanskyHR(oOrdering<=valOldO, :); ppSklanskyHR(ppOrdering<=val, :)];
        if val < valOldPP, step = -1; end
        valOldPP = val;
end

%Move the other sliders along with valAll
if moveAll
    if step == 1
        %Suited hands
        valIdxS = max(handles.slider_handRange_suited.Value, find(sOrdering <= valIdx, 1, 'last'));
        
        %Offsuited hands
        valIdxO = max(handles.slider_handRange_offsuited.Value, find(oOrdering <= valIdx, 1, 'last'));
        
        %Pocket hands
        valIdxPP = max(handles.slider_handRange_pocket.Value, find(ppOrdering <= valIdx, 1, 'last'));
        
    elseif step == -1
        %Suited hands
        valIdxS = find(sOrdering <= valIdx, 1, 'last');
        
        %Offsuited hands
        valIdxO = find(oOrdering <= valIdx, 1, 'last');
        
        %Pocket hands
        valIdxPP = find(ppOrdering <= valIdx, 1, 'last');
        
    end
    valOldS = sOrdering(valIdxS);
    valOldO = oOrdering(valIdxO);
    valOldPP = ppOrdering(valIdxPP);
    if isempty(valIdxS), valIdxS = 0; end
    if isempty(valIdxO), valIdxO = 0; end
    if isempty(valIdxPP), valIdxPP = 0; end
    
    set(handles.slider_handRange_suited, 'Value', valIdxS);
    set(handles.slider_handRange_offsuited, 'Value', valIdxO);
    set(handles.slider_handRange_pocket, 'Value', valIdxPP);
end

%Move valAll up if we moved all other sliders up
if step == 1
    minValAllArray = 169;
    if valOldS < max(sOrdering), minValAllArray(end+1) = valOldS; end
    if valOldO < max(oOrdering), minValAllArray(end+1) = valOldO; end
    if valOldPP < max(ppOrdering), minValAllArray(end+1) = valOldPP; end
    valOld = max(valOld, min(minValAllArray));
    set(handles.slider_handRange, 'Value', valOld);
end

%% Update handrange
%Increase
if step == 1
    for k = 1:size(hands, 1)
        handRange(hands(k,1), hands(k,2)) = 1;
    end
    [r,c] = find(handRangeOld ~= handRange); %Find diff
%Decrease
elseif step == -1
    handRangeMask = zeros(13,13);
    for k = 1:size(hands, 1)
        handRangeMask(hands(k,1), hands(k,2)) = 1;
    end
    [r,c] = find(handRangeMask ~= handRange);
    for k = 1:length(r)
        handRange(r(k),c(k)) = 0;
    end
end


pokerPlayer.setHandRange(handRange);
pokerPlayer.viewPlayerHandRange(r,c);

