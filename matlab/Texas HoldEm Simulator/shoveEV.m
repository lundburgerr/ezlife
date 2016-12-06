

p1 = mapCardsText2Num('8D, 7D', 2);
p2 = mapCardsText2Num('AS, JS', 2);
Deck = 1:52;
Deck(p1) = [];
Deck(p2) = [];

numSim = 30000;
p1wins = 0;
p2wins = 0;
chop = 0;
tic
parfor n=1:numSim
   table = DrawCards(5, Deck);
   [ranking, result] = HandResult([p1; p2], table);
   p1wins = p1wins + (ranking(1)<ranking(2));
   p2wins = p2wins + (ranking(1)>ranking(2));
   chop = chop + (ranking(1)==ranking(2));
end
toc

fprintf('P1 wins: %.1f\n', p1wins/numSim*100);
fprintf('P2 wins: %.1f\n', p2wins/numSim*100);
fprintf('chop: %.1f\n', chop/numSim*100);