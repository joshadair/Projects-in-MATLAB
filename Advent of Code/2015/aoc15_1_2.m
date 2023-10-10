function floor = aoc15_1_2(input)
floor=0;

for idx=1:length(input)
    if input(idx)=='('
        floor=floor+1;
    elseif input(idx)==')'
        floor=floor-1;
    end

    if floor==-1
        floor=idx;
        return
    end    
end

end
