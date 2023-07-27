function cell = imageRotateGIF(fileName,degrees)
cell = {};
image = imread(fileName);
index = linspace(1,degrees,degrees/5);
index = index(2:end);


for times = 1:5

for d=index
a = imrotate(image,d,'bicubic','crop');
b = imrotate(image,-d,'bicubic','crop');
a = imfuse(a,b,'blend');

for frames = 1:15
cell{end+1} = image;
cell{end+1} = a;
end

end

for d=flip(index)
a = imrotate(image,d,'bicubic','crop');
b = imrotate(image,-d,'bicubic','crop');
a = imfuse(a,b,'blend');

for frames = 1:15
cell{end+1} = image;
cell{end+1} = a;
end

end

end

end




    