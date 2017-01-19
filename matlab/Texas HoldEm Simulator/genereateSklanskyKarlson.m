

cards = 'AKQJT98765432';
handString = 'AA,KK,AKs,QQ,AKo,JJ,AQs,TT,AQo,99,AJs,88,ATs,AJo,77,66,ATo,A9s,55,A8s,KQs,44,A9o,A7s,KJs,A5s,A8o,A6s,A4s,33,KTs,A7o,A3s,KQo,A2s,A5o,A6o,A4o,KJo,QJs,A3o,22,K9s,A2o,KTo,QTs,K8s,K7s,JTs,K9o,K6s,QJo,Q9s,K5s,K8o,K4s,QTo,K7o,K3s,K2s,Q8s,K6o,J9s,K5o,Q9o,JTo,K4o,Q7s,T9s,Q6s,K3o,J8s,Q5s,K2o,Q8o,Q4s,J9o,Q3s,T8s,J7s,Q7o,Q2s,Q6o,98s,Q5o,J8o,T9o,J6s,T7s,J5s,Q4o,J4s,J7o,Q3o,97s,T8o,J3s,T6s,Q2o,J2s,87s,J6o,98o,T7o,96s,J5o,T5s,T4s,86s,J4o,T6o,97o,T3s,76s,95s,J3o,T2s,87o,85s,96o,T5o,J2o,75s,94s,T4o,65s,86o,93s,84s,95o,T3o,76o,92s,74s,54s,T2o,85o,64s,83s,94o,75o,82s,73s,93o,65o,53s,63s,84o,92o,43s,74o,72s,54o,64o,52s,62s,83o,42s,82o,73o,53o,63o,32s,43o,72o,52o,62o,42o,32o';
hands = regexp(handString, '\s*,*\s*', 'split');
numNonPPcombinations = (169-13)/2;

Sklansky = zeros(169,2);
pocket = zeros(13,2);
offSuited = zeros(numNonPPcombinations,2);
suited = zeros(numNonPPcombinations,2);

SklanskyOrdering = [];%zeros(1,169);
pocketOrdering = [];%zeros(1,13);
offSuitedOrdering = [];%zeros(1,(169-13)/2);
suitedOrdering = [];%zeros(1,(169-13)/2);

ordering = 1;
indexS = 1;
indexO = 1;
for hh = hands
    hand = hh{1};
    if length(hand) == 3
        k1 = strfind(cards, hand(1));
        k2 = strfind(cards, hand(2));
        switch hand(3)
            case 's'
                handTuple = [k1, k2];
                suited(indexS, :) = handTuple;
                suitedOrdering(end+1) = ordering;
                indexS = indexS + 1;
            case 'o'
                handTuple = [k2, k1];
                offSuited(indexO, :) = handTuple;
                offSuitedOrdering(end+1) = ordering;
                indexO = indexO + 1;
        end
    elseif length(hand) == 2
        k = strfind(cards, hand(1));
        handTuple = [k,k];
        pocket(k,:) = handTuple;
        pocketOrdering(end+1) = ordering;
    end
    Sklansky(ordering, :) = handTuple;
    SklanskyOrdering(end+1) = ordering;
    ordering = ordering + 1;
end

%% Print out all hands so that I can easily put them into an array
%pocket pairs
for n=1:13
    fprintf('[%d, %d]; ', pocket(n,1), pocket(n,2));
end
fprintf('\n');
for n=1:13
    fprintf('%d, ', pocketOrdering(n));
end
fprintf('\n\n');

%suited hands
for n=1:(169-13)/2
    fprintf('[%d, %d]; ', suited(n,1), suited(n,2));
end
fprintf('\n');
for n=1:numNonPPcombinations
    fprintf('%d, ', suitedOrdering(n));
end
fprintf('\n\n');

%offsuited hands
for n=1:numNonPPcombinations
    fprintf('[%d, %d]; ', offSuited(n,1), offSuited(n,2));
end
fprintf('\n');
for n=1:numNonPPcombinations
    fprintf('%d, ', offSuitedOrdering(n));
end
fprintf('\n\n');

%All hands
for n=1:169
    fprintf('[%d, %d]; ', Sklansky(n,1), Sklansky(n,2));
end
fprintf('\n');
for n=1:169
    fprintf('%d, ', SklanskyOrdering(n));
end
fprintf('\n\n');



