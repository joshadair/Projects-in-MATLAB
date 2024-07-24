function average = averageImage_fromVideo(fileName)

inputVid = VideoReader(fileName);
numFrames = floor(inputVid.Duration)*inputVid.FrameRate;
firstFrame = read(inputVid,1);
image_sizeArray = size(firstFrame);
rows = image_sizeArray(1);
cols = image_sizeArray(2);
totals = zeros(image_sizeArray);

%convert video to cell of images
cell={};
for x=1:numFrames/2
    cell{x} = im2double(read(inputVid,x));
end



for clr=1:3
    for r=1:rows
        for c=1:cols
            for x=1:1:numFrames/2
                % Potentially useful to increase step count to reduce
                % number of frames used in the average, this can help to
                % give more prominence to "temporary" objects over static
                % backgrounds
                totals(r,c,clr) = totals(r,c,clr)+cell{x}(r,c,clr);
            end
        end
    end
end

average = totals/floor(numFrames/2);


