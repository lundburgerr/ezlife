function [handRanking, handResult, bestCards] = BestHand(cards)
% Figure out the best hand given hole cards + FlopTurnRiver
% cards should be an array of 5 to 7 cards
% Each card are mapped beginning with spades, diamonds, hearts and clubs
% and then with Aces counting up, e.g.
% AS = 1    AD = 2    AD = 2    AH = 3    AC = 4
% KS = 5    ...
% QS = 9    .
% JS = 13   .
% 10S = 17
% 9S = 21
% 8S = 25
% 7S = 29
% 6S = 33
% 5S = 37
% 4S = 41
% 3S = 45
% 2S = 49    ...                         2C = 52
%
% result, Hands{result(1), 1}, gives the result of the hand and the
% result(2:6) with which cards we got that with the mapping above
% A zero represent the null card
%
% TODO: Kicker and hand values should be as small as possible and there
% should also not be any skips between values for handRanking for adjacent
% handvalues. SO basically edit result(2) and result(3) everywhere and also
% the calculation for  handRanking


Cards = {'A','K','Q','J','10','9','8','7','6','5','4','3','2'};
Suits = {'S','D','H','C'};
Hands = {'Royal Flush','AKQJ10 of same suit','RF';
         'Straight Flush','5 consecutive cards of same suit','SF';
         'Four of a Kind','4 cards of same number','4K';
         'Full House','3 cards of one number and 2 cards of another number','FH';
         'Flush','5 cards of 1 suit','F';
         'Straight','5 consecutive cards (suit doesn''t matter)','S';
         'Three of a Kind','3 cards of same number','3K';
         'Two Pair','2 cards each of 2 different numbers','2P';
         'One Pair','2 cards of same number','1P';
         'High Card','Highest card in hand','H';
         };
     
NumCards = length(Cards);
NumSuits = length(Suits);
DeckSize = NumCards * NumSuits;

cards = sort(cards);

%% Create hand matrix
handMatrix = zeros(NumSuits,NumCards);
for idx = 1:length(cards)
    handMatrix(cards(idx)) = 1;
end

%% Get some info for the rest of the checks
NumCardsPerSuit = sum(handMatrix,2);
NumEachCard = sum(handMatrix,1);
ind4 = find(NumEachCard >= 4,1,'first');
ind3 = find(NumEachCard >= 3,2,'first');
ind2 = find(NumEachCard >= 2,2,'first');
indFl = find(NumCardsPerSuit >= 5,1,'first');

%% Determine best hand from given cards 
result = zeros(1,1+1+1+5);
for jjdx = 1:size(Hands,1)
    switch Hands{jjdx,3}
        case 'RF'
            % Check for Royal Flush
            suitsRF = (sum(handMatrix(:,1:5),2) == 5);
            suitRF = find(suitsRF,1,'first');
            if ~isempty(suitRF)
                % Found Royal Flush
                result(1) = jjdx;
                result(2:3) = 1; %No valid hand or kicker value
                result(4:8) = suitRF + NumSuits * (0:4);
                break;
            end
        case 'SF'
            % Check for Straight Flush
            mat = [handMatrix handMatrix(:,1)]; %Aces are also ones
            for suitStFl = 1:NumSuits
                startInd = strfind(mat(suitStFl,:),ones(1,5)); %Try to find 5 ones in a row
                if ~isempty(startInd)
                    % Found Straight Flush
                    result(1) = jjdx;
                    result(2) = startInd(1)-1;
                    result(3) = 1; %No valid kicker value
                    result(4:8) = suitStFl + NumSuits * (startInd(1) + (-1:3));
                    if (startInd(1) == (NumCards - 3))
                        result(6) = result(6) - DeckSize;
                    end
                    break;
                end
            end
        case '4K'
            % Check for Four of a Kind
            if ~isempty(ind4)
                % Found Four of a Kind
                result(1) = jjdx;
                result(2) = ind4(1);%hand value
                suits4 = find(handMatrix(:,ind4(1)),4,'first'); %??
                result(4:7) = (NumSuits * (ind4(1) - 1) + suits4);
                hand = setdiff(cards,result(4:7));
                result(8) = hand(1);
                result(3) = ceil(hand(1)/NumSuits); %kicker value
                break;
            end
        case 'FH'
            % Check for Full House
            if ~isempty(ind3)
                ind23 = setdiff(ind2,ind3(1));
                if ~isempty(ind23)
                    % Found Full House
                    result(1) = jjdx;
                    result(2) = factorialBase2Dec([ind3, ind23], NumCards, 2); %TODO: Check if this is right?
                    result(3) = 1; %No valid kicker value
                    suits3 = find(handMatrix(:,ind3(1)),3,'first');
                    suits2 = find(handMatrix(:,ind23(1)),2,'first');
                    result(4:6) = (NumSuits * (ind3(1) - 1) + suits3);
                    result(7:8) = (NumSuits * (ind23(1) - 1) + suits2);
                    break;
                end
            end
        case 'F'
            % Check for Flush
            if ~isempty(indFl)
                % Found FlushcardNumFl
                result(1) = jjdx;
                cardNumFl = find(handMatrix(indFl(1),:),5,'first');
                result(2) = factorialBase2Dec(cardNumFl, NumCards, 5); %handvalue
                result(3) = 1; %No valid kicker value
                result(4:8) = (NumSuits * (cardNumFl - 1) + indFl(1));
                break;
            end
        case 'S'
            % Check for Straight
            startInd = strfind([NumEachCard NumEachCard(1)] > 0,ones(1,5));
            if ~isempty(startInd)
                % Found Straight
                result(1) = jjdx;
                result(2) = startInd(1);
                result(3) = 1; %No valid kicker for a straight
                if (startInd(1) == (NumCards - 3))
                    for idx = 1:4
                        result(idx + 3) = NumSuits * (startInd(1) + idx - 2) + find(handMatrix(:,startInd(1) + idx - 1),1,'first');
                    end
                    result(6) = find(handMatrix(:,1),1,'first');
                else
                    for idx = 1:5
                        result(idx + 3) = NumSuits * (startInd(1) + idx - 2) + find(handMatrix(:,startInd(1) + idx - 1),1,'first');
                    end
                end
                break;
            end
        case '3K'
            % Check for Three of a Kind
            if ~isempty(ind3)
                % Found Three of a Kind
                result(1) = jjdx;
                result(2) = ind3(1);
                suits3 = find(handMatrix(:,ind3(1)),3,'first');
                result(4:6) = (NumSuits * (ind3(1) - 1) + suits3);
                hand = setdiff(cards,result(4:6));
                result(7:8) = hand(1:2);
