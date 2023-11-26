function o=bullseyezeros(n)
v1=ceil(n/2);
o=zeros(n+(v1-1)*2);
c=0;

for i1=(n+(v1-1)*2):-4:1
    v2=ceil(n/2)-c;
    r=zeros(i1); 
    r(1,:)=v2;
    r(end,:)=v2;
    r(:,end)=v2;
    r(:,1)=v2;
    
    %o=o+padarray(r,(((n+(v1-1)*2))-i1)/2);
    o=o+padarray(r,[(((n+(v1-1)*2))-i1)/2 (((n+(v1-1)*2))-i1)/2],0,'both');

    c=c+1;
end
end