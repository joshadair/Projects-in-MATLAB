function [o2,lengths]=aoc23_11_1(in)
[row,col]=size(in);
o1=[];
lengths=[];

for i1=1:row
    if ismember('#',in(i1,:))==0
        o1=[o1;in(i1,:);in(i1,:)];
    else
        o1=[o1;in(i1,:)];
    end
end

o2=[];
for i1=1:col
    if ismember('#',o1(:,i1))==0
        o2=[o2 o1(:,i1) o1(:,i1)];
    else
        o2=[o2 o1(:,i1)];
    end
end

[rLocs,cLocs]=ind2sub(size(o2),find(o2=='#'));

for i1=1:length(rLocs)-1
    for i2=i1+1:length(rLocs)
        lengths=[lengths;abs(rLocs(i2)-rLocs(i1))+abs(cLocs(i2)-cLocs(i1))];
    end
end

end
