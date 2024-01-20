function drawframe_rips(f)
% set tablesize nxn (ts), output image (o), timer matrix (tm), and seed
% random number generator (rng) so randomized pebbles remain in consistent
% locations as each frame is generated
ts=500;
o=zeros(ts);
tm=o;
rng(9);

% use starting image (im) for pebble locations
imr=[12 12 12 25 25 25 37 37 37 50 50 50 50 50 50 63 63 63 75 75 75 88 88 88];
imc=[12 50 88 25 50 75 37 50 63 25 37 63 12 88 75 37 50 63 50 25 75 12 50 88];
imr=imr*5;
imc=imc*5;
for i1=1:numel(imr)
tm(imr(i1),imc(i1))=1;
end

% sf (scale factor) is a multiplier allowing for deeper iterations at the cost of animation 
% resolution (skips frames), due to limitation of f=1:48 (48 frame per animation)
sf=1;

% loop to iterate through previous frames (1 -> f-1) to generate current frame (f)
for i1=1:sf*f
    if f==1
        break;
    end
    
    % pad output and timer with extra space for ripple overflow to be trimmed later
    o=paddata(o,[ts+2*sf*f ts+2*sf*f],Side="both");
    tm=paddata(tm,[ts+2*sf*f ts+2*sf*f],Side="both");
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
    o=o(c-ts/2:c+ts/2,c-ts/2:c+ts/2);
    tm=tm(c-ts/2:c+ts/2,c-ts/2:c+ts/2);
end

o=uint16(o);
cmp=colormap(turbo(1+max(max(o))));
o=ind2rgb(o,cmp);
imshow(o)
end