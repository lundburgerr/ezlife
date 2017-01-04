function idx = handIndex(hand,n,k, nCk_mapping)
%nCk_mapping = zeros(51, 6);
%for k=1:7
%    for n=k:51
%        nCk_mapping(n,k) = nchoosek(n, k-1);
%    end
%end


%Sort hand
t = sort(hand); %t=2.09, 1000000

%Remap hand, (first card is a spade, rest dont matter)
% suit = mod(t(1)-1, 4)+1;
% t(mod(t, 4) == suit) = t(mod(t, 4) == suit)-suit+1;
 suit = (t(1)-1) - 4.*floor((t(1)-1)./4) + 1; %Fst modulus instead of built in in matlab which is slow
 index_swap_to_spade = t - 4.*floor(t./4) == suit;
 t(index_swap_to_spade) = t(index_swap_to_spade)-suit+1;


%Loop over all cards and calculate factorial base without holes in decimal for all values
%except the first
idx = 1;
for i=1:k-1
    if t(i) + 1 <= t(i+1) - 1
        for j=t(i)+1:t(i+1) - 1
            idx = idx + nCk_mapping(n-j, k-i);%nchoosek(n - j, k - i); %t=1.06, 1000000
        end %t=1.05, 1000000
    end
end

%% Calculate added index from the first card
% Values below were calculated from a simulation, this is simpler and faster than other ways
t1_floored = floor((t(1)-1)/4)+1;
switch t1_floored
    case 2
        idx = idx + 18009460;
    case 3
        idx = idx + 28747033;
    case 4
        idx = idx + 34843487;
    case 5
        idx = idx + 38106110;
    case 6
        idx = idx + 39729270;
    case 7
        idx = idx + 40465551;
    case 8
        idx = idx + 40761561;
    case 9
        idx = idx + 40862508;
    case 10
        idx = idx + 40889640;
    case 11
        idx = idx + 40894645;
    case 12
        idx = idx + 40895107;
end

%     r = nCr(n,k);
%     for i=0:k-1
%         if n-comb(i+1)<k-i, continue, end
%         r = r-nCr(n-comb(i+1),k-i);
%     end
%     
% end
% 
% function val = nCr(n,r)
%     val = factorial(n) / factorial(r) / factorial(n-r);
% end