function newVideoExport = pixelate_old(fileName, filetype, newPix)

if filetype == 'video'
    inputVid = VideoReader(fileName);
    numFrames = floor(inputVid.Duration)*inputVid.FrameRate;
    newVideoExport = VideoWriter('pixelVideo.avi','Motion JPEG AVI');
    open(newVideoExport);
    
    
    input = read(inputVid,1);
    input = im2double(input);
    sizeArray = size(input);
    r = sizeArray(1);
    c = sizeArray(2);
    rSteps = r/newPix;
    cSteps = c/newPix;
    newPix_options = flip(intersect(divisors(r),divisors(c)));
    newPix_options = cat(2,newPix_options,flip(newPix_options));
    newPix_num_options = length(newPix_options);
    

    for frame = 1:1:numFrames
        input = read(inputVid,frame);
        input = im2double(input);
        
        % Create video where new pixel grain decreases with video duration,
        % i.e. the video gets "clearer" as it progresses towards the end
        newPix = newPix_options(ceil((frame/numFrames)*newPix_num_options));
        
        rSteps = r/newPix;
        cSteps = c/newPix;

        %cmpOut = [];
        %cmpOut(:,:,1) = zeros(rSteps,cSteps);
        %cmpOut(:,:,2) = zeros(rSteps,cSteps);
        %cmpOut(:,:,3) = zeros(rSteps,cSteps);

        fullOut = [];
        fullOut(:,:,1) = zeros(r,c);
        fullOut(:,:,2) = zeros(r,c);
        fullOut(:,:,3) = zeros(r,c);


        for color=1:3
            activeRGB = input(:,:,color);
            for x=1:rSteps 
                for y=1:cSteps  
                    floatColor = 0;       
                    pixelCount = 0;
              
                    for n=1:newPix         
                        for m=1:newPix           
                            floatColor = floatColor + activeRGB(n+(x-1)*newPix,m+(y-1)*newPix);                                                                
                            pixelCount = pixelCount + 1;       
                        end                        
                    end         
                    
                    %cmpOut(x,y,color) = floatColor/pixelCount;
                            
                    for a=1:newPix            
                        for b=1:newPix                               
                            fullOut((x-1)*newPix+a,(y-1)*newPix+b,color) = floatColor/pixelCount;           
                        end                        
                    end 
                    
                end                            
            end          
        end
      
        %dithering, color quantizing
        %[fullOut,cmap] = rgb2ind(fullOut,2,'dither');
       % newFrame = im2frame(fullOut,cmap);
        
        %no dithering, color quantizing
        newFrame = im2frame(fullOut);
        
        writeVideo(newVideoExport,newFrame);

% Can incorporate a reduction of sample rate by skipping through frames in
% the import process (for x=1:#:numFrames) where # = 2, 3, ... for 1/2,
% 1/3, ... sample rates respectively, if this is used, then it's helpful to
% duplicate processed/pixelated images based on the sample rate to preserve
% number of frames, framerate, and duration in output video, this could be
% done by using a for loop to nest writeVideo and running it # times

end

close(newVideoExport);

elseif filetype == 'image'
    input = imread(fileName);
    input = im2double(input);
    sizeArray = size(input);
    r = sizeArray(1);
    c = sizeArray(2);

    divr = divisors(r);
    divc= divisors(c);
    cmndiv = intersect(divr,divc);

    rSteps = r/newPix;
    cSteps = c/newPix;
    
    cmpOut = [];
    cmpOut(:,:,1) = zeros(rSteps,cSteps);
    cmpOut(:,:,2) = zeros(rSteps,cSteps);
    cmpOut(:,:,3) = zeros(rSteps,cSteps);
    
    fullOut = [];
    fullOut(:,:,1) = zeros(r,c);
    fullOut(:,:,2) = zeros(r,c);
    fullOut(:,:,3) = zeros(r,c);

    for color=1:3
        activeRGB=input(:,:,color);

        for x=1:rSteps
            for y=1:cSteps
                floatColor = 0;
                pixelCount = 0;              
                for n=1:newPix
                    for m=1:newPix   
                        floatColor = floatColor + activeRGB(n+(x-1)*newPix,m+(y-1)*newPix);  
                        pixelCount = pixelCount + 1;      
                    end               
                end
                
                cmpOut(x,y,color) = uint8(floatColor/pixelCount);
       
                for a=1:newPix        
                    for b=1:newPix                                                     
                        fullOut((x-1)*newPix+a,(y-1)*newPix+b,color) = floatColor/pixelCount;          
                    end                  
                end                               
            end                       
        end        
    end
    
    newVideoExport = fullOut;

end

end