function contestAnimator() 
    animFilename = 'animation.mp4';
    v=VideoWriter(animFilename,'MPEG-4');
    v.Quality=100;
    v.FrameRate=24;
    open(v);
    matrix=[];
    timer=[];
    for frame = 1:48*4
        [im,matrix,timer]=drawframe_rips(frame,matrix,timer);
        im=imresize(im,[1000 1000],'box');
        writeVideo(v,im);
    end
end