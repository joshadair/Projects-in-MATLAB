function average = averageImage_Cell(cell)
numImages = length(cell);
image_sizeArray = size(cell{1});
rows = image_sizeArray(1);
cols = image_sizeArray(2);
totals = zeros(image_sizeArray);

for x=1:numImages
    cell{x} = im2double(cell{x});
end

for clr=1:3
    for r=1:rows
        for c=1:cols
            for x=1:numImages   
                totals(r,c,clr) = totals(r,c,clr)+cell{x}(r,c,clr);
            end
        end
    end
end

average = totals/numImages;


