function result = is_non_negative(val)
result = 1;
if length(val) ~= 1
    result = 0;
end
if val < 0
    result = 0;
end

