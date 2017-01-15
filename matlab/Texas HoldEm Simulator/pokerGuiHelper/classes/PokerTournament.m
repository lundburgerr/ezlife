classdef PokerTournament < handle
    %POKERTOURNAMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        tournamentName;
        payouts;
        pokerPlayers; %TODO: Maybe this should be in a PokerTable class? RIght now this only contain players for one table, works for SNGs
        handles;
    end
    
    methods
        function obj = PokerTournament(name)
            obj.tournamentName = name;
            obj.payouts = 1;
            obj.pokerPlayers = PokerPlayer.empty(10,0);
        end
        
        %set payouts for tournament
        function setPayouts(obj, payouts)
            obj.payouts = payouts;
        end
        
        %Set pokerplayer to the tournament (table)
        function setPokerPlayer(obj, pokerPlayer, pind)
            obj.pokerPlayers(pind) = pokerPlayer;
        end
        
        %Update ICM for all players on the table
        function updateIcm(obj)
            Nplayers = length(obj.pokerPlayers);
            stacks = zeros(1,Nplayers);
            for p = 1:Nplayers
                stacks(p) = obj.pokerPlayers(p).getStack();
            end
            
            for p = 1:Nplayers
                icm_player = icm(obj.payouts, stacks, p);
                if isnan(icm_player)
                    icm_player = 0;
                end
                obj.pokerPlayers(p).setIcm(icm_player);
            end
        end

    end
    
end

