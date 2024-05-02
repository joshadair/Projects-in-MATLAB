function cell = imageHueDensityFilterIterate(fileName,iterations)
image = imread(fileName);
output = image;
cell={};

for i=1:iterations
    %output = output;
    output = imageHueDensityFilter(output);
    cell{end+1} = output;
end

end




            
        