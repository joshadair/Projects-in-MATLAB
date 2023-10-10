function floor = aoc15_1_1(input)
floor=0;

for idx=1:length(input)
    if input(idx)=='('
        floor=floor+1;
    elseif input(idx)==')'
        floor=floor-1;
    end
end

end
