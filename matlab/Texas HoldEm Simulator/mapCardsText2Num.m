function cards = mapCardsText2Num(cardStr,num)
%Given a card in string return the mapping in an integer from 1 to 52
%cardStr    - format is like 'AS JD' with valid cards from A, K, Q, J, 10, 9,
%               ... and valid suits are S, D, H, C. Cards are seperated by
%               comma or space
%num        - Number of cards to map from cardStr, num cannot be more than
%               the number of cards in cardStr
    cards = zeros(1,num);
    for idx = 1:num
        [c cardStr] = strtok(cardStr,[',',' ']); %#ok
        cardStr = cardStr(2:end);
        cards(idx) = ParseUserCard(c);
    end
end


% Takes a string like 'AH' and converts it to a card
function card = ParseUserCard(cardStr)
    card = GetCard(cardStr);
    if (card == 0)
        card = ParseUserCard(ProcessUserInput(['Card ''' cardStr ''' was invalid.']));
    end
end

% Gets the card associated with a card string
function card = GetCard(cardStr)
    Cards = {'A','K','Q','J','10','9','8','7','6','5','4','3','2'};
    Suits = {'S','D','H','C'};
    NumSuits = 4;
    if isempty(cardStr)
        card = 0;
    else
        cardNum = find(strcmpi(Cards,cardStr(1:(end-1))));
        suit = find(strcmpi(Suits,cardStr(end)));
        if ((length(cardNum) ~= 1) || (length(suit) ~= 1))
            card = 0;
        else
            card = suit + (cardNum - 1) * NumSuits;
        end
    end
end