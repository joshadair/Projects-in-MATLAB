function video = videoFrom_Cell(cell,fileName,frameRate)
video = VideoWriter(fileName,'MPEG-4');
video.FrameRate = frameRate;
open(video);

for x=1:length(cell)
    writeVideo(video,cell{x});
end

close(video);
    