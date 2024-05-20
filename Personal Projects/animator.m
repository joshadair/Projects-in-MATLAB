function animator(frames,filename)
v=VideoWriter(filename);
v.Quality=100;
v.FrameRate=2;
open(v)

for i1=1:length(frames)
    active=frames(:,:,i1);
    b=bar3(active);
    colormap(turbo(10));
    set(gca,'ZLim',[0 10]);

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

    c=colorbar;
    c.Ticks=0:10;
    clim([0 10]);
    exportgraphics(gca,'temp.png');
    im=imread('temp.png');
    im=imresize(im,[560 730]);
    writeVideo(v,im);
end
close(v)
end