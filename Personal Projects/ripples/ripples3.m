function frames=ripples3(numFrames,tablesize)
% adding f random pebbles at each frame iteration we see patterns emerge at
% higher orders within the chaos
% set tablesize nxn (ts), output image (o), timer matrix (tm), and seed
% random number generator (rng) so randomized pebbles remain in consistent
% locations as each frame is generated

% try large and small tablesize

o=zeros(tablesize);
tm=o;
frames=[];
frames=cat(3,frames,o);

nP=randi(tablesize^2);
tm(nP)=1;

while size(frames,3)<numFrames

    % add random pebble every nth iteration
    if size(frames,3)<(numFrames/2)
        n=1;
        if mod(size(frames,3),n)==0
            nP=randi(tablesize^2);
            if tm(nP)==0
                tm(nP)=1;
            end
        end
    end

    % pad output and timer with extra space for ripple overflow to be trimmed later
    o=padarray(o,[numFrames numFrames]);
    tm=padarray(tm,[numFrames numFrames]);
    [rP,cP]=find(tm>0);

    % core loop for evaluating locations>0 in timer matrix (value equates to how
    % many turns have lapsed since pebble dropped at this location) and drawing new ripples at
    % these locations while also erasing old ripples
    for i2=1:numel(rP)
        row=rP(i2);
        col=cP(i2);
        t=tm(row,col);

        newrip=ones(2*t+1);
        newrip(2:end-1,2:end-1)=0;
        o(row-t:row+t,col-t:col+t)=o(row-t:row+t,col-t:col+t)+newrip;

        oldrip=ones(2*t-1);
        if t>1
            oldrip(2:end-1,2:end-1)=0;
        end
        o(row-(t-1):row+(t-1),col-(t-1):col+(t-1))=o(row-(t-1):row+(t-1),col-(t-1):col+(t-1))-oldrip;

        if t<=tablesize
            tm(row,col)=t+1;
        else
            tm(row,col)=0;
        end
    end

    % trim overflow padding so output and timer both back to ts
    o=o(numFrames+1:end-numFrames,numFrames+1:end-numFrames);
    tm=tm(numFrames+1:end-numFrames,numFrames+1:end-numFrames);

    frames=cat(3,frames,o);
end
end