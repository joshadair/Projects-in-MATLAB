function contestAnimator() 
    animFilename = 'animation.mp4'; % Output file name
    firstFrame = true;
    framesPerSecond = 24;
    delayTime = 1/framesPerSecond;
    % Create the gif
    matrix=[];
    timer=[];
    v=VideoWriter(animFilename,'MPEG-4');
    v.Quality=100;
    open(v);
    for frame = 1:48*20
        [im,matrix,timer]=drawframe_rips3(frame,matrix,timer);
        %fig = gcf(); 
        %fig.Units = 'pixels';
        %fig.Position(3:4) = [1000,1000];
        %im = getframe(fig);
        %[A,map] = rgb2ind(im.cdata,256);

        writeVideo(v,im);

        %{
        if firstFrame
            firstFrame = false;
            %imwrite(A,map,animFilename, LoopCount=Inf, DelayTime=delayTime);
            imwrite(im,animFilename, LoopCount=Inf, DelayTime=delayTime);
        else
            %imwrite(A,map,animFilename, WriteMode="append", DelayTime=delayTime);
            imwrite(im,animFilename, WriteMode="append", DelayTime=delayTime);
        end
        %}

    end
end