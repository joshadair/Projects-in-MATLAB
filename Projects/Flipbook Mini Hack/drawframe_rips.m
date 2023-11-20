function [ind,o]=drawframe_rips(f)

ts=100;
p=1;

o=zeros(ts);
tm=o;
rng(1);
lcP=randperm(ts^2,p);
o(lcP)=2;
tm(lcP)=1;


for i1=1:f   
if f==1
    break;
end

rng(1);
nP=randi(ts^2,round(i1/.75)+1);
if i1==1
o(nP)=2;
end
tm(nP)=i1;

o=padarray(o,[f f],0,'both');
tm=padarray(tm,[f f],0,'both');
[rP,cpebs]=find(tm>0);

for i2=1:numel(rP)
        t=tm(rP(i2),cpebs(i2));
        newrip=ones(2*t+1);
        newrip(2:end-1,2:end-1)=0;
        o(rP(i2)-t:rP(i2)+t,cpebs(i2)-t:cpebs(i2)+t)=o(rP(i2)-t:rP(i2)+t,cpebs(i2)-t:cpebs(i2)+t)+newrip;
        oldrip=ones(2*t-1);
        if t==1
            o(rP(i2),cpebs(i2))=o(rP(i2),cpebs(i2))-2;
        elseif t>1
            oldrip(2:end-1,2:end-1)=0;
            o(rP(i2)-(t-1):rP(i2)+(t-1),cpebs(i2)-(t-1):cpebs(i2)+(t-1))=o(rP(i2)-(t-1):rP(i2)+(t-1),cpebs(i2)-(t-1):cpebs(i2)+(t-1))-oldrip;
        end 

        tm(rP(i2),cpebs(i2))=t+1;
end
o=o(f+1:end-f,f+1:end-f);
tm=tm(f+1:end-f,f+1:end-f);
end
cmp=colormap(turbo(max(max(o))));
o=uint8(o);
o=imresize(o,[1000 1000],'box');
ind=o;
o=ind2rgb(o,cmp);
imshow(o)
end

