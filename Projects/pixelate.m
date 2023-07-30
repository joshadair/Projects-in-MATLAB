function [compressed,fullsize] = pixelate(filename)

if exist(filename) == 2
    image = imread(filename);  
elseif isa(filename,&&exist(filename) == 1
    


image = im2double(image);
[rows,cols,colors] = size(image);  
div_rows = divisors(rows);    
div_cols= divisors(cols);   
div_shared = intersect(div_rows,div_cols);
div_shared_text = regexprep(num2str(div_shared),' +',' ');
prompt = cat(2,'Grain size options: ',div_shared_text);
new_pixelGrain = input(prompt)

rSteps = rows/new_pixelGrain;
cSteps = cols/new_pixelGrain;
    
compressed = [];    
compressed(:,:,1) = zeros(rSteps,cSteps);
compressed(:,:,2) = zeros(rSteps,cSteps);    
compressed(:,:,3) = zeros(rSteps,cSteps);
fullsize = [];
fullsize(:,:,1) = zeros(rows,cols);
fullsize(:,:,2) = zeros(rows,cols);
fullsize(:,:,3) = zeros(rows,cols);
   
for color=1:3     
    activeRGB=image(:,:,color);
        
    for x=1:rSteps          
        for y=1:cSteps               
            floatColor = 0;               
            pixelCount = new_pixelGrain^2; 
            
            for n=1:new_pixelGrain  
                for m=1:new_pixelGrain      
                    floatColor = floatColor + activeRGB(n+(x-1)*new_pixelGrain,m+(y-1)*new_pixelGrain);                    
                end                
            end
            
            new_pixelColor = floatColor/pixelCount;
            compressed(x,y,color) = new_pixelColor;       
                
            for a=1:new_pixelGrain        
                for b=1:new_pixelGrain                                                     
                    fullsize((x-1)*new_pixelGrain+a,(y-1)*new_pixelGrain+b,color) = new_pixelColor;                            
                end   
            end           
        end    
    end    
end

end