%                 result(3) = NumCards*floor((hand(1)-1)/4) + floor((hand(2)-1)/4) + 1; %kicker value
                factorialBaseCards = floor((hand(1:2)-1)./4) + 1;
                result(3) = factorialBase2Dec(factorialBaseCards, NumCards, 2); %kickervalue
                break;
            end
        case '2P'
            % Check for Two Pair
            if (length(ind2) >= 2)
                % Found Two Pair
                result(1) = jjdx;
                result(2) = factorialBase2Dec(ind2, NumCards, 2); %handvalue
                suits2a = find(handMatrix(:,ind2(1)),2,'first');
                suits2b = find(handMatrix(:,ind2(2)),2,'first');
                result(4:5) = (NumSuits * (ind2(1) - 1) + suits2a);
                result(6:7) = (NumSuits * (ind2(2) - 1) + suits2b);
                hand = setdiff(cards,result(2:5));
                result(8) = hand(1);
                result(3) = floor((hand(1)-1)/4) + 1; %kicker value
                break;
            end
        case '1P'
            % Check for One Pair
            if ~isempty(ind2)
                % Found One Pair
                result(1) = jjdx;
                result(2) = ind2(1);
                suits2 = find(handMatrix(:,ind2(1)),2,'first');
                result(4:5) = (NumSuits * (ind2(1) - 1) + suits2);
                hand = setdiff(cards,result(4:5));
                result(6:8) = hand(1:3);
%                 result(3) = NumCards^2*floor((hand(1)-1)/4) + NumCards*floor((hand(2)-1)/4) + NumCards*floor((hand(3)-1)/4) + 1; %kicker value
                factorialBaseCards = floor((hand(1:3)-1)./4) + 1;
                result(3) = factorialBase2Dec(factorialBaseCards, NumCards, 3); %kickervalue
                break;
            end
        case 'H'
            % High Card
            result(1) = jjdx;
            result(2) = floor((cards(1)-1)/4) + 1;
            factorialBaseCards = floor((cards(2:5)-1)./4) + 1;
            result(3) = factorialBase2Dec(factorialBaseCards, NumCards, 4); %kickervalue
%             result(3) = NumCards^3*floor((cards(2)-1)/4) + NumCards^2*floor((cards(3)-1)/4) + NumCards*floor((cards(4)-1)/4) + floor((cards(5)-1)/4) + 1; %kicker value
            result(4:8) = cards(1:5);
            break;
        otherwise
          error('Hand type not supported');
    end
end

maxHandValue = NumCards^2; %is atleast an upper limit
maxKickerValue = NumCards^5; %is atleast an upper limit
handRanking = result(1)*maxHandValue*maxKickerValue*4 + result(2)*maxKickerValue*2 + result(3); %TODO: Without multiplying by 4 and 2 here we get slightly wrong results. We should calculate handranking much better in the future
handResult = Hands{result(1)};
bestCards = result(4:8);



