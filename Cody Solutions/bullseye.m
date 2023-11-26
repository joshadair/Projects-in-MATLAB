function o=bullseye(n)
o=zeros(n);

for i1=n:-2:1
    v=ceil(i1/2);
    r=zeros(i1); 
    r(1,:)=v;
    r(end,:)=v;
    r(:,end)=v;
    r(:,1)=v; 
    o=o+padarray(r,[(n-i1)/2 (n-i1)/2],0,'both');
end
end