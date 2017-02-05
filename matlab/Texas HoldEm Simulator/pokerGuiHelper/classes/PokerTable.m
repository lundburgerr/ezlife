classdef PokerTable < handle
    %POKERTOURNAMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        tournament;
        pokerPlayers; %TODO: Maybe this should be in a PokerTable class? RIght now this only contain players for one table, works for SNGs
        currentStreet; %0 = PREFLOP, 1 = FLOP, 2 = TURN, 3 = RIVER
        potSize;
        handles;
        tableCards;
        deck;
        playerPositions;
        activeSeats;
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
        end
        
        %Set pokerplayer to the table
        function setPokerPlayer(obj, pokerPlayer, pind)
            obj.pokerPlayers(pind) = pokerPlayer;
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
        
        %Reset player actions
        function resetPlayerActions(obj)
           for n=1:length(obj.pokerPlayers)
               obj.pokerPlayers.updateStreetAction('reset', 1);
           end
        end

    end
    
end

