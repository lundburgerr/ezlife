function result = is_poker_cards(cards)
result = 1;
if ~isnumeric(cards)
    result = 0;
    return;
end

for k=1:length(cards(:))
    if cards(k) < 1 || cards(k) > 52 || ~is_positive_integer(cards(k))
        result = 0;
        break;
    end
end



