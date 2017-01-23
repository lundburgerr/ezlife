function result = is_bool(val)

if length(val) ~= 1
    result = 0;
end

if val == 0 || val == 1
    result = 1;
else
    result = 0;
end


