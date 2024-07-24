function cell = fastSpin(fileName)
    image = imread(fileName); 
    sizes = size(image);
    r =  sizes(1);
    c =  sizes(2);
    cell = {}; 
    index = linspace(1,60,360); 
    
    for d=index
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
    end
    
    for d=flip(index)
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
    end
    
    for d=index
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
    end
    
    for d=flip(index)
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = image;
    end
    
    
    output = VideoWriter('effectVid.avi', 'Motion JPEG AVI');
    output.FrameRate = 8;
    output.Quality = 25;
    open(output);
    
    for x=1:length(cell)
        writeVideo(output,cell{x});
    end
    
    close(output); 
    
end
        
    
    
    
        
        