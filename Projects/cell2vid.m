function video = cell2vid(cell,filename,framerate)
video = VideoWriter(filename,'MPEG-4');
video.FrameRate = framerate;
open(video);

for x=1:length(cell)
    writeVideo(video,cell{x});
end

close(video);
    