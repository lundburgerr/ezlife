classdef PokerStreetAction
    properties
        action;
        street;
        bet;
    end
    
    methods
        function obj = PokerStreetAction(action, street, bet)
            obj.action = action;
            obj.street = street;
            obj.bet = bet;
        end
    end
    
end

