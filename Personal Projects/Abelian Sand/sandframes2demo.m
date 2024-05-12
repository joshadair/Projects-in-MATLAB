function sandframes2demo(frames,edgeCondition,filename,duration)
[row,col]=size(frames(:,:,end));
video=VideoWriter(filename,'MPEG-4');
framerate=floor(length(frames)/duration);
video.FrameRate=framerate;
open(video);

if strcmp(edgeCondition,'grow')==1
    frames=normalizesandsize(frames);

    for i1=1:length(frames)
        temp=ind2rgb(frames{i1},cmap);
        temp=imresize(temp,[1080 1080],'box');
        writeVideo(video,temp);
    end
end

if strcmp(edgeCondition,'falloff')==1
    for i1=1:ceil(length(frames)*.07)
        frames=cat(3,frames(:,:,1),frames);
        frames=cat(3,frames,frames(:,:,end));
    end

    for i1=1:length(frames)
        temp=num2str(frames(:,:,i1));
        img=text2im(temp);
        img=double(img);
        writeVideo(video,img);
    end
end

end
