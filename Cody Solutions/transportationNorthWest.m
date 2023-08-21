function [assignmentMatrix, totalCost] = transportationNorthWest(x)
[row,col]=size(x);
a=zeros(row,col);
a(end,:)=x(end,:);
a(:,end)=x(:,end);
c=1;
for r=1:row-1
    while a(r,end)~=0   
        a(r,c) = min(a(end,c),a(r,end));   
        a(r,end) = a(r,end)-a(r,c);
        c=c+1;
    end
    c=c-1;
end

end