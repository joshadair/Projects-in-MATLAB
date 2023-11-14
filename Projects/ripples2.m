function frames=ripples2(num_frames,tablesize,pebbles)
out=zeros(tablesize);
timer=out;
locs_pebbles=randperm(tablesize^2,pebbles);
out(locs_pebbles)=2;
timer(locs_pebbles)=1;
frames={};
frames{end+1}=out;
n=num_frames;

while numel(find(out>0))>0 && length(frames)<num_frames
    new_peb=randi(tablesize^2);
    out(new_peb)=2;
    timer(new_peb)=1;

    out=padarray(out,[n n],0,'both');
    timer=padarray(timer,[n n],0,'both');
    [rpebs,cpebs]=find(timer>0);
    for i1=1:numel(rpebs)
        t=timer(rpebs(i1),cpebs(i1));
        newrip=ones(2*t+1);
        newrip(2:end-1,2:end-1)=0;
        out(rpebs(i1)-t:rpebs(i1)+t,cpebs(i1)-t:cpebs(i1)+t)=out(rpebs(i1)-t:rpebs(i1)+t,cpebs(i1)-t:cpebs(i1)+t)+newrip;
        oldrip=ones(2*t-1);
        if t==1
            out(rpebs(i1)-(t-1):rpebs(i1)+(t-1),cpebs(i1)-(t-1):cpebs(i1)+(t-1))=out(rpebs(i1)-(t-1):rpebs(i1)+(t-1),cpebs(i1)-(t-1):cpebs(i1)+(t-1))-2*oldrip;
        elseif t>1
            oldrip(2:end-1,2:end-1)=0;
            out(rpebs(i1)-(t-1):rpebs(i1)+(t-1),cpebs(i1)-(t-1):cpebs(i1)+(t-1))=out(rpebs(i1)-(t-1):rpebs(i1)+(t-1),cpebs(i1)-(t-1):cpebs(i1)+(t-1))-oldrip;
        end 

        timer(rpebs(i1),cpebs(i1))=timer(rpebs(i1),cpebs(i1))+1;
    end

    out=out(n+1:end-n,n+1:end-n);
    timer=timer(n+1:end-n,n+1:end-n);
    frames{end+1}=out;
end

cell2vid(frames,"ripples.mp4",5);
end

