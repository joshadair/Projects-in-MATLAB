function contestAnimator() 
    animFilename = 'animation.mp4';
    v=VideoWriter(animFilename,'MPEG-4');
    v.Quality=100;
    v.FrameRate=6;
    open(v);
    matrix=[];
    timer=[];
    for frame = 1:200
        [~,img]=drawframe_fastsieve(frame);
        img=imresize(img,[1000 1000],'box');
        writeVideo(v,img);
    end
end