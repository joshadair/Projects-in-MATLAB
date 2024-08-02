function a=ripAnim(frames,gifSize,filename)
a=zeros(gifSize,gifSize,3);
frames=frames+1;
frames=imresize(frames,[gifSize gifSize],'box');
%cmap=colormap(turbo(max(max(max(frames)))));

for i1=1:size(frames,3)
    active=uint8(frames(:,:,i1));
    cmap=colormap(turbo(max(max(max(active)))));
    rgb=ind2rgb(active,cmap);
    a=rgb+a;

    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",0.05);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.05);
    end
end
a=a/size(frames,3);
end