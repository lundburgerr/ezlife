function [cards, Deck] = DrawCards(N, Deck)
% Draw N random cards from the deck (and remove them from deck)
% N     - Number of cards to draw
% Deck  - Remaining cards in the deck
    inds = randperm(length(Deck),N);
    cards = Deck(inds);
    Deck(inds) = [];
