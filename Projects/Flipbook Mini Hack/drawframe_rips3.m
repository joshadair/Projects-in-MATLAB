function [im,matrix,timer]=drawframe_rips3(f,in_o,in_tm)
% set tablesize nxn (ts), output image (o), timer matrix (tm), and seed
% random number generator (rng) so randomized pebbles remain in consistent
% locations as each frame is generated
ts=1000;

if f==1
    o=zeros(ts);
    tm=o;

    % use starting image (im) for pebble locations
    imr=[12 12 12 25 25 25 37 37 37 50 50 50 50 50 50 63 63 63 75 75 75 88 88 88];
    imc=[12 50 88 25 50 75 37 50 63 25 37 63 12 88 75 37 50 63 50 25 75 12 50 88];
    imr=imr*10;
    imc=imc*10;
    for i1=1:numel(imr)
        tm(imr(i1),imc(i1))=1;
    end
else
    o=in_o;
    tm=in_tm;
end

if f==1
    o=tm;
    matrix=o;
    timer=tm;
    im=uint16(o);
    cmp=colormap(turbo(1+max(max(im))));
    im=ind2rgb(im,cmp);
    imshow(im)
    return;
end

% pad output and timer with extra space for ripple overflow to be trimmed later
o=paddata(o,[ts+2*f ts+2*f],Side="both");
tm=paddata(tm,[ts+2*f ts+2*f],Side="both");
[rP,cP]=find(tm>0);

% core loop for evaluating locations > 0 in timer matrix (value equates to how
% many turns have lapsed since pebble dropped at this location) and drawing new ripples at
% these locations while also erasing old ripples
for i2=1:numel(rP)
    t=tm(rP(i2),cP(i2));
    newrip=t*ones(2*t+1);
    newrip(2:end-1,2:end-1)=0;
    o(rP(i2)-t:rP(i2)+t,cP(i2)-t:cP(i2)+t)=o(rP(i2)-t:rP(i2)+t,cP(i2)-t:cP(i2)+t)+newrip;
    oldrip=ones(2*t-1);
    o(rP(i2)-(t-1):rP(i2)+(t-1),cP(i2)-(t-1):cP(i2)+(t-1))=o(rP(i2)-(t-1):rP(i2)+(t-1),cP(i2)-(t-1):cP(i2)+(t-1))-oldrip;
    tm(rP(i2),cP(i2))=t+1;
end

% trim overflow padding so output and timer both back to ts
c=size(o)/2;
o=o(1+c-ts/2:c+ts/2,1+c-ts/2:c+ts/2);
tm=tm(1+c-ts/2:c+ts/2,1+c-ts/2:c+ts/2);
%end

matrix=o;
timer=tm;
im=uint16(o);
cmp=colormap(turbo(1+max(max(im))));
im=ind2rgb(im,cmp);
%imshow(im)
end