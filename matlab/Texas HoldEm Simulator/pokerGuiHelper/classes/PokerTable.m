classdef PokerTable < handle
    %POKERTOURNAMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        tournament;
        pokerPlayers;
        currentStreet; %0 = PREFLOP, 1 = FLOP, 2 = TURN, 3 = RIVER
        potSize;
        handles;
        
        tableCards;
        deck;
        
        playerPositions;
        activeSeats;
        
        %Table structure stuff (Should this be in PokerTournament class?)
        ante;
        smallBlind;
        bigBlind;
        
        %Determining player to act and if the street is finished
        playerToAct; %Current players turn, -1 indicating no more players can act this street
        lastPlayerToRaise;
        toCall; %Value that player needs to call to continue
        hasNotFolded;
    end
    
    methods
        function obj = PokerTable(tournament, handle_pot_size, handle_table_cards, handle_player_positions)
            obj.tournament = tournament;
            
            obj.handles.pot_size = handle_pot_size;
            obj.handles.table_cards = handle_table_cards;
            
            obj.handles.player_positions = zeros(10,1);
            positionChildrenHandles = allchild(handle_player_positions);
            for k=1:10
                obj.handles.player_positions(k) = positionChildrenHandles(10+1-k);
            end
            
            obj.currentStreet = Street.PREFLOP;
            obj.updatePotSize('reset', 1);
            obj.updateDeck('reset', 1);
            obj.updateTableCards('reset', 1);
            
            obj.activeSeats = zeros(1,10);
            obj.playerPositions = zeros(1,10);
            obj.pokerPlayers = PokerPlayer.empty(10,0);
            obj.playerToAct = 1;
            obj.lastPlayerToRaise = -1;
            obj.toCall = 0;
            
            obj.ante = 0;
            obj.smallBlind = 0;
            obj.bigBlind = 0;
            obj.currentStreet = -1;
            obj.hasNotFolded = ones(1,10);
        end
        
        %Set pokerplayer to the table
        function setPokerPlayer(obj, pokerPlayer, pind)
            obj.pokerPlayers(pind) = pokerPlayer;
        end
        
        function setTableStructure(obj, varargin)
            p = inputParser;
            p.addOptional('ante', obj.ante, @is_non_negative);
            p.addOptional('smallblind', obj.smallBlind, @is_non_negative);
            p.addOptional('bigblind', obj.bigBlind, @is_non_negative);
            parse(p,varargin{:});
            
            obj.ante = p.Results.ante;
            obj.smallBlind = p.Resulst.smallblind;
            obj.bigBlind = p.Results.bigblind;
        end
        
        function setActiveSeat(obj, pind, val)
            obj.activeSeats(pind) = val;
        end
        
        function result = isActiveSeat(obj, pind)
            result = obj.activeSeats(pind);
        end
        
        function setDealer(obj, pind)
            if ~obj.isActiveSeat(pind)
                error('Not an active seat');
            end
            idxActive = find(obj.activeSeats == 1);
            numPlayers = length(idxActive);
            positions = PokerPosition.generatePositions(pind, numPlayers);
            for n=1:length(idxActive)
                obj.playerPositions(idxActive(n)) = positions(n);
            end
            
            %Update gui handles
            for n=1:10
                set(obj.handles.player_positions(n), 'String', PokerPosition.toString(obj.playerPositions(n)));
            end
            
        end
        
        function rotatePositions(obj)
            idxActive = find(obj.activeSeats == 1);
            positions = obj.playerPositions(idxActive);
            positions = circshift(positions, 1);
            for n=1:length(idxActive)
                obj.playerPositions(idxActive(n)) = positions(n);
            end
            
            %Update gui handles
            for n=1:10
                set(obj.handles.player_positions, 'String', PokerPosition.toString(obj.playerPositions(n)));
            end
        end
        
        %Update currentStreet
        %If varargin is empty we just step to next street, otherwise we can
        %set street to whatever we want
        function updateCurrentStreet(obj, varargin)
%             oldStreet = obj.currentStreet;
            
            %Update street
            if isempty(varargin)
                obj.currentStreet = mod(obj.currentStreet + 1, 4);
            else
                street = varargin{1};
                if Street.validStreet(street)
                    obj.currentStreet = street;
                else
                    warning('Not a valid street');
                end
            end
            
            %If change back to preflop we reset deck, potSize and table cards
