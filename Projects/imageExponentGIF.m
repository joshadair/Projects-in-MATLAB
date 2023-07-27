function [cell, altcell, recurs_cell] = imageExponentGIF(fileName,factor,stepSize)
image = imread(fileName);
image = im2double(image);
expimage = exp(image);
recurs_expimage = image;
onesImage = ones(size(image));

cell={};
altcell={};
recurs_cell={};

for x=1:stepSize:factor
% temp = expimage + exp(2*(x/100)*pi*ones(size(image)));
% Need to return to this where there are different forms of e^[matrix] as
% follows ... e^A*[matrix], e^[A]*[matrix], A*e^[matrix], [A]*e^[matrix]

% expimage = exp(image)+((2*pi)*x/factor)*exp(image);
temp_expimage = ((2*pi)*x/factor)*expimage;
cell{end+1} = temp_expimage - floor(temp_expimage);

altcell{end+1} = onesImage - (temp_expimage - floor(temp_expimage));


temp_expimagerecurs = exp(recurs_expimage);
recurs_expimage=temp_expimagerecurs - floor(temp_expimagerecurs);
recurs_cell{end+1} = recurs_expimage;
% may experiment with ceil(new_vale) - new_value to get range [0,1] but
% results should be different color "spectrum"

end


for x=factor:-1*stepSize:1
% temp = expimage + exp(2*(x/100)*pi*ones(size(image)));
% expimage = exp(image)+((2*pi)*x/factor)*exp(image);
temp_expimage = ((2*pi)*x/factor)*expimage;
cell{end+1} = temp_expimage - floor(temp_expimage);

altcell{end+1} = onesImage - (temp_expimage - floor(temp_expimage));

temp_expimagerecurs = exp(recurs_expimage);
recurs_expimage=temp_expimagerecurs - floor(temp_expimagerecurs);
recurs_cell{end+1} = recurs_expimage;
end



end


