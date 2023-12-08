function out=aoc23_3_2aux(data)
out=data;
i1=1;
while i1<=length(out)-1
    if sum(out(i1,2:3)==out(i1+1,2:3))~=2
        out(i1,:)=[];
        out=aoc23_3_2aux(out);
    end
    i1=i1+2;
end

end