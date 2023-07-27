function [average,fileNames] = averageImage_Folder(folderName)

imageFiles = dir(folderName);
fileName = '';
fileNames = '';
cell = {};


for f=3:length(imageFiles)
    fileName = imageFiles(f).name;
    fileNames = cat(1,fileNames,fileName);   
    cell{end+1} = imread(fullfile(folderName,fileName));
end

average = averageImage_Cell(cell);
imwrite(average,'average.png','png');