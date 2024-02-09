function out=aoc15_20_1(in)
out=zeros(1,in*10);
for i1=1:in
    out(i1:i1:end)=out(i1:i1:end)+i1*10;
end


end