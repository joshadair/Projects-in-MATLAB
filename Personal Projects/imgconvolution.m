function output = imgconvolution(input_object,kernel);

if isa(input_object,'numeric') == 1
    input_temp = input_object;
    input_object = {};
    input_object{end+1} = input_temp;
elseif exist(input_object) == 2
    input_object = imgvid2cell(input_object); 
end

switch kernel
    case isa(kernel,'numerical')
        kernel = kernel;
    case 'unsharp'
        kernel = (-1/256)*[1 4 6 4 1; 4 16 24 16 4;6 24 -476 24 6; 4 16 24 16 4;1 4 6 4 1];
    case 'gaussblur5'
        kernel = (1/256)*[1 4 6 4 1;4 16 24 16 4;6 24 36 24 6; 4 16 24 16 4;1 4 6 4 1];
    case 'sharpen'
        kernel = [0 -1 0; -1 5 -1; 0 -1 0];
    case 'edge'
        kernel = [0 -1 0; -1 4 -1;0 -1 0];
    case 'boxblur'
        kernel = (1/9)*[1 1 1; 1 1 1; 1 1 1];
    case 'gaussblur3'
        kernel = (1/16)*[1 2 1; 2 4 2; 1 2 1];
end

input_image = input_object{1};
input_image = im2double(input_image);
[rows,cols,colors] = size(input_image);
output = zeros(size(input_image));
[krows,kcols] = size(kernel);
extend_image = input_image;
k_sizefactor = (krows-1)/2;

% Duplicate pixels rows/cols borders and corners to create extra pixels for edge handling
% according to the extend methodology
for count=1:k_sizefactor
extend_image = cat(1,extend_image(1,1:cols,:),extend_image);
extend_image = cat(1,extend_image,extend_image(end,1:cols,:));
extend_image = cat(2,extend_image(1:rows+2,1,:),extend_image);
extend_image = cat(2,extend_image,extend_image(1:rows+2,end,:));

[rows,cols,colors] = size(extend_image);
end


for clr=1:colors
    activeRGB = extend_image(:,:,clr);
    for r=1+k_sizefactor:rows-k_sizefactor    
        for c=1+k_sizefactor:cols-k_sizefactor
            active_imgmatrix = activeRGB(r-k_sizefactor:r+k_sizefactor,c-k_sizefactor:c+k_sizefactor);
            output(r-k_sizefactor,c-k_sizefactor,clr) = convolution(kernel,active_imgmatrix);
        end
    end
end

end



   
    
        

