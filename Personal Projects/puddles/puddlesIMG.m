function frames=puddlesIMG(ts,nFrames,img)
% adding f random pebbles at each frame iteration we see patterns emerge at
% higher orders within the chaos
% set ts nxn (ts), output image (o), timer matrix (tm), and seed
% random number generator (rng) so randomized pebbles remain in consistent
% locations as each frame is generated

% try large and small ts
o=zeros(ts);
tm=o;

% use starting image (im) for pebble locations
if ~exist('img','var')
    imgR=[12 12 12 25 25 25 37 37 37 50 50 50 50 50 50 63 63 63 75 75 75 88 88 88];
    imgC=[12 50 88 25 50 75 37 50 63 25 37 63 12 88 75 37 50 63 50 25 75 12 50 88];
    imgR=uint16(ts/100*imgR);
    imgC=uint16(ts/100*imgC);
    for i1=1:numel(imgR)
        tm(imgR(i1),imgC(i1))=1;
    end
else
    tm=img;
end

frames=[];
frames=cat(3,frames,tm);

while size(frames,3)<nFrames
    % pad output and timer with extra space for ripple overflow to be trimmed later
    o=padarray(o,[nFrames nFrames]);
    tm=padarray(tm,[nFrames nFrames]);
    [rP,cP]=find(tm>0);

    % core loop for evaluating locations>0 in timer matrix (value equates to how
    % many turns have lapsed since pebble dropped at this location) and drawing new ripples at
    % these locations while also erasing old ripples
    for i2=1:numel(rP)
        row=rP(i2);
        col=cP(i2);
        t=tm(row,col);

        newRip=t*ones(2*t+1);
        newRip(2:end-1,2:end-1)=0;
        o(row-t:row+t,col-t:col+t)=o(row-t:row+t,col-t:col+t)+newRip;
        oldRip=ones(2*t-1);
        o(row-(t-1):row+(t-1),col-(t-1):col+(t-1))=o(row-(t-1):row+(t-1),col-(t-1):col+(t-1))-oldRip;
        o(o<0)=0; %prevent 'over-subtraction' of ripples?

        if t<=ts
            tm(row,col)=t+1;
        else
            tm(row,col)=0;
        end
    end

    % trim overflow padding so output and timer both back to ts
    o=o(nFrames+1:end-nFrames,nFrames+1:end-nFrames);
    tm=tm(nFrames+1:end-nFrames,nFrames+1:end-nFrames);

    frames=cat(3,frames,uint16(o));
end
end