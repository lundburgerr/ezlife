function calculateEquity(playerHand, oppRange)

%Load handrankings for any seven card hand
S = load('allHandRankings.mat', 'allHandRankings');
allHandRankings = S.allHandRankings;

%Necessary for fast nCk
nCk_mapping = zeros(51, 6);
for k=1:7
    for n=k:51
        nCk_mapping(n,k) = nchoosek(n, k-1);
    end
end

%Retrieve hands and probabilities from range
[oppHands, oppHandsProb] = handRange2WeightedHands(oppRange, playerHand);
[oppHandsProb, sortIdx] = sort(oppHandsProb, 'descend');
oppHands = oppHands(sortIdx);

%Create deck
deckStart = 1:52;
idx = ismember(deckStart, playerHand); 
deckStart(idx) = []; %Remove playerhand from deck

%Calculate equity
numSim = 50000;
p1wins = 0;
p2wins = 0;
chop = 0;
counter = 1;
counterHands = 1;
tic
while counter <= numSim
    oppHand = oppHands{counterHands};
    numSimHand = ceil(oppHandsProb(counterHands)*numSim);
    idx = ismember(deckStart, oppHand); 
    deckHand = deckStart;
    deckHand(idx) = []; %Remove opponent hand from deck
    counterHands = counterHands + 1;
    for n=1:numSimHand
        % Draw 5 cards
        table = drawCardsFast(5, deckHand);
        
        %Calculate handRanking directly
%         ranking = handComparison([playerHand; oppHand], table);
%         r1 = ranking(1);
%         r2 = ranking(2);
        
        %Calculate handRanking fast from precalculated array
        idx1 = handIndex([p1, table], 52, 7, nCk_mapping);
        idx2 = handIndex([p2, table], 52, 7, nCk_mapping);
        r1 = allHandRankings(idx1);
        r2 = allHandRankings(idx2);
        
        %Compare ranking between hands
        if r1 < r2
            p1wins = p1wins + 1;
        elseif r1 > r2
            p2wins = p2wins + 1;
        else
            chop = chop + 1;
        end
        
        %Increase counter
        counter = counter + 1;
    end
end
toc
fprintf('P1 wins: %.1f%%\n', p1wins/numSim*100);
fprintf('P2 wins: %.1f%%\n', p2wins/numSim*100);
fprintf('chop: %.1f%%\n', chop/numSim*100);
