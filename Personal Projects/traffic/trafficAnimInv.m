function avg=trafficAnimInv(frames,gifSize,filename)
frames=frames+1; % add 1 to convert to index colormap range, i.e. cannot have value of 0 in indexed image, loses color difference of 0 to 1
frames=flip(frames,1);
cmap=colormap(turbo(max(max(max(frames)))));
frames=imresize(frames,[gifSize gifSize],'box');
nFrames=size(frames,3);
avg=zeros(gifSize,gifSize,3);

for i1=1:nFrames
    active=frames(:,:,i1);
    rgb=ind2rgb(active,cmap);
    inv=imcomplement(rgb);
    avg=avg+inv;
    [active,cmap]=rgb2ind(inv,3,'nodither');
    if i1==1
        imwrite(active,cmap,filename,"gif","LoopCount",Inf,"DelayTime",0.0333);
    else
        imwrite(active,cmap,filename,"gif","WriteMode","append","DelayTime",0.0333);
    end
end
avg=avg/nFrames;

end
