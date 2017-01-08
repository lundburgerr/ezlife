function [hands, probability] = handRange2WeightedHands(handRange, knownCards)
%Naive solution to generating real hands (tuples) with it's corresponsindg
%probability from handRange, exluding hands that contain cards in
%knownCards
%No suit ismorophism is used

numCards = 13;
numSuits = 4;

playedHands = find(handRange ~= 0);
numHands = length(playedHands);
hands = cell(numHands*4*3, 1); %Upper bound to number of hands
probability = zeros(numHands*4*3, 1); %Upper bound to number of hands
counter = 1;

%We don't calculate permutations, halving the amount of hands, i.e KS,QH == QH,KS
%TODO: No suit isomorphysm used knowing the known cards
for n = playedHands'
    row = ceil(n/numCards);
    col = mod(n-1, numCards)+1;
    if col > row %Unsuited hands
        for kk = 1:numSuits
            c1 = (row-1)*numSuits + kk;
            for pp = 1:numSuits
                if kk == pp, continue, end;
                c2 = (col-1)*numSuits + pp;
                if ~any(c1 == knownCards) && ~any(c2 == knownCards)
                    hands{counter} = [c1, c2];
                    probability(counter) = handRange(row, col);
                    counter = counter + 1;
                end
            end
        end
    elseif col < row %Suited hands
        for kk = 1:numSuits
            c1 = (col-1)*numSuits + kk;
            c2 = (row-1)*numSuits + kk;
            if ~any(c1 == knownCards) && ~any(c2 == knownCards)
                hands{counter} = [c1, c2];
                probability(counter) = handRange(row, col);
                counter = counter + 1;
            end
        end
    else %Pocket pairs
        for kk = 1:numSuits-1
            c1 = (row-1)*numSuits + kk;
            for pp = kk+1:numSuits
                c2 = (col-1)*numSuits + pp;
                if ~any(c1 == knownCards) && ~any(c2 == knownCards)
                    hands{counter} = [c1, c2];
                    probability(counter) = handRange(row, col);
                    counter = counter + 1;
                end
            end
        end
    end
end

hands = hands(1:counter-1);
probability = probability(1:counter-1)/sum(probability(1:counter-1));