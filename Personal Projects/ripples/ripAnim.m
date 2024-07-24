function ripAnim(frames,gifSize,filename)
frames=frames+1;
frames=imresize(frames,[gifSize gifSize]);

for i1=1:size(frames,3)
    active=frames(:,:,i1);
    cmap=colormap(turbo(max(max(max(active)))));
    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",0.0333);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.0333);
    end

end

end