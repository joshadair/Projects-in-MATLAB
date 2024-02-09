function [o,index]=aoc15_25_1(n)
o=zeros(n);
index=o;
count=1;

for i1=1:n
    for i2=1:i1
        if count==1
            o(1)=20151125;
            index(1)=1;
            prev=20151125;
            count=count+1;
            continue
        end
        o(i1-i2+1,i2)=mod(prev*252533,33554393);
        prev=o(i1-i2+1,i2);
        index(i1-i2+1,i2)=index(i1-i2+1,i2)+count;
        count=count+1;
    end
end

%{
o2=zeros(n);
o2(1)=20151125;


for index=2:n*(n+1)/2
    pLoc=find(o==index-1);
    aLoc=find(o==index);
    o2(aLoc)=mod(o2(pLoc)*252533,33554393);
end
%}




end