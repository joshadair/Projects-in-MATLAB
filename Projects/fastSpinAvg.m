function output = fastSpinAvg(fileName)
    image = imread(fileName); 
    image =  im2double(image);
    sizes = size(image);
    r =  sizes(1);
    c =  sizes(2);
    cell = {}; 
    index = linspace(1,90,5); 
    index = index(2:end-1);
    index(2)= [];
    
    for count = 1:5
    
    for d=index
        cell{end+1} = imrotate(image,d,'nearest','crop');
        cell{end+1} = imrotate(image,-d,'nearest','crop');
    end
    
    end
    

output = averageImage_Cell(cell);
cell={output,output,output,output,image};
output = averageImage_Cell(cell);
imwrite(output,'avgSpin.jpg');
    
end