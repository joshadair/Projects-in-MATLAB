function total=aoc15_12_2aux(in)
total=0;
for i1=1:length(in)
    out=aoc15_12_1(in{i1});
    total=total+sum(out);
end


end