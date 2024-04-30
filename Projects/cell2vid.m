function video=cell2vid(frames,filename,seconds)
video=VideoWriter(filename,'MPEG-4');
framerate=floor(numel(frames)/seconds);
video.FrameRate=framerate;
open(video);
colors=10;

for i1=1:numel(frames)
    % Need to update to accomodate for different types of images in frames
    % i.e. indexed, RGB, binary/BW, double/single/uint8 etc.
    %frame=uint16(frames{i1});
    %cmp=colormap(slanCM('turbo',max(max(frame))+1));
    %if mod(i1,2)==0
    %    cmp=flip(cmp);
    %end
    %frame=ind2rgb(frame,cmp);
    %frame=imbinarize(frame);
    %frame=ind2rgb(frames{i1},turbo(colors));
    %frame=imresize(frame,[1000 1000],'box');
    writeVideo(video,frames{i1});
end

close(video);
    