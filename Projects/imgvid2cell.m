function cell = imgvid2cell(filename)
cell={};

try
    input_image = imread(filename);
    cell{end+1} = input_image;
catch
    input_video = VideoReader(filename);
    num_frames = floor(input_video.Duration)*input_video.FrameRate;
    
    for x=1:num_frames
        cell{end+1} = read(input_video,x);
    end
end

end