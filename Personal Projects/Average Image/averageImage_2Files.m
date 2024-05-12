function average = averageImage_2Files(file1,file2)
image1 = im2double(imread(file1));
image2 = im2double(imread(file2));
sizeArray = size(image1);
rows = sizeArray(1);
cols = sizeArray(2);
average = zeros(sizeArray);


for clr=1:3
    for r=1:rows
        for c=1:cols
            val1 = image1(r,c,clr);
            val2 = image2(r,c,clr);
            average(r,c,clr) = (val1+val2)/2;
        end
    end
end


