function cards = drawCardsFast(N, Deck)
% Draw N random cards from the deck (and remove them from deck)
% N     - Number of cards to draw
% Deck  - Remaining cards in the deck
    inds = randperm(length(Deck),N); %t=1.78, 1000000
    cards = Deck(inds); %t=0.65, 1000000