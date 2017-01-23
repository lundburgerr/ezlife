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
        end
        
        %Set pokerplayer to the table
        function setPokerPlayer(obj, pokerPlayer, pind)
            obj.pokerPlayers(pind) = pokerPlayer;
            obj.playerStreetAction{pind} = [];
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
            pind_rel = length(idxActive <= pind);
            numPlayers = length(idxActive);
            positions = PokerPosition.generatePositions(pind_rel, numPlayers);
            for n=1:length(idxActive)
                obj.playerPositions(idxActive(n)) = positions(n);
            end
        end
        
        function rotatePositions(obj)
            idxActive = find(obj.activeSeats == 1);
            positions = obj.playerPositions(idxActive);
            positions = circshift(positions, 1);
            for n=1:length(idxActive)
                obj.playerPositions(idxActive(n)) = positions(n);
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
            
            if p.reset == 1
                obj.potSize = 0;
            else
                obj.potSize = obj.potSize + p.add;
            end
            
            %Update handle
            set(obj.handles.pot_size, 'String', obj.potSize);
        end
        
        %Update deck. Removing known cards
        function updateDeck(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('remove', [], @is_poker_cards);
            parse(p,varargin{:});
            
            if p.reset == 1
                obj.deck = 1:52;
            else
                idx = zeros(length(p.remove), 1);
                for k = 1:length(p.remove)
                    idx(k) = find(obj.deck == p.remove(k));
                end
                obj.deck(idx) = [];
            end
            
            %Update handle
            set(obj.handles.pot_size, 'String', obj.potSize);
        end
        
        %Update table cards
        function updateTableCards(obj, varargin)
            p = inputParser;
            p.addOptional('reset', 0, @is_bool);
            p.addOptional('add', [], @is_poker_cards);
            parse(p,varargin{:});
            
            if p.reset == 1
                obj.tableCards = [];
            else
                obj.tableCards = [obj.tableCards, p.add]; %TODO: Should check that p.add is a row vector
                obj.updateDeck('remove', p.add); %Remove cards from the deck
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

