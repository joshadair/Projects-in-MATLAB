function avg=pudAnim(frames,gifSize,filename)
avg=zeros(gifSize,gifSize,3);
frames=frames+1;
frames=imresize(frames,[gifSize gifSize],'box');
frames=double(frames);
%cmap=colormap(turbo(max(max(max(frames)))));

for i1=1:size(frames,3)
    active=frames(:,:,i1);
    cmap=colormap(turbo(max(max(active))));
    rgb=ind2rgb(active,cmap);
    rgb=imcomplement(rgb);
    [active,cmap]=rgb2ind(rgb,256,"nodither");
    avg=avg+rgb;

    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",0.05);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.05);
    end
end
avg=avg/size(frames,3);
imshow(avg)
end