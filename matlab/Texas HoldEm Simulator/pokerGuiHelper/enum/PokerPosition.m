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
        
        %Generate correctly ordered positions given dealer position and
        %number of players
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
        
        %Given a position, return a representable string
        function textStr = toString(position)
            switch position
                case PokerPosition.BB
                    textStr = 'BB';
                case PokerPosition.SB
                    textStr = 'SB';
                case PokerPosition.D
                    textStr = 'D';
                case PokerPosition.CO
                    textStr = 'CO';
                case PokerPosition.HJ
                    textStr = 'HJ';
                case PokerPosition.HJp1
                    textStr = 'HJp1';
                case PokerPosition.HJp2
                    textStr = 'HJp2';
                case PokerPosition.HJp3
                    textStr = 'HJp3';
                case PokerPosition.HJp4
                    textStr = 'HJp4';
                case PokerPosition.HJp5
                    textStr = 'HJp5';
                otherwise
                    textStr = '';
            end
        end
        
        %Checks to see if argument is valid positions
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

