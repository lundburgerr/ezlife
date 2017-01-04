

% deck = 1:52;
% test_loops = 100000;
% hands = cell(1, test_loops);
% for n=1:test_loops
%     [hands{n}, ~] = DrawCards(7, deck);
% end
% tic
% for n=1:test_loops
%     [handRanking, bestCards] = BestHand(hands{n});
% end
% ttBC = toc;
% fprintf('Time besthand: %d s\n', ttBC/test_loops);
% 
% nCk_mapping = zeros(51, 6);
% for k=1:7
%     for n=k:51
%         nCk_mapping(n,k) = nchoosek(n, k-1);
%     end
% end
% tic
% for n=1:test_loops
%     index = handIndex(hands{n}, 52, 7, nCk_mapping);
% end
% ttHI = toc;
% fprintf('Time handindex: %d s\n', ttHI/test_loops);
% fprintf('Performance of HI: %d\n', ttBC/ttHI);
% 
% 
% return;

%Necessary for fast nCk
nCk_mapping = zeros(51, 6);
for k=1:7
    for n=k:51
        nCk_mapping(n,k) = nchoosek(n, k-1);
    end
end

Cards = {'A','K','Q','J','10','9','8','7','6','5','4','3','2'};
Suits = {'S','D','H','C'};
numSuits = 4;
numCards = 13;

%All possible cards
deck = 1:52;
spadesCards = 1:4:49; %We map the first card to be a spade
allHandRankings = zeros(40895114, 1); %Numerical value
% allHandResults = cell{40895114, 1};
counter = 0;
indexes = zeros(40895114, 1);
c1_ind = 0;
for c1 = spadesCards
    fprintf('c_ind=%d: %d\n', c1_ind, counter);
    c1_ind = c1_ind+1;
    for c2 = deck(deck > c1)
        for c3 = deck(deck > c2)
            for c4 = deck(deck > c3)
                for c5 = deck(deck > c4)
                    for c6 = deck(deck > c5)
                        for c7 = deck(deck > c6)
                            counter = counter+1;
                            allHandRankings(counter) = BestHand([c1, c2, c3, c4, c5, c6, c7]);
%                             idx =  handIndex([c1, c2, c3, c4, c5, c6, c7], 52, 7, nCk_mapping);
%                             if counter ~= idx
%                                 fprintf('counter = %d; idx = %d\n', counter, idx);
%                                 error('NOOOO')
%                             end
%                             if mod(counter, 10000) == 0
%                                 fprintf('%d: [%d, %d, %d, %d, %d, %d, %d]\n', counter, c1, c2, c3, c4, c5, c6, c7);
%                             end
%                             allHandRankings( = BestHand(hands{n});
                        end
                    end
                end
            end
        end
    end
end
save('allHandRankings.mat', 'allHandRankings');