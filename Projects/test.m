n_str = '124'

ones = str2num(n_str(end));
tens = str2num(n_str(end-1));


if ismember(tens,[0 2 4 6 8]) && ismember(ones,[0 4 8]) == true
    [tf] = 1;
elseif ismember(tens,[1 3 5 7 9]) && ismember(ones,[2 6]) == true
    [tf] = 1;
else
    [tf] = 0;
end

