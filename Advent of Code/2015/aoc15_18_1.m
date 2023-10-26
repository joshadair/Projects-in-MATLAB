function out=aoc15_18_1(in)
padded_in=padarray(in,[1 1],0,'both');
padded_in(2,2)=1;
padded_in(2,101)=1;
padded_in(101,2)=1;
padded_in(101,101)=1;
out=padded_in;
for count=1:100
    for r=2:101
        for c=2:101
            nhood=padded_in(r-1:r+1,c-1:c+1);
            hood_sum=sum(sum(nhood));
            if hood_sum<=2 || hood_sum>4
                out(r,c)=0;
            elseif hood_sum==3
                out(r,c)=1;
            end
        end
    end
    out(2,2)=1;
    out(2,101)=1;
    out(101,2)=1;
    out(101,101)=1;
    padded_in=out;
end
end


