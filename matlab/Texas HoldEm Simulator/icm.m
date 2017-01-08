function equity = icm(payouts, stacks, pindex)
%See: http://forumserver.twoplustwo.com/32/beginners-questions/independent-chip-model-algorithm-wanted-139980/
% http://www.holdemresources.net/hr/sngs/icm/icmjava.html
%
%The limitations of ICM:
%ICM does not consider the position of a player (a 4BB stack on the button is usually much more valuable than the same stack in first position)
%ICM does not take skill differences into account
%ICM does not consider potential future situations (sometimes it’s better to pass on small edges and wait for a larger edge).

total = 0; 
for i = 1:length(stacks) 
    total = total + stacks(i);
end
equity = getEquity(payouts, stacks, total, pindex, 1);

end


function equity = getEquity(payouts, stacks, total, pindex, depth)
    Plen = length(payouts);
    equity = stacks(pindex)/total * payouts(depth); 
    if depth < Plen
        for i = 1:length(stacks)
            if i ~= pindex && stacks(i) > 0
                c = stacks(i); 
                stacks(i) = 0; 
                equity = equity + getEquity(payouts, stacks, total - c, pindex, depth +  1) * c / total; 
                stacks(i) = c; 
            end
        end
    end
end










% equity = 0;
% for pp = 1:length(payouts)
%     probPlaceN = 0; %probability to place in place N
%     for mm = 1:length(stacks)
%         if mm == pindex, continue, end;
%         
%         %Calculate product in the general term, see http://www.pokerhelper.com/independent-chip-modeling/
%         product = 1;
%         for ii = 1:pp
%             product = product*
%         end
%         
%         %Calculate stackRatio which is the term multiplied by the product
%         %in every iteration for each player (stack)
%         stackRatio = stacks(pindex)/
%         
%         %Add the probability of this player finishing in 
%         probPlaceN = probPlaceN + product*stackRatio;
%     end
%     equity = equity + payouts(pp)*probPlaceN;