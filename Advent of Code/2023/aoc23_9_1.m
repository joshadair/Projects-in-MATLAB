function [sum,o]=aoc23_9_1(in)
o=in;
sum=0;
counter=1;

while any(unique(o(end,:)))
    newRow=zeros(1,size(o,2));
    o=[o;newRow];

    for i1=1:size(o,2)-counter
        o(end,i1)=o(end-1,i1+1)-o(end-1,i1);
    end
    counter=counter+1;
end

for i1=1:size(o,1)
    sum=sum+o(i1,end-i1+1);
end


end



