function output = fastSpinAvg(fileName)
    image = imread(fileName); 
    image =  im2double(image);
    cell = {}; 
    index = linspace(10,45,35); 

  %  for count = 1:5
    
    for theta=index       
        rotated_image = imrotate(image,theta,'nearest','crop');  
        for count = 1:floor(1+theta/3)      
            cell{end+1} = rotated_image;      
            %cell{end+1} = imrotate(image,-theta,'nearest','crop');
        end
    end
    
   % end
    

averagerotates = averageImage_Cell(cell);
output = averageImage_Cell({image,averagerotates,averagerotates});
%cell={output,output,output,output,image};
%output = averageImage_Cell(cell);
%imwrite(output,'avgSpin.jpg');
    
end