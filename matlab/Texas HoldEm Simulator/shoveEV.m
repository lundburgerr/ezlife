
S = load('allHandRankings.mat', 'allHandRankings');
allHandRankings = S.allHandRankings;

%Necessary for fast nCk
nCk_mapping = zeros(51, 6);
for k=1:7
    for n=k:51
        nCk_mapping(n,k) = nchoosek(n, k-1);
    end
end

p1 = mapCardsText2Num('8C, 7D', 2);
p2 = mapCardsText2Num('AS, AH', 2);
Deck = 1:52;
idx = ismember(Deck, p1); Deck(idx) = [];
idx = ismember(Deck, p2); Deck(idx) = [];

numSim = 100000;
p1wins = 0;
p2wins = 0;
chop = 0;
tic
for n=1:numSim
    % Draw 5 cards
   table = drawCardsFast(5, Deck);
   
   %Calculate handRanking directly
%    ranking = handComparison([p1; p2], table);
%    r1 = ranking(1);
%    r2 = ranking(2);

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
    
end
toc

fprintf('P1 wins: %.1f\n', p1wins/numSim*100);
fprintf('P2 wins: %.1f\n', p2wins/numSim*100);
fprintf('chop: %.1f\n', chop/numSim*100);