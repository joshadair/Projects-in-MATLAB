function contestAnimator(frames)
animFilename = 'animation.mp4';
v=VideoWriter(animFilename,'MPEG-4');
v.Quality=100;
v.FrameRate=2;
open(v);
for i1=1:length(frames)
    b=bar3(frames(:,:,i1));
    set(gca,'ZLim',[0 10]);
    for k=1:length(b)
        zdata=b(k).ZData;
        b(k).CData=zdata;
        b(k).FaceColor='interp';
    end
    colorbar
    set(colorbar,'Ticks',0:10)
    exportgraphics(gca,'temp.png');
    im=imread('temp.png');
    im=imresize(im,[608 560]);
    writeVideo(v,im);
end
end