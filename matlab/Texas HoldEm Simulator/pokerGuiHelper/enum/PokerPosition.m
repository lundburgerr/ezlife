classdef PokerPosition < int32
    enumeration
      BB (-2)
      SB (-1)
      D (1)
      CO (2)
      HJ (3)
      HJp1 (4)
      HJp2 (5)
      HJp3 (6)
      HJp4 (7)
      HJp5 (8)
    end
    
    methods(Static)
        
        function positions = generatePositions(dealer, numPlayers)
            %Check if dealer position is valid
            if  dealer < 1 || dealer > numPlayers
                positions = [];
                return;
            end
            
            %Generate positions array
            if numPlayers > 2
                positions = enumeration(PokerPosition.D);
                positions = flipud(positions(1:numPlayers));
                positions = circshift(positions(1:numPlayers), dealer+2);
            elseif numPlayers == 2
                positions(dealer) = PokerPosition.D;
                positions(numPlayers-dealer+1) = PokerPosition.BB;
            end
        end
        
        function v = isValidPosition(position, numPlayers)
            if numPlayers > 2
                if (position >= 1 && position <=numPlayers) || position == -1 || position == -2
                    v = 1;
                else
                    v = 0;
                end
            elseif numPlayers == 2
                if position == 1 || position == -2
                    v = 1;
                else
                    v = 0;
                end
            else
                v = 0;
            end
        end
    end
end

