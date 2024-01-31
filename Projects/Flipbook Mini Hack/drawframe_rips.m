function [im,matrix,timer]=drawframe_rips(f,in_matrix,in_timer)
% uses wire ripples

ts=300;

if f==1
    o=zeros(ts);
    tm=o;
else
    o=in_matrix;
    tm=in_timer;
end


%{

% use starting image (im) for pebble locations
imr=[12 12 12 25 25 25 37 37 37 50 50 50 50 50 50 63 63 63 75 75 75 88 88 88];
imc=[12 50 88 25 50 75 37 50 63 25 37 63 12 88 75 37 50 63 50 25 75 12 50 88];
imr=imr*5;
imc=imc*5;
for i1=1:numel(imr)
tm(imr(i1),imc(i1))=1;
end
%}

% loop to iterate through previous frames (1 -> f-1) to generate current frame (f)
if f==1
    o=tm;
    matrix=o;
    timer=tm;
    im=uint16(o);
    cmp=colormap(turbo(1+max(max(im))));
    im=ind2rgb(im,cmp);
    imshow(im)
    return
end

% add random pebble every nth iteration
n=2;
if mod(f,n)==0
    nP=randi(ts^2);
    if tm(nP)==0
        tm(nP)=1;
    end
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

    newrip=ones(2*t+1);
    newrip(2:end-1,2:end-1)=0;
    o(rP(i2)-t:rP(i2)+t,cP(i2)-t:cP(i2)+t)=o(rP(i2)-t:rP(i2)+t,cP(i2)-t:cP(i2)+t)+newrip;

    oldrip=ones(2*t-1);
    oldrip(2:end-1,2:end-1)=0;
    o(rP(i2)-(t-1):rP(i2)+(t-1),cP(i2)-(t-1):cP(i2)+(t-1))=o(rP(i2)-(t-1):rP(i2)+(t-1),cP(i2)-(t-1):cP(i2)+(t-1))-oldrip;

    tm(rP(i2),cP(i2))=t+1;
end

% trim overflow padding so output and timer both back to ts
c=size(o)/2;
o=o(c-ts/2:c+ts/2,c-ts/2:c+ts/2);
tm=tm(c-ts/2:c+ts/2,c-ts/2:c+ts/2);


matrix=o;
timer=tm;

cmp=colormap(turbo(max(max(o))));
im=uint16(o);
im=ind2rgb(im,cmp);
%imshow(im)
end