function [rgb,ind]=drawframe_rips(f)
% set tablesize nxn (ts), number of pebbles (p), output frame (o), and timer
% matrix (tm)
ts=50;
p=5;
o=zeros(ts);
tm=o;

%{
% basic starting condition of one pebble at center of table
o(50,50)=2;
tm(50,50)=1;
%}

% randomize locations for initial pebbles (lcP)
rng(36);
lcP=randperm(ts^2,p);
o(lcP)=2;
tm(lcP)=1;

%{
% use starting image (im) instead of random pebble locations
imr=[12 12 12 25 25 25 37 37 37 50 50 50 50 50 50 63 63 63 75 75 75 88 88 88];
imc=[12 50 88 25 50 75 37 50 63 25 37 63 12 88 75 37 50 63 50 25 75 12 50 88];
%imr=[33 33 66];
%imc=[30 70 50];
sz=[100 100];
for i1=1:numel(imr)
o(sub2ind(sz,imr(i1),imc(i1)))=2;
tm(sub2ind(sz,imr(i1),imc(i1)))=1;
end
%}

%{
% reverse loop
if f>24
   f=25-(f-24);
end
%}

% sf (scale factor) is a multiplier allowing for deeper iterations at the
% cost of animation resolution (skip frames), due to limitation of f=1:48 (48 frames
% per animation)
sf=1;
for i1=1:sf*f
    if f==1
        break;
    end

    %{
    % add random pebble every nth iteration
    n=50;
    if mod(i1,n)==0
        nP=randi(ts^2,1);
        if tm(nP)==0
            o(nP)=2;
            tm(nP)=1;
        end
    end
    %}

    % pad output and timer with extra space for ripple overflow to be
    % trimmed later
    %o=padarray(o,[2*f 2*f],0,'both');
    %tm=padarray(tm,[2*f 2*f],0,'both');
    o=paddata(o,[ts+2*sf*f ts+2*sf*f],Side="both");
    tm=paddata(tm,[ts+2*sf*f ts+2*sf*f],Side="both");
    [rP,cP]=find(tm>0);

    for i2=1:numel(rP)
        t=tm(rP(i2),cP(i2));
        %newrip=t*ones(2*t+1);
        newrip=ones(2*t+1);
        newrip(2:end-1,2:end-1)=0;
        o(rP(i2)-t:rP(i2)+t,cP(i2)-t:cP(i2)+t)=o(rP(i2)-t:rP(i2)+t,cP(i2)-t:cP(i2)+t)+newrip;
        
        oldrip=ones(2*t-1);
        %oldrip=(t-1)*ones(2*t-1);
        if t==1
            o(rP(i2),cP(i2))=o(rP(i2),cP(i2))-2;
        elseif t>1
            oldrip(2:end-1,2:end-1)=0;
            o(rP(i2)-(t-1):rP(i2)+(t-1),cP(i2)-(t-1):cP(i2)+(t-1))=o(rP(i2)-(t-1):rP(i2)+(t-1),cP(i2)-(t-1):cP(i2)+(t-1))-oldrip;
        end

        tm(rP(i2),cP(i2))=t+1;
    end

    % trim overflow padding so output and timer both back to ts
    m=(size(o,2)-ts)/2;
    o=o(m+1:(end-m),m+1:(end-m));
    tm=tm(m+1:(end-m),m+1:(end-m));
end

cmp=colormap(turbo(1+max(max(o))));
o=uint16(o);
ind=o;
%rgb=imresize(o,[1000 1000],'box');
%rgb=ind2rgb(rgb,cmp);
%imshow(rgb)
b=bar3(ind);

for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end


end

