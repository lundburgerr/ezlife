classdef PokerPlayer < handle
    %POKERPLAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        handRange;
        stack;
        IcmPlayer;
        handles;
        position; %Maybe position should be in another class, like PokerTable
        tournament; %The tournament the players is in, can calculate ICM and stuff.
    end
    
    methods
        function obj = PokerPlayer(handles_handrange_grid, handle_playerpanel)
            obj.handRange = zeros(13,13);
            obj.stack = 0;
            obj.IcmPlayer = 0.0;
            obj.position = 0; %TODO: Create ENUM for positions: BB, SB, BU, CO, HJ, HJ+1, HJ+2, ... 
            
            playerChildrenHandles = allchild(handle_playerpanel);
            obj.handles.handrange_grid = handles_handrange_grid;
            obj.handles.stack_field = playerChildrenHandles(6);
            obj.handles.icm_field = playerChildrenHandles(1);
        end
        
        function viewPlayerHandRange(obj, varargin)
            if isempty(varargin)
                rows = repmat(1:13, 1, 13);
                cols = zeros(1, 13*13);
                for n=1:13
                    cols(1+13*(n-1):13*n) = n*ones(1,13);
                end
            elseif length(varargin) == 2
                rows = varargin{1};
                cols = varargin{2};
            end
            obj.updateHandrangeView(rows, cols);
        end
        
        function setHandRange(obj, handRange)
            obj.handRange = handRange;
        end
        
        function setStack(obj, stack)
            if isnumeric(stack)
                obj.stack = stack;
%                 tournament.updateIcm(); %TODO: This sshould work
            end
            obj.updateStackField();
        end
        
        function setIcm(obj, IcmPlayer)
            if isnumeric(IcmPlayer) && IcmPlayer <= 1 && IcmPlayer >= 0
                obj.IcmPlayer = IcmPlayer;
                obj.updateIcmField();
            end
        end
        
        %% Getters
        function stack = getStack(obj)
            stack = obj.stack;
        end
        
        function handRange = getHandRange(obj)
            handRange = obj.handRange;
        end
        
        
    end
    
    %% Private Methods
    methods (Access = private)
        %Update the handrange grid to show this players handrange
        function updateHandrangeView(obj, rows, cols)
            N = length(rows);
            inverted_green = [1 0.4 0.9];
            for n = 1:N
                ny = rows(n);
                nx = cols(n);
                color = [1, 1, 1] - inverted_green*obj.handRange(ny, nx);
                set(obj.handles.handrange_grid(ny,nx), 'BackgroundColor', color)
                text_string = get(obj.handles.handrange_grid(ny,nx), 'String');
                text_string(2,:) = sprintf('(%.2f)', obj.handRange(ny, nx));
                set(obj.handles.handrange_grid(ny,nx), 'String', text_string);
            end
        end
        
        function updateIcmField(obj)
            text = sprintf('%.1f%%', obj.IcmPlayer*100);
            set(obj.handles.icm_field, 'String', text);
        end
        
        function updateStackField(obj)
            set(obj.handles.stack_field, 'String', obj.stack);
        end
    end
    
end

