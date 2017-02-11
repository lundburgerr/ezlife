function result = is_positive_integer(val)
result = 1;
if length(val) ~= 1
    result = 0;
end
if ceil(val) ~= floor(val)
    result = 0;
end
if val == Inf
    result = 0;
end
if val < 1
    result = 0;
end