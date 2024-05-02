function output = imageHueDensityFilter(input_object)

if isa(input_object,'numeric') == 1
    input_temp = input_object;
    input_object = {};
    input_object{end+1} = input_temp;
elseif exist(input_object) == 2
    input_object = imgvid2cell(input_object); 
end

input_image = input_object{1};
input_image = double(input_image);
[rows,cols,colors] = size(input_image);

output = zeros(rows,cols,colors);

for clr=1:colors
    activecolor = input_image(:,:,clr);
    pixelcolor_counts = histcounts(activecolor,256);
    probcolor = pixelcolor_counts/(rows*cols);
    normalized_probcolor = probcolor/max(probcolor);
    for r=1:rows
        for c=1:cols               
            output(r,c,clr) = normalized_probcolor(1,activecolor(r,c)+1);
            %if currentPixelColorValue == 0
             %   output(r,c,clr) = 0;
           % else
                
            
        end  
    end  
end

output = im2uint8(output);

end





            
        