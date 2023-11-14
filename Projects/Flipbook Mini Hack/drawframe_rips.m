function drawframe_rips(f)

tablesize=100;
pebbles=5;

out=zeros(tablesize);
timer=out;
rng(1);
locs_pebbles=randperm(tablesize^2,pebbles);
out(locs_pebbles)=2;
timer(locs_pebbles)=1;

for i1=1:f   
if f==1
    break;
end

rng(1);
new_peb=randi(tablesize^2);
if i1==1
out(new_peb)=2;
end
timer(new_peb)=i1;

out=padarray(out,[f f],0,'both');
timer=padarray(timer,[f f],0,'both');
[rpebs,cpebs]=find(timer>0);

for i2=1:numel(rpebs)
        t=timer(rpebs(i2),cpebs(i2));
        newrip=ones(2*t+1);
        newrip(2:end-1,2:end-1)=0;
        out(rpebs(i2)-t:rpebs(i2)+t,cpebs(i2)-t:cpebs(i2)+t)=out(rpebs(i2)-t:rpebs(i2)+t,cpebs(i2)-t:cpebs(i2)+t)+newrip;
        oldrip=ones(2*t-1);
        if t==1
            out(rpebs(i2),cpebs(i2))=out(rpebs(i2),cpebs(i2))-2;
        elseif t>1
            oldrip(2:end-1,2:end-1)=0;
            out(rpebs(i2)-(t-1):rpebs(i2)+(t-1),cpebs(i2)-(t-1):cpebs(i2)+(t-1))=out(rpebs(i2)-(t-1):rpebs(i2)+(t-1),cpebs(i2)-(t-1):cpebs(i2)+(t-1))-oldrip;
        end 

        timer(rpebs(i2),cpebs(i2))=t+1;
end
out=out(f+1:end-f,f+1:end-f);
timer=timer(f+1:end-f,f+1:end-f);
end
%cmp=colormap(turbo(max(max(timer))+1));
%out=ind2rgb(out,cmp);
imshow(out)
end

