function output = imageHueDensityFilter(fileName)
image = imread(fileName);
image = double(image);
[rows,cols,colors] = size(image);

red = image(:,:,1);
green = image(:,:,2);
blue = image(:,:,3);

output = zeros(rows,cols,3);

for clr=1:3
    activeColor = image(:,:,clr);
    histColor = histcounts(activeColor,256);
    probColor = histColor/(rows*cols);
    normalclrhist = probColor/max(probColor);
    for r=1:rows
        for c=1:cols
            currentPixelColorValue = activeColor(r,c);
            
            if currentPixelColorValue == 0
                intensityProbValue = max(normalclrhist);
                output(r,c,clr) = 0;
            else
                intensityProbValue = normalclrhist(1,currentPixelColorValue);
                output(r,c,clr) = intensityProbValue;
            end    
        end
    end
end

output = im2uint8(output);

end



            
        