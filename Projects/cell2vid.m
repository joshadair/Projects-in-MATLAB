function video=cell2vid(frames,filename,seconds)
video=VideoWriter(filename,'MPEG-4');
framerate=floor(numel(frames)/seconds);
video.FrameRate=framerate;
open(video);

for i1=1:numel(frames)
    writeVideo(video,frames{i1});
end

close(video);
    