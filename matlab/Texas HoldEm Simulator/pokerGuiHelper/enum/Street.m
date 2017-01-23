classdef Street < uint32
    enumeration
      PREFLOP (0) 
      FLOP (1) 
      TURN (2)
      RIVER (3)
    end
    
    methods(Static)
      function len = length()
         len = Street.RIVER + 1;
      end
      
      function num = numCards(street)
          switch street
              case Street.PREFLOP
                  num = 0;
              case Street.FLOP
                  num = 3;
              case Street.TURN
                  num = 1;
              case Street.RIVER
                  num = 1;
              otherwise
                  num = 0;
          end
      end
      
      function v = validStreet(street)
          if street >= 0 && street <4
              v = 1;
          else
              v = 0;
          end
      end
   end
end

