function avg=trafficMask(frames,alphaFrames,filename)
% creates GIF from frames of current figure
nFrames=size(alphaFrames,3);
row=size(image,1);
col=size(image,2);
avg=zeros(row,col,3);
alphaFrames=imresize(alphaFrames,[row col],'box');

for i1=1:nFrames
    active=frames(:,:,i1);
    cmap=colormap(turbo(max(max(active))));
    imshow(active,cmap)
    %set(gcf,'color','black')
    alpha(alphaFrames(:,:,i1))
    if i1==1
        temp=getframe(gcf);
        temp=frame2im(temp);
        [temp,map]=rgb2ind(temp,256);
        imwrite(temp,map,filename,"gif","LoopCount",Inf,"DelayTime",0.0167);
    else
        temp=getframe(gcf);
        temp=frame2im(temp);
        [temp,map]=rgb2ind(temp,256);
        imwrite(temp,map,filename,"gif","WriteMode","append","DelayTime",0.0167);
    end

%{
    exportgraphics(gca,'temp.png');
    im=imread('temp.png');
    im=imresize(im,[560 730]);
    writeVideo(v,im);
%}

end
%close(v)
end
