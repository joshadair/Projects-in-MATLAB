function o=bullseyezeros2(n)
if n==1
    o=1;
    return;
end

o=zeros(4*n-3);
o(floor((4*n-3)/2)+1,floor((4*n-3)/2)+1)=1;

for i1=n:-1:2
        r=zeros(4*i1-3); 
        r(1,:)=i1;
        r(end,:)=i1;
        r(:,end)=i1;
        r(:,1)=i1;
    o=o+paddata(r,[4*n-3 4*n-3],Side="both");
end
end