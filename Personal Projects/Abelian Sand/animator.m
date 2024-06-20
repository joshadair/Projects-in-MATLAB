function animator(frames,filename)
% creates GIF of 3D bar graph visual of sandpiles

%{
v=VideoWriter(filename);
v.Quality=100;
v.FrameRate=2;
open(v)
%}
nFrames=size(frames,3);
maxFrames=max(max(max(frames)));
cmap=turbo(1+maxFrames);

for i1=1:nFrames
    active=frames(:,:,i1);
    b=bar3(active);  
    colormap(cmap);
    set(gca,'ZLim',[0 maxFrames]);
    c=colorbar;
    c.Ticks=0:maxFrames;
    clim([0 maxFrames]);
    %{
    for k=1:length(b)
        zdata=b(k).ZData;
        b(k).CData=zdata;
        b(k).FaceColor='interp';
    end
    %}

    numBars=size(active,1);
    numSets=size(active,2);
    for i2=1:numSets
        zdata=ones(6*numBars,4);
        k=1;
        for j=0:6:(6*numBars-6)
            zdata(j+1:j+6,:)=active(k,i2);
            k=k+1;
        end
        set(b(i2),'Cdata',zdata)
    end

    if i1==1
        temp=getframe(gcf);
        temp=frame2im(temp);
        [temp,map]=rgb2ind(temp,256);
        imwrite(temp,map,filename,"gif","LoopCount",Inf,"DelayTime",0.5);
    else
        temp=getframe(gcf);
        temp=frame2im(temp);
        [temp,map]=rgb2ind(temp,256);
        imwrite(temp,map,filename,"gif","WriteMode","append","DelayTime",0.5);
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