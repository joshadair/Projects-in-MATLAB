function [o2,lengths]=aoc23_11_2(in,n)
[row,col]=size(in);
lengths=[];

o1=[];
rowInsert=zeros(n,col);
%rowInsert(:,:)='.';
%rowInsert=char(rowInsert);
for i1=1:row
    if ismember(1,in(i1,:))==0
       o1=[o1;rowInsert];
    else
        o1(end+1,:)=in(i1,:);
    end
end

o2=[];
[row,col]=size(o1);
colInsert=zeros(row,n);
%colInsert(:,:)='.';
%colInsert=char(colInsert);
for i1=1:col
    if ismember(1,o1(:,i1))==0
        o2=[o2 colInsert];
    else
        o2=[o2 o1(:,i1)];
    end
end

[rLocs,cLocs]=ind2sub(size(o2),find(o2==1));

for i1=1:length(rLocs)-1
    for i2=i1+1:length(rLocs)
        lengths=[lengths;abs(rLocs(i2)-rLocs(i1))+abs(cLocs(i2)-cLocs(i1))];
    end
end

end
