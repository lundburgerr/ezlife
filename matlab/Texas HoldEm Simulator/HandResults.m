function [ranking, result] = HandResults(PlayersCards, commonCards)
%Compares the results of several hands
%PlayersCards   - is a Nx2 matrix, where N is the number of players
%commonCards    - is a vector containing 3 to 5 elements which is the cards on the board
%ranking        - is the relative ranking of the playersCards
%result         - is the result from BestHand for each player

% Return results of hand
[~, NumPlayers] = size(PlayersCards);
result = zeros(NumPlayers,6);
for jjj = 1:NumPlayers
    if ~isempty(find(PlayersCards(jjj,:) == 0,1))
        result(jjj,:) = [(NumHands + 1) 0 0 0 0 0];
    else
        result(jjj,:) = BestHand([PlayersCards(jjj,:) commonCards]);
    end
end

% Figure out who won the hand
results = sum(result .* repmat(logspace(2,-8,6),NumPlayers,1),2);
[~,ranking] = sort(results);

end
