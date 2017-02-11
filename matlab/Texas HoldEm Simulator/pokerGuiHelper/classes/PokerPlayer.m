classdef PokerPlayer < handle
    %POKERPLAYER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        handRange;
        stack;
        IcmPlayer;
        handles;
        tournament; %The tournament the players is in, can calculate ICM and stuff.
        streetAction;
    end
    
    methods
        function obj = PokerPlayer(handles_handrange_grid, handle_playerpanel, tournament)
            obj.handRange = zeros(13,13);
            obj.stack = 0;
            obj.IcmPlayer = 0.0;
            obj.tournament = tournament;
            
            playerChildrenHandles = allchild(handle_playerpanel);
            obj.handles.handrange_grid = handles_handrange_grid;
            obj.handles.stack_field = playerChildrenHandles(6);
            obj.handles.icm_field = playerChildrenHandles(1);
            obj.handles.bet = playerChildrenHandles(5);
            obj.handles.raiseButton = playerChildrenHandles(4);
            obj.handles.callButton = playerChildrenHandles(3);
            obj.handles.foldButton = playerChildrenHandles(2);
            obj.handles.panel = handle_playerpanel;
            
            obj.streetAction = {};
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
                obj.tournament.updateIcm();
            end
            obj.updateStackField();
        end
        
        function updateStack(obj, varargin)
            p = inputParser;
            p.addOptional('add', 0, @is_non_negative);
            p.addOptional('remove', 0, @is_non_negative);
            parse(p,varargin{:});
            
            obj.stack = obj.stack + p.Results.add - p.Results.remove;
            obj.tournament.updateIcm();
            obj.updateStackField();
        end
        
        function setIcm(obj, IcmPlayer)
            if isnumeric(IcmPlayer) && IcmPlayer <= 1 && IcmPlayer >= 0
                obj.IcmPlayer = IcmPlayer;
                obj.updateIcmField();
            end
        end
        
        %Update player actions
        function diffBet = updateStreetAction(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('add', [], @is_poker_street_action);
            parse(p,varargin{:});
            
            if p.Results.reset == 1
                obj.streetAction = {};
            elseif ~isempty(p.Results.add)
                oldBet = 0;
                if ~isempty(obj.streetAction)
                    oldAction = obj.streetAction{end};
                    if p.Results.add.street == oldAction.street
                        oldBet = oldAction.bet;
                    end
                end
                obj.streetAction{end+1} = p.Results.add;
                set(obj.handles.bet, 'String', p.Results.add.bet);
                %TODO: change color of player field indicating what action
                %they took
                
                %Return the difference of bet and what the player had
                %allready put in on this street (not counting ante of course)
                diffBet = p.Results.add.bet - oldBet;
                
                %Remove amount of chips from player stack
                obj.updateStack('remove', diffBet);
            end
            
            
        end
        
        function enablePlayerActions(obj, enable)
            switch enable
                case 'on'
                    set(obj.handles.bet, 'Enable', 'on');
                    set(obj.handles.raiseButton, 'Enable', 'on');
                    set(obj.handles.callButton, 'Enable', 'on');
                    set(obj.handles.foldButton, 'Enable', 'on');
                case 'off'
                    set(obj.handles.bet, 'Enable', 'off');
                    set(obj.handles.raiseButton, 'Enable', 'off');
                    set(obj.handles.callButton, 'Enable', 'off');
                    set(obj.handles.foldButton, 'Enable', 'off');
                otherwise
                    error('Not a valid argument')
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