%             if oldStreet ~= obj.currentStreet && obj.currentStreet == 0
            if obj.currentStreet == Street.PREFLOP
                obj.updatePotSize('reset', 1);
                obj.updateDeck('reset', 1);
                obj.updateTableCards('reset', 1);
                obj.resetPlayerActions();
                obj.rotatePositions();
            end
        end
        
        %Update pot size
        function updatePotSize(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('add', 0, @is_non_negative);
            parse(p,varargin{:});
            
            if p.Results.reset == 1
                obj.potSize = 0;
            end
            obj.potSize = obj.potSize + p.Results.add;
            
            %Update handle
            set(obj.handles.pot_size, 'String', sprintf('%.2f', obj.potSize));
        end
        
        %Update deck. Removing known cards
        function updateDeck(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('remove', [], @is_poker_cards);
            p.addOptional('add', [], @is_poker_cards);
            parse(p,varargin{:});
            
            if p.Results.reset == 1
                obj.deck = 1:52;
            end
            if ~isempty(p.Results.remove)
                idx = zeros(length(p.Results.remove), 1);
                for k = 1:length(p.Results.remove)
                    idx(k) = find(obj.deck == p.Results.remove(k));
                end
                obj.deck(idx) = [];
            end
            if ~isempty(p.Results.add)
                for k=1:length(p.Results.add)
                    if isempty(find(obj.deck==p.Results.add(k), 1))
                        obj.deck(end+1) = p.Results.add(k);
                    end
                end
            end
        end
        
        %Check if card is in the deck
        function result = inDeck(obj, card)
            result = ~isempty(find(obj.deck==card, 1));
        end
        
        %Update table cards
        function updateTableCards(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('add', [], @is_poker_cards);
            parse(p,varargin{:});
            
            if p.Results.reset == 1
                obj.updateDeck('add', obj.tableCards)
                obj.tableCards = [];
            end
            if ~isempty(p.Results.add)
                for n=1:length(p.Results.add)
                    if length(obj.tableCards) == 5, break; end
                    if obj.inDeck(p.Results.add(n))
                        obj.tableCards = [obj.tableCards, p.Results.add(n)];
                        obj.updateDeck('remove', p.Results.add(n)); %Remove cards from the deck
                    end
                end
            end
            
            %Update handle
            set(obj.handles.table_cards, 'String', mapCardsNum2Text(obj.tableCards));
        end
        
        %Reset all player actions
        function resetPlayerActions(obj)
           for n=1:length(obj.pokerPlayers)
               obj.pokerPlayers(n).updateStreetAction('reset', 1);
           end
        end
        
        %Add action to player and update table information (pot size)
        function ok = addPlayerAction(obj, pind, streetAction, varargin) %action = 0 for folding, 1 for calling and 2 for raising
            p = inputParser;
            p.addOptional('next', 1, @is_bool); %If next is set we 
            parse(p,varargin{:});
            ok = 0;
            
            if pind == obj.playerToAct
                ok = 1;
                %if raise, update latest player to raise
                if streetAction.action == 2
                    obj.lastPlayerToRaise = pind;
                    obj.toCall = streetAction.bet;
                end
                
                relativeBet = obj.pokerPlayers(pind).updateStreetAction('add', streetAction);
                obj.updatePotSize('add', relativeBet);
                betTotal = streetAction.bet;
                %TODO: Probably should update player bet field in GUI here
                
                %If folded, set player has folded
                if streetAction.action == 0
                    obj.hasNotFolded(pind) = 0;
                end
                
                %Update player to act
                if p.Results.next
                    obj.setPlayerToAct('next', 1);
                end
                
                %TODO: If end of street, start a new street
                
                %TODO: If new hand rotate position, post antes and blinds
                %and stuff
                
                %TODO: check that bet size is valid (for example player
                %might be allin) and adjust it accordingly
                
                %TODO:
                %If next player to act is the last raiser, then end of street
                
                %TODO:
                %If we change street, do some predefined behaviour for that
                %street
            else
                error('Not this players turn');
            end
        end
        
        function setPlayerToAct(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('set', [], @is_positive_integer); %TODO: Should be between 1 and 10
            p.addOptional('next', 0, @is_bool);
            parse(p,varargin{:});
            
            if p.Results.reset == 1
                [~, obj.playerToAct] = max(obj.playerPositions.*obj.hasNotFolded);
            elseif ~isempty(p.Results.set)
                obj.playerToAct = p.Results.set;
            elseif p.Results.next
                obj.playerToAct = obj.getNextPlayerToAct();
            end
            
            for n=1:10
                if n == obj.playerToAct
                    obj.pokerPlayers(n).enablePlayerActions('on')
                else
                    obj.pokerPlayers(n).enablePlayerActions('off')
                end
            end
%             set(findall(PanelHandle, '-property', 'enable'), 'enable', 'off')
        end
        
        %Getters and setters
        function currentStreet = getCurrentStreet(obj)
            currentStreet = obj.currentStreet;
        end
        function setCurrentStreet(obj, currentStreet)
            obj.currentStreet = currentStreet;
        end
        function toCall = getToCall(obj)
            toCall = obj.toCall;
        end

    end
    
    methods (Access = private)
        function pind = getNextPlayerToAct(obj)
            pind = mod(obj.playerToAct, 10) + 1;
            while ~obj.isActiveSeat(pind)
                pind = mod(obj.playerToAct, 10) + 1;
            end
%             set(findall(PanelHandle, '-property', 'enable'), 'enable', 'off')
        end
    end
    
end

