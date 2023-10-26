function out=aoc15_12_2help(in);
out=[];
for i1=1:length(in)
    if contains(in(i1),"red")==1
    out=[out;in(i1)];
    end
end

end

