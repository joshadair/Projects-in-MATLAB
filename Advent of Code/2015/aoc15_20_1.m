function out=aoc15_20_1(in)
out=zeros(in*10,10);
for i1=1:in
    for i2=1:10
        out(i1*i2,10-i2+1)=i1*10;
    end
end


end