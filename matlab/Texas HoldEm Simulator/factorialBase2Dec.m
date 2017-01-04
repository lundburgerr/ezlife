function r = factorialBase2Dec(t,n,k)%,nCk_mapping)
%nCk_mapping = zeros(n-1, k-1);
%for kk=1:k
%    for nn=kk:n-1
%        nCk_mapping(nn,kk) = nchoosek(nn, kk-1);
%    end
%end

%Loop over all cards and calculate factorial base without holes in decimal for all values
t = sort([0, t]);
r = 1;
for i=1:k
    if t(i) + 1 <= t(i+1) - 1
        for j=t(i)+1:t(i+1) - 1
%             r = r + nCk_mapping(n-j, k-i);
            r = r + nchoosek(n - j, k - i);
        end 
    end
end