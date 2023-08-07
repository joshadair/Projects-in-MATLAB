function [tf] = divisible_by_3(n_str)
[tf] = 0;
total = 0;

for x=1:length(n_str)
    total = total+str2num(n_str(x));
end

if total>10
    total = num2str(total);
    [tf] = divisible_by_3(total);
elseif sum(ismember([total],[3, 6, 9])) == 1
    [tf] = 1;
end

end
