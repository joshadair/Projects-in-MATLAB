function [im,matrix,timer]=drawframe_rips2(f,in_matrix,in_timer)
% uses bullseye pattern for ripples

if f==1
    ts=300;
    o=zeros(ts);
    tm=o;

    % use starting image (im) for pebble locations
    imr=[12 12 12 25 25 25 37 37 37 50 50 50 50 50 50 63 63 63 75 75 75 88 88 88];
    imc=[12 50 88 25 50 75 37 50 63 25 37 63 12 88 75 37 50 63 50 25 75 12 50 88];
    imr=imr*3;
    imc=imc*3;
    for i1=1:numel(imr)
        tm(imr(i1),imc(i1))=1;
    end
else
    tm=in_timer;
    o=in_matrix;
end

if f==1
    cmp=colormap(turbo(1+max(max(o))));
    matrix=o;
    timer=tm;
    im=uint16(o);
    im=ind2rgb(o,cmp);
    imshow(im)
    return
end

% pad output and timer with extra space for ripple overflow to be
% trimmed later
o=padarray(o,[2*f 2*f],0,'both');
tm=padarray(tm,[2*f 2*f],0,'both');
[rP,cP]=find(tm>0);

% core loop for evaluating locations > 0 in timer matrix (value equates to how
% many turns have lapsed since pebble dropped at this location) and drawing new ripples at
% these locations while also erasing old ripples
for i2=1:numel(rP)
    t=tm(rP(i2),cP(i2)); % timer value (t) at pebble drop location
    %if (4*t-3)>ts
    %    continue
    %end
    newRip=bullseyezeros2(t); % helper function creating bullesyed matrix with zero spacing where outer ring value is t
    s=4*t-3; % size (s) of newRip
    o(rP(i2)-floor(s/2):rP(i2)+floor(s/2),cP(i2)-floor(s/2):cP(i2)+floor(s/2))=o(rP(i2)-floor(s/2):rP(i2)+floor(s/2),cP(i2)-floor(s/2):cP(i2)+floor(s/2))+newRip;

    % for timer values > 1, also need to delete previous ripple(s)
    if t>1
        oldRip=bullseyezeros2(t-1);
        s=4*(t-1)-3;
        o(rP(i2)-floor(s/2):rP(i2)+floor(s/2),cP(i2)-floor(s/2):cP(i2)+floor(s/2))=o(rP(i2)-floor(s/2):rP(i2)+floor(s/2),cP(i2)-floor(s/2):cP(i2)+floor(s/2))-oldRip;
    end

    tm(rP(i2),cP(i2))=t+1;
end
o=o(2*f+1:end-2*f,2*f+1:end-2*f);
tm=tm(2*f+1:end-2*f,2*f+1:end-2*f);
% end
cmp=colormap(turbo(1+max(max(o))));
matrix=o;
timer=tm;
im=uint16(o);
%o=imresize(o,[1000 1000],'box');
%ind=o;
im=ind2rgb(o,cmp);
%imshow(im)
end

