function cardsText = mapCardsNum2Text(cardsNum)
Cards = {'A','K','Q','J','T','9','8','7','6','5','4','3','2'};
Suits = {'S','D','H','C'};

if isempty(cardsNum)
    cardsText = blanks(0);
    return;
end

inputCards = ceil(cardsNum./4);
inputSuits = (cardsNum-1) - 4.*floor((cardsNum-1)./4) + 1; %mod(cardsNum-1, 4) + 1; %Fast modulus mod(x,a) = x - a.*floor(x/4)
N = length(cardsNum);
cardsText = blanks(2*N + 2*(N-1));
cardsText(1) = Cards{inputCards(1)};
cardsText(2) = Suits{inputSuits(1)};
for n=2:N
    cardsText(4*(n-1) - 1) = ',';
    cardsText(4*(n-1) + 1) = Cards{inputCards(n)};
    cardsText(4*(n-1) + 2) = Suits{inputSuits(n)};
end