function WindowButtonMotionFcn_Callback(hObject, eventdata)
    %Add or subtract
    persistent delay_last_change;
    gui = ancestor(hObject, 'figure');
    gui_data = guidata(gui);
    GOS = gui_data.GOS;
    handles = gui_data.handles;
    addOrSubtract = gui_data.addOrSubtract;

    %Initialize persistent variable
    if isempty(delay_last_change)
        delay_last_change = clock();
    end
    
    if etime(clock(), delay_last_change) < 0.02
        return;
    end
    
    %Get current grid point
    C = hObject.CurrentPoint; %hObject.SelectionType
    jj = floor((GOS.guiHeight-GOS.margin-C(2))/GOS.nodeWidth) + 1; %Which row?
    ii = floor((C(1)-GOS.margin)/GOS.nodeWidth) + 1;                    %Which column?
    
    %Add/Subtract probability to current grid point
    if( ii >= 1 && ii <= GOS.gridSize && ...
            jj >= 1 && jj <= GOS.gridSize)
%         gui_data.gridProbability(jj, ii) = gui_data.gridProbability(jj, ii) + addOrSubtract*0.05;
%         gui_data.gridProbability(jj, ii) = min(gui_data.gridProbability(jj, ii), 1);
%         gui_data.gridProbability(jj, ii) = max(gui_data.gridProbability(jj, ii), 0);
        
        %% TODO Move nearby points
        %Create distance matrix from center
        square_size = 3;
        fall_off_constant = 1; %The higher the faster
        middle_ind = floor(square_size/2)+1;
        distance_matrix = zeros(square_size);
        for nx = 1:square_size
            for ny = 1:square_size
                if ii == jj
                    if nx == ny
                        distance_matrix(ny,nx) = sqrt((middle_ind-nx)^2 + (middle_ind-ny)^2)^fall_off_constant;
                    else
                        distance_matrix(ny,nx) = inf;
                    end
                elseif ii > jj
                    if ii+nx > jj+ny
                        distance_matrix(ny,nx) = sqrt((middle_ind-nx)^2 + (middle_ind-ny)^2)^fall_off_constant;
                    else
                        distance_matrix(ny,nx) = inf;
                    end
                elseif ii < jj
                    if ii+nx < jj+ny
                        distance_matrix(ny,nx) = sqrt((middle_ind-nx)^2 + (middle_ind-ny)^2)^fall_off_constant;
                    else
                        distance_matrix(ny,nx) = inf;
                    end
                end
            end
        end
        
        %Create gaussian distr. matrix relative to middle
        exp_mat = exp(-(distance_matrix));
        
        %Move surrounding points in a logarithmic fashion
        dp = 0.05; %change in probability at middle
        dp_mat = dp*exp_mat;
        for nx = -floor(square_size/2):floor(square_size/2)
            if ii+nx < 1 || ii+nx > GOS.gridSize, continue; end
            for ny = -floor(square_size/2):floor(square_size/2)
                if jj+ny < 1 || jj+ny > GOS.gridSize, continue; end
                dp_ind_y = ny + floor(square_size/2) + 1;
                dp_ind_x = nx + floor(square_size/2) + 1;
                gui_data.gridProbability(jj+ny, ii+nx) = gui_data.gridProbability(jj+ny, ii+nx) + addOrSubtract*dp_mat(dp_ind_y, dp_ind_x);
                gui_data.gridProbability(jj+ny, ii+nx) = min(gui_data.gridProbability(jj+ny, ii+nx), 1);
                gui_data.gridProbability(jj+ny, ii+nx) = max(gui_data.gridProbability(jj+ny, ii+nx), 0);
                
                field = sprintf('hand_field_%dx%d', jj+ny, ii+nx);
                inverted_green = [1 0.4 0.9];
                set(handles.(field), 'BackgroundColor', [1, 1, 1] - inverted_green*gui_data.gridProbability(jj+ny, ii+nx))
                text_string = get(handles.(field), 'String');
                text_string(2,:) = sprintf('(%.2f)', gui_data.gridProbability(jj+ny, ii+nx));
                set(handles.(field), 'String', text_string);
            end
        end
        
        delay_last_change = clock();
    end
    
    guidata(gui, gui_data);
end

