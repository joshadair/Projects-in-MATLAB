function [minimum,min_route,maximum,max_route] = aoc15_9_1(input)
dest=length(input);
p=perms(1:dest);
vals=zeros(length(p),1);

for idx1=1:length(p)
    val=0;
    for idx2=1:dest-1
        val=val+input(p(idx1,idx2),p(idx1,idx2+1));
    end
    vals(idx1)=val;
end

[minimum,loc1]=min(vals);
min_route=p(loc1,:);
[maximum,loc2]=max(vals);
max_route=p(loc2,:);

end





